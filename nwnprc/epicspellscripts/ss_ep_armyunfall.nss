//:://////////////////////////////////////////////
//:: FileName: "ss_ep_armyunfall"
/*   Purpose: Army Unfallen epic spell - heals/resurrects all allies.
*/
//:://////////////////////////////////////////////
//:: Created By: Boneshank
//:: Last Updated On:
//:://////////////////////////////////////////////
#include "inc_epicspells"
#include "x2_inc_spellhook"
#include "x2_i0_spells"

void main()
{
    if (!X2PreSpellCastCode())
    {
        return;
    }
    if (GetCanCastSpell(OBJECT_SELF, ARMY_UN_DC, ARMY_UN_S, ARMY_UN_XP))
    {
        effect eRez, eHeal, eBLD, eLink;
        effect eVis = EffectVisualEffect(VFX_FNF_LOS_HOLY_10);
        effect eVis2 = EffectVisualEffect(VFX_FNF_PWSTUN);
        effect eVis3 = EffectVisualEffect(VFX_IMP_HEALING_G);
        int nX, nAlly, nBLD;
        object oTarget = GetFirstFactionMember(OBJECT_SELF, FALSE);
        while (GetIsObjectValid(oTarget))
        {
            nX = GetMaxHitPoints(oTarget) - GetCurrentHitPoints(oTarget);
            eRez = EffectResurrection();
            eHeal = EffectHeal(nX);
            eLink = EffectLinkEffects(eHeal, eVis);
            eLink = EffectLinkEffects(eLink, eVis2);
            eLink = EffectLinkEffects(eLink, eVis3);
            oTarget = GetNextFactionMember(OBJECT_SELF, FALSE);
            if (!MatchNonliving(GetRacialType(oTarget)) &&
                oTarget != OBJECT_SELF)
            {
                if (nX > 0)
                {
                    if (GetIsDead(oTarget))
                        ApplyEffectToObject(DURATION_TYPE_INSTANT, eRez, oTarget);
                    ApplyEffectToObject(DURATION_TYPE_INSTANT, eLink, oTarget);
                    nAlly++;
                }
            }
        }
        if (BACKLASH_DAMAGE == TRUE)
        {
            nBLD = d6(nAlly);
            eBLD = EffectDamage(nBLD);
            ApplyEffectToObject(DURATION_TYPE_INSTANT, eBLD, oTarget);
        }
    }
}
