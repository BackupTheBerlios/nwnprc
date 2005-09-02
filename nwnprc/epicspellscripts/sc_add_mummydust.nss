#include "prc_alterations"
#include "inc_epicspells"
int StartingConditional()
{
    // Make sure the player has the required feat
    if(!GetHasFeat(R_MUMDUST_FE, GetPCSpeaker()) ||
        GetHasFeat(MUMDUST_FE, GetPCSpeaker()))
        return FALSE;

    return TRUE;
}
