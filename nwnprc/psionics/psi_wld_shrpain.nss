/*
   ----------------
   Share Pain
   
   prc_pow_shrpain
   ----------------

   19/2/04 by Stratovarius

   Class: Psion/Wilder
   Power Level: 2
   Range: Touch
   Target: One Willing Creature
   Duration: 1 Hour/level
   Saving Throw: None
   Power Resistance: No
   Power Point Cost: 3
   
   This power creates a psychometabolic connection between you and a willing subject so that some of your wounds
   are transferred to the subject. You take half damage from all attacks that deal hitpoint damage to you
   and the willing subject takes the remainder. 
*/

#include "psi_inc_psifunc"

void main()
{
    UsePower(POWER_SHAREPAIN, CLASS_TYPE_WILDER);
}