#include "nw_i0_spells"
#include "inc_epicspells"
int StartingConditional()
{

    // Make sure the player has the required feat
    if(GetHasFeat(ARMY_UN_FE, GetPCSpeaker()))
        return TRUE;

    return FALSE;
}
