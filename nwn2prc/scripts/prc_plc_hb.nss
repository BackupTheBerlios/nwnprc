//::///////////////////////////////////////////////
//:: OnHeartbeat placeable eventscript
//:: prc_plc_hb
//:://////////////////////////////////////////////

#include "prc_alterations"
void main()
{
    ExecuteAllScriptsHookedToEvent(OBJECT_SELF, EVENT_PLACEABLE_ONHEARTBEAT);
}