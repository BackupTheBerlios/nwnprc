/*
   ----------------
   Deceleration
   
   prc_all_decel
   ----------------

   25/10/04 by Stratovarius

   Class: Psion/Wilder
   Power Level: 1
   Range: Short
   Target: One Medium or smaller Creature
   Duration: 1 Min/level
   Saving Throw: Reflex negates
   Power Resistance: Yes
   Power Point Cost: 1
   
   You warp space around an individual, hindering the subject's ability
   to move. The subjects speed is halved.
   
   Augment: For every 2 additional power points spent, this power can affect a target
   that is one size larger.
*/

#include "psi_inc_psifunc"

void main()
{
    UsePower(POWER_DECELERATION, CLASS_TYPE_PSION);
}