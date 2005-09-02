#include "prc_alterations"
#include "inc_epicspells"
int StartingConditional()
{
    // Make sure the player has the required feat
    if(!GetHasFeat(R_AL_MART_FE, GetPCSpeaker()) ||
        GetHasFeat(AL_MART_FE, GetPCSpeaker()))
        return FALSE;

    return TRUE;
}
