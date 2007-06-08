/*
   ----------------
   prc_inc_spells
   ----------------

   7/25/04 by WodahsEht

   Contains many useful functions for determining caster level, mostly.  The goal
   is to consolidate all caster level functions to this -- existing caster level
   functions will be wrapped around the main function.

   In the future, all new PrC's that add to caster levels should be added to
   the GetArcanePRCLevels and GetDivinePRCLevels functions.  Very little else should
   be necessary, except when new casting feats are created.
*/


// -----------------
// BEGIN ONHITCAST
// -----------------

/**
// new functions for a highly flexible onhitcast system
// added by motu99; April 15, 2007

// most of this has been tested; some is still beta

// in principle these functions should allow us to put any conceivable spell (and as many as we like) on an item
// the spell(s) will be cast automatically, when the bearer of the item has scored a hit (item = weapon) or has received a hit (item= armor)
// furthermore these functions will enable us to instantly cast *any* type of spell listed in spells.2da (e.g. we are not limited to "onhit" spells).
// With the new function CastSpellAtObject() the spell will be cast instantly, without having to insert it into the action queue
// (and thus not knowing when it will be done, if ever).
*/

/**
Making your spells compatible with PRC instant spell casting
using the provided function CastSpellAtObject()

1) insert PRC wrappers into the spell script
edit your spell script, replacing all
calls to the spell information functions
- GetSpellCastItem,
- GetSpellTargetObject,
- etc.
with the respective PRC wrappers
(just add "PRC" to the left of the function name)

Nothing else needs to be done
*/

/**
// Making your onhitcast spells compatible with PRC onhitcast:

1) insert PRC wrappers into the impact spell script
edit your spell script, replacing all
calls to the spell information functions
- GetSpellCastItem,
- GetSpellTargetObject,
- etc.
with the respective PRC wrappers
(just add "PRC" to the left of the function name)

2) route the impact script through prc_onhitcast
[only for onhitcast spells! Not for "normal" spells!]

In order to circumvent the bioware bug, according to
which only the first onhitcast spell on an item is executed,
we must route all onhitcast spells through prc_onhitcast.

This is done very conveniently by placing the following code
into the body of the main function of your onhitcast impact spell script:

	if(OnHitCastRouteToUniquePower()) return;

Put this at the very beginning of the main()

See "x2_s3_flamingd" for an example

3) edit 2das
[if your spell is operational, you probably have done this before]
register your spell script in the appropriate 2das:
- spells.2da
- iprp_onhitspell.2da

4) find a way to place your onhitcast spells on the item (armor or weapon)
[if your spell is operational you might have done this before]
usually done by a "normal" spell. For instance the "Flame Weapon"
spell will put a special onhitcast item property on the weapon. The integer
valued subtye of the item property defines what spell is to be called on a hit.
The appropriate impact spell script "x2_s3_flamingd" is related to the
integer valued subtype via "iprp_onhitspell.2da" and "spells.2da"

See "x2_s0_enhweap" for an example how to put an onhitcast spell
(as well as other item properties) on a weapon
*/



/**
// ExecuteSpellScript:

// instantly executes the spell script sScript via ExecuteScript in the context of oCaster (taking oCaster as the caster)
// does not perform any checks, whether oCaster can actually cast the spell at all (or at the given level and metamagic)
// will not call the spell hook PreSpellCastCode and does not perform any saving throws

// Remark motu99:
// no spellhook, no saves, no caster checks: This appears to be the general behavior of the onhitcast spells:
// As far as I could tell, the onhitcast spells on weapon and armor are never routed through the spellhook by the
// aurora engine (unless the spell script explicitly calls the hook), the target of the spell doesn't get a saving throw
// (unless the spell script explicitly provideds for that), and - of course - the caster (or rather the item possessor)
// must not necessarily have to ability to cast spells (a wizard can put "flame weapon" on a fighter's weapon) 

// ExecuteSpellScript sets local override ints/objects on oCaster just before execution
// (and deletes them immediately after execution),  so that the PRC-wrapper functions in the
// spell scripts can determine
//   - the target oTarget of the spell (accessed in the spell script via PRCGetSpellTargetObject),
//   - the metamagic feat of the spell nMetamagic (accessed in the spell script via PRCGetMetaMagicFeat)
//   - the casterlevel nCasterLevel (accessed in the spell script via PRCGetCasterLevel)
//   - the spell cast item oItem (accessed in the spell script via PRCGetSpellCastItem)

// if default values for the parameters oTarget, nMetaMagic, nCasterLevel and oItem are passed to ExecuteSpellScript,
// it does not set any overrides for the PRC-wrapper functions. In this case you have to rely on the standard logic in
// the wrapper functions (or on bioware's unreliable setup) to properly determine the correct values.
// The standard logic generally works fine for nCasterLevel, but might it not work as expected for oTarget, nMetaMagic
// and oItem - depending from where you call ExecuteSpellScript.
// If you call ExecuteSpellScript from within a spell script or a spell hook (so that the PRC - or Bioware's - initialization
// codes had a chance to set up things nicely) then the spell "information" functions PRCGetSpellTargetObject,
// PRCGetMetaMagicFeat etc. will most likely return sensible values.
// However, if you call ExecuteSpellScript outside of a spell script, nobody will have done any setup for you, so in this case
// you are strongly advised to setup things manually, e.g. determine oTarget, nMetaMagic, nCasterLevel, oItem on your own and
// pass them to ExecuteSpellScript without relying on the standard logic to do the guessing for you.

// In principle ExecuteSpellScript(), in combination with the PRC-wrappers, is the only thing you really need.
// To safely cycle through all onhitcast spells on an item one should use ApplyAllOnHitCastSpellsOnItemExcludingSubType()
// This function is used in prc_onhitcast. As prc_onhitcast hides all the dirty work from us,  most likely that function will
// never be needed outside of prc_onhitcast. 
// The other functions are provided as a convenience. They all eventually call ExecuteSpellScript
*/
void ExecuteSpellScript(string sScript, object oTarget = OBJECT_INVALID, int nMetaMagic = METAMAGIC_ANY, int nCasterLevel = 0, object oItem = OBJECT_INVALID, object oCaster = OBJECT_SELF);

/**
// CastSpellAtObject:

// Will instantly cast the spell with index iSpellNr at oTarget
// Will look up the ImpactScript to execute via spells.2da
// The spell is not inserted into the action queue of oCaster, no checks are performed whether oCaster can actually cast the spell!
// oTarget is the target of the spell, oItem (if required) is the item from which the spell is cast, oCaster (or OBJECT_SELF) is considered to be the caster

// so far this only works for spells cast on an object (oTarget). It is quite easy to write a similar function for AoE spells ( have to add a location)
// tested for flame weapon and darkfire impact spell scripts, but should eventually work for all spells (see below)

// in order to work, it requires the impact spell scripts to use the PRC-wrapper functions!!!
// Besides the established wrappers (PRCGetSpellTargetObject, PRCGetCasterLevel, PRCGetMetaMagicFeat, PRCGetSpellID etc.)
// we need a new PRC-wrapper function to replace SpellCastItem(). Not surprising the wrapper is named PRCGetSpellCastItem()
// It would be a good idea to check all spell scripts, whether all calls to Bioware's spell information functions
// have been replaced by the respective PRC wrapper functions. (So far, this is not done consistently!)

// if default values for oTarget, nMetaMagic, nCasterLevel and oItem are supplied, no override variables are set, so that the PRC-wrapper functions
// (or Bioware's functions) must determine the SpellTargetObject, the SpellCastItem etc. through their "standard" logic. This might or might not work.
// For more information see the description in ExecuteSpellScript()

*/
void CastSpellAtObject(int iSpellNr, object oTarget = OBJECT_INVALID, int nMetaMagic = METAMAGIC_ANY, int nCasterLevel = 0, object oItem = OBJECT_INVALID, object oCaster = OBJECT_SELF);


// instantly executes an AoE spell script, very similar to ExecuteSpellScript
// will not set an override location, if the parameter bBioLocation = TRUE
// in that case you will rely on Bioware's GetSpellTargetLocation to supply the correct location to the spell script
// this might work, if called from *within* a spell script, but it generally doesn't work when called from *outside*
// a spell script (which usually is the case for instant spells)
void ExecuteAoESpellScript(string sScript, location lTargetLocation, int bBioLocation = FALSE, int nMetaMagic = METAMAGIC_ANY, int nCasterLevel = 0, object oItem = OBJECT_INVALID, object oCaster = OBJECT_SELF);

// instantly casts an area of effect spell at location lTargetLocation
// works similar to ActionCastSpellAtLocation, only casts spell instantly (without saving throw etc.)
// See description of CastSpellAtObject, how instant spells work
void CastSpellAtLocation(int iSpellNr, location lTargetLocation, int nMetaMagic = METAMAGIC_ANY, int nCasterLevel = 0, object oItem = OBJECT_INVALID, object oCaster = OBJECT_SELF);

// applies to oTarget the onhitcast spell (situated on oItem) with subtype iSubType,  in the context of oCaster
// will look up the spell script that must be executed in "iprp_onhitspell.2da" and "spells.2da"
// if default values for oTarget, oItem are supplied, no override variables are set, so that the PRC-wrapper functions
// (or Bioware's functions) must determine the SpellTargetObject and the SpellCastItem
// for more information see the description in ExecuteSpellScript()
void ApplyOnHitCastSpellSubType(int iSubType, object oTarget = OBJECT_INVALID, object oItem = OBJECT_INVALID, object oCaster = OBJECT_SELF);

// applies to oTarget the onhitcast spell darkdire (situated on oItem), in the context of oCaster
// will look up the spell script that must be executed in "iprp_onhitspell.2da" and "spells.2da"
// if default values for oTarget, oItem are supplied, no override variables are set, so that the PRC-wrapper functions
// (or Bioware's functions) must determine the SpellTargetObject and the SpellCastItem
// for more information see the description in ExecuteSpellScript()
void ApplyOnHitDarkfire(object oTarget = OBJECT_INVALID, object oItem = OBJECT_INVALID, object oCaster = OBJECT_SELF);

// applies to oTarget the onhitcast spell flame weapon (situated on oItem), in the context of oCaster
// will look up the spell script that must be executed in "iprp_onhitspell.2da" and "spells.2da"
// if default values for oTarget, oItem are supplied, no override variables are set, so that the PRC-wrapper functions
// (or Bioware's functions) must determine the SpellTargetObject and the SpellCastItem
// for more information see the description in ExecuteSpellScript()
void ApplyOnHitFlameWeapon(object oTarget = OBJECT_INVALID, object oItem = OBJECT_INVALID, object oCaster = OBJECT_SELF);

// applies to oTarget the onhitcast spell unique power (situated on oItem), in the context of oCaster
// actually this will call prc_onhitcast (hardcoded), e.g. it will not look up the 2das (as the above functions do)
// if default values for oTarget, oItem are supplied, no override variables are set, so that the PRC-wrapper functions
// (or Bioware's functions) must determine the SpellTargetObject and the SpellCastItem
// for more information see the description in ExecuteSpellScript()
void ApplyOnHitUniquePower(object oTarget = OBJECT_INVALID, object oItem = OBJECT_INVALID, object oCaster = OBJECT_SELF);

// applies all on hit cast spells on oItem to oTarget in the context of oCaster
// will look up the spell script that must be executed in "iprp_onhitspell.2da" and "spells.2da"
// This is a safe way to do this, without interfering with any other loops over item properties in the spell scripts
// Always use this function to cycle through and execute the onhitcast spells on an item!!
// if default values for oTarget, oItem are supplied, no override variables are set, so that the PRC-wrapper functions
// (or Bioware's functions) must determine the SpellTargetObject and the SpellCastItem
// for more information see the description in ExecuteSpellScript()
void ApplyAllOnHitCastSpellsOnItem(object oTarget = OBJECT_INVALID, object oItem = OBJECT_INVALID, object oCaster = OBJECT_SELF);

// applies all on hit cast spells on oItem, excluding any spell-subtype given in iExcludeSubType, to oTarget in the context of oCaster
// will look up the spell script that must be executed in "iprp_onhitspell.2da" and "spells.2da"
// This is a safe way to do this, without interfering with any other loops over item properties in the spell scripts
// Always use this function to cycle through and execute the onhitcast spells on an item!!
// if default values for oTarget, oItem are supplied, no override variables are set, so that the PRC-wrapper functions
// (or Bioware's functions) must determine the SpellTargetObject and the SpellCastItem
// for more information see the description in ExecuteSpellScript()
void ApplyAllOnHitCastSpellsOnItemExcludingSubType(int iExcludeSubType, object oTarget = OBJECT_INVALID, object oItem = OBJECT_INVALID, object oCaster = OBJECT_SELF);

// returns true, if oItem has at least one onhitcast spell on it (can be any subtype)
int GetHasOnHitCastSpell(object oItem);

// returns true, if the oItem has an onhitcast spell with the given subtype
int GetHasOnHitCastSpellSubType(int iSubType, object oItem);

// returns True, if we have the onhit flame weapon spell on oItem
int GetHasOnHitFlameWeapon(object oItem);

// returns True, if we have the onhit darkfire spell on oItem
int GetHasOnHitDarkfire(object oItem);

// returns True, if we have the onhit unique power spell on oItem
int GetHasOnHitUniquePower(object oItem);

// to be used only in on-hit cast spell scripts, in order to route the spell through the unique power script (prc_onhitcast)
// checks the local int "prc_ohc"; if it does not find the int, it assumes the spell script was called
// directly be the aurora engine. In that case it will call prc_onhitcast and return TRUE (to signal to the caller, that
// it should NOT further execute the spell script, as this will be done by prc_onhitcast)
// if the function returns FALSE; the spell was not routed through prc_onhitcast, so the spell script should continue
int OnHitCastRouteToUniquePower(object oSpellOrigin = OBJECT_SELF);

// this will force the instant execution of any onhitcast spell script, even if it is set up to be
// routed through prc_onhitcast (for more info on forced execution look at the code of OnHitCastRouteToUniquePower)
// For more info on functionality, see the description/code of ExecuteSpellScript()
void ForceExecuteSpellScript(string sScript, object oTarget = OBJECT_INVALID, int nMetaMagic = METAMAGIC_ANY, int nCasterLevel = 0, object oItem = OBJECT_INVALID, object oCaster = OBJECT_SELF);

// this will force the instant execution of any onhitcast spell script with iSpellNr, as given in spells.2da
// The spell script will be executed, even if it has been set up to be routed through prc_onhitcast
// (for more info on forced execution look at the code of OnHitCastRouteToUniquePower)
// for more info on functionality, see the description/code of CastSpellAtObject
void ForceCastSpellAtObject(int iSpellNr, object oTarget = OBJECT_INVALID, int nMetaMagic = METAMAGIC_ANY, int nCasterLevel = 0, object oItem = OBJECT_INVALID, object oCaster = OBJECT_SELF);

// forces the instant application of the onhitcast spell (situated on oItem) with subtype iSubType to oTarget,  in the context of oCaster
// (for more info on forced execution look at the code of OnHitCastRouteToUniquePower)
// for more info on functionality, see the description/code of ApplyOnHitCastSpellSubType
void ForceApplyOnHitCastSpellSubType(int iSubType, object oTarget = OBJECT_INVALID, object oItem = OBJECT_INVALID, object oCaster = OBJECT_SELF);

// instantly applies all on hit cast spells on oItem to oTarget in the context of oCaster
// will force apply the spell scripts even if they have internally been set up to be routed through prc_onhitcast
// (for more info on forced execution look at the code of OnHitCastRouteToUniquePower)
// for more info on functionality, see the description/code of ApplyAllOnHitCastSpells
// This is the safe way to loop through the item properties, without interfering with any other loops over item properties in the spell scripts
void ForceApplyAllOnHitCastSpellsOnItem(object oTarget = OBJECT_INVALID, object oItem = OBJECT_INVALID, object oCaster = OBJECT_SELF);

// most likely we will never need the following function:
// instantly applies all on hit cast spells on oItem, excluding any spell-subtype given in iExcludeSubType, to oTarget in the context of oCaster
// will force apply the spell scripts even if they have internally been set up to be routed through prc_onhitcast
// (for more info on forced execution look at the code of OnHitCastRouteToUniquePower)
// for more info on functionality, see the description/code of ApplyAllOnHitCastSpellsExcludingSubType
// This is the safe way to loop through the item properties, without interfering with any other loops over item properties in the spell scripts
void ForceApplyAllOnHitCastSpellsExcludingSubType(int iExcludeSubType, object oTarget = OBJECT_INVALID, object oItem = OBJECT_INVALID, object oCaster = OBJECT_SELF);


// -----------------
// END ONHITCAST
// -----------------


// Returns the caster level when used in spells.  You can use PRCGetCasterLevel()
// to determine a caster level from within a true spell script.  In spell-like-
// abilities & items, it will only return GetCasterLevel.
int PRCGetCasterLevel(object oCaster = OBJECT_SELF);

// Returns the equivalent added caster levels from Arcane Prestige Classes.
int GetArcanePRCLevels (object oCaster);

// Returns the equivalent added caster levels from Divine Prestige Classes.
int GetDivinePRCLevels (object oCaster);

// Returns TRUE if nClass is an arcane spellcasting class, FALSE otherwise.
int GetIsArcaneClass(int nClass, object oCaster = OBJECT_SELF);

// Returns TRUE if nClass is an divine spellcasting class, FALSE otherwise.
int GetIsDivineClass (int nClass, object oCaster = OBJECT_SELF);

// Returns the CLASS_TYPE of the first arcane caster class possessed by the character
// or CLASS_TYPE_INVALID if there is none.
int GetFirstArcaneClass (object oCaster = OBJECT_SELF);

// Returns the CLASS_TYPE of the first divine caster class possessed by the character
// or CLASS_TYPE_INVALID if there is none.
int GetFirstDivineClass (object oCaster = OBJECT_SELF);

// Returns the position that the first arcane class is in, returns 0 if none.
int GetFirstArcaneClassPosition (object oCaster = OBJECT_SELF);

// Returns the position that the first divine class is in, returns 0 if none.
int GetFirstDivineClassPosition (object oCaster = OBJECT_SELF);

// Returns the SPELL_SCHOOL of the spell in question.
int GetSpellSchool(int iSpellId);

// Returns the best "natural" arcane levels of the PC in question.  Does not
// consider feats that situationally adjust caster level.
int GetLevelByTypeArcane(object oCaster = OBJECT_SELF);

// Returns the best "natural" divine levels of the PC in question.  Does not
// consider feats that situationally adjust caster level.
int GetLevelByTypeDivine(object oCaster = OBJECT_SELF);

// Returns the best "feat-adjusted" arcane levels of the PC in question.
// Considers feats that situationally adjust caster level.
int GetLevelByTypeArcaneFeats(object oCaster = OBJECT_SELF, int iSpellID = -1);

// Returns the best "feat-adjusted" divine levels of the PC in question.
// Considers feats that situationally adjust caster level.
int GetLevelByTypeDivineFeats(object oCaster = OBJECT_SELF, int iSpellID = -1);

//Returns Reflex Adjusted Damage. Is a wrapper function that allows the
//DC to be adjusted based on conditions that cannot be done using iprops
//such as saves vs spellschools, or other adjustments
int PRCGetReflexAdjustedDamage(int nDamage, object oTarget, int nDC, int nSaveType=SAVING_THROW_TYPE_NONE, object oSaveVersus=OBJECT_SELF);

//Returns 0, 1 or 2 as MySavingThrow does. 0 is a failure, 1 is success, 2 is immune.
//Is a wrapper function that allows the DC to be adjusted based on conditions
//that cannot be done using iprops, such as saves vs spellschool.
int PRCMySavingThrow(int nSavingThrow, object oTarget, int nDC, int nSaveType=SAVING_THROW_TYPE_NONE, object oSaveVersus = OBJECT_SELF, float fDelay = 0.0);

