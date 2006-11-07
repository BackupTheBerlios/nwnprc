//::///////////////////////////////////////////////
//:: OnLocked door eventscript
//:: prc_door_lock
//:://////////////////////////////////////////////

#include "prc_alterations"
void main()
{
    ExecuteAllScriptsHookedToEvent(OBJECT_SELF, EVENT_DOOR_ONLOCK);
}