/*
   ----------------
   Mind Blank
   
   prc_pow_psimndbk
   ----------------

   25/2/05 by Stratovarius

   Class: Psion/Wilder
   Power Level: 8
   Range: Close
   Target: One Creature
   Duration: 24 Hours
   Saving Throw: None
   Power Resistance: No
   Power Point Cost: 15
   
   The caster gains immunity to mind affectng spells and powers.
*/

#include "psi_inc_psifunc"

void main()
{
    UsePower(POWER_PSIMINDBLANK, CLASS_TYPE_WILDER);
}