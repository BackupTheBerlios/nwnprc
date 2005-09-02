#include "prc_alterations"
#include "inc_epicspells"
int StartingConditional()
{
    // Make sure the player has the required feat
    if(!GetHasFeat(R_SUP_DIS_FE, GetPCSpeaker()) ||
        GetHasFeat(SUP_DIS_FE, GetPCSpeaker()))
        return FALSE;

    return TRUE;
}
