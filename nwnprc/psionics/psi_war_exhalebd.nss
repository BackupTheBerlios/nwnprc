/*
   ----------------
   Exhalation of the Black Dragon
   
   prc_all_exhalebd
   ----------------

   28/10/04 by Stratovarius

   Class: Psychic Warrior
   Power Level: 3
   Range: Short
   Target: One Creature
   Duration: Instantaneous
   Saving Throw: None
   Power Resistance: Yes
   Power Point Cost: 5
   
   You spit forth vitriolic acid at your target, dealing 3d6 points of acid damage on a successful ranged touch attack.
   
   Augment: For every 2 additional power points spent, this power's damage increases by 1d6. 
*/

#include "psi_inc_psifunc"

void main()
{
    UsePower(POWER_EXHALEBLACKDRAG, CLASS_TYPE_PSYWAR);
}