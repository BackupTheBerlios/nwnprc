#include "prc_alterations"
#include "inc_epicspells"
int StartingConditional()
{
    // Make sure the player has the required feat
    if(!GetHasFeat(R_DWEO_TH_FE, GetPCSpeaker()) ||
        GetHasFeat(DWEO_TH_FE, GetPCSpeaker()))
        return FALSE;

    return TRUE;
}
