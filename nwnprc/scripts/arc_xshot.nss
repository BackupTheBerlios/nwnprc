void main()
{
 object oTarget = GetSpellTargetObject();
 ApplyEffectToObject(DURATION_TYPE_PERMANENT,EffectModifyAttacks(1),oTarget);
 ApplyEffectToObject(DURATION_TYPE_TEMPORARY,EffectVisualEffect(VFX_FNF_LOS_HOLY_20),oTarget,2.0);
}
