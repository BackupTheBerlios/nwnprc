/* 
   ----------------
   prc_psi_ppoints
   ----------------
   
   19/10/04 by Stratovarius
   
   Calculates the Manifester level, DC, etc.
   Psion, Psychic Warrior, Wilder. (Soulknife does not have Manifester levels)
*/

#include "prc_feat_const"
#include "prc_class_const"
#include "prc_power_const"
#include "lookup_2da_spell"
#include "prc_inc_clsfunc"

// Returns the Manifesting Class
// GetCasterClass wont work, so the casting class is set via a localint
int GetManifestingClass(object oCaster = OBJECT_SELF);

// Returns Manifester Level
int GetManifesterLevel(object oCaster = OBJECT_SELF);

// Returns the level of a Power
// Used for Power cost and DC
int GetPowerLevel(object oCaster);

// Returns the psionic DC
int GetManifesterDC(object oCaster = OBJECT_SELF);

// Checks whether manifester has enough PP to cast
// If he does, subtract PP and cast power, else power fails
int GetCanManifest(object oCaster, int nAugCost, object oTarget = OBJECT_SELF);

// Checks to see if the caster has suffered psychic enervation
// from a wild surge. If yes, daze and subtract power points.
// Also checks for Surging Euphoria, and applies it, if needed.
void PsychicEnervation(object oCaster, int nWildSurge);

// Checks to see if the power manifested is a Telepathy one
// This is used with the Wilder's Volatile Mind ability.
int GetIsTelepathyPower();

// Increases the cost of a Telepathy power by an 
// amount if the target of the spell is a Wilder
int VolatileMind(object oTarget, object oCaster);

// Returns the number of powers a character posseses from a specific class
int GetPowerCount(object oPC, int nClass);

// Checks the feat.2da prereqs for a specific power
// Only deals with AND/OR feat requirements at the moment
// Also checks that the PC doesnt already have the feat
int CheckPowerPrereqs(int nFeat, object oPC);

// Run this to specify what class is casting it and then it will cheat-cast the real
// power.
void UsePower(int nPower, int nClass);

// ---------------
// BEGIN FUNCTIONS
// ---------------


int GetManifestingClass(object oCaster)
{
      return GetLocalInt(oCaster, "ManifestingClass");
}

int GetManifesterLevel(object oCaster)
{
    int nLevel;
    // Item Spells
    if (GetItemPossessor(GetSpellCastItem()) == oCaster)
    {
        //SendMessageToPC(oCaster, "Item casting at level " + IntToString(GetCasterLevel(oCaster)));
        
        return GetCasterLevel(oCaster);
    }

    // For when you want to assign the caster level.
    else if (GetLocalInt(oCaster, "PRC_Castlevel_Override") != 0)
    {
        //SendMessageToPC(oCaster, "Forced-level manifesting at level " + IntToString(GetCasterLevel(oCaster)));

        DelayCommand(1.0, DeleteLocalInt(oCaster, "PRC_Castlevel_Override"));
        nLevel = GetLocalInt(oCaster, "PRC_Castlevel_Override");
    }
    else
    {
	//Gets the level of the manifesting class
	int nLevel = GetLevelByClass(GetManifestingClass(oCaster), oCaster);
    }
      
	if (nLevel == 0)	nLevel = GetLevelByPosition(1, oCaster);

      //Adding wild surge
	int nSurge = GetLocalInt(oCaster, "WildSurge");
	if (nSurge > 0) nLevel = nLevel + nSurge;
	
	//FloatingTextStringOnCreature("Manifester Level: " + IntToString(nLevel), oCaster, FALSE);

	return nLevel;
}

int GetPowerLevel(object oCaster)
{
      return GetLocalInt(oCaster, "PowerLevel");
}

int GetAbilityScoreOfClass(object oCaster, int nClass)
{
    int nScore;
    switch(nClass)
    {
        case CLASS_TYPE_PSION:
            nScore = GetAbilityScore(oCaster, ABILITY_INTELLIGENCE);
            break;
        case CLASS_TYPE_WILDER:
            nScore = GetAbilityScore(oCaster, ABILITY_CHARISMA);
            break;
        case CLASS_TYPE_PSYWARRIOR:
            nScore = GetAbilityScore(oCaster, ABILITY_WISDOM);
            break;
    }
    return nScore;
}


int GetManifesterDC(object oCaster)
{

	int nClass = GetManifestingClass(oCaster);
	int nDC = 10;
	nDC += GetPowerLevel(oCaster);
      nDC += (GetAbilityScoreOfClass(oCaster, nClass) - 10)/2;
      
	return nDC;
}

