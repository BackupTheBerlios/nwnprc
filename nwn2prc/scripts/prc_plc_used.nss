//::///////////////////////////////////////////////
//:: OnUsed placeable eventscript
//:: prc_plc_used
//:://////////////////////////////////////////////

#include "prc_alterations"
void main()
{
    ExecuteAllScriptsHookedToEvent(OBJECT_SELF, EVENT_PLACEABLE_ONUSED);
}