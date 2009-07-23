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
    effect eVis = EffectVisualEffect(VFX_IMP_IMPROVE_ABILITY_SCORE);
    effect eVis2 = EffectVisualEffect(VFX_DUR_BARD_SONG);
    effect eDur = EffectVisualEffect(VFX_DUR_CESSATE_POSITIVE);
    effect eFNF = EffectVisualEffect(VFX_FNF_LOS_NORMAL_30);
    ApplyEffectAtLocation(DURATION_TYPE_INSTANT, eFNF, GetLocation(OBJECT_SELF));

    int nRaise = d4(1) + 1;
    effect eRaise = EffectAbilityIncrease(ABILITY_CONSTITUTION, nRaise);

    effect eLink = EffectLinkEffects(eRaise, eDur);

    object oTarget = GetFirstObjectInShape(SHAPE_SPHERE, RADIUS_SIZE_COLOSSAL, GetLocation(OBJECT_SELF));
    while(GetIsObjectValid(oTarget))
    {
      if (!PRCGetHasEffect(EFFECT_TYPE_SILENCE,oTarget) && !PRCGetHasEffect(EFFECT_TYPE_DEAF,oTarget))
      {
        if(oTarget == OBJECT_SELF)
        {
            SignalEvent(oTarget, EventSpellCastAt(OBJECT_SELF, SPELL_ENDURANCE, FALSE));
            effect eLinkBard = EffectLinkEffects(eLink, eVis2);
            eLinkBard = ExtraordinaryEffect(eLinkBard);
            ApplyEffectToObject(DURATION_TYPE_INSTANT, eVis, oTarget);
            ApplyEffectToObject(DURATION_TYPE_TEMPORARY, eLinkBard, oTarget, HoursToSeconds(nDuration));
        }
        else if(GetIsReactionTypeFriendly(oTarget) || GetFactionEqual(oTarget))
        {
            SignalEvent(oTarget, EventSpellCastAt(OBJECT_SELF, SPELL_ENDURANCE, FALSE));
            eLink = ExtraordinaryEffect(eLink);
            ApplyEffectToObject(DURATION_TYPE_INSTANT, eVis, oTarget);
            ApplyEffectToObject(DURATION_TYPE_TEMPORARY, eLink, oTarget, HoursToSeconds(nDuration));
        }
        oTarget = MyNextObjectInShape(SHAPE_SPHERE, RADIUS_SIZE_COLOSSAL, GetLocation(OBJECT_SELF));
      }
    }
}

