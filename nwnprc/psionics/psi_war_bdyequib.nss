/*
   ----------------
   Body Equilibrium
   
   prc_all_bdyequib
   ----------------

   6/12/04 by Stratovarius

   Class: Psion/Wilder, Psychic Warrior
   Power Level: Psion/Wilder 2, Psychic Warrior 2
   Range: Personal
   Target: Self
   Duration: 10 Min/level
   Saving Throw: None
   Power Resistance: No
   Power Point Cost: 3
   
   You adjust your bodies equilibrium to correspond with the surface you are walking on,
   making you able to move easily across unusual and unstable surfaces. This makes you
   immune to entangle.
   
*/

#include "psi_inc_psifunc"

void main()
{
    UsePower(POWER_BODYEQUILIBRIUM, CLASS_TYPE_PSYWAR);
}