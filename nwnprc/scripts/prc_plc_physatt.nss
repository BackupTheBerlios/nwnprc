//::///////////////////////////////////////////////
//:: OnPhysicalAttacked door eventscript
//:: prc_plc_physatt
//:://////////////////////////////////////////////

#include "prc_alterations"
void main()
{
    ExecuteAllScriptsHookedToEvent(OBJECT_SELF, EVENT_PLACEABLE_ONATTACKED);
}