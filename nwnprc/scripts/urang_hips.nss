#include "NW_I0_SPELLS"

void main()
{

   if (GetHasSpellEffect(SPELL_UR_HIPS))
   {
     RemoveEffectsFromSpell(OBJECT_SELF,SPELL_UR_HIPS);  
     return;	
   }

    object oTarget = GetSpellTargetObject();
    effect eMov = EffectMovementSpeedDecrease(50);
    effect eInvis = EffectInvisibility(INVISIBILITY_TYPE_NORMAL);
    effect eLink = EffectLinkEffects(eInvis, eMov);

    ApplyEffectToObject(DURATION_TYPE_PERMANENT, SupernaturalEffect(eLink), oTarget);

}