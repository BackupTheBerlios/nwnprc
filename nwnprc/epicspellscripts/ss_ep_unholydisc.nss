//:://////////////////////////////////////////////
//:: FileName: "ss_ep_unholydisc"
/*   Purpose: Unholy Disciple
*/
//:://////////////////////////////////////////////
//:: Created By: Boneshank
//:: Last Updated On:
//:://////////////////////////////////////////////

#include "prc_alterations"
#include "inc_epicspells"
#include "x2_inc_spellhook"
#include "inc_utility"

void main()
{
	DeleteLocalInt(OBJECT_SELF, "X2_L_LAST_SPELLSCHOOL_VAR");
	SetLocalInt(OBJECT_SELF, "X2_L_LAST_SPELLSCHOOL_VAR", SPELL_SCHOOL_NECROMANCY);

    if (!X2PreSpellCastCode())
    {
		DeleteLocalInt(OBJECT_SELF, "X2_L_LAST_SPELLSCHOOL_VAR");
        return;
    }
    if (GetCanCastSpell(OBJECT_SELF, UNHOLYD_DC, UNHOLYD_S, UNHOLYD_XP))
    {
        effect eSummon;
        eSummon = EffectSummonCreature("unholy_disciple",496,1.0f);
        eSummon = ExtraordinaryEffect(eSummon);
        if (GetAlignmentGoodEvil(OBJECT_SELF) != ALIGNMENT_GOOD)
        {
            //Apply the summon visual and summon the disciple.
            MultisummonPreSummon();
            ApplyEffectAtLocation(DURATION_TYPE_INSTANT, eSummon, PRCGetSpellTargetLocation());
        }
        else
            SendMessageToPC(OBJECT_SELF, "You must be non-good to summon an unholy disciple.");
    }
	DeleteLocalInt(OBJECT_SELF, "X2_L_LAST_SPELLSCHOOL_VAR");
}


