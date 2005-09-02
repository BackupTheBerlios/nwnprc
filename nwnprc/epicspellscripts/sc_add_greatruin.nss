#include "prc_alterations"
#include "inc_epicspells"
int StartingConditional()
{
    // Make sure the player has the required feat
    if(!GetHasFeat(R_GR_RUIN_FE, GetPCSpeaker()) ||
        GetHasFeat(GR_RUIN_FE, GetPCSpeaker()))
        return FALSE;

    return TRUE;
}
