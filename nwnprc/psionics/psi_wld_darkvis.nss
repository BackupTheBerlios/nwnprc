/*
   ----------------
   Darkvision
   
   prc_all_darkvis
   ----------------

   25/10/04 by Stratovarius

   Class: Psion/Wilder, Psychic Warrior
   Power Level: Psion/Wilder 3, Psychic Warrior 2
   Range: Personal
   Target: Caster
   Duration: 1 hour/level
   Saving Throw: None
   Power Resistance: None
   Power Point Cost: Psion/Wilder 5, Psychic Warrior 3
   
   You psionically enhance your eyes to gain the effects of darkvision.
*/

#include "psi_inc_psifunc"

void main()
{
    UsePower(POWER_DARKVISION, CLASS_TYPE_WILDER);
}