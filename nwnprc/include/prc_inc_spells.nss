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

#include "prc_feat_const"
#include "prc_class_const"
#include "lookup_2da_spell"

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

//Returns Reflex Adjusted Damage. Is a wrapper function that allows the 
//DC to be adjusted based on conditions that cannot be done using iprops
//such as saves vs spellschools, or other adjustments
int PRCGetReflexAdjustedDamage(int nDamage, object oTarget, int nDC, int nSaveType=SAVING_THROW_TYPE_NONE, object oSaveVersus=OBJECT_SELF);

//Returns 0, 1 or 2 as MySavingThrow does. 0 is a failure, 1 is success, 2 is immune.
//Is a wrapper function that allows the DC to be adjusted based on conditions 
//that cannot be done using iprops, such as saves vs spellschool.
int PRCMySavingThrow(int nSavingThrow, object oTarget, int nDC, int nSaveType=SAVING_THROW_TYPE_NONE, object oSaveVersus = OBJECT_SELF, float fDelay = 0.0);

// Returns the caster level when used in spells.  You can use PRCGetCasterLevel()
// to determine a caster level from within a true spell script.  In spell-like-
// abilities & items, it will only return GetCasterLevel.
int PRCGetCasterLevel(object oCaster = OBJECT_SELF);

// Helps to find the adjustment to level granted by Practiced Spellcaster feats.
//
// oCaster - the PC/NPC in question
// iCastingClass - the class we're looking at
// iCastingLevels - the amount of adjusted caster levels BEFORE Practiced Spellcaster
int PractisedSpellcasting (object oCaster, int iCastingClass, int iCastingLevels);

// Functions mostly only useful within the scope of this include
int ArchmageSpellPower (object oCaster);
int TrueNecromancy (object oCaster, int iSpellID, string sType);
int ShadowWeave (object oCaster, int iSpellID);
string GetChangedElementalType(int spell_id, object oCaster = OBJECT_SELF);
int FireAdept (object oCaster, int iSpellID);
int BWSavingThrow(int nSavingThrow, object oTarget, int nDC, int nSaveType=SAVING_THROW_TYPE_NONE, object oSaveVersus = OBJECT_SELF, float fDelay = 0.0);

// ---------------
// BEGIN FUNCTIONS
// ---------------
int GetArcanePRCLevels (object oCaster)
{
   int nArcane;
   int nOozeMLevel = GetLevelByClass(CLASS_TYPE_OOZEMASTER, oCaster);
   int nFirstClass = GetClassByPosition(1, oCaster);
   int nSecondClass = GetClassByPosition(2, oCaster);
   
   nArcane       += GetLevelByClass(CLASS_TYPE_ARCHMAGE, oCaster)
                  + GetLevelByClass(CLASS_TYPE_ARCTRICK, oCaster)
	          + GetLevelByClass(CLASS_TYPE_ELDRITCH_KNIGHT, oCaster)
                  + GetLevelByClass(CLASS_TYPE_ES_ACID, oCaster)
		  + GetLevelByClass(CLASS_TYPE_ES_COLD, oCaster)
		  + GetLevelByClass(CLASS_TYPE_ES_ELEC, oCaster)
		  + GetLevelByClass(CLASS_TYPE_ES_FIRE, oCaster)
		  + GetLevelByClass(CLASS_TYPE_HARPERMAGE, oCaster)
		  + GetLevelByClass(CLASS_TYPE_MAGEKILLER, oCaster)
		  + GetLevelByClass(CLASS_TYPE_MASTER_HARPER, oCaster)
                  + GetLevelByClass(CLASS_TYPE_TRUENECRO, oCaster)
                  + GetLevelByClass(CLASS_TYPE_SHADOW_ADEPT, oCaster)
	          + GetLevelByClass(CLASS_TYPE_MYSTIC_THEURGE, oCaster)
	          + GetLevelByClass(CLASS_TYPE_RED_WIZARD, oCaster)

                  + (GetLevelByClass(CLASS_TYPE_ACOLYTE, oCaster) + 1) / 2
		  + (GetLevelByClass(CLASS_TYPE_BLADESINGER, oCaster) + 1) / 2
		  + (GetLevelByClass(CLASS_TYPE_BONDED_SUMMONNER, oCaster) + 1) / 2
		  + (GetLevelByClass(CLASS_TYPE_PALEMASTER, oCaster) + 1) / 2
		  + (GetLevelByClass(CLASS_TYPE_HATHRAN, oCaster) + 1) / 2
		  + (GetLevelByClass(CLASS_TYPE_SPELLSWORD, oCaster) + 1) / 2

                  + (GetLevelByClass(CLASS_TYPE_MINSTREL_EDGE, oCaster) + 1) / 3;
  
   if (nOozeMLevel)
   {
       if (GetIsArcaneClass(nFirstClass) || (!GetIsDivineClass(nFirstClass) && GetIsArcaneClass(nSecondClass)))
           nArcane += nOozeMLevel / 2;
   }

   return nArcane;       
}

