//::///////////////////////////////////////////////
//:: Name      Heartclutch
//:: FileName  sp_heartclutch.nss
//:://////////////////////////////////////////////
/**@file Heartclutch 
Transmutation [Evil] 
Level: Clr 5 
Components: V, S, Disease 
Casting Time: 1 action 
Range: Close (25 ft. + 5 ft./2 levels) 
Target: The heart of one creature 
Duration: Instantaneous
Saving Throw: Fortitude partial 
Spell Resistance: Yes

The caster holds forth his empty hand, and the 
stillbeating heart of the subject appears within it.
The subject dies in 1d3 rounds, and only a heal, 
regenerate, miracle, or wish spell will save it 
during this time. The target is entitled to a 
Fortitude saving throw to survive the attack. If the
target succeeds at the save, it instead takes 3d6 
points of damage +1 point per caster level from 
general damage to the chest and internal organs. 
(The target might die from damage even if it 
succeeds at the saving throw.)

A creature with no discernible anatomy is unaffected
by this spell. 

Disease Component: Soul rot. 

Author:    Tenjac
Created:   
*/
//:://////////////////////////////////////////////
//:://////////////////////////////////////////////

void ClutchLoop(object oTarget, int nDelay, object oPC);
int GetHasSoulRot(object oPC);

#include "spinc_common"

void main()
{
	object oPC = OBJECT_SELF;
	object oTarget = GetSpellTargetObject();
	int nCasterLvl = PRCGetCasterLevel(oPC);
	int nDelay = (d3(1) - 1);
	int nType = MyPRCGetRacialType(oTarget);
		
	//Spellhook
	if(!X2PreSpellCastCode()) return;
	
	SPSetSchool(SPELL_SCHOOL_TRANSMUTATION);
	
	SPRaiseSpellCastAt(oTarget,TRUE, SPELL_HEARTCLUTCH, oPC);
	
	if(nType != RACIAL_TYPE_OOZE &&
	   nType != RACIAL_TYPE_UNDEAD &&
	   nType != RACIAL_TYPE_CONSTRUCT &&
	   nType != RACIAL_TYPE_ELEMENTAL)
	   
	{
		//Check for Soul rot
		
		if(GetHasSoulRot(oPC))
		{
			//Check for Spell resistance
			if(!MyPRCResistSpell(oPC, oTarget, nCasterLvl + SPGetPenetr()))
			{
				//Clutching loop
				ClutchLoop(oTarget, nDelay, oPC);
			}
		}
	}
	SPEvilShift(oPC);
	SPSetSchool();
}

void ClutchLoop(object oTarget, int nDelay, object oPC)
{		
	if(nDelay < 1)
	{
		int nDC = SPGetSpellSaveDC(oTarget, oPC);
		//Save
		if(PRCMySavingThrow(SAVING_THROW_FORT, oTarget, nDC, SAVING_THROW_TYPE_MIND_SPELLS))
		{
			SPApplyEffectToObject(DURATION_TYPE_INSTANT, EffectDamage(DAMAGE_TYPE_MAGICAL, d6(3)), oTarget);
			
		}
		else
		{
			SPApplyEffectToObject(DURATION_TYPE_INSTANT, EffectDeath(), oTarget);
		}
	}
	
	nDelay--;
	
	//Round we go...
	ClutchLoop(oTarget, nDelay, oPC);
}

int GetHasSoulRot(object oPC)
{
	int bHasDisease = FALSE;
	effect eTest = GetFirstEffect(oPC);
	effect eDisease = EffectDisease(DISEASE_SOUL_ROT);
	
	if (GetHasEffect(EFFECT_TYPE_DISEASE, oPC))
	{
		while (GetIsEffectValid(eTest))
		{
			if(eTest == eDisease)
			{
				bHasDisease = TRUE;
				
			}
			eTest = GetNextEffect(oPC);
		}
	}
	return bHasDisease;
}
		
		 
			