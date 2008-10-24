//////////////////////////////////////////////////
// Hamstring Attack
// tob_tgcw_hamstr.nss
// Tenjac  10/17/07
//////////////////////////////////////////////////
/** @file Hamstring Attack
Tiger Claw (Strike)
Level: Swordsage 7, warblade 7
Prerequisite: Three Tiger Claw maneuvers
Initiation Action: 1 standard action
Range: Melee attack
Target: One creature
Saving Throw: Fortitude half
Duration: 1 minute

You slice into your opponent's legs, leaving him hobbled and stumbling about.

As part of this maneuver, you make a single melee attack. If this attack hits, it deals damage as
normal. In addition, the target takes 1d8 points of Dexterity damage and a -10 foot penalty to
speed for 1 minute. A successful Fortitude save (DC 17 + your Str modifier) halves both the 
Dexterity damage and the speed penalty.
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
        effect eNone;
        
        if(move.bCanManeuver)
        {
        	int nBonus = TOBSituationalAttackBonuses(oInitiator, DISCIPLINE_TIGER_CLAW);
                PerformAttack(oTarget, oInitiator, eNone, 0.0, nBonus, 0, 0, "Hamstring Attack Hit", "Hamstring Attack Miss");
                
                if (GetLocalInt(oTarget, "PRCCombat_StruckByAttack"))
                {
                        int nDexDam = d8(1);
                        effect eSlow = EffectMovementSpeedDecrease(33);
                        
                        //Save
                        if(PRCMySavingThrow(SAVING_THROW_FORT, oTarget, (17 + GetAbilityModifier(ABILITY_STRENGTH, oInitiator)), SAVING_THROW_TYPE_NONE))
                        {                                
                                nDexDam = nDexDam/2;
                                eSlow = EffectMovementSpeedDecrease(17);
                        }
                        
                        ApplyAbilityDamage(oInitiator, ABILITY_CONSTITUTION, nDexDam, DURATION_TYPE_PERMANENT);
                        SPApplyEffectToObject(DURATION_TYPE_TEMPORARY, eSlow, oTarget, TurnsToSeconds(1));
                }
        }
}