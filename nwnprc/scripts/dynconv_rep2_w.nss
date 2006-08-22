//:://////////////////////////////////////////////
//:: Dynamic Conversation
//:: dynconv_rep2_w
//:://////////////////////////////////////////////
/** @file
    Checks that there is a valid option for
    conversation choice 2.

    @author Primogenitor
*/
//:://////////////////////////////////////////////
//:://////////////////////////////////////////////

#include "prc_alterations"

int StartingConditional()
{
    object oPC = GetPCSpeaker();
    if(GetLocalString(oPC, GetTokenIDString(DYNCONV_TOKEN_REPLY_2)) == "")
        return FALSE;
    else
        return TRUE;
}
