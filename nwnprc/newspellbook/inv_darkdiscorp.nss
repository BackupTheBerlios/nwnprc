//::///////////////////////////////////////////////
//:: Polymorph Self
//:: NW_S0_PolySelf.nss
//:: Copyright (c) 2001 Bioware Corp.
//:://////////////////////////////////////////////
/*
    The PC is able to changed their form to one of
    several forms.
*/
//:://////////////////////////////////////////////
//:: Created By: Preston Watamaniuk
//:: Created On: Jan 21, 2002
//:://////////////////////////////////////////////

//:: modified by mr_bumpkin Dec 4, 2003 for PRC stuff
#include "spinc_common"
#include "pnp_shft_poly"
#include "prc_inc_clsfunc"
#include "inv_inc_invfunc"
#include "inv_invokehook"

void main()
{
    if(GetLocalInt(OBJECT_SELF, "DarkDiscorporation"))
    {
        RemoveSpellEffects(INVOKE_DARK_DISCORPORATION, OBJECT_SELF, OBJECT_SELF);
        DeleteLocalInt(OBJECT_SELF, "DarkDiscorporation");
        object oNoAtk = GetItemPossessedBy(OBJECT_SELF, "prc_eldrtch_glv");
        DestroyObject(oNoAtk);
        RemoveEventScript(OBJECT_SELF, EVENT_ONPLAYERUNEQUIPITEM, "inv_discorpnoatk", TRUE, FALSE);
        RemoveEventScript(OBJECT_SELF, EVENT_ONUNAQUIREITEM, "inv_discorpnoatk", TRUE, FALSE);
        DeleteLocalInt(OBJECT_SELF, "IgnoreSwarmDmg");
        DeleteLocalInt(OBJECT_SELF, "SwarmDmgType");
        return;
    }
    
    if (!PreInvocationCastCode())
    {
    // If code within the PreSpellCastHook (i.e. UMD) reports FALSE, do not run this spell
        return;
    }

    //Declare major variables
    int nSpell = GetSpellId();
    object oTarget = GetSpellTargetObject();
    effect eVis = EffectVisualEffect(VFX_IMP_POLYMORPH);
    int CasterLvl = GetInvokerLevel(OBJECT_SELF, GetInvokingClass());
    int nChaMod = GetAbilityModifier(ABILITY_CHARISMA, OBJECT_SELF);

    effect eDex = EffectAbilityIncrease(ABILITY_DEXTERITY, 6);
    effect eCritImmune = EffectImmunity(IMMUNITY_TYPE_CRITICAL_HIT);
    effect eWeaponImm1 = EffectDamageImmunityIncrease(DAMAGE_TYPE_BLUDGEONING, 100);
    effect eWeaponImm2 = EffectDamageImmunityIncrease(DAMAGE_TYPE_PIERCING, 100);
    effect eWeaponImm3 = EffectDamageImmunityIncrease(DAMAGE_TYPE_SLASHING, 100);
    effect eAOE = EffectAreaOfEffect(INVOKE_VFX_DARK_DISCORPORATION);
    effect eArmor = EffectACIncrease(nChaMod, AC_DEFLECTION_BONUS);
    effect eLink = EffectLinkEffects(eCritImmune, eDex);
    eLink = EffectLinkEffects(eLink, eWeaponImm1);
    eLink = EffectLinkEffects(eLink, eWeaponImm2);
    eLink = EffectLinkEffects(eLink, eWeaponImm3);
    eLink = EffectLinkEffects(eLink, eAOE);
    eLink = EffectLinkEffects(eLink, eArmor);
    
    //Fire cast spell at event for the specified target
    SignalEvent(oTarget, EventSpellCastAt(OBJECT_SELF, INVOKE_DARK_DISCORPORATION, FALSE));

    //Apply the VFX impact and effects
    SPApplyEffectToObject(DURATION_TYPE_INSTANT, eVis, oTarget);
    SPApplyEffectToObject(DURATION_TYPE_TEMPORARY, eLink, oTarget, HoursToSeconds(24),TRUE,-1,CasterLvl);
    SetLocalInt(OBJECT_SELF, "DarkDiscorporation", TRUE);
    
    object oNoAtk = CreateItemOnObject("prc_eldrtch_glv", OBJECT_SELF);
    SetDroppableFlag(oNoAtk, FALSE);
    SetItemCursedFlag(oNoAtk, TRUE);
    AssignCommand(OBJECT_SELF, ActionEquipItem(oNoAtk, INVENTORY_SLOT_RIGHTHAND));
    SetLocalInt(OBJECT_SELF, "IgnoreSwarmDmg", TRUE);
    SetLocalInt(OBJECT_SELF, "SwarmDmgType", INVOKE_DARK_DISCORPORATION);
    ExecuteScript("inv_discorpnoatk", OBJECT_SELF);
    
}

