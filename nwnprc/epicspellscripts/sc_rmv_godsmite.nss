#include "inc_epicspells"
int StartingConditional()
{

    // Make sure the player has the required feat
    if(GetHasFeat(GODSMIT_FE, GetPCSpeaker()))
        return TRUE;

    return FALSE;
}
