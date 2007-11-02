//////////////////////////////////////////////////
//  Pouncing Charge
//  tob_tgcw_pouncc.nss
//  Tenjac   10/19/07
//////////////////////////////////////////////////
/** @file Pouncing Charge
Tiger Claw (Strike)
Level: Swordsage 5, warblade 5
Prerequisite: Two Tiger Claw maneuvers
Initiation Action: 1 full-round action
Range: Personal
Target: You

With the roar of a wild beast, you throw yourself into the fray. Your weapons are little
more than a blur as you hack at your foe with feral speed.

With a ferocious howl, you throw yourself into combat. You move with such speed and 
ferocity that when you reach your enemy, you unleash a blistering flurry of slashes, cuts,
and hacks.

As part of initiating this maneuver, you make a charge attack. Instead of making a single
attack at the end of your charge, you can make a full attack. The bonus on your attack 
roll for making a charge attack applies to all your attack rolls.
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