// Finds caster levels by specific types (see the constants below).
int GetCasterLvl(int iTypeSpell, object oCaster = OBJECT_SELF);

// Helps to find the adjustment to level granted by Practiced Spellcaster feats.
//
// oCaster - the PC/NPC in question
// iCastingClass - the class we're looking at
// iCastingLevels - the amount of adjusted caster levels BEFORE Practiced Spellcaster
int PractisedSpellcasting (object oCaster, int iCastingClass, int iCastingLevels);

// Applies bonus damage to targets from Prestige abilities, like the Diabolist.
//
// oTarget - Target of the spell
void PRCBonusDamage(object oTarget);

//  Calculates bonus damage to a spell for Spell Betrayal Ability
int SpellBetrayalDamage(object oTarget, object oCaster);

//  Calculates damage to a spell for Spellstrike Ability
int SpellStrikeDamage(object oTarget, object oCaster);

//  Adds the bonus damage from both Spell Betrayal and Spellstrike together
int ApplySpellBetrayalStrikeDamage(object oTarget, object oCaster, int bShowTextString = TRUE);

// Added by GaiaWerewolf
// Checks if a spell is a healing spell
int GetIsHealingSpell(int nSpellId);

// to override for custom spellcasting classes
int PRCGetLastSpellCastClass(object oCaster = OBJECT_SELF);

// wrapper for getspelltargetlocation
location PRCGetSpellTargetLocation(object oCaster = OBJECT_SELF);

// returns if a character should be using the newspellbook when casting
int UseNewSpellBook(object oCreature);

// wrapper for DecrementRemainingSpellUses, works for newspellbook 'fake' spells too
void PRCDecrementRemainingSpellUses(object oCreature, int nSpell);

// wrapper for GetHasSpell, works for newspellbook 'fake' spells too
// should return 0 if called with a normal spell when a character should be using the newspellbook
int PRCGetHasSpell(int nSpell, object oCreature = OBJECT_SELF);

// returns the spelllevel of nSpell as it can be cast by oCreature
int PRCGetSpellLevel(object oCreature, int nSpell);

/**
 * A wrapper for GetSpellTargetObject().
 * Handles effects that redirect spell targeting, currently:
 * - Reddopsi
 * - Casting from runes
 *
 * NOTE: Will probably not return a sensible value outside of a spellscript. Assumes
 *       OBJECT_SELF is the object doing the casting.
 *
 * @return The target for the spell whose spellscript is currently being executed.
 */
object PRCGetSpellTargetObject(object oCaster   = OBJECT_SELF);

/**
 * A wrapper for GetSpellCastItem(). 
 *
 * NOTE: Will probably not return a sensible value outside of a spellscript. 
 *
 * @return The item from which the spell was cast.
 */
object PRCGetSpellCastItem(object oPC = OBJECT_SELF);

/**
 * Determines and applies the alignment shift for using spells/powers with the
 * [Evil] descriptor.  The amount of adjustment is equal to the square root of
 * the caster's distance from pure evil.
 * In other words, the amount of shift is higher the farther the caster is from
 * pure evil, with the extremes being 10 points of shift at pure good and 0
 * points of shift at pure evil.
 *
 * Does nothing if the PRC_SPELL_ALIGNMENT_SHIFT switch is not set.
 *
 * @param oPC The caster whose alignment to adjust
 */
void SPEvilShift(object oPC);

/**
 * Determines and applies the alignment shift for using spells/powers with the
 * [Good] descriptor.  The amount of adjustment is equal to the square root of
 * the caster's distance from pure good.
 * In other words, the amount of shift is higher the farther the caster is from
 * pure good, with the extremes being 10 points of shift at pure evil and 0
 * points of shift at pure good.
 *
 * Does nothing if the PRC_SPELL_ALIGNMENT_SHIFT switch is not set.
 *
 * @param oPC The caster whose alignment to adjust
 */
void SPGoodShift(object oPC);

/**
 * Applies the corruption cost for Corrupt spells.
 *
 * @param oPC      The caster of the Corrupt spell
 * @param oTarget  The target of the spell.
 *                 Not used for anything, should probably remove - Ornedan
 * @param nAbility ABILITY_* of the ability to apply the cost to
 * @param nCost    The amount of stat damage or drain to apply
 * @param bDrain   If this is TRUE, the cost is applied as ability drain.
 *                 If FALSE, as ability damage.
 */
void DoCorruptionCost(object oPC, int nAbility, int nCost, int bDrain);

// This function is used in the spellscripts
// It functions as Evasion for Fortitude and Will partial saves
// This means the "partial" section is ignored
// nSavingThrow takes either SAVING_THROW_WILL or SAVING_THROW_FORT
int GetHasMettle(object oTarget, int nSavingThrow);

/*This function is used to tell whether the target is incorporeal via
 *the persistant local int "IS_INCORPOREAL" or appearance.
 */


// Test for incorporeallity of the target
// useful for targetting loops when incorporeal creatures
// wouldnt be affected
int GetIsIncorporeal(object oTarget);


// Gets the total number of HD of controlled undead
// i.e from Animate Dead, Ghoul Gauntlet or similar
// Dominated undead from Turn Undead do not count
int GetControlledUndeadTotalHD(object oPC = OBJECT_SELF);

// Gets the total number of HD of controlled evil outsiders
// i.e from call dretch, call lemure, or similar
// Dominated outsiders from Turn Undead etc do not count
int GetControlledFiendTotalHD(object oPC = OBJECT_SELF);

// Gets the total number of HD of controlled good outsiders
// i.e from call favoured servants
// Dominated outsiders from Turn Undead etc do not count
int GetControlledCelestialTotalHD(object oPC = OBJECT_SELF);

// -----------------
// BEGIN SPELLSWORD
// -----------------

//This function returns 1 only if the object oTarget is the object
//the weapon hit when it channeled the spell sSpell or if there is no
//channeling at all
int ChannelChecker(string sSpell, object oTarget);

//If a spell is being channeled, we store its target and its name
void StoreSpellVariables(string sString,int nDuration);

//Replacement for The MaximizeOrEmpower function that checks for metamagic feats
//in channeled spells as well
int PRCMaximizeOrEmpower(int nDice, int nNumberOfDice, int nMeta, int nBonus = 0);

//This checks if the spell is channeled and if there are multiple spells
//channeled, which one is it. Then it checks in either case if the spell
//has the metamagic feat the function gets and returns TRUE or FALSE accordingly
//int CheckMetaMagic(int nMeta,int nMMagic);
//not needed now there is PRCGetMetaMagicFeat()

//wrapper for biowares GetMetaMagicFeat()
//used for spellsword and items
int PRCGetMetaMagicFeat(object oCaster = OBJECT_SELF);

//wrapper for biowares PRCGetSpellId()
//used for actioncastspell
int PRCGetSpellId(object oCaster = OBJECT_SELF);

//GetFirstObjectInShape wrapper for changing the AOE of the channeled spells (Spellsword Channel Spell)
object MyFirstObjectInShape(int nShape, float fSize, location lTarget, int bLineOfSight=FALSE, int nObjectFilter=OBJECT_TYPE_CREATURE, vector vOrigin=[0.0,0.0,0.0]);

//GetNextObjectInShape wrapper for changing the AOE of the channeled spells (Spellsword Channel Spell)
object MyNextObjectInShape(int nShape, float fSize, location lTarget, int bLineOfSight=FALSE, int nObjectFilter=OBJECT_TYPE_CREATURE, vector vOrigin=[0.0,0.0,0.0]);

// -----------------
// END SPELLSWORD
// -----------------

// Functions mostly only useful within the scope of this include
int ArchmageSpellPower (object oCaster);
int TrueNecromancy (object oCaster, int iSpellID, string sType);
int DomainPower(object oCaster, int nSpellID);
int StormMagic(object oCaster);
int DeathKnell(object oCaster);
int ShadowWeave (object oCaster, int iSpellID);
string GetChangedElementalType(int spell_id, object oCaster = OBJECT_SELF);
int FireAdept (object oCaster, int iSpellID);
int BWSavingThrow(int nSavingThrow, object oTarget, int nDC, int nSaveType=SAVING_THROW_TYPE_NONE, object oSaveVersus = OBJECT_SELF, float fDelay = 0.0);

// ---------------
// BEGIN CONSTANTS
// ---------------

const int  TYPE_ARCANE   = -1;
const int  TYPE_DIVINE   = -2;

//Changed to use CLASS_TYPE_* instead
//const int  TYPE_SORCERER = 2;
//const int  TYPE_WIZARD   = 3;
//const int  TYPE_BARD     = 4;
//const int  TYPE_CLERIC   = 11;
//const int  TYPE_DRUID    = 12;
//const int  TYPE_RANGER   = 13;
//const int  TYPE_PALADIN  = 14;

#include "inc_utility"
//#include "prc_alterations"
#include "x2_inc_itemprop"
#include "prc_inc_sneak"
//#include "prc_feat_const"
//#include "prc_class_const"
#include "lookup_2da_spell"
#include "inc_vfx_const"
#include "prc_inc_newip"
#include "spinc_necro_cyst"
#include "inc_abil_damage"
#include "prc_power_const"
#include "inc_newspellbook"
#include "inc_lookups"

// ---------------
// BEGIN FUNCTIONS
// ---------------

/**
// PRCGetSpellCastItem(object oCaster = OBJECT_SELF)
// wrapper function (experimental) for GetSpellCastItem()

// Note that we are giving preference for the local object, "PRC_SPELLCASTITEM_OVERRIDE", stored on oCaster
// Therefore it is absolutely essential, in order to have this variable not interfere with "normal" spell casting,
// to delete it *immediately after* the spell script executed. All of this is taken care of in the function ExecuteSpellScript(),
// which should be used instead of any direct calls to the spell scripts (e.g. don't use ExecuteScript() directly)

// Another possibility is to give preference to the GetSpellCastItem() call and only fetch the local object
// "PRC_SPELLCASTITEM_OVERRIDE" when GetSpellCastItem() returns an invalid object.
// This is how it is was done in the PRC 3.1c version of prc_onhitcast (lines 58-61), and in psi_sk_onhit, prc_evnt_bonebld, prc_evnt_strmtl
// In those scripts the local (override) object was called "PRC_CombatSystem_OnHitCastSpell_Item". In order to be consistent with
// the names of the other override variables, I changed the name of the override object to PRC_SPELLCASTITEM_OVERRIDE and
// provided the wrapper PRCGetSpellCastItem for an easy to use onhitcast system

// Possible caveats:

// You should never cast spells as an action, when you need to set and delete the local object "PRC_SPELLCASTITEM_OVERRIDE" *outside* the action script.
// This also pertains to other override variables, such as PRC_SPELL_TARGET_OBJECT_OVERRIDE, PRC_METAMAGIC_OVERRIDE, etc.
// If you set (and delete) any local override (object or int) *within* the action script, thats ok. For instance putting ExecuteSpellScript() into an
// ActionDoCommand, an AssignCommand or a DelayCommand will work; But setting "PRC_SPELLCASTITEM_OVERRIDE", then calling ActionCastSpellAt*
// (which will insert the spell cast action into the action queue) and trying to delete the local object "PRC_SPELLCASTITEM_OVERRIDE" via a DelayCommand
// or an AssignCommand(), often just guessing how long it takes the spell cast action to execute, will most likely break any other spell casting that is done between
// setting the local override variable and deleting it. The problem becomes real, when you want to cast a spell, that requires a spell cast item (e.g. an onhit cast spell),
// via any of the ActionCastSpellAt* commands provided by Bioware. First, the bioware ActionCastSpellAt* functions don't set up the SpellCastItem properly (simply
// because you cannot supply the item as a parameter). So if the spell needs the item, you have to set it yourself. If bioware had provided a way to cast a spell *directly*, e.g.
// not as an action, things would be quite easy. We could write a small three line function which i) sets the local object "PRC_SPELLCASTITEM_OVERRIDE", then ii) does
// the spell directly, and iii) finally deletes the local object "PRC_SPELLCASTITEM_OVERRIDE". This single(!) three line function then can be inserted into the action
// queue of oCaster via an AssignCommand or ActionDoCommand. But that is not possible, because Bioware only gave us Action* functions for spell casting. A workaround,
// that might work in most cases, is to assign three consecutive actions to the caster's action queue: First insert an action that sets the local object
// "PRC_SPELLCASTITEM_OVERRIDE", then insert the spell cast action into the queue via one of Bioware's ActionCastSpellAt* functions. Finally insert an action
// into the queue that deletes the local object "PRC_SPELLCASTITEM_OVERRIDE". If the local object is stored on oCaster (not on the module!) this approach will
// work most of the time. However, in the unfortunate event that an onhitcast spell (or another "instant" spell) is activated *between* the three consecutive
// actions, trouble is certain to occur. 
*/


// wrapper function by motu99. Anything that depends on it will only be fully functional,
// if the relevant spell scripts have been modified, replacing Bioware's GetSpellCastItem with PRCGetSpellCastItem
object PRCGetSpellCastItem(object oCaster = OBJECT_SELF)
{
	// if the local object "PRC_SPELLCASTITEM_OVERRIDE" is valid, we take it without even looking for anything else
	object oItem = GetLocalObject(oCaster, PRC_SPELLCASTITEM_OVERRIDE);
	if (GetIsObjectValid(oItem))
	{
		if (DEBUG) DoDebug("PRCGetSpellCastItem: found override spell cast item = "+GetName(oItem)+", original item = " + GetName(GetSpellCastItem()));
		return oItem;
	}
	
	// otherwise simply return Bioware's GetSpellCastItem
	return GetSpellCastItem();
/*
// motu99: disabled the old stuff; was only used in three scripts (changed them)
		// if Bioware's functions doesn't return a valid object, maybe the scripted combat system will
		if(!GetIsObjectValid(oItem))
			oItem = GetLocalObject(oPC, "PRC_CombatSystem_OnHitCastSpell_Item");
*/
}

/**
// executes the spell script sScript via ExecuteScript in the context of oCaster (assuming oCaster is the caster)
// sets local override ints/objects on oCaster before execution (and deletes them immediately after execution)
// so that the PRC-wrapper functions in the spell scripts can determine
//   - the target oTarget of the spell (accessed in the spell script via PRCGetSpellTargetObject),
//   - the metamagic feat of the spell nMetamagic (accessed in the spell script via PRCGetMetaMagicFeat)
//   - the casterlevel nCasterLevel (accessed in the spell script via PRCGetCasterLevel)
//   - the spell cast item oItem (accessed in the spell script via PRCGetSpellCastItem)
// if default values for the parameters oTarget, nMetaMagic, nCasterLevel and oItem are passed to ExecuteSpellScript,
// it does not set any overrides for the PRC-wrapper functions. In this case you have to rely on the logic in
// the wrapper functions to properly determine the correct values. This will generally work for nCasterLevel, but might not work
// as expected for oTarget, nMetaMagic and oItem - depending from where you call ExecuteSpellScript. If you call it from
// within a spell script (so that Bioware's initialization code - or any PRC code - had a chance to set up things nicely), then the spell "information" 
// functions PRCGetSpellTargetObject, PRCGetMetaMagicFeat etc. will most likely return sensible values.
// However, if you call ExecuteSpellScript outside of a spell script, nobody will have done any setup for you!
// In such a case you are strongly advised to setup things manually, by explicitly passing non-default arguments to this function!

// known caveats:
// Using calls to PRCGetMetaMagicFeat() in onhitcast spells can be dangerous, because PRCGetMetaMagicFeat(), if given a valid spell cast item, will cycle through
// the item properties on the spell cast item, in order to find out whether there are item properties of the type ITEM_PROPERTY_CAST_SPELL_METAMAGIC
// on the item. This is problematic, because prc_onhitcast must also cycle through the item properties, in order to find out what onhitcast spells are on the item.
// prc_onhitcast will execute all onhitcast spells it finds (besides itself) via ExecuteScript() or ExecuteSpellScript().
// If we are not careful, we might find ourselves with two nested loops over item properties. But the current implementation
// of GetFirstItemProperty and GetNextItemProperty does not allow nested loops. Nested loops generally result
// in unpredictable behavior (such as infinitely returning the same item property on GetNextItemProperty)

// The above described problem always occurs when there are nested loops over item properties or effects. Therefore generally it is a bad idea to call anything
// complicated (e.g. a spell script) within a loop over item properties or effects, in particular if you don't know the internal logic of the complicated routine
// you called (it could contain calls to GetFirst* or GetNext*)

// I provided a "safe" function to cycle through all onhitcast spells on an item: ApplyAllOnHitCastSpellsExcludingSubType
*/
void ExecuteSpellScript(string sScript, object oTarget = OBJECT_INVALID, int nMetaMagic = METAMAGIC_ANY, int nCasterLevel = 0, object oItem = OBJECT_INVALID, object oCaster = OBJECT_SELF)
{
	if(DEBUG) DoDebug("ExecuteSpellScript: executing script "+sScript);

	// tell the impact spell script who the target is
	if (oTarget != OBJECT_INVALID)
		SetLocalObject(oCaster, PRC_SPELL_TARGET_OBJECT_OVERRIDE, oTarget);

	// tell the impact spell script what the spell cast item is
	if (oItem != OBJECT_INVALID)
		SetLocalObject(oCaster, PRC_SPELLCASTITEM_OVERRIDE, oItem);
		
	// override the caster level, but only if necessary
	if (nCasterLevel)
		SetLocalInt(oCaster, PRC_CASTERLEVEL_OVERRIDE, nCasterLevel);

	// tell the impact spell script the metamagic we want to use
	if (nMetaMagic != METAMAGIC_ANY)
		SetLocalInt(oCaster, PRC_METAMAGIC_OVERRIDE, nMetaMagic);
		
	// execute the impact spell script in the context of oCaster
	ExecuteScript(sScript, oCaster);

/**
// motu99: If we are paranoid, we could delete all local ints and objects, regardless if we set them beforehand,
// This would prevent any accidental setting of these variables somewhere else, and then forgetting to delete them
// However, as long as we route all of our stuff through ExecuteSpellScript(), we can be sure, that these variables
// are not misused anywhere else. (And then Bioware does not seem to delete its variables either)
// If we delete the local ints and objects indiscriminately, we MUST always call ExecuteScript with NON-DEFAULT values.
// Otherwise we are in trouble when we do multiple calls to ExecuteScript from a loop: We might accidentally delete
// any overrides that we set on some previous call to ExecuteSpellScript. At that point we are at the mercy of
// Bioware's functions to provide the correct values, which does not always work.
// Note that some measure of safety is provided through the fact, that we set these local ints / objects on oCaster, and not on the module
*/
	// cleanup (we only delete those local ints / objects that we set before
	if (oItem != OBJECT_INVALID)
		DeleteLocalObject(oCaster, PRC_SPELLCASTITEM_OVERRIDE);

	if (oTarget != OBJECT_INVALID)
		DeleteLocalObject(oCaster, PRC_SPELL_TARGET_OBJECT_OVERRIDE);

	if (nMetaMagic != METAMAGIC_ANY)
		DeleteLocalInt(oCaster, PRC_METAMAGIC_OVERRIDE);

	if (nCasterLevel)
		DeleteLocalInt(oCaster, PRC_CASTERLEVEL_OVERRIDE);

//DoDebug("ExecuteSpellScript: done executing script "+sScript);
}


// will instantly cast the spell with index iSpellNr at oTarget by calling the ImpactScript listed in spells.2da
// the spell is not inserted into the action queue of the caster, no checks are performed whether the caster can actually cast the spell!
// oTarget is the target of the spell, oItem (if required) is the item from which the spell is cast, oPC (or OBJECT_SELF) is the caster
// so far this only works for spells cast on an object (oTarget). It is quite easy to write a similar function for AoE spells ( have to add a location)
// experimental; so far only tested for flame weapon and darkfire

