//::///////////////////////////////////////////////
//:: OnOpened door eventscript
//:: prc_plc_open
//:://////////////////////////////////////////////

#include "prc_alterations"
void main()
{
    ExecuteAllScriptsHookedToEvent(OBJECT_SELF, EVENT_PLACEABLE_ONOPEN);
}