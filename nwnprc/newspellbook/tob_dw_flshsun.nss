/*
    ----------------
    Flashing Sun

    tob_dw_flshsun.nss
    ----------------

    05/05/07 by Stratovarius
*/ /** @file

    Flashing Sun

    Desert Wind (Strike)
    Level: Swordsage 2
    Prerequisite: One Desert Wind maneuver
    Initiation Action: 1 Full-Round action
    Range: Personal
    Target: You

    Almost a blur of acceleration, your shining blade flashes
    as you attack with impossible speed.
    
    You take a full attack action, getting one additional attack at your highest attack bonus.
    All attacks are made at a -2 penalty.
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
	// Extra attack during the round
	effect eNone;
	PerformAttack(oTarget, oInitiator, eNone, 0.0, -2, 0, 0, "Flashing Sun Hit", "Flashing Sun Miss");
	PerformAttackRound(oTarget, oInitiator, eNone, 0.0, -2, 0, 0, FALSE, "Flashing Sun Hit", "Flashing Sun Miss");
    }
}