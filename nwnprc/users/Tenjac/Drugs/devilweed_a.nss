// Devilweed initial and side effects
void main()
{
    effect eff = EffectAbilityDecrease(ABILITY_WISDOM,1);
    ApplyEffectToObject(DURATION_TYPE_PERMANENT,eff,OBJECT_SELF);
    eff = EffectSavingThrowDecrease(SAVING_THROW_WILL,2,SAVING_THROW_TYPE_MIND_SPELLS);
    ApplyEffectToObject(DURATION_TYPE_TEMPORARY,eff,OBJECT_SELF,HoursToSeconds(d3()));

    effect eVis = EffectVisualEffect(VFX_IMP_MAGIC_RESISTANCE_USE);
    ApplyEffectToObject(DURATION_TYPE_INSTANT,eVis,OBJECT_SELF);
}
