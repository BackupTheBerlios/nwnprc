//::///////////////////////////////////////////////
//:: OnClientLeave eventscript
//:: prc_onleave
//:://////////////////////////////////////////////

#include "inc_eventhook"

void main()
{
	// Execute scripts hooked to this event for the player triggering it
	object oPC = GetExitingObject();
	ExecuteAllScriptsHookedToEvent(oPC, EVENT_ONCLIENTLEAVE);
}
