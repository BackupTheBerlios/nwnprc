//:://////////////////////////////////////////////
//:: FileName: "ss_ep_deadeye"
/*   Purpose: Deadeye Sense - Increases the target's AB by +20 for 20 hours.
*/
//:://////////////////////////////////////////////
//:: Created By: Boneshank
//:: Last Updated On: March 11, 2004
//:://////////////////////////////////////////////
#include "NW_I0_SPELLS"
#include "x2_inc_spellhook"
#include "inc_epicspells"

void main()
{
    if (!X2PreSpellCastCode())
    {
        return;
    }
    if (GetCanCastSpell(OBJECT_SELF, DEADEYE_DC, DEADEYE_S, DEADEYE_XP))
    {
        object oTarget = GetSpellTargetObject();
        int nDuration = 20;

        effect eVis = EffectVisualEffect(VFX_IMP_HEAD_HOLY);
        effect eDur = EffectVisualEffect(VFX_DUR_CESSATE_POSITIVE);
        effect eImpact = EffectVisualEffect(VFX_FNF_LOS_HOLY_30);
        effect eAttack = EffectAttackIncrease(20);
        effect eLink = EffectLinkEffects(eAttack, eDur);
        float fDelay;
        ApplyEffectAtLocation(DURATION_TYPE_INSTANT, eImpact, GetSpellTargetLocation());
        if(GetIsReactionTypeFriendly(oTarget) || GetFactionEqual(oTarget))
        {
            fDelay = GetRandomDelay(0.4, 1.1);
            //Fire spell cast at event for target
            SignalEvent(oTarget, EventSpellCastAt(OBJECT_SELF, SPELL_BLESS, FALSE));
            DelayCommand(fDelay, ApplyEffectToObject(DURATION_TYPE_INSTANT, eVis, oTarget));
            DelayCommand(fDelay, ApplyEffectToObject(DURATION_TYPE_TEMPORARY, eLink, oTarget, HoursToSeconds(nDuration)));
        }
    }
}

