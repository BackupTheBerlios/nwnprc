/*
   ----------------
   Oak Body
   
   prc_pow_oakbody
   ----------------

   25/2/04 by Stratovarius

   Class: Psion/Wilder, Psychic Warrior
   Power Level: 7 P/W, 5 PsyWar
   Range: Personal
   Target: Self
   Duration: 1 Min/level
   Saving Throw: None
   Power Resistance: No
   Power Point Cost: P/W 13, PsyWar 9
   
   You gain the advantages of a living oak. This grants you Damage Reduction 10/+2, +5 Natural Armour, Immunity to Blindness, Deafness,
   Disease, Poison, Stunning, 50% Cold Immunity, +4 to Strength, Immunity to Drown, 50% Fire Vulnerability, -2 Dexterity, 
   25% Arcane Spell Failure and 50% movement speed.
   
   Augment: For every additional power point spent, this power's duration increases by 1 minute.  
*/

#include "psi_inc_psifunc"

void main()
{
    UsePower(POWER_OAKBODY, CLASS_TYPE_PSION);
}