/*
   ----------------
   Energy Ray Fire
   
   prc_all_enrayf
   ----------------

   30/10/04 by Stratovarius

   Class: Psion/Wilder
   Power Level: 1
   Range: Short
   Target: One Creature
   Duration: Instantaneous
   Saving Throw: None
   Power Resistance: Yes
   Power Point Cost: 1
   
   You create a ray of energy of the chosen type that shoots forth from your finger tips,
   doing 1d6+1 fire damage on a successful ranged touch attack.
   
   Augment: For every additional power point spent, this power's damage increases by 1d6+1. 
*/
#include "psi_inc_psifunc"

void main()
{
    UsePower(POWER_ENERGYRAY_FIRE, CLASS_TYPE_PSION);
}