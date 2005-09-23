//:://////////////////////////////////////////////
//:: Dynamic Conversation: Show header node
//:: dynconv_main_w
//:://////////////////////////////////////////////
/** @file
    Determines whether to show the "NPC" response
    text or the wait node.

    @author Primogenitor
*/
//:://////////////////////////////////////////////
//:://////////////////////////////////////////////

#include "inc_dynconv"


int StartingConditional()
{
    object oPC = GetPCSpeaker();
    if(GetLocalInt(oPC, "DynConv_Waiting"))
        return FALSE;
    string sScript = GetLocalString(oPC, DYNCONV_SCRIPT);
    SetLocalInt(oPC, DYNCONV_VARIABLE, DYNCONV_SETUP_STAGE);
    ExecuteScript(sScript, OBJECT_SELF);
    if(GetLocalInt(oPC, "DynConv_Waiting"))
        return FALSE;
    return TRUE;
}
