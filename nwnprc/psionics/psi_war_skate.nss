/*
   ----------------
   Skate
   
   prc_all_skate
   ----------------

   7/12/04 by Stratovarius

   Class: Psion/Wilder, Psychic Warrior
   Power Level: 1
   Range: Touch
   Target: One Creature
   Duration: 1 min/level
   Saving Throw: None
   Power Resistance: No
   Power Point Cost: 1
   
   You, or another willing creature, can slide along solid ground as if it was smooth ice. The skater's land speed
   increases by 50%.
*/

#include "psi_inc_psifunc"

void main()
{
    UsePower(POWER_SKATE, CLASS_TYPE_PSYWAR);
}