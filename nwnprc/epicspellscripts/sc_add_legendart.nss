#include "inc_epicspells"
int StartingConditional()
{
    // Make sure the player has the required feat
    if(!GetHasFeat(R_LEG_ART_FE, GetPCSpeaker()) ||
        GetHasFeat(LEG_ART_FE, GetPCSpeaker()))
        return FALSE;

    return TRUE;
}
