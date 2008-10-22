//::///////////////////////////////////////////////
//:: OnUserDefined eventscript
//:: prc_onuserdef
//:://////////////////////////////////////////////
#include "prc_alterations"

void main()
{
    // Unlike normal, this is executed on OBJECT_SELF. Therefore, we have to first
    // check that the OBJECT_SELF is a creature.
    int nEvent = GetUserDefinedEventNumber();

    if(DEBUG) DoDebug("prc_onuserdef: " + IntToString(nEvent));

    if(GetObjectType(OBJECT_SELF) == OBJECT_TYPE_CREATURE)
    {
        switch(nEvent)
        {
            case EVENT_DAMAGED:
            {
                if(DEBUG) DoDebug("prc_onuserdef: EVENT_DAMAGED");
                ExecuteScript("prc_shield_other", OBJECT_SELF);
                break;
            }
        }
        ExecuteAllScriptsHookedToEvent(OBJECT_SELF, EVENT_ONUSERDEFINED);
    }
}
