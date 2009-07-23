#include "prc_inc_spells"

void main()
{
    if (PRCGetHasEffect(EFFECT_TYPE_SILENCE,OBJECT_SELF))
    {
        FloatingTextStrRefOnCreature(85764,OBJECT_SELF); // not useable when silenced
        return;
    }

    //Declare major variables
    int CasterLvl = GetPrCAdjustedCasterLevelByType(TYPE_DIVINE,OBJECT_SELF,1);
    int nDuration = CasterLvl;
    effect eVis = EffectVisualEffect(VFX_DUR_FREEDOM_OF_MOVEMENT);
    effect eVis2 = EffectVisualEffect(VFX_DUR_BARD_SONG);
    effect eDur = EffectVisualEffect(VFX_DUR_CESSATE_POSITIVE);
    effect eImpact = EffectVisualEffect(VFX_IMP_HEAD_SONIC);
    eVis = EffectLinkEffects(eVis, eImpact);
    effect eFNF = EffectVisualEffect(VFX_FNF_LOS_NORMAL_30);
    ApplyEffectAtLocation(DURATION_TYPE_INSTANT, eFNF, GetLocation(OBJECT_SELF));

    effect eParal = EffectImmunity(IMMUNITY_TYPE_PARALYSIS);
    effect eEntangle = EffectImmunity(IMMUNITY_TYPE_ENTANGLE);
    effect eSlow = EffectImmunity(IMMUNITY_TYPE_SLOW);
    effect eMove = EffectImmunity(IMMUNITY_TYPE_MOVEMENT_SPEED_DECREASE);

    effect eLink = EffectLinkEffects(eParal, eEntangle);
    eLink = EffectLinkEffects(eLink, eSlow);
    eLink = EffectLinkEffects(eLink, eVis);
    eLink = EffectLinkEffects(eLink, eDur);
    eLink = EffectLinkEffects(eLink, eMove);

    object oTarget = GetFirstObjectInShape(SHAPE_SPHERE, RADIUS_SIZE_COLOSSAL, GetLocation(OBJECT_SELF));
    while(GetIsObjectValid(oTarget))
    {
      if (!PRCGetHasEffect(EFFECT_TYPE_SILENCE,oTarget) && !PRCGetHasEffect(EFFECT_TYPE_DEAF,oTarget))
      {
        if(oTarget == OBJECT_SELF)
        {
            SignalEvent(oTarget, EventSpellCastAt(OBJECT_SELF, 62, FALSE));
            effect eLinkBard = EffectLinkEffects(eLink, eVis2);
            eLinkBard = ExtraordinaryEffect(eLinkBard);
            ApplyEffectToObject(DURATION_TYPE_TEMPORARY, eLinkBard, oTarget, TurnsToSeconds(nDuration));
            //Search for and remove the above negative effects
            effect eLook = GetFirstEffect(oTarget);
            while(GetIsEffectValid(eLook))
            {
              if(GetEffectType(eLook) == EFFECT_TYPE_PARALYZE ||
                  GetEffectType(eLook) == EFFECT_TYPE_ENTANGLE ||
                  GetEffectType(eLook) == EFFECT_TYPE_SLOW ||
                  GetEffectType(eLook) == EFFECT_TYPE_MOVEMENT_SPEED_DECREASE)
              {
                  RemoveEffect(oTarget, eLook);
              }
            eLook = GetNextEffect(oTarget);
            }
        }
        else if(GetIsReactionTypeFriendly(oTarget) || GetFactionEqual(oTarget))
        {
            SignalEvent(oTarget, EventSpellCastAt(OBJECT_SELF, 62, FALSE));
            eLink = ExtraordinaryEffect(eLink);
            ApplyEffectToObject(DURATION_TYPE_TEMPORARY, eLink, oTarget, TurnsToSeconds(nDuration));
            //Search for and remove the above negative effects
            effect eLook = GetFirstEffect(oTarget);
            while(GetIsEffectValid(eLook))
            {
              if(GetEffectType(eLook) == EFFECT_TYPE_PARALYZE ||
                  GetEffectType(eLook) == EFFECT_TYPE_ENTANGLE ||
                  GetEffectType(eLook) == EFFECT_TYPE_SLOW ||
                  GetEffectType(eLook) == EFFECT_TYPE_MOVEMENT_SPEED_DECREASE)
              {
                  RemoveEffect(oTarget, eLook);
              }
            eLook = GetNextEffect(oTarget);
            }
        }
        oTarget = MyNextObjectInShape(SHAPE_SPHERE, RADIUS_SIZE_COLOSSAL, GetLocation(OBJECT_SELF));
      }
    }
}

