#include "nw_i0_spells"
#include "inc_epicspells"
int StartingConditional()
{
    // Make sure the player has the required feat
    if(!GetHasFeat(R_DIREWIN_FE, GetPCSpeaker()) ||
        GetHasFeat(DIREWIN_FE, GetPCSpeaker()))
        return FALSE;

    return TRUE;
}
