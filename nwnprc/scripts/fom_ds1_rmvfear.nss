#include "prc_inc_spells"

void main()
{
    if (PRCGetHasEffect(EFFECT_TYPE_SILENCE,OBJECT_SELF))
    {
        FloatingTextStrRefOnCreature(85764,OBJECT_SELF); // not useable when silenced
        return;
    }

    //Declare major variables
    effect eFear;
    int nDuration = 100;

    effect eVis = EffectVisualEffect(VFX_IMP_REMOVE_CONDITION);
    effect eFNF = EffectVisualEffect(VFX_FNF_LOS_NORMAL_30);
    ApplyEffectAtLocation(DURATION_TYPE_INSTANT, eFNF, GetLocation(OBJECT_SELF));

    effect eSave = EffectSavingThrowIncrease(SAVING_THROW_WILL, 4, SAVING_THROW_TYPE_FEAR);
    effect eMind = EffectVisualEffect(VFX_DUR_MIND_AFFECTING_POSITIVE);
    effect eDur = EffectVisualEffect(VFX_DUR_CESSATE_POSITIVE);

    effect eLink = EffectLinkEffects(eMind, eSave);
    eLink = EffectLinkEffects(eLink, eDur);

    object oTarget = GetFirstObjectInShape(SHAPE_SPHERE, RADIUS_SIZE_COLOSSAL, GetLocation(OBJECT_SELF));
    while(GetIsObjectValid(oTarget))
    {
      if (!PRCGetHasEffect(EFFECT_TYPE_SILENCE,oTarget) && !PRCGetHasEffect(EFFECT_TYPE_DEAF,oTarget))
      {
        if(GetIsReactionTypeFriendly(oTarget) || GetFactionEqual(oTarget))
        {
        float fDelay = PRCGetRandomDelay();
        SignalEvent(oTarget, EventSpellCastAt(OBJECT_SELF, SPELL_REMOVE_FEAR, FALSE));
        eFear = GetFirstEffect(oTarget);
            //Get the first effect on the current target
            while(GetIsEffectValid(eFear))
            {
                if (GetEffectType(eFear) == EFFECT_TYPE_FRIGHTENED)
                {
                    //Remove any fear effects and apply the VFX impact
                    RemoveEffect(oTarget, eFear);
                    ApplyEffectToObject(DURATION_TYPE_INSTANT, eVis, oTarget);
                }
                //Get the next effect on the target
                eFear = GetNextEffect(oTarget);
            }
            //Apply the linked effects
            DelayCommand(fDelay, ApplyEffectToObject(DURATION_TYPE_TEMPORARY, eLink, oTarget, RoundsToSeconds(nDuration)));
        }
        oTarget = MyNextObjectInShape(SHAPE_SPHERE, RADIUS_SIZE_COLOSSAL, GetLocation(OBJECT_SELF));
      }
    }
}

