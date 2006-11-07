//::///////////////////////////////////////////////
//:: OnDamaged door eventscript
//:: prc_door_damaged
//:://////////////////////////////////////////////

#include "prc_alterations"
void main()
{
    ExecuteAllScriptsHookedToEvent(OBJECT_SELF, EVENT_DOOR_ONDAMAGED);
}