/*
   ----------------
   Energy Wave Cold
   
   prc_pow_enwavec
   ----------------

   25/2/05 by Stratovarius

   Class: Psion/Wilder
   Power Level: 7
   Range: Long
   Area: 120 ft Cone
   Duration: Instantaneous
   Saving Throw: Reflex or Fortitude half.
   Power Resistance: Yes
   Power Point Cost: 13
   
   You create a flood of energy that deals 13d6 to anything in a 120' cone.
   
   Cold: Fort Save, +1 damage a die.
   Electricity: Reflex Save, DC +2, Caster level check to overcome Power Resistance +2.
   Fire: Reflex Save, +1 damage a die.
   Sonic: Reflex Save, -1 damage a die.
   
   Augment: For every additional power point spent, this power's damage increases by 1d6. 
   For every two additional power points spent the DC increases by 1. 
*/

#include "psi_inc_psifunc"
#include "psi_inc_pwresist"
#include "psi_spellhook"
#include "X0_I0_SPELLS"

#include "psi_inc_psifunc"

void main()
{
    UsePower(POWER_ENERGYWAVE_FIRE, CLASS_TYPE_PSION);
}