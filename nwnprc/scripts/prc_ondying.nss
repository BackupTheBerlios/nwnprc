//::///////////////////////////////////////////////
//:: OnPlayerDying eventscript
//:: prc_ondying
//:://////////////////////////////////////////////

#include "inc_eventhook"

void main()
{
	// Execute scripts hooked to this event for the player triggering it
	object oPC = GetLastPCToCancelCutscene();
	ExecuteAllScriptsHookedToEvent(oPC, EVENT_ONPLAYERDYING);
}
