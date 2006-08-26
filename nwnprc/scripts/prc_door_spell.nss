//::///////////////////////////////////////////////
//:: OnSpellCastAt door eventscript
//:: prc_door_spell
//:://////////////////////////////////////////////

#include "prc_alterations"
void main()
{
    ExecuteAllScriptsHookedToEvent(OBJECT_SELF, EVENT_DOOR_ONSPELL);
}