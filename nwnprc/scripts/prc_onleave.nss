//::///////////////////////////////////////////////
//:: OnClientLeave eventscript
//:: prc_onleave
//:://////////////////////////////////////////////
#include "prc_alterations"
#include "inc_eventhook"
#include "prc_inc_switch"
#include "inc_letoscript"
#include "inc_leto_prc"
#include "inc_time"

void main()
{
    // Execute scripts hooked to this event for the player triggering it
    object oPC = GetExitingObject();
    if(GetPRCSwitch(PRC_LETOSCRIPT_FIX_ABILITIES) && !GetIsDM(oPC))
        PRCLetoExit(oPC);  
    if(GetPRCSwitch(PRC_USE_LETOSCRIPT) && !GetIsDM(oPC))
        LetoPCExit(oPC);     
    AssignCommand(GetModule(), DelayCommand(0.1, RecalculateTime()));        
    ExecuteAllScriptsHookedToEvent(oPC, EVENT_ONCLIENTLEAVE);
}
