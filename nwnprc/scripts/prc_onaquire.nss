//::///////////////////////////////////////////////
//:: OnAcquireItem eventscript
//:: prc_onaquire
//:://////////////////////////////////////////////

#include "inc_eventhook"

void main()
{
	// Handle someone acquiring an poisoned item.
	ExecuteScript("poison_onaquire", OBJECT_SELF);
	
	// Execute scripts hooked to this event for the player triggering it
	object oPC = GetModuleItemAcquiredBy();
	ExecuteAllScriptsHookedToEvent(oPC, EVENT_ONACQUIREITEM);
}