// in order to work, it requires modifications in the impact spell scripts!!!
// We need a new PRC-wrapper function for the SpellCastItem, and replace any occurrence of GetSpellCastItem() with the new wrapper-function PRCGetSpellCastItem())
// It would be a good idea to check all impact spell scripts, whether all calls to GetSpellCastItem(), GetCasterLevel(), GetMetaMagicFeat() and GetSpellTargetObject()
// have been replaced by the respective PRC wrapper functions 

// if default values for oTarget, oItem are supplied, no override variables are set, so that the PRC-wrapper functions
// (or Bioware's functions) must determine the SpellTargetObject and the SpellCastItem
// see the description in ExecuteSpellScript()
void CastSpellAtObject(int iSpellNr, object oTarget = OBJECT_INVALID, int nMetaMagic = METAMAGIC_ANY, int nCasterLevel = 0, object oItem = OBJECT_INVALID, object oCaster = OBJECT_SELF)
{
	// get the name of the impact spell script (for ExecuteScript)
	string sScript = Get2DACache("spells", "ImpactScript", iSpellNr);

	if(sScript == "" || sScript == "****")
		return;

	ExecuteSpellScript(sScript, oTarget, nMetaMagic, nCasterLevel, oItem, oCaster);
}

// executes an AoE spell script, very similar to ExecuteSpellScript
// will not set an override location, if the parameter bBioLocation = TRUE
void ExecuteAoESpellScript(string sScript, location lTargetLocation, int bBioLocation = FALSE, int nMetaMagic = METAMAGIC_ANY, int nCasterLevel = 0, object oItem = OBJECT_INVALID, object oCaster = OBJECT_SELF)
{
	if(DEBUG) DoDebug("ExecuteAoESpellScript: executing script "+sScript);

	// tell the impact spell script where the target area is
	if (!bBioLocation)
	{
		SetLocalInt(oCaster, PRC_SPELL_TARGET_LOCATION_OVERRIDE, TRUE);
		SetLocalLocation(oCaster, PRC_SPELL_TARGET_LOCATION_OVERRIDE, lTargetLocation);
	}

	// tell the impact spell script what the spell cast item is
	if (oItem != OBJECT_INVALID)
		SetLocalObject(oCaster, PRC_SPELLCASTITEM_OVERRIDE, oItem);
		
	// override the caster level, but only if necessary
	if (nCasterLevel)
		SetLocalInt(oCaster, PRC_CASTERLEVEL_OVERRIDE, nCasterLevel);

	// tell the impact spell script the metamagic we want to use
	if (nMetaMagic != METAMAGIC_ANY)
		SetLocalInt(oCaster, PRC_METAMAGIC_OVERRIDE, nMetaMagic);
		
	// execute the impact spell script in the context of oCaster
	ExecuteScript(sScript, oCaster);

/**
// motu99: If we are paranoid, we could delete all local ints and objects, regardless if we set them beforehand,
// This would prevent any accidental setting of these variables somewhere else, and then forgetting to delete them
// However, as long as we route all of our stuff through ExecuteSpellScript(), we can be sure, that these variables
// are not misused anywhere else. (And then Bioware does not seem to delete its variables either)
// If we delete the local ints and objects indiscriminately, we MUST always call ExecuteScript with NON-DEFAULT values.
// Otherwise we are in trouble when we do multiple calls to ExecuteScript from a loop: We might accidentally delete
// any overrides that we set on some previous call to ExecuteSpellScript. At that point we are at the mercy of
// Bioware's functions to provide the correct values, which does not always work.
// Note that some measure of safety is provided through the fact, that we set these local ints / objects on oCaster, and not on the module
*/
	// cleanup (we only delete those local ints / objects that we set before
	if (!bBioLocation)
	{
		DeleteLocalInt(oCaster, PRC_SPELL_TARGET_LOCATION_OVERRIDE);
		// DeleteLocalLocation(oCaster, PRC_SPELL_TARGET_LOCATION_OVERRIDE);
	}

	if (oItem != OBJECT_INVALID)
		DeleteLocalObject(oCaster, PRC_SPELLCASTITEM_OVERRIDE);

	if (nMetaMagic != METAMAGIC_ANY)
		DeleteLocalInt(oCaster, PRC_METAMAGIC_OVERRIDE);

	if (nCasterLevel)
		DeleteLocalInt(oCaster, PRC_CASTERLEVEL_OVERRIDE);

//DoDebug("ExecuteAoESpellScript: done executing script "+sScript);
}

// works similar to ActionCastSpellAtLocation, only casts spell instantly (without saving throw etc.
// See description of CastSpellAtObject, how instant spells work
void CastSpellAtLocation(int iSpellNr, location lTargetLocation, int nMetaMagic = METAMAGIC_ANY, int nCasterLevel = 0, object oItem = OBJECT_INVALID, object oCaster = OBJECT_SELF)
{
	// get the name of the impact spell script (for ExecuteScript)
	string sScript = Get2DACache("spells", "ImpactScript", iSpellNr);

	if(sScript == "" || sScript == "****")
		return;

	// we have to provide a location, so bBioLocation = FALSE
	// if  bBioLocation were true, ExecuteAoESpellScript would have to rely on Bioware's GetSpellTargetLocation
	// in order to supply the location for the spell script. That can work if you call CastSpellAtLocation from within
	// a spell script, but usually you don't do that with instant spells, so mostly this would not work
	ExecuteAoESpellScript(sScript, lTargetLocation, FALSE, nMetaMagic, nCasterLevel, oItem, oCaster);
}


// applies to oTarget the onhitcast spell (situated on oItem) with subtype iSubType,  in the context of oPC
// if default values for oTarget, oItem are supplied, no override variables are set, so that the PRC-wrapper functions
// (or Bioware's functions) must determine the SpellTargetObject and the SpellCastItem
// see the description in ExecuteSpellScript()
void ApplyOnHitCastSpellSubType(int iSubType, object oTarget = OBJECT_INVALID, object oItem = OBJECT_INVALID, object oCaster = OBJECT_SELF)
{
	// get the spellID of the onhitspell
	int iSpellID = StringToInt( Get2DACache("iprp_onhitspell", "SpellIndex", iSubType) );

	// now execute the impact spell script
	CastSpellAtObject(iSpellID, oTarget, METAMAGIC_ANY, 0, oItem, oCaster);
}

// applies to oTarget the onhitcast spell darkdire (situated on oItem), in the context of oCaster
// if default values for oTarget, oItem are supplied, no override variables are set, so that the PRC-wrapper functions
// (or Bioware's functions) must determine the SpellTargetObject and the SpellCastItem
// see the description in ExecuteSpellScript()
void ApplyOnHitDarkfire(object oTarget = OBJECT_INVALID, object oItem = OBJECT_INVALID, object oCaster = OBJECT_SELF)
{
	ApplyOnHitCastSpellSubType(IP_CONST_ONHIT_CASTSPELL_ONHIT_DARKFIRE, oTarget, oItem, oCaster);
}

// applies to oTarget the onhitcast spell flame weapon (situated on oItem), in the context of oCaster
// if default values for oTarget, oItem are supplied, no override variables are set, so that the PRC-wrapper functions
// (or Bioware's functions) must determine the SpellTargetObject and the SpellCastItem
// see the description in ExecuteSpellScript()
void ApplyOnHitFlameWeapon(object oTarget = OBJECT_INVALID, object oItem = OBJECT_INVALID, object oCaster = OBJECT_SELF)
{
	ApplyOnHitCastSpellSubType(IP_CONST_ONHIT_CASTSPELL_ONHIT_FIREDAMAGE, oTarget, oItem, oCaster);
}

// applies to oTarget the onhitcast spell unique power (situated on oItem), in the context of oPC
// if default values for oTarget, oItem are supplied, no override variables are set, so that the PRC-wrapper functions
// (or Bioware's functions) must determine the SpellTargetObject and the SpellCastItem
// see the description in ExecuteSpellScript()
void ApplyOnHitUniquePower(object oTarget = OBJECT_INVALID, object oItem = OBJECT_INVALID, object oCaster = OBJECT_SELF)
{
//	ApplyOnHitCastSpellSubType(IP_CONST_ONHIT_CASTSPELL_ONHIT_UNIQUEPOWER, oTarget, oItem, oCaster);
	ExecuteSpellScript("prc_onhitcast", oTarget, METAMAGIC_ANY, 0, oItem, oCaster);
}

// applies all on hit cast spells on oItem to oTarget in the context of oCaster
// This is a safe way to do this, without interfering with any other loops over item properties in the spell scripts that are called
// always use this function to cycle through and execute the onhitcast spells on an item
// if default values for oTarget, oItem are supplied, no override variables are set, so that the PRC-wrapper functions
// (or Bioware's functions) must determine the SpellTargetObject and the SpellCastItem
// see the description in ExecuteSpellScript()
void ApplyAllOnHitCastSpellsOnItem(object oTarget = OBJECT_INVALID, object oItem = OBJECT_INVALID, object oCaster = OBJECT_SELF)
{
	int iSubType;
	int iNr = 0;

	// remember the item that was passed to the function (in case it is invalid we pass it through to the spell cast functions)
	object oItemPassed = oItem;
	
	// we need an item, so if OBJECT_INVALID was given, we must use the "standard" logic in PRCGetSpellCastItem to determine the item
	if (oItem == OBJECT_INVALID)
		oItem = PRCGetSpellCastItem(oCaster);

	itemproperty ip = GetFirstItemProperty(oItem);

	while(GetIsItemPropertyValid(ip))
	{
// DoDebug("ApplyAllOnHitCastSpellsExcludingSubType: found " + DebugStringItemProperty(ip));
		if (GetItemPropertyType(ip) ==ITEM_PROPERTY_ONHITCASTSPELL)
		{
			// retrieve the spell ID
			iSubType = GetItemPropertySubType(ip);
			// we found a new onhit spell, so increment iNr
			iNr++;
			// store the spell ID in an array and execute the spell later, this is safer than trying to execute the spell script directly
			// lets hope that nobody else uses our name "ohspl" for the array
			SetLocalArrayInt(oCaster, "ohspl", iNr, iSubType);
		}
		ip = GetNextItemProperty(oItem);
	}
	
	// now execute the spell scripts (note that the local array will not be deleted) 
	while (iNr)
	{
		iSubType = GetLocalArrayInt(oCaster, "ohspl", iNr);
//DoDebug("ApplyAllOnHitCastSpellsExcludingSubType: executing onhitcastspell subtype # " + IntToString(iSubType));
		ApplyOnHitCastSpellSubType(iSubType, oTarget, oItemPassed, oCaster);
		iNr--;
	}	
}

// applies all on hit cast spells on oItem, excluding any spell-subtype given in iExcludeSubType, to oTarget in the context of oCaster
// This is a safe way to do this, without interfering with any other loops over item properties in the spell scripts that are called
// always use this function to cycle through and execute the onhitcast spells on an item
// if default values for oTarget, oItem are supplied, no override variables are set, so that the PRC-wrapper functions
// (or Bioware's functions) must determine the SpellTargetObject and the SpellCastItem
// see the description in ExecuteSpellScript()
void ApplyAllOnHitCastSpellsOnItemExcludingSubType(int iExcludeSubType, object oTarget = OBJECT_INVALID, object oItem = OBJECT_INVALID, object oCaster = OBJECT_SELF)
{
	int iSubType;
	int iNr = 0;

	// remember the item that was passed to the function (in case it is invalid we pass it through to the spell cast functions)
	object oItemPassed = oItem;
	
	if (oItem == OBJECT_INVALID)
		oItem = PRCGetSpellCastItem(oCaster);

	itemproperty ip = GetFirstItemProperty(oItem);

	while(GetIsItemPropertyValid(ip))
	{
// DoDebug("ApplyAllOnHitCastSpellsExcludingSubType: found " + DebugStringItemProperty(ip));
		if (GetItemPropertyType(ip) ==ITEM_PROPERTY_ONHITCASTSPELL)
		{
			iSubType = GetItemPropertySubType(ip);
			if(iSubType == iExcludeSubType) // if(iSubType ==IP_CONST_ONHIT_CASTSPELL_ONHIT_UNIQUEPOWER) // == 125
            {
                ip = GetNextItemProperty(oItem);
                continue; //skip over OnHit:CastSpell:UniquePower otherwise it would TMI.
            }
			// we found a new onhit spell, so increment iNr
			iNr++;
			// store the spell ID in an array and execute the spell later, this is safer than trying to execute the spell script directly
			// lets hope that nobody else uses our name "ohspl" for the array
			SetLocalArrayInt(oCaster, "ohspl", iNr, iSubType);
		}
		ip = GetNextItemProperty(oItem);
	}
	
	// now execute the spell scripts (note that the local array will not be deleted) 
	while (iNr)
	{
		iSubType = GetLocalArrayInt(oCaster, "ohspl", iNr);
//DoDebug("ApplyAllOnHitCastSpellsExcludingSubType: executing onhitcastspell subtype # " + IntToString(iSubType));
		ApplyOnHitCastSpellSubType(iSubType, oTarget, oItemPassed, oCaster);
		iNr--;
	}	
}

// returns true, if oItem has at least one onhitcast spell (of any subtype)
int GetHasOnHitCastSpell(object oItem)
{	
	itemproperty ip = GetFirstItemProperty(oItem);

	while(GetIsItemPropertyValid(ip))
	{
		if (GetItemPropertyType(ip) ==ITEM_PROPERTY_ONHITCASTSPELL)
		{
				return TRUE;
		}
		ip = GetNextItemProperty(oItem);
	}
	return FALSE;
}

// returns true, if oItem has an onhitcast spell with the given subtype
int GetHasOnHitCastSpellSubType(int iSubType, object oItem)
{	
	itemproperty ip = GetFirstItemProperty(oItem);

	while(GetIsItemPropertyValid(ip))
	{

		if (GetItemPropertyType(ip) ==ITEM_PROPERTY_ONHITCASTSPELL
			&& GetItemPropertySubType(ip) == iSubType)
		{
				return TRUE;
		}
		ip = GetNextItemProperty(oItem);
	}
	return FALSE;
}

// returns True, if we have the onhit flame weapon spell on the item
int GetHasOnHitFlameWeapon(object oItem)
{
	return GetHasOnHitCastSpellSubType(IP_CONST_ONHIT_CASTSPELL_ONHIT_FIREDAMAGE, oItem);
}

// returns True, if we have the onhit darkfire spell on the item
int GetHasOnHitDarkfire(object oItem)
{
	return GetHasOnHitCastSpellSubType(IP_CONST_ONHIT_CASTSPELL_ONHIT_DARKFIRE, oItem);
}

// returns True, if we have the onhit unique power spell on the item
int GetHasOnHitUniquePower(object oItem)
{
	return GetHasOnHitCastSpellSubType(IP_CONST_ONHIT_CASTSPELL_ONHIT_UNIQUEPOWER, oItem);
}

// to be used only in on-hit cast spell scripts, in order to route the spell through the unique power script (prc_onhitcast)
// checks the local int "prc_onhitcast_executing"; if it does not find the int, it assumes the spell script was called
// directly be the aurora engine. In that case it will call prc_onhitcast and return TRUE (to signal to the caller, that
// it should NOT execute the spell script, as this will be done by prc_onhitcast)
// if the function returns FALSE; the spell is not routed through prc_onhitcast, so the spell script should continue
int OnHitCastRouteToUniquePower(object oSpellOrigin = OBJECT_SELF)
{
	// if the local int "frc_ohc" is on, then we never route the spell through prc_onhitcast
	// rather we force the execution of the onhitcast script; so return False in this case
	if (GetLocalInt(oSpellOrigin, "frc_ohc"))
	{
		// signal to caller that it can continue execution (no rerouting to prc_onhitcast)
		return FALSE;
	}

	// now check whether we were called from prc_onhitcast
	int bNotCalledByPRC = !GetLocalInt(oSpellOrigin, "prc_ohc");

	// if not, call prc_onhitcast
	if (bNotCalledByPRC)
	{
		if (DEBUG) DoDebug("onhitcast spell script not called through prc_onhitcast - now routing to prc_onhitcast");
		ExecuteScript("prc_onhitcast", oSpellOrigin);
	}
	// signal to calling function, whether it should terminate execution, because we rerouted the call (e.g. bNotCalledByPRC=TRUE)
	// or whether it should continue execution, because we did not reroute (e.g. bNotCalledByPRC=FALSE)
	return bNotCalledByPRC;
}

// this will force the execution of any onhitcast spell script, even if it is set up to be
// routed through prc_onhitcast (see the description for the function OnHitCastRouteToUniquePower)
void ForceExecuteSpellScript(string sScript, object oTarget = OBJECT_INVALID, int nMetaMagic = METAMAGIC_ANY, int nCasterLevel = 0, object oItem = OBJECT_INVALID, object oCaster = OBJECT_SELF)
{
	// set the local int, that tells the spell script that we want to force its execution
	SetLocalInt(oCaster, "frc_ohc", TRUE);

	// now call the spell script
	ExecuteSpellScript(sScript, oTarget, nMetaMagic, nCasterLevel, oItem, oCaster);

	// delete the local int for forced execution
	DeleteLocalInt(oCaster, "frc_ohc");
}

// this will force the instant execution of any onhitcast spell script with iSpellNr, as given in spells.2da
// The spell script will be executed, even if it has been set up to be routed through prc_onhitcast
// (for more info, see the description of the function OnHitCastRouteToUniquePower)
void ForceCastSpellAtObject(int iSpellNr, object oTarget = OBJECT_INVALID, int nMetaMagic = METAMAGIC_ANY, int nCasterLevel = 0, object oItem = OBJECT_INVALID, object oCaster = OBJECT_SELF)
{
	// get the name of the impact spell script (for ExecuteSpellScript)
	string sScript = Get2DACache("spells", "ImpactScript", iSpellNr);

	if(sScript == "" || sScript == "****")
		return;

	// now force-execute the spell script
	ForceExecuteSpellScript(sScript, oTarget, nMetaMagic, nCasterLevel, oItem, oCaster);
}

// forces the application of the onhitcast spell (situated on oItem) with subtype iSubType to oTarget,  in the context of oPC
void ForceApplyOnHitCastSpellSubType(int iSubType, object oTarget = OBJECT_INVALID, object oItem = OBJECT_INVALID, object oCaster = OBJECT_SELF)
{
	// get the spellID of the onhitspell
	int iSpellID = StringToInt( Get2DACache("iprp_onhitspell", "SpellIndex", iSubType) );

	// now force-execute the impact spell script
	ForceCastSpellAtObject(iSpellID, oTarget, METAMAGIC_ANY, 0, oItem, oCaster);
}

// applies all on hit cast spells on oItem to oTarget in the context of oCaster
// will force apply the spell scripts even if they have internally been set up to be routed through prc_onhitcast
// (for more info, see the description of the function OnHitCastRouteToUniquePower)
// This is the safe way to do this, without interfering with any other loops over item properties in the spell scripts that are called
void ForceApplyAllOnHitCastSpellsOnItem(object oTarget = OBJECT_INVALID, object oItem = OBJECT_INVALID, object oCaster = OBJECT_SELF)
{
	// set the local int, that tells the spell scripts that we want to force their execution
	SetLocalInt(oCaster, "frc_ohc", TRUE);

	// now apply all onhitcast spells on the item
	ApplyAllOnHitCastSpellsOnItem(oTarget, oItem, oCaster);

	// delete the local int for forced execution
	DeleteLocalInt(oCaster, "frc_ohc");	
}

// applies all on hit cast spells on oItem, excluding any spell-subtype given in iExcludeSubType, to oTarget in the context of oCaster
// will force apply the spell scripts even if they have internally been set up to be routed through prc_onhitcast
// (for more info, see the description of the function OnHitCastRouteToUniquePower)
// This is the safe way to do this, without interfering with any other loops over item properties in the spell scripts that are called
void ForceApplyAllOnHitCastSpellsOnItemExcludingSubType(int iExcludeSubType, object oTarget = OBJECT_INVALID, object oItem = OBJECT_INVALID, object oCaster = OBJECT_SELF)
{
	// set the local int, that tells the spell scripts that we want to force their execution
	SetLocalInt(oCaster, "frc_ohc", TRUE);

	// now apply all onhitcast spells on the item
	ApplyAllOnHitCastSpellsOnItemExcludingSubType(iExcludeSubType, oTarget, oItem, oCaster);

	// delete the local int for forced execution
	DeleteLocalInt(oCaster, "frc_ohc");	
}




