#include "prc_alterations"

void main()
{
 object oTarget = PRCGetSpellTargetObject();

 PRCRemoveEffectsFromSpell(oTarget, GetSpellId());

 ApplyEffectToObject(DURATION_TYPE_PERMANENT,SupernaturalEffect(EffectModifyAttacks(1)),oTarget);
 //ApplyEffectToObject(DURATION_TYPE_TEMPORARY,EffectVisualEffect(VFX_FNF_LOS_HOLY_20),oTarget,2.0);
}
