//::///////////////////////////////////////////////
//:: Time Stop
//:: NW_S0_TimeStop.nss
//:: Copyright (c) 2001 Bioware Corp.
//:://////////////////////////////////////////////
/*
//:://////////////////////////////////////////////
//:: FileName: "ss_ep_grtimestop"
/*   Purpose: Greater Timestop - in all ways this spell is the same as
        Timestop except for the duration, which is doubled.
*/
//:://////////////////////////////////////////////
//:: Created By: Boneshank
//:: Last Updated On: March 11, 2004
//:://////////////////////////////////////////////
#include "x2_inc_spellhook"
#include "inc_epicspells"

void main()
{
    if (!X2PreSpellCastCode())
    {
        return;
    }
    if (GetCanCastSpell(OBJECT_SELF, GR_TIME_DC, GR_TIME_S, GR_TIME_XP))
    {
        location lTarget = GetSpellTargetLocation();
        effect eVis = EffectVisualEffect(VFX_FNF_TIME_STOP);
        effect eTime = EffectTimeStop();
        SignalEvent(OBJECT_SELF, EventSpellCastAt(OBJECT_SELF, SPELL_TIME_STOP, FALSE));
        DelayCommand(0.75, ApplyEffectToObject(DURATION_TYPE_TEMPORARY, eTime, OBJECT_SELF, 18.0));
        ApplyEffectAtLocation(DURATION_TYPE_INSTANT, eVis, lTarget);
    }
}

