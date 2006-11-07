//::///////////////////////////////////////////////
//:: OnSpellCastAt door eventscript
//:: prc_plc_spell
//:://////////////////////////////////////////////

#include "prc_alterations"
void main()
{
    ExecuteAllScriptsHookedToEvent(OBJECT_SELF, EVENT_PLACEABLE_ONSPELL);
}