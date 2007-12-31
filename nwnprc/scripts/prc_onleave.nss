//::///////////////////////////////////////////////
//:: OnClientLeave eventscript
//:: prc_onleave
//:://////////////////////////////////////////////
#include "prc_alterations"
#include "inc_utility"
#include "inc_letoscript"
#include "inc_leto_prc"

void main()
{
    // Execute scripts hooked to this event for the player triggering it
    object oPC = GetExitingObject();
    if(GetPRCSwitch(PRC_LETOSCRIPT_FIX_ABILITIES) && !GetIsDM(oPC))
        PRCLetoExit(oPC);
    if(GetPRCSwitch(PRC_USE_LETOSCRIPT) && !GetIsDM(oPC))
        LetoPCExit(oPC);
    AssignCommand(GetModule(), DelayCommand(0.1, RecalculateTime()));
    if (GetLevelByClass(CLASS_TYPE_WEREWOLF, oPC) > 0)
    {
        ExecuteScript("prc_wwunpoly", oPC);
    }
    ExecuteAllScriptsHookedToEvent(oPC, EVENT_ONCLIENTLEAVE);
}
