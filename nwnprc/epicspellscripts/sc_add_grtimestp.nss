#include "inc_epicspells"
int StartingConditional()
{
    // Make sure the player has the required feat
    if(!GetHasFeat(R_GR_TIME_FE, GetPCSpeaker()) ||
        GetHasFeat(GR_TIME_FE, GetPCSpeaker()))
        return FALSE;

    return TRUE;
}
