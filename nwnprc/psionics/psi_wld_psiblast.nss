/*
   ----------------
   Psionic Blast
   
   prc_all_psiblast
   ----------------

   28/10/04 by Stratovarius

   Class: Psion/Wilder
   Power Level: 3
   Range: Medium
   Target: 30' Cone
   Duration: Instantaneous
   Saving Throw: Will negates
   Power Resistance: Yes
   Power Point Cost: 5
   
   The air ripples with the force of your mental attack, which blasts the minds of all creatures
   in range. Psionic Blast stuns all affect creatures for 1 round.
   
   Augment: For every 2 additional power points spent, the duration increases by 1 round.
*/

#include "psi_inc_psifunc"

void main()
{
    UsePower(POWER_PSIBLAST, CLASS_TYPE_WILDER);
}