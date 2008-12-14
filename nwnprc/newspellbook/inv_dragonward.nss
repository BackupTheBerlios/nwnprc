
#include "prc_inc_spells"
#include "inv_inc_invfunc"
#include "inv_invokehook"

void RemoveDragonWard(object oTarget, int CurrentDragonWard)
{
    if(GetPersistantLocalInt(oTarget, "nTimesDragonWarded") != CurrentDragonWard)
        return;

    DeleteLocalInt(oTarget, "DragonWard");
}

void main()
{
    if (!PreInvocationCastCode())
    {
    // If code within the PreSpellCastHook (i.e. UMD) reports FALSE, do not run this spell
        return;
    }

    //Declare major variables
    object oCaster = OBJECT_SELF;
    effect eImm1 = EffectImmunity(IMMUNITY_TYPE_FEAR);
    effect eVis = EffectVisualEffect(VFX_DUR_MIND_AFFECTING_POSITIVE);
    effect eDur = EffectVisualEffect(VFX_DUR_CESSATE_POSITIVE);

    effect eLink = EffectLinkEffects(eImm1, eVis);
    eLink = EffectLinkEffects(eLink, eDur);

    object oTarget = PRCGetSpellTargetObject();
    int nTimesDragonWarded = GetPersistantLocalInt(oTarget, "nTimesDragonWarded");
    int CasterLvl = GetInvokerLevel(oCaster, GetInvokingClass());

    nTimesDragonWarded++;
    if(nTimesDragonWarded > 9) nTimesDragonWarded = 0;
    SetPersistantLocalInt(oTarget, "nTimesDragonWarded", nTimesDragonWarded);
    SetLocalInt(oTarget, "DragonWard", TRUE);
    SPApplyEffectToObject(DURATION_TYPE_TEMPORARY, eLink, oTarget, HoursToSeconds(24),TRUE,-1,CasterLvl);
    DelayCommand(HoursToSeconds(24), RemoveDragonWard(oTarget, nTimesDragonWarded));

}

