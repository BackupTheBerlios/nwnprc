#include "inc_epicspells"
int StartingConditional()
{
    // Make sure the player has the required feat
    if(!GetHasFeat(R_EP_M_AR_FE, GetPCSpeaker()) ||
        GetHasFeat(EP_M_AR_FE, GetPCSpeaker()))
        return FALSE;

    return TRUE;
}