int GetArcanePRCLevels (object oCaster)
{
   int nArcane;
   int nOozeMLevel  = GetLevelByClass(CLASS_TYPE_OOZEMASTER, oCaster);
   int nFirstClass  = PRCGetClassByPosition(1, oCaster);
   int nSecondClass = PRCGetClassByPosition(2, oCaster);
   int nThirdClass  = PRCGetClassByPosition(3, oCaster);

   nArcane += GetLevelByClass(CLASS_TYPE_ARCHMAGE,        oCaster)
           +  GetLevelByClass(CLASS_TYPE_ARCTRICK,        oCaster)
           +  GetLevelByClass(CLASS_TYPE_ELDRITCH_KNIGHT, oCaster)
           +  GetLevelByClass(CLASS_TYPE_ES_ACID,         oCaster)
           +  GetLevelByClass(CLASS_TYPE_ES_COLD,         oCaster)
           +  GetLevelByClass(CLASS_TYPE_ES_ELEC,         oCaster)
           +  GetLevelByClass(CLASS_TYPE_ES_FIRE,         oCaster)
           +  GetLevelByClass(CLASS_TYPE_HARPERMAGE,      oCaster)
           +  GetLevelByClass(CLASS_TYPE_MAGEKILLER,      oCaster)
           +  GetLevelByClass(CLASS_TYPE_MASTER_HARPER,   oCaster)
           +  GetLevelByClass(CLASS_TYPE_TRUENECRO,       oCaster)
           +  GetLevelByClass(CLASS_TYPE_SHADOW_ADEPT,    oCaster)
           +  GetLevelByClass(CLASS_TYPE_MYSTIC_THEURGE,  oCaster)
           +  GetLevelByClass(CLASS_TYPE_RED_WIZARD,      oCaster)
           +  GetLevelByClass(CLASS_TYPE_DIABOLIST,       oCaster)
           +  GetLevelByClass(CLASS_TYPE_CEREBREMANCER,   oCaster)
           +  GetLevelByClass(CLASS_TYPE_MAESTER,         oCaster)
           +  GetLevelByClass(CLASS_TYPE_ENLIGHTENEDFIST, oCaster)
           +  GetLevelByClass(CLASS_TYPE_VIRTUOSO,        oCaster)
           +  GetLevelByClass(CLASS_TYPE_WAR_WIZARD_OF_CORMYR, oCaster)

           +  (GetLevelByClass(CLASS_TYPE_ACOLYTE,            oCaster) + 1) / 2
           +  (GetLevelByClass(CLASS_TYPE_BLADESINGER,        oCaster) + 1) / 2
           +  (GetLevelByClass(CLASS_TYPE_BONDED_SUMMONNER,   oCaster) + 1) / 2
           +  (GetLevelByClass(CLASS_TYPE_PALEMASTER,         oCaster) + 1) / 2
           +  (GetLevelByClass(CLASS_TYPE_HATHRAN,            oCaster) + 1) / 2
           +  (GetLevelByClass(CLASS_TYPE_SPELLSWORD,         oCaster) + 1) / 2
           +  (GetLevelByClass(CLASS_TYPE_THRALL_OF_GRAZZT_A, oCaster) + 1) / 2
           +  (GetLevelByClass(CLASS_TYPE_DISCIPLE_OF_ASMODEUS, oCaster) + 1) / 2

           +  (GetLevelByClass(CLASS_TYPE_JUDICATOR, oCaster) + 1) / 3;


   if (nOozeMLevel)
   {
       if (GetIsArcaneClass(nFirstClass, oCaster)
           || (!GetIsDivineClass(nFirstClass, oCaster)
                && GetIsArcaneClass(nSecondClass, oCaster))
           || (!GetIsDivineClass(nFirstClass, oCaster)
                && !GetIsDivineClass(nSecondClass, oCaster)
                && GetIsArcaneClass(nThirdClass, oCaster)))
           nArcane += nOozeMLevel / 2;
   }
    //Rakshasa include outsider HD as sorc
    //if they have sorcerer levels, then it counts as a prestige class
    //otherwise its used instead of sorc levels
    if(GetLevelByClass(CLASS_TYPE_SORCERER, oCaster)
        && GetRacialType(oCaster) == RACIAL_TYPE_RAKSHASA)
        nArcane += GetLevelByClass(CLASS_TYPE_OUTSIDER);

   return nArcane;
}

int GetDivinePRCLevels (object oCaster)
{
   int nDivine;
   int nOozeMLevel = GetLevelByClass(CLASS_TYPE_OOZEMASTER, oCaster);
   int nFirstClass = PRCGetClassByPosition(1, oCaster);
   int nSecondClass = PRCGetClassByPosition(2, oCaster);
   int nThirdClass = PRCGetClassByPosition(3, oCaster);

   // This section accounts for full progression classes
   nDivine += GetLevelByClass(CLASS_TYPE_DIVESA,            oCaster)
           +  GetLevelByClass(CLASS_TYPE_DIVESC,            oCaster)
           +  GetLevelByClass(CLASS_TYPE_DIVESE,            oCaster)
           +  GetLevelByClass(CLASS_TYPE_DIVESF,            oCaster)
           +  GetLevelByClass(CLASS_TYPE_FISTRAZIEL,        oCaster)
           +  GetLevelByClass(CLASS_TYPE_HEARTWARDER,       oCaster)
           +  GetLevelByClass(CLASS_TYPE_HIEROPHANT,        oCaster)
           +  GetLevelByClass(CLASS_TYPE_HOSPITALER,        oCaster)
           +  GetLevelByClass(CLASS_TYPE_MASTER_OF_SHROUDS, oCaster)
           +  GetLevelByClass(CLASS_TYPE_MYSTIC_THEURGE,    oCaster)
           +  GetLevelByClass(CLASS_TYPE_STORMLORD,         oCaster)
           +  GetLevelByClass(CLASS_TYPE_MASTER_HARPER_DIV, oCaster)
           +  GetLevelByClass(CLASS_TYPE_PSYCHIC_THEURGE,   oCaster)
           +  GetLevelByClass(CLASS_TYPE_ALAGHAR,           oCaster)
           +  GetLevelByClass(CLASS_TYPE_COMBAT_MEDIC,      oCaster)
           +  GetLevelByClass(CLASS_TYPE_BLIGHTLORD,        oCaster)
           +  GetLevelByClass(CLASS_TYPE_CONTEMPLATIVE,     oCaster)
           +  GetLevelByClass(CLASS_TYPE_RUNECASTER,        oCaster)

           +  (GetLevelByClass(CLASS_TYPE_OLLAM,                 oCaster) + 1) / 2
           +  (GetLevelByClass(CLASS_TYPE_BRIMSTONE_SPEAKER,     oCaster) + 1) / 2
           +  (GetLevelByClass(CLASS_TYPE_TEMPUS,                oCaster) + 1) / 2
           +  (GetLevelByClass(CLASS_TYPE_HATHRAN,               oCaster) + 1) / 2
           +  (GetLevelByClass(CLASS_TYPE_BFZ,                   oCaster) + 1) / 2
           +  (GetLevelByClass(CLASS_TYPE_ORCUS,                 oCaster) + 1) / 2
           +  (GetLevelByClass(CLASS_TYPE_SHINING_BLADE,         oCaster) + 1) / 2
           +  (GetLevelByClass(CLASS_TYPE_WARPRIEST,             oCaster) + 1) / 2
           +  (GetLevelByClass(CLASS_TYPE_THRALL_OF_GRAZZT_D,    oCaster) + 1) / 2
           +  (GetLevelByClass(CLASS_TYPE_MIGHTY_CONTENDER_KORD, oCaster) + 1) / 2

           +  (GetLevelByClass(CLASS_TYPE_JUDICATOR, oCaster) + 1) / 3;

   if (!GetHasFeat(FEAT_SF_CODE, oCaster))
   {
       nDivine   += GetLevelByClass(CLASS_TYPE_SACREDFIST, oCaster);
   }

   if (nOozeMLevel)
   {
       if (GetIsDivineClass(nFirstClass, oCaster)
           || (!GetIsArcaneClass(nFirstClass, oCaster)
                && GetIsDivineClass(nSecondClass, oCaster))
           || (!GetIsArcaneClass(nFirstClass, oCaster)
                && !GetIsArcaneClass(nSecondClass, oCaster)
                && GetIsDivineClass(nThirdClass, oCaster)))
           nDivine += nOozeMLevel / 2;
   }

   return nDivine;
}

int GetIsArcaneClass(int nClass, object oCaster = OBJECT_SELF)
{
    return (nClass==CLASS_TYPE_WIZARD ||
            nClass==CLASS_TYPE_SORCERER ||
            nClass==CLASS_TYPE_BARD ||
            nClass==CLASS_TYPE_ASSASSIN ||
            nClass==CLASS_TYPE_SUEL_ARCHANAMACH ||
            nClass==CLASS_TYPE_SHADOWLORD ||
            nClass==CLASS_TYPE_HEXBLADE ||
            nClass==CLASS_TYPE_DUSKBLADE ||
            (nClass==CLASS_TYPE_OUTSIDER
                && GetRacialType(oCaster)==RACIAL_TYPE_RAKSHASA
                && !GetLevelByClass(CLASS_TYPE_SORCERER))
            );
}

int GetIsDivineClass (int nClass, object oCaster = OBJECT_SELF)
{
    return (nClass==CLASS_TYPE_CLERIC ||
            nClass==CLASS_TYPE_DRUID ||
            nClass==CLASS_TYPE_PALADIN ||
            nClass==CLASS_TYPE_RANGER ||
            nClass==CLASS_TYPE_BLACKGUARD ||
            nClass==CLASS_TYPE_SOLDIER_OF_LIGHT ||
            nClass==CLASS_TYPE_VASSAL ||
            nClass==CLASS_TYPE_KNIGHT_MIDDLECIRCLE ||
            nClass==CLASS_TYPE_KNIGHT_CHALICE ||
            nClass==CLASS_TYPE_ANTI_PALADIN ||
            nClass==CLASS_TYPE_VIGILANT ||
            nClass==CLASS_TYPE_FAVOURED_SOUL ||
            nClass==CLASS_TYPE_SOHEI ||
            nClass==CLASS_TYPE_HEALER ||
            nClass==CLASS_TYPE_SLAYER_OF_DOMIEL ||
            nClass==CLASS_TYPE_OCULAR);
}

int GetFirstArcaneClassPosition (object oCaster = OBJECT_SELF)
{
    if (GetIsArcaneClass(PRCGetClassByPosition(1, oCaster), oCaster))
        return 1;
    if (GetIsArcaneClass(PRCGetClassByPosition(2, oCaster), oCaster))
        return 2;
    if (GetIsArcaneClass(PRCGetClassByPosition(3, oCaster), oCaster))
        return 3;

    return 0;
}

int GetFirstDivineClassPosition (object oCaster = OBJECT_SELF)
{
    if (GetIsDivineClass(PRCGetClassByPosition(1, oCaster), oCaster))
        return 1;
    if (GetIsDivineClass(PRCGetClassByPosition(2, oCaster), oCaster))
        return 2;
    if (GetIsDivineClass(PRCGetClassByPosition(3, oCaster), oCaster))
        return 3;

    return 0;
}

int GetFirstArcaneClass (object oCaster = OBJECT_SELF)
{
    int iArcanePos = GetFirstArcaneClassPosition(oCaster);
    if (!iArcanePos) return CLASS_TYPE_INVALID; // no arcane casting class

    int nClass = PRCGetClassByPosition(iArcanePos, oCaster);
    //raks cast as sorcs
    if(nClass == CLASS_TYPE_OUTSIDER
        && GetRacialType(oCaster) == RACIAL_TYPE_RAKSHASA
        && !GetLevelByClass(CLASS_TYPE_SORCERER))
        nClass = CLASS_TYPE_SORCERER;
    return nClass;
}

int GetFirstDivineClass (object oCaster = OBJECT_SELF)
{
    int iDivinePos = GetFirstDivineClassPosition(oCaster);
    if (!iDivinePos) return CLASS_TYPE_INVALID; // no Divine casting class

    int nClass = PRCGetClassByPosition(iDivinePos, oCaster);
    return nClass;
}

int GetSpellSchool(int iSpellId)
{
    string sSpellSchool = Get2DACache("spells", "School", iSpellId);//lookup_spell_school(iSpellId);
    int iSpellSchool;

    if (sSpellSchool == "A") iSpellSchool = SPELL_SCHOOL_ABJURATION;
    else if (sSpellSchool == "C") iSpellSchool = SPELL_SCHOOL_CONJURATION;
    else if (sSpellSchool == "D") iSpellSchool = SPELL_SCHOOL_DIVINATION;
    else if (sSpellSchool == "E") iSpellSchool = SPELL_SCHOOL_ENCHANTMENT;
    else if (sSpellSchool == "V") iSpellSchool = SPELL_SCHOOL_EVOCATION;
    else if (sSpellSchool == "I") iSpellSchool = SPELL_SCHOOL_ILLUSION;
    else if (sSpellSchool == "N") iSpellSchool = SPELL_SCHOOL_NECROMANCY;
    else if (sSpellSchool == "T") iSpellSchool = SPELL_SCHOOL_TRANSMUTATION;
    else iSpellSchool = SPELL_SCHOOL_GENERAL;

    return iSpellSchool;
}

int GetLevelByTypeArcane(object oCaster = OBJECT_SELF)
{
    int iFirstArcane = GetFirstArcaneClass(oCaster);
    int iBest = 0;
    int iClass1 = PRCGetClassByPosition(1, oCaster);
    int iClass2 = PRCGetClassByPosition(2, oCaster);
    int iClass3 = PRCGetClassByPosition(3, oCaster);
    int iClass1Lev = PRCGetLevelByPosition(1, oCaster);
    int iClass2Lev = PRCGetLevelByPosition(2, oCaster);
    int iClass3Lev = PRCGetLevelByPosition(3, oCaster);

    if (iClass1 == iFirstArcane) iClass1Lev += GetArcanePRCLevels(oCaster);
    if (iClass2 == iFirstArcane) iClass2Lev += GetArcanePRCLevels(oCaster);
    if (iClass3 == iFirstArcane) iClass3Lev += GetArcanePRCLevels(oCaster);

    iClass1Lev += PractisedSpellcasting(oCaster, iClass1, iClass1Lev);
    iClass2Lev += PractisedSpellcasting(oCaster, iClass2, iClass2Lev);
    iClass3Lev += PractisedSpellcasting(oCaster, iClass3, iClass3Lev);

    if (!GetIsArcaneClass(iClass1, oCaster)) iClass1Lev = 0;
    if (!GetIsArcaneClass(iClass2, oCaster)) iClass2Lev = 0;
    if (!GetIsArcaneClass(iClass3, oCaster)) iClass3Lev = 0;

    if (iClass1Lev > iBest) iBest = iClass1Lev;
    if (iClass2Lev > iBest) iBest = iClass2Lev;
    if (iClass3Lev > iBest) iBest = iClass3Lev;

    return iBest;
}

int GetLevelByTypeDivine(object oCaster = OBJECT_SELF)
{
    int iFirstDivine = GetFirstDivineClass(oCaster);
    int iBest = 0;
    int iClass1 = PRCGetClassByPosition(1, oCaster);
    int iClass2 = PRCGetClassByPosition(2, oCaster);
    int iClass3 = PRCGetClassByPosition(3, oCaster);
    int iClass1Lev = PRCGetLevelByPosition(1, oCaster);
    int iClass2Lev = PRCGetLevelByPosition(2, oCaster);
    int iClass3Lev = PRCGetLevelByPosition(3, oCaster);

    if (iClass1 == CLASS_TYPE_PALADIN || iClass1 == CLASS_TYPE_RANGER) iClass1Lev = iClass1Lev / 2;
    if (iClass2 == CLASS_TYPE_PALADIN || iClass2 == CLASS_TYPE_RANGER) iClass2Lev = iClass2Lev / 2;
    if (iClass3 == CLASS_TYPE_PALADIN || iClass3 == CLASS_TYPE_RANGER) iClass3Lev = iClass3Lev / 2;

    if (iClass1 == iFirstDivine) iClass1Lev += GetDivinePRCLevels(oCaster);
    if (iClass2 == iFirstDivine) iClass2Lev += GetDivinePRCLevels(oCaster);
    if (iClass3 == iFirstDivine) iClass3Lev += GetDivinePRCLevels(oCaster);

    iClass1Lev += PractisedSpellcasting(oCaster, iClass1, iClass1Lev);
    iClass2Lev += PractisedSpellcasting(oCaster, iClass2, iClass2Lev);
    iClass3Lev += PractisedSpellcasting(oCaster, iClass3, iClass3Lev);

    if (!GetIsDivineClass(iClass1, oCaster)) iClass1Lev = 0;
    if (!GetIsDivineClass(iClass2, oCaster)) iClass2Lev = 0;
    if (!GetIsDivineClass(iClass3, oCaster)) iClass3Lev = 0;

    if (iClass1Lev > iBest) iBest = iClass1Lev;
    if (iClass2Lev > iBest) iBest = iClass2Lev;
    if (iClass3Lev > iBest) iBest = iClass3Lev;

    return iBest;
}

int GetLevelByTypeArcaneFeats(object oCaster = OBJECT_SELF, int iSpellID = -1)
{
    int iFirstArcane = GetFirstArcaneClass(oCaster);
    int iBest = 0;
    int iClass1 = PRCGetClassByPosition(1, oCaster);
    int iClass2 = PRCGetClassByPosition(2, oCaster);
    int iClass3 = PRCGetClassByPosition(3, oCaster);
    int iClass1Lev = PRCGetLevelByPosition(1, oCaster);
    int iClass2Lev = PRCGetLevelByPosition(2, oCaster);
    int iClass3Lev = PRCGetLevelByPosition(3, oCaster);

    if (iSpellID = -1) iSpellID = PRCGetSpellId(oCaster);

    int iBoost = TrueNecromancy(oCaster, iSpellID, "ARCANE") +
                 ShadowWeave(oCaster, iSpellID) +
                 FireAdept(oCaster, iSpellID) +
                 DomainPower(oCaster, iSpellID) +
                 StormMagic(oCaster);

    if (iClass1 == iFirstArcane) iClass1Lev += GetArcanePRCLevels(oCaster);
    if (iClass2 == iFirstArcane) iClass2Lev += GetArcanePRCLevels(oCaster);
    if (iClass3 == iFirstArcane) iClass3Lev += GetArcanePRCLevels(oCaster);

    iClass1Lev += iBoost;
    iClass2Lev += iBoost;
    iClass3Lev += iBoost;

    iClass1Lev += PractisedSpellcasting(oCaster, iClass1, iClass1Lev);
    iClass2Lev += PractisedSpellcasting(oCaster, iClass2, iClass2Lev);
    iClass3Lev += PractisedSpellcasting(oCaster, iClass3, iClass3Lev);

    if (!GetIsArcaneClass(iClass1, oCaster)) iClass1Lev = 0;
    if (!GetIsArcaneClass(iClass2, oCaster)) iClass2Lev = 0;
    if (!GetIsArcaneClass(iClass3, oCaster)) iClass3Lev = 0;

    if (iClass1Lev > iBest) iBest = iClass1Lev;
    if (iClass2Lev > iBest) iBest = iClass2Lev;
    if (iClass3Lev > iBest) iBest = iClass3Lev;

    return iBest;
}

