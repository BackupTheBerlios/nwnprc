//:://////////////////////////////////////////////
//:: FileName: "ss_ep_fiendwords"
/*   Purpose: Fiendish Words - summons a "ghost" of a fiend NPC, which
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
    if (GetCanCastSpell(OBJECT_SELF, FIEND_W_DC, FIEND_W_S, FIEND_W_XP))
    {
        DelayCommand(5.0, AssignCommand(OBJECT_SELF,
            ActionStartConversation(OBJECT_SELF,
            "ss_fiendishwords", TRUE, FALSE)));
    }
}

