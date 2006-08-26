//::///////////////////////////////////////////////
//:: OnUserDefined placeable eventscript
//:: prc_plc_ud
//:://////////////////////////////////////////////

#include "prc_alterations"
void main()
{
    ExecuteAllScriptsHookedToEvent(OBJECT_SELF, EVENT_PLACEABLE_ONUSERDEFINED);
}