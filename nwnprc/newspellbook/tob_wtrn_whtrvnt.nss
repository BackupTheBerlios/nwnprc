/*
   ----------------
   White Raven Tactics

   tob_wtrn_whtrvnt.nss
   ----------------

    18/08/07 by Stratovarius
*/ /** @file

    White Raven Tactics

    Iron Heart (Boost)
    Level: Crusader 3, Warblade 3
    Initiation Action: 1 Swift Action
    Range: 10 ft.
    Target: One ally

    You can inspire your allies to astounding feats of martial prowess
    With a few short orders, you cajole them into seizing the initiative
    and driving back the enemy.
    
    Your ally gets to go again this turn. You cannot target yourself with this maneuver.
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
	ApplyEffectToObject(DURATION_TYPE_TEMPORARY, EffectTimeStop(), oTarget, 6.0);
    }
}