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
#include "lookup_2da_spell"

// Returns the Manifesting Class
int GetManifestingClass(object oCaster = OBJECT_SELF);

// Returns Manifester Level
int GetManifesterLevel(object oCaster = OBJECT_SELF);

// Returns the level of a Power
int GetPowerLevel();

// Returns the psionic DC
int GetManifesterDC(object oCaster = OBJECT_SELF);

// Checks whether manifester has enough PP to cast
// If he does, subtract PP and cast power, else power fails
int GetCanManifest(object oCaster, int nAugCost);

// Checks to see if the caster has suffered psychic enervation
// from a wild surge. If yes, daze and subtract power points.
void PsychicEnervation(object oCaster, int nWildSurge);

// ---------------
// BEGIN FUNCTIONS
// ---------------


int GetManifestingClass(object oCaster)
{

	int nPsion = GetLevelByClass(CLASS_TYPE_PSION, oCaster);
	int nPsychic = GetLevelByClass(CLASS_TYPE_PSYWARRIOR, oCaster);
	int nWilder = GetLevelByClass(CLASS_TYPE_WILDER, oCaster);
	int nClass;
	int nLevel;
	int nLocal = GetLocalInt(OBJECT_SELF, "PSI_MANIFESTER_CLASS");
	
	if (nLocal > 0)
	{
		if (nLocal == 1) 
		{
			nClass = CLASS_TYPE_PSION;
			FloatingTextStringOnCreature("Manifester Class: Psion", oCaster, FALSE);
		}
		else if (nLocal == 2) 
		{
			nClass = CLASS_TYPE_WILDER;
			FloatingTextStringOnCreature("Manifester Class: Wilder", oCaster, FALSE);
		}
		else if (nLocal == 3) 
		{
			nClass = CLASS_TYPE_PSYWARRIOR;
			FloatingTextStringOnCreature("Manifester Class: Psychic Warrior", oCaster, FALSE);
		}
	}
	else
	{
		//Compare the main two Manifester classes
		if (nPsion >= nWilder) 
		{
			nLevel = nPsion;
			nClass = CLASS_TYPE_PSION;
			FloatingTextStringOnCreature("Manifester Class: Psion", oCaster, FALSE);
		}
		else if (nWilder > nPsion) 
		{
			nLevel = nWilder;
			nClass = CLASS_TYPE_WILDER;
			FloatingTextStringOnCreature("Manifester Class: Wilder", oCaster, FALSE);
		}
		//Then compare the Psy Warrior
		if (nPsychic > nLevel) 
		{
			nClass = CLASS_TYPE_PSYWARRIOR;
			FloatingTextStringOnCreature("Manifester Class: Psychic Warrior", oCaster, FALSE);
		}
	}

	return nClass;

}

int GetManifesterLevel(object oCaster)
{
	//Gets the level of the manifesting class
	int nClass = GetManifestingClass(oCaster);
	int nLevel = GetLevelByClass(nClass, oCaster);
	int nSurge = GetLocalInt(oCaster, "WildSurge");
	
	if (nClass == CLASS_TYPE_WILDER && nSurge > 0) nLevel = nLevel + nSurge;
	
	FloatingTextStringOnCreature("Manifester Level: " + IntToString(nLevel), oCaster, FALSE);

	return nLevel;
}


int GetPowerLevel()
{
	int nSpell = GetSpellId();
	int nLevel = StringToInt(lookup_spell_innate(nSpell));
	return nLevel;
}


int GetManifesterDC(object oCaster)
{

	int nClass = GetManifestingClass(oCaster);
	int nDC = 10;
	nDC = nDC + GetPowerLevel();
	
	if (nClass == CLASS_TYPE_PSION)			nDC = nDC + GetAbilityModifier(ABILITY_INTELLIGENCE, oCaster);
	else if (nClass == CLASS_TYPE_WILDER)		nDC = nDC + GetAbilityModifier(ABILITY_CHARISMA, oCaster);
	else if (nClass == CLASS_TYPE_PSYWARRIOR)	nDC = nDC + GetAbilityModifier(ABILITY_WISDOM, oCaster);

	return nDC;
}

int GetCanManifest(object oCaster, int nAugCost)
{
    int nLevel = GetPowerLevel();
    int nAugment = GetLocalInt(oCaster, "Augment");
    int nPP = GetLocalInt(oCaster, "PowerPoints");
    int nPPCost;
    int nCanManifest = TRUE;
    
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
    if (nAugment == 0) nPPCost = nPPCost;    
    else if (nAugment == 1) nPPCost = nPPCost + (nAugCost * 1);
    else if (nAugment == 2) nPPCost = nPPCost + (nAugCost * 2);
    else if (nAugment == 3) nPPCost = nPPCost + (nAugCost * 3);
    else if (nAugment == 4) nPPCost = nPPCost + (nAugCost * 4);
    else if (nAugment == 5) nPPCost = nPPCost + (nAugCost * 5);
    
    // If PP Cost is greater than Manifester level
    if (GetManifesterLevel(oCaster) >= nPPCost)
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
}