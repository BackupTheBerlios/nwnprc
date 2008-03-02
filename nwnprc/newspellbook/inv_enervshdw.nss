

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
    effect eAOE = EffectAreaOfEffect(INVOKE_AOE_ENERVATING_SHADOW);
    effect eDur2 = EffectVisualEffect(VFX_DUR_CESSATE_POSITIVE);
    effect eDur = EffectVisualEffect(VFX_DUR_INVISIBILITY);

    //Fire cast spell at event for the specified target
    SignalEvent(oTarget, EventSpellCastAt(OBJECT_SELF, INVOKE_ENERVATING_SHADOW, FALSE));

    //Link Effects
    effect eLink = EffectLinkEffects(eDur2, eAOE);
    eLink = EffectLinkEffects(eDur, eLink);

    //Apply VFX impact and effects
    SPApplyEffectToObject(DURATION_TYPE_TEMPORARY, eLink, oTarget, RoundsToSeconds(5),TRUE,-1,CasterLvl);
}
