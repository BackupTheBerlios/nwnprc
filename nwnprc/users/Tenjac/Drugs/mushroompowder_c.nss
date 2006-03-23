// Mushroom powder overdose

#include "spinc_common"

void main()
{
	object oPC = OBJECT_SELF;
	effect eDam = EffectDamage(d6(3));
	effect ePar = EffectParalyze();
	
	SPApplyEffectToObject(DURATION_TYPE_INSTANT, eDam, oPC);
	SPApplyEffectToObject(DURATION_TYPE_TEMPORARY, ePar, oPC, HoursToSeconds(d4()));
}
