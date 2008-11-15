/*
   ----------------
   Disarming Strike

   tob_irnh_dsrmstk
   ----------------

   06/06/07 by Stratovarius
*/ /** @file

    Disarming Strike

    Iron Heart (Strike)
    Level: Warblade 2
    Initiation Action: 1 Standard Action
    Range: Melee Attack
    Target: One Creatures

    You chop at your foe's hand, causing a grievous injury
    and forcing him to drop his weapon.
    
    You make a single melee attack. If it is successful, you attempt
    to disarm the target. This will not work against creatures that cannot be disarmed.
*/

#include "tob_inc_move"
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
    	effect eNone;
    	object oWeap = GetItemInSlot(INVENTORY_SLOT_RIGHTHAND, oInitiator);
	DelayCommand(0.0, PerformAttack(oTarget, oInitiator, eNone, 0.0, 0, 0, 0,"Disarming Strike Hit", "Disarming Strike Miss"));
       
        if (GetLocalInt(oTarget, "PRCCombat_StruckByAttack") && GetIsCreatureDisarmable(oTarget))
    	{
    		int nAttack = GetAttackBonus(oTarget, oInitiator, oWeap) + d20();
    		int nTargAttack = GetAttackBonus(oInitiator, oTarget, GetItemInSlot(INVENTORY_SLOT_RIGHTHAND, oTarget)) + d20();
    		
    		if (nAttack >= nTargAttack)
    		{
    			// Drop the weapon
    			AssignCommand(oTarget, ClearAllActions(TRUE));
        		AssignCommand(oTarget, ActionPutDownItem(GetItemInSlot(INVENTORY_SLOT_RIGHTHAND, oTarget)));
    		}
    	}
    }
}