#include "inc_epicspells"
int StartingConditional()
{
    // Make sure the player has the required feat
    if(!GetHasFeat(R_GODSMIT_FE, GetPCSpeaker()) ||
        GetHasFeat(GODSMIT_FE, GetPCSpeaker()))
        return FALSE;

    return TRUE;
}
