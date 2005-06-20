//:://////////////////////////////////////////////
//:: Generic Listener object OnHearbeat script
//:: prc_glist_onhb
//:://////////////////////////////////////////////
/** @file
    The generic listener object's heartbeat script.
    If the listener is listening to a single object,
    makes sure the target is still a valid object.
    If it isn't, the listener deletes itself.
    
    If the listener is listening at a location,
    returns the listener to that location if it had moved.
*/
//:://////////////////////////////////////////////
//:: Created By: Ornedan
//:: Created On: 19.06.2005
//:://////////////////////////////////////////////

#include "prc_inc_listener"
#include "inc_debug"

void main()
{
    // Check if we are listening to a single creature or an area
    if(GetLocalInt(OBJECT_SELF, "PRC_GenericListener_ListenToSingle"))
    {
        object oListeningTo = GetLocalObject(OBJECT_SELF, "PRC_GenericListener_ListeningTo");
        if(!GetIsObjectValid(oListeningTo))
            DestroyListener(OBJECT_SELF);

        DoDebug("Listener distance to listened: " + FloatToString(GetDistanceBetween(OBJECT_SELF, oListeningTo))
                + ". In the same area: " + (GetArea(OBJECT_SELF) == GetArea(oListeningTo) ? "TRUE":"FALSE"));
    }
    // An area. Just make sure the listener stays there
    else
    {
        if(GetLocation(OBJECT_SELF) != GetLocalLocation(OBJECT_SELF, "PRC_GenericListener_ListeningLocation"))
            AssignCommand(OBJECT_SELF, JumpToLocation(GetLocalLocation(OBJECT_SELF, "PRC_GenericListener_ListeningLocation")));
    }
}