int GetLevelByTypeDivineFeats(object oCaster = OBJECT_SELF, int iSpellID = -1)
{
    int iFirstDivine = GetFirstDivineClass(oCaster);
    int iBest = 0;
    int iClass1 = PRCGetClassByPosition(1, oCaster);
    int iClass2 = PRCGetClassByPosition(2, oCaster);
    int iClass3 = PRCGetClassByPosition(3, oCaster);
    int iClass1Lev = PRCGetLevelByPosition(1, oCaster);
    int iClass2Lev = PRCGetLevelByPosition(2, oCaster);
    int iClass3Lev = PRCGetLevelByPosition(3, oCaster);

    if (iSpellID = -1) iSpellID = PRCGetSpellId(oCaster);

    int iBoost = TrueNecromancy(oCaster, iSpellID, "DIVINE") +
                 ShadowWeave(oCaster, iSpellID) +
                 FireAdept(oCaster, iSpellID) +
                 DomainPower(oCaster, iSpellID) +
                 StormMagic(oCaster);

    if (iClass1 == CLASS_TYPE_PALADIN
        || iClass1 == CLASS_TYPE_RANGER
        || iClass3 == CLASS_TYPE_ANTI_PALADIN)
        iClass1Lev = iClass1Lev / 2;
    if (iClass2 == CLASS_TYPE_PALADIN
        || iClass2 == CLASS_TYPE_RANGER
        || iClass3 == CLASS_TYPE_ANTI_PALADIN)
        iClass2Lev = iClass2Lev / 2;
    if (iClass3 == CLASS_TYPE_PALADIN
        || iClass3 == CLASS_TYPE_RANGER
        || iClass3 == CLASS_TYPE_ANTI_PALADIN)
        iClass3Lev = iClass3Lev / 2;

    if (iClass1 == iFirstDivine) iClass1Lev += GetDivinePRCLevels(oCaster);
    if (iClass2 == iFirstDivine) iClass2Lev += GetDivinePRCLevels(oCaster);
    if (iClass3 == iFirstDivine) iClass3Lev += GetDivinePRCLevels(oCaster);

    iClass1Lev += iBoost;
    iClass2Lev += iBoost;
    iClass3Lev += iBoost;

    iClass1Lev += PractisedSpellcasting(oCaster, iClass1, iClass1Lev);
    iClass2Lev += PractisedSpellcasting(oCaster, iClass2, iClass2Lev);
    iClass3Lev += PractisedSpellcasting(oCaster, iClass3, iClass3Lev);

    if (!GetIsDivineClass(iClass1, oCaster)) iClass1Lev = 0;
    if (!GetIsDivineClass(iClass2, oCaster)) iClass2Lev = 0;
    if (!GetIsDivineClass(iClass3, oCaster)) iClass3Lev = 0;

    if (iClass1Lev > iBest) iBest = iClass1Lev;
    if (iClass2Lev > iBest) iBest = iClass2Lev;
    if (iClass3Lev > iBest) iBest = iClass3Lev;

    return iBest;
}

int PRCGetLastSpellCastClass(object oCaster = OBJECT_SELF)
{
    int nClass = GetLocalInt(oCaster, PRC_CASTERCLASS_OVERRIDE);
    if(nClass)
	{
		if(DEBUG) DoDebug("PRCGetLastSpellCastClass: found override caster class = "+IntToString(nClass)+", original class = "+IntToString(GetLastSpellCastClass()));
        return nClass;
	}
    return GetLastSpellCastClass();
}

int PRCGetCasterLevel(object oCaster = OBJECT_SELF)
{
	int nAdjust = GetLocalInt(oCaster, PRC_CASTERLEVEL_ADJUSTMENT);//this is for builder use
	nAdjust += GetLocalInt(oCaster, "TrueCasterLens");
	//DelayCommand(1.0, DeleteLocalInt(oCaster, "PRC_Castlevel_Adjustment"));

	// For when you want to assign the caster level.
	int iReturnLevel = GetLocalInt(oCaster, PRC_CASTERLEVEL_OVERRIDE);
	if (iReturnLevel)
	{
		//SendMessageToPC(oCaster, "Forced-level casting at level " + IntToString(GetCasterLevel(oCaster)));
		if (DEBUG) DoDebug("PRCGetCasterLevel: found override caster level = "+IntToString(iReturnLevel)+" with adjustment = " + IntToString(nAdjust)+", original level = "+IntToString(GetCasterLevel(oCaster)));
		//DelayCommand(1.0, DeleteLocalInt(oCaster, PRC_CASTERLEVEL_OVERRIDE));
		return iReturnLevel+nAdjust;
	}

	// set to zero again (not necessary, if we made it here, it is zero)
	// iReturnLevel = 0;

	int iCastingClass = PRCGetLastSpellCastClass(oCaster); // might be CLASS_TYPE_INVALID
	int iSpellId = PRCGetSpellId(oCaster);
	// object oItem = GetSpellCastItem();
	object oItem = PRCGetSpellCastItem(oCaster);

	// Item Spells
	if (GetItemPossessor(oItem) == oCaster)
	{
		//SendMessageToPC(oCaster, "Item casting at level " + IntToString(GetCasterLevel(oCaster)));
		if(GetPRCSwitch(PRC_STAFF_CASTER_LEVEL)
			&& ((GetBaseItemType(oItem) == BASE_ITEM_MAGICSTAFF) ||
				(GetBaseItemType(oItem) == BASE_ITEM_CRAFTED_STAFF))
			)
		{
			iCastingClass = GetFirstArcaneClass(oCaster);//sets it to an arcane class
		}
		else
		{
			//code for getting new ip type
			itemproperty ipTest = GetFirstItemProperty(oItem);
			while(GetIsItemPropertyValid(ipTest) && !iReturnLevel)
			{
				if(GetItemPropertyType(ipTest) == ITEM_PROPERTY_CAST_SPELL_CASTER_LEVEL)
				{
					int nSubType = GetItemPropertySubType(ipTest);
					nSubType = StringToInt(Get2DACache("iprp_spells", "SpellIndex", nSubType));
					if(nSubType == iSpellId)
						iReturnLevel = GetItemPropertyCostTableValue (ipTest);
				}
				ipTest = GetNextItemProperty(oItem);
			}
		}
	}

	// no item casting, and arcane caster?
	if (!iReturnLevel && GetIsArcaneClass(iCastingClass, oCaster))
	{
		iReturnLevel = GetLevelByClass(iCastingClass, oCaster);
		if (GetFirstArcaneClass(oCaster) == iCastingClass)
		{
			iReturnLevel += GetArcanePRCLevels(oCaster)
				+  ArchmageSpellPower(oCaster);
		}
		iReturnLevel += TrueNecromancy(oCaster, iSpellId, "ARCANE")
			+  ShadowWeave(oCaster, iSpellId)
			+  FireAdept(oCaster, iSpellId)
			+  StormMagic(oCaster)
			+  DomainPower(oCaster, iSpellId)
			+  DeathKnell(oCaster);

		iReturnLevel += PractisedSpellcasting(oCaster, iCastingClass, iReturnLevel); //gotta be the last one
	}
	// no item casting and divine caster?
	else if(GetIsDivineClass(iCastingClass, oCaster))
	{
		iReturnLevel = GetLevelByClass(iCastingClass, oCaster);
		if (iCastingClass == CLASS_TYPE_RANGER
			|| iCastingClass == CLASS_TYPE_PALADIN
			|| iCastingClass == CLASS_TYPE_ANTI_PALADIN)
			iReturnLevel = iReturnLevel / 2;
		if (GetFirstDivineClass(oCaster) == iCastingClass)
			iReturnLevel += GetDivinePRCLevels(oCaster);
		iReturnLevel += TrueNecromancy(oCaster, iSpellId, "DIVINE")
			+  ShadowWeave(oCaster, iSpellId)
			+  FireAdept(oCaster, iSpellId)
			+  StormMagic(oCaster)
			+  DomainPower(oCaster, iSpellId)
			+  DeathKnell(oCaster);
		iReturnLevel += PractisedSpellcasting(oCaster, iCastingClass, iReturnLevel); //gotta be the last one
	}

	//at this point it must be a SLA or similar
	if(!iReturnLevel)
		iReturnLevel = GetCasterLevel(oCaster);

	iReturnLevel += nAdjust;

	//Adds 1 to caster level
	if(GetHasSpellEffect(SPELL_VIRTUOSO_MAGICAL_MELODY, oCaster))
		iReturnLevel++;

	return iReturnLevel;
}

int PractisedSpellcasting (object oCaster, int iCastingClass, int iCastingLevels)
{
    int iAdjustment = GetHitDice(oCaster) - iCastingLevels;
    if (iAdjustment > 4) iAdjustment = 4;
    if (iAdjustment < 0) iAdjustment = 0;

    if (iCastingClass == CLASS_TYPE_BARD
        && GetHasFeat(FEAT_PRACTISED_SPELLCASTER_BARD, oCaster))
        return iAdjustment;
    if (iCastingClass == CLASS_TYPE_SORCERER
        && GetHasFeat(FEAT_PRACTISED_SPELLCASTER_SORCERER, oCaster))
        return iAdjustment;
    if (iCastingClass == CLASS_TYPE_WIZARD
        && GetHasFeat(FEAT_PRACTISED_SPELLCASTER_WIZARD, oCaster))
        return iAdjustment;
    if (iCastingClass == CLASS_TYPE_CLERIC
        && GetHasFeat(FEAT_PRACTISED_SPELLCASTER_CLERIC, oCaster))
        return iAdjustment;
    if (iCastingClass == CLASS_TYPE_DRUID
        && GetHasFeat(FEAT_PRACTISED_SPELLCASTER_DRUID, oCaster))
        return iAdjustment;

    return 0;
}

int ArchmageSpellPower (object oCaster)
{
    int nLevelBonus = 0;

    if (GetHasFeat(FEAT_SPELL_POWER_I,oCaster))
    {
        nLevelBonus += 1;
     if (GetHasFeat(FEAT_SPELL_POWER_V,oCaster))
         nLevelBonus += 4;
     else if (GetHasFeat(FEAT_SPELL_POWER_IV,oCaster))
         nLevelBonus += 3;
     else if (GetHasFeat(FEAT_SPELL_POWER_III,oCaster))
         nLevelBonus += 2;
        else if (GetHasFeat(FEAT_SPELL_POWER_II,oCaster))
         nLevelBonus += 1;
    }
    return nLevelBonus;
}

int TrueNecromancy (object oCaster, int iSpellID, string sType)
{
	int iTNLevel = GetLevelByClass(CLASS_TYPE_TRUENECRO, oCaster);
	if (!iTNLevel)
		return 0;
	
	if (GetSpellSchool(iSpellID) != SPELL_SCHOOL_NECROMANCY)
		return 0;

	if (sType == "ARCANE")
		return GetLevelByClass(CLASS_TYPE_CLERIC, oCaster); // TN and arcane levels already added.

	// Either iSorLevel or iWizLevel will be 0 if the class is a true necro (only in NWN, not in NWN 2)
	if (sType == "DIVINE")
		return	GetLevelByClass(CLASS_TYPE_SORCERER, oCaster)
				+ GetLevelByClass(CLASS_TYPE_WIZARD, oCaster)
				+ iTNLevel; // cleric levels already added.

	return 0;
}

int StormMagic(object oCaster)
{
    if (!GetHasFeat(FEAT_STORMMAGIC,oCaster)) return 0;

    object oArea = GetArea(oCaster);

    if (GetWeather(oArea) == WEATHER_RAIN || GetWeather(oArea) == WEATHER_SNOW)
    {
        return 1;
    }
    return 0;
}

int DomainPower(object oCaster, int nSpellID)
{
	int nBonus = 0;
	int iSpellSchool = GetSpellSchool(nSpellID);

	// Boosts Caster level with the Illusion school by 1
	if (iSpellSchool == SPELL_SCHOOL_ILLUSION && GetHasFeat(FEAT_DOMAIN_POWER_GNOME, oCaster))
	{
		nBonus += 1;
	}
	
	// Boosts Caster level with the Illusion school by 1
	if (iSpellSchool == SPELL_SCHOOL_ILLUSION && GetHasFeat(FEAT_DOMAIN_POWER_ILLUSION, oCaster))
	{
		nBonus += 1;
	}

	// Boosts Caster level with healing spells
	if (GetIsHealingSpell(nSpellID) && GetHasFeat(FEAT_HEALING_DOMAIN_POWER, oCaster))
	{
		nBonus += 1;
	}

	// Boosts Caster level with the Divination school by 1
	if (iSpellSchool == SPELL_SCHOOL_DIVINATION && GetHasFeat(FEAT_KNOWLEDGE_DOMAIN_POWER, oCaster))
	{
		nBonus += 1;
	}

	return nBonus;
}

int DeathKnell(object oCaster)
{
    if (!GetLocalInt(oCaster, "DeathKnell")) return 0;
    // If you do have the int, return a +1 bonus to caster level
    return 1;
}

int ShadowWeave (object oCaster, int iSpellID)
{
   if (!GetHasFeat(FEAT_SHADOWWEAVE,oCaster)) return 0;

   int iSpellSchool = GetSpellSchool(iSpellID);

   // Bonus for spells of Enhancement, Necromancy and Illusion schools and spells with Darkness descriptor
   if (iSpellSchool == SPELL_SCHOOL_ENCHANTMENT ||
       iSpellSchool == SPELL_SCHOOL_NECROMANCY  ||
       iSpellSchool == SPELL_SCHOOL_ILLUSION    ||
       iSpellID == SPELL_DARKNESS               ||
       iSpellID == SPELLABILITY_AS_DARKNESS     ||
       iSpellID == 688                          || // Drider darkness
       iSpellID == SHADOWLORD_DARKNESS)
   {
       return 1;
   }
   // Penalty to spells of Evocation and Transmutation schools, except for those with Darkness descriptor
   else if (iSpellSchool == SPELL_SCHOOL_EVOCATION     ||
            iSpellSchool == SPELL_SCHOOL_TRANSMUTATION)
   {
       return -1;
   }

   return 0;
}

// stolen from prcsp_archmaginc.nss, modified to work in this script.
string GetChangedElementalType(int spell_id, object oCaster = OBJECT_SELF)
{
    string spellType = Get2DACache("spells", "ImmunityType", spell_id);//lookup_spell_type(spell_id);

    string sType = GetLocalString(oCaster, "archmage_mastery_elements_name");

    if (sType == "") sType = spellType;

    return sType;
}

int FireAdept (object oCaster, int iSpellID)
{
    if (GetHasFeat(FEAT_FIRE_ADEPT, oCaster) && GetChangedElementalType(iSpellID, oCaster) == "Fire")
        return 1;
    else
        return 0;
}


int BWSavingThrow(int nSavingThrow, object oTarget, int nDC, int nSaveType=SAVING_THROW_TYPE_NONE, object oSaveVersus = OBJECT_SELF, float fDelay = 0.0)
{
    // -------------------------------------------------------------------------
    // GZ: sanity checks to prevent wrapping around
    // -------------------------------------------------------------------------
    if (nDC<1)
       nDC = 1;
    else if (nDC > 255)
      nDC = 255;

    effect eVis;
    int bValid = FALSE;
    int nSpellID;
    if(nSavingThrow == SAVING_THROW_FORT)
    {
        bValid = FortitudeSave(oTarget, nDC, nSaveType, oSaveVersus);
        if(bValid == 1)
        {
            eVis = EffectVisualEffect(VFX_IMP_FORTITUDE_SAVING_THROW_USE);
        }
    }
    else if(nSavingThrow == SAVING_THROW_REFLEX)
    {
        bValid = ReflexSave(oTarget, nDC, nSaveType, oSaveVersus);
        if(bValid == 1)
        {
            eVis = EffectVisualEffect(VFX_IMP_REFLEX_SAVE_THROW_USE);
        }
    }
    else if(nSavingThrow == SAVING_THROW_WILL)
    {
        bValid = WillSave(oTarget, nDC, nSaveType, oSaveVersus);
        if(bValid == 1)
        {
            eVis = EffectVisualEffect(VFX_IMP_WILL_SAVING_THROW_USE);
        }
    }

    nSpellID = PRCGetSpellId(oSaveVersus);

    /*
        return 0 = FAILED SAVE
        return 1 = SAVE SUCCESSFUL
        return 2 = IMMUNE TO WHAT WAS BEING SAVED AGAINST
    */
    if(bValid == 0)
    {
        if((nSaveType == SAVING_THROW_TYPE_DEATH
         || nSpellID == SPELL_WEIRD
         || nSpellID == SPELL_FINGER_OF_DEATH) &&
         nSpellID != SPELL_HORRID_WILTING)
        {
            eVis = EffectVisualEffect(VFX_IMP_DEATH);
            DelayCommand(fDelay, ApplyEffectToObject(DURATION_TYPE_INSTANT, eVis, oTarget));
        }
    }
    if(bValid == 2)
    {
        eVis = EffectVisualEffect(VFX_IMP_MAGIC_RESISTANCE_USE);
    }
    if(bValid == 1 || bValid == 2)
    {
        if(bValid == 2)
        {
            /*
            If the spell is save immune then the link must be applied in order to get the true immunity
            to be resisted.  That is the reason for returing false and not true.  True blocks the
            application of effects.
            */
            bValid = FALSE;
        }
        DelayCommand(fDelay, ApplyEffectToObject(DURATION_TYPE_INSTANT, eVis, oTarget));
    }
    return bValid;
}


void PRCBonusDamage (object oTarget)
{
	object oCaster = OBJECT_SELF;
	int nDice;
	int nDamage;
	effect eDam;
	effect eVis;

	//FloatingTextStringOnCreature("PRC Bonus Damage is called", oCaster, FALSE);

	int iDiabolistLevel = GetLevelByClass(CLASS_TYPE_DIABOLIST, oCaster);
	if (iDiabolistLevel > 0 && GetLocalInt(oCaster, "Diabolism") == TRUE)
	{

		//FloatingTextStringOnCreature("Diabolism is active", oCaster, FALSE);

		nDice = (iDiabolistLevel + 5) / 5;
		nDamage = d6(nDice);

		eVis = EffectVisualEffect(VFX_FNF_LOS_EVIL_10);
		eDam = EffectDamage(nDamage, DAMAGE_TYPE_DIVINE);

		if (GetLocalInt(oCaster, "VileDiabolism") == TRUE)
		{
			//FloatingTextStringOnCreature("Vile Diabolism is active", oCaster, FALSE);
			nDamage /= 2;
			eDam = EffectDamage(nDamage, DAMAGE_TYPE_POSITIVE);
			SetLocalInt(oCaster, "VileDiabolism", FALSE);
		}

		ApplyEffectToObject(DURATION_TYPE_INSTANT, eDam, oTarget);
		ApplyEffectToObject(DURATION_TYPE_INSTANT, eVis, oTarget);
		DelayCommand(3.0, SetLocalInt(oCaster, "Diabolism", FALSE));
	}

	if (GetLevelByClass(CLASS_TYPE_BLOOD_MAGUS, oCaster) > 0 && GetLocalInt(oCaster, "BloodSeeking") == TRUE)
	{
		nDamage = d6();
		eDam = EffectDamage(nDamage, DAMAGE_TYPE_MAGICAL);
		eVis = EffectVisualEffect(VFX_IMP_DEATH_L);
		ApplyEffectToObject(DURATION_TYPE_INSTANT, eDam, oTarget);
		ApplyEffectToObject(DURATION_TYPE_INSTANT, eVis, oTarget);

		effect eSelfDamage = EffectDamage(3, DAMAGE_TYPE_MAGICAL);
		// To make sure it doesn't cause a conc check
		DelayCommand(1.0, ApplyEffectToObject(DURATION_TYPE_INSTANT, eSelfDamage, oCaster));
	}
}

//  Bonus damage to a spell for Spell Betrayal Ability
int SpellBetrayalDamage(object oTarget, object oCaster)
{
     int iDam = 0;
     int ThrallLevel = GetLevelByClass(CLASS_TYPE_THRALL_OF_GRAZZT_A, oCaster) + GetLevelByClass(CLASS_TYPE_THRALL_OF_GRAZZT_D, oCaster);
     string sMes = "";

     if(ThrallLevel >= 2)
     {
          if( GetIsDeniedDexBonusToAC(oTarget, oCaster, TRUE) )
          {
               ThrallLevel /= 2;
               iDam = d6(ThrallLevel);
          }
     }

     return iDam;
}

