#include "prc_alterations"
#include "inc_epicspells"
int StartingConditional()
{
    // Make sure the player has the required feat
    if(!GetHasFeat(R_GR_SP_RE_FE, GetPCSpeaker()) ||
        GetHasFeat(GR_SP_RE_FE, GetPCSpeaker()))
        return FALSE;

    return TRUE;
}
