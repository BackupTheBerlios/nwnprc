//::///////////////////////////////////////////////
//:: OnUsed placeable eventscript
//:: prc_plc_used
//:://////////////////////////////////////////////

#include "inc_eventhook"
void main()
{
    ExecuteAllScriptsHookedToEvent(OBJECT_SELF, EVENT_PLACEABLE_ONUSED);
}