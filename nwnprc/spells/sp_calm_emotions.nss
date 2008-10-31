//::///////////////////////////////////////////////
//:: Name      Calm Emotions
//:: FileName  sp_calm_emotions.nss
//:://////////////////////////////////////////////2
/** @file Calm Emotions
Enchantment (Compulsion) [Mind-Affecting]
Level: 	Brd 2, Clr 2, Law 2
Components: 	V, S, DF
Casting Time: 	1 standard action
Range: 	Medium (100 ft. + 10 ft./level)
Area: 	Creatures in a 20-ft.-radius spread
Duration: 	1 round/level
Saving Throw: 	Will negates
Spell Resistance: 	Yes

This spell calms agitated creatures. You have no 
control over the affected creatures, but calm emotions
can stop raging creatures from fighting or joyous ones
from reveling. Creatures so affected cannot take 
violent actions (although they can defend themselves) 
or do anything destructive. 


**/
//////////////////////////////////////////////////////
// Author: Tenjac
// Date:   8.10.06
//////////////////////////////////////////////////////

void DoConcLoop(object oPC, float fDur, int nCounter);

#include "prc_alterations"
#include "prc_inc_spells"

void main()
{
	if(!X2PreSpellCastCode()) return;
	
	PRCSetSchool(SPELL_SCHOOL_ENCHANTMENT);
	
	object oPC = OBJECT_SELF;
	effect eAoE = EffectAreaOfEffect(AOE_PER_CALM_EMOTIONS);
	int nCasterLvl = PRCGetCasterLevel(oPC);
	float fDur = RoundsToSeconds(nCasterLvl);
	int nMetaMagic = PRCGetMetaMagicFeat();
	
	if(nMetaMagic == METAMAGIC_EXTEND)
	{
		fDur += fDur;
	}
	
	SPApplyEffectToObject(DURATION_TYPE_TEMPORARY, eAoE, oPC, fDur);
	
	//Get the number of rounds
	int nCounter = (FloatToInt(fDur) / 6);
	
	//Start conc monitor
	DoConcLoop(oPC, fDur, nCounter);
	
	PRCSetSchool();
}

void DoConcLoop(object oPC, float fDur, int nCounter)
{
	if((nCounter == 0) || GetBreakConcentrationCheck(oPC) > 0)
	{
		PRCRemoveSpellEffects(SPELL_CALM_EMOTIONS, oPC, oPC);
	}
	
	else
	{
		nCounter--;
		DelayCommand(6.0f, DoConcLoop(oPC, fDur, nCounter));
	}
}
	
	
	
	
	