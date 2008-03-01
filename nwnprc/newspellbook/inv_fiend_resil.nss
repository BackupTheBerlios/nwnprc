/*
          Warlock Fiendish Resilience
          Fast Healing x for 2 minutes
*/

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
    object oPC = OBJECT_SELF;
    object oTarget = GetSpellTargetObject();
    effect eVis = EffectVisualEffect(VFX_IMP_HEAD_NATURE);
    effect eDur = EffectVisualEffect(VFX_DUR_CESSATE_POSITIVE);
    
    int nHealAmt = 1;
    if(GetLevelByClass(CLASS_TYPE_WARLOCK, oPC) > 37) nHealAmt = 15;
    else if(GetLevelByClass(CLASS_TYPE_WARLOCK, oPC) > 32) nHealAmt = 12;
    else if(GetLevelByClass(CLASS_TYPE_WARLOCK, oPC) > 27) nHealAmt = 10;
    else if(GetLevelByClass(CLASS_TYPE_WARLOCK, oPC) > 22) nHealAmt = 7;
    else if(GetLevelByClass(CLASS_TYPE_WARLOCK, oPC) > 17) nHealAmt = 5;
    else if(GetLevelByClass(CLASS_TYPE_WARLOCK, oPC) > 12) nHealAmt = 2;
    
    effect eFastHeal = EffectRegenerate(nHealAmt, RoundsToSeconds(1));
    effect eLink = EffectLinkEffects(eFastHeal, eDur);
    
    //Fire cast spell at event for the specified target
    SignalEvent(oTarget, EventSpellCastAt(OBJECT_SELF, INVOKE_FIENDISH_RESILIENCE, FALSE));
    
    //Apply the VFX impact and effect
    ApplyEffectToObject(DURATION_TYPE_TEMPORARY, eLink, oTarget, TurnsToSeconds(2));
    ApplyEffectToObject(DURATION_TYPE_INSTANT, eVis, oTarget);

}
