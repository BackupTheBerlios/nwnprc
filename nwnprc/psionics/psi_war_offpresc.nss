/*
   ----------------
   Offensive Prescience
   
   prc_all_offpresc
   ----------------

   31/10/04 by Stratovarius

   Class: Psion/Wilder, Psychic Warrior
   Power Level: 1
   Range: Personal
   Target: Self
   Duration: 1 Min/level
   Saving Throw: None
   Power Resistance: No
   Power Point Cost: 1
   
   Your awareness extends a fraction of a second into the future, allowing you to 
   better aim blows against an opponent. You gain a +2 bonus to your damage.
   
   Augment: For every 3 additional power points you spend, the bonus improves by 1.
*/

#include "psi_inc_psifunc"

void main()
{
    UsePower(POWER_OFFPRESC, CLASS_TYPE_PSYWAR);
}