//::///////////////////////////////////////////////
//:: Name      Sannish
//:: FileName  sp_sannish.nss 
//:://////////////////////////////////////////////
/** Script for the drug Sannish

Author:    Tenjac
Created:   5/23/06
*/
//:://////////////////////////////////////////////
//:://////////////////////////////////////////////

#include "spinc_common"

void main()
{
	object oPC = OBJECT_SELF;
	
	// Initial effect
	ApplyAbilityDamage(oPC, ABILITY_WISDOM, 1, DURATION_TYPE_TEMPORARY, TRUE, -1.0f);
	
	effect eNerf = EffectAttackDecrease(1);
	SPApplyEffectToObject(DURATION_TYPE_TEMPORARY, eNerf, oPC, HoursToSeconds(d4()));
	
	//Secondary - Immune to pain
	
	//Overdose
	//if(overdose)
	{
		effect eDaze = EffectDazed();
		float fDur = HoursToSeconds(d4(2));
		SPApplyEffectToObject(DURATION_TYPE_TEMPORARY, eDaze, oPC, fDur);
	}
}

