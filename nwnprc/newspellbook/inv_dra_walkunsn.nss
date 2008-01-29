/*
    nw_s0_invisib

    Target creature becomes invisible

    By: Preston Watamaniuk
    Created: Jan 7, 2002
    Modified: Jun 12, 2006
*/

#include "prc_sp_func"
#include "inv_inc_invfunc"
#include "inv_invokehook"

void main()
{
    object oCaster = OBJECT_SELF;
    int nCasterLevel = GetInvocationLevel(oCaster);
    object oTarget = PRCGetSpellTargetObject();
    
    effect eInvis = EffectInvisibility(INVISIBILITY_TYPE_NORMAL);
    effect eDur = EffectVisualEffect(VFX_DUR_CESSATE_POSITIVE);
    effect eLink = EffectLinkEffects(eInvis, eDur);

    //Fire cast spell at event for the specified target
    SignalEvent(oTarget, EventSpellCastAt(oCaster, SPELL_INVISIBILITY, FALSE));
    //Apply the VFX impact and effects
    SPApplyEffectToObject(DURATION_TYPE_TEMPORARY, eLink, oTarget, HoursToSeconds(24),TRUE,-1,nCasterLevel);
}