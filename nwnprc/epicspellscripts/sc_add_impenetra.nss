#include "prc_alterations"
#include "inc_epicspells"
int StartingConditional()
{
    // Make sure the player has the required feat
    if(!GetHasFeat(R_IMPENET_FE, GetPCSpeaker()) ||
        GetHasFeat(IMPENET_FE, GetPCSpeaker()))
        return FALSE;

    return TRUE;
}
