/*
   ----------------
   Ubiquitous Vision
   
   prc_pow_ubiqvis
   ----------------

   25/3/04 by Stratovarius

   Class: Psion/Wilder, Psychic Warrior
   Power Level: 3
   Range: Personal
   Target: Self
   Duration: 10 Min/level
   Saving Throw: None
   Power Resistance: No
   Power Point Cost: 5
   
   You have metaphoric "eyes in the back of your head", and on the sides and top as well, granting you benefits. These include
   rogues being unable to sneak you due to flanking, and a +4 bonus to spot and search.
*/

#include "psi_inc_psifunc"

void main()
{
    UsePower(POWER_UBIQVISION, CLASS_TYPE_PSION);
}