#include "prc_alterations"
#include "inc_epicspells"
int StartingConditional()
{
    // Make sure the player has the required feat
    if(!GetHasFeat(R_MAGMA_B_FE, GetPCSpeaker()) ||
        GetHasFeat(MAGMA_B_FE, GetPCSpeaker()))
        return FALSE;

    return TRUE;
}
