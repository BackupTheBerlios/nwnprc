// Baccaran initial and side effects

#include "spinc_common"

void main()
{
	object oPC = OBJECT_SELF;
	ApplyAbilityDamage(oPC, ABILITY_STRENGTH, 4, DURATION_TYPE_TEMPORARY, TRUE, -1.0f);
	
	effect eMind = EffectSavingThrowDecrease(SAVING_THROW_WILL,2,SAVING_THROW_TYPE_MIND_SPELLS);
	SPApplyEffectToObject(DURATION_TYPE_TEMPORARY, eMind, oPC, HoursToSeconds(d4(2)));
	
}