int GetCanManifest(object oCaster, int nAugCost, object oTarget = OBJECT_SELF)
{

//    SendMessageToPC(GetFirstPC(), "Manifesting power "+IntToString(GetSpellId()));

    int nLevel = GetPowerLevel(oCaster);
    int nAugment = GetLocalInt(oCaster, "Augment");
    int nPP = GetLocalInt(oCaster, "PowerPoints");
    int nPPCost;
    int nCanManifest = TRUE;
    int nVolatile = VolatileMind(oTarget, oCaster);
    int nClass = GetManifestingClass(oCaster);
    
    if(GetAbilityScoreOfClass(oCaster, nClass) - 10 < nLevel)
    {
        FloatingTextStringOnCreature("You do not have a high enough ability score to manifest this power", oCaster, FALSE);    
        nCanManifest = FALSE;
    }

    //Sets Power Point cost based on power level
    if (nLevel == 1) nPPCost = 1;
    else if (nLevel == 2) nPPCost = 3;
    else if (nLevel == 3) nPPCost = 5;
    else if (nLevel == 4) nPPCost = 7;
    else if (nLevel == 5) nPPCost = 9;
    else if (nLevel == 6) nPPCost = 11;
    else if (nLevel == 7) nPPCost = 13;
    else if (nLevel == 8) nPPCost = 15;
    else if (nLevel == 9) nPPCost = 17;
    
    //Adds in the augmentation cost
    if (nAugment > 0) nPPCost = nPPCost + (nAugCost * nAugment); 
    
    //Adds in the cost for volatile mind
    if (nVolatile > 0) nPPCost += nVolatile;
    
    // If PP Cost is greater than Manifester level
    if (GetManifesterLevel(oCaster) >= nPPCost && nCanManifest)
    {
    	//If Manifest does not have enough points, cancel power
    	if (nPPCost > nPP) 
    	{
    		FloatingTextStringOnCreature("You do not have enough Power Points to manifest this power", oCaster, FALSE);
    		nCanManifest = FALSE;
    	}
    	else //Manifester has enough points, so subtract cost and manifest power
    	{
    		nPP = nPP - nPPCost;
    		FloatingTextStringOnCreature("Power Points Remaining: " + IntToString(nPP), oCaster, FALSE);
    		SetLocalInt(oCaster, "PowerPoints", nPP);
    	}
    }
    else
    {
    	FloatingTextStringOnCreature("Your manifester level is not high enough to spend that many Power Points", oCaster, FALSE);
    	nCanManifest = FALSE;
    }	
    return nCanManifest;

}


void PsychicEnervation(object oCaster, int nWildSurge)
{
	int nDice = d20(1);

	if (nWildSurge >= nDice)
	{
		int nWilder = GetLevelByClass(CLASS_TYPE_WILDER, oCaster);
		int nPP = GetLocalInt(oCaster, "PowerPoints");
	
		effect eMind = EffectVisualEffect(VFX_DUR_MIND_AFFECTING_NEGATIVE);
		effect eDaze = EffectDazed();
		effect eLink = EffectLinkEffects(eMind, eDaze);
		eLink = ExtraordinaryEffect(eLink);
	
		FloatingTextStringOnCreature("You have become psychically enervated and lost power points", oCaster, FALSE);
		ApplyEffectToObject(DURATION_TYPE_TEMPORARY, eLink, oCaster, TurnsToSeconds(1));
		
    		nPP = nPP - nWilder;
    		FloatingTextStringOnCreature("Power Points Remaining: " + IntToString(nPP), oCaster, FALSE);
    		SetLocalInt(oCaster, "PowerPoints", nPP);	
	}
	else
	{
		int nEuphoria = 1;
		if (GetLevelByClass(CLASS_TYPE_WILDER, oCaster) > 19) nEuphoria = 3;
		else if (GetLevelByClass(CLASS_TYPE_WILDER, oCaster) > 11) nEuphoria = 2;
		
		effect eBonAttack = EffectAttackIncrease(nEuphoria);
		effect eBonDam = EffectDamageIncrease(nEuphoria, DAMAGE_TYPE_MAGICAL);
		effect eVis = EffectVisualEffect(VFX_IMP_MAGIC_PROTECTION);
		effect eSave = EffectSavingThrowIncrease(SAVING_THROW_ALL, nEuphoria, SAVING_THROW_TYPE_SPELL);
		effect eDur = EffectVisualEffect(VFX_DUR_CESSATE_POSITIVE);
		effect eDur2 = EffectVisualEffect(VFX_DUR_MAGIC_RESISTANCE);
		effect eLink = EffectLinkEffects(eSave, eDur);
		eLink = EffectLinkEffects(eLink, eDur2);
		eLink = EffectLinkEffects(eLink, eBonDam);
		eLink = EffectLinkEffects(eLink, eBonAttack);
		eLink = ExtraordinaryEffect(eLink);
		FloatingTextStringOnCreature("Surging Euphoria: " + IntToString(nWildSurge), oCaster, FALSE);
		ApplyEffectToObject(DURATION_TYPE_TEMPORARY, eLink, oCaster, RoundsToSeconds(nWildSurge));
	}
}

