//::///////////////////////////////////////////////
//:: OnHeartbeat NPC eventscript
//:: prc_npc_hb
//:://////////////////////////////////////////////

#include "inc_prc_npc"
#include "inc_eventhook"

void main()
{
	//NPC substiture for OnEquip
	DoEquipTest();
	
	// Execute scripts hooked to this event for the NPC triggering it
	ExecuteAllScriptsHookedToEvent(OBJECT_SELF, EVENT_NPC_ONHEARTBEAT);
}