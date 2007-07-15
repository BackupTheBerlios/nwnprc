/*
   ----------------
   Assassin's Stance

   tob_sdhd_assassn
   ----------------

   15/07/07 by Stratovarius
*/ /** @file

    Assassin's Stance

    Shadow Hand (Stance)
    Level: Swordsage 3
    Prerequisite: One Shadow Hand maneuver.
    Initiation Action: 1 Swift Action
    Range: Personal.
    Target: You
    Duration: Stance

    As your foe struggles to regain his defensive posture, you line up an exacting strike
    that hits with superior accuracy and deadly force.
    
    You gain +2d6 Sneak Attack.
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
       	effect 	eLink = EffectVisualEffect(PSI_DUR_SHADOW_BODY));

       	ApplyEffectToObject(DURATION_TYPE_PERMANENT, eLink, oTarget);
       	DelayCommand(1.0, ExecuteScript("prc_sneak_att", oInitiator));
    }
}

