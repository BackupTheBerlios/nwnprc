#include "inc_epicspells"
int StartingConditional()
{
    // Make sure the player has the required feat
    if(!GetHasFeat(R_WHIP_SH_FE, GetPCSpeaker()) ||
        GetHasFeat(WHIP_SH_FE, GetPCSpeaker()))
        return FALSE;

    return TRUE;
}
