//::///////////////////////////////////////////////
//:: OnDisturbed placeable eventscript
//:: prc_plc_disturb
//:://////////////////////////////////////////////

#include "prc_alterations"
void main()
{
    ExecuteAllScriptsHookedToEvent(OBJECT_SELF, EVENT_PLACEABLE_ONDISTURBED);
}