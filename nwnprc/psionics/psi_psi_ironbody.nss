/*
   ----------------
   Iron Body
   
   prc_pow_ironbody
   ----------------

   25/2/04 by Stratovarius

   Class: Psion/Wilder
   Power Level: 8
   Range: Personal
   Target: Self
   Duration: 1 Min/level
   Saving Throw: None
   Power Resistance: No
   Power Point Cost: 15
   
   You transform into a body of living iron. This grants you Damage Reduction 15/+5, Immunity to Blindness, Deafness,
   Disease, Poison, Stunning, Critical Hits, Ability Drain, Electricity, Drowning, 50% Fire Immunity, 50% Acid Immunity,
   +6 to Strength, -6 Dexterity, 50% Arcane Spell Failure and 50% movement speed.
*/

#include "psi_inc_psifunc"

void main()
{
    UsePower(POWER_IRONBODY, CLASS_TYPE_PSION);
}