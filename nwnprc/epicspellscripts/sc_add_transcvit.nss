#include "inc_epicspells"
int StartingConditional()
{
    // Make sure the player has the required feat
    if(!GetHasFeat(R_TRANVIT_FE, GetPCSpeaker()) ||
        GetHasFeat(TRANVIT_FE, GetPCSpeaker()))
        return FALSE;

    return TRUE;
}
