/*
   ----------------
   Mindwipe
   
   prc_pow_mindwipe
   ----------------

   19/2/04 by Stratovarius

   Class: Psion/Wilder
   Power Level: 4
   Range: Short
   Target: One Creature
   Duration: Instantaneous
   Saving Throw: Fortitude negates
   Power Resistance: Yes
   Power Point Cost: 7
   
   You partially wipe your victim's mind of past experiences, bestowing two negative levels.
   
   Augment: For every 3 additional power points spend, this power bestows an extra negative level.
   For every 2 additional power points spent in this way, the DC increases by 1.
*/

#include "psi_inc_psifunc"

void main()
{
    UsePower(POWER_MINDWIPE, CLASS_TYPE_PSION);
}