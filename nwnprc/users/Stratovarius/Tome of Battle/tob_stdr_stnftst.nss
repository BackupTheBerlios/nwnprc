/*
   ----------------
   Stonefoot Stance

   tob_stdr_stnftst
   ----------------

   23/03/07 by Stratovarius
*/ /** @file

    Stonefoot Stance

    Stone Dragon (Stance)
    Level: Crusader 1, Swordsage 1, Warblade 1
    Initiation Action: 1 Swift Action
    Range: Personal
    Target: You
    Duration: Stance

    You crouch and set your feet flat on the ground, drawing 
    the resilience of the earth into your body.
    
    You gain a +2 bonus on Strength checks, and a +2 AC bonus against creatures larger than you.
    This stance ends if you move more than 5 feet for any reason.
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
       	effect eLink =                          VersusSizeEffect(oInitiator, EffectACIncrease(2), 1);
       	       eLink = EffectLinkEffects(eLink, EffectVisualEffect(VFX_DUR_ROOTED_TO_SPOT));
       	       
       	InitiatorMovementCheck(oInitiator, move.nSpellId);

       	ApplyEffectToObject(DURATION_TYPE_PERMANENT, eLink, oInitiator);
    }
}