#include "nw_i0_spells"
#include "inc_epicspells"
int StartingConditional()
{
    // Make sure the player has the required feat
    if(!GetHasFeat(R_DULBLAD_FE, GetPCSpeaker()) ||
        GetHasFeat(DULBLAD_FE, GetPCSpeaker()))
        return FALSE;

    return TRUE;
}
