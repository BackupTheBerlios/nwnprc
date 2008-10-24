/*
   ----------------
   Absolute Steel

   tob_irnh_abstl
   ----------------

   15/07/07 by Stratovarius
*/ /** @file

    Absolute Steel

    Iron Heart (Stance)
    Level: Warblade 3
    Prerequisite: One Iron Heart maneuver
    Initiation Action: 1 Swift Action
    Range: Personal
    Target: You
    Duration: Stance

    You shift your weight to the back of your feet and hold your blade carefully forward
    at the ready. Your muscles twitch slightly as you prepare to dodge the next attack you face.
    
    You gain a +10' movement speed bonus. If you move more than 10' in a round, you gain +2 AC.
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
       	effect eLink = EffectLinkEffects(EffectMovementSpeedIncrease(33), EffectVisualEffect(VFX_DUR_AIR2));
       	       eLink = ExtraordinaryEffect(eLink);
       	       
       	InitiatorMovementCheck(oInitiator, move.nMoveId);

       	ApplyEffectToObject(DURATION_TYPE_PERMANENT, eLink, oTarget);
    }
}