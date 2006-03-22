// Devilweed secondary effects
void main()
{
    effect eff = EffectAbilityIncrease(ABILITY_STRENGTH,4);
    ApplyEffectToObject(DURATION_TYPE_TEMPORARY,eff,OBJECT_SELF,HoursToSeconds(d3()));
}
