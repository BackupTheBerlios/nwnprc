//:://////////////////////////////////////////////
//:: FileName: "ss_ep_continreun"
/*   Purpose: Contingent Reunion - upon casting this at a target, the caster
        must choose a condition which will later trigger the teleportation to
        the target.
*/
//:://////////////////////////////////////////////
//:: Created By: Boneshank
//:: Last Updated On: March 12, 2004
//:://////////////////////////////////////////////
#include "x2_inc_spellhook"
#include "inc_epicspells"

void main()
{
    if (!X2PreSpellCastCode())
    {
        return;
    }
    if (GetCanCastSpell(OBJECT_SELF, CON_REU_DC, CON_REU_S, CON_REU_XP))
    {
        // Is the target a place, creature, or object?
        object oTarget = GetSpellTargetObject();
        location lTarget = GetSpellTargetLocation();
        effect eVis = EffectVisualEffect(VFX_FNF_LOS_HOLY_20);
        if (oTarget != OBJECT_INVALID)
        {
            if (oTarget == OBJECT_SELF) // If target is self, becomes location
            {
                SetLocalLocation(OBJECT_SELF, "lSpellTarget", lTarget);
                SetLocalObject(OBJECT_SELF, "oSpellTarget", OBJECT_INVALID);
            }
            else
            {
                SetLocalObject(OBJECT_SELF, "oSpellTarget", oTarget);
                if (GetObjectType(oTarget) == OBJECT_TYPE_CREATURE)
                    SetLocalInt(OBJECT_SELF, "nMyTargetIsACreature", TRUE);
            }
        }
        else
        {
            SetLocalLocation(OBJECT_SELF, "lSpellTarget", lTarget);
            SetLocalObject(OBJECT_SELF, "oSpellTarget", OBJECT_INVALID);
        }
        ApplyEffectAtLocation(DURATION_TYPE_INSTANT, eVis, lTarget);
        AssignCommand(OBJECT_SELF, ActionStartConversation(OBJECT_SELF,
            "ss_cont_reunion", TRUE, FALSE));
    }
}

