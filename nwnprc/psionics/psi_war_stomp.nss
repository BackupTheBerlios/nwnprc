/*
   ----------------
   Stomp
   
   prc_all_stomp
   ----------------

   28/10/04 by Stratovarius

   Class: Psychic Warrior
   Power Level: 1
   Range: Short
   Target: 20' Cone
   Duration: Instantaneous
   Saving Throw: Reflex negates
   Power Resistance: No
   Power Point Cost: 1
   
   Your stomp precipitates a psychokinetic shockwave that travels along the ground, toppling creatures.
   Creatures that fail their save are knocked down and take 1d4 points of bludgeoning damage.
   
   Augment: For every additional power point spent, this power's damage increases by 1d4. 
*/

#include "psi_inc_psifunc"

void main()
{
    UsePower(POWER_STOMP, CLASS_TYPE_PSYWAR);
}