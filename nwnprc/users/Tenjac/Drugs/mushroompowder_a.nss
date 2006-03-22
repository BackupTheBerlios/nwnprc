// Mushroom powder initial effects and side effects
void main()
{
    // Initial effect
    effect eff = EffectAbilityIncrease(ABILITY_INTELLIGENCE,2);
    eff = EffectLinkEffects(EffectAbilityIncrease(ABILITY_CHARISMA,2),eff);
    ApplyEffectToObject(DURATION_TYPE_TEMPORARY,SupernaturalEffect(eff),OBJECT_SELF,HoursToSeconds(1));

    // Side effects
    eff = EffectAbilityDecrease(ABILITY_WISDOM,2);
    ApplyEffectToObject(DURATION_TYPE_TEMPORARY,SupernaturalEffect(eff),OBJECT_SELF,HoursToSeconds(d4()));

    eff = EffectAbilityDecrease(ABILITY_STRENGTH,2);
    eff = EffectLinkEffects(EffectAbilityDecrease(ABILITY_CONSTITUTION,2),eff);
    ApplyEffectToObject(DURATION_TYPE_TEMPORARY,SupernaturalEffect(eff),OBJECT_SELF,HoursToSeconds(d4(2)));
}
