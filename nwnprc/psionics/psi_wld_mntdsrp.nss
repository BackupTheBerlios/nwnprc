/*
   ----------------
   Mental Disruption
   
   prc_all_mntdsrp
   ----------------

   7/11/04 by Stratovarius

   Class: Psion/Wilder
   Power Level: 2
   Range: 10 ft
   Area: 10 ft radius centered on caster
   Duration: 1 Min/level
   Saving Throw: Will negates
   Power Resistance: Yes
   Power Point Cost: 3
   
   You generate a mental wave of confusion that sweeps out from your location. Any enemy in the area that fails its save becomes dazed for one round.
   
   Augment: For every 2 additional power points spent, the DC on this power increases by 1.
*/
#include "psi_inc_psifunc"

void main()
{
    UsePower(POWER_MINDDISRUPT, CLASS_TYPE_WILDER);
}