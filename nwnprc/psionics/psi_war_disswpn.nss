/*
   ----------------
   Dissolving Weapon
   
   prc_all_disswpn
   ----------------

   19/1/05 by Ornedan

   Class: Psychic Warrior
   Power Level: 2
   Range: Personal
   Target: One held Weapon
   Duration: Instantaneous
   Saving Throw: None
   Power Resistance: No
   Power Point Cost: 3
   
   Your weapon is corrosive, dealing 4d6 points of acid damage on a successful strike.
   
   Augment: For every 2 additional power points spent, this power's damage increases by 1d6. 
*/

#include "psi_inc_psifunc"

void main()
{
    UsePower(POWER_DISSOLVEWEAP, CLASS_TYPE_PSYWAR);
}


