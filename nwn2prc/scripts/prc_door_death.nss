//::///////////////////////////////////////////////
//:: OnDeath door eventscript
//:: prc_door_death
//:://////////////////////////////////////////////

#include "prc_alterations"
void main()
{
    ExecuteAllScriptsHookedToEvent(OBJECT_SELF, EVENT_DOOR_ONDEATH);
}