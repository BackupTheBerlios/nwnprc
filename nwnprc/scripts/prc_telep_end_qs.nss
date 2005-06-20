//::///////////////////////////////////////////////
//:: Teleport System - Clear Quickselection
//:: prc_telep_end_qs
//::///////////////////////////////////////////////
/** @file
    This featscript deactivates the user's teleport
    target location quickselection by deleting the
    variable it is stored in.
*/
//:://////////////////////////////////////////////
//:: Created By: Ornedan
//:: Created On: 31.05.2005
//:://////////////////////////////////////////////

#include "inc_metalocation"

void main()
{
    object oPC = OBJECT_SELF;

    // Clear the quickselection
    DeleteLocalInt(oPC, "PRC_Teleport_Quickselection");
    DeleteLocalMetalocation(oPC, "PRC_Teleport_Quickselection");
    
    SendMessageToPCByStrRef(oPC, 16825291); // "Teleport quickselection deactivated"
}