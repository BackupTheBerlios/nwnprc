// Baccaran secondary effects
void main()
{
    effect eff = EffectAbilityIncrease(ABILITY_WISDOM,d6()+1);
    ApplyEffectToObject(DURATION_TYPE_TEMPORARY,eff,OBJECT_SELF,HoursToSeconds(d2()));

}
