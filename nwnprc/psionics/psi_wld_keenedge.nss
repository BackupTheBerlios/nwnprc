/*
   ----------------
   Keen Edge
   
   prc_pow_keenedge
   ----------------

   17/2/05 by Stratovarius

   Class: Psion/Wilder, Psychic Warrior
   Power Level: 3
   Range: Short
   Target: One Weapon
   Duration: 10 Min/level
   Saving Throw: None
   Power Resistance: No
   Power Point Cost: 5
   
   You mentally sharpen the edge of your weapon, granting it the keen property. This only works on piercing or slashing weapons.
*/

#include "psi_inc_psifunc"

void main()
{
    UsePower(POWER_KEENEDGE, CLASS_TYPE_WILDER);
}