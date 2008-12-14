
#include "prc_inc_spells"
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
    int CasterLvl = GetInvokerLevel(OBJECT_SELF, GetInvokingClass());
    object oTarget = PRCGetSpellTargetObject();
    effect eVis = EffectVisualEffect(VFX_IMP_MAGBLUE );
    effect eDur = EffectVisualEffect(VFX_DUR_CESSATE_POSITIVE);
    int nSaveType;
    int nBonus = GetAbilityModifier(ABILITY_CHARISMA);

    if(GetSpellId() == INVOKE_DARK_ONES_OWN_LUCK_FORT) nSaveType = SAVING_THROW_FORT;
    else if(GetSpellId() == INVOKE_DARK_ONES_OWN_LUCK_REFLEX) nSaveType = SAVING_THROW_REFLEX;
    else if(GetSpellId() == INVOKE_DARK_ONES_OWN_LUCK_WILL) nSaveType = SAVING_THROW_WILL;

    effect eSave = EffectSavingThrowIncrease(nSaveType, nBonus);
    effect eLink = EffectLinkEffects(eSave, eDur);

    //Fire cast spell at event for the specified target
    SignalEvent(oTarget, EventSpellCastAt(OBJECT_SELF, GetSpellId(), FALSE));
    if(GetHasSpellEffect(INVOKE_DARK_ONES_OWN_LUCK_FORT, oTarget) ||
       GetHasSpellEffect(INVOKE_DARK_ONES_OWN_LUCK_REFLEX, oTarget) ||
       GetHasSpellEffect(INVOKE_DARK_ONES_OWN_LUCK_WILL, oTarget))
    {
        PRCRemoveSpellEffects(INVOKE_DARK_ONES_OWN_LUCK_FORT, OBJECT_SELF, oTarget);
        PRCRemoveSpellEffects(INVOKE_DARK_ONES_OWN_LUCK_REFLEX, OBJECT_SELF, oTarget);
        PRCRemoveSpellEffects(INVOKE_DARK_ONES_OWN_LUCK_WILL, OBJECT_SELF, oTarget);
    }
    //Apply the VFX impact and effect
    SPApplyEffectToObject(DURATION_TYPE_TEMPORARY, eLink, oTarget, HoursToSeconds(24),TRUE,-1,CasterLvl);
    SPApplyEffectToObject(DURATION_TYPE_INSTANT, eVis, oTarget);

}
