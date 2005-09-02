#include "prc_alterations"
#include "inc_epicspells"
int StartingConditional()
{
    // Make sure the player has the required feat
    if(!GetHasFeat(R_TOLO_KW_FE, GetPCSpeaker()) ||
        GetHasFeat(TOLO_KW_FE, GetPCSpeaker()))
        return FALSE;

    return TRUE;
}
