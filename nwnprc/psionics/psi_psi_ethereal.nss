/*
   ----------------
   Etherealness
   
   prc_pow_ethereal
   ----------------

   26/2/05 by Stratovarius

   Class: Psion/Wilder
   Power Level: 9
   Range: 5' Radius
   Target: Caster + 1 Target/3 levels
   Duration: 1 Min/level
   Saving Throw: None
   Power Resistance: Yes
   Power Point Cost: 17
   
   You and 1 friend per 3 levels go to the Ethereal Plane. Once there, you may split up. Taking any hostile action will end the power.
*/

#include "psi_inc_psifunc"

void main()
{
    UsePower(POWER_ETHEREALNESS, CLASS_TYPE_PSION);
}