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
    effect eVis = EffectVisualEffect(VFX_DUR_MAGICAL_SIGHT);
    effect eVis2 = EffectVisualEffect(VFX_DUR_BARD_SONG);
    effect eDur = EffectVisualEffect(VFX_DUR_CESSATE_POSITIVE);
    effect eImpact = EffectVisualEffect(VFX_IMP_HEAD_SONIC);
    eVis = EffectLinkEffects(eVis, eImpact);
    effect eFNF = EffectVisualEffect(VFX_FNF_LOS_NORMAL_30);
    ApplyEffectAtLocation(DURATION_TYPE_INSTANT, eFNF, GetLocation(OBJECT_SELF));

    effect eSight = EffectTrueSeeing();
        if(GetPRCSwitch(PRC_PNP_TRUESEEING))
    {
        eSight = EffectSeeInvisible();
        int nSpot = GetPRCSwitch(PRC_PNP_TRUESEEING_SPOT_BONUS);
        if(nSpot == 0)
            nSpot = 15;
        effect eSpot = EffectSkillIncrease(SKILL_SPOT, nSpot);
        effect eUltra = EffectUltravision();
        eSight = EffectLinkEffects(eSight, eSpot);
        eSight = EffectLinkEffects(eSight, eUltra);
    }

    effect eLink = EffectLinkEffects(eSight, eVis);
    eLink = EffectLinkEffects(eLink, eDur);

    object oTarget = GetFirstObjectInShape(SHAPE_SPHERE, RADIUS_SIZE_COLOSSAL, GetLocation(OBJECT_SELF));
    while(GetIsObjectValid(oTarget))
    {
      if (!PRCGetHasEffect(EFFECT_TYPE_SILENCE,oTarget) && !PRCGetHasEffect(EFFECT_TYPE_DEAF,oTarget))
      {
        if(oTarget == OBJECT_SELF)
        {
            SignalEvent(oTarget, EventSpellCastAt(OBJECT_SELF, 186, FALSE));
            effect eLinkBard = EffectLinkEffects(eLink, eVis2);
            eLinkBard = ExtraordinaryEffect(eLinkBard);
            ApplyEffectToObject(DURATION_TYPE_TEMPORARY, eLinkBard, oTarget, TurnsToSeconds(nDuration));
        }
        else if(GetIsReactionTypeFriendly(oTarget) || GetFactionEqual(oTarget))
        {
            SignalEvent(oTarget, EventSpellCastAt(OBJECT_SELF, 186, FALSE));
            eLink = ExtraordinaryEffect(eLink);
            ApplyEffectToObject(DURATION_TYPE_TEMPORARY, eLink, oTarget, TurnsToSeconds(nDuration));
        }
        oTarget = MyNextObjectInShape(SHAPE_SPHERE, RADIUS_SIZE_COLOSSAL, GetLocation(OBJECT_SELF));
      }
    }
}

