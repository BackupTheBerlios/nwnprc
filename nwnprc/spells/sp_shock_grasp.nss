//::///////////////////////////////////////////////
//:: Name      Shocking Grasp
//:: FileName  sp_shock_grasp.nss
//:://////////////////////////////////////////////
/**@file Shocking Grasp
Evocation [Electricity]
Level: 	Sor/Wiz 1, Duskblade 1
Components: 	V, S
Casting Time: 	1 standard action
Range: 	Touch
Target: 	Creature or object touched
Duration: 	Instantaneous
Saving Throw: 	None
Spell Resistance: 	Yes

Your successful melee touch attack deals 1d6 points 
of electricity damage per caster level (maximum 5d6).

**/
//::////////////////////////////////////////////////
//:: Author: Tenjac
//:: Date  : 29.9.06
//::////////////////////////////////////////////////


/*3055
<BEGIN NOTES TO SCRIPTER - MAY BE DELETED LATER>
Modify as necessary
Most code should be put in DoSpell()

PRC_SPELL_EVENT_ATTACK is set when a
touch or ranged attack is used
<END NOTES TO SCRIPTER>
*/

#include "prc_alterations"
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
	
	SPRaiseSpellCastAt(oTarget, TRUE);
	
	//INSERT SPELL CODE HERE
		
	int iAttackRoll = PRCDoMeleeTouchAttack(oTarget);
		
	if (iAttackRoll > 0)
	
	{
		//Check Spell Resistance
		if(!MyPRCResistSpell(oCaster, oTarget, nCasterLevel + SPGetPenetr()))
		{
			int nDam = d6(min(nCasterLevel, 5));
			
			if(nMetaMagic == METAMAGIC_MAXIMIZE)
			{
				nDam = 6 * min(nCasterLevel, 5);
			}
			
			if(nMetaMagic == METAMAGIC_EMPOWER)
			{
				nDam += (nDam/2);
			}
						
			SPApplyEffectToObject(DURATION_TYPE_INSTANT, EffectDamage(nDam, DAMAGE_TYPE_ELECTRICAL), oTarget);
		}
	}
	
	return iAttackRoll;    //return TRUE if spell charges should be decremented
}

void main()
{
	object oCaster = OBJECT_SELF;
	int nCasterLevel = PRCGetCasterLevel(oCaster);
	SPSetSchool(SPELL_SCHOOL_EVOCATION);
	if (!X2PreSpellCastCode()) return;
	object oTarget = PRCGetSpellTargetObject();
	int nEvent = GetLocalInt(oCaster, PRC_SPELL_EVENT); //use bitwise & to extract flags
	if(!nEvent) //normal cast
	{
		if(GetLocalInt(oCaster, PRC_SPELL_HOLD) && oCaster == oTarget)
		{
			//holding the charge, casting spell on self
			SetLocalSpellVariables(oCaster, 1);   //change 1 to number of charges
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