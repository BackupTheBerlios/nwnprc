//:://////////////////////////////////////////////
//:: FileName: "ss_ep_unholydisc"
/*   Purpose: Unholy Disciple
*/
//:://////////////////////////////////////////////
//:: Created By: Boneshank
//:: Last Updated On:
//:://////////////////////////////////////////////
#include "x2_inc_spellhook"
#include "inc_epicspells"
void main()
{
    if (!X2PreSpellCastCode())
    {
        return;
    }
    if (GetCanCastSpell(OBJECT_SELF, UNHOLYD_DC, UNHOLYD_S, UNHOLYD_XP))
    {
        effect eSummon;
        eSummon = EffectSummonCreature("unholy_disciple",496,1.0f);
        eSummon = ExtraordinaryEffect(eSummon);
        if (GetAlignmentGoodEvil(OBJECT_SELF) != ALIGNMENT_GOOD)
        //Apply the summon visual and summon the disciple.
        ApplyEffectAtLocation(DURATION_TYPE_INSTANT, eSummon, GetSpellTargetLocation());
        else
            SendMessageToPC(OBJECT_SELF, "You must be non-good to summon an unholy disciple.");
    }
}


