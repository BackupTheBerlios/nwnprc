/*
   ----------------
   Retrieve
   
   prc_pow_retrieve
   ----------------

   27/3/05 by Stratovarius

   Class: Psion/Wilder
   Power Level: 6
   Range: Medium
   Target: One Item of 10 pounds/level
   Duration: Instantaneous
   Saving Throw: Will negates
   Power Resistance: No
   Power Point Cost: 11
   
   You teleport an item you can see to you. If the object is possessed by an opponent, they get a will save to prevent it.
   This power will take the opponents weapon, if it is disarmable.
   
   Augment: For every additional power point spent, the weight of the item you can pick up increases by 10 pounds.
*/

#include "psi_inc_psifunc"

void main()
{
    UsePower(POWER_RETRIEVE, CLASS_TYPE_PSION);
}