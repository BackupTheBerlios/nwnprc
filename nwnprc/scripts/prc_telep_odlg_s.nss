//:://////////////////////////////////////////////
//:: Teleport options dialog starter
//:: prc_telp_odlg_s
//:://////////////////////////////////////////////
/** @file
    This script starts the Teleport Options dynamic
    conversation.
*/
//:://////////////////////////////////////////////
//:: Created By: Ornedan
//:: Created On: 18.06.2005
//:://////////////////////////////////////////////

#include "inc_dynconv"


void main()
{
    SetLocalString(OBJECT_SELF, DYNCONV_SCRIPT, "prc_telep_optdlg");
    AssignCommand(OBJECT_SELF, ClearAllActions(TRUE));
    AssignCommand(OBJECT_SELF, ActionStartConversation(OBJECT_SELF, "dyncov_base", TRUE, FALSE));
}