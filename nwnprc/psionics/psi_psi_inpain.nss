/*
   ----------------
   Inflict Pain
   
   prc_all_inpain
   ----------------

   25/10/04 by Stratovarius

   Class: Psion/Wilder
   Power Level: 2
   Range: Short
   Target: One Creature
   Duration: 1 Round/level
   Saving Throw: Will negates
   Power Resistance: Yes
   Power Point Cost: 3
   
   You telepathically stab the mind of your foe, causing horrible agony. The subject
   suffers wracking pain that imposes a -4 on attack rolls and skill checks. If the target
   makes its save, the penalty is -2.
   
   Augment: For every 2 additional power points spent, this power's DC increases by 1,
   and affects another hostile creature within 15 feet of the first.    
*/
#include "psi_inc_psifunc"

void main()
{
    UsePower(POWER_INFLICTPAIN, CLASS_TYPE_PSION);
}