//  Bonus damage to a spell for Spellstrike Ability
int SpellStrikeDamage(object oTarget, object oCaster)
{
     int iDam = 0;
     int ThrallLevel = GetLevelByClass(CLASS_TYPE_THRALL_OF_GRAZZT_A, oCaster) + GetLevelByClass(CLASS_TYPE_THRALL_OF_GRAZZT_D, oCaster);

     if(ThrallLevel >= 6)
     {
          if( GetIsAOEFlanked(oTarget, oCaster) )
          {
               ThrallLevel /= 4;
               iDam = d6(ThrallLevel);
          }
     }

     return iDam;
}

//  Adds the bonus damage from both Spell Betrayal and Spellstrike together
int ApplySpellBetrayalStrikeDamage(object oTarget, object oCaster, int bShowTextString = TRUE)
{
     int iDam = 0;
     int iBetrayalDam = SpellBetrayalDamage(oTarget, oCaster);
     int iStrikeDam = SpellStrikeDamage(oTarget, oCaster);
     string sMes = "";

     if(iStrikeDam > 0 && iBetrayalDam > 0)  sMes ="*Spellstrike Betrayal Sucess*";
     else if(iBetrayalDam > 0)               sMes ="*Spell Betrayal Sucess*";
     else if(iStrikeDam > 0)                 sMes ="*Spellstrike Sucess*";

     if(bShowTextString)      FloatingTextStringOnCreature(sMes, oCaster, TRUE);

     iDam = iBetrayalDam + iStrikeDam;

     // debug code
     //sMes = "Spell Betrayal / Spellstrike Bonus Damage: " + IntToString(iBetrayalDam) + " + " + IntToString(iStrikeDam) + " = " + IntToString(iDam);
     //DelayCommand( 1.0, FloatingTextStringOnCreature(sMes, oCaster, TRUE) );

     return iDam;
}


int PRCMySavingThrow(int nSavingThrow, object oTarget, int nDC, int nSaveType=SAVING_THROW_TYPE_NONE, object oSaveVersus = OBJECT_SELF, float fDelay = 0.0)
{
    int nSpell = PRCGetSpellId(oSaveVersus);

    // Iron Mind's Mind Over Body, allows them to treat other saves as will saves up to 3/day.
    // No point in having it trigger when its a will save.
    if (nSavingThrow != SAVING_THROW_WILL && GetLocalInt(oTarget, "IronMind_MindOverBody"))
    {
        nSavingThrow = SAVING_THROW_WILL;
        DeleteLocalInt(oTarget, "IronMind_MindOverBody");
    }

    // Handle the target having Force of Will and being targeted by a psionic power
    if(nSavingThrow != SAVING_THROW_WILL        &&
       ((nSpell > 14000 && nSpell < 14360) ||
        (nSpell > 15350 && nSpell < 15470)
        )                                       &&
       GetHasFeat(FEAT_FORCE_OF_WILL, oTarget)  &&
       !GetLocalInt(oTarget, "ForceOfWillUsed") &&
       // Only use will save if it's better
       ((nSavingThrow == SAVING_THROW_FORT ? GetFortitudeSavingThrow(oTarget) : GetReflexSavingThrow(oTarget)) > GetWillSavingThrow(oTarget))
       )
    {
        nSavingThrow = SAVING_THROW_WILL;
        SetLocalInt(oTarget, "ForceOfWillUsed", TRUE);
        DelayCommand(6.0f, DeleteLocalInt(oTarget, "ForceOfWillUsed"));
        // "Force of Will used for this round."
        FloatingTextStrRefOnCreature(16826670, oTarget, FALSE);
    }

    //Thayan Knights auto-fail mind spells cast by red wizards
    if(	nSaveType == SAVING_THROW_TYPE_MIND_SPELLS
		&& GetLevelByClass(CLASS_TYPE_RED_WIZARD, oSaveVersus) > 0
		&& GetLevelByClass(CLASS_TYPE_THAYAN_KNIGHT, oTarget) > 0
		)
    {
        return 0;
    }

    // Hexblade gets a bonus against spells equal to his Charisma (Min +1)
    int nHex = GetLevelByClass(CLASS_TYPE_HEXBLADE, oTarget);
    if (nHex > 0)
    {
        int nHexCha = GetAbilityModifier(ABILITY_CHARISMA, oTarget);
        if (nHexCha < 1) nHexCha = 1;
        nDC -= nHexCha;
    }

    // This is done here because it is possible to tell the saving throw type here
    // Tyranny Domain increases the DC of mind spells by +2.
    if(nSaveType == SAVING_THROW_TYPE_MIND_SPELLS && GetHasFeat(FEAT_DOMAIN_POWER_TYRANNY, oSaveVersus))
        nDC += 2;

    //racial pack code
    //this works by lowering the DC rather than adding to the save
    //same net effect but slightly different numbers
    if(nSaveType == SAVING_THROW_TYPE_FIRE && GetHasFeat(FEAT_HARD_FIRE, oTarget))
        nDC -= 1 + (GetHitDice(oTarget) / 5);
    else if(nSaveType == SAVING_THROW_TYPE_COLD && GetHasFeat(FEAT_HARD_WATER, oTarget))
        nDC -= 1 + (GetHitDice(oTarget) / 5);
    else if(nSaveType == SAVING_THROW_TYPE_ELECTRICITY)
    {
        if(GetHasFeat(FEAT_HARD_AIR, oTarget))
            nDC -= 1 + (GetHitDice(oTarget) / 5);
        else if(GetHasFeat(FEAT_HARD_ELEC, oTarget))
            nDC -= 2;
    }
    else if(nSaveType == SAVING_THROW_TYPE_POISON && GetHasFeat(FEAT_POISON_3, oTarget))
        nDC -= 3;
    else if(nSaveType == SAVING_THROW_TYPE_ACID && GetHasFeat(FEAT_HARD_EARTH, oTarget))
        nDC -= 1 + (GetHitDice(oTarget) / 5);

    // Necrotic Cyst penalty on Necromancy spells
    if(GetPersistantLocalInt(oTarget, NECROTIC_CYST_MARKER) && (GetSpellSchool(nSpell) == SPELL_SCHOOL_NECROMANCY))
        nDC += 2;
    
    // This Maneuver allows people to use a skill check instead of a save on a Will save
    if (nSavingThrow == SAVING_THROW_WILL && GetLocalInt(oTarget, "MomentOfPerfectMind"))
    {
    	return GetIsSkillSuccessful(oTarget, SKILL_CONCENTRATION, nDC);
    }
    
    // This Maneuver allows people to use a skill check instead of a save on a Reflex save
    if (nSavingThrow == SAVING_THROW_REFLEX && GetLocalInt(oTarget, "ActionBeforeThought"))
    {
    	return GetIsSkillSuccessful(oTarget, SKILL_CONCENTRATION, nDC);
    }    

    int nSaveRoll = BWSavingThrow(nSavingThrow, oTarget, nDC, nSaveType, oSaveVersus, fDelay);

    // Second Chance power reroll
    if(nSaveRoll == 0                                        &&     // Failed the save
       GetLocalInt(oTarget, "PRC_Power_SecondChance_Active") &&     // Second chance is active
       !GetLocalInt(oTarget, "PRC_Power_SecondChance_UserForRound") // And hasn't yet been used for this round
       )
    {
        // Reroll
        nSaveRoll = BWSavingThrow(nSavingThrow, oTarget, nDC, nSaveType, oSaveVersus, fDelay);

        // Can't use this ability again for a round
        SetLocalInt(oTarget, "PRC_Power_SecondChance_UserForRound", TRUE);
        DelayCommand(6.0f, DeleteLocalInt(oTarget, "PRC_Power_SecondChance_UserForRound"));
    }
    
    // Zealous Surge Reroll
    if(nSaveRoll == 0 &&     // Failed the save
       GetLocalInt(oTarget, "ZealousSurge"))
    {
        // Reroll
        nSaveRoll = BWSavingThrow(nSavingThrow, oTarget, nDC, nSaveType, oSaveVersus, fDelay);

        // Ability Used
	DeleteLocalInt(oTarget, "ZealousSurge");
    }      

    // Iron Mind Barbed Mind ability
    if(GetLevelByClass(CLASS_TYPE_IRONMIND, oTarget) >= 10)
    {
        // Only works on Mind Spells and in Heavy Armour
        object oItem = GetItemInSlot(INVENTORY_SLOT_CHEST, oTarget);
        if(nSaveType == SAVING_THROW_TYPE_MIND_SPELLS && GetBaseAC(oItem) >= 6)
        {
            // Spell/Power caster takes 1d6 damage and 1 Wisdom damage
            effect eDam = EffectDamage(d6(), DAMAGE_TYPE_MAGICAL);
            ApplyEffectToObject(DURATION_TYPE_INSTANT, eDam, oSaveVersus);
            ApplyAbilityDamage(oSaveVersus, ABILITY_WISDOM, 1, DURATION_TYPE_TEMPORARY, TRUE, -1.0);
        }
    }

    return nSaveRoll;
}


int PRCGetReflexAdjustedDamage(int nDamage, object oTarget, int nDC, int nSaveType=SAVING_THROW_TYPE_NONE, object oSaveVersus=OBJECT_SELF)
{
    int nSpell = PRCGetSpellId(oSaveVersus);
    int nOriginalDamage = nDamage;

     // Iron Mind's Mind Over Body, allows them to treat other saves as will saves up to 3/day.
     // For this, it lowers the DC by the difference between the Iron Mind's will save and its reflex save.
     if (GetLocalInt(oTarget, "IronMind_MindOverBody"))
     {
        int nWill = GetWillSavingThrow(oTarget);
        int nRef = GetReflexSavingThrow(oTarget);
        int nSaveBoost = nWill - nRef;
        // Makes sure it does nothing if bonus would be less than 0
        if (nSaveBoost < 0) nSaveBoost = 0;
        // Lower the save the appropriate amount.
        nDC -= nSaveBoost;
        DeleteLocalInt(oTarget, "IronMind_MindOverBody");
     }

    // Racial ability adjustments
    if(nSaveType == SAVING_THROW_TYPE_FIRE && GetHasFeat(FEAT_HARD_FIRE, oTarget))
        nDC -= 1 + (GetHitDice(oTarget) / 5);
    else if(nSaveType == SAVING_THROW_TYPE_COLD && GetHasFeat(FEAT_HARD_WATER, oTarget))
        nDC -= 1 + (GetHitDice(oTarget) / 5);
    else if(nSaveType == SAVING_THROW_TYPE_SONIC && GetHasFeat(FEAT_HARD_AIR, oTarget))
        nDC -= 1 + (GetHitDice(oTarget) / 5);
    else if(nSaveType == SAVING_THROW_TYPE_ELECTRICITY)
    {
        if(GetHasFeat(FEAT_HARD_AIR, oTarget))
            nDC -= 1 + (GetHitDice(oTarget) / 5);
        else if(GetHasFeat(FEAT_HARD_ELEC, oTarget))
            nDC -= 2;
    }
    else if(nSaveType == SAVING_THROW_TYPE_POISON && GetHasFeat(FEAT_POISON_4, oTarget))
        nDC -= 4;
    else if(nSaveType == SAVING_THROW_TYPE_POISON && GetHasFeat(FEAT_POISON_3, oTarget))
        nDC -= 3;
    else if(nSaveType == SAVING_THROW_TYPE_ACID && GetHasFeat(FEAT_HARD_EARTH, oTarget))
        nDC -= 1+(GetHitDice(oTarget)/5);

    // This ability removes evasion from the target
    if (GetLocalInt(oTarget, "TrueConfoundingResistance"))
    {
        // return the damage cut in half
        if (PRCMySavingThrow(SAVING_THROW_REFLEX, oTarget, nDC, nSaveType, oSaveVersus))
        {
            return nDamage / 2;
        }

        return nDamage;
    }
    // This Maneuver allows people to use a skill check instead of a save on a Reflex save
    if (GetLocalInt(oTarget, "ActionBeforeThought"))
    {
        // return the damage cut in half
        if (GetIsSkillSuccessful(oTarget, SKILL_CONCENTRATION, nDC))
        {
            return nDamage / 2;
        }

        return nDamage;
    }    

    // Do save
    nDamage = GetReflexAdjustedDamage(nDamage, oTarget, nDC, nSaveType, oSaveVersus);

    // Second Chance power reroll
    if(nDamage == nOriginalDamage                            &&     // Failed the save
       GetLocalInt(oTarget, "PRC_Power_SecondChance_Active") &&     // Second chance is active
       !GetLocalInt(oTarget, "PRC_Power_SecondChance_UserForRound") // And hasn't yet been used for this round
       )
    {
        // Reroll
        nDamage = GetReflexAdjustedDamage(nDamage, oTarget, nDC, nSaveType, oSaveVersus);

        // Can't use this ability again for a round
        SetLocalInt(oTarget, "PRC_Power_SecondChance_UserForRound", TRUE);
        DelayCommand(6.0f, DeleteLocalInt(oTarget, "PRC_Power_SecondChance_UserForRound"));
    }
    // Zealous Surge Reroll
    if(nDamage == nOriginalDamage  &&     // Failed the save
       GetLocalInt(oTarget, "ZealousSurge"))
    {
        // Reroll
        nDamage = GetReflexAdjustedDamage(nDamage, oTarget, nDC, nSaveType, oSaveVersus);

        // Ability Used
	DeleteLocalInt(oTarget, "ZealousSurge");
    }    

    return nDamage;
}

// function for internal use in GetCasterLvl

// caster level for divine base classes (with practiced spellcaster feats)
int GetCasterLvlDivine(int iClassType, object oCaster)
{
	if (GetFirstDivineClass(oCaster) == iClassType)
		return GetLevelByTypeDivine(oCaster);

	int iTemp = GetLevelByClass(iClassType, oCaster);
	iTemp += PractisedSpellcasting(oCaster, iClassType, iTemp);
	return iTemp;
}

// caster level for arcane base classes (with practiced spellcaster feats)
int GetCasterLvlArcane(int iClassType, object oCaster)
{
	if (GetFirstArcaneClass(oCaster) == iClassType)
		return GetLevelByTypeArcane(oCaster);

	int iTemp = GetLevelByClass(iClassType, oCaster);
	iTemp += PractisedSpellcasting(oCaster, iClassType, iTemp);
	return iTemp;
}

// caster level for classes with half progression
int GetCasterLvlDivineSemi(int iClassType, object oCaster)
{
	if (GetFirstDivineClass(oCaster) == iClassType)
		return GetLevelByTypeDivine(oCaster);
	else
		return GetLevelByClass(iClassType, oCaster) / 2;
}

// caster level for classes with half progression
int GetCasterLvlArcaneSemi(int iClassType, object oCaster)
{
	if (GetFirstArcaneClass(oCaster) == iClassType)
		return GetLevelByTypeArcane(oCaster);
	else
		return GetLevelByClass(iClassType, oCaster) / 2;
}

// caster level for classes with full progression
int GetCasterLvlArcaneFull(int iClassType, object oCaster)
{
	if (GetFirstArcaneClass(oCaster) == iClassType)
		return GetLevelByTypeArcane(oCaster);
	else
		return GetLevelByClass(iClassType, oCaster);
}

// caster level for classes with full progression
int GetCasterLvlDivineFull(int iClassType, object oCaster)
{
	if (GetFirstDivineClass(oCaster) == iClassType)
		return GetLevelByTypeDivine(oCaster);
	else
		return GetLevelByClass(iClassType, oCaster);
}

int GetCasterLvl(int iTypeSpell, object oCaster = OBJECT_SELF)
{
/*
    int iWiz = GetLevelByClass(CLASS_TYPE_WIZARD, oCaster);
    int iBrd = GetLevelByClass(CLASS_TYPE_BARD, oCaster);
    int iCle = GetLevelByClass(CLASS_TYPE_CLERIC, oCaster);
    int iDru = GetLevelByClass(CLASS_TYPE_DRUID, oCaster);
    int iPal = GetLevelByClass(CLASS_TYPE_PALADIN, oCaster);
    int iRan = GetLevelByClass(CLASS_TYPE_RANGER, oCaster);
    int iAss = GetLevelByClass(CLASS_TYPE_ASSASSIN, oCaster);
    int iFav = GetLevelByClass(CLASS_TYPE_FAVOURED_SOUL, oCaster);
    int iSue = GetLevelByClass(CLASS_TYPE_SUEL_ARCHANAMACH, oCaster);
    int iHex = GetLevelByClass(CLASS_TYPE_HEXBLADE, oCaster);
    int iDsk = GetLevelByClass(CLASS_TYPE_DUSKBLADE, oCaster);
    int iSoh = GetLevelByClass(CLASS_TYPE_SOHEI, oCaster);
    int iHlr = GetLevelByClass(CLASS_TYPE_HEALER, oCaster);
    int iSod = GetLevelByClass(CLASS_TYPE_SLAYER_OF_DOMIEL, oCaster);
    int iSha = GetLevelByClass(CLASS_TYPE_SHADOWLORD, oCaster);
    int iBlk = GetLevelByClass(CLASS_TYPE_BLACKGUARD, oCaster);
    int iVob = GetLevelByClass(CLASS_TYPE_VASSAL, oCaster);
    int iSol = GetLevelByClass(CLASS_TYPE_SOLDIER_OF_LIGHT, oCaster);
    int iKMc = GetLevelByClass(CLASS_TYPE_KNIGHT_MIDDLECIRCLE, oCaster);
    int iKCh = GetLevelByClass(CLASS_TYPE_KNIGHT_CHALICE, oCaster);
    int iVig = GetLevelByClass(CLASS_TYPE_VIGILANT, oCaster);
    int iAPl = GetLevelByClass(CLASS_TYPE_ANTI_PALADIN, oCaster);
    int iOcu = GetLevelByClass(CLASS_TYPE_OCULAR, oCaster);
    int iArc = GetLevelByTypeArcane(oCaster);
    int iDiv = GetLevelByTypeDivine(oCaster);
    int iSor = GetLevelByClass(CLASS_TYPE_SORCERER, oCaster);

	//Rakshasa include outsider HD as sorc
	if(!iSor && GetRacialType(oCaster) == RACIAL_TYPE_RAKSHASA)
		iSor = GetLevelByClass(CLASS_TYPE_OUTSIDER, oCaster);
*/

	int iTemp;
	switch (iTypeSpell)
	{
		case TYPE_ARCANE:
			return GetLevelByTypeArcane(oCaster);

		case TYPE_DIVINE:
			return GetLevelByTypeDivine(oCaster);

        case CLASS_TYPE_SORCERER:
		{
			if (GetFirstArcaneClass(oCaster) == CLASS_TYPE_SORCERER)
				return GetLevelByTypeArcane(oCaster);
			
			iTemp = GetLevelByClass(CLASS_TYPE_SORCERER, oCaster);

			//Rakshasa include outsider HD as sorc
			// motu99: shouldn't we add this to the sorc levels? Not sure, so left it the way it was
			if(!iTemp && GetRacialType(oCaster) == RACIAL_TYPE_RAKSHASA)
				iTemp = GetLevelByClass(CLASS_TYPE_OUTSIDER, oCaster);
			
			iTemp += PractisedSpellcasting(oCaster, CLASS_TYPE_SORCERER, iTemp);
			return iTemp;
		}

		case CLASS_TYPE_WIZARD:
			return GetCasterLvlArcane(CLASS_TYPE_WIZARD, oCaster);

		case CLASS_TYPE_BARD:
			return GetCasterLvlArcane(CLASS_TYPE_BARD, oCaster);
 
		case CLASS_TYPE_CLERIC:
			return GetCasterLvlDivine(CLASS_TYPE_CLERIC, oCaster);

		case CLASS_TYPE_DRUID:
			return GetCasterLvlDivine(CLASS_TYPE_DRUID, oCaster);

		case CLASS_TYPE_RANGER:
			return GetCasterLvlDivineSemi(CLASS_TYPE_RANGER, oCaster);

		case CLASS_TYPE_PALADIN:
			return GetCasterLvlDivineSemi(CLASS_TYPE_PALADIN, oCaster);

		//new spellbook classes
		case CLASS_TYPE_SHADOWLORD:
			return GetCasterLvlArcaneFull(CLASS_TYPE_SHADOWLORD, oCaster);

		case CLASS_TYPE_ASSASSIN:
			return GetCasterLvlArcaneFull(CLASS_TYPE_ASSASSIN, oCaster);

		case CLASS_TYPE_SUEL_ARCHANAMACH:
			return GetCasterLvlArcaneFull(CLASS_TYPE_SUEL_ARCHANAMACH, oCaster);
		
		case CLASS_TYPE_HEXBLADE:
			return GetCasterLvlArcaneSemi(CLASS_TYPE_HEXBLADE, oCaster);

		case CLASS_TYPE_DUSKBLADE:
			return GetCasterLvlArcaneFull(CLASS_TYPE_DUSKBLADE, oCaster);

		case CLASS_TYPE_FAVOURED_SOUL:
			return GetCasterLvlDivineFull(CLASS_TYPE_FAVOURED_SOUL, oCaster);

		case CLASS_TYPE_SOHEI:
			return GetCasterLvlDivineSemi(CLASS_TYPE_SOHEI, oCaster);

		case CLASS_TYPE_HEALER:
			return GetCasterLvlDivineFull(CLASS_TYPE_HEALER, oCaster);

		case CLASS_TYPE_SLAYER_OF_DOMIEL:
			return GetCasterLvlDivineFull(CLASS_TYPE_SLAYER_OF_DOMIEL, oCaster);
	
		case CLASS_TYPE_BLACKGUARD:
			return GetCasterLvlDivineFull(CLASS_TYPE_BLACKGUARD, oCaster);

		case CLASS_TYPE_VASSAL:
			return GetCasterLvlDivineFull(CLASS_TYPE_VASSAL, oCaster);

		case CLASS_TYPE_SOLDIER_OF_LIGHT:
			return GetCasterLvlDivineFull(CLASS_TYPE_SOLDIER_OF_LIGHT, oCaster);

        case CLASS_TYPE_KNIGHT_MIDDLECIRCLE:
			return GetCasterLvlDivineFull(CLASS_TYPE_KNIGHT_MIDDLECIRCLE, oCaster);

		case CLASS_TYPE_KNIGHT_CHALICE:
			return GetCasterLvlDivineFull(CLASS_TYPE_KNIGHT_CHALICE, oCaster);

		case CLASS_TYPE_VIGILANT:
			return GetCasterLvlDivineFull(CLASS_TYPE_VIGILANT, oCaster);

		case CLASS_TYPE_ANTI_PALADIN:
			return GetCasterLvlDivineSemi(CLASS_TYPE_ANTI_PALADIN, oCaster);

		case CLASS_TYPE_OCULAR:
			return GetCasterLvlDivineFull(CLASS_TYPE_OCULAR, oCaster);

		default:
			break;
	}
	return 0;
}



