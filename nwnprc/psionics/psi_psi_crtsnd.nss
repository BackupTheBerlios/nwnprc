/*
   ----------------
   Create Sound
   
   prc_pow_crtsnd
   ----------------

   26/3/05 by Stratovarius

   Class: Psion/Wilder
   Power Level: 1
   Range: Short
   Target: One Creature
   Duration: 1 Round/level
   Saving Throw: None
   Power Resistance: No
   Power Point Cost: 1
   
   You create a volume of changing sounds that disguises your movements, granting the target a bonus of +4 to your move silently checks.
*/

#include "psi_inc_psifunc"

void main()
{
    UsePower(POWER_CREATESOUND, CLASS_TYPE_PSION);
}
