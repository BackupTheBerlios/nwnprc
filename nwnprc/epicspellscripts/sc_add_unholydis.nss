#include "inc_epicspells"
int StartingConditional()
{
    // Make sure the player has the required feat
    if(!GetHasFeat(R_UNHOLYD_FE, GetPCSpeaker()) ||
        GetHasFeat(UNHOLYD_FE, GetPCSpeaker()))
        return FALSE;

    return TRUE;
}
