//::///////////////////////////////////////////////
//:: [Powerful Charge]
//:: [avar_dive.nss]
//:://////////////////////////////////////////////
/*
    
*/
//:://////////////////////////////////////////////
//:: Created By: WodahsEht
//:: Created On: Oct. 3, 2004
//:://////////////////////////////////////////////

#include "prc_inc_combat"
#include "prc_inc_util"
#include "prc_inc_skills"

void main()
{
    object oPC = OBJECT_SELF;
    object oTarget = GetSpellTargetObject();
    object oWeap = GetItemInSlot(INVENTORY_SLOT_RIGHTHAND, OBJECT_SELF);
    
    if(oTarget == OBJECT_INVALID)
    {
       FloatingTextStringOnCreature("Invalid Target for Powerful Charge", oPC);
       return;
    }
    
    float fDistance = GetDistanceBetweenLocations(GetLocation(oPC), GetLocation(oTarget) );
    
    // PnP rules use feet, might as well convert it now.
    fDistance = MetersToFeet(fDistance);
    if(fDistance >= 7.0 )
    {
        FloatingTextStringOnCreature("Powerful Charge not yet implemented", oPC);
    }
    else
    {
        FloatingTextStringOnCreature("Too close for Powerful Charge", oPC);
    }
}
