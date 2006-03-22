// Luhix initial effects
void main()
{
    // Initial effect
    effect eff = EffectAbilityDecrease(ABILITY_CHARISMA,1);
    ApplyEffectToObject(DURATION_TYPE_PERMANENT,eff,OBJECT_SELF);
    eff = EffectAbilityDecrease(ABILITY_CONSTITUTION,1);
    ApplyEffectToObject(DURATION_TYPE_PERMANENT,eff,OBJECT_SELF);
    eff = EffectAbilityDecrease(ABILITY_DEXTERITY,1);
    ApplyEffectToObject(DURATION_TYPE_PERMANENT,eff,OBJECT_SELF);
    eff = EffectAbilityDecrease(ABILITY_INTELLIGENCE,1);
    ApplyEffectToObject(DURATION_TYPE_PERMANENT,eff,OBJECT_SELF);
    eff = EffectAbilityDecrease(ABILITY_STRENGTH,1);
    ApplyEffectToObject(DURATION_TYPE_PERMANENT,eff,OBJECT_SELF);
    eff = EffectAbilityDecrease(ABILITY_WISDOM,1);
    ApplyEffectToObject(DURATION_TYPE_PERMANENT,eff,OBJECT_SELF);

    PlayVoiceChat(VOICE_CHAT_PAIN1);

}
