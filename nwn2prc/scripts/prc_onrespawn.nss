//::///////////////////////////////////////////////
//:: OnPlayerRespawn eventscript
//:: prc_onrespawn
//:://////////////////////////////////////////////
#include "prc_alterations"
#include "inc_utility"

void main()
{
    // Execute scripts hooked to this event for the player triggering it
    object oPC =  GetLastRespawnButtonPresser();
    ExecuteAllScriptsHookedToEvent(oPC, EVENT_ONPLAYERRESPAWN);
}