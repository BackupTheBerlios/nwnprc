/*
   ----------------
   Mind Blank, Personal
   
   prc_pow_powres
   ----------------

   25/2/04 by Stratovarius

   Class: Psion/Wilder, Psychic Warrior
   Power Level: 7 P/W, 6 PsyWar
   Range: Personal
   Target: Self
   Duration: 24 Hours
   Saving Throw: None
   Power Resistance: No
   Power Point Cost: P/W 13, PsyWar 11
   
   The caster gains immunity to mind affectng spells and powers.
*/

#include "psi_inc_psifunc"

void main()
{
    UsePower(POWER_MINDBLANKPERSONAL, CLASS_TYPE_WILDER);
}