int GetDivinePRCLevels (object oCaster)
{
   int nDivine;
   int nOozeMLevel = GetLevelByClass(CLASS_TYPE_OOZEMASTER, oCaster);
   int nFirstClass = GetClassByPosition(1, oCaster);
   int nSecondClass = GetClassByPosition(2, oCaster);
   
   // This section accounts for full progression classes
   nDivine       += GetLevelByClass(CLASS_TYPE_DIVESA, oCaster)
		  + GetLevelByClass(CLASS_TYPE_DIVESC, oCaster)
		  + GetLevelByClass(CLASS_TYPE_DIVESE, oCaster)
		  + GetLevelByClass(CLASS_TYPE_DIVESF, oCaster)
		  + GetLevelByClass(CLASS_TYPE_FISTRAZIEL, oCaster)
		  + GetLevelByClass(CLASS_TYPE_HEARTWARDER, oCaster)
		  + GetLevelByClass(CLASS_TYPE_HIEROPHANT, oCaster)
		  + GetLevelByClass(CLASS_TYPE_HOSPITALER, oCaster)
		  + GetLevelByClass(CLASS_TYPE_MASTER_OF_SHROUDS, oCaster)
		  + GetLevelByClass(CLASS_TYPE_MYSTIC_THEURGE, oCaster)
		  + GetLevelByClass(CLASS_TYPE_STORMLORD, oCaster)

                  + (GetLevelByClass(CLASS_TYPE_KNIGHT_CHALICE, oCaster) + 1) / 2
		  + (GetLevelByClass(CLASS_TYPE_OCULAR, oCaster) + 1) / 2
		  + (GetLevelByClass(CLASS_TYPE_TEMPUS, oCaster) + 1) / 2
		  + (GetLevelByClass(CLASS_TYPE_HATHRAN, oCaster) + 1) / 2
		  + (GetLevelByClass(CLASS_TYPE_BFZ, oCaster) + 1) / 2
		  + (GetLevelByClass(CLASS_TYPE_ORCUS, oCaster) + 1) / 2
		  + (GetLevelByClass(CLASS_TYPE_SHINING_BLADE, oCaster) + 1) / 2
		  + (GetLevelByClass(CLASS_TYPE_WARPRIEST, oCaster) + 1) / 2;

   if (!GetHasFeat(FEAT_SF_CODE, oCaster))
   {
       nDivine   += GetLevelByClass(CLASS_TYPE_SACREDFIST, oCaster);
   }

   if (nOozeMLevel)
   {
       if (GetIsDivineClass(nFirstClass) || (!GetIsArcaneClass(nFirstClass) && GetIsDivineClass(nSecondClass)))
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
            nClass==CLASS_TYPE_RANGER);
}

int GetFirstArcaneClassPosition (object oCaster = OBJECT_SELF)
{
    if (GetIsArcaneClass(GetClassByPosition(1, oCaster)))
        return 1;
    if (GetIsArcaneClass(GetClassByPosition(2, oCaster)))
        return 2;
    if (GetIsArcaneClass(GetClassByPosition(3, oCaster)))
        return 3;

    return 0;
}

int GetFirstDivineClassPosition (object oCaster = OBJECT_SELF)
{
    if (GetIsDivineClass(GetClassByPosition(1, oCaster)))
        return 1;
    if (GetIsDivineClass(GetClassByPosition(2, oCaster)))
        return 2;
    if (GetIsDivineClass(GetClassByPosition(3, oCaster)))
        return 3;

    return 0;
}

