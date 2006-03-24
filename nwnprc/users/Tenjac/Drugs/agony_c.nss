//Agony overdose

#include "spinc_common"

void main()
{
	if(!PRCMySavingThrow(SAVING_THROW_FORT, oPC, 18, SAVING_THROW_TYPE_POISON))
	{
		object oPC = OBJECT_SELF;
		float fDur = HoursToSeconds(d4(1));
		effect eBlind = EffectBlindness();
		effect eDeaf = EffectDeaf();
		effect eLink = EffectLinkEffects(eBlind, eDeaf);	
		
		//Blind/deaf
		SPApplyEffectToObject(DURATION_TYPE_TEMPORARY, eLink, oPC, (fDur - 1.0f));
			
		//Clear all actions
		AssignCommand(oPC, ClearAllActions());
		
		//Animation		
		PlayAnimation(ANIMATION_LOOPING_DEAD_BACK, fDur);
				
		//Make them sit and wait.  That's what you get.  JUST SAY NO!
		DelayCommand(0.2,SetCommandable(FALSE, oPC));
		
		//Restore Control
		DelayCommand((fDur - 0.2), SetCommandable(TRUE, oPC));
	}
}
		
		