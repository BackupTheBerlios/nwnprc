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

// Added by Primogenitor
// part of the replacement for GetClassByPosition and GetLevelByPosition
// since those always return CLASS_TYPE_INVALID for non-bioware classes
void SetupPRCGetClassByPosition(object oCreature);

// Added by Primogenitor
// replacement for GetClassByPosition since that always returns
// CLASS_TYPE_INVALID for non-bioware classes
//
// A creature can have up to three classes.  This function determines the
// creature's class (CLASS_TYPE_*) based on nClassPosition.
// - nClassPosition: 1, 2 or 3
// - oCreature
// * Returns CLASS_TYPE_INVALID if the oCreature does not have a class in
//   nClassPosition (i.e. a single-class creature will only have a value in
//   nClassLocation=1) or if oCreature is not a valid creature.
int PRCGetClassByPosition(int nClassPosition, object oCreature=OBJECT_SELF);


// Added by Primogenitor
// replacement for GetLevelByPosition since GetClassByPosition always returns
// CLASS_TYPE_INVALID for non-bioware classes, so the PRC order may not be the
// same as the bioware order for the classes
//
// A creature can have up to three classes.  This function determines the
// creature's class level based on nClass Position.
// - nClassPosition: 1, 2 or 3
// - oCreature
// * Returns 0 if oCreature does not have a class in nClassPosition
//   (i.e. a single-class creature will only have a value in nClassLocation=1)
//   or if oCreature is not a valid creature.
int PRCGetLevelByPosition(int nClassPosition, object oCreature=OBJECT_SELF);

// Returns the caster level when used in spells.  You can use PRCGetCasterLevel()
// to determine a caster level from within a true spell script.  In spell-like-
// abilities & items, it will only return GetCasterLevel.
int PRCGetCasterLevel(object oCaster = OBJECT_SELF);

// Returns the equivalent added caster levels from Arcane Prestige Classes.
int GetArcanePRCLevels (object oCaster);

// Returns the equivalent added caster levels from Divine Prestige Classes.
int GetDivinePRCLevels (object oCaster);

// Returns TRUE if nClass is an arcane spellcasting class, FALSE otherwise.
int GetIsArcaneClass(int nClass);

// Returns TRUE if nClass is an divine spellcasting class, FALSE otherwise.
int GetIsDivineClass (int nClass);

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

//to override for custom spellcasting classes
int PRCGetLastSpellCastClass();

//wrapper for getspelltargetlocation
location PRCGetSpellTargetLocation();

//wrapper for getspelltargetlocation
object PRCGetSpellTargetObject();

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

#include "prc_inc_sneak"
#include "prc_feat_const"
#include "prc_class_const"
#include "lookup_2da_spell"
#include "prc_inc_switch"
#include "inc_vfx_const"
#include "prc_alterations"

