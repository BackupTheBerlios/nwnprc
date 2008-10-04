/*
   ----------------
   Bloodclaw Master Pouncing Charge

   tob_bldclw_pnce.nss
   ----------------

    3/10/08 by Stratovarius
*/ /** @file
  
    You charge your foe, but instead of performing a single attack at the end of the charge,
    you perform a full attack. You also expend a maneuver
*/

#include "tob_inc_tobfunc"
#include "tob_movehook"
#include "prc_alterations"

void main()
{

    object oInitiator    = OBJECT_SELF;
    object oTarget       = PRCGetSpellTargetObject();

    // Expend a maneuver to do the charge
    if(ExpendRandomManeuver(oInitiator, GetFirstBladeMagicClass(oInitiator), DISCIPLINE_TIGER_CLAW) && 
       GetIsDisciplineWeapon(GetItemInSlot(INVENTORY_SLOT_LEFTHAND, oInitiator), DISCIPLINE_TIGER_CLAW))
    {
    	// Yup, thats it.
	DoCharge(oInitiator, oTarget, TRUE, TRUE, 0, -1, FALSE, 0, FALSE, FALSE, 0, TRUE);
    }
}