/*
   ----------------
   Time Hop
   
   prc_pow_timehop
   ----------------

   27/3/05 by Stratovarius

   Class: Psion/Wilder
   Power Level: 3
   Range: Close
   Target: One Object
   Duration: 1 Round/level
   Saving Throw: Will negates
   Power Resistance: Yes
   Power Point Cost: 5
   
   The subject of the power hops forward in time. In effect, the subject disappears in a shimmer, then reappears when the power
   expires. No change has taken place to the object. The creature must be of medium size or smaller. 
   
   Augment: For every 2 additional power points spent, this power's can affect 1 more target within 15 feet of the original, and
   the size category it can effect increases by 1 step.
*/

#include "psi_inc_psifunc"

void main()
{
    UsePower(POWER_TIMEHOP, CLASS_TYPE_PSION);
}