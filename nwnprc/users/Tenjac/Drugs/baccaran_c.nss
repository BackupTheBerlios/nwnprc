// Baccaran overdose

#include "spinc_common"

void main()
{
	object oPC = OBJECT_SELF;
	effect eDam = EffectDamage(d6(2));
	
	SPApplyEffectToObject(DURATION_TYPE_INSTANT, eDam, oPC);
	
	effect eSave = EffectSavingThrowDecrease(SAVING_THROW_WILL, 2, SAVING_THROW_TYPE_MIND_SPELLS);
	
	SPApplyEffectToObject(DURATION_TYPE_TEMPORARY, eSave, oPC, HoursToSeconds(d4(2)));

}
