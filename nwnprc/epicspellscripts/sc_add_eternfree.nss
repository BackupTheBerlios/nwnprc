#include "inc_epicspells"
int StartingConditional()
{
    // Make sure the player has the required feat
    if(!GetHasFeat(R_ET_FREE_FE, GetPCSpeaker()) ||
        GetHasFeat(ET_FREE_FE, GetPCSpeaker()))
        return FALSE;

    return TRUE;
}
