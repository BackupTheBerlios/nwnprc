/*
          Warlock Fiendish Resilience
          Fast Healing x for 2 minutes(5 minutes if epic)
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
    int nDuration = 2;
    effect eVis = EffectVisualEffect(VFX_IMP_HEAD_NATURE);
    effect eDur = EffectVisualEffect(VFX_DUR_CESSATE_POSITIVE);
    
    int nHealAmt = 1;
    if(GetLevelByClass(CLASS_TYPE_WARLOCK, oPC) > 17) nHealAmt = 5;
    else if(GetLevelByClass(CLASS_TYPE_WARLOCK, oPC) > 12) nHealAmt = 2;
    
    //check for the epic feats
    if(GetHasFeat(FEAT_EPIC_FIENDISH_RESILIENCE_I))
    { 
        nHealAmt = 25;
        nDuration = 5;
        int nFeatAmt = 0;
        int bDone = FALSE;
        while(!bDone)
        {   if(nFeatAmt >= 9) 
                bDone = TRUE;
            else if(GetHasFeat(FEAT_EPIC_FIENDISH_RESILIENCE_II + nFeatAmt))
                nFeatAmt++;
            else
                bDone = TRUE;
        }
        nHealAmt += 5 * nFeatAmt;
    }
    
    
    effect eFastHeal = EffectRegenerate(nHealAmt, RoundsToSeconds(1));
    effect eLink = EffectLinkEffects(eFastHeal, eDur);
    
    //Fire cast spell at event for the specified target
    SignalEvent(oTarget, EventSpellCastAt(OBJECT_SELF, INVOKE_FIENDISH_RESILIENCE, FALSE));
    
    //Apply the VFX impact and effect
    ApplyEffectToObject(DURATION_TYPE_TEMPORARY, eLink, oTarget, TurnsToSeconds(nDuration));
    ApplyEffectToObject(DURATION_TYPE_INSTANT, eVis, oTarget);

}
