//:://////////////////////////////////////////////
//:: New Spellbooks conversation starter
//:: prc_spellbook
//:://////////////////////////////////////////////
/** @file
    This script starts the new spellbook spell
    slots management conversation

    @author Primogenitor
*/
//:://////////////////////////////////////////////
//:://////////////////////////////////////////////


#include "inc_dynconv"

void main()
{
    object oPC = OBJECT_SELF;
    StartDynamicConversation("prc_s_spellb", oPC, TRUE, TRUE, FALSE, oPC);
}