//wrapper for GetSpellTargetLocation()
location PRCGetSpellTargetLocation(object oCaster = OBJECT_SELF)
{
	// check if there is an override location on the module, and return that
	// bioware did not define a LOCATION_INVALID const, so we must signal a valid override location by setting a local int on the module
    if(GetLocalInt(GetModule(), PRC_SPELL_TARGET_LOCATION_OVERRIDE))
	{
		if (DEBUG) DoDebug("PRCGetSpellTargetLocation: found override target location on module");
        return GetLocalLocation(GetModule(), PRC_SPELL_TARGET_LOCATION_OVERRIDE);
	}


	// motu99: the following code retrieves an override location on the caster
	// this is when we want to cast area of effect spells instantly (e.g. not as an action), similar to CastSpellAtObject()
	// check if there is an override location on the caster, and return that
	// bioware did not define a LOCATION_INVALID const, so we signal a valid override location by setting a local int on oCaster
	if (GetLocalInt(oCaster, PRC_SPELL_TARGET_LOCATION_OVERRIDE))
	{
		if (DEBUG) DoDebug("PRCGetSpellTargetLocation: found override target location on caster "+GetName(oCaster));
		return GetLocalLocation(oCaster, PRC_SPELL_TARGET_LOCATION_OVERRIDE);
	}

	// object oItem     = GetSpellCastItem();
	object oItem     = PRCGetSpellCastItem(oCaster);

    // The rune always targets the one who activates it.
    if(GetResRef(oItem) == "prc_rune_1") return GetLocation(GetItemPossessor(oItem));

    return GetSpellTargetLocation();
}

//wrapper for GetSpellTargetObject()
object PRCGetSpellTargetObject(object oCaster   = OBJECT_SELF)
{
	if(GetLocalInt(oCaster, "PRC_EF_ARCANE_FIST"))
		return oCaster;

	object oSpellTarget;

	// is there an override target on the module? (this is only valid if a local int is set)
    if(GetLocalInt(GetModule(), PRC_SPELL_TARGET_OBJECT_OVERRIDE))
	{
		// this could also be an invalid target (so that the module builder can disable targeting)
		oSpellTarget = GetLocalObject(GetModule(), PRC_SPELL_TARGET_OBJECT_OVERRIDE);
		if (DEBUG) DoDebug("PRCGetSpellTargetObject: module override target = "+GetName(oSpellTarget)+", original target = "+GetName(GetSpellTargetObject()));
        return oSpellTarget;
	}

	// motu99: added code to put an override target on the caster
	// we might want to change the preference: so far module overrides have higher preference (to give module builders some extra power :-)
	// if we want caster overrides to have higher preference, put this before the module override check
	oSpellTarget = GetLocalObject(oCaster, PRC_SPELL_TARGET_OBJECT_OVERRIDE);
	if (GetIsObjectValid(oSpellTarget))
	{
		if (DEBUG) DoDebug("PRCGetSpellTargetObject: caster override target = "+GetName(oSpellTarget)+", original target = "+GetName(GetSpellTargetObject()));
		return oSpellTarget;
	}

	object oBWTarget = GetSpellTargetObject();
	int nSpellID     = PRCGetSpellId(oCaster);
		
	int bTouch = GetStringUpperCase(Get2DACache("spells", "Range", nSpellID)) == "T";
	// Reddopsi power causes spells and powers to rebound onto the caster.
	if(GetLocalInt(oBWTarget, "PRC_Power_Reddopsi_Active")                 &&  // Reddopsi is active on the target
		!GetLocalInt(oCaster, "PRC_Power_Reddopsi_Active")                  &&  // And not on the manifester
		!(nSpellID == SPELL_LESSER_DISPEL             ||                        // And the spell/power is not a dispelling one
		nSpellID == SPELL_DISPEL_MAGIC              ||
		nSpellID == SPELL_GREATER_DISPELLING        ||
		nSpellID == SPELL_MORDENKAINENS_DISJUNCTION ||
		nSpellID == POWER_DISPELPSIONICS
		)                                                                 &&
		!bTouch     // And the spell/power is not touch range
		)
		return oCaster;

    if(GetLocalInt(oBWTarget, "PRC_SPELL_TURNING") &&
        !(nSpellID == SPELL_LESSER_DISPEL             ||                        // And the spell/power is not a dispelling one
                 nSpellID == SPELL_DISPEL_MAGIC              ||
                 nSpellID == SPELL_GREATER_DISPELLING        ||
                 nSpellID == SPELL_MORDENKAINENS_DISJUNCTION ||
                 nSpellID == POWER_DISPELPSIONICS) &&
        !bTouch
        )
    {
        int nSpellLevel = StringToInt(Get2DACache("spells", "Innate", nSpellID));//lookup_spell_innate(nSpellID));
        object oTarget = oBWTarget;
        int nLevels = GetLocalInt(oTarget, "PRC_SPELL_TURNING_LEVELS");
        int bCasterTurning = GetLocalInt(oCaster, "PRC_SPELL_TURNING");
        int nCasterLevels = GetLocalInt(oCaster, "PRC_SPELL_TURNING_LEVELS");
        if(!bCasterTurning)
        {
            if(nSpellLevel > nLevels)
            {
                if((Random(nSpellLevel) + 1) <= nLevels)
                    oTarget = oCaster;
            }
            else
                oTarget = oCaster;
        }
        else
        {
            if((Random(nCasterLevels + nLevels) + 1) <= nLevels)
                oTarget = oCaster;
            nCasterLevels -= nSpellLevel;
            if(nCasterLevels < 0) nCasterLevels = 0;
            SetLocalInt(oCaster, "PRC_SPELL_TURNING_LEVELS", nCasterLevels);
        }
        nLevels -= nSpellLevel;
        if(nLevels < 0) nLevels = 0;
        SetLocalInt(oBWTarget, "PRC_SPELL_TURNING_LEVELS", nLevels);
        return oTarget;
    }

	// object oItem     = GetSpellCastItem();
	object oItem     = PRCGetSpellCastItem(oCaster);

    // The rune always targets the one who activates it.
    if(GetResRef(oItem) == "prc_rune_1")
    {
        if(DEBUG) DoDebug(GetName(oCaster) + " has cast a spell using a rune");
        // Making sure that the owner of the item is correct
        if (GetIsObjectValid(GetItemPossessor(oItem))) if(DEBUG) DoDebug(GetName(oCaster) + " is the owner of the Spellcasting item");
        return GetItemPossessor(oItem);
    }

    return oBWTarget;
}


////////////////Begin Spellsword//////////////////

//GetNextObjectInShape wrapper for changing the AOE of the channeled spells
object MyNextObjectInShape(int nShape,
                           float fSize, location lTarget,
                           int bLineOfSight = FALSE,
                           int nObjectFilter = OBJECT_TYPE_CREATURE,
                           vector vOrigin=[0.0, 0.0, 0.0])
{
    // War Wizard of Cormyr's Widen Spell ability
    if (DEBUG) DoDebug("Value for WarWizardOfCormyr_Widen: " + IntToString(GetLocalInt(OBJECT_SELF, "WarWizardOfCormyr_Widen")));
    if (DEBUG) DoDebug("Original Spell Size: " + FloatToString(fSize));
    if (GetLocalInt(OBJECT_SELF, "WarWizardOfCormyr_Widen"))
    {
        // At level 5 its 100% area increase
        if (GetLevelByClass(CLASS_TYPE_WAR_WIZARD_OF_CORMYR, OBJECT_SELF) >= 5) fSize *= 2;
        // At level 3 its 50% area increase
        else if (GetLevelByClass(CLASS_TYPE_WAR_WIZARD_OF_CORMYR, OBJECT_SELF) >= 3) fSize *= 1.5;
        if (DEBUG) DoDebug("Widened Spell Size: " + FloatToString(fSize));
        // This allows it to affect the entire casting
        DelayCommand(1.0, DeleteLocalInt(OBJECT_SELF, "WarWizardOfCormyr_Widen"));
    }

    int nChannel = GetLocalInt(OBJECT_SELF,"spellswd_aoe");
    if(nChannel != 1)
    {
        return GetNextObjectInShape(nShape,fSize,lTarget,bLineOfSight,nObjectFilter,vOrigin);
    }
    else
    {
        return OBJECT_INVALID;
    }
}


//GetFirstObjectInShape wrapper for changing the AOE of the channeled spells
object MyFirstObjectInShape(int nShape,
                            float fSize,
                            location lTarget,
                            int bLineOfSight = FALSE,
                            int nObjectFilter = OBJECT_TYPE_CREATURE,
                            vector vOrigin=[0.0, 0.0, 0.0])
{
	object oCaster = OBJECT_SELF;

    //int on caster for the benefit of spellfire wielder resistance
    // string sName = "IsAOE_" + IntToString(GetSpellId());
    string sName = "IsAOE_" + IntToString(PRCGetSpellId(oCaster));

    SetLocalInt(oCaster, sName, 1);
    DelayCommand(0.1, DeleteLocalInt(oCaster, sName));

    // War Wizard of Cormyr's Widen Spell ability
    if (DEBUG) DoDebug("Value for WarWizardOfCormyr_Widen: " + IntToString(GetLocalInt(oCaster, "WarWizardOfCormyr_Widen")));
    if (DEBUG) DoDebug("Original Spell Size: " + FloatToString(fSize));
    if (GetLocalInt(oCaster, "WarWizardOfCormyr_Widen"))
    {
        // At level 5 its 100% area increase
        if (GetLevelByClass(CLASS_TYPE_WAR_WIZARD_OF_CORMYR, oCaster) >= 5) fSize *= 2;
        // At level 3 its 50% area increase
        else if (GetLevelByClass(CLASS_TYPE_WAR_WIZARD_OF_CORMYR, oCaster) >= 3) fSize *= 1.5;
        if (DEBUG) DoDebug("Widened Spell Size: " + FloatToString(fSize));
        // This allows it to affect the entire casting
        DelayCommand(1.0, DeleteLocalInt(oCaster, "WarWizardOfCormyr_Widen"));
    }

    int nChannel = GetLocalInt(oCaster,"spellswd_aoe");
    if(nChannel != 1)
    {
        return GetFirstObjectInShape(nShape,fSize,lTarget,bLineOfSight,nObjectFilter,vOrigin);
    }
    else
    {
        return PRCGetSpellTargetObject(oCaster);
    }
}


//This checks if the spell is channeled and if there are multiple spells
//channeled, which one is it. Then it checks in either case if the spell
//has the metamagic feat the function gets and returns TRUE or FALSE accordingly
//Also used by the new spellbooks for the same purpose
/* replaced by wrapper for GetMetaMagicFeat instead
   Not necessarily. This may still be a usefule level of abstraction - Ornedan
   */
int CheckMetaMagic(int nMeta,int nMMagic)
{
    return nMeta & nMMagic;
}

int PRCGetMetaMagicFeat(object oCaster = OBJECT_SELF)
{

    int nOverride = GetLocalInt(oCaster, PRC_METAMAGIC_OVERRIDE);
    if(nOverride)
	{
		if (DEBUG) DoDebug("PRCGetMetaMagicFeat: found override metamagic = "+IntToString(nOverride)+", original = "+IntToString(GetMetaMagicFeat()));
        return nOverride;
	}

    int nFeat = GetMetaMagicFeat();

	// object oItem = GetSpellCastItem();	
	object oItem = PRCGetSpellCastItem(oCaster);	
    if(GetIsObjectValid(oItem))
        nFeat = 0;//biobug, this isn't reset to zero by casting from an item
	
    int nSSFeat = GetLocalInt(oCaster, PRC_METAMAGIC_ADJUSTMENT);
    int nNewSpellMetamagic = GetLocalInt(oCaster, "NewSpellMetamagic");
    if(nNewSpellMetamagic)
        nFeat = nNewSpellMetamagic-1;
    if(nSSFeat)
        nFeat = nSSFeat;

    // Suel Archanamach's Extend spells they cast on themselves.
    // Only works for Suel Spells, and not any other caster type they might have
    // Since this is a spellscript, it assumes OBJECT_SELF is the caster
    if (GetLevelByClass(CLASS_TYPE_SUEL_ARCHANAMACH) >= 3 && PRCGetLastSpellCastClass(oCaster) == CLASS_TYPE_SUEL_ARCHANAMACH)
    {
        // Check that they cast on themselves
        // if (oCaster == GetSpellTargetObject())
        if (oCaster == PRCGetSpellTargetObject(oCaster))
        {
            // Add extend to the metamagic feat using bitwise math
            nFeat |= METAMAGIC_EXTEND;
        }
    }
    // Magical Contraction, Truenaming Utterance
    if (GetLocalInt(oCaster, "TrueMagicalContraction"))
    {
        nFeat |= METAMAGIC_EXTEND;
    }

	if(GetIsObjectValid(oItem))
    {
        // int iSpellId = PRCGetSpellId();
        int iSpellId = PRCGetSpellId(oCaster);

        //check item for metamagic
        int nItemMetaMagic;
        itemproperty ipTest = GetFirstItemProperty(oItem);
        while(GetIsItemPropertyValid(ipTest))
        {
            if(GetItemPropertyType(ipTest) == ITEM_PROPERTY_CAST_SPELL_METAMAGIC)
            {
                int nSubType = GetItemPropertySubType(ipTest);
                nSubType = StringToInt(Get2DACache("iprp_spells", "SpellIndex", nSubType));
                if(nSubType == iSpellId)
                {
                    int nCostValue = GetItemPropertyCostTableValue(ipTest);
                    if(nCostValue == -1 && DEBUG)
                        DoDebug("Problem examining itemproperty");
                    switch(nCostValue)
                    {
                        //bitwise "addition" equivalent to nFeat = (nFeat | nSSFeat)
                        case 0:
                            nItemMetaMagic |= METAMAGIC_NONE;
                            break;
                        case 1:
                            nItemMetaMagic |= METAMAGIC_QUICKEN;
                            break;
                        case 2:
                            nItemMetaMagic |= METAMAGIC_EMPOWER;
                            break;
                        case 3:
                            nItemMetaMagic |= METAMAGIC_EXTEND;
                            break;
                        case 4:
                            nItemMetaMagic |= METAMAGIC_MAXIMIZE;
                            break;
                        case 5:
                            nItemMetaMagic |= METAMAGIC_SILENT;
                            break;
                        case 6:
                            nItemMetaMagic |= METAMAGIC_STILL;
                            break;
                    }
                }
            }
            ipTest = GetNextItemProperty(oItem);
        }
        nFeat = nItemMetaMagic;
    }
	// if (DEBUG) DoDebug("PRCGetMetaMagicFeat: returning " +IntToString(nFeat));
    return nFeat;
}


//Wrapper for The MaximizeOrEmpower function that checks for metamagic feats
//in channeled spells as well
int PRCMaximizeOrEmpower(int nDice, int nNumberOfDice, int nMeta, int nBonus = 0)
{
    int i = 0;
    int nDamage = 0;
    int nChannel = GetLocalInt(OBJECT_SELF,"spellswd_aoe");
    int nFeat = GetLocalInt(OBJECT_SELF,"spell_metamagic");
    int nDiceDamage;
    for (i=1; i<=nNumberOfDice; i++)
    {
        nDiceDamage = nDiceDamage + Random(nDice) + 1;
    }
    nDamage = nDiceDamage;
    //Resolve metamagic
    if (nMeta & METAMAGIC_MAXIMIZE || nFeat & METAMAGIC_MAXIMIZE)
//    if ((nMeta & METAMAGIC_MAXIMIZE))
    {
        nDamage = nDice * nNumberOfDice;
    }
    if (nMeta & METAMAGIC_EMPOWER || nFeat & METAMAGIC_EMPOWER)
//    else if ((nMeta & METAMAGIC_EMPOWER))
    {
       nDamage = nDamage + nDamage / 2;
    }
    return nDamage + nBonus;
}

int PRCGetSpellId(object oCaster = OBJECT_SELF)
{
    int nID = GetLocalInt(oCaster, PRC_SPELLID_OVERRIDE);
    if(!nID)
        return GetSpellId();

	if (DEBUG) DoDebug("PRCGetSpellId: found override spell id = "+IntToString(nID)+", original id = "+IntToString(GetSpellId()));

    if(nID == -1)
        nID = 0;
    return nID;
}

void SPEvilShift(object oPC)
{
    // Check for alignment shift switch being active
    if(GetPRCSwitch(PRC_SPELL_ALIGNMENT_SHIFT))
    {
        // Amount of adjustment is equal to the square root of your distance from pure evil.
        // In other words, the amount of shift is higher the farther you are from pure evil, with the
        // extremes being 10 points of shift at pure good and 0 points of shift at pure evil.
        AdjustAlignment(oPC, ALIGNMENT_EVIL,  FloatToInt(sqrt(IntToFloat(GetGoodEvilValue(oPC)))));
    }
}