int GetFirstArcaneClass (object oCaster = OBJECT_SELF)
{
    int iArcanePos = GetFirstArcaneClassPosition(oCaster);
    if (!iArcanePos) return CLASS_TYPE_INVALID; // no arcane casting class
    
    return GetClassByPosition(iArcanePos, oCaster);
}

int GetFirstDivineClass (object oCaster = OBJECT_SELF)
{
    int iDivinePos = GetFirstDivineClassPosition(oCaster);
    if (!iDivinePos) return CLASS_TYPE_INVALID; // no Divine casting class
    
    return GetClassByPosition(iDivinePos, oCaster);
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
    int iClass1 = GetClassByPosition(1, oCaster);
    int iClass2 = GetClassByPosition(2, oCaster);
    int iClass3 = GetClassByPosition(3, oCaster);
    int iClass1Lev = GetLevelByClass(iClass1, oCaster);
    int iClass2Lev = GetLevelByClass(iClass2, oCaster);
    int iClass3Lev = GetLevelByClass(iClass3, oCaster);

    if (iClass1 == iFirstArcane) iClass1Lev += GetArcanePRCLevels(oCaster);
    if (iClass2 == iFirstArcane) iClass2Lev += GetArcanePRCLevels(oCaster);
    if (iClass3 == iFirstArcane) iClass3Lev += GetArcanePRCLevels(oCaster);

    if (!GetIsArcaneClass(iClass1)) iClass1Lev = 0;
    else iClass1Lev += PractisedSpellcasting(oCaster, iClass1, iClass1Lev);

    if (!GetIsArcaneClass(iClass2)) iClass2Lev = 0;
    else iClass2Lev += PractisedSpellcasting(oCaster, iClass2, iClass2Lev);

    if (!GetIsArcaneClass(iClass3)) iClass3Lev = 0;
    else iClass3Lev += PractisedSpellcasting(oCaster, iClass3, iClass3Lev);

    int iBest = 0;
    if (iClass1Lev > iBest) iBest = iClass1Lev;
    if (iClass2Lev > iBest) iBest = iClass2Lev;
    if (iClass3Lev > iBest) iBest = iClass3Lev;
    
    return iBest;
}

int GetLevelByTypeDivine(object oCaster = OBJECT_SELF)
{
    int iFirstDivine = GetFirstDivineClass(oCaster);
    int iClass1 = GetClassByPosition(1, oCaster);
    int iClass2 = GetClassByPosition(2, oCaster);
    int iClass3 = GetClassByPosition(3, oCaster);
    int iClass1Lev = GetLevelByClass(iClass1, oCaster);
    int iClass2Lev = GetLevelByClass(iClass2, oCaster);
    int iClass3Lev = GetLevelByClass(iClass3, oCaster);

    if (iClass1 == CLASS_TYPE_PALADIN || iClass1 == CLASS_TYPE_RANGER) iClass1Lev = iClass1Lev / 2;
    if (iClass2 == CLASS_TYPE_PALADIN || iClass2 == CLASS_TYPE_RANGER) iClass2Lev = iClass2Lev / 2;
    if (iClass3 == CLASS_TYPE_PALADIN || iClass3 == CLASS_TYPE_RANGER) iClass3Lev = iClass3Lev / 2;

    if (iClass1 == iFirstDivine) iClass1Lev += GetDivinePRCLevels(oCaster);
    if (iClass2 == iFirstDivine) iClass2Lev += GetDivinePRCLevels(oCaster);
    if (iClass3 == iFirstDivine) iClass3Lev += GetDivinePRCLevels(oCaster);

    if (!GetIsDivineClass(iClass1)) iClass1Lev = 0;
    else iClass1Lev += PractisedSpellcasting(oCaster, iClass1, iClass1Lev);

    if (!GetIsDivineClass(iClass2)) iClass2Lev = 0;
    else iClass2Lev += PractisedSpellcasting(oCaster, iClass2, iClass2Lev);

    if (!GetIsDivineClass(iClass3)) iClass3Lev = 0;
    else iClass3Lev += PractisedSpellcasting(oCaster, iClass3, iClass3Lev);

    int iBest = 0;
    if (iClass1Lev > iBest) iBest = iClass1Lev;
    if (iClass2Lev > iBest) iBest = iClass2Lev;
    if (iClass3Lev > iBest) iBest = iClass3Lev;
    
    return iBest;
}

