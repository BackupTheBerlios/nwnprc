/*
   ----------------
   Inertial Armour
   
   prc_all_inertarm
   ----------------

   28/10/04 by Stratovarius

   Class: Psion/Wilder, Psychic Warrior
   Power Level: 1
   Range: Personal
   Target: Self
   Duration: 1 Hour/level
   Saving Throw: None
   Power Resistance: No
   Power Point Cost: 1
   
   Your mind generates a tangible field of force that provides a +4 bonus to AC.
   This bonus does not stack with that provided by armour enchantments.
   
   Augment: For every 2 additional power points you spend, the AC bonus improves by 1.
*/

#include "psi_inc_psifunc"

void main()
{
    UsePower(POWER_INERTIALARMOUR, CLASS_TYPE_PSYWAR);
}