#include "inc_epicspells"
int StartingConditional()
{
    // Make sure the player has the required feat
    if(!GetHasFeat(R_BATTLEB_FE, GetPCSpeaker()) ||
        GetHasFeat(BATTLEB_FE, GetPCSpeaker()))
        return FALSE;

    return TRUE;
}
