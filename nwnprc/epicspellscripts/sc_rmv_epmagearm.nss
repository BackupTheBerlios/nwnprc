#include "inc_epicspells"
int StartingConditional()
{

    // Make sure the player has the required feat
    if(GetHasFeat(EP_M_AR_FE, GetPCSpeaker()))
        return TRUE;

    return FALSE;
}
