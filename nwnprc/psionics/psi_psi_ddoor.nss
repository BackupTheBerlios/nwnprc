/*
   ----------------
   Dimension Door
   
   prc_pow_ddoor
   ----------------

   19/2/04 by Stratovarius

   Class: Psion/Wilder, Psychic Warrior
   Power Level: 4
   Range: Long
   Target: Self
   Duration: Instantaneous
   Saving Throw: None
   Power Resistance: No
   Power Point Cost: 7
   
   You instantly transfer yourself from your current location to any other spot within range.
*/

#include "psi_inc_psifunc"

void main()
{
    UsePower(POWER_DIMENSIONDOOR, CLASS_TYPE_PSION);
}