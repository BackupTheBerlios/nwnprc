/*
   ----------------
   Temporal Acceleration
   
   prc_pow_tempacc
   ----------------

   27/3/05 by Stratovarius

   Class: Psion/Wilder
   Power Level: 6
   Range: Personal
   Target: Caster
   Duration: 1 Round
   Saving Throw: None
   Power Resistance: No
   Power Point Cost: 11
   
   You enter another time frame, speeding up so greatly that all other creatures seem frozen, though they are still actually 
   moving at normal speed. You are free to act for 1 round of apparent time. This is an instant power.
   
   Augment: For every 4 additional power points spent, the duration increases by 1 round.
*/

#include "psi_inc_psifunc"

void main()
{
    UsePower(POWER_TEMPORALACCELERATION, CLASS_TYPE_PSION);
}