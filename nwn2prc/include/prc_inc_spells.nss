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
int PRCGetLastSpellCastClass();

// wrapper for getspelltargetlocation
location PRCGetSpellTargetLocation();

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
object PRCGetSpellTargetObject();


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
 * @param oCaster  The caster of the Corrupt spell
 * @param oTarget  The target of the spell.
 *                 Not used for anything, should probably remove - Ornedan
 * @param nAbility ABILITY_* of the ability to apply the cost to
 * @param nCost    The amount of stat damage or drain to apply
 * @param bDrain   If this is TRUE, the cost is applied as ability drain.
 *                 If FALSE, as ability damage.
 */
void DoCorruptionCost(object oCaster, int nAbility, int nCost, int bDrain);

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
int PRCGetMetaMagicFeat();

//wrapper for biowares PRCGetSpellId()
//used for actioncastspell
int PRCGetSpellId();

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

    if (iSpellID = -1) iSpellID = PRCGetSpellId();

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

    if (iSpellID = -1) iSpellID = PRCGetSpellId();

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

int PRCGetLastSpellCastClass()
{
    int nClass;
    if(GetLocalInt(OBJECT_SELF, PRC_CASTERCLASS_OVERRIDE))
        return GetLocalInt(OBJECT_SELF, PRC_CASTERCLASS_OVERRIDE);
    return GetLastSpellCastClass();
}

int PRCGetCasterLevel(object oCaster = OBJECT_SELF)
{
    int iCastingClass = PRCGetLastSpellCastClass(); // might be CLASS_TYPE_INVALID

    int iSpellId = PRCGetSpellId();
    int bIsStaff = FALSE;
    int nItemLevel;
    object oItem = GetSpellCastItem();
    int nAdjust = GetLocalInt(oCaster, PRC_CASTERLEVEL_ADJUSTMENT);//this is for builder use
    nAdjust += GetLocalInt(oCaster, "TrueCasterLens");
    //DelayCommand(1.0, DeleteLocalInt(oCaster, "PRC_Castlevel_Adjustment"));
    int iArcLevel;
    int iDivLevel;
    int iReturnLevel;
    int iItemLevel;

    // For when you want to assign the caster level.
    if (GetLocalInt(oCaster, PRC_CASTERLEVEL_OVERRIDE))
    {
        //SendMessageToPC(oCaster, "Forced-level casting at level " + IntToString(GetCasterLevel(oCaster)));

        //DelayCommand(1.0, DeleteLocalInt(oCaster, PRC_CASTERLEVEL_OVERRIDE));
        return GetLocalInt(oCaster, PRC_CASTERLEVEL_OVERRIDE)+nAdjust;
    }

    // Item Spells
    if (GetItemPossessor(oItem) == oCaster)
    {
        //SendMessageToPC(oCaster, "Item casting at level " + IntToString(GetCasterLevel(oCaster)));
        if(GetPRCSwitch(PRC_STAFF_CASTER_LEVEL)
            && GetBaseItemType(oItem) == BASE_ITEM_MAGICSTAFF)
        {
            iCastingClass = GetFirstArcaneClass(oCaster);//sets it to an arcane class
        }
        else
        {
            iItemLevel = GetCasterLevel(oCaster);
            //code for getting new ip type
            itemproperty ipTest = GetFirstItemProperty(oItem);
            while(GetIsItemPropertyValid(ipTest) && !iItemLevel)
            {
                if(GetItemPropertyType(ipTest) == ITEM_PROPERTY_CAST_SPELL_CASTER_LEVEL)
                {
                    int nSubType = GetItemPropertySubType(ipTest);
                    nSubType = StringToInt(Get2DACache("iprp_spells", "SpellIndex", nSubType));
                    if(nSubType == iSpellId)
                        iItemLevel = GetItemPropertyCostTableValue (ipTest);
                }
                ipTest = GetNextItemProperty(oItem);
            }
        }
    }

    iArcLevel = GetLevelByClass(iCastingClass, oCaster);
    if (GetFirstArcaneClass(oCaster) == iCastingClass)
    {
        iArcLevel += GetArcanePRCLevels(oCaster)
                  +  ArchmageSpellPower(oCaster);
    }
    iArcLevel += TrueNecromancy(oCaster, iSpellId, "ARCANE")
              +  ShadowWeave(oCaster, iSpellId)
              +  FireAdept(oCaster, iSpellId)
              +  StormMagic(oCaster)
              +  DomainPower(oCaster, iSpellId)
              +  DeathKnell(oCaster);

    iArcLevel += PractisedSpellcasting(oCaster, iCastingClass, iArcLevel); //gotta be the last one


    iDivLevel = GetLevelByClass(iCastingClass, oCaster);
    if (iCastingClass == CLASS_TYPE_RANGER
        || iCastingClass == CLASS_TYPE_PALADIN
        || iCastingClass == CLASS_TYPE_ANTI_PALADIN)
        iDivLevel = iDivLevel / 2;
    if (GetFirstDivineClass(oCaster) == iCastingClass)
        iDivLevel += GetDivinePRCLevels(oCaster);
    iDivLevel += TrueNecromancy(oCaster, iSpellId, "DIVINE")
              +  ShadowWeave(oCaster, iSpellId)
              +  FireAdept(oCaster, iSpellId)
              +  StormMagic(oCaster)
              +  DomainPower(oCaster, iSpellId)
              +  DeathKnell(oCaster);
    iDivLevel += PractisedSpellcasting(oCaster, iCastingClass, iDivLevel); //gotta be the last one

    if(GetIsArcaneClass(iCastingClass, oCaster))
        iReturnLevel = iArcLevel;
    else if(GetIsDivineClass(iCastingClass, oCaster))
        iReturnLevel = iDivLevel;
    //items override arcane/divine
    if(iItemLevel)
        iReturnLevel = iItemLevel;
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
    int iCleLevel = GetLevelByClass(CLASS_TYPE_CLERIC, oCaster);
    int iSorLevel = GetLevelByClass(CLASS_TYPE_SORCERER, oCaster);
    int iWizLevel = GetLevelByClass(CLASS_TYPE_WIZARD, oCaster);
    // Either iSorLevel or iWizLevel will be 0 if the class is a true necro
    int iSpellSchool = GetSpellSchool(iSpellID);

    if (!iTNLevel) return 0;

    if (iSpellSchool != SPELL_SCHOOL_NECROMANCY) return 0;

    if (sType == "ARCANE") return iCleLevel; // TN and arcane levels already added.

    if (sType == "DIVINE") return iSorLevel + iWizLevel + iTNLevel; // cleric levels already added.

    return 0;
}

