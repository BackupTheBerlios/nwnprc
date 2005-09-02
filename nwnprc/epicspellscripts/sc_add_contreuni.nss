#include "prc_alterations"
#include "inc_epicspells"
int StartingConditional()
{
    // Make sure the player has the required feat
    if(!GetHasFeat(R_CON_REU_FE, GetPCSpeaker()) ||
        GetHasFeat(CON_REU_FE, GetPCSpeaker()))
        return FALSE;

    return TRUE;
}
