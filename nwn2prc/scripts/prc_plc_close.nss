//::///////////////////////////////////////////////
//:: OnClose placeable eventscript
//:: prc_plc_close
//:://////////////////////////////////////////////

#include "prc_alterations"
void main()
{
    ExecuteAllScriptsHookedToEvent(OBJECT_SELF, EVENT_PLACEABLE_ONCLOSE);
}