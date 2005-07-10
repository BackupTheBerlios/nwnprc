/*
   ----------------
   Psychic Chirurgery
   
   prc_psi_psychir
   ----------------

   11/5/05 by Stratovarius

   Class: Psion (Telepath)
   Power Level: 9
   Range: Close
   Target: One Creature
   Duration: Instantaneous
   Saving Throw: None
   Power Resistance: No
   Power Point Cost: 17
   
   The target has all negative effects removed from it, including level drain and ability damage.
*/

#include "psi_inc_psifunc"

void main()
{
    UsePower(POWER_PSYCHICCHIR, CLASS_TYPE_PSION);
}