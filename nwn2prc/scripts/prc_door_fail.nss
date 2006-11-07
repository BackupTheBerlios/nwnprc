//::///////////////////////////////////////////////
//:: OnFailToOpen door eventscript
//:: prc_door_fail
//:://////////////////////////////////////////////

#include "prc_alterations"
void main()
{
    ExecuteAllScriptsHookedToEvent(OBJECT_SELF, EVENT_DOOR_ONFAILTOOPEN);
}