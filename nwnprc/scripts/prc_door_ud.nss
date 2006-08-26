//::///////////////////////////////////////////////
//:: OnUserDefined door eventscript
//:: prc_door_ud
//:://////////////////////////////////////////////

#include "prc_alterations"
void main()
{
    ExecuteAllScriptsHookedToEvent(OBJECT_SELF, EVENT_DOOR_ONUSERDEFINED);
}