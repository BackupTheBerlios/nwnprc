/*
   ----------------
   Fuse Flesh
   
   prc_pow_fuseflsh
   ----------------

   24/2/05 by Stratovarius

   Class: Psion/Wilder
   Power Level: 6
   Range: Touch
   Target: One Creature
   Duration: 1 Round/level
   Saving Throw: Fortitude Negates, Fortitude Partial
   Power Resistance: Yes
   Power Point Cost: 11
   
   You cause the victims flesh to ripple, grow together, and fuse into a nearly seamless whole, paralyzing the creature. If the target fails its
   saving throw, it must attempt another fortitude save or be blinded and deafened for the duration of the power.
   
   Augment: For every 2 additional power points spent, this power's DC increases by 1.
*/

#include "psi_inc_psifunc"

void main()
{
    UsePower(POWER_FUSEFLESH, CLASS_TYPE_WILDER);
}