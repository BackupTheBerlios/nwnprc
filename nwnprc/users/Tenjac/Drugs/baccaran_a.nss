// Baccaran initial and side effects
void main()
{
    effect eff = EffectAbilityDecrease(ABILITY_STRENGTH,d4());
    ApplyEffectToObject(DURATION_TYPE_PERMANENT,eff,OBJECT_SELF);

    eff = EffectSavingThrowDecrease(SAVING_THROW_WILL,2,SAVING_THROW_TYPE_MIND_SPELLS);
    ApplyEffectToObject(DURATION_TYPE_TEMPORARY,eff,OBJECT_SELF,HoursToSeconds(d4(2)));

}