// ---------------
// BEGIN FUNCTIONS
// ---------------
int GetArcanePRCLevels (object oCaster)
{
   int nArcane;
   int nOozeMLevel = GetLevelByClass(CLASS_TYPE_OOZEMASTER, oCaster);
   int nFirstClass = PRCGetClassByPosition(1, oCaster);
   int nSecondClass = PRCGetClassByPosition(2, oCaster);
   int nThirdClass = PRCGetClassByPosition(3, oCaster);
   
   nArcane       += GetLevelByClass(CLASS_TYPE_ARCHMAGE, oCaster)
                 +  GetLevelByClass(CLASS_TYPE_ARCTRICK, oCaster)
              +  GetLevelByClass(CLASS_TYPE_ELDRITCH_KNIGHT, oCaster)
                 +  GetLevelByClass(CLASS_TYPE_ES_ACID, oCaster)
           +  GetLevelByClass(CLASS_TYPE_ES_COLD, oCaster)
           +  GetLevelByClass(CLASS_TYPE_ES_ELEC, oCaster)
           +  GetLevelByClass(CLASS_TYPE_ES_FIRE, oCaster)
           +  GetLevelByClass(CLASS_TYPE_HARPERMAGE, oCaster)
           +  GetLevelByClass(CLASS_TYPE_MAGEKILLER, oCaster)
           +  GetLevelByClass(CLASS_TYPE_MASTER_HARPER, oCaster)
                 +  GetLevelByClass(CLASS_TYPE_TRUENECRO, oCaster)
                 +  GetLevelByClass(CLASS_TYPE_SHADOW_ADEPT, oCaster)
              +  GetLevelByClass(CLASS_TYPE_MYSTIC_THEURGE, oCaster)
              +  GetLevelByClass(CLASS_TYPE_RED_WIZARD, oCaster)
              +  GetLevelByClass(CLASS_TYPE_DIABOLIST, oCaster)
              +  GetLevelByClass(CLASS_TYPE_CEREBREMANCER, oCaster)
              +  GetLevelByClass(CLASS_TYPE_MAESTER, oCaster)

                 +  (GetLevelByClass(CLASS_TYPE_ACOLYTE, oCaster) + 1) / 2
           +  (GetLevelByClass(CLASS_TYPE_BLADESINGER, oCaster) + 1) / 2
           +  (GetLevelByClass(CLASS_TYPE_BONDED_SUMMONNER, oCaster) + 1) / 2
           +  (GetLevelByClass(CLASS_TYPE_PALEMASTER, oCaster) + 1) / 2
           +  (GetLevelByClass(CLASS_TYPE_HATHRAN, oCaster) + 1) / 2
           +  (GetLevelByClass(CLASS_TYPE_SPELLSWORD, oCaster) + 1) / 2
           +  (GetLevelByClass(CLASS_TYPE_THRALL_OF_GRAZZT_A, oCaster) + 1) / 2

                 +  (GetLevelByClass(CLASS_TYPE_JUDICATOR, oCaster) + 1) / 3;
                 

   if (nOozeMLevel)
   {
       if (GetIsArcaneClass(nFirstClass) 
           || (!GetIsDivineClass(nFirstClass) && GetIsArcaneClass(nSecondClass))
           || (!GetIsDivineClass(nFirstClass) && !GetIsDivineClass(nSecondClass) && GetIsArcaneClass(nThirdClass)))
           nArcane += nOozeMLevel / 2;
   }

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
   nDivine       += GetLevelByClass(CLASS_TYPE_DIVESA, oCaster)
           +  GetLevelByClass(CLASS_TYPE_DIVESC, oCaster)
           +  GetLevelByClass(CLASS_TYPE_DIVESE, oCaster)
           +  GetLevelByClass(CLASS_TYPE_DIVESF, oCaster)
           +  GetLevelByClass(CLASS_TYPE_FISTRAZIEL, oCaster)
           +  GetLevelByClass(CLASS_TYPE_HEARTWARDER, oCaster)
           +  GetLevelByClass(CLASS_TYPE_HIEROPHANT, oCaster)
           +  GetLevelByClass(CLASS_TYPE_HOSPITALER, oCaster)
           +  GetLevelByClass(CLASS_TYPE_MASTER_OF_SHROUDS, oCaster)
           +  GetLevelByClass(CLASS_TYPE_MYSTIC_THEURGE, oCaster)
           +  GetLevelByClass(CLASS_TYPE_STORMLORD, oCaster)
           +  GetLevelByClass(CLASS_TYPE_MASTER_HARPER_DIV, oCaster)
           +  GetLevelByClass(CLASS_TYPE_PSYCHIC_THEURGE, oCaster)
           +  GetLevelByClass(CLASS_TYPE_ALAGHAR, oCaster)
           +  GetLevelByClass(CLASS_TYPE_COMBAT_MEDIC, oCaster)
           +  GetLevelByClass(CLASS_TYPE_BLIGHTLORD, oCaster)
           +  GetLevelByClass(CLASS_TYPE_CONTEMPLATIVE, oCaster)

           +  (GetLevelByClass(CLASS_TYPE_OLLAM, oCaster) + 1) / 2 
           //+  (GetLevelByClass(CLASS_TYPE_OCULAR, oCaster) + 1) / 2
           +  (GetLevelByClass(CLASS_TYPE_TEMPUS, oCaster) + 1) / 2
           +  (GetLevelByClass(CLASS_TYPE_HATHRAN, oCaster) + 1) / 2
           +  (GetLevelByClass(CLASS_TYPE_BFZ, oCaster) + 1) / 2
           +  (GetLevelByClass(CLASS_TYPE_ORCUS, oCaster) + 1) / 2
           +  (GetLevelByClass(CLASS_TYPE_SHINING_BLADE, oCaster) + 1) / 2
           +  (GetLevelByClass(CLASS_TYPE_WARPRIEST, oCaster) + 1) / 2
           +  (GetLevelByClass(CLASS_TYPE_THRALL_OF_GRAZZT_D, oCaster) + 1) / 2
       +  (GetLevelByClass(CLASS_TYPE_CONTENDER, oCaster) + 1) / 2

           +  (GetLevelByClass(CLASS_TYPE_JUDICATOR, oCaster) + 1) / 3;

   if (!GetHasFeat(FEAT_SF_CODE, oCaster))
   {
       nDivine   += GetLevelByClass(CLASS_TYPE_SACREDFIST, oCaster);
   }

   if (nOozeMLevel)
   {
       if (GetIsDivineClass(nFirstClass) 
           || (!GetIsArcaneClass(nFirstClass) && GetIsDivineClass(nSecondClass))
           || (!GetIsArcaneClass(nFirstClass) && !GetIsArcaneClass(nSecondClass) && GetIsDivineClass(nThirdClass)))
           nDivine += nOozeMLevel / 2;
   }

   return nDivine;       
}

