//Agony secondary effects

#include "spinc_common"

void main()
{
	object oPC = OBJECT_SELF;
	int nBonus = d4(1) + 1;
	float fDur = 300.0f + (d10(1) * 60.0f);
	effect eCha = EffectAbilityIncrease(ABILITY_CHARISMA, nBonus);
	
	SPApplyEffectToObject(DURATION_TYPE_TEMPORARY, eCha, oPC, fDur);
}