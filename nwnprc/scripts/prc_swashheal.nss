#include "prc_feat_const"

void main()
{
   int HealInt = GetIsImmune(GetSpellTargetObject(),IMMUNITY_TYPE_CRITICAL_HIT) ? 1 : 0;
       HealInt = GetIsImmune(GetSpellTargetObject(),IMMUNITY_TYPE_SNEAK_ATTACK) ? 1 : HealInt;
   
         if (HealInt>0)
             {
             ApplyEffectToObject(DURATION_TYPE_INSTANT,EffectHeal(GetAbilityModifier(ABILITY_INTELLIGENCE, OBJECT_SELF)),GetSpellTargetObject());
             }
}