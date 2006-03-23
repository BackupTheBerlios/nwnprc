// Sannish initial and side effects

#include "spinc_common"

void main()
{
	object oPC = OBJECT_SELF;
	effect eWis = EffectAbilityDecrease(ABILITY_WISDOM,1);
	effect eNerf = EffectAttackDecrease(1);
	
	SPApplyEffectToObject(DURATION_TYPE_PERMANENT, eWis, );
	SPApplyEffectToObject(DURATION_TYPE_TEMPORARY, eNerf, oPC, HoursToSeconds(d4()));
}
