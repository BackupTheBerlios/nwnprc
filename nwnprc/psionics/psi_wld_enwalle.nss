/*
   ----------------
   Energy Wall, Electricity
   
   prc_pow_enwalle
   ----------------

   26/3/05 by Stratovarius

   Class: Psion/Wilder
   Power Level: 3
   Range: Medium
   Target: Self
   Duration: Instant
   Saving Throw: None
   Power Resistance: No
   Power Point Cost: 5
   
   Upon manifesting this power, you create an immobile sheet of energy of the chosen type. All creatures within 10 feet of the wall
   take 2d6 damage, while those actually in the wall take 2d6 + 1 per manifester level, to a max of +20. This stacks with the extra
   damage provided by certain damage types.
   
   Cold: Fort Save, +1 damage a die.
   Electricity: Reflex Save, DC +2, Caster level check to overcome Power Resistance +2.
   Fire: Reflex Save, +1 damage a die.
   Sonic: Reflex Save, -1 damage a die.
*/

#include "psi_inc_psifunc"

void main()
{
    UsePower(POWER_ENERGYWALL_ELEC, CLASS_TYPE_WILDER);
}