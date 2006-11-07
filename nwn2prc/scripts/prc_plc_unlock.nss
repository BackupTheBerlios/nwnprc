//::///////////////////////////////////////////////
//:: OnUnocked placeable eventscript
//:: prc_plc_unlock
//:://////////////////////////////////////////////

#include "prc_alterations"
void main()
{
    ExecuteAllScriptsHookedToEvent(OBJECT_SELF, EVENT_PLACEABLE_ONUNLOCK);
}