int GetIsTelepathyPower()
{
	int nSpell = GetSpellId();
	if (nSpell == 2371 || nSpell == 2373 || nSpell == 2374)
	{
		return TRUE;
	}
	
	return FALSE;
}

int VolatileMind(object oTarget, object oCaster)
{
	int nWilder = GetLevelByClass(CLASS_TYPE_WILDER, oTarget);
	int nTelepathy = GetIsTelepathyPower();
	int nCost = 0;
	
	if (nWilder > 4 && nTelepathy == TRUE)
	{
		if (GetIsEnemy(oTarget, oCaster))
		{
			if      (GetHasFeat(FEAT_WILDER_VOLATILE_MIND_4, oTarget)) nCost = 4;
			else if (GetHasFeat(FEAT_WILDER_VOLATILE_MIND_3, oTarget)) nCost = 3;
			else if (GetHasFeat(FEAT_WILDER_VOLATILE_MIND_2, oTarget)) nCost = 2;
			else if (GetHasFeat(FEAT_WILDER_VOLATILE_MIND_1, oTarget)) nCost = 1;
		}
	}
	
	//FloatingTextStringOnCreature("Volatile Mind Cost: " + IntToString(nCost), oTarget, FALSE);
	return nCost;
}


int CheckPowerPrereqs(int nFeat, object oPC)
{
    if(GetHasFeat(nFeat, oPC))
        return FALSE;
    if(Get2DACache("feat", "PREREQFEAT1", nFeat) != ""
        && !GetHasFeat(StringToInt(Get2DACache("feat", "PREREQFEAT1", nFeat)), oPC))
        return FALSE;
    if(Get2DACache("feat", "PREREQFEAT2", nFeat) != ""
        && !GetHasFeat(StringToInt(Get2DACache("feat", "PREREQFEAT2", nFeat)), oPC))
        return FALSE;
    if(    (Get2DACache("feat", "OrReqFeat0", nFeat) != ""
               && !GetHasFeat(StringToInt(Get2DACache("feat", "OrReqFeat0", nFeat)), oPC))
        || (Get2DACache("feat", "OrReqFeat1", nFeat) != ""
               && !GetHasFeat(StringToInt(Get2DACache("feat", "OrReqFeat1", nFeat)), oPC))
        || (Get2DACache("feat", "OrReqFeat2", nFeat) != ""
               && !GetHasFeat(StringToInt(Get2DACache("feat", "OrReqFeat2", nFeat)), oPC))
        || (Get2DACache("feat", "OrReqFeat3", nFeat) != ""
               && !GetHasFeat(StringToInt(Get2DACache("feat", "OrReqFeat3", nFeat)), oPC))
        || (Get2DACache("feat", "OrReqFeat4", nFeat) != ""
               && !GetHasFeat(StringToInt(Get2DACache("feat", "OrReqFeat4", nFeat)), oPC))
      )
        return FALSE;
    //if youve reached this far then return TRUE
    return TRUE;
}

int GetPowerCount(object oPC, int nClass)
{
    if(!persistant_array_exists(oPC, "PsiPowerCount"))
        return 0;
    return persistant_array_get_int(oPC, "PsiPowerCount", nClass);
}

void UsePower(int nPower, int nClass)
{
//    SendMessageToPC(OBJECT_SELF, "Manifesting power "+IntToString(nPower));
    //set the class
    SetLocalInt(OBJECT_SELF, "ManifestingClass", nClass);
//    DelayCommand(1.0, DeleteLocalInt(OBJECT_SELF, "ManifestingClass"));
    //set the spell power
    SetLocalInt(OBJECT_SELF, "PowerLevel", StringToInt(lookup_spell_innate(GetSpellId())));
    //pass in the spell
    ActionCastSpell(nPower);
}