//::///////////////////////////////////////////////
//:: OnClose door eventscript
//:: prc_door_close
//:://////////////////////////////////////////////

#include "prc_alterations"
void main()
{
    ExecuteAllScriptsHookedToEvent(OBJECT_SELF, EVENT_DOOR_ONCLOSE);
}