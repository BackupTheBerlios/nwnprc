//::///////////////////////////////////////////////
//:: OnPlayerDying eventscript
//:: prc_ondying
//:://////////////////////////////////////////////
#include "prc_alterations"
#include "inc_utility"

void main()
{
    // Execute scripts hooked to this event for the player triggering it
    object oPC = GetLastPlayerDying();
    ExecuteAllScriptsHookedToEvent(oPC, EVENT_ONPLAYERDYING);
}
