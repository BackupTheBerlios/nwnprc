/*
   ----------------
   Share Pain, Forced
   
   prc_pow_shrpainf
   ----------------

   19/2/04 by Stratovarius

   Class: Psion/Wilder
   Power Level: 3
   Range: Short
   Target: One Creature
   Duration: 1 Round/level
   Saving Throw: Fort negates
   Power Resistance: Yes
   Power Point Cost: 5
   
   This power creates a psychometabolic connection between you and an unwilling subject so that some of your wounds
   are transferred to the subject. You take half damage from all attacks that deal hitpoint damage to you
   and the unwilling subject takes the remainder. 
   
   Augment: For every 2 additional power points spend, the DC increases by 1.
*/

#include "psi_inc_psifunc"

void main()
{
    UsePower(POWER_SHAREPAINFORCED, CLASS_TYPE_PSION);
}