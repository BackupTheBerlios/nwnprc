// Sannish secondary effects
void main()
{
    effect eff = EffectAbilityIncrease(ABILITY_CONSTITUTION,2);
    ApplyEffectToObject(DURATION_TYPE_TEMPORARY,eff,OBJECT_SELF,HoursToSeconds(d4()));
}
