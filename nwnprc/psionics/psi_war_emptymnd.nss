/*
   ----------------
   Empty Mind
   
   prc_all_emptymnd
   ----------------

   29/10/04 by Stratovarius

   Class: Psion/Wilder, Psychic Warrior
   Power Level: 1
   Range: Personal
   Target: Self
   Duration: 1 Round/level
   Saving Throw: None
   Power Resistance: No
   Power Point Cost: 1
   
   You empty your mind of all transitory and distracting thoughts, gaining a +2 bonus to will saves.
   
   Augment: For every 2 additional power points you spend, the will save bonus improves by 1.
*/

#include "psi_inc_psifunc"

void main()
{
    UsePower(POWER_EMPTYMIND, CLASS_TYPE_PSYWAR);
}