/*
   ----------------
   Ultrablast
   
   prc_pow_ultrabst
   ----------------

   25/2/04 by Stratovarius

   Class: Psion/Wilder
   Power Level: 7
   Range: 15
   Area: 15 ft burst centered on caster
   Duration: Instantaneous
   Saving Throw: Will half.
   Power Resistance: Yes
   Power Point Cost: 13
   
   Yu grumble psychically, then release a horrid shriek from your subconcious that disrupts the brains of all enemies in the power's
   area, dealing 13d6 to each enemy.
   
   Augment: For every additional power point spent, this power's damage increases by 1d6. 
*/

#include "psi_inc_psifunc"

void main()
{
    UsePower(POWER_ULTRABLAST, CLASS_TYPE_WILDER);
}