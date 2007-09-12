//////////////////////////////////////////////////
// Mountain Avalanche
// Stone Dragon (Strike)
// tob_stdr_mtavaln.nss
//////////////////////////////////////////////////
/** @file Mountain Avalanche
Stone Dragon (Strike)
Level: Crusader 5, swordsage 5, warblade 5
Prerequisite: Two Stone Dragon maneuvers
Initiation Action: 1 full-round action
Range: Personal
Target: You
Saving Throw: Reflex half; see text

You wade through your enemies like a stone giant rampaging through a mob of orcs.
You crush them underfoot and drive them before you, leaving a trail of the dead in
your wake.

As part of this maneuver, you can move up to double your speed and trample your 
opponents. You can enter the space of any creature of your size category or smaller.
If you enter and occupy all of the space occupied by such a creature, it takes 
damage equal to 2d6 + 1 1/2 times your Str bonus (if any).

You can deal trampling damage to a creature only once per round, no matter how many
times you move into or through its space. You must move into every square a creature
occupies to trample it. If you mover over only part of the space a creature occupies, 
it can either attempt an attack of opportunity against you or it can attempt a Reflex 
save (DC 15 = your Str modifier) to avoid half of your trampling damage.

 <Stratovarius> I'd make it basically a long line effect
 <Stratovarius> Use the inc_draw stuff
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