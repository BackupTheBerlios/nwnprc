#include "prc_alterations"
#include "inc_epicspells"
int StartingConditional()
{
    // Make sure the player has the required feat
    if(!GetHasFeat(R_DREAMSC_FE, GetPCSpeaker()) ||
        GetHasFeat(DREAMSC_FE, GetPCSpeaker()))
        return FALSE;

    return TRUE;
}
