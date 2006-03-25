// Devilweed initial and side effects

#include "spinc_common"

void main()
{
	object oPC = OBJECT_SELF;
	ApplyAbilityDamage(oPC, ABILITY_WISDOM, 1, DURATION_TYPE_TEMPORARY, TRUE, -1.0f);
	
	SPApplyEffectToObject(DURATION_TYPE_PERMANENT, eff, oPC);
	
	effect eMind = EffectSavingThrowDecrease(SAVING_THROW_WILL, 2, SAVING_THROW_TYPE_MIND_SPELLS);
	SPApplyEffectToObject(DURATION_TYPE_TEMPORARY, eMind, oPC, HoursToSeconds(d3()));
	
	effect eVis = EffectVisualEffect(VFX_IMP_MAGIC_RESISTANCE_USE);
	SPApplyEffectToObject(DURATION_TYPE_INSTANT, eVis, oPC);
}