int GetIsArcaneClass(int nClass)
{
    return (nClass==CLASS_TYPE_WIZARD ||
            nClass==CLASS_TYPE_SORCERER ||
            nClass==CLASS_TYPE_BARD);
}

int GetIsDivineClass (int nClass)
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
            nClass==CLASS_TYPE_OCULAR);
}

int GetFirstArcaneClassPosition (object oCaster = OBJECT_SELF)
{
    if (GetIsArcaneClass(PRCGetClassByPosition(1, oCaster)))
        return 1;
    if (GetIsArcaneClass(PRCGetClassByPosition(2, oCaster)))
        return 2;
    if (GetIsArcaneClass(PRCGetClassByPosition(3, oCaster)))
        return 3;

    return 0;
}

int GetFirstDivineClassPosition (object oCaster = OBJECT_SELF)
{
    if (GetIsDivineClass(PRCGetClassByPosition(1, oCaster)))
        return 1;
    if (GetIsDivineClass(PRCGetClassByPosition(2, oCaster)))
        return 2;
    if (GetIsDivineClass(PRCGetClassByPosition(3, oCaster)))
        return 3;

    return 0;
}

int GetFirstArcaneClass (object oCaster = OBJECT_SELF)
{
    int iArcanePos = GetFirstArcaneClassPosition(oCaster);
    if (!iArcanePos) return CLASS_TYPE_INVALID; // no arcane casting class
    
    return PRCGetClassByPosition(iArcanePos, oCaster);
}

int GetFirstDivineClass (object oCaster = OBJECT_SELF)
{
    int iDivinePos = GetFirstDivineClassPosition(oCaster);
    if (!iDivinePos) return CLASS_TYPE_INVALID; // no Divine casting class
    
    return PRCGetClassByPosition(iDivinePos, oCaster);
}

