//::///////////////////////////////////////////////
//:: OnAreaTransitionClick door eventscript
//:: prc_door_transit
//:://////////////////////////////////////////////

#include "prc_alterations"
void main()
{
    ExecuteAllScriptsHookedToEvent(OBJECT_SELF, EVENT_DOOR_ONTRANSITION);
}