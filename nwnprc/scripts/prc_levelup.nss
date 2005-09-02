/*
    Put into: OnLevelup Event
*/
//:://////////////////////////////////////////////
//:: Created By: Stratovarius and DarkGod
//:: Created On: 2003-07-16
//:://////////////////////////////////////////////

//Added hook into EvalPRCFeats event
//  Aaon Graywolf - Jan 6, 2004
//Added delay to EvalPRCFeats event to allow module setup to take priority
//  Aaon Graywolf - Jan 6, 2004

#include "prc_alterations"
#include "prc_alterations"
#include "prc_inc_domain"
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
    object oPC = GetPCLevellingUp();

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
    
    //FloatingTextStringOnCreature("PRC Levelup was called", oPC, FALSE);
    
    // Gives people the proper spells from their bonus domains
    // This should run before EvalPRCFeats, because it sets a variable
    CheckBonusDomains(oPC);

    //All of the PRC feats have been hooked into EvalPRCFeats
    //The code is pretty similar, but much more modular, concise
    //And easy to maintain.
    //  - Aaon Graywolf
    DelayCommand(0.1, PrcFeats(oPC));

    // Check to see which special prc requirements (i.e. those that can't be done)
    // through the .2da's, the newly leveled up player meets.
    DelayCommand(0.5, ExecuteScript("prc_prereq", oPC)); // Delayed so that deleveling gets to happen before it.
    ExecuteScript("prc_enforce_feat", oPC);
    ExecuteScript("prc_enforce_psi", oPC);
    //Restore Power Points for Psionics
    ExecuteScript("prc_psi_ppoints", oPC);

    DelayCommand(1.0, FeatSpecialUsePerDay(oPC)); 

    // These scripts fire events that should only happen on levelup
    ExecuteScript("prc_vassal_treas", oPC);
    
    // Execute scripts hooked to this event for the player triggering it
    ExecuteAllScriptsHookedToEvent(oPC, EVENT_ONPLAYERLEVELUP);
}