int GetSpellSchool(int iSpellId)
{
    string sSpellSchool = lookup_spell_school(iSpellId);
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
    
    if (!GetIsArcaneClass(iClass1)) iClass1Lev = 0;
    if (!GetIsArcaneClass(iClass2)) iClass2Lev = 0;
    if (!GetIsArcaneClass(iClass3)) iClass3Lev = 0;

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

    if (!GetIsDivineClass(iClass1)) iClass1Lev = 0;
    if (!GetIsDivineClass(iClass2)) iClass2Lev = 0;
    if (!GetIsDivineClass(iClass3)) iClass3Lev = 0;
    
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
    
    if (!GetIsArcaneClass(iClass1)) iClass1Lev = 0;
    if (!GetIsArcaneClass(iClass2)) iClass2Lev = 0;
    if (!GetIsArcaneClass(iClass3)) iClass3Lev = 0;

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

    if (!GetIsDivineClass(iClass1)) iClass1Lev = 0;
    if (!GetIsDivineClass(iClass2)) iClass2Lev = 0;
    if (!GetIsDivineClass(iClass3)) iClass3Lev = 0;
    
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
                if(GetItemPropertyType(ipTest) == 85
                    && GetItemPropertySubType(ipTest) == iSpellId
                    )
                    iItemLevel = GetItemPropertyCostTableValue (ipTest);
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
              +  StormMagic(oCaster);
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
              +  StormMagic(oCaster);
              +  DeathKnell(oCaster);
    iDivLevel += PractisedSpellcasting(oCaster, iCastingClass, iDivLevel); //gotta be the last one

    if(GetIsArcaneClass(iCastingClass))
        iReturnLevel = iArcLevel;
    else if(GetIsDivineClass(iCastingClass))
        iReturnLevel = iDivLevel;  
    //items override arcane/divine    
    if(iItemLevel)
        iReturnLevel = iItemLevel;
    //at this point it must be a SLA or similar    
    if(!iReturnLevel)
        iReturnLevel = GetCasterLevel(oCaster);
        
    iReturnLevel += nAdjust;  
    
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
    
    if (GetWeather(oArea) == WEATHER_RAIN || GetWeather(oArea) == WEATHER_SNOW)
    {
        return 1;
    }
    return 0;
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

   if (iSpellSchool == SPELL_SCHOOL_EVOCATION || iSpellSchool == SPELL_SCHOOL_TRANSMUTATION)
   {
        if (iSpellID == SPELL_DARKNESS || 
            iSpellID == SPELLABILITY_AS_DARKNESS  ||
            iSpellID == SPELL_SHADOW_CONJURATION_DARKNESS ||
            iSpellID == 688 || // Drider darkness
            iSpellID == SHADOWLORD_DARKNESS)
        {
            return 0;
        }
        else
        {
            return -1; // yes, that's a penalty.
        }
   }
   return 0;
}

