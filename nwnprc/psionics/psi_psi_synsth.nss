/*
   ----------------
   Synesthete
   
   prc_all_synsth
   ----------------

   1/11/04 by Stratovarius

   Class: Psion/Wilder, Psychic Warrior
   Power Level: 1
   Range: Personal
   Target: Self
   Duration: 10 Min/level
   Saving Throw: None
   Power Resistance: No
   Power Point Cost: 1
   
   Using this power lets you feel sound and light upon your face, giving you a +4 bonus to Search, Spot, and List,
   as well as making you immune to blindness and deafness.
*/
#include "psi_inc_psifunc"

void main()
{
    UsePower(POWER_SYNESTHETE, CLASS_TYPE_PSION);
}