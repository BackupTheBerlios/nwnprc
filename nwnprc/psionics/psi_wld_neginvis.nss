/*
   ----------------
   Eradicate Invisibility
   
   prc_all_neginvis
   ----------------

   11/12/04 by Stratovarius

   Class: Psion/Wilder
   Power Level: 3
   Area: Colossal burst centered on caster
   Duration: Instantaneous
   Saving Throw: Reflex negates.
   Power Resistance: No
   Power Point Cost: 5
   
   You radiate a psychokinetic burst that disrupts and negates all invisibility in the area.
*/

#include "psi_inc_psifunc"

void main()
{
    UsePower(POWER_ERADICATEINVIS, CLASS_TYPE_WILDER);
}