int PRCGetCasterLevel(object oCaster = OBJECT_SELF)
{
    int iCastingClass = GetLastSpellCastClass(); // might be CLASS_TYPE_INVALID

    int iSpellId = GetSpellId();

    if (GetIsArcaneClass(iCastingClass)) // Arcane spells
    {
        int iArcLevel = GetLevelByClass(iCastingClass, oCaster);

        if (GetFirstArcaneClass(oCaster) == iCastingClass)
        {
            iArcLevel += GetArcanePRCLevels(oCaster);
            iArcLevel += ArchmageSpellPower(oCaster);
        }

        iArcLevel += TrueNecromancy(oCaster, iSpellId, "ARCANE");
        iArcLevel += ShadowWeave(oCaster, iSpellId);
        iArcLevel += FireAdept(oCaster, iSpellId);
        iArcLevel += PractisedSpellcasting(oCaster, iCastingClass, iArcLevel); //gotta be the last one

        SendMessageToPC(oCaster, "Arcane casting at level " + IntToString(iArcLevel));

        return iArcLevel;
    }
    else if (GetIsDivineClass(iCastingClass)) // Divine spells
    {
        int iDivLevel = GetLevelByClass(iCastingClass, oCaster);

        if (iCastingClass == CLASS_TYPE_RANGER || iCastingClass == CLASS_TYPE_PALADIN) iDivLevel = iDivLevel / 2;

        if (GetFirstDivineClass(oCaster) == iCastingClass) iDivLevel += GetDivinePRCLevels(oCaster);

        iDivLevel += TrueNecromancy(oCaster, iSpellId, "DIVINE");
        iDivLevel += ShadowWeave(oCaster, iSpellId);
        iDivLevel += FireAdept(oCaster, iSpellId);
        iDivLevel += PractisedSpellcasting(oCaster, iCastingClass, iDivLevel); //gotta be the last one

        SendMessageToPC(oCaster, "Divine casting at level " + IntToString(iDivLevel));

        return iDivLevel;
    }
    else // No caster class could be determined.  (Spell-Like abilities & items.)
    {
        SendMessageToPC(oCaster, "SLA (?) casting at level " + IntToString(GetCasterLevel(oCaster)));

        return GetCasterLevel(oCaster);
    }
}

