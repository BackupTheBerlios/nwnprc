#include "inc_epicspells"
int StartingConditional()
{
    // Make sure the player has the required feat
    if(!GetHasFeat(R_CELCOUN_FE, GetPCSpeaker()) ||
        GetHasFeat(CELCOUN_FE, GetPCSpeaker()))
        return FALSE;

    return TRUE;
}
