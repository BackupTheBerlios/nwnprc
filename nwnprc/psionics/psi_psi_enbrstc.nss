/*
   ----------------
   Energy Burst Cold
   
   prc_all_enbrstc
   ----------------

   11/12/04 by Stratovarius

   Class: Psion/Wilder
   Power Level: 3
   Range: 40
   Area: 40 ft burst centered on caster
   Duration: Instantaneous
   Saving Throw: Reflex or Fortitude half.
   Power Resistance: Yes
   Power Point Cost: 5
   
   You create an explosion of unstable ectoplasmic energy of the chosen type that deals 5d6 to every creature
   or object in the area.
   
   Cold: Fort Save, +1 damage a die.
   Electricity: Reflex Save, DC +2, Caster level check to overcome Power Resistance +2.
   Fire: Reflex Save, +1 damage a die.
   Sonic: Reflex Save, -1 damage a die.
   
   Augment: For every additional power point spent, this power's damage increases by 1d6. 
   For every two additional dice of damage, the DC increases by 1. 
*/

#include "psi_inc_psifunc"

void main()
{
    UsePower(POWER_ENERGYBURST_COLD, CLASS_TYPE_PSION);
}