#include "inc_epicspells"
int StartingConditional()
{
    // Make sure the player has the required feat
    if(!GetHasFeat(R_RAINFIR_FE, GetPCSpeaker()) ||
        GetHasFeat(RAINFIR_FE, GetPCSpeaker()))
        return FALSE;

    return TRUE;
}
