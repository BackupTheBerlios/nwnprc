/*
   ----------------
   Evade Burst
   
   prc_pow_evadebst
   ----------------

   22/10/04 by Stratovarius

   Class: Psion/Wilder, Psychic Warrior
   Power Level: Psion/Wilder 7, PsyWar 3
   Range: Personal
   Target: Self
   Duration: 1 Round/Level
   Saving Throw: None
   Power Resistance: No
   Power Point Cost: Psion/Wilder 13, PsyWar 5
   
   When you manifest this power, you gain the effect of evasion.
   
   Augment: If you spend 4 additional points, you gain improved evasion. Augmenting this power beyond level 1 does nothing.
*/

#include "psi_inc_psifunc"

void main()
{
    UsePower(POWER_EVADEBURST, CLASS_TYPE_WILDER);
}