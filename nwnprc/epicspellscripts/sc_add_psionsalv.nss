#include "inc_epicspells"
int StartingConditional()
{

    // Make sure the player has the required feat
    if(!GetHasFeat(R_PSION_S_FE, GetPCSpeaker()) ||
        GetHasFeat(PSION_S_FE, GetPCSpeaker()))
        return FALSE;

    return TRUE;
}
