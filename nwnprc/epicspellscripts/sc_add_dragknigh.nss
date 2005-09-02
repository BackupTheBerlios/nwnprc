#include "prc_alterations"
#include "inc_epicspells"
int StartingConditional()
{
    // Make sure the player has the required feat
    if(!GetHasFeat(R_DRG_KNI_FE, GetPCSpeaker()) ||
        GetHasFeat(DRG_KNI_FE, GetPCSpeaker()))
        return FALSE;

    return TRUE;
}
