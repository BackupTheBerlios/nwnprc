/*
   ----------------
   Energy Retort Sonic
   
   prc_all_enrtrts
   ----------------

   11/12/04 by Stratovarius

   Class: Psion/Wilder
   Power Level: 3
   Range: Personal
   Target: Self
   Duration: 1 min/level
   Saving Throw: Reflex or Fortitude half.
   Power Resistance: Yes
   Power Point Cost: 5
   
   You weave a potential energy field around your body. The first successful attack made against you in each
   round prompts a response from the field, dealing 4d6 damage of the appropriate element. To deal the damage, you
   must hit on a ranged touch attack. The target then gets power resistance and a save for half.
   
   Cold: Fort Save, +1 damage a die.
   Electricity: Reflex Save, DC +2, Caster level check to overcome Power Resistance +2.
   Fire: Reflex Save, +1 damage a die.
   Sonic: Reflex Save, -1 damage a die.
   
   Augment: For every additional power point spent, this power's duration increases by 1 minute.
*/

#include "psi_inc_psifunc"

void main()
{
    UsePower(POWER_ENERGYRETORT_SONIC, CLASS_TYPE_PSION);
}