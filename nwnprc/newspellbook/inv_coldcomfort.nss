//::///////////////////////////////////////////////
//:: Endure Elements
//:: NW_S0_EndEle
//:: Copyright (c) 2001 Bioware Corp.
//:://////////////////////////////////////////////
/*
    Offers 10 points of elemental resistance.  If 20
    points of a single elemental type is done to the
    protected creature the spell fades
*/
//:://////////////////////////////////////////////
//:: Created By: Preston Watamaniuk
//:: Created On: Oct 23, 2001
//:://////////////////////////////////////////////

#include "spinc_common"
#include "inv_inc_invfunc"
#include "inv_invokehook"

void main()
{
    
    if (!PreInvocationCastCode())
    {
    // If code within the PreSpellCastHook (i.e. UMD) reports FALSE, do not run this spell
        return;
    }
    
    //Declare major variables
    object oTarget = GetSpellTargetObject();
    int CasterLvl = GetInvokerLevel(OBJECT_SELF, GetInvokingClass());
    effect eAOE = EffectAreaOfEffect(INVOKE_AOE_COLD_COMFORT);
    int nAmount = 20;
    int nResistance = 10;
    effect eCold = EffectDamageResistance(DAMAGE_TYPE_COLD, nResistance, nAmount);
    effect eFire = EffectDamageResistance(DAMAGE_TYPE_FIRE, nResistance, nAmount);
    effect eAcid = EffectDamageResistance(DAMAGE_TYPE_ACID, nResistance, nAmount);
    effect eSonic = EffectDamageResistance(DAMAGE_TYPE_SONIC, nResistance, nAmount);
    effect eElec = EffectDamageResistance(DAMAGE_TYPE_ELECTRICAL, nResistance, nAmount);
    effect eDur = EffectVisualEffect(VFX_DUR_PROTECTION_ELEMENTS);
    effect eVis = EffectVisualEffect(VFX_IMP_ELEMENTAL_PROTECTION);
    effect eDur2 = EffectVisualEffect(VFX_DUR_CESSATE_POSITIVE);

    //Fire cast spell at event for the specified target
    SignalEvent(oTarget, EventSpellCastAt(OBJECT_SELF, INVOKE_COLD_COMFORT, FALSE));

    //Link Effects
    effect eLink = EffectLinkEffects(eCold, eFire);
    eLink = EffectLinkEffects(eLink, eAcid);
    eLink = EffectLinkEffects(eLink, eSonic);
    eLink = EffectLinkEffects(eLink, eElec);
    eLink = EffectLinkEffects(eLink, eDur);
    eLink = EffectLinkEffects(eLink, eDur2);
    eLink = EffectLinkEffects(eLink, eAOE);

    //Apply VFX impact and effects
    SPApplyEffectToObject(DURATION_TYPE_TEMPORARY, eLink, oTarget, HoursToSeconds(24),TRUE,-1,CasterLvl);
    SPApplyEffectToObject(DURATION_TYPE_INSTANT, eVis, oTarget);
}
