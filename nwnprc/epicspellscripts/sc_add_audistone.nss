#include "nw_i0_spells"
#include "inc_epicspells"
int StartingConditional()
{

    // Make sure the player has the required feat
    if(!GetHasFeat(R_A_STONE_FE, GetPCSpeaker()) ||
        GetHasFeat(A_STONE_FE, GetPCSpeaker()))
        return FALSE;

    return TRUE;
}