// stolen from prcsp_archmaginc.nss, modified to work in this script.
string GetChangedElementalType(int spell_id, object oCaster = OBJECT_SELF)
{
    string spellType = lookup_spell_type(spell_id);

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
    
    // For when you want to assign the caster DC
    //this does not take feat/race/class into account, it is an absolute override
    if (GetLocalInt(oSaveVersus, PRC_DC_TOTAL_OVERRIDE) != 0)
    {
        nDC = GetLocalInt(oSaveVersus, PRC_DC_TOTAL_OVERRIDE);
        //SendMessageToPC(oCaster, "Forced-DC casting at DC " + nDC;
    }
    
    // -------------------------------------------------------------------------
    // GZ: sanity checks to prevent wrapping around
    // -------------------------------------------------------------------------
    if (nDC<1)
    {
       nDC = 1;
    }
    else if (nDC > 255)
    {
      nDC = 255;
    }

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

     object oCaster = GetLastSpellCaster();
     int nSpell = PRCGetSpellId();
     
     // Handle the target having Force of Will and being targeted by a psionic power
     if(nSavingThrow != SAVING_THROW_WILL        &&
        nSpell > 14000 && nSpell < 14360         &&
        GetHasFeat(FEAT_FORCE_OF_WILL, oTarget)  &&
        !GetLocalInt(oTarget, "ForceOfWillUsed") &&
        // Only use will save if it's better
        (nSavingThrow == SAVING_THROW_FORT ? GetFortitudeSavingThrow(oTarget) : GetReflexSavingThrow(oTarget)) > GetWillSavingThrow(oTarget)
       )
     {
        nSavingThrow = SAVING_THROW_WILL;
        SetLocalInt(oTarget, "ForceOfWillUsed", TRUE);
        DelayCommand(6.0f, DeleteLocalInt(oTarget, "ForceOfWillUsed"));
        SendMessageToPC(oTarget, "Force Of Will used");
     }
     
      int iRW = GetLevelByClass(CLASS_TYPE_RED_WIZARD, oCaster);
     int iTK = GetLevelByClass(CLASS_TYPE_THAYAN_KNIGHT, oTarget);
     //Thayan Knights auto-fail mind spells cast by red wizards
     if (iRW > 0 && iTK > 0 && nSaveType == SAVING_THROW_TYPE_MIND_SPELLS)
     {
          return 0;
     }
     
     if (iRW > 0)
     {
        //Red Wizards recieve a bonus against their specialist schools
        // this is done by lowering the DC of spells cast against them
          int iRWSpec;
          if (GetHasFeat(FEAT_RW_TF_ABJ, oTarget)) iRWSpec = SPELL_SCHOOL_ABJURATION;
          else if (GetHasFeat(FEAT_RW_TF_CON, oTarget)) iRWSpec = SPELL_SCHOOL_CONJURATION;
          else if (GetHasFeat(FEAT_RW_TF_DIV, oTarget)) iRWSpec = SPELL_SCHOOL_DIVINATION;
          else if (GetHasFeat(FEAT_RW_TF_ENC, oTarget)) iRWSpec = SPELL_SCHOOL_ENCHANTMENT;
          else if (GetHasFeat(FEAT_RW_TF_EVO, oTarget)) iRWSpec = SPELL_SCHOOL_EVOCATION;
          else if (GetHasFeat(FEAT_RW_TF_ILL, oTarget)) iRWSpec = SPELL_SCHOOL_ILLUSION;
          else if (GetHasFeat(FEAT_RW_TF_NEC, oTarget)) iRWSpec = SPELL_SCHOOL_NECROMANCY;
          else if (GetHasFeat(FEAT_RW_TF_TRS, oTarget)) iRWSpec = SPELL_SCHOOL_TRANSMUTATION;

          if (GetSpellSchool(nSpell) == iRWSpec)
          {
               if (iRW > 28)         nDC = nDC - 14;
               else if (iRW > 26)    nDC = nDC - 13;
               else if (iRW > 24)    nDC = nDC - 12;
               else if (iRW > 22)    nDC = nDC - 11;
               else if (iRW > 20)    nDC = nDC - 10;
               else if (iRW > 18)    nDC = nDC - 9;
               else if (iRW > 16)    nDC = nDC - 8;
               else if (iRW > 14)    nDC = nDC - 7;
               else if (iRW > 12)    nDC = nDC - 6;
               else if (iRW > 10)    nDC = nDC - 5;
               else if (iRW > 8)     nDC = nDC - 4;
               else if (iRW > 6)     nDC = nDC - 3;
               else if (iRW > 2)     nDC = nDC - 2;
               else if (iRW > 0)     nDC = nDC - 1;          
          }
     }

    //racial pack code
    //this works by lowering the DC rather than adding to the save
    //same net effect but slightly different numbers
    if(nSaveType == SAVING_THROW_TYPE_FIRE && GetHasFeat(FEAT_HARD_FIRE, oTarget) )
    { nDC -= 1+(GetHitDice(oTarget)/5); }
    else if(nSaveType == SAVING_THROW_TYPE_COLD && GetHasFeat(FEAT_HARD_WATER, oTarget) )
    {    nDC -= 1+(GetHitDice(oTarget)/5);  }
    else if(nSaveType == SAVING_THROW_TYPE_ELECTRICITY )
    {
        if(GetHasFeat(FEAT_HARD_AIR, oTarget))
            nDC -= 1+(GetHitDice(oTarget)/5);
        else if(GetHasFeat(FEAT_HARD_ELEC, oTarget))
            nDC -= 2;
    }
    else if(nSaveType == SAVING_THROW_TYPE_POISON && GetHasFeat(FEAT_POISON_3, oTarget) )
    {   nDC -= 3;  }
    else if(nSaveType == SAVING_THROW_TYPE_ACID && GetHasFeat(FEAT_HARD_EARTH, oTarget) )
    {   nDC -= 1+(GetHitDice(oTarget)/5);  }

     int nSaveRoll = BWSavingThrow(nSavingThrow, oTarget, nDC, nSaveType, oSaveVersus, fDelay);
     
     // Second Chance power in psionics
     if (nSaveRoll == 0 && GetLocalInt(oTarget, "SecondChance") && !GetLocalInt(oTarget, "SecondChanceTimer"))
     {
        // Can't use this ability again for a round
        SetLocalInt(oTarget, "SecondChanceTimer", TRUE);
        nSaveRoll = BWSavingThrow(nSavingThrow, oTarget, nDC, nSaveType, oSaveVersus, fDelay);
        DelayCommand(6.0, DeleteLocalInt(oTarget, "SecondChanceTimer"));
     }
     return nSaveRoll;
}


