// Sannish initial and side effects
void main()
{
    effect eff = EffectAbilityDecrease(ABILITY_WISDOM,1);
    ApplyEffectToObject(DURATION_TYPE_PERMANENT,eff,OBJECT_SELF);
    eff = EffectAttackDecrease(1);
    ApplyEffectToObject(DURATION_TYPE_TEMPORARY,eff,OBJECT_SELF,HoursToSeconds(d4()));
}
