#include "inc_epicspells"
int StartingConditional()
{
    // Make sure the player has the required feat
    if(!GetHasFeat(R_ENSLAVE_FE, GetPCSpeaker()) ||
        GetHasFeat(ENSLAVE_FE, GetPCSpeaker()))
        return FALSE;

    return TRUE;
}
