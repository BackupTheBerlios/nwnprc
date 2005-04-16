/*
   ----------------
   Dismissal
   
   prc_pow_dismiss
   ----------------

   28/4/05 by Stratovarius

   Class: Psion (Nomad)
   Power Level: 4
   Range: Close
   Target: One Extraplanar Creature
   Duration: Instantaneous
   Saving Throw: Will negates
   Power Resistance: Yes
   Power Point Cost: 7
   
   This spell forces an extraplanar creature back to its home plane if it fails a save. Extraplanar creatures are outsiders and 
   elementals. This spell does not work on summons that are not of these races. 
*/

#include "psi_inc_psifunc"

void main()
{
    UsePower(POWER_DISMISSAL, CLASS_TYPE_PSION);
}