int PRCGetReflexAdjustedDamage(int nDamage, object oTarget, int nDC, int nSaveType=SAVING_THROW_TYPE_NONE, object oSaveVersus=OBJECT_SELF)
{
     
     int iShadow = GetLevelByClass(CLASS_TYPE_SHADOW_ADEPT, oTarget);
     int iRedWizard = GetLevelByClass(CLASS_TYPE_RED_WIZARD, oTarget);
     int nSpell = PRCGetSpellId();
     
     if (iRedWizard > 0)
     {
          int iRWSpec;
          if (GetHasFeat(FEAT_RW_TF_ABJ, oTarget)) iRWSpec = SPELL_SCHOOL_ABJURATION;
          else if (GetHasFeat(FEAT_RW_TF_CON, oTarget)) iRWSpec = SPELL_SCHOOL_CONJURATION;
          else if (GetHasFeat(FEAT_RW_TF_DIV, oTarget)) iRWSpec = SPELL_SCHOOL_DIVINATION;
          else if (GetHasFeat(FEAT_RW_TF_ENC, oTarget)) iRWSpec = SPELL_SCHOOL_ENCHANTMENT;
          else if (GetHasFeat(FEAT_RW_TF_EVO, oTarget)) iRWSpec = SPELL_SCHOOL_EVOCATION;
          else if (GetHasFeat(FEAT_RW_TF_ILL, oTarget)) iRWSpec = SPELL_SCHOOL_ILLUSION;
          else if (GetHasFeat(FEAT_RW_TF_NEC, oTarget)) iRWSpec = SPELL_SCHOOL_NECROMANCY;
          else if (GetHasFeat(FEAT_RW_TF_TRS, oTarget)) iRWSpec = SPELL_SCHOOL_TRANSMUTATION;

          if (GetSpellSchool(nSpell) == iRWSpec)
          {
          
               if (iRedWizard > 28)          nDC = nDC - 14;
               else if (iRedWizard > 26)     nDC = nDC - 13;
               else if (iRedWizard > 24)     nDC = nDC - 12;
               else if (iRedWizard > 22)     nDC = nDC - 11;
               else if (iRedWizard > 20)     nDC = nDC - 10;
               else if (iRedWizard > 18)     nDC = nDC - 9;
               else if (iRedWizard > 16)     nDC = nDC - 8;
               else if (iRedWizard > 14)     nDC = nDC - 7;
               else if (iRedWizard > 12)     nDC = nDC - 6;
               else if (iRedWizard > 10)     nDC = nDC - 5;
               else if (iRedWizard > 8) nDC = nDC - 4;
               else if (iRedWizard > 6) nDC = nDC - 3;
               else if (iRedWizard > 2) nDC = nDC - 2;
               else if (iRedWizard > 0) nDC = nDC - 1;
          
          }


     }
        
        if (iShadow > 0)
     {

     
          if (GetSpellSchool(nSpell) == SPELL_SCHOOL_ENCHANTMENT || GetSpellSchool(nSpell) == SPELL_SCHOOL_NECROMANCY || GetSpellSchool(nSpell) == SPELL_SCHOOL_ILLUSION)
          {
          
               if (iShadow > 28)   nDC = nDC - 10;
               else if (iShadow > 25)   nDC = nDC - 9;
               else if (iShadow > 22)   nDC = nDC - 8;
               else if (iShadow > 19)   nDC = nDC - 7;
               else if (iShadow > 16)   nDC = nDC - 6;
               else if (iShadow > 13)   nDC = nDC - 5;
               else if (iShadow > 10)   nDC = nDC - 4;
               else if (iShadow > 7)    nDC = nDC - 3;
               else if (iShadow > 4)    nDC = nDC - 2;
               else if (iShadow > 1)    nDC = nDC - 1;
          }
     
     //SendMessageToPC(GetFirstPC(), "Your Spell Save modifier is " + IntToString(nDC));
     }
     
        
        
     //racial pack code
        if(nSaveType == SAVING_THROW_TYPE_FIRE && GetHasFeat(FEAT_HARD_FIRE, oTarget) )
        { nDC -= 1+(GetHitDice(oTarget)/5); }
        else if(nSaveType == SAVING_THROW_TYPE_COLD && GetHasFeat(FEAT_HARD_WATER, oTarget) )
        {    nDC -= 1+(GetHitDice(oTarget)/5);  }
        else if(nSaveType == SAVING_THROW_TYPE_SONIC && GetHasFeat(FEAT_HARD_AIR, oTarget) )
        {    nDC -= 1+(GetHitDice(oTarget)/5);  }
        else if(nSaveType == SAVING_THROW_TYPE_ELECTRICITY )
        {
            if(GetHasFeat(FEAT_HARD_AIR, oTarget))
                nDC -= 1+(GetHitDice(oTarget)/5);
            else if(GetHasFeat(FEAT_HARD_ELEC, oTarget))
                nDC -= 2;
        }
        else if(nSaveType == SAVING_THROW_TYPE_POISON && GetHasFeat(FEAT_POISON_4, oTarget) )
        {   nDC -= 4;  }
        else if(nSaveType == SAVING_THROW_TYPE_POISON && GetHasFeat(FEAT_POISON_3, oTarget) )
        {   nDC -= 3;  }
        else if(nSaveType == SAVING_THROW_TYPE_ACID && GetHasFeat(FEAT_HARD_EARTH, oTarget) )
        {   nDC -= 1+(GetHitDice(oTarget)/5);  }


    return GetReflexAdjustedDamage(nDamage, oTarget, nDC, nSaveType, oSaveVersus);
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
    int iArc = GetLevelByTypeArcane(oCaster);
    int iDiv = GetLevelByTypeDivine(oCaster);

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
        default:
             break;
    }
    return 0;
}