int PractisedSpellcasting (object oCaster, int iCastingClass, int iCastingLevels)
{
    int iAdjustment = GetHitDice(oCaster) - iCastingLevels;
    if (iAdjustment > 4) iAdjustment = 4;
    if (iAdjustment < 0) iAdjustment = 0;
    
    if (iCastingClass == CLASS_TYPE_BARD && GetHasFeat(FEAT_PRACTISED_SPELLCASTER_BARD, oCaster))
        return iAdjustment;
    if (iCastingClass == CLASS_TYPE_SORCERER && GetHasFeat(FEAT_PRACTISED_SPELLCASTER_SORCERER, oCaster))
        return iAdjustment;
    if (iCastingClass == CLASS_TYPE_WIZARD && GetHasFeat(FEAT_PRACTISED_SPELLCASTER_WIZARD, oCaster))
        return iAdjustment;
    if (iCastingClass == CLASS_TYPE_CLERIC && GetHasFeat(FEAT_PRACTISED_SPELLCASTER_CLERIC, oCaster))
        return iAdjustment;
    if (iCastingClass == CLASS_TYPE_DRUID && GetHasFeat(FEAT_PRACTISED_SPELLCASTER_DRUID, oCaster))
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

int ShadowWeave (object oCaster, int iSpellID)
{
   if (!GetLocalInt(oCaster, "PatronShar")) return 0;

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

    nSpellID = GetSpellId();

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


int PRCMySavingThrow(int nSavingThrow, object oTarget, int nDC, int nSaveType=SAVING_THROW_TYPE_NONE, object oSaveVersus = OBJECT_SELF, float fDelay = 0.0)
{

	int iRedWizard = GetLevelByClass(CLASS_TYPE_RED_WIZARD, oTarget);
	int nSpell = GetSpellId();
	
	if (iRedWizard > 0)
	{
		int iRWSpec;
		if (GetHasFeat(FEAT_RW_SPEC_ABJ, oTarget)) iRWSpec = SPELL_SCHOOL_ABJURATION;
		else if (GetHasFeat(FEAT_RW_SPEC_CON, oTarget)) iRWSpec = SPELL_SCHOOL_CONJURATION;
		else if (GetHasFeat(FEAT_RW_SPEC_DIV, oTarget)) iRWSpec = SPELL_SCHOOL_DIVINATION;
		else if (GetHasFeat(FEAT_RW_SPEC_ENC, oTarget)) iRWSpec = SPELL_SCHOOL_ENCHANTMENT;
		else if (GetHasFeat(FEAT_RW_SPEC_EVO, oTarget)) iRWSpec = SPELL_SCHOOL_EVOCATION;
		else if (GetHasFeat(FEAT_RW_SPEC_ILL, oTarget)) iRWSpec = SPELL_SCHOOL_ILLUSION;
		else if (GetHasFeat(FEAT_RW_SPEC_NEC, oTarget)) iRWSpec = SPELL_SCHOOL_NECROMANCY;
		else if (GetHasFeat(FEAT_RW_SPEC_TRS, oTarget)) iRWSpec = SPELL_SCHOOL_TRANSMUTATION;

		if (GetSpellSchool(nSpell) == iRWSpec)
		{
		
			if (iRedWizard > 9)		nDC = nDC - 4;
			else if (iRedWizard > 6)	nDC = nDC - 3;
			else if (iRedWizard > 2)	nDC = nDC - 2;
			else if (iRedWizard > 0)	nDC = nDC - 1;
		
		}


	}



	return BWSavingThrow(nSavingThrow, oTarget, nDC, nSaveType, oSaveVersus, fDelay);
}


int PRCGetReflexAdjustedDamage(int nDamage, object oTarget, int nDC, int nSaveType=SAVING_THROW_TYPE_NONE, object oSaveVersus=OBJECT_SELF)
{

	int iRedWizard = GetLevelByClass(CLASS_TYPE_RED_WIZARD, oTarget);
	int nSpell = GetSpellId();
	
	if (iRedWizard > 0)
	{
		int iRWSpec;
		if (GetHasFeat(FEAT_RW_SPEC_ABJ, oTarget)) iRWSpec = SPELL_SCHOOL_ABJURATION;
		else if (GetHasFeat(FEAT_RW_SPEC_CON, oTarget)) iRWSpec = SPELL_SCHOOL_CONJURATION;
		else if (GetHasFeat(FEAT_RW_SPEC_DIV, oTarget)) iRWSpec = SPELL_SCHOOL_DIVINATION;
		else if (GetHasFeat(FEAT_RW_SPEC_ENC, oTarget)) iRWSpec = SPELL_SCHOOL_ENCHANTMENT;
		else if (GetHasFeat(FEAT_RW_SPEC_EVO, oTarget)) iRWSpec = SPELL_SCHOOL_EVOCATION;
		else if (GetHasFeat(FEAT_RW_SPEC_ILL, oTarget)) iRWSpec = SPELL_SCHOOL_ILLUSION;
		else if (GetHasFeat(FEAT_RW_SPEC_NEC, oTarget)) iRWSpec = SPELL_SCHOOL_NECROMANCY;
		else if (GetHasFeat(FEAT_RW_SPEC_TRS, oTarget)) iRWSpec = SPELL_SCHOOL_TRANSMUTATION;

		if (GetSpellSchool(nSpell) == iRWSpec)
		{
		
			if (iRedWizard > 9)		nDC = nDC - 4;
			else if (iRedWizard > 6)	nDC = nDC - 3;
			else if (iRedWizard > 2)	nDC = nDC - 2;
			else if (iRedWizard > 0)	nDC = nDC - 1;
		
		}


	}

    return GetReflexAdjustedDamage(nDamage, oTarget, nDC, nSaveType, oSaveVersus);
}
