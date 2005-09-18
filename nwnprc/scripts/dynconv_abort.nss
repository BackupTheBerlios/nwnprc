//:://////////////////////////////////////////////
//:: Dynamic Conversation: Conversation aborted
//:: dynconv_abort
//:://////////////////////////////////////////////
/** @file
    Ran when the conversation is exited through
    being aborted.

    @author Primogenitor
*/
//:://////////////////////////////////////////////
//:://////////////////////////////////////////////

#include "inc_dynconv"


void main()
{
    object oPC = GetPCSpeaker();
    string sScript = GetLocalString(oPC, DYNCONV_SCRIPT);
    SetLocalInt(oPC, DYNCONV_VARIABLE, DYNCONV_ABORTED);
    ExecuteScript(sScript, OBJECT_SELF);
}
