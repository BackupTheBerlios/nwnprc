/*
   ----------------
   Daze
   
   prc_all_daze
   ----------------

   25/10/04 by Stratovarius

   Class: Psion/Wilder
   Power Level: 1
   Range: Short
   Target: One Creature
   Duration: 2 Rounds
   Saving Throw: Will negates
   Power Resistance: Yes
   Power Point Cost: 1
   
   You daze a single creature with 4 HD or less.
   
   Augment: For every additional power point spent, this power can affect a target
   that has HD equal to 4 + the additional power points spent.
*/

#include "psi_inc_psifunc"

void main()
{
    UsePower(POWER_DAZE, CLASS_TYPE_WILDER);
}