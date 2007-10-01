//////////////////////////////////////////////////
//  Disrupting Blow
//  tob_dmnd_drptb.nss
//  Tenjac  9/28/07
//////////////////////////////////////////////////
/** @file Disrupting Blow
Diamond Mind(Strike)
Level: Swordsage 5, warblade 5
Prerequisite: Two Diamond Mind maneuvers
Inititation Action: 1 standard action
Range: Melee attack
Target: One creature
Saving Throw: Will negates
Duration: 1 round

With a combination of brute force, keen timing, and exacting aim, you force your
opponent into an awkward position that ruins his next action.

As part of this maneuver, you make a melee attack. If this attack hits, your 
target takes normal melee damage and must make a Will save (DC 15 + your Str modifier)
or be unable to take any actions for 1 round. 
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
                PerformAttack(oTarget, oInitiator, 0.0, 0, 0, 0, "Disrupting Blow Hit", "Disrupting Blow Miss");
                
                if (GetLocalInt(oTarget, "PRCCombat_StruckByAttack"))
                {
                        int nDC = 15 + GetAbilityModifier(ABILITY_STRENGTH, oInitiator);
                        
                        // Saving Throw
                        if (!PRCMySavingThrow(SAVING_THROW_WILL, oTarget, nDC, oInitiator))
                        {
                                SPApplyEffectToObject(DURATION_TYPE_TEMPORARY, EffectDazed(), oTarget, RoundsToSeconds(1));
                        }
                }
        }
}
                                