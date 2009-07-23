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
    int bValid;
    int bVisual;
    effect eVis = EffectVisualEffect(VFX_DUR_MIND_AFFECTING_POSITIVE);
    effect eVis2 = EffectVisualEffect(VFX_DUR_BARD_SONG);
    effect eDur = EffectVisualEffect(VFX_DUR_CESSATE_POSITIVE);
    effect eFNF = EffectVisualEffect(VFX_FNF_LOS_NORMAL_30);
    ApplyEffectAtLocation(DURATION_TYPE_INSTANT, eFNF, GetLocation(OBJECT_SELF));

    effect eImm1 = EffectImmunity(IMMUNITY_TYPE_MIND_SPELLS);

    effect eLink = EffectLinkEffects(eImm1, eVis);
    eLink = EffectLinkEffects(eLink, eDur);

    object oTarget = GetFirstObjectInShape(SHAPE_SPHERE, RADIUS_SIZE_COLOSSAL, GetLocation(OBJECT_SELF));
    while(GetIsObjectValid(oTarget))
    {
      if (!PRCGetHasEffect(EFFECT_TYPE_SILENCE,oTarget) && !PRCGetHasEffect(EFFECT_TYPE_DEAF,oTarget))
      {
        if(oTarget == OBJECT_SELF)
        {
            effect eSearch = GetFirstEffect(oTarget);
            effect eDam = PRCEffectDamage(oTarget, 1, DAMAGE_TYPE_NEGATIVE);
            SignalEvent(oTarget, EventSpellCastAt(OBJECT_SELF, SPELL_CLARITY, FALSE));
                while(GetIsEffectValid(eSearch))
                   {
                        bValid = FALSE;
                        //Check to see if the effect matches a particular type defined below
                        if (GetEffectType(eSearch) == EFFECT_TYPE_DAZED)
                        {
                            bValid = TRUE;
                        }
                        else if(GetEffectType(eSearch) == EFFECT_TYPE_CHARMED)
                        {
                            bValid = TRUE;
                        }
                        else if(GetEffectType(eSearch) == EFFECT_TYPE_SLEEP)
                        {
                            bValid = TRUE;
                        }
                        else if(GetEffectType(eSearch) == EFFECT_TYPE_CONFUSED)
                        {
                            bValid = TRUE;
                        }
                        else if(GetEffectType(eSearch) == EFFECT_TYPE_STUNNED)
                        {
                            bValid = TRUE;
                        }
                        //Apply damage and remove effect if the effect is a match
                        if (bValid == TRUE)
                        {
                            SPApplyEffectToObject(DURATION_TYPE_INSTANT, eDam, oTarget);
                            RemoveEffect(oTarget, eSearch);
                            bVisual = TRUE;
                        }
                        eSearch = GetNextEffect(oTarget);
                    }

            effect eLinkBard = EffectLinkEffects(eLink, eVis2);
            eLinkBard = ExtraordinaryEffect(eLinkBard);
            ApplyEffectToObject(DURATION_TYPE_TEMPORARY, eLinkBard, oTarget, 30.0  + RoundsToSeconds(nDuration));
        }
        else if(GetIsReactionTypeFriendly(oTarget) || GetFactionEqual(oTarget))
        {
            effect eSearch = GetFirstEffect(oTarget);
            effect eDam = PRCEffectDamage(oTarget, 1, DAMAGE_TYPE_NEGATIVE);
            SignalEvent(oTarget, EventSpellCastAt(OBJECT_SELF, SPELL_CLARITY, FALSE));
                while(GetIsEffectValid(eSearch))
                   {
                        bValid = FALSE;
                        //Check to see if the effect matches a particular type defined below
                        if (GetEffectType(eSearch) == EFFECT_TYPE_DAZED)
                        {
                            bValid = TRUE;
                        }
                        else if(GetEffectType(eSearch) == EFFECT_TYPE_CHARMED)
                        {
                            bValid = TRUE;
                        }
                        else if(GetEffectType(eSearch) == EFFECT_TYPE_SLEEP)
                        {
                            bValid = TRUE;
                        }
                        else if(GetEffectType(eSearch) == EFFECT_TYPE_CONFUSED)
                        {
                            bValid = TRUE;
                        }
                        else if(GetEffectType(eSearch) == EFFECT_TYPE_STUNNED)
                        {
                            bValid = TRUE;
                        }
                        //Apply damage and remove effect if the effect is a match
                        if (bValid == TRUE)
                        {
                            SPApplyEffectToObject(DURATION_TYPE_INSTANT, eDam, oTarget);
                            RemoveEffect(oTarget, eSearch);
                            bVisual = TRUE;
                        }
                        eSearch = GetNextEffect(oTarget);
                    }
            eLink = ExtraordinaryEffect(eLink);
            ApplyEffectToObject(DURATION_TYPE_TEMPORARY, eLink, oTarget, 30.0  + RoundsToSeconds(nDuration));
        }
        oTarget = MyNextObjectInShape(SHAPE_SPHERE, RADIUS_SIZE_COLOSSAL, GetLocation(OBJECT_SELF));
      }
    }
}

