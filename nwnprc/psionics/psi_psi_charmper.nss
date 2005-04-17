/*
   ----------------
   Charm Person
   
   prc_psi_charmper
   ----------------

   21/10/04 by Stratovarius

   Class: Psion (Telepath)
   Power Level: 1
   Range: Short
   Target: One Humanoid
   Duration: 1 Hour/Level
   Saving Throw: Will negates
   Power Resistance: Yes
   Power Point Cost: 1
   
   You charm the spells target, as per charm person. 
   
   Augment: If you augment this power 1 time, this power also affects Animal, Fey, Giant, Magical Beast
   or Monstrous Humanoid. If you augment this power 3 times, this power also affects Aberration, Dragon, Outsider
   and Elementals. If you augment this power 5 times, duration increases to 1 day/level. It costs 2 power 
   points to augment once, 6 to augment 3 times, and 10 to augment 5 times. For every 2 power points spent
   this way, the DC increases by 1.
*/

#include "psi_inc_psifunc"

void main()
{
    UsePower(POWER_CHARMPERSON, CLASS_TYPE_PSION);
}