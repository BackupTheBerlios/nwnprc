/*
   ----------------
   Mind Trap
   
   prc_pow_mindtrap
   ----------------

   17/2/05 by Stratovarius

   Class: Psion/Wilder
   Power Level: 3
   Range: Personal
   Target: Self
   Duration: 1 Round/level
   Saving Throw: None
   Power Resistance: No
   Power Point Cost: 5
   
   You set up a trap in your mind against psionic intruders. Anyone who attacks you with a telepathy power immediately loses
   1d6 power points. This does not negate the power being cast.
   
   Augment: For every additional power point spent, the duration increases by 1 round.
*/

#include "psi_inc_psifunc"

void main()
{
    UsePower(POWER_MINDTRAP, CLASS_TYPE_PSION);
}