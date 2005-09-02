#include "prc_alterations"
#include "inc_epicspells"
int StartingConditional()
{
    // Make sure the player has the required feat
    if(!GetHasFeat(R_RISEN_R_FE, GetPCSpeaker()) ||
        GetHasFeat(RISEN_R_FE, GetPCSpeaker()))
        return FALSE;

    return TRUE;
}
