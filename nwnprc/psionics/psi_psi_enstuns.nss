/*
   ----------------
   Energy Stun Cold
   
   prc_all_enstunc
   ----------------

   6/11/04 by Stratovarius

   Class: Psion/Wilder
   Power Level: 2
   Range: Short
   Area: 5 ft burst
   Duration: Instantaneous
   Saving Throw: Reflex or Fortitude half.
   Power Resistance: Yes
   Power Point Cost: 3
   
   You release a power stroke of energy that encircles all creatures in the area, dealing
   1d6 points of damage to them. In addition, any creature that fails its save for half damage
   must succeed on a will save or be stunned for 1 round.
   
   Cold: Fort Save, +1 damage a die.
   Electricity: Reflex Save, DC +2, Caster level check to overcome Power Resistance +2.
   Fire: Reflex Save, +1 damage a die.
   Sonic: Reflex Save, -1 damage a die.
   
   Augment: For every additional power point spent, this power's damage increases by 1d6, 
   and the DC increases by 1. 
*/
#include "psi_inc_psifunc"

void main()
{
    UsePower(POWER_ENERGYSTUN_SONIC, CLASS_TYPE_PSION);
}