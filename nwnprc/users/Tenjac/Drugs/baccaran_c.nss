// Mushroom powder overdose

#include "spinc_common"

void main()
{
	object oPC = OBJECT_SELF;
	effect eff = EffectDamage(d6(2));
	
	SPApplyEffectToObject(DURATION_TYPE_INSTANT, eff, oPC);
	
	eff2 = EffectSavingThrowDecrease(SAVING_THROW_WILL, 2, SAVING_THROW_TYPE_MIND_SPELLS);
	
	SPApplyEffectToObject(DURATION_TYPE_TEMPORARY, eff2, oPC, HoursToSeconds(d4(2)));

}
