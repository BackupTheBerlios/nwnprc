// Added compatibility for PRC base classes
#include "prc_class_const"
#include "inc_utility"

//::///////////////////////////////////////////////
//:: FileName M0q01herbfight
//:: Copyright (c) 2002 Bioware Corp.
//:://////////////////////////////////////////////
//:://////////////////////////////////////////////
//:: Created By: Script Wizard
//:: Created On: 4/25/2002 10:21:34 AM
//:://////////////////////////////////////////////
int StartingConditional()
{
if(DEBUG) DoDebug("M0q01herbfight running");
    // Restrict based on the player's class
    if((GetLevelByClass(CLASS_TYPE_BARBARIAN, GetPCSpeaker()) == 0) &&
       (GetLevelByClass(CLASS_TYPE_FIGHTER, GetPCSpeaker()) == 0) &&
       (GetLevelByClass(CLASS_TYPE_MONK, GetPCSpeaker()) == 0) &&
       (GetLevelByClass(CLASS_TYPE_BRAWLER, GetPCSpeaker()) == 0) &&
       (GetLevelByClass(CLASS_TYPE_SOULKNIFE, GetPCSpeaker()) == 0) &&
       (GetLevelByClass(CLASS_TYPE_ANTI_PALADIN, GetPCSpeaker()) == 0) &&
       (GetLevelByClass(CLASS_TYPE_CORRUPTER, GetPCSpeaker()) == 0) &&
       (GetLevelByClass(CLASS_TYPE_MARSHAL, GetPCSpeaker()) == 0) &&
       (GetLevelByClass(CLASS_TYPE_SWASHBUCKLER, GetPCSpeaker()) == 0) &&
       (GetLevelByClass(CLASS_TYPE_ARCHER, GetPCSpeaker()) == 0) &&
       (GetLevelByClass(CLASS_TYPE_CW_SAMURAI, GetPCSpeaker()) == 0) &&
       (GetLevelByClass(CLASS_TYPE_SAMURAI, GetPCSpeaker()) == 0) &&
       (GetLevelByClass(CLASS_TYPE_PSYWAR, GetPCSpeaker()) == 0) &&
       (GetLevelByClass(CLASS_TYPE_ULTIMATE_RANGER, GetPCSpeaker()) == 0) &&
       (GetLevelByClass(CLASS_TYPE_PALADIN, GetPCSpeaker()) == 0) &&
       (GetLevelByClass(CLASS_TYPE_RANGER, GetPCSpeaker()) == 0))
        return FALSE;

    return TRUE;
}
