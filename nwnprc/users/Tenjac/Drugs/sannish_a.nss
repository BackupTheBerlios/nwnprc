// Sannish initial and side effects

#include "spinc_common"

void main()
{
	object oPC = OBJECT_SELF;
	
	ApplyAbilityDamage(oPC, ABILITY_WISDOM, 1, DURATION_TYPE_TEMPORARY, TRUE, -1.0f);
	
	effect eNerf = EffectAttackDecrease(1);
	SPApplyEffectToObject(DURATION_TYPE_TEMPORARY, eNerf, oPC, HoursToSeconds(d4()));
}
