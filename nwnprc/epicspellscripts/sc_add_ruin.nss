#include "inc_epicspells"
int StartingConditional()
{
    // Make sure the player has the required feat
    if(!GetHasFeat(R_RUIN_FE, GetPCSpeaker()) ||
        GetHasFeat(RUIN_FE, GetPCSpeaker()))
        return FALSE;

    return TRUE;
}
