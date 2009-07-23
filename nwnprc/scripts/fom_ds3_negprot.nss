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
    effect eVis = EffectVisualEffect(VFX_IMP_HOLY_AID);
    effect eVis2 = EffectVisualEffect(VFX_DUR_BARD_SONG);
    effect eFNF = EffectVisualEffect(VFX_FNF_LOS_NORMAL_30);
    ApplyEffectAtLocation(DURATION_TYPE_INSTANT, eFNF, GetLocation(OBJECT_SELF));

    effect eNeg = EffectDamageImmunityIncrease(DAMAGE_TYPE_NEGATIVE, 100);
    effect eLevel = EffectImmunity(IMMUNITY_TYPE_NEGATIVE_LEVEL);
    effect eAbil = EffectImmunity(IMMUNITY_TYPE_ABILITY_DECREASE);

    effect eLink = EffectLinkEffects(eNeg, eLevel);
    eLink = EffectLinkEffects(eLink, eAbil);

    object oTarget = GetFirstObjectInShape(SHAPE_SPHERE, RADIUS_SIZE_COLOSSAL, GetLocation(OBJECT_SELF));
    while(GetIsObjectValid(oTarget))
    {
      if (!PRCGetHasEffect(EFFECT_TYPE_SILENCE,oTarget) && !PRCGetHasEffect(EFFECT_TYPE_DEAF,oTarget))
      {
        if(oTarget == OBJECT_SELF)
        {
            SignalEvent(oTarget, EventSpellCastAt(OBJECT_SELF, SPELL_NEGATIVE_ENERGY_PROTECTION, FALSE));
            effect eLinkBard = EffectLinkEffects(eLink, eVis2);
            eLinkBard = ExtraordinaryEffect(eLinkBard);
            ApplyEffectToObject(DURATION_TYPE_INSTANT, eVis, oTarget);
            ApplyEffectToObject(DURATION_TYPE_TEMPORARY, eLinkBard, oTarget, TurnsToSeconds(nDuration));
        }
        else if(GetIsReactionTypeFriendly(oTarget) || GetFactionEqual(oTarget))
        {
            SignalEvent(oTarget, EventSpellCastAt(OBJECT_SELF, SPELL_NEGATIVE_ENERGY_PROTECTION, FALSE));
            eLink = ExtraordinaryEffect(eLink);
            ApplyEffectToObject(DURATION_TYPE_INSTANT, eVis, oTarget);
            ApplyEffectToObject(DURATION_TYPE_TEMPORARY, eLink, oTarget, TurnsToSeconds(nDuration));
        }
        oTarget = MyNextObjectInShape(SHAPE_SPHERE, RADIUS_SIZE_COLOSSAL, GetLocation(OBJECT_SELF));
      }
    }
}

