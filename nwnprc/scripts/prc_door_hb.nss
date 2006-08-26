//::///////////////////////////////////////////////
//:: Onheartbeat door eventscript
//:: prc_door_hb
//:://////////////////////////////////////////////

#include "prc_alterations"
void main()
{
    ExecuteAllScriptsHookedToEvent(OBJECT_SELF, EVENT_DOOR_ONHEARTBEAT);
}