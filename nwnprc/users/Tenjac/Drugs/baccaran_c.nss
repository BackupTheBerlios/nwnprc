// Mushroom powder overdose
void main()
{
    effect eff = EffectDamage(d6(2));
    ApplyEffectToObject(DURATION_TYPE_INSTANT,eff,OBJECT_SELF);
    eff = EffectSavingThrowDecrease(SAVING_THROW_WILL,2,SAVING_THROW_TYPE_MIND_SPELLS);
    ApplyEffectToObject(DURATION_TYPE_TEMPORARY,eff,OBJECT_SELF,HoursToSeconds(d4(2)));

}
