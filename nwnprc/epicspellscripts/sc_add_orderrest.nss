#include "nw_i0_spells"
#include "inc_epicspells"
int StartingConditional()
{
    // Make sure the player has the required feat
    if(!GetHasFeat(R_ORDER_R_FE, GetPCSpeaker()) ||
        GetHasFeat(ORDER_R_FE, GetPCSpeaker()))
        return FALSE;

    return TRUE;
}
