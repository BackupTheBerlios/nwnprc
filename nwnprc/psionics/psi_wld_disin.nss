/*
   ----------------
   Disintegrate
   
   prc_all_disin
   ----------------

   27/10/04 by Stratovarius

   Class: Psion/Wilder
   Power Level: 6
   Range: Long
   Target: One Creature
   Duration: Instantaneous
   Saving Throw: Fortitude partial
   Power Resistance: Yes
   Power Point Cost: 11
   
   A thin ray springs from your fingers at the target. You must succeed on a ranged touch attack
   to deal damage to the target. The ray deals 22d6 points of damage.
   
   Augment: For every additional power point spend, the target takes an additional
   2d6 points of damage if it fails its save.
*/

#include "psi_inc_psifunc"

void main()
{
    UsePower(POWER_DISINTEGRATE, CLASS_TYPE_WILDER);
}