#include "inc_epicspells"
int StartingConditional()
{
    // Make sure the player has the required feat
    if(!GetHasFeat(R_TWINF_FE, GetPCSpeaker()) ||
        GetHasFeat(TWINF_FE, GetPCSpeaker()))
        return FALSE;

    return TRUE;
}
