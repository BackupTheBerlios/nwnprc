#include "nw_i0_spells"
#include "inc_epicspells"
int StartingConditional()
{
    // Make sure the player has the required feat
    if(!GetHasFeat(R_NAILSKY_FE, GetPCSpeaker()) ||
        GetHasFeat(NAILSKY_FE, GetPCSpeaker()))
        return FALSE;

    return TRUE;
}
