#include "inc_item_props"
#include "prc_inc_function"
#include "prc_inc_clsfunc"
#include "inc_eventhook"
#include "prc_inc_switch"
#include "inc_leto_prc"


void main()
{
    //The composite properties system gets confused when an exported
    //character re-enters.  Local Variables are lost and most properties
    //get re-added, sometimes resulting in larger than normal bonuses.
    //The only real solution is to wipe the skin on entry.  This will
    //mess up the lich, but only until I hook it into the EvalPRC event -
    //hopefully in the next update
    //  -Aaon Graywolf
    object oPC = GetEnteringObject();
    object oSkin = GetPCSkin(oPC);
    ScrubPCSkin(oPC, oSkin);
    DeletePRCLocalInts(oSkin);

    SetLocalInt(oPC,"ONENTER",1);
    // Make sure we reapply any bonuses before the player notices they are gone.
    DelayCommand(0.1, EvalPRCFeats(oPC));
    // Check to see which special prc requirements (i.e. those that can't be done)
    // through the .2da's, the entering player already meets.
    ExecuteScript("prc_prereq", oPC);
    ExecuteScript("prc_psi_ppoints", oPC);
    if (GetHasFeat(FEAT_PRESTIGE_IMBUE_ARROW))
    {
        //Destroy imbued arrows.
        AADestroyAllImbuedArrows(oPC);
    }
    DelayCommand(0.15, DeleteLocalInt(oPC,"ONENTER"));
    
    //Anti Forum Troll Code
    //Thats right, the PRC now has grudges.
    string sPlayerName = GetStringLowerCase(GetPCPlayerName(oPC));
    if(sPlayerName == "archfiend")
    {
        BlackScreen(oPC);//cant see or do anything
    }
    
    if(GetPRCSwitch(PRC_USE_LETOSCRIPT) && !GetIsDM(oPC))
        LetoPCEnter(oPC);
    if(GetPRCSwitch(PRC_LETOSCRIPT_FIX_ABILITIES) && !GetIsDM(oPC))
        PRCLetoEnter(oPC);   
    if(GetPRCSwitch(PRC_CONVOCC_ENABLE))
        ExecuteScript("prc_ccc_enter", OBJECT_SELF);           
    // Execute scripts hooked to this event for the player triggering it
    ExecuteAllScriptsHookedToEvent(oPC, EVENT_ONCLIENTENTER);
    

}
