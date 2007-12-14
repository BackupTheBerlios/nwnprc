//////////////////////////////////////////////////
// One With Shadow
// tob_sdhd_owshad.nss
// Tenjac   12/14/07
//////////////////////////////////////////////////
/** @file One With Shadow
Shadow Hand (Counter)
Level: Swordsage 8
Prerequisite: Three Shadow Hand maneuvers
Initiation Action: 1 immediate action
Range: Personal
Target: You
Duration: See text

You fade into the raw essence of shadow, turning transparent, then insubstantial.

As an immediate action, you become incorporeal. You gain all the benefits of the incorporeal subtype, along with 
the drawbacks, as outlined in the Incorporeal Subtype sidebar. All of your gear becomes incorporeal, although you 
cannot grant this state to a living creature that you touch or carry. You remain incorporeal until the beginning
of your next turn.

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
               effect eInc = EffectIncorporeal();
               object oSkin = GetPCSkin(oTarget);
               
               SPApplyEffectToObject(DURATION_TYPE_TEMPORARY, eInc, oTarget, 6.0);           
               itemproperty ipIncorp = PRCItemPropertyBonusFeat(FEAT_INCORPOREAL);
               AddItemProperty(DURATION_TYPE_TEMPORARY, ipIncorp, oSkin, 6.0);                
       }
}