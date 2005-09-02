#include "prc_alterations"
#include "inc_epicspells"
int StartingConditional()
{
    // Make sure the player has the required feat
    if(!GetHasFeat(R_STORM_M_FE, GetPCSpeaker()) ||
        GetHasFeat(STORM_M_FE, GetPCSpeaker()))
        return FALSE;

    return TRUE;
}
