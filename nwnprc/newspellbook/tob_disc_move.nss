/*
   ----------------
   Generic Maneuver

   tob_disc_move.nss
   ----------------

   26/03/07 by Stratovarius
*/ /** @file

    Generic Maneuver

    Discipline (Strike, Boost, Counter, or Stance)
    Level: Crusader 1, Swordsage 1, Warblade 1
    Initiation Action: 1 Standard/Swift/Full-Round Action
    Range: 
    Target: 
    Duration:

    Flavour Text
    
    Mechanical abilities
*/

#include "tob_inc_move"
#include "tob_movehook"


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
    	// This section is for a strike, change for a boost or counter
    	effect eNone;
	PerformAttack(oTarget, oInitiator, eNone);
	if (GetLocalInt(oTarget, "PRCCombat_StruckByAttack"))
    	{
        	// Apply effects in here
        }
    }
}