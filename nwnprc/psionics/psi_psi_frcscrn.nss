/*
   ----------------
   Force Screen
   
   prc_all_frcscrn
   ----------------

   28/10/04 by Stratovarius

   Class: Psion/Wilder, Psychic Warrior
   Power Level: 1
   Range: Personal
   Target: Self
   Duration: 1 Min/level
   Saving Throw: None
   Power Resistance: No
   Power Point Cost: 1
   
   You create an invisible mobile disk of force that hovers in front of you. The force screen
   applies a +4 Shield bonus to armour class.
   
   Augment: For every 4 additional power points you spend, the AC bonus improves by 1.
*/
#include "psi_inc_psifunc"

void main()
{
    UsePower(POWER_FORCESCREEN, CLASS_TYPE_PSION);
}