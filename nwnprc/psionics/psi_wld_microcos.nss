/*
   ----------------
   Microcosm
   
   prc_pow_microcos
   ----------------

   26/2/05 by Stratovarius

   Class: Psion/Wilder
   Power Level: 9
   Range: Close
   Target: One Creature
   Duration: Instantaneous
   Saving Throw: None
   Power Resistance: Yes
   Power Point Cost: 17
   
   You warp the consciousness of the victim, sending it into a catatonic state. If that creature has less than 100 hitpoints,
   the target sprawls limply, drooling and mewling on the ground. This effect is permanent.
*/

#include "psi_inc_psifunc"

void main()
{
    UsePower(POWER_MICROCOSM, CLASS_TYPE_WILDER);
}