#include "inc_epicspells"
int StartingConditional()
{
    // Make sure the player has the required feat
    if(!GetHasFeat(R_FIEND_W_FE, GetPCSpeaker()) ||
        GetHasFeat(FIEND_W_FE, GetPCSpeaker()))
        return FALSE;

    return TRUE;
}
