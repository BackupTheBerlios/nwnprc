//::///////////////////////////////////////////////
//:: OnDamaged NPC eventscript
//:: prc_npc_damaged
//:://////////////////////////////////////////////

#include "inc_eventhook"

void main()
{
	// Execute scripts hooked to this event for the NPC triggering it
	ExecuteAllScriptsHookedToEvent(OBJECT_SELF, EVENT_NPC_ONDAMAGED);
}