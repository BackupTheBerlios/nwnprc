/*
   ----------------
   Elf Sight
   
   prc_all_elfsight
   ----------------

   6/11/04 by Stratovarius

   Class: Psion/Wilder, Psychic Warrior
   Power Level: Psion/Wilder 2, Psychic Warrior 1
   Range: Personal
   Target: Self
   Duration: 1 Hour/level
   Saving Throw: None
   Power Resistance: No
   Power Point Cost: Psion/Wilder 3, Psychic Warrior 1
   
   When you manifest this power, you gain a +2 bonus to spot and search, and gain low light
   vision as an elf.
*/

#include "psi_inc_psifunc"

void main()
{
    UsePower(POWER_ELFSIGHT, CLASS_TYPE_PSYWAR);
}
