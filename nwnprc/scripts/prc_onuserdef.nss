//::///////////////////////////////////////////////
//:: OnUserDefined eventscript
//:: prc_onuserdef
//:://////////////////////////////////////////////

#include "inc_eventhook"

void main()
{
	// Executes scripts stored on the module for this event
	ExecuteAllScriptsHookedToEvent(OBJECT_SELF, EVENT_ONUSERDEFINED);
}
