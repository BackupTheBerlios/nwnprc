//:://////////////////////////////////////////////
//:: FileName: "sc_epicradial_ok"
/*   Purpose: Starting conditional check to make sure player has 7 or less
        spells assigned to their epic spell radial menu (prevents CRASH)
	 NOTE: The Rest Dialog has been keyed to a feat on the same menu.
	 This limits the spells to 6 now.
*/
//:://////////////////////////////////////////////
//:: Created By: Boneshank
//:: Last Updated On: March 12, 2004
//:://////////////////////////////////////////////
#include "inc_epicspells"

int StartingConditional()
{
    if (GetCastableFeatCount(GetPCSpeaker()) < 6)
        return TRUE;
    return FALSE;
}