//primos class position things

void SetupPRCGetClassByPosition(object oCreature)
{
    int i;
    int nCounter = 1;
    //set to defaults, including the +1 for 1start not 0 start
    SetLocalInt(oCreature, "PRC_ClassInPos1", CLASS_TYPE_INVALID+1);
    SetLocalInt(oCreature, "PRC_ClassInPos2", CLASS_TYPE_INVALID+1);
    SetLocalInt(oCreature, "PRC_ClassInPos3", CLASS_TYPE_INVALID+1);
    SetLocalInt(oCreature, "PRC_ClassLevelInPos1", 0+1);
    SetLocalInt(oCreature, "PRC_ClassLevelInPos2", 0+1);
    SetLocalInt(oCreature, "PRC_ClassLevelInPos3", 0+1);
    for(i=0;i<256;i++)
    {
        if(GetLevelByClass(i, oCreature))
        {
            // set to values, including the +1 for 1start not 0 start
            SetLocalInt(oCreature, "PRC_ClassInPos"+IntToString(nCounter), i+1);
            SetLocalInt(oCreature, "PRC_ClassLevelInPos"+IntToString(nCounter),
                GetLevelByClass(i, oCreature)+1);
            nCounter++;
            if(nCounter >= 4)
                break; // end loop now
        }
    }
}

int PRCGetClassByPosition(int nClassPosition, object oCreature=OBJECT_SELF)
{
    if(!GetIsObjectValid(oCreature) || GetObjectType(oCreature) != OBJECT_TYPE_CREATURE)
        return CLASS_TYPE_INVALID;
    int nClass = GetLocalInt(oCreature, "PRC_ClassInPos"+IntToString(nClassPosition));
    if(nClass == 0)
    {
        SetupPRCGetClassByPosition(oCreature);
        nClass = GetLocalInt(oCreature, "PRC_ClassInPos"+IntToString(nClassPosition));
    }
    //correct for 1 start not 0 start
    nClass--;
    return nClass;
}

