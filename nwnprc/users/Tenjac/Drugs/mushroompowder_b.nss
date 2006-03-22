// Mushroom powder secondary effects
void main()
{
    effect eff = EffectAbilityDecrease(ABILITY_STRENGTH,1);
    ApplyEffectToObject(DURATION_TYPE_PERMANENT,SupernaturalEffect(eff),OBJECT_SELF);
}
