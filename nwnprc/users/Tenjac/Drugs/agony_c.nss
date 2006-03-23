//Agony overdose

#include "spinc_common"

void main()
{
	if(!PRCMySavingThrow(SAVING_THROW_FORT, oPC, 18, SAVING_THROW_TYPE_POISON))
	{
		object oPC = OBJECT_SELF;
		float fDur = HoursToSeconds(d4(1));
		effect ePar = EffectCutsceneParalyze();
		
		//Paralyze
		SPApplyEffectToObject(DURATION_TYPE_TEMPORARY, ePar, oPC, fDur);
		
		PlayAnimation(ANIMATION_LOOPING_DEAD_BACK, fDur);
	}
}
		
		