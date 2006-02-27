//::///////////////////////////////////////////////
//:: Name      Touch of Juiblex
//:: FileName  sp_tch_Juiblex.nss
//:://////////////////////////////////////////////
/**@file Touch of Juiblex 
Transmutation [Evil] 
Level: Corrupt 3 
Components: V, S, Corrupt
Casting Time: 1 action 
Range: Touch
Target: Creature touched
Duration: Instantaneous
Saving Throw: Fortitude negates 
Spell Resistance: Yes

The subject turns into green slime over the course of
4 rounds. If a remove curse, polymorph other, heal, 
greater restoration, limited wish, miracle, or wish
spell is cast during the 4 rounds of transformation,
the subject is restored to normal but still takes 3d6
points of damage. 

Corruption Cost: 1d6 points of Strength damage.

Author:    Tenjac
Created:   2/19/06
*/
//:://////////////////////////////////////////////
//:://////////////////////////////////////////////

#include "prc_alterations"
#include "spinc_common"
#include "prc_inc_spells"


void CountdownToSlime(object oTarget, int nCounter)
{
	if(nCounter > 0)
	{
		nCounter--;
		DelayCommand(6.0f, CountdownToSlime(oTarget, nCounter));
	}
	else
	{
		location lLoc = GetLocation(oTarget);
		
		//kill target
		effect eDeath = EffectDeath();		
		SPApplyEffectToObject(DURATION_TYPE_INSTANT, eDeath, oTarget);
		
		
		CreateObject(OBJECT_TYPE_CREATURE, "x2_gelcube", lLoc);
	}
}

void main()
{
	SPSetSchool(SPELL_SCHOOL_TRANSMUTATION);
	
	// Run the spellhook. 
	if (!X2PreSpellCastCode()) return;
	
	object oPC = OBJECT_SELF;
	object oTarget = GetSpellTargetObject();
	int nDC = SPGetSpellSaveDC(oTarget, oPC);
	int nCasterLvl = PRCGetCasterLevel(oPC);
	int nCounter = 4;
	
	SPRaiseSpellCastAt(oTarget, TRUE, SPELL_TOUCH_OF_JUIBLEX, oPC);
	
	//Spell Resistance
	if (!MyPRCResistSpell(oPC, oTarget, nCasterLvl + SPGetPenetr()))
	{
		//Save
		if (!PRCMySavingThrow(SAVING_THROW_FORT, oTarget, nDC, SAVING_THROW_TYPE_SPELL))
		{
			//It's the final countdown
			CountdownToSlime(oTarget, nCounter);
		}
	}			
	
	//Alignment shift
	SPEvilShift(oPC);
	
	//Corruption cost
	int nCost = d6(1);	
	DoCorruptionCost(oPC, ABILITY_STRENGTH, nCost, 0);
	
	SPSetSchool();
}
	
	
	
