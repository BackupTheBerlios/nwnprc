//:://////////////////////////////////////////////
//:: FileName: "ss_ep_celestcoun"
/*   Purpose: Celestial Council - summons a "ghost" of a celestial NPC, which
        then starts a conversation with the caster.
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
    if (GetCanCastSpell(OBJECT_SELF, CELCOUN_DC, CELCOUN_S, CELCOUN_XP))
    {
        DelayCommand(5.0, AssignCommand(OBJECT_SELF,
            ActionStartConversation(OBJECT_SELF,
            "ss_celestialcoun", TRUE, FALSE)));
    }
}

