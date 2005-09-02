#include "prc_alterations"
#include "inc_epicspells"
int StartingConditional()
{
    // Make sure the player has the required feat
    if(!GetHasFeat(R_FLEETNS_FE, GetPCSpeaker()) ||
        GetHasFeat(FLEETNS_FE, GetPCSpeaker()))
        return FALSE;

    return TRUE;
}
