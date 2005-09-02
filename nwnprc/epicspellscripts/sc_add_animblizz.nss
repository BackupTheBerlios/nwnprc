#include "prc_alterations"
#include "inc_epicspells"
int StartingConditional()
{

    // Make sure the player has the required feat
    if(!GetHasFeat(R_ANBLIZZ_FE, GetPCSpeaker()) ||
        GetHasFeat(ANBLIZZ_FE, GetPCSpeaker()))
        return FALSE;

    return TRUE;
}
