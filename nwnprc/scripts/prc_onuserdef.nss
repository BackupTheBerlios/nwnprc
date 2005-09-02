//::///////////////////////////////////////////////
//:: OnUserDefined eventscript
//:: prc_onuserdef
//:://////////////////////////////////////////////
#include "prc_alterations"
#include "inc_eventhook"

void main()
{
    // Unlike normal, this is executed on OBJECT_SELF. Therefore, we have to first
    // check that the OBJECT_SELF is a creature.
    if(GetObjectType(OBJECT_SELF) == OBJECT_TYPE_CREATURE)
        ExecuteAllScriptsHookedToEvent(OBJECT_SELF, EVENT_ONUSERDEFINED);
}
