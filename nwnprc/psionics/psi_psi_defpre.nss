/*
   ----------------
   Defensive Precognition
   
   prc_all_defpre
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
   better evade an opponent's blows. You gain a +1 bonus to all saving throws and 
   to your armour class.
   
   Augment: For every 3 additional power points you spend, the bonuses improves by 1.
*/

#include "psi_inc_psifunc"

void main()
{
    UsePower(POWER_DEFPRECOG, CLASS_TYPE_PSION);
}