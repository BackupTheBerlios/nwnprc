//::///////////////////////////////////////////////
//:: OnPhysicalAttacked door eventscript
//:: prc_door_phyatt
//:://////////////////////////////////////////////

#include "prc_alterations"
void main()
{
    ExecuteAllScriptsHookedToEvent(OBJECT_SELF, EVENT_DOOR_ONATTACKED);
}