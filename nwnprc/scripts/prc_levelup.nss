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



#include "x2_inc_switches"
#include "prc_inc_function"
#include "soul_inc"

void PrcFeats(object oPC)
{
     EvalPRCFeats(oPC);
     

}

void main()
{
    object oPC = GetPCLevellingUp();
    object oSkin = GetPCSkin(oPC);
    ScrubPCSkin(oPC, oSkin);
    DeletePRCLocalInts(oSkin);     

    //All of the PRC feats have been hooked into EvalPRCFeats
    //The code is pretty similar, but much more modular, concise
    //And easy to maintain.
    //  - Aaon Graywolf
    DelayCommand(0.1, PrcFeats(oPC));

    // Check to see which special prc requirements (i.e. those that can't be done)
    // through the .2da's, the newly leveled up player meets.
    ExecuteScript("prc_prereq", oPC);
    PatronShar(oPC);
    DelayCommand(1.0, FeatSpecialUsePerDay(oPC));
    
}
