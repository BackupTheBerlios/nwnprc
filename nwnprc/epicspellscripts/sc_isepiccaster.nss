//:://////////////////////////////////////////////
//:: FileName: "sc_isepiccaster"
/*   Purpose: Starting conditional, returns TRUE if the player is an epic caster.
*/
//:://////////////////////////////////////////////
//:: Created By: Boneshank
//:: Last Updated On: March 12, 2004
//:://////////////////////////////////////////////
#include "inc_epicspells"

int StartingConditional()
{
    object oPC = GetPCSpeaker();
    if (GetIsEpicCleric(oPC) || GetIsEpicDruid(oPC) ||
        GetIsEpicSorcerer(oPC) || GetIsEpicWizard(oPC))
        return TRUE;
    return FALSE;
}
