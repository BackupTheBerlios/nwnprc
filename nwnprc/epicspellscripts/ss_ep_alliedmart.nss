//:://////////////////////////////////////////////
//:: FileName: "ss_ep_alliedmart"
/*   Purpose: Allied Martyr - The subject of this spell willingly allows all
        damage suffered by the caster to be transfered to the subject.
        NOTE: It is ASSUMED that any NPC partymember is automatically willing.
            Other party members who are actual players will have a conversation
            pop up where they are asked if they are willing to let it happen.
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
    if (GetCanCastSpell(OBJECT_SELF, AL_MART_DC, AL_MART_S, AL_MART_XP))
    {
        object oTarget = GetSpellTargetObject();
        // Twice per round, for 20 hours.
        int nDuration = FloatToInt(HoursToSeconds(20) / 3);
        // Is the target an ally (in the caster's party)?
        effect eVis = EffectVisualEffect(VFX_IMP_HOLY_AID);
        if (GetFactionEqual(oTarget, OBJECT_SELF))
        {
            SetLocalObject(oTarget, "oAllyForMyMartyrdom", OBJECT_SELF);
            SetLocalString(oTarget,
                "sAllyForMyMartyrdom", GetName(OBJECT_SELF));
            SetLocalInt(oTarget, "nTimeForMartyrdomFor", nDuration);
            ApplyEffectToObject(DURATION_TYPE_INSTANT, eVis, oTarget);
            ApplyEffectToObject(DURATION_TYPE_INSTANT, eVis, OBJECT_SELF);
            // Is the party member another player?
            if (GetIsPC(oTarget))
            {
                //We have to get the player's permission for this.
                // A "Yes" from the player will use ActionTaken to run script.
                AssignCommand(oTarget, ActionStartConversation(OBJECT_SELF,
                    "ss_alliedmartyr", TRUE, FALSE));
            }
            // The party member is NOT a player.
            else
            {
                ExecuteScript("run_all_martyr", oTarget);
            }

        }
    }
}
