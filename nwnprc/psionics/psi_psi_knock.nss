/*
   ----------------
   Psionic Knock	
   
   prc_all_knock
   ----------------

   7//11/04 by Stratovarius

   Class: Psion/Wilder
   Power Level: 2
   Range: Personal
   Target: Self
   Duration: Instantaneous
   Saving Throw: None
   Power Resistance: No
   Power Point Cost: 3
   
   When you manifest this power, you unlock all objects in a large radius. 
*/
#include "psi_inc_psifunc"

void main()
{
    UsePower(POWER_KNOCK, CLASS_TYPE_PSION);
}