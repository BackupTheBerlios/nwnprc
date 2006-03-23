// Luhix overdose

#include "spinc_common"

void main()
{
	object oPC = OBJECT_SELF;
	if(!FortitudeSave(oPC, 25, SAVING_THROW_TYPE_POISON))
	{
		PlayVoiceChat(VOICE_CHAT_PAIN3);
		DelayCommand(3.0,SPApplyEffectToObject(DURATION_TYPE_INSTANT, EffectDeath(), oPC));
	}
}
