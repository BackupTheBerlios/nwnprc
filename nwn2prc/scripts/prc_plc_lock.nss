//::///////////////////////////////////////////////
//:: OnLocked placeable eventscript
//:: prc_plc_lock
//:://////////////////////////////////////////////

#include "prc_alterations"
void main()
{
    ExecuteAllScriptsHookedToEvent(OBJECT_SELF, EVENT_PLACEABLE_ONLOCK);
}