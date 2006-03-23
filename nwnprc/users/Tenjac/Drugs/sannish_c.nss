// Sannish overdose

#include "spinc_common"

void main()
{
	object oPC = OBJECT_SELF;
	effect eDaze = EffectDazed();
	float fDur = HoursToSeconds(d4(2));
	
	SPApplyEffectToObject(DURATION_TYPE_TEMPORARY, eDaze, oPC, fDur);
}
