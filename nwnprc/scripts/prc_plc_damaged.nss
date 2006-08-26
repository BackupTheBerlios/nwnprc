//::///////////////////////////////////////////////
//:: OnDamaged placeable eventscript
//:: prc_plc_damaged
//:://////////////////////////////////////////////

#include "prc_alterations"
void main()
{
    ExecuteAllScriptsHookedToEvent(OBJECT_SELF, EVENT_PLACEABLE_ONDAMAGED);
}