/*
   ----------------
   Thicken Skin
   
   prc_all_thickskn
   ----------------

   28/10/04 by Stratovarius

   Class: Psion (Egoist), Psychic Warrior
   Power Level: 1
   Range: Personal
   Target: Self
   Duration: 10 Min/level
   Saving Throw: None
   Power Resistance: No
   Power Point Cost: 1
   
   Your skin thickens and spreads across your body, providing a +1 bonus to your armour class.
   
   Augment: For every 3 additional power points you spend, the AC bonus improves by 1.
*/

#include "psi_inc_psifunc"

void main()
{
    UsePower(POWER_THICKSKIN, CLASS_TYPE_PSYWAR);
}