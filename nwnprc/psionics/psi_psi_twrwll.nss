/*
   ----------------
   Tower of Iron Will
   
   prc_pow_twrwll
   ----------------

   23/2/05 by Stratovarius

   Class: Psion/Wilder
   Power Level: 5
   Range: 10 ft
   Area: 10 ft burst centered on caster
   Duration: 1 Round/level
   Saving Throw: None
   Power Resistance: No
   Power Point Cost: 9
   
   You generate a bastion of thought so strong it offers protection to you and everyone around you, improving the self control of all.
   You and all creatures in the area gain power resistance 19. 
   
   Augment: For every additional power point spent, this power's duration increases by 1 round, 
   and the power resistance it grants is increased by 1
*/

#include "psi_inc_psifunc"

void main()
{
    UsePower(POWER_TOWERIRONWILL, CLASS_TYPE_PSION);
}