int StormMagic(object oCaster)
{
    if (!GetHasFeat(FEAT_STORMMAGIC,oCaster)) return 0;

    object oArea = GetArea(oCaster);

    if (GetWeather(oArea, WEATHER_TYPE_RAIN) > 0 ||
        GetWeather(oArea, WEATHER_TYPE_SNOW) > 0  || 
        GetWeather(oArea, WEATHER_TYPE_LIGHTNING) > 0)
    {
        return 1;
    }
    return 0;
}

int DomainPower(object oCaster, int nSpellID)
{
    int nBonus = 0;

        // Boosts Caster level with the Illusion school by 1
    if (GetHasFeat(FEAT_DOMAIN_POWER_GNOME, oCaster) && GetSpellSchool(nSpellID) == SPELL_SCHOOL_ILLUSION)
    {
        nBonus += 1;
    }
        // Boosts Caster level with the Illusion school by 1
    if (GetHasFeat(FEAT_DOMAIN_POWER_ILLUSION, oCaster) && GetSpellSchool(nSpellID) == SPELL_SCHOOL_ILLUSION)
    {
        nBonus += 1;
    }
        // Boosts Caster level with healing spells
    if (GetHasFeat(FEAT_HEALING_DOMAIN_POWER, oCaster) && GetIsHealingSpell(nSpellID))
    {
        nBonus += 1;
    }
        // Boosts Caster level with the Divination school by 1
    if (GetHasFeat(FEAT_KNOWLEDGE_DOMAIN_POWER, oCaster) && GetSpellSchool(nSpellID) == SPELL_SCHOOL_DIVINATION)
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

    nSpellID = PRCGetSpellId();

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

     if (GetLevelByClass(CLASS_TYPE_DIABOLIST, oCaster) > 0 && GetLocalInt(oCaster, "Diabolism") == TRUE)
     {

          //FloatingTextStringOnCreature("Diabolism is active", oCaster, FALSE);

          nDice = (GetLevelByClass(CLASS_TYPE_DIABOLIST, oCaster) + 5) / 5;
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
    int nSpell = PRCGetSpellId();

    // Iron Mind's Mind Over Body, allows them to treat other saves as will saves up to 3/day.
    // No point in having it trigger when its a will save.
    if (GetLocalInt(oTarget, "IronMind_MindOverBody") && nSavingThrow != SAVING_THROW_WILL)
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

    int iRW = GetLevelByClass(CLASS_TYPE_RED_WIZARD, oSaveVersus);
    int iTK = GetLevelByClass(CLASS_TYPE_THAYAN_KNIGHT, oTarget);
    //Thayan Knights auto-fail mind spells cast by red wizards
    if(iRW > 0 && iTK > 0 && nSaveType == SAVING_THROW_TYPE_MIND_SPELLS)
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
    if(GetHasFeat(FEAT_DOMAIN_POWER_TYRANNY, oSaveVersus) && nSaveType == SAVING_THROW_TYPE_MIND_SPELLS)
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
    int nSpell = PRCGetSpellId();
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

    return nDamage;
}

int GetCasterLvl(int iTypeSpell, object oCaster = OBJECT_SELF)
{
    int iSor = GetLevelByClass(CLASS_TYPE_SORCERER, oCaster);
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
     //Rakshasa include outsider HD as sorc
     if(!iSor
        && GetRacialType(oCaster) == RACIAL_TYPE_RAKSHASA)
        iSor = GetLevelByClass(CLASS_TYPE_OUTSIDER, oCaster);

    int iTemp;

    switch (iTypeSpell)
    {
        case TYPE_ARCANE:
             return iArc;
             break;
        case TYPE_DIVINE:
             return iDiv;
             break;
        case CLASS_TYPE_SORCERER:
             if (GetFirstArcaneClass(oCaster) == CLASS_TYPE_SORCERER)
                 iTemp = iArc;
             else
                 iTemp = iSor + PractisedSpellcasting(oCaster, CLASS_TYPE_SORCERER, iSor);
             return iTemp;
             break;
        case CLASS_TYPE_WIZARD:
             if (GetFirstArcaneClass(oCaster) == CLASS_TYPE_WIZARD)
                 iTemp = iArc;
             else
                 iTemp = iWiz + PractisedSpellcasting(oCaster, CLASS_TYPE_WIZARD, iWiz);
             return iTemp;
             break;
        case CLASS_TYPE_BARD:
             if (GetFirstArcaneClass(oCaster) == CLASS_TYPE_BARD)
                 iTemp = iArc;
             else
                 iTemp = iBrd + PractisedSpellcasting(oCaster, CLASS_TYPE_BARD, iBrd);
             return iTemp;
             break;
        case CLASS_TYPE_CLERIC:
             if (GetFirstDivineClass(oCaster) == CLASS_TYPE_CLERIC)
                 iTemp = iDiv;
             else
                 iTemp = iCle + PractisedSpellcasting(oCaster, CLASS_TYPE_CLERIC, iCle);
             return iTemp;
             break;
        case CLASS_TYPE_DRUID:
             if (GetFirstDivineClass(oCaster) == CLASS_TYPE_DRUID)
                 iTemp = iDiv;
             else
                 iTemp = iDru + PractisedSpellcasting(oCaster, CLASS_TYPE_DRUID, iDru);
             return iTemp;
             break;
        case CLASS_TYPE_RANGER:
             if (GetFirstDivineClass(oCaster) == CLASS_TYPE_RANGER)
                 iTemp = iDiv;
             else
                 iTemp = iRan / 2;
             return iTemp;
             break;
        case CLASS_TYPE_PALADIN:
             if (GetFirstDivineClass(oCaster) == CLASS_TYPE_PALADIN)
                 iTemp = iDiv;
             else
                 iTemp = iPal / 2;
             return iTemp;
             break;
        //new spellbook classes
        case CLASS_TYPE_SHADOWLORD:
             if (GetFirstArcaneClass(oCaster) == CLASS_TYPE_SHADOWLORD)
                 iTemp = iArc;
             else
                 iTemp = iSha;
             return iTemp;
             break;
        case CLASS_TYPE_ASSASSIN:
             if (GetFirstArcaneClass(oCaster) == CLASS_TYPE_ASSASSIN)
                 iTemp = iArc;
             else
                 iTemp = iAss;
             return iTemp;
             break;
        case CLASS_TYPE_SUEL_ARCHANAMACH:
             if (GetFirstArcaneClass(oCaster) == CLASS_TYPE_SUEL_ARCHANAMACH)
                 iTemp = iArc;
             else
                 iTemp = iSue;
             return iTemp;
             break;
	case CLASS_TYPE_HEXBLADE:
             if (GetFirstArcaneClass(oCaster) == CLASS_TYPE_HEXBLADE)
                 iTemp = iArc;
             else
                 iTemp = iHex / 2;
             return iTemp;
             break;  
	case CLASS_TYPE_DUSKBLADE:
             if (GetFirstArcaneClass(oCaster) == CLASS_TYPE_DUSKBLADE)
                 iTemp = iArc;
             else
                 iTemp = iDsk;
             return iTemp;
             break;              
        case CLASS_TYPE_FAVOURED_SOUL:
             if (GetFirstDivineClass(oCaster) == CLASS_TYPE_FAVOURED_SOUL)
                 iTemp = iDiv;
             else
                 iTemp = iFav;
             return iTemp;
             break;
        case CLASS_TYPE_SOHEI:
             if (GetFirstDivineClass(oCaster) == CLASS_TYPE_SOHEI)
                 iTemp = iDiv;
             else
                 iTemp = iSoh / 2;
             return iTemp;
             break; 
        case CLASS_TYPE_HEALER:
             if (GetFirstDivineClass(oCaster) == CLASS_TYPE_HEALER)
                 iTemp = iDiv;
             else
                 iTemp = iHlr;
             return iTemp;
             break;             
        case CLASS_TYPE_SLAYER_OF_DOMIEL:
             if (GetFirstDivineClass(oCaster) == CLASS_TYPE_SLAYER_OF_DOMIEL)
                 iTemp = iDiv;
             else
                 iTemp = iSod;
             return iTemp;
             break;             
        case CLASS_TYPE_BLACKGUARD:
             if (GetFirstDivineClass(oCaster) == CLASS_TYPE_BLACKGUARD)
                 iTemp = iDiv;
             else
                 iTemp = iBlk;
             return iTemp;
             break;
        case CLASS_TYPE_VASSAL:
             if (GetFirstDivineClass(oCaster) == CLASS_TYPE_VASSAL)
                 iTemp = iDiv;
             else
                 iTemp = iVob;
             return iTemp;
             break;
        case CLASS_TYPE_SOLDIER_OF_LIGHT:
             if (GetFirstDivineClass(oCaster) == CLASS_TYPE_SOLDIER_OF_LIGHT)
                 iTemp = iDiv;
             else
                 iTemp = iSol;
             return iTemp;
             break;
        case CLASS_TYPE_KNIGHT_MIDDLECIRCLE:
             if (GetFirstDivineClass(oCaster) == CLASS_TYPE_KNIGHT_MIDDLECIRCLE)
                 iTemp = iDiv;
             else
                 iTemp = iKMc;
             return iTemp;
             break;
        case CLASS_TYPE_KNIGHT_CHALICE:
             if (GetFirstDivineClass(oCaster) == CLASS_TYPE_KNIGHT_CHALICE)
                 iTemp = iDiv;
             else
                 iTemp = iKCh;
             return iTemp;
             break;
        case CLASS_TYPE_VIGILANT:
             if (GetFirstDivineClass(oCaster) == CLASS_TYPE_VIGILANT)
                 iTemp = iDiv;
             else
                 iTemp = iVig;
             return iTemp;
             break;
        case CLASS_TYPE_ANTI_PALADIN:
             if (GetFirstDivineClass(oCaster) == CLASS_TYPE_ANTI_PALADIN)
                 iTemp = iDiv;
             else
                 iTemp = iAPl / 2;
             return iTemp;
             break;
        case CLASS_TYPE_OCULAR:
             if (GetFirstDivineClass(oCaster) == CLASS_TYPE_OCULAR)
                 iTemp = iDiv;
             else
                 iTemp = iOcu;
             return iTemp;
             break;
        default:
             break;
    }
    return 0;
}



//wrapper for GetSpellTargetLocation()
location PRCGetSpellTargetLocation()
{
    if(GetLocalInt(GetModule(), PRC_SPELL_TARGET_LOCATION_OVERRIDE))
        return GetLocalLocation(GetModule(), PRC_SPELL_TARGET_LOCATION_OVERRIDE);

    object oItem     = GetSpellCastItem();
    // The rune always targets the one who activates it.
    if(GetResRef(oItem) == "prc_rune_1") return GetLocation(GetItemPossessor(oItem));

    return GetSpellTargetLocation();
}

//wrapper for GetSpellTargetObject()
object PRCGetSpellTargetObject()
{
    object oCaster   = OBJECT_SELF; // We hope this is only ever called from the spellscript
    object oItem     = GetSpellCastItem();
    object oBWTarget = GetSpellTargetObject();
    int nSpellID     = PRCGetSpellId();


    if(GetLocalInt(oCaster, "PRC_EF_ARCANE_FIST"))
        return oCaster;

    if(GetLocalInt(GetModule(), PRC_SPELL_TARGET_OBJECT_OVERRIDE))
        return GetLocalObject(GetModule(), PRC_SPELL_TARGET_OBJECT_OVERRIDE);

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
    //int on caster for the benefit of spellfire wielder resistance
    string sName = "IsAOE_" + IntToString(GetSpellId());
    SetLocalInt(OBJECT_SELF, sName, 1);
    DelayCommand(0.1, DeleteLocalInt(OBJECT_SELF, sName));

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
        return GetFirstObjectInShape(nShape,fSize,lTarget,bLineOfSight,nObjectFilter,vOrigin);
    }
    else
    {
        return PRCGetSpellTargetObject();
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

int PRCGetMetaMagicFeat()
{
    int nFeat = GetMetaMagicFeat();
    if(GetIsObjectValid(GetSpellCastItem()))
        nFeat = 0;//biobug, this isn't reset to zero by casting from an item

    int nOverride = GetLocalInt(OBJECT_SELF, PRC_METAMAGIC_OVERRIDE);
    if(nOverride)
        return nOverride;
    int nSSFeat = GetLocalInt(OBJECT_SELF, PRC_METAMAGIC_ADJUSTMENT);
    int nNewSpellMetamagic = GetLocalInt(OBJECT_SELF, "NewSpellMetamagic");
    if(nNewSpellMetamagic)
        nFeat = nNewSpellMetamagic-1;
    if(nSSFeat)
        nFeat = nSSFeat;

    // Suel Archanamach's Extend spells they cast on themselves.
    // Only works for Suel Spells, and not any other caster type they might have
    // Since this is a spellscript, it assumes OBJECT_SELF is the caster
    if (GetLevelByClass(CLASS_TYPE_SUEL_ARCHANAMACH) >= 3 && PRCGetLastSpellCastClass() == CLASS_TYPE_SUEL_ARCHANAMACH)
    {
        // Check that they cast on themselves
        if (OBJECT_SELF == GetSpellTargetObject())
        {
            // Add extend to the metamagic feat using bitwise math
            nFeat |= METAMAGIC_EXTEND;
        }
    }
    // Magical Contraction, Truenaming Utterance
    if (GetLocalInt(OBJECT_SELF, "TrueMagicalContraction"))
    {
        nFeat |= METAMAGIC_EXTEND;
    }

    if(GetIsObjectValid(GetSpellCastItem()))
    {
        object oItem = GetSpellCastItem();
        int iSpellId = PRCGetSpellId();
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

int PRCGetSpellId()
{
    int nID = GetLocalInt(OBJECT_SELF, PRC_SPELLID_OVERRIDE);
    if(nID == 0)
        return GetSpellId();
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
    if(GetLocalInt(OBJECT_SELF,"spellswd_aoe") == 1)
    {
        SetLocalInt(OBJECT_SELF, sString+"channeled",1);
        SetLocalInt(PRCGetSpellTargetObject(), sString+"target",1);
    }
    DelayCommand(RoundsToSeconds(nDuration),DeleteLocalInt(PRCGetSpellTargetObject(), sString+"target"));
    DelayCommand(RoundsToSeconds(nDuration),DeleteLocalInt(OBJECT_SELF, sString+"channeled"));
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
       //|| nSpellId == SPELL_HEALING_CIRCLE
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
        // Fill out the line below to add another class with Will mettle
        // else if (GetLevelByClass(CLASS_TYPE_X, oTarget) >= X) nMettle = TRUE;
    }
    if (nSavingThrow = SAVING_THROW_FORT)
    {
        // Add Classes with Fort mettle here
        if (GetLevelByClass(CLASS_TYPE_HEXBLADE, oTarget) >= 3) nMettle = TRUE;
        else if (GetLevelByClass(CLASS_TYPE_SOHEI, oTarget) >= 9) nMettle = TRUE;
    }

    return nMettle;
}

void DoCommandSpell(object oCaster, object oTarget, int nSpellId, int nDuration, int nCaster)
{
    if (nSpellId == SPELL_COMMAND_APPROACH || nSpellId == SPELL_GREATER_COMMAND_APPROACH ||
        nSpellId == SPELL_DOA_COMMAND_APPROACH || nSpellId == SPELL_DOA_GREATER_COMMAND_APPROACH)
    {
        // Force the target to approach the caster
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
        AssignCommand(oTarget, ClearAllActions(TRUE));
        AssignCommand(oTarget, ActionPutDownItem(GetItemInSlot(INVENTORY_SLOT_RIGHTHAND, oTarget)));
        AssignCommand(oTarget, ActionPutDownItem(GetItemInSlot(INVENTORY_SLOT_LEFTHAND, oTarget)));
    }
    else if (nSpellId == SPELL_COMMAND_FALL || nSpellId == SPELL_GREATER_COMMAND_FALL ||
             nSpellId == SPELL_DOA_COMMAND_FALL || nSpellId == SPELL_DOA_GREATER_COMMAND_FALL)
    {
        // Force the target to fall down
        AssignCommand(oTarget, ClearAllActions(TRUE));
        SPApplyEffectToObject(DURATION_TYPE_TEMPORARY, EffectKnockdown(), oTarget, RoundsToSeconds(nDuration),TRUE,-1,nCaster);
    }
    else if (nSpellId == SPELL_COMMAND_FLEE || nSpellId == SPELL_GREATER_COMMAND_FLEE || 
             nSpellId == SPELL_DOA_COMMAND_FLEE || nSpellId == SPELL_DOA_GREATER_COMMAND_FLEE)
    {
        // Force the target to flee the caster
        AssignCommand(oTarget, ClearAllActions(TRUE));
        AssignCommand(oTarget, ActionMoveAwayFromObject(oCaster, TRUE));
    }
    else if (nSpellId == SPELL_COMMAND_HALT || nSpellId == SPELL_GREATER_COMMAND_HALT ||
             nSpellId == SPELL_DOA_COMMAND_HALT || nSpellId == SPELL_DOA_GREATER_COMMAND_HALT)
    {
        // Force the target to stand still
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
