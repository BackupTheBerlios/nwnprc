/*
   ----------------
   Ectoplasmic Shambler
   
   prc_pow_esham
   ----------------

   23/2/04 by Stratovarius

   Class: Psion/Wilder
   Power Level: 5
   Range: Long
   Area: Colossal
   Duration: 1 Min/level
   Saving Throw: None
   Power Resistance: No
   Power Point Cost: 9
   
   You fashion an ephemeral mass of psedu-living ectoplasm called an ectoplasmic shambler. Anything caught within the shambler
   is blinded, and takes 1 point of damage for every 2 manifester levels of the caster.
*/

#include "psi_inc_psifunc"

void main()
{
    UsePower(POWER_ECTOSHAMBLER, CLASS_TYPE_WILDER);
}