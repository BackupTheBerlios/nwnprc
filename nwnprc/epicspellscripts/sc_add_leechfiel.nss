#include "inc_epicspells"
int StartingConditional()
{
    // Make sure the player has the required feat
    if(!GetHasFeat(R_LEECH_F_FE, GetPCSpeaker()) ||
        GetHasFeat(LEECH_F_FE, GetPCSpeaker()))
        return FALSE;

    return TRUE;
}
