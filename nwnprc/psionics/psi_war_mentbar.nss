/*
   ----------------
   Mental Barrier
   
   prc_pow_mentbar
   ----------------

   17/2/05 by Stratovarius

   Class: Psion/Wilder, Psychic Warrior
   Power Level: 3
   Range: Personal
   Target: Self
   Duration: 1 Round/level
   Saving Throw: None
   Power Resistance: No
   Power Point Cost: 5
   
   Your mind generates a tangible field of force that provides a +4 bonus to AC.
   This is a deflection bonus.
   
   Augment: For every 4 additional power points you spend, the AC bonus improves by 1 and the duration increases by 4 rounds.
*/

#include "psi_inc_psifunc"

void main()
{
    UsePower(POWER_MENTALBARRIER, CLASS_TYPE_PSYWAR);
}