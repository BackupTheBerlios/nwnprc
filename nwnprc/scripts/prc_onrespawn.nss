//::///////////////////////////////////////////////
//:: OnPlayerRespawn eventscript
//:: prc_onrespawn
//:://////////////////////////////////////////////

#include "inc_eventhook"

void main()
{
	// Execute scripts hooked to this event for the player triggering it
	object oPC =  GetLastRespawnButtonPresser();
	ExecuteAllScriptsHookedToEvent(oPC, EVENT_ONPLAYERRESPAWN);
}
