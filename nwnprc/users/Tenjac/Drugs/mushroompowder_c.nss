// Mushroom powder overdose

#include "spinc_common"

void main()
{
	object oPC = OBJECT_SELF;
	effect eDam = EffectDamage(d6(2));
	
	
	SPApplyEffectToObject(DURATION_TYPE_INSTANT, eDam, oPC);
}
