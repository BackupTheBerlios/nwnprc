/*
   ----------------
   Energy Bolt Electricity
   
   prc_all_enbolte
   ----------------

   6/11/04 by Stratovarius

   Class: Psion/Wilder
   Power Level: 3
   Range: Long
   Area: 120 ft line
   Duration: Instantaneous
   Saving Throw: Reflex or Fortitude half.
   Power Resistance: Yes
   Power Point Cost: 5
   
   You release a powerful bolt of energy that hits all creatures in the area, dealing
   5d6 points of damage to them.
   
   Cold: Fort Save, +1 damage a die.
   Electricity: Reflex Save, DC +2, Caster level check to overcome Power Resistance +2.
   Fire: Reflex Save, +1 damage a die.
   Sonic: Reflex Save, -1 damage a die.
   
   Augment: For every additional power point spent, this power's damage increases by 1d6. 
   For every two additional power points spent the DC increases by 1. 
*/

#include "psi_inc_psifunc"

void main()
{
    UsePower(POWER_ENERGYBOLT_ELEC, CLASS_TYPE_PSION);
}