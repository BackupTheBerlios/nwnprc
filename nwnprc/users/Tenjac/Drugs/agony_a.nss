// Agony initial and side effects

#include "spinc_common"

void main()
{
	object oPC = OBJECT_SELF;
	effect eff = EffectStun();
	float fDur = RoundsToSeconds(d4(1) + 1);
	float fDaze = ((d6(1) + 1) * 60.0f);
	SPApplyEffectToObject(DURATION_TYPE_TEMPORARY,eff,oPC, fDur);
	
	eff2 = EffectDazed();
	DelayCommand(fDur, SPApplyEffectToObject(DURATION_TYPE_TEMPORARY, eff2, oPC, fDaze));	
}
