#include "inc_epicspells"
int StartingConditional()
{
    // Make sure the player has the required feat
    if(!GetHasFeat(R_HELBALL_FE, GetPCSpeaker()) ||
        GetHasFeat(HELBALL_FE, GetPCSpeaker()))
        return FALSE;

    return TRUE;
}
