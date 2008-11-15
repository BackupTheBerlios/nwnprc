///////////////////////////////////////////////////
// Dancing Mongoose
// tob_tgcw_dncmon.nss
///////////////////////////////////////////////////
/** @file Dancing Mongoose
Tiger Claw(Boost)
Level: Swordsage 5, warblade 5
Prerequisite: Two Tiger Claw maneuvers
Initiation Action: 1 swift action
Range: Personal
Target: You
Duration: 1 turn

You sing your weapons about you in a blur of speed, making a series of
devastating attacks in the space of a single breath.

You make a flurry of deadly attacks. After initiating this boost, you 
can make one additional attack with each weapon you wield (to a maximim of 
two extra attacks if you wield two or more weapons). These extra attacks
are made at your highest attack bonus for each of your repective weapons.
All of these attacks mus be directed against the same opponent.
*/
//////////////////////////////////////////////////////
//  Tenjac   10/4/07
///////////////////////////////////////////////////////

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
        effect eNone;
        
        if(move.bCanManeuver)
        {
                //Normal attacks
                DelayCommand(0.0, PerformAttackRound(oTarget, oInitiator, eNone));
                
                DelayCommand(0.0, PerformAttack(oTarget, oInitiator, eNone, 0.0, 0, 0, 0, "Dancing Mongoose Hit", "Dancing Mongoose Miss"));
                
                object oOffHand = GetItemInSlot(INVENTORY_SLOT_LEFTHAND, oInitiator);
                
                if(IPGetIsMeleeWeapon(oOffHand))
                {
                        DelayCommand(0.0, PerformAttack(oTarget, oInitiator, eNone, 0.0, 0, 0, 0, "Dancing Mongoose Hit", "Dancing Mongoose Miss", FALSE, OBJECT_INVALID, oOffHand, TRUE));
                }
        }
}
                        