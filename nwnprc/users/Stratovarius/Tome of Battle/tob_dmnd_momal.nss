//////////////////////////////////////////////////
//  Moment of Alacrity
//  tob_dmnd_momal.nss
//  Tenjac  10/3/07
//////////////////////////////////////////////////
/** @file Moment of Alacrity
Diamond Mind(Boost)
Level: Swordsage 6, warblade 6
Prerequisite: Two Diamond Mind maneuvers
Initiation Action: 1 swift action
Range: Personal
Target: You
Duration: Instantaneous

You step into a space between heartbeats and act again while your enemies are still
reacting to your last strike.

You can improve your initiative count for the next round and all subsequent round of the 
current encounter. When you initiate this maneuver, your initiative count improves by 20,
and your place in the initiative order changes accordingly. This modifier applies at the
end of the round. Your place in the initiative order changes to reflect moment of alacrity's
effect starting with the next round.

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
                //probably a couple second timestop on self
                 effect eVis = EffectVisualEffect(VFX_FNF_TIME_STOP);
                 effect eTime = EffectTimeStop();
                 location lTarget = GetLocation(oInitiator);
                 if(GetPRCSwitch(PRC_TIMESTOP_LOCAL))
                 {
                         eTime = EffectAreaOfEffect(VFX_PER_NEW_TIMESTOP);
                         eTime = EffectLinkEffects(eTime, EffectEthereal());
                 }
                  
                 DelayCommand(0.75, SPApplyEffectToObject(DURATION_TYPE_TEMPORARY, eTime, oInitiator, fDuration,TRUE,-1,CasterLvl));
                 ApplyEffectAtLocation(DURATION_TYPE_INSTANT, eVis, lTarget);
         }
 }