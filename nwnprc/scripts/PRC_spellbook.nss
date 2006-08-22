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


#include "prc_alterations"

void main()
{
    object oPC = OBJECT_SELF;
    StartDynamicConversation("prc_s_spellb", oPC, DYNCONV_EXIT_ALLOWED_SHOW_CHOICE, TRUE, FALSE, oPC);
}
