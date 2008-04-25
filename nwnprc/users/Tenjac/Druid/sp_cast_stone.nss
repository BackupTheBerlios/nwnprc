////////////////////////////////////////////////////
//  Cast In Stone
//  sp_cast_stone.nss
////////////////////////////////////////////////////
/** @file Cast In Stone
Transmutation
Level: Druid 9
Components: V, S
Casting Time: 1 standard action
Range: Personal
Target: You
Duration: 1 round/level (D)
Saving Throw: None and Fortitude negates; see text
Spell Resistance: No

Any creature within 30 feet that meets
your gaze is permanently turned into a
mindless, inert statue (as flesh to stone),
unless it succeeds on a Fortitude save.

Each creature within range of the
gaze must attempt a saving throw
against the gaze effect each round at
the beginning of its turn. A creature
can avert its eyes, which grants a 50%
chance to avoid the gaze but in turn
grants you concealment relative to it.
A creature can close its eyes or turn
away entirely; doing so prevents the
gaze from affecting it but grants you
total concealment from that creature.
In addition, you can actively attempt
to use the gaze as a standard action each
round. To do so, you choose a target
within range, and that target must
attempt a saving throw. A target that is
averting or shutting its eyes gains the
above benefits.
*/
//////////////////////////////////////////////////
//  Tenjac   10/1/07
//////////////////////////////////////////////////

#include "prc_inc_spells"

void main()
{
        object oPC = OBJECT_SELF;
        location lLoc = GetSpellTargetLocation();
        object oTarget = MyFirstObjectInShape(SHAPE_CONE, FeetToMeters(30.0), lLoc, TRUE, OBJECT_TYPE_CREATURE);
        
        