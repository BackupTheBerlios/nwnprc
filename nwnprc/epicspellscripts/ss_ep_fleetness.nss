//:://////////////////////////////////////////////
//:: FileName: "ss_ep_fleetness"
/*   Purpose: Fleetness of Foot - grants the target double the movement rate
        for 20 hours. Yowza!
*/
//:://////////////////////////////////////////////
//:: Created By: Boneshank
//:: Last Updated On: March 11, 2004
//:://////////////////////////////////////////////
#include "NW_I0_SPELLS"
#include "x2_inc_spellhook"
#include "inc_epicspells"
#include "prc_alterations"

void main()
{
	DeleteLocalInt(OBJECT_SELF, "X2_L_LAST_SPELLSCHOOL_VAR");
	SetLocalInt(OBJECT_SELF, "X2_L_LAST_SPELLSCHOOL_VAR", SPELL_SCHOOL_TRANSMUTATION);

    if (!X2PreSpellCastCode())
    {
		DeleteLocalInt(OBJECT_SELF, "X2_L_LAST_SPELLSCHOOL_VAR");
        return;
    }
    if (GetCanCastSpell(OBJECT_SELF, FLEETNS_DC, FLEETNS_S, FLEETNS_XP))
    {
        object oTarget = GetSpellTargetObject();
        int nDuration = 20;

        effect eDur = EffectVisualEffect(VFX_DUR_CESSATE_POSITIVE);
        effect eVis = EffectVisualEffect(VFX_IMP_HASTE);
        effect eImpact = EffectVisualEffect(VFX_IMP_GOOD_HELP);
        effect eSpeed = EffectMovementSpeedIncrease(99);
        effect eLink = EffectLinkEffects(eSpeed, eDur);
        float fDelay;
        if(GetIsReactionTypeFriendly(oTarget) || GetFactionEqual(oTarget))
        {
            fDelay = GetRandomDelay(0.4, 1.1);
            //Fire spell cast at event for target
            SignalEvent(oTarget, EventSpellCastAt
                (OBJECT_SELF, SPELL_EXPEDITIOUS_RETREAT, FALSE));
            DelayCommand(fDelay, SPApplyEffectToObject
                (DURATION_TYPE_INSTANT, eImpact, oTarget));
            DelayCommand(fDelay, SPApplyEffectToObject
                (DURATION_TYPE_INSTANT, eVis, oTarget));
            DelayCommand(fDelay, SPApplyEffectToObject
                (DURATION_TYPE_TEMPORARY, eLink, oTarget,
                HoursToSeconds(nDuration)));
        }
    }
	DeleteLocalInt(OBJECT_SELF, "X2_L_LAST_SPELLSCHOOL_VAR");
}

