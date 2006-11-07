//::///////////////////////////////////////////////
//:: Name      Lantern Light
//:: FileName  sp_lantrn_lght.nss
//:://////////////////////////////////////////////
/**@file Lantern Light
Evocation [Good, Light]
Level: Cleric 1, paladin 1, sorcerer/wizard 1, vassal
of Bahamut 1
Components: S, Abstinence
Casting Time: 1 standard action
Range: Close (25ft + 5ft/2 leves)
Effect: Ray
Duration: 1 round/level 
Saving Throw: None
Spell Resistance: Yes 

Rays of holy light flash from your eyes.  You can fire
1 ray per 2 caster levels, but no more than 1 ray per
round.  You must succeed on a ranged touch attack to
hit a target,  The target takes 1d6 points of damage
from each ray.  

Abstinance: You must obstain from sexual intercourse
for 24 hours before casting this spell.

Author:    Tenjac
Created:   7/12/06
*/
//:://////////////////////////////////////////////
//:://////////////////////////////////////////////

#include "spinc_common"
#include "prc_sp_func"

//Implements the spell impact, put code here
//  if called in many places, return TRUE if
//  stored charges should be decreased
//  eg. touch attack hits
//
//  Variables passed may be changed if necessary
int DoSpell(object oCaster, object oTarget, int nCasterLevel, int nEvent)
{
	
	int nMetaMagic = PRCGetMetaMagicFeat();
	int nSaveDC = PRCGetSaveDC(oTarget, oCaster);
	int nPenetr = nCasterLevel + SPGetPenetr();
	float fMaxDuration = RoundsToSeconds(nCasterLevel); //modify if necessary
	
	//INSERT SPELL CODE HERE
	int iAttackRoll = 0;    //placeholder
	
	iAttackRoll = PRCDoMeleeTouchAttack(oTarget);
	if (iAttackRoll > 0)
	{		
		//Touch attack code goes here
		int nDam = d6(1);
		
		if(nMetaMagic == METAMAGIC_MAXIMIZE)
		{
			nDam = 6;
		}
		
		if(nMetaMagic == METAMAGIC_EMPOWER)
		{
			nDam += (nDam/2);
		}
		
		SPApplyEffectToObject(DURATION_TYPE_INSTANT, EffectDamage(DAMAGE_TYPE_MAGICAL, nDam), oTarget);
	}
	return iAttackRoll;    //return TRUE if spell charges should be decremented
}

void main()
{
	object oCaster = OBJECT_SELF;
	int nCasterLevel = PRCGetCasterLevel(oCaster);
	SPSetSchool(GetSpellSchool(PRCGetSpellId()));
	if (!X2PreSpellCastCode()) return;
	object oTarget = PRCGetSpellTargetObject();
	int nEvent = GetLocalInt(oCaster, PRC_SPELL_EVENT); //use bitwise & to extract flags
	if(!nEvent) //normal cast
	{
		if(GetLocalInt(oCaster, PRC_SPELL_HOLD) && oCaster == oTarget)
		{   //holding the charge, casting spell on self
		SetLocalSpellVariables(oCaster, (nCasterLevel/2));   //change 1 to number of charges
		return;
		}
		
		DoSpell(oCaster, oTarget, nCasterLevel, nEvent);
	}
	else
	{
		if(nEvent & PRC_SPELL_EVENT_ATTACK)
		{
			if(DoSpell(oCaster, oTarget, nCasterLevel, nEvent))
			DecrementSpellCharges(oCaster);
		}
	}
	SPSetSchool();
}