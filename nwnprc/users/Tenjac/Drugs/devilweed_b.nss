// Devilweed secondary effects

#include "spinc_common"

void main()
{
	object oPC = OBJECT_SELF;
	effect eff = EffectAbilityIncrease(ABILITY_STRENGTH,4);
	SPApplyEffectToObject(DURATION_TYPE_TEMPORARY, eff, oPC, HoursToSeconds(d3()));
}
