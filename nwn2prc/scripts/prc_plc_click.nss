//::///////////////////////////////////////////////
//:: OnClick placeable eventscript
//:: prc_plc_click
//:://////////////////////////////////////////////

#include "prc_alterations"
void main()
{
    ExecuteAllScriptsHookedToEvent(OBJECT_SELF, EVENT_PLACEABLE_ONCLICK);
}