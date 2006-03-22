// Luhix secondary and side effects
void main()
{
    // Secondary effects
    float fDur = HoursToSeconds(d3());
    effect eff = EffectAbilityIncrease(ABILITY_CHARISMA,2);
    ApplyEffectToObject(DURATION_TYPE_TEMPORARY,eff,OBJECT_SELF,fDur);
    eff = EffectAbilityIncrease(ABILITY_CONSTITUTION,2);
    ApplyEffectToObject(DURATION_TYPE_TEMPORARY,eff,OBJECT_SELF,fDur);
    eff = EffectAbilityIncrease(ABILITY_DEXTERITY,2);
    ApplyEffectToObject(DURATION_TYPE_TEMPORARY,eff,OBJECT_SELF,fDur);
    eff = EffectAbilityIncrease(ABILITY_INTELLIGENCE,2);
    ApplyEffectToObject(DURATION_TYPE_TEMPORARY,eff,OBJECT_SELF,fDur);
    eff = EffectAbilityIncrease(ABILITY_STRENGTH,2);
    ApplyEffectToObject(DURATION_TYPE_TEMPORARY,eff,OBJECT_SELF,fDur);
    eff = EffectAbilityIncrease(ABILITY_WISDOM,2);
    ApplyEffectToObject(DURATION_TYPE_TEMPORARY,eff,OBJECT_SELF,fDur);

    // Side effect
    eff = EffectTemporaryHitpoints(d8()+2);
    ApplyEffectToObject(DURATION_TYPE_TEMPORARY,eff,OBJECT_SELF,fDur);
}
