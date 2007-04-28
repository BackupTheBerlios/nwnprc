/*
   ----------------
   Stance of Clarity

   tob_dvsp_stnclr.nss
   ----------------

    29/03/07 by Stratovarius
*/ /** @file

    Stance of Clarity

    Diamond Mind (Stance)
    Level: Swordsage 1, Warblade 1
    Initiation Action: 1 Swift Action
    Range: Personal.
    Target: You.
    Duration: Stance.

    You focus your efforts on a single opponent, studying
    his moves and preparing an attack. Your other opponents
    fade from sight as your mind locks onto your target.
    
    You gain a +2 AC bonus against the highest CR creature in the area,
    and a -2 AC penalty against all other creatures attacking him.
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
	SPApplyEffectToObject(DURATION_TYPE_PERMANENT, ExtraordinaryEffect(EffectAreaOfEffect(AOE_PER_STANCE_OF_CLARITY)), oTarget);
    }
}