void SPGoodShift(object oPC)
{
    // Check for alignment shift switch being active
    if(GetPRCSwitch(PRC_SPELL_ALIGNMENT_SHIFT))
    {
        // Amount of adjustment is equal to the square root of your distance from pure good.
        // In other words, the amount of shift is higher the farther you are from pure good, with the
        // extremes being 10 points of shift at pure evil and 0 points of shift at pure good.
        AdjustAlignment(oPC, ALIGNMENT_GOOD, FloatToInt(sqrt(IntToFloat(100 - GetGoodEvilValue(oPC)))));
    }
}

void DoCorruptionCost(object oPC, int nAbility, int nCost, int bDrain)
{
    // Undead redirect all damage & drain to Charisma, sez http://www.wizards.com/dnd/files/BookVileFAQ12102002.zip
    if(MyPRCGetRacialType(oPC) == RACIAL_TYPE_UNDEAD)
        nAbility = ABILITY_CHARISMA;

    //Exalted Raiment
    if(GetHasSpellEffect(SPELL_EXALTED_RAIMENT, GetItemInSlot(INVENTORY_SLOT_CHEST, oPC)))
    {
        nCost -= 1;
    }

    // Is it ability drain?
    if(bDrain)
        ApplyAbilityDamage(oPC, nAbility, nCost, DURATION_TYPE_PERMANENT, TRUE);
    // Or damage
    else
        ApplyAbilityDamage(oPC, nAbility, nCost, DURATION_TYPE_TEMPORARY, TRUE, -1.0f);
}


//This function returns 1 only if the object oTarget is the object
//the weapon hit when it channeled the spell sSpell or if there is no
//channeling at all
int ChannelChecker(string sSpell, object oTarget)
{
    int nSpell = GetLocalInt(GetAreaOfEffectCreator(), sSpell+"channeled");
    int nTarget = GetLocalInt(oTarget, sSpell+"target");
    if(nSpell == 1 && nTarget == 1)
    {
        return 1;
    }
    else if(nSpell != 1 && nTarget != 1)
    {
        return 1;
    }
    else
    {
        return 0;
    }
}

//If a spell is being channeled, we store its target and its name
void StoreSpellVariables(string sString,int nDuration)
{
	object oCaster = OBJECT_SELF;
	object oTarget = PRCGetSpellTargetObject(oCaster);
	
    if(GetLocalInt(oCaster,"spellswd_aoe") == 1)
    {
        SetLocalInt(oCaster, sString+"channeled",1);
        SetLocalInt(oTarget, sString+"target",1);
    }
    DelayCommand(RoundsToSeconds(nDuration),DeleteLocalInt(oTarget, sString+"target"));
    DelayCommand(RoundsToSeconds(nDuration),DeleteLocalInt(oCaster, sString+"channeled"));
}

effect ChannelingVisual()
{
    return EffectVisualEffect(VFX_DUR_SPELLTURNING);
}

////////////////End Spellsword//////////////////

/* Healing spell filter
 *
 * This function will take a spell ID, run it through a list of existing healing spells
 * and return TRUE if the spell ID corresponded to one of them. This is needed for at least
 * the Healing Kicker ability of the Combat Medic, which adds an extra effect to the next
 * healing spell cast.
 *
 * The list of spells is by no means authoritative - it's not 100% clear whether some spells
 * make the cut or not (see Nature's balance, for instance) and the list may expand in the
 * future. Revise and add on as necessary.
 *
 * Author: GaiaWerewolf
 * Date: 18 July 2005
 */
int GetIsHealingSpell(int nSpellId)
{
    if (  nSpellId == SPELL_CURE_CRITICAL_WOUNDS
       || nSpellId == SPELL_CURE_LIGHT_WOUNDS
       || nSpellId == SPELL_CURE_MINOR_WOUNDS
       || nSpellId == SPELL_CURE_MODERATE_WOUNDS
       || nSpellId == SPELL_CURE_SERIOUS_WOUNDS
       || nSpellId == SPELL_GREATER_RESTORATION
       || nSpellId == SPELL_HEAL
       || nSpellId == SPELL_HEALING_CIRCLE
       || nSpellId == SPELL_MASS_HEAL
       || nSpellId == SPELL_MONSTROUS_REGENERATION
       || nSpellId == SPELL_REGENERATE
       //End of stock NWN spells
       || nSpellId == SPELL_FOM_DIVINE_SONG_CURELIGHT
       || nSpellId == SPELL_FOM_DIVINE_SONG_CUREMODERATE
       || nSpellId == SPELL_FOM_DIVINE_SONG_CURESERIOUS
       || nSpellId == SPELL_FOM_DIVINE_SONG_CURECRITICAL
       || nSpellId == SPELL_FOM_DIVINE_SONG_MONSTREGEN
       || nSpellId == SPELL_CORRUPTER_CURE_LIGHT_WOUNDS
       || nSpellId == SPELL_CORRUPTER_CURE_MODERATE_WOUNDS
       || nSpellId == SPELL_CORRUPTER_CURE_SERIOUS_WOUNDS
       || nSpellId == SPELL_MASS_CURE_LIGHT
       || nSpellId == SPELL_MASS_CURE_MODERATE
       || nSpellId == SPELL_MASS_CURE_SERIOUS
       || nSpellId == SPELL_MASS_CURE_CRITICAL
       || nSpellId == SPELL_PANACEA
       //End of PRC spells which have a defined constant
       //Start of spells from Primogenitor's spellbook system
//this is not needed, since it fake casts the normal spells listed above
//Primogenitor
/*       || nSpellId == 13001 || nSpellId == 13002
       || nSpellId == 13003 || nSpellId == 13004
       || nSpellId == 13005 || nSpellId == 13030
       || nSpellId == 13031 || nSpellId == 13032
       || nSpellId == 13033 || nSpellId == 13045
       || nSpellId == 13046 || nSpellId == 13047
       || nSpellId == 13070 || nSpellId == 13125
       || nSpellId == 13126 || nSpellId == 13127
       || nSpellId == 13128 || nSpellId == 13129
       || nSpellId == 13152 || nSpellId == 13153
       || nSpellId == 13154 || nSpellId == 13155
       || nSpellId == 13175 || nSpellId == 13176
       || nSpellId == 13177 || nSpellId == 13189
       || nSpellId == 13202 || nSpellId == 13203
       || nSpellId == 13204 || nSpellId == 13205
       || nSpellId == 13230 */
       )
        return TRUE;

    return FALSE;
}

int GetHasMettle(object oTarget, int nSavingThrow)
{
    int nMettle = FALSE;
    object oArmour = GetItemInSlot(INVENTORY_SLOT_CHEST);

    if (nSavingThrow = SAVING_THROW_WILL)
    {
        // Iron Mind's ability only functions in Heavy Armour
        if (GetLevelByClass(CLASS_TYPE_IRONMIND, oTarget) >= 5 && GetBaseAC(oArmour) >= 6) nMettle = TRUE;
        else if (GetLevelByClass(CLASS_TYPE_HEXBLADE, oTarget) >= 3) nMettle = TRUE;
        else if (GetLevelByClass(CLASS_TYPE_SOHEI, oTarget) >= 9) nMettle = TRUE;
        else if (GetLevelByClass(CLASS_TYPE_CRUSADER, oTarget) >= 13) nMettle = TRUE;
        // Fill out the line below to add another class with Will mettle
        // else if (GetLevelByClass(CLASS_TYPE_X, oTarget) >= X) nMettle = TRUE;
    }
    if (nSavingThrow = SAVING_THROW_FORT)
    {
        // Add Classes with Fort mettle here
        if (GetLevelByClass(CLASS_TYPE_HEXBLADE, oTarget) >= 3) nMettle = TRUE;
        else if (GetLevelByClass(CLASS_TYPE_SOHEI, oTarget) >= 9) nMettle = TRUE;
        else if (GetLevelByClass(CLASS_TYPE_CRUSADER, oTarget) >= 13) nMettle = TRUE;
    }

    return nMettle;
}

void DoCommandSpell(object oCaster, object oTarget, int nSpellId, int nDuration, int nCaster)
{
    if(DEBUG) DoDebug("Command Spell: Begin");
    if (nSpellId == SPELL_COMMAND_APPROACH || nSpellId == SPELL_GREATER_COMMAND_APPROACH ||
        nSpellId == SPELL_DOA_COMMAND_APPROACH || nSpellId == SPELL_DOA_GREATER_COMMAND_APPROACH)
    {
        // Force the target to approach the caster
        if(DEBUG) DoDebug("Command Spell: Approach");
        AssignCommand(oTarget, ClearAllActions(TRUE));
        AssignCommand(oTarget, ActionForceMoveToObject(oCaster, TRUE));
    }
    // Creatures that can't be disarmed ignore this
    else if ((nSpellId == SPELL_COMMAND_DROP && GetIsCreatureDisarmable(oTarget)) ||
             (nSpellId == SPELL_GREATER_COMMAND_DROP && GetIsCreatureDisarmable(oTarget)) ||
             (nSpellId == SPELL_DOA_COMMAND_DROP && GetIsCreatureDisarmable(oTarget)) ||
             (nSpellId == SPELL_DOA_GREATER_COMMAND_DROP && GetIsCreatureDisarmable(oTarget)))
    {
        // Force the target to drop what its holding
        if(DEBUG) DoDebug("Command Spell: Drop");
        AssignCommand(oTarget, ClearAllActions(TRUE));
        AssignCommand(oTarget, ActionPutDownItem(GetItemInSlot(INVENTORY_SLOT_RIGHTHAND, oTarget)));
        AssignCommand(oTarget, ActionPutDownItem(GetItemInSlot(INVENTORY_SLOT_LEFTHAND, oTarget)));
    }
    else if (nSpellId == SPELL_COMMAND_FALL || nSpellId == SPELL_GREATER_COMMAND_FALL ||
             nSpellId == SPELL_DOA_COMMAND_FALL || nSpellId == SPELL_DOA_GREATER_COMMAND_FALL)
    {
        // Force the target to fall down
        if(DEBUG) DoDebug("Command Spell: Fall");
        AssignCommand(oTarget, ClearAllActions(TRUE));
        SPApplyEffectToObject(DURATION_TYPE_TEMPORARY, EffectKnockdown(), oTarget, RoundsToSeconds(nDuration),TRUE,-1,nCaster);
    }
    else if (nSpellId == SPELL_COMMAND_FLEE || nSpellId == SPELL_GREATER_COMMAND_FLEE ||
             nSpellId == SPELL_DOA_COMMAND_FLEE || nSpellId == SPELL_DOA_GREATER_COMMAND_FLEE)
    {
        // Force the target to flee the caster
        if(DEBUG) DoDebug("Command Spell: Flee");
        AssignCommand(oTarget, ClearAllActions(TRUE));
        AssignCommand(oTarget, ActionMoveAwayFromObject(oCaster, TRUE));
    }
    else if (nSpellId == SPELL_COMMAND_HALT || nSpellId == SPELL_GREATER_COMMAND_HALT ||
             nSpellId == SPELL_DOA_COMMAND_HALT || nSpellId == SPELL_DOA_GREATER_COMMAND_HALT)
    {
        // Force the target to stand still
        if(DEBUG) DoDebug("Command Spell: Stand"); 
        AssignCommand(oTarget, ClearAllActions(TRUE));
        SPApplyEffectToObject(DURATION_TYPE_TEMPORARY, EffectCutsceneParalyze(), oTarget, RoundsToSeconds(nDuration),TRUE,-1,nCaster);
    }
    else // Catch errors here
    {
        if (!GetIsCreatureDisarmable(oTarget))
        {
            FloatingTextStringOnCreature(GetName(oTarget) + " is not disarmable.", oCaster, FALSE);
        }
        else
        {
            FloatingTextStringOnCreature("sp_command/sp_greatcommand: Error, Unknown SpellId", oCaster, FALSE);
        }
    }
    if(DEBUG) DoDebug("Command Spell: End");
}

int GetIsIncorporeal(object oTarget)
{
    int bIncorporeal = FALSE;

    //base it on appearance
    int nAppear = GetAppearanceType(oTarget);
    if(nAppear == APPEARANCE_TYPE_ALLIP
        || nAppear == APPEARANCE_TYPE_SHADOW
        ||nAppear == APPEARANCE_TYPE_SHADOW_FIEND
        ||nAppear == APPEARANCE_TYPE_SPECTRE
        ||nAppear == APPEARANCE_TYPE_WRAITH)
    {
        bIncorporeal = TRUE;
    }

    //Check for local int
    if(GetPersistantLocalInt(oTarget, "Is_Incorporeal"))
        bIncorporeal = TRUE;

    //check for feat
    if(GetHasFeat(FEAT_INCORPOREAL, oTarget))
        bIncorporeal = TRUE;

    //Return value
    return bIncorporeal;
}


int GetIsEthereal(object oTarget)
{
    int bEthereal = FALSE;

    //Check for local int
    if(GetPersistantLocalInt(oTarget, "Is_Ethereal"))
        bEthereal = TRUE;

    //check for feat
    if(GetHasFeat(FEAT_ETHEREAL, oTarget))
        bEthereal = TRUE;

    //Return value
    return bEthereal;
}


int GetControlledUndeadTotalHD(object oPC = OBJECT_SELF)
{
    int nTotalHD;
    int i = 1;
    object oSummonTest = GetAssociate(ASSOCIATE_TYPE_SUMMONED, oPC, i);
    while(GetIsObjectValid(oSummonTest))
    {
        if(MyPRCGetRacialType(oSummonTest) == RACIAL_TYPE_UNDEAD)
            nTotalHD += GetHitDice(oSummonTest);
        if(DEBUG)FloatingTextStringOnCreature(GetName(oSummonTest)+" is summon number "+IntToString(i), oPC);
        i++;
        oSummonTest = GetAssociate(ASSOCIATE_TYPE_SUMMONED, oPC, i);
    }
    return nTotalHD;
}


int GetControlledFiendTotalHD(object oPC = OBJECT_SELF)
{
    int nTotalHD;
    int i = 1;
    object oSummonTest = GetAssociate(ASSOCIATE_TYPE_SUMMONED, oPC, i);
    while(GetIsObjectValid(oSummonTest))
    {
        if(MyPRCGetRacialType(oSummonTest) == RACIAL_TYPE_OUTSIDER
             && GetAlignmentGoodEvil(oSummonTest) == ALIGNMENT_EVIL)
            nTotalHD += GetHitDice(oSummonTest);
        if(DEBUG)FloatingTextStringOnCreature(GetName(oSummonTest)+" is summon number "+IntToString(i), oPC);
        i++;
        oSummonTest = GetAssociate(ASSOCIATE_TYPE_SUMMONED, oPC, i);
    }
    return nTotalHD;
}

int GetControlledCelestialTotalHD(object oPC = OBJECT_SELF)
{
    int nTotalHD;
    int i = 1;
    object oSummonTest = GetAssociate(ASSOCIATE_TYPE_SUMMONED, oPC, i);
    while(GetIsObjectValid(oSummonTest))
    {
        if(MyPRCGetRacialType(oSummonTest) == RACIAL_TYPE_OUTSIDER
             && GetAlignmentGoodEvil(oSummonTest) == ALIGNMENT_GOOD)
            nTotalHD += GetHitDice(oSummonTest);
        if(DEBUG)FloatingTextStringOnCreature(GetName(oSummonTest)+" is summon number "+IntToString(i), oPC);
        i++;
        oSummonTest = GetAssociate(ASSOCIATE_TYPE_SUMMONED, oPC, i);
    }
    return nTotalHD;
}

// returns if a character should be using the newspellbook when casting
int UseNewSpellBook(object oCreature)
{
    int nFirstArcane = GetFirstArcaneClass(oCreature);
    //check they have bard/sorc in first arcane slot
    if(nFirstArcane != CLASS_TYPE_BARD && nFirstArcane != CLASS_TYPE_SORCERER)
        return FALSE;
    //check they have arcane PrC
    if(!GetArcanePRCLevels(oCreature))
        return FALSE;
    //check if the newspellbooks are disabled
    if((GetPRCSwitch(PRC_SORC_DISALLOW_NEWSPELLBOOK) && nFirstArcane == CLASS_TYPE_SORCERER) ||
        (GetPRCSwitch(PRC_BARD_DISALLOW_NEWSPELLBOOK) && nFirstArcane == CLASS_TYPE_BARD))
        return FALSE;
    //check they have bard/sorc levels
    if(!GetLevelByClass(CLASS_TYPE_BARD) && !GetLevelByClass(CLASS_TYPE_SORCERER))
        return FALSE;

    //at this point, they should be using the new spellbook
    return TRUE;
}

// wrapper for DecrementRemainingSpellUses, works for newspellbook 'fake' spells too
void PRCDecrementRemainingSpellUses(object oCreature, int nSpell)
{
    if (!UseNewSpellBook(oCreature) && GetHasSpell(nSpell, oCreature)) {
        DecrementRemainingSpellUses(oCreature, nSpell);
        return;
    }

    int i;
    for(i=1;i<=3;i++)
    {
        int nClass = PRCGetClassByPosition(i, oCreature);
        int nLevel = GetLevelByClass(nClass, oCreature);
        if (nLevel && GetSpellUses(oCreature, nSpell, nClass))
        {
            RemoveSpellUse(oCreature, nSpell, nClass);
            return;
        }
    }
}

// wrapper for GetHasSpell, works for newspellbook 'fake' spells too
// should return 0 if called with a normal spell when a character should be using the newspellbook
int PRCGetHasSpell(int nSpell, object oCreature = OBJECT_SELF)
{
    int nUses = 0;

    if (!UseNewSpellBook(oCreature))
    {
        nUses += GetHasSpell(nSpell, oCreature);
    }

    int nSpellbookID = SpellToSpellbookID(nSpell);
    if (nSpellbookID != -1)
    {
        int i;
        for(i=1;i<=3;i++)
        {
            int nClass = PRCGetClassByPosition(i, oCreature);
            if(GetLevelByClass(nClass, oCreature))
                nUses += GetSpellUses(oCreature, nSpell, nClass);
        }
    }
    if(DEBUG) DoDebug("PRCGetHasSpell: " + IntToString(nSpell) + ", " + IntToString(nUses));
    return nUses;
}

// returns the spelllevel of nSpell as it can be cast by oCreature
int PRCGetSpellLevel(object oCreature, int nSpell)
{
    if (!PRCGetHasSpell(nSpell, oCreature))
        return -1;

    int i;
    for(i=1;i<=3;i++)
    {
        int nClass = PRCGetClassByPosition(i, oCreature);
        int nCharLevel = GetLevelByClass(nClass, oCreature);
        if (nCharLevel)
        {

            string sSpellLevel = "";
            if (nClass == CLASS_TYPE_WIZARD || nClass == CLASS_TYPE_SORCERER)
                sSpellLevel = Get2DACache("spells", "Wiz_Sorc", nSpell);
            else if (nClass == CLASS_TYPE_RANGER)
                sSpellLevel = Get2DACache("spells", "Ranger", nSpell);
            else if (nClass == CLASS_TYPE_PALADIN)
                sSpellLevel = Get2DACache("spells", "Paladin", nSpell);
            else if (nClass == CLASS_TYPE_DRUID)
                sSpellLevel = Get2DACache("spells", "Druid", nSpell);
            else if (nClass == CLASS_TYPE_CLERIC)
                sSpellLevel = Get2DACache("spells", "Cleric", nSpell);
            else if (nClass == CLASS_TYPE_BARD)
                sSpellLevel = Get2DACache("spells", "Bard", nSpell);

            if (sSpellLevel != "")
                return StringToInt(sSpellLevel);

            int nSpellLevel = GetSpellLevel(oCreature, nSpell, nClass);

            if (nSpellLevel != -1)
                return nSpellLevel;

        }
    }

    //return innate level?
    return -1;
}
