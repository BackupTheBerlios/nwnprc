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

#include "nw_i0_spells"
#include "inc_epicspells"
#include "inc_dispel"
//#include "prc_alterations"
#include "x2_inc_spellhook"

void main()
{
	DeleteLocalInt(OBJECT_SELF, "X2_L_LAST_SPELLSCHOOL_VAR");
	SetLocalInt(OBJECT_SELF, "X2_L_LAST_SPELLSCHOOL_VAR", SPELL_SCHOOL_TRANSMUTATION);
	int nDuration = d4(2);

    if (!X2PreSpellCastCode())
    {
		DeleteLocalInt(OBJECT_SELF, "X2_L_LAST_SPELLSCHOOL_VAR");
        return;
    }
    if (GetCanCastSpell(OBJECT_SELF, GR_TIME_DC, GR_TIME_S, GR_TIME_XP))
    {
        location lTarget = GetSpellTargetLocation();
        effect eVis = EffectVisualEffect(VFX_FNF_TIME_STOP);
        effect eTime = EffectTimeStop();
        SignalEvent(OBJECT_SELF, EventSpellCastAt(OBJECT_SELF, SPELL_TIME_STOP, FALSE));
        DelayCommand(0.75, SPApplyEffectToObject(DURATION_TYPE_TEMPORARY, eTime, OBJECT_SELF, RoundsToSeconds(nDuration), TRUE, -1, GetTotalCastingLevel(OBJECT_SELF)));
        ApplyEffectAtLocation(DURATION_TYPE_INSTANT, eVis, lTarget);
    }
	DeleteLocalInt(OBJECT_SELF, "X2_L_LAST_SPELLSCHOOL_VAR");
}

