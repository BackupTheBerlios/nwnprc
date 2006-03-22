// Luhix overdose
void main()
{
    if(!FortitudeSave(OBJECT_SELF,25,SAVING_THROW_TYPE_POISON))
    {
        PlayVoiceChat(VOICE_CHAT_PAIN3);
        DelayCommand(3.0,ApplyEffectToObject(DURATION_TYPE_INSTANT,EffectDeath(),OBJECT_SELF));
    }
}
