//:://////////////////////////////////////////////
//:: FileName: "ss_ep_epicrepuls"
/*   Purpose: Epic Repulsion - repel a specific creature type for 24 hours.
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
	DeleteLocalInt(OBJECT_SELF, "X2_L_LAST_SPELLSCHOOL_VAR");
	SetLocalInt(OBJECT_SELF, "X2_L_LAST_SPELLSCHOOL_VAR", SPELL_SCHOOL_ABJURATION);

    if (!X2PreSpellCastCode())
    {
		DeleteLocalInt(OBJECT_SELF, "X2_L_LAST_SPELLSCHOOL_VAR");
        return;
    }
    if (GetCanCastSpell(OBJECT_SELF, EP_RPLS_DC, EP_RPLS_S, EP_RPLS_XP))
    {
        object oTarget = GetSpellTargetObject();
        location lTarget = GetLocation(oTarget);
        effect eVis = EffectVisualEffect(VFX_FNF_PWSTUN);
        ApplyEffectAtLocation(DURATION_TYPE_INSTANT, eVis, lTarget);
        SetLocalObject(OBJECT_SELF, "oRepulsionTarget", oTarget);
        AssignCommand(OBJECT_SELF, ActionStartConversation(OBJECT_SELF,
            "ss_ep_repulsion", TRUE, FALSE));
    }
	DeleteLocalInt(OBJECT_SELF, "X2_L_LAST_SPELLSCHOOL_VAR");
}
