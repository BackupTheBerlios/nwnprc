// Devilweed initial and side effects

#include "spinc_common"

void main()
{
	object oPC = OBJECT_SELF;
	effect eff = EffectAbilityDecrease(ABILITY_WISDOM,1);
	
	SPApplyEffectToObject(DURATION_TYPE_PERMANENT, eff, oPC);
	
	eff2 = EffectSavingThrowDecrease(SAVING_THROW_WILL, 2, SAVING_THROW_TYPE_MIND_SPELLS);
	SPApplyEffectToObject(DURATION_TYPE_TEMPORARY, eff2, oPC, HoursToSeconds(d3()));
	
	effect eVis = EffectVisualEffect(VFX_IMP_MAGIC_RESISTANCE_USE);
	SPApplyEffectToObject(DURATION_TYPE_INSTANT, eVis, oPC);
}
