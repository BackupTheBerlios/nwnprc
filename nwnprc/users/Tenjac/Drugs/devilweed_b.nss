// Devilweed secondary effects

#include "spinc_common"

void main()
{
	object oPC = OBJECT_SELF;
	effect eStr = EffectAbilityIncrease(ABILITY_STRENGTH,4);
	SPApplyEffectToObject(DURATION_TYPE_TEMPORARY, eStr, oPC, HoursToSeconds(d3()));
}
