//:://////////////////////////////////////////////
//:: FileName: "ss_ep_cont_resur"
/*   Purpose: Contingent Resurrection - sets a variable on the target, so that
        in the case of their death, they will automatically resurrect.
        NOTE: This contingency will last indefinitely, unless it triggers or the
        player dispels it in the pre-rest conversation.
*/
//:://////////////////////////////////////////////
//:: Created By: Boneshank
//:: Last Updated On: March 13, 2004
//:://////////////////////////////////////////////
#include "nw_i0_spells"
#include "inc_epicspells"
#include "x2_inc_spellhook"
#include "inc_dispel"
//#include "prc_alterations"

// Brings oPC back to life, via the contingency of 'Contingent Resurrection'.
void ContingencyResurrect(object oTarget, int nCount, object oCaster = OBJECT_SELF);

void main()
{
    DeleteLocalInt(OBJECT_SELF, "X2_L_LAST_SPELLSCHOOL_VAR");
    SetLocalInt(OBJECT_SELF, "X2_L_LAST_SPELLSCHOOL_VAR", SPELL_SCHOOL_CONJURATION);

    if (!X2PreSpellCastCode())
    {
        DeleteLocalInt(OBJECT_SELF, "X2_L_LAST_SPELLSCHOOL_VAR");
        return;
    }
    object oTarget = GetSpellTargetObject();
    if (GetCanCastSpell(OBJECT_SELF, CON_RES_DC, CON_RES_S, CON_RES_XP))
    {
        object oTarget = GetSpellTargetObject();
        effect eVis = EffectVisualEffect(VFX_FNF_LOS_HOLY_20);
        effect eVisFail = EffectVisualEffect(VFX_IMP_NEGATIVE_ENERGY);
        // If the target is of a race that could be resurrected, go ahead.
        if (MyPRCGetRacialType(oTarget) != RACIAL_TYPE_CONSTRUCT &&
            MyPRCGetRacialType(oTarget) != RACIAL_TYPE_OUTSIDER &&
            MyPRCGetRacialType(oTarget) != RACIAL_TYPE_UNDEAD &&
            MyPRCGetRacialType(oTarget) != RACIAL_TYPE_ELEMENTAL)
        {
            ApplyEffectAtLocation(DURATION_TYPE_INSTANT, eVis,
                GetLocation(oTarget));
            PenalizeSpellSlotForCaster(OBJECT_SELF);
            // Start the contingency.
            SetLocalInt(OBJECT_SELF, "nContingentRez",
                GetLocalInt(OBJECT_SELF, "nContingentRez") + 1);
            ContingencyResurrect(oTarget, 1);
        }
        else
        {
            ApplyEffectAtLocation(DURATION_TYPE_INSTANT, eVisFail,
                GetLocation(oTarget));
            SendMessageToPC(OBJECT_SELF, "Spell failed - Invalid target!");
        }
    }
    DeleteLocalInt(OBJECT_SELF, "X2_L_LAST_SPELLSCHOOL_VAR");
}

void ContingencyResurrect(object oTarget, int nCount, object oCaster = OBJECT_SELF)
{
    effect eRez = EffectResurrection();
    effect eHea = EffectHeal(GetMaxHitPoints(oTarget) + 10);
    effect eVis = EffectVisualEffect(VFX_IMP_RAISE_DEAD);
    if (GetLocalInt(oCaster, "nContingentRez") > 0)
    {   // If the target isn't dead.
        if (!GetIsDead(oTarget))
        {
            if (nCount >= 10) nCount = 0;
            if (nCount == 1)
                FloatingTextStringOnCreature("*Contingency active*",
                    oTarget, FALSE);
            nCount++;
            DelayCommand(6.0, ContingencyResurrect(oTarget, nCount));
        }
        else // Resurrect the target, and end the contingency.
        {
            FloatingTextStringOnCreature("*Contingency triggered*", oTarget);
            ApplyEffectAtLocation
                (DURATION_TYPE_INSTANT, eVis, GetLocation(oTarget));
            SPApplyEffectToObject(DURATION_TYPE_INSTANT, eRez, oTarget);
            SPApplyEffectToObject(DURATION_TYPE_INSTANT, eHea, oTarget);
            SetLocalInt(oCaster, "nContingentRez",
                GetLocalInt(oCaster, "nContingentRez") - 1);
            ContingencyResurrect(oTarget, nCount);
            ExecuteScript("prc_pw_contress", oTarget);
            if(GetPRCSwitch(PRC_PW_DEATH_TRACKING) && GetIsPC(oTarget))
                SetPersistantLocalInt(oTarget, "persist_dead", FALSE);
        }
    }
    else // Make the spell slot available to the original caster again.
        RestoreSpellSlotForCaster(oCaster);
}

