#include "prc_alterations"
#include "inc_epicspells"
int StartingConditional()
{
    // Make sure the player has the required feat
    if(!GetHasFeat(R_HERCALL_FE, GetPCSpeaker()) ||
        GetHasFeat(HERCALL_FE, GetPCSpeaker()))
        return FALSE;

    return TRUE;
}
