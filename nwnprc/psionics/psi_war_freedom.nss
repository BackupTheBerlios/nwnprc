/*
   ----------------
   Freedom of Movement
   
   prc_pow_freedom
   ----------------

   19/2/04 by Stratovarius

   Class: Psion/Wilder, Psychic Warrior
   Power Level: 4
   Range: Personal
   Target: Self
   Duration: 10 Min/level
   Saving Throw: None
   Power Resistance: No
   Power Point Cost: 7
   
   When you manifest this power, you may move as normal, even under the influence of magic
   that would normally impede movement.
*/

#include "psi_inc_psifunc"

void main()
{
    UsePower(POWER_FREEDOM, CLASS_TYPE_PSYWAR);
}