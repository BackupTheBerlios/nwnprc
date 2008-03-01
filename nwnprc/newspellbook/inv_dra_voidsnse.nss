//::///////////////////////////////////////////////
//:: See Invisibility
//:: NW_S0_SeeInvis.nss
//:: Copyright (c) 2001 Bioware Corp.
//:://////////////////////////////////////////////
/*
    Allows the mage to see creatures that are
    invisible
*/
//:://////////////////////////////////////////////
//:: Created By: Preston Watamaniuk
//:: Created On: Jan 7, 2002
//:://////////////////////////////////////////////

//:: modified by mr_bumpkin Dec 4, 2003 for PRC stuff
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
    object oSkin = GetPCSkin(oTarget);
    effect eVis = EffectVisualEffect(VFX_DUR_MAGICAL_SIGHT);
    effect eDur = EffectVisualEffect(VFX_DUR_CESSATE_POSITIVE);
    effect eSight = EffectSeeInvisible();
    effect eSight2 = EffectUltravision();
    //blindsense allows noticing of hidden characters without spot/listen checks
    effect eSight3 = EffectSkillIncrease(SKILL_LISTEN, 80);
    effect eSight4 = EffectSkillIncrease(SKILL_SPOT, 80);
    effect eLink = EffectLinkEffects(eVis, eSight);
    eLink = EffectLinkEffects(eLink, eSight2);
    eLink = EffectLinkEffects(eLink, eSight3);
    eLink = EffectLinkEffects(eLink, eSight4);
    eLink = EffectLinkEffects(eLink, eDur);
    
    //Fire cast spell at event for the specified target
    SignalEvent(oTarget, EventSpellCastAt(OBJECT_SELF, SPELL_TRUE_SEEING, FALSE));
    int CasterLvl = GetInvokerLevel(OBJECT_SELF, GetInvokingClass());
    
    //Apply the VFX impact and effect
    SPApplyEffectToObject(DURATION_TYPE_TEMPORARY, eLink, oTarget, HoursToSeconds(24),TRUE,-1,CasterLvl);
    IPSafeAddItemProperty(oSkin, ItemPropertyDarkvision(), HoursToSeconds(24), X2_IP_ADDPROP_POLICY_REPLACE_EXISTING, FALSE, FALSE);

}
