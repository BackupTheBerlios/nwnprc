// Baccaran initial and side effects

#include "spinc_common"

void main()
{
	object oPC = OBJECT_SELF;
	effect eff = EffectAbilityDecrease(ABILITY_STRENGTH,d4());
	SPApplyEffectToObject(DURATION_TYPE_PERMANENT, eff, oPC);
	
	eff2 = EffectSavingThrowDecrease(SAVING_THROW_WILL,2,SAVING_THROW_TYPE_MIND_SPELLS);
	SPApplyEffectToObject(DURATION_TYPE_TEMPORARY, eff2, oPC, HoursToSeconds(d4(2)));
	
}
