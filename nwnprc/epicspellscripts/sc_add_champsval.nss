#include "prc_alterations"
#include "inc_epicspells"
int StartingConditional()
{
    // Make sure the player has the required feat
    if(!GetHasFeat(R_CHAMP_V_FE, GetPCSpeaker()) ||
        GetHasFeat(CHAMP_V_FE, GetPCSpeaker()))
        return FALSE;

    return TRUE;
}
