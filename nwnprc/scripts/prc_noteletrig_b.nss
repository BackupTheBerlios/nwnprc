//::///////////////////////////////////////////////
//:: No Teleport Trigger OnExit eventscript
//:: prc_noteletrig_b
//::///////////////////////////////////////////////
/** @file
    This file decreases the value of the
    PRC_DISABLE_CREATURE_TELEPORT local integer by
    one on the entering creature.
*/
//:://////////////////////////////////////////////
//:: Created By: Ornedan
//:: Created On: 02.07.2005
//:://////////////////////////////////////////////

#include "inc_utility"


void main()
{
    object oCreature = GetEnteringObject();
    // If the value reaches zero, delete the variable. No need for it to stick around sucking up resources.
    int nValue = GetLocalInt(oCreature, PRC_DISABLE_CREATURE_TELEPORT) - 1;
    if(nValue)
        SetLocalInt(oCreature, PRC_DISABLE_CREATURE_TELEPORT, nValue);
    else
        DeleteLocalInt(oCreature, PRC_DISABLE_CREATURE_TELEPORT);
}