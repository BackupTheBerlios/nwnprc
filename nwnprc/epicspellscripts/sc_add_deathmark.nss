#include "prc_alterations"
#include "inc_epicspells"
int StartingConditional()
{
    // Make sure the player has the required feat
    if(!GetHasFeat(R_DTHMARK_FE, GetPCSpeaker()) ||
        GetHasFeat(DTHMARK_FE, GetPCSpeaker()))
        return FALSE;

    return TRUE;
}
