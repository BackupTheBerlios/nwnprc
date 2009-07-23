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
    int nDuration = 24;
    int nAmount = 40;
    int nResistance = 30;
    
    effect eVis = EffectVisualEffect(VFX_IMP_ELEMENTAL_PROTECTION);
    effect eVis2 = EffectVisualEffect(VFX_DUR_BARD_SONG);
    effect eDur = EffectVisualEffect(VFX_DUR_CESSATE_POSITIVE);
    effect eDur2 = EffectVisualEffect(VFX_DUR_PROTECTION_ELEMENTS);
    effect eFNF = EffectVisualEffect(VFX_FNF_LOS_NORMAL_30);
    ApplyEffectAtLocation(DURATION_TYPE_INSTANT, eFNF, GetLocation(OBJECT_SELF));

    effect eCold = EffectDamageResistance(DAMAGE_TYPE_COLD, nResistance, nAmount);
    effect eFire = EffectDamageResistance(DAMAGE_TYPE_FIRE, nResistance, nAmount);
    effect eAcid = EffectDamageResistance(DAMAGE_TYPE_ACID, nResistance, nAmount);
    effect eSonic = EffectDamageResistance(DAMAGE_TYPE_SONIC, nResistance, nAmount);
    effect eElec = EffectDamageResistance(DAMAGE_TYPE_ELECTRICAL, nResistance, nAmount);

    effect eLink = EffectLinkEffects(eCold, eFire);
    eLink = EffectLinkEffects(eLink, eAcid);
    eLink = EffectLinkEffects(eLink, eSonic);
    eLink = EffectLinkEffects(eLink, eElec);
    eLink = EffectLinkEffects(eLink, eDur);
    eLink = EffectLinkEffects(eLink, eDur2);

    object oTarget = GetFirstObjectInShape(SHAPE_SPHERE, RADIUS_SIZE_COLOSSAL, GetLocation(OBJECT_SELF));
    while(GetIsObjectValid(oTarget))
    {
      if (!PRCGetHasEffect(EFFECT_TYPE_SILENCE,oTarget) && !PRCGetHasEffect(EFFECT_TYPE_DEAF,oTarget))
      {
        if(oTarget == OBJECT_SELF)
        {
            SignalEvent(oTarget, EventSpellCastAt(OBJECT_SELF, SPELL_PROTECTION_FROM_ELEMENTS, FALSE));
            PRCRemoveEffectsFromSpell(oTarget, 137);
            effect eLinkBard = EffectLinkEffects(eLink, eVis2);
            eLinkBard = ExtraordinaryEffect(eLinkBard);
            ApplyEffectToObject(DURATION_TYPE_INSTANT, eVis, oTarget);
            ApplyEffectToObject(DURATION_TYPE_TEMPORARY, eLinkBard, oTarget, HoursToSeconds(nDuration));
        }
        else if(GetIsReactionTypeFriendly(oTarget) || GetFactionEqual(oTarget))
        {
            SignalEvent(oTarget, EventSpellCastAt(OBJECT_SELF, SPELL_PROTECTION_FROM_ELEMENTS, FALSE));
            PRCRemoveEffectsFromSpell(oTarget, 137);
            eLink = ExtraordinaryEffect(eLink);
            ApplyEffectToObject(DURATION_TYPE_INSTANT, eVis, oTarget);
            ApplyEffectToObject(DURATION_TYPE_TEMPORARY, eLink, oTarget, HoursToSeconds(nDuration));
        }
        oTarget = MyNextObjectInShape(SHAPE_SPHERE, RADIUS_SIZE_COLOSSAL, GetLocation(OBJECT_SELF));
      }
    }
}

