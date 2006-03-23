// Luhix secondary and side effects
void main()

#include "spinc_common"
{
	object oPC = OBJECT_SELF;
	
	float fDur = HoursToSeconds(d3());
	
	effect eCha = EffectAbilityIncrease(ABILITY_CHARISMA, 2);
	SPApplyEffectToObject(DURATION_TYPE_TEMPORARY, eCha, oPC, fDur);
	
	effect eCon = EffectAbilityIncrease(ABILITY_CONSTITUTION,2);
	SPApplyEffectToObject(DURATION_TYPE_TEMPORARY, eCon, oPC, fDur);
	
	effect eDex = EffectAbilityIncrease(ABILITY_DEXTERITY,2);
	SPApplyEffectToObject(DURATION_TYPE_TEMPORARY, eDex, oPC, fDur);
	
	effect eInt = EffectAbilityIncrease(ABILITY_INTELLIGENCE,2);
	SPApplyEffectToObject(DURATION_TYPE_TEMPORARY, eInt, oPC, fDur);
	
	effect eStr = EffectAbilityIncrease(ABILITY_STRENGTH,2);
	SPApplyEffectToObject(DURATION_TYPE_TEMPORARY, eStr, oPC, fDur);
	
	effect eWis = EffectAbilityIncrease(ABILITY_WISDOM,2);
	SPApplyEffectToObject(DURATION_TYPE_TEMPORARY, eWis, oPC, fDur);
	
	// Side effect
	effect eHP = EffectTemporaryHitpoints(d8()+2);
	SPApplyEffectToObject(DURATION_TYPE_TEMPORARY, eHP, oPC, fDur);
}
