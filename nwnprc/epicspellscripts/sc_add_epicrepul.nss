#include "inc_epicspells"
int StartingConditional()
{
    // Make sure the player has the required feat
    if(!GetHasFeat(R_EP_RPLS_FE, GetPCSpeaker()) ||
        GetHasFeat(EP_RPLS_FE, GetPCSpeaker()))
        return FALSE;

    return TRUE;
}
