// Mushroom powder overdose
void main()
{
    effect eff = EffectDamage(d6(3));
    ApplyEffectToObject(DURATION_TYPE_INSTANT,eff,OBJECT_SELF);
    eff = EffectParalyze();
    ApplyEffectToObject(DURATION_TYPE_TEMPORARY,eff,OBJECT_SELF,HoursToSeconds(d4()));

}
