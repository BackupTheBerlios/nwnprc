//::///////////////////////////////////////////////
//:: FileName pnp_lich_isdemi
//:://////////////////////////////////////////////
//:://////////////////////////////////////////////
//:: Created By: Script Wizard
//:: Created On: 1/24/2004 9:30:45 AM
//:://////////////////////////////////////////////
#include "prc_alterations"
#include "prc_getcast_lvl"

// Determines if the the lich is able to start the process of becoming a demilich

int StartingConditional()
{

    // Restrict based on the player's class
    int iPassed = FALSE;
	
    if((GetLevelByClass(CLASS_TYPE_LICH, GetPCSpeaker()) >= 4) &&
       ((GetCasterLvl(TYPE_CLERIC,GetPCSpeaker()) >= 21) ||
        (GetCasterLvl(TYPE_WIZARD,GetPCSpeaker()) >= 21) ||
        (GetCasterLvl(TYPE_SORCERER,GetPCSpeaker()) >= 21)) )
        iPassed = TRUE;

    return iPassed;
}
