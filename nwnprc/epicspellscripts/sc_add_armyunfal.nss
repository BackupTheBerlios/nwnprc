#include "inc_epicspells"
int StartingConditional()
{
    // Make sure the player has the required feat
    if(!GetHasFeat(R_ARMY_UN_FE, GetPCSpeaker()) ||
        GetHasFeat(ARMY_UN_FE, GetPCSpeaker()))
        return FALSE;

    return TRUE;
}
