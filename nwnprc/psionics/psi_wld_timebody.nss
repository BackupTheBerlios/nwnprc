/*
   ----------------
   Timeless Body
   
   prc_pow_timebody
   ----------------

   26/2/05 by Stratovarius

   Class: Psion/Wilder
   Power Level: 9
   Range: Personal
   Target: Self
   Duration: 1 Round
   Saving Throw: None
   Power Resistance: No
   Power Point Cost: 17
   
   Your body ignores all harmful effects, making you invulnerable to all spells, powers, damage, or any other damaging effect.
*/

#include "psi_inc_psifunc"

void main()
{
    UsePower(POWER_TIMELESSBODY, CLASS_TYPE_WILDER);
}