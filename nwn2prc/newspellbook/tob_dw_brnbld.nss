/*
   ----------------
   Burning Blade

   tob_dw_brnbld.nss
   ----------------

    28/03/07 by Stratovarius
*/ /** @file

    Burning Blade

    Desert Wind (Boost) [Fire]
    Level: Swordsage 1
    Initiation Action: 1 Swift Action
    Range: Personal.
    Target: You.
    Duration: 1 Round.

    Your blade bursts into flame as it sweeps towards your foe in an elegant arc.
    
    Your strikes deal 1d6 + Initiator level fire damage.
    This is a supernatural maneuver.
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
	DoDesertWindBoost(oInitiator);	
    }
}