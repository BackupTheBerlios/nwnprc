/*
   ----------------
   Empathic Transfer, Hostile
   
   psi_pow_emptrnh
   ----------------

   19/4/05 by Stratovarius

   Class: Psion (Telepath)
   Power Level: 3
   Range: Touch
   Target: One Creature
   Duration: Instantaneous
   Saving Throw: Will partial
   Power Resistance: Yes
   Power Point Cost: 5
   
   You transfer your hurt to another. When you manifest this power and make a successful touch attack, you transfer up to 50 points
   of damage from yourself to the touched creature. You regain hitpoints equal to the amount transferred. You cannot exceed your 
   maximum total hitpoints through use of this power. 
   
   Augment: For every additional power point spent, you can transfer an additional 10 points of damage (maximum of 90)
*/

#include "psi_inc_psifunc"

void main()
{
    UsePower(POWER_EMPATHICTRANSFERHOSTILE, CLASS_TYPE_PSION);
}