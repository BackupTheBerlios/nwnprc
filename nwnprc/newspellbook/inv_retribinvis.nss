/*
    nw_s0_imprinvis

    Target creature can attack and cast spells while
    invisible

    By: Preston Watamaniuk
    Created: Jan 7, 2002
    Modified: Jun 12, 2006
*/

#include "prc_sp_func"
#include "inv_inc_invfunc"
#include "inv_invokehook"

void main()
{
    if (!PreInvocationCastCode())
    {
    // If code within the PreSpellCastHook (i.e. UMD) reports FALSE, do not run this spell
        return;
    }
    
    object oCaster = OBJECT_SELF;
    int nCasterLvl = GetInvokerLevel(OBJECT_SELF, GetInvokingClass());
    
    object oTarget = PRCGetSpellTargetObject();
    float fDur = RoundsToSeconds(nCasterLvl);
    
    effect eImpact = EffectVisualEffect(VFX_IMP_HEAD_MIND);
    effect eVis = EffectVisualEffect(VFX_DUR_INVISIBILITY);
    effect eInvis = EffectInvisibility(INVISIBILITY_TYPE_IMPROVED);
    effect eDur = EffectVisualEffect(VFX_DUR_CESSATE_POSITIVE);
    effect eCover = EffectConcealment(50);
    effect eLink = EffectLinkEffects(eDur, eCover);
    eLink = EffectLinkEffects(eLink, eVis);

    //Fire cast spell at event for the specified target
    SignalEvent(oTarget, EventSpellCastAt(OBJECT_SELF, INVOKE_RETRIBUTIVE_INVISIBILITY, FALSE));
    
    //Apply the VFX impact and effects
    SPApplyEffectToObject(DURATION_TYPE_INSTANT, eImpact, oTarget);

    SPApplyEffectToObject(DURATION_TYPE_TEMPORARY, eLink, oTarget, fDur,TRUE,-1,nCasterLvl);
    SPApplyEffectToObject(DURATION_TYPE_TEMPORARY, eInvis, oTarget, fDur,TRUE,-1,nCasterLvl);
    SetLocalInt(oTarget, "DangerousInvis", nCasterLvl);

}