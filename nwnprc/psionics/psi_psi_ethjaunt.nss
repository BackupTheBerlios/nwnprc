/*
   ----------------
   Ethereal Jaunt
   
   prc_pow_ethjaunt
   ----------------

   8/4/05 by Stratovarius

   Class: Psion (Nomad)
   Power Level: 7
   Range: Personal
   Target: Self
   Duration: 1 Round/level
   Saving Throw: None
   Power Resistance: Yes
   Power Point Cost: 13
   
   You go to the Ethereal Plane. Taking any hostile action will end the power.
*/

#include "psi_inc_psifunc"

void main()
{
    UsePower(POWER_ETHEREALJAUNT, CLASS_TYPE_PSION);
}