/*
   ----------------
   Distract
   
   prc_all_distract
   ----------------

   25/10/04 by Stratovarius

   Class: Psion/Wilder, Psychic Warrior
   Power Level: 1
   Range: Short
   Target: One Creature
   Duration: 1 Min/level
   Saving Throw: Will negates
   Power Resistance: Yes
   Power Point Cost: 1
   
   You cause your subjects mind to wander, applying a -4 penalty to Spot, Search, and Listen.
*/

#include "psi_inc_psifunc"

void main()
{
    UsePower(POWER_DISTRACT, CLASS_TYPE_WILDER);
}