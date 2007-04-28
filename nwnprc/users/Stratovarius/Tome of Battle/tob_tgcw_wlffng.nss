/*
    ----------------
    Wolf Fang Strike

    tob_tgcw_wlffng.nss
    ----------------

    27/04/07 by Stratovarius
*/ /** @file

    Wolf Fang Strike

    Tiger Claw (Strike)
    Level: Swordsage 1, Warblade 1
    Initiation Action: 1 Standard Action
    Range: Melee Attack
    Target: One Creature

    You lash out in a blur of movement with two weapons, 
    hacking into your foe with a combination of feral strength and speed.
    
    You must fight with two weapons to use this maneuver. 
*/

#include "tob_inc_tobfunc"
#include "tob_movehook"
#include "prc_alterations"

void main()
{
    if (!PreManeuverCastCode())
    {
    // If code within the PreManeuverCastCode (i.e. UMD) reports FALSE, do not run this spell
        return;
    }

// End of Spell Cast Hook

    object oInitiator    = OBJECT_SELF;
    object oTarget       = PRCGetSpellTargetObject();
    struct maneuver move = EvaluateManeuver(oInitiator, oTarget);

    if(move.bCanManeuver)
    {
    	object oItem = GetItemInSlot(INVENTORY_SLOT_RIGHTHAND, oInitiator);
    	object oItem2 = GetItemInSlot(INVENTORY_SLOT_LEFTHAND, oInitiator);
    	
	if (IPGetIsMeleeWeapon(oItem) && IPGetIsMeleeWeapon(oItem2))
    	{
    		// Perform two attacks, overriding either weapon just to make sure
    		PerformAttack(oTarget, oInitiator, eNone, 0.0, -2, 0, 0, "Wolf Fang Strike Hit", "Wolf Fang Strike Miss", FALSE, oItem);
    		PerformAttack(oTarget, oInitiator, eNone, 0.0, -2, 0, 0, "Wolf Fang Strike Hit", "Wolf Fang Strike Miss", FALSE, oItem2);
        }
        else
        	FloatingTextStringOnCreature("You must have two melee weapons equipped to use this maneuver", oInitiator, FALSE);
    }
}