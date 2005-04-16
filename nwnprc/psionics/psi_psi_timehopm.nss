/*
   ----------------
   Time Hop, Mass
   
   prc_pow_timehopm
   ----------------

   8/4/05 by Stratovarius

   Class: Psion (Nomad)
   Power Level: 8
   Range: Personal
   Target: 25' Burst
   Duration: 1 Hour/level
   Saving Throw: Will negates
   Power Resistance: Yes
   Power Point Cost: 15
   
   The subjects of the power hop forward in time. In effect, the subjects disappear in a shimmer, then reappear when the power
   expires. No change has taken place to the objects. Friendly targets get no saving throw. 
*/

#include "psi_inc_psifunc"

void main()
{
    UsePower(POWER_TIMEHOPMASS, CLASS_TYPE_PSION);
}