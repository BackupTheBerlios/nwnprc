//::///////////////////////////////////////////////
//:: Check Arcane
//:: NW_D2_Arcane
//:: Copyright (c) 2001 Bioware Corp.
//:://////////////////////////////////////////////
/*
    Checks if the PC is a spellcaster
*/
//:://////////////////////////////////////////////
//:: Created By: Preston Watamaniuk
//:: Created On: Sept 18, 2001
//:://////////////////////////////////////////////
/**
* Modified by: fluffyamoeba
* oc_fix script for PRC base spellcasters to get through the prelude
*/

#include "prc_class_const"

int StartingConditional()
{
    object oCaster = GetPCSpeaker();
    if(GetLevelByClass(CLASS_TYPE_BARD,oCaster) > 0 ||
       GetLevelByClass(CLASS_TYPE_SORCERER,oCaster) > 0 ||
       GetLevelByClass(CLASS_TYPE_WILDER,oCaster) > 0 ||
       GetLevelByClass(CLASS_TYPE_SWORDSAGE,oCaster) > 0 ||
       GetLevelByClass(CLASS_TYPE_WARLOCK,oCaster) > 0 ||
       GetLevelByClass(CLASS_TYPE_SHUGENJA,oCaster) > 0 ||
       GetLevelByClass(CLASS_TYPE_DRAGONFIRE_ADEPT,oCaster) > 0 ||
       GetLevelByClass(CLASS_TYPE_WARMAGE,oCaster) > 0 ||
       GetLevelByClass(CLASS_TYPE_DUSKBLADE,oCaster) > 0 ||
       GetLevelByClass(CLASS_TYPE_PSYWAR,oCaster) > 0 ||
       GetLevelByClass(CLASS_TYPE_PSION,oCaster) > 0 ||
       GetLevelByClass(CLASS_TYPE_WIZARD,oCaster) > 0)
    {
        return TRUE;
    }
    return FALSE;
}

