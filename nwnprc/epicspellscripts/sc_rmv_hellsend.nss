#include "inc_epicspells"
int StartingConditional()
{

    // Make sure the player has the required feat
    if(GetHasFeat(HELSEND_FE, GetPCSpeaker()))
        return TRUE;

    return FALSE;
}
