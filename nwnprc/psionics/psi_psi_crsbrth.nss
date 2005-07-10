/*
   ----------------
   Crisis of Breathe
   
   psi_pow_crsbrth
   ----------------

   19/4/05 by Stratovarius

   Class: Psion (Telepath)
   Power Level: 3
   Range: Medium
   Target: One Living Humanoid
   Duration: 1 Round/level
   Saving Throw: Will negates, Fort partial
   Power Resistance: Yes
   Power Point Cost: 5
   
   You compel the subject to purge its entire store of air in one explosive exhalation, and thereby disrupt the subject's autonomic
   breathing cycle. If the target succeeds on a Will save when target by this power, it is unaffected. Otherwise, it must succeed on
   a Fortitude save every round or black out. If the target succeeds on the Fortitude save, nothing happens. If it fails, it blacks
   out and falls down. For every round it fails the Fort save, the DC increases by 1. If it fails the Fort save for 3 consecutive 
   rounds, it dies from lack of air.
   
   Augment: If you augment this power 1 time, this power also affects Animal, Fey, Giant, Magical Beast
   or Monstrous Humanoid. If you augment this power 3 times, this power also affects Aberration, Dragon and Outsiders. 
   It costs 2 power points to augment once and 6 to augment 3 times. For every 2 power points spent this way, the DC increases by 1.   
*/

#include "psi_inc_psifunc"

void main()
{
    UsePower(POWER_CRISISBREATH, CLASS_TYPE_PSION);
}