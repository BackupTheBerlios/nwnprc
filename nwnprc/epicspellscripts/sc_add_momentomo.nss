#include "inc_epicspells"
int StartingConditional()
{
    // Make sure the player has the required feat
    if(!GetHasFeat(R_MORI_FE, GetPCSpeaker()) ||
        GetHasFeat(MORI_FE, GetPCSpeaker()))
        return FALSE;

    return TRUE;
}
