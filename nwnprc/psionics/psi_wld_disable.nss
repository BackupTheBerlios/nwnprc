/*
   ----------------
   Disable
   
   prc_all_disable
   ----------------

   29/10/04 by Stratovarius

   Class: Psion/Wilder
   Power Level: 1
   Range: Short
   Area: 20' Cone
   Duration: 1 Min/level
   Saving Throw: Will negates
   Power Resistance: Yes
   Power Point Cost: 1
   
   You broadcast a mental compulsion that convinces one or more creatures of 4 or less HD that it is disabled. 
   This has the effect of slowing them down, as they are lethargic.
   
   Augment: For every 2 additional power points spent, this power's range increases by 5 and its DC by 1. 
*/

#include "psi_inc_psifunc"

void main()
{
    UsePower(POWER_DISABLE, CLASS_TYPE_WILDER);
}