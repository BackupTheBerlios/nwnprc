#include "prc_alterations"
#include "inc_epicspells"
int StartingConditional()
{

    // Make sure the player has the required feat
    if(GetHasFeat(AL_MART_FE, GetPCSpeaker()))
        return TRUE;

    return FALSE;
}