int PRCGetLevelByPosition(int nClassPosition, object oCreature=OBJECT_SELF)
{
    if(!GetIsObjectValid(oCreature) || GetObjectType(oCreature) != OBJECT_TYPE_CREATURE)
        return 0;
    int nClass = GetLocalInt(oCreature, "PRC_ClassLevelInPos"+IntToString(nClassPosition));
    if(nClass == 0)
    {
        SetupPRCGetClassByPosition(oCreature);
        nClass = GetLocalInt(oCreature, "PRC_ClassLevelInPos"+IntToString(nClassPosition));
    }
    //correct for 1 start not 0 start
    nClass--;
    return nClass;
}

//wrapper for getspelltargetlocation
location PRCGetSpellTargetLocation()
{
    if(GetLocalInt(GetModule(), PRC_SPELL_TARGET_LOCATION_OVERRIDE))
        return GetLocalLocation(GetModule(), PRC_SPELL_TARGET_LOCATION_OVERRIDE);
    return GetSpellTargetLocation();        
}

//wrapper for getspelltargetlocation
object PRCGetSpellTargetObject()
{
    if(GetLocalInt(GetModule(), PRC_SPELL_TARGET_OBJECT_OVERRIDE))
        return GetLocalObject(GetModule(), PRC_SPELL_TARGET_OBJECT_OVERRIDE);
    return GetSpellTargetObject();
}


////////////////Begin Spellsword//////////////////

//GetNextObjectInShape wrapper for changing the AOE of the channeled spells
object MyNextObjectInShape(int nShape,
                           float fSize, location lTarget,
                           int bLineOfSight = FALSE,
                           int nObjectFilter = OBJECT_TYPE_CREATURE,
                           vector vOrigin=[0.0, 0.0, 0.0])
{
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
    /*
    int nChannel = GetLocalInt(OBJECT_SELF,"spellswd_aoe");
    int nFeat = GetLocalInt(OBJECT_SELF,"spell_metamagic");
    int nNewSpellMetamagic = GetLocalInt(OBJECT_SELF, "NewSpellMetamagic");
    if(nChannel == 1)
    {
        if(nFeat == nMMagic)
            return TRUE;
        else
            return FALSE;
    } 
    else if(nNewSpellMetamagic != 0)
    {
        if(nNewSpellMetamagic == nMMagic)
            return TRUE;
        else
            return FALSE;
    } 
    else    
    {
        if(nMeta == nMMagic)
            return TRUE;
        else
            return FALSE;
    } 
}
*/
int PRCGetMetaMagicFeat()
{
    int nFeat = GetMetaMagicFeat();
    int nChannel = GetLocalInt(OBJECT_SELF,"spellswd_aoe");
    int nSSFeat = GetLocalInt(OBJECT_SELF,"spell_metamagic");
    int nNewSpellMetamagic = GetLocalInt(OBJECT_SELF, "NewSpellMetamagic");
    if(nChannel == 1)
        nFeat |= nSSFeat; //bitwise "addition" equivalent to nFeat = (nFeat | nSSFeat)
    else if(nNewSpellMetamagic)
        nFeat |= nNewSpellMetamagic;
    if(GetIsObjectValid(GetSpellCastItem()))
    {
        object oItem = GetSpellCastItem();
        int iSpellId = PRCGetSpellId();
        //check item for metamagic
        int nItemMetaMagic;
        itemproperty ipTest = GetFirstItemProperty(oItem);
        while(GetIsItemPropertyValid(ipTest))
        {
            if(GetItemPropertyType(ipTest) == 92 // TODO: Constant this
                && GetItemPropertySubType(ipTest) == iSpellId)
            {               
                int nCostValue = GetItemPropertyCostTableValue (ipTest);
                switch(nCostValue)
                {
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
            ipTest = GetNextItemProperty(oItem);
        }
        nFeat |= nItemMetaMagic;
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
    int nID = GetLocalInt(OBJECT_SELF, "SpellIDOverride");
    if(nID == 0)
        return GetSpellId();
    if(nID == -1)
        nID = 0;
    return nID;
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