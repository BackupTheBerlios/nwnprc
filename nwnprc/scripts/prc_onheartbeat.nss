//::///////////////////////////////////////////////
//:: OnHeartbeat eventscript
//:: prc_onheartbeat
//:://////////////////////////////////////////////

#include "inc_eventhook"

void main()
{
    // Item creation code
    ExecuteScript("hd_o0_heartbeat",OBJECT_SELF);

    // Race Pack Code
    ExecuteScript("race_hb", GetModule() );

    // Execute hooked HB scripts for all players
    object oPC = GetFirstPC();
    while(GetIsObjectValid(oPC)){
        ExecuteAllScriptsHookedToEvent(oPC, EVENT_ONHEARTBEAT);
        oPC = GetNextPC();
    }
}
