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

	// The scripts hooked to this event will have to be stored on the module itself
	ExecuteAllScriptsHookedToEvent(OBJECT_SELF, EVENT_ONHEARTBEAT);
}
