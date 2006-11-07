//::///////////////////////////////////////////////
//:: OnOpen door eventscript
//:: prc_door_open
//:://////////////////////////////////////////////

#include "prc_alterations"
void main()
{
    ExecuteAllScriptsHookedToEvent(OBJECT_SELF, EVENT_DOOR_ONOPEN);
}