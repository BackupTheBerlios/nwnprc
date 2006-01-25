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
#include "prc_alterations"
#include "inc_epicspells"
#include "x2_inc_spellhook"
#include "inc_dispel"
//#include "prc_alterations"

// Brings oPC back to life, via the contingency of 'Contingent Resurrection'.
void ContingencyResurrect(object oTarget, int nCount, object oCaster);

void main()
{
    object oCaster = OBJECT_SELF;

    DeleteLocalInt(oCaster, "X2_L_LAST_SPELLSCHOOL_VAR");
    SetLocalInt(oCaster, "X2_L_LAST_SPELLSCHOOL_VAR", SPELL_SCHOOL_CONJURATION);

    if (!X2PreSpellCastCode())
    {
        DeleteLocalInt(oCaster, "X2_L_LAST_SPELLSCHOOL_VAR");
        return;
    }

    if (GetCanCastSpell(oCaster, SPELL_EPIC_CON_RES))
    {
        object oTarget   = PRCGetSpellTargetObject();
        location lTarget = GetLocation(oTarget);
        effect eVis      = EffectVisualEffect(VFX_FNF_LOS_HOLY_20);
        effect eVisFail  = EffectVisualEffect(VFX_IMP_NEGATIVE_ENERGY);
        // If the target is of a race that could be resurrected, go ahead.
        if (MyPRCGetRacialType(oTarget) != RACIAL_TYPE_CONSTRUCT &&
            MyPRCGetRacialType(oTarget) != RACIAL_TYPE_OUTSIDER &&
            MyPRCGetRacialType(oTarget) != RACIAL_TYPE_UNDEAD &&
            MyPRCGetRacialType(oTarget) != RACIAL_TYPE_ELEMENTAL)
        {
            ApplyEffectAtLocation(DURATION_TYPE_INSTANT, eVis, lTarget);
            PenalizeSpellSlotForCaster(oCaster);
            // Start the contingency.
            SetLocalInt(oCaster, "nContingentRez", GetLocalInt(oCaster, "nContingentRez") + 1);
            ContingencyResurrect(oTarget, 1, oCaster);
        }
        else
        {
            ApplyEffectAtLocation(DURATION_TYPE_INSTANT, eVisFail, lTarget);
            SendMessageToPC(oCaster, "Spell failed - Invalid target!");
        }
    }
    DeleteLocalInt(oCaster, "X2_L_LAST_SPELLSCHOOL_VAR");
}

void ContingencyResurrect(object oTarget, int nCount, object oCaster)
{
    // If the contingency has been turned off, terminate HB
    if(!GetLocalInt(oCaster, "nContingentRez"))
        return;

    // If the target isn't dead, just toss out a notice that the heartbeat is running and schedule next beat
    if(!GetIsDead(oTarget))
    {
        if((nCount++ % 10) == 0)
            FloatingTextStringOnCreature("*Contingency active*", oTarget, FALSE);
        DelayCommand(6.0, ContingencyResurrect(oTarget, nCount, oCaster));
    }
    else // Resurrect the target, and end the contingency.
    {
        effect eRez = EffectResurrection();
        effect eHea = EffectHeal(GetMaxHitPoints(oTarget) + 10);
        effect eVis = EffectVisualEffect(VFX_IMP_RAISE_DEAD);

        // Resurrect the target
        FloatingTextStringOnCreature("*Contingency triggered*", oTarget);
        ApplyEffectAtLocation(DURATION_TYPE_INSTANT, eVis, GetLocation(oTarget));
        SPApplyEffectToObject(DURATION_TYPE_INSTANT, eRez, oTarget);
        SPApplyEffectToObject(DURATION_TYPE_INSTANT, eHea, oTarget);

        // Bookkeeping of epic spell slots in contingent use
        RestoreSpellSlotForCaster(oCaster);
        SetLocalInt(oCaster, "nContingentRez", GetLocalInt(oCaster, "nContingentRez") - 1);

        //ContingencyResurrect(oTarget, nCount); // Methinks this particular HB should end now - Ornedan

        // PW death stuff
        ExecuteScript("prc_pw_contress", oTarget);
        if(GetPRCSwitch(PRC_PW_DEATH_TRACKING) && GetIsPC(oTarget))
            SetPersistantLocalInt(oTarget, "persist_dead", FALSE);
    }
}

