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
#include "prc_inc_domain"

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
    if(DEBUG) DoDebug("prc_levelup running for '" + GetName(oPC) + "'");

    object oSkin = GetPCSkin(oPC);
    ScrubPCSkin(oPC, oSkin);
    DeletePRCLocalInts(oSkin);
    if(DEBUG) DoDebug("prc_levelup: DeleteLocals");

    // Gives people the proper spells from their bonus domains
    // This should run before EvalPRCFeats, because it sets a variable
    CheckBonusDomains(oPC);
    if(DEBUG) DoDebug("prc_levelup: BonusDomain");
    //All of the PRC feats have been hooked into EvalPRCFeats
    //The code is pretty similar, but much more modular, concise
    //And easy to maintain.
    //  - Aaon Graywolf
    DelayCommand(0.1, PrcFeats(oPC));
    if(DEBUG) DoDebug("prc_levelup: PRCFeats");
    // Check to see which special prc requirements (i.e. those that can't be done)
    // through the .2da's, the newly leveled up player meets.
    DelayCommand(0.5, ExecuteScript("prc_prereq", oPC)); // Delayed so that deleveling gets to happen before it.
    ExecuteScript("prc_enforce_feat", oPC);
    ExecuteScript("prc_enforce_psi", oPC);
    //Restore Power Points for Psionics
    ExecuteScript("prc_psi_ppoints", oPC);
    if(DEBUG) DoDebug("prc_levelup: PowerPoints");
    DelayCommand(1.0, FeatSpecialUsePerDay(oPC));

    // These scripts fire events that should only happen on levelup
    ExecuteScript("prc_vassal_treas", oPC);
    ExecuteScript("tob_evnt_recover", oPC);

    // Execute scripts hooked to this event for the player triggering it
    ExecuteAllScriptsHookedToEvent(oPC, EVENT_ONPLAYERLEVELUP);
    if(DEBUG) DoDebug("prc_levelup: Exiting");
}
