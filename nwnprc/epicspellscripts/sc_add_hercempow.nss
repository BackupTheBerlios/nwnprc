#include "inc_epicspells"
int StartingConditional()
{

    // Make sure the player has the required feat
    if(!GetHasFeat(R_HERCEMP_FE, GetPCSpeaker()) ||
        GetHasFeat(HERCEMP_FE, GetPCSpeaker()))
        return FALSE;

    return TRUE;
}
