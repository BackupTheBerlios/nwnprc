#include "inc_dynconv"


void main()
{
    object oPC = OBJECT_SELF;
    SetLocalString(oPC, DYNCONV_SCRIPT, "prc_switchesc");
    ActionStartConversation(oPC, "dyncov_base", TRUE, FALSE);
}
