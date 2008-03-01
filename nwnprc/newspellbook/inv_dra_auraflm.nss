//::///////////////////////////////////////////////
//:: Elemental Shield
//:: NW_S0_FireShld.nss
//:: Copyright (c) 2001 Bioware Corp.
//:://////////////////////////////////////////////
/*
    Caster gains 50% cold and fire immunity.  Also anyone
    who strikes the caster with melee attacks takes
    1d6 + 1 per caster level in damage.
*/
//:://////////////////////////////////////////////
//:: Created By: Preston Watamaniuk
//:: Created On: Jan 7, 2002
//:://////////////////////////////////////////////
//:: Created On: Aug 28, 2003, GZ: Fixed stacking issue

//:: modified by mr_bumpkin Dec 4, 2003 for PRC stuff
#include "spinc_common"
#include "inv_inc_invfunc"
#include "x0_i0_spells"
#include "inv_invokehook"

void main()
{
    if (!PreInvocationCastCode())
    {
    // If code within the PreSpellCastHook (i.e. UMD) reports FALSE, do not run this spell
        return;
    }
// End of Spell Cast Hook


    //Declare major variables
    effect eVis = EffectVisualEffect(VFX_DUR_ELEMENTAL_SHIELD);
    int CasterLvl = GetInvokerLevel(OBJECT_SELF, GetInvokingClass());
    object oTarget = OBJECT_SELF;
    object oSkin = GetPCSkin(oTarget);
    effect eShield = EffectDamageShield(CasterLvl - 1, DAMAGE_BONUS_1, DAMAGE_TYPE_FIRE);
    effect eDur = EffectVisualEffect(VFX_DUR_CESSATE_POSITIVE);

    //Link effects
    effect eLink = EffectLinkEffects(eShield, eDur);
    eLink = EffectLinkEffects(eLink, eVis);

    //Fire cast spell at event for the specified target
    SignalEvent(oTarget, EventSpellCastAt(OBJECT_SELF, SPELL_ELEMENTAL_SHIELD, FALSE));

    //  *GZ: No longer stack this spell
    if (GetHasSpellEffect(GetSpellId(),oTarget))
    {
         RemoveSpellEffects(GetSpellId(), OBJECT_SELF, oTarget);
    }

    //Apply the VFX impact and effects
    SPApplyEffectToObject(DURATION_TYPE_TEMPORARY, eLink, oTarget, HoursToSeconds(24),TRUE,-1,CasterLvl);
    IPSafeAddItemProperty(oSkin, ItemPropertyLight(IP_CONST_LIGHTBRIGHTNESS_BRIGHT, IP_CONST_LIGHTCOLOR_ORANGE), HoursToSeconds(24), X2_IP_ADDPROP_POLICY_REPLACE_EXISTING, FALSE, FALSE);

}

