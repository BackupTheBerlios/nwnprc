#include "prc_inc_spells"

void main()
{
    if (PRCGetHasEffect(EFFECT_TYPE_SILENCE,OBJECT_SELF))
    {
        FloatingTextStrRefOnCreature(85764,OBJECT_SELF); // not useable when silenced
        return;
    }

    //Declare major variables
    effect eImpact = EffectVisualEffect(VFX_IMP_REMOVE_CONDITION);
    effect eFNF = EffectVisualEffect(VFX_FNF_LOS_NORMAL_30);
    ApplyEffectAtLocation(DURATION_TYPE_INSTANT, eFNF, GetLocation(OBJECT_SELF));

    object oTarget = GetFirstObjectInShape(SHAPE_SPHERE, RADIUS_SIZE_COLOSSAL, GetLocation(OBJECT_SELF));
    while(GetIsObjectValid(oTarget))
    {
      if (!PRCGetHasEffect(EFFECT_TYPE_SILENCE,oTarget) && !PRCGetHasEffect(EFFECT_TYPE_DEAF,oTarget))
      {
        if(GetIsReactionTypeFriendly(oTarget) || GetFactionEqual(oTarget))
        {
        SignalEvent(oTarget, EventSpellCastAt(OBJECT_SELF, SPELL_REMOVE_CURSE, FALSE));
        effect eRemove = GetFirstEffect(oTarget);
        //Search for negative effects
        //Get the first effect on the target
        while(GetIsEffectValid(eRemove))
          {
            //Check if the current effect is of correct type
            if (GetEffectType(eRemove) == EFFECT_TYPE_CURSE)
            {
                //Remove the effect and apply VFX impact
                RemoveEffect(oTarget, eRemove);
                ApplyEffectToObject(DURATION_TYPE_INSTANT, eImpact, oTarget);
            }
            //Get the next effect on the target
            GetNextEffect(oTarget);
          }
        }
        oTarget = MyNextObjectInShape(SHAPE_SPHERE, RADIUS_SIZE_COLOSSAL, GetLocation(OBJECT_SELF));
      }
    }
}

