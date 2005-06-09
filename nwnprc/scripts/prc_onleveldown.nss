//::///////////////////////////////////////////////
//:: OnLevelDown eventscript
//:: prc_onleveldown
//:://////////////////////////////////////////////
/** @file
    This script is a virtual event. It is fired
    when a check in module hearbeat detects a player's
    hit dice has dropped.
    It runs most of the same operations as prc_levelup
    in order to fully re-evaluate the character's
    class features that are granted by the PRC scripts.
*/
//:://////////////////////////////////////////////
//:: Created By: Ornedan
//:: Created On: 09.06.2005
//:://////////////////////////////////////////////

#include "prc_inc_function"
#include "inc_item_props"
#include "inc_eventhook"


void PrcFeats(object oPC)
{
     EvalPRCFeats(oPC);
     if (GetLevelByClass(CLASS_TYPE_WEREWOLF, oPC) > 0)
     {
        ExecuteScript("prc_wwunpoly", oPC);
     }
}

void main()
{
    object oPC = OBJECT_SELF;

    //Used to determine what the last levelled class was
    if(GetLevelByClass(PRCGetClassByPosition(1, oPC), oPC) != PRCGetLevelByPosition(1, oPC))
        SetLocalInt(oPC, "LastLevelledClass", PRCGetClassByPosition(1, oPC));
    else if(GetLevelByClass(PRCGetClassByPosition(2, oPC), oPC) != PRCGetLevelByPosition(2, oPC))
        SetLocalInt(oPC, "LastLevelledClass", PRCGetClassByPosition(2, oPC));
    else if(GetLevelByClass(PRCGetClassByPosition(3, oPC), oPC) != PRCGetLevelByPosition(3, oPC))
        SetLocalInt(oPC, "LastLevelledClass", PRCGetClassByPosition(3, oPC));
    DelayCommand(2.0, DeleteLocalInt(oPC, "LastLevelledClass"));

    object oSkin = GetPCSkin(oPC);
    ScrubPCSkin(oPC, oSkin);
    DeletePRCLocalInts(oSkin);     

    //All of the PRC feats have been hooked into EvalPRCFeats
    //The code is pretty similar, but much more modular, concise
    //And easy to maintain.
    //  - Aaon Graywolf
    PrcFeats(oPC);

    // Check to see which special prc requirements (i.e. those that can't be done)
    // through the .2da's, the newly leveled up player meets.
    ExecuteScript("prc_prereq", oPC);
    
    // Execute scripts hooked to this event for the player triggering it
	ExecuteAllScriptsHookedToEvent(oPC, EVENT_ONPLAYERLEVELDOWN);
}
