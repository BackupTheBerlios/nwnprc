#include "inc_epicspells"
int StartingConditional()
{

    // Make sure the player has the required feat
    if(GetHasFeat(GR_SP_RE_FE, GetPCSpeaker()))
        return TRUE;

    return FALSE;
}
