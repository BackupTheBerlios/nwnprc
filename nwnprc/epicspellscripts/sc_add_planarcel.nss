#include "prc_alterations"
#include "inc_epicspells"
int StartingConditional()
{
    // Make sure the player has the required feat
    if(!GetHasFeat(R_PLANCEL_FE, GetPCSpeaker()) ||
        GetHasFeat(PLANCEL_FE, GetPCSpeaker()))
        return FALSE;

    return TRUE;
}
