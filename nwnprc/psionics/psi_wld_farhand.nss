/*
   ----------------
   Far Hand
   
   prc_all_farhand
   ----------------

   6/12/04 by Stratovarius

   Class: Psion/Wilder
   Power Level: 1
   Range: Medium
   Target: One Item of 5 pounds
   Duration: Instantaneous
   Saving Throw: None
   Power Resistance: No
   Power Point Cost: 1
   
   You mentally lift a small, unattended object and move it to your inventory.
   
   Augment: For every additional power point spent, the weight of the item you can pick up increases by 2 pounds.
*/

#include "psi_inc_psifunc"

void main()
{
    UsePower(POWER_FARHAND, CLASS_TYPE_WILDER);
}