#include "nw_i0_spells"
#include "inc_epicspells"
int StartingConditional()
{

    // Make sure the player has the required feat
    if(GetHasFeat(DRG_KNI_FE, GetPCSpeaker()))
        return TRUE;

    return FALSE;
}
