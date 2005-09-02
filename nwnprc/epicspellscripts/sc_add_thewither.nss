#include "prc_alterations"
#include "inc_epicspells"
int StartingConditional()
{
    // Make sure the player has the required feat
    if(!GetHasFeat(R_THEWITH_FE, GetPCSpeaker()) ||
        GetHasFeat(THEWITH_FE, GetPCSpeaker()))
        return FALSE;

    return TRUE;
}
