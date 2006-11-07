//::///////////////////////////////////////////////
//:: OnDeath placeable eventscript
//:: prc_plc_death
//:://////////////////////////////////////////////

#include "prc_alterations"
void main()
{
    ExecuteAllScriptsHookedToEvent(OBJECT_SELF, EVENT_PLACEABLE_ONDEATH);
}