#include "inc_epicspells"
int StartingConditional()
{
    // Make sure the player has the required feat
    if(!GetHasFeat(R_PIOUS_P_FE, GetPCSpeaker()) ||
        GetHasFeat(PIOUS_P_FE, GetPCSpeaker()))
        return FALSE;

    return TRUE;
}
