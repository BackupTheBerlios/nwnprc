//::///////////////////////////////////////////////
//:: OnUnlock door eventscript
//:: prc_door_unlock
//:://////////////////////////////////////////////

#include "prc_alterations"
void main()
{
    ExecuteAllScriptsHookedToEvent(OBJECT_SELF, EVENT_DOOR_ONUNLOCK);
}