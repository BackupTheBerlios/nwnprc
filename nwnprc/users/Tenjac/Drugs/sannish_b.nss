// Sannish secondary effects

#include "spinc_common"

void main()
{
	object oPC = OBJECT_SELF;
	
	effect eCon = EffectAbilityIncrease(ABILITY_CONSTITUTION, 2);
	SPApplyEffectToObject(DURATION_TYPE_TEMPORARY, eCon, oPC, HoursToSeconds(d4()));
}
