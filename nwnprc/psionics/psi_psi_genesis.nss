/*
   ----------------
   Genesis
   
   prc_pow_genesis
   ----------------

   12/4/05 by Stratovarius

   Class: Psion (Shaper)
   Power Level: 9
   Range: Close
   Target: Ground
   Duration: Instantaneous
   Saving Throw: None
   Power Resistance: No
   Power Point Cost: 17
   
   You create a finite plane with limited access: a Demiplane. Demiplanes created by this power are very small, very minor planes,
   but they are private. Upon manifesting this power, a portal will appear infront of you that the manifester and all party members
   may use to enter the plane. Once anyone exits the plane, the plane is shut until the next manifesting of this power. Exiting the
   plane will return you to where you cast the portal.
*/

#include "psi_inc_psifunc"

void main()
{
    UsePower(POWER_GENESIS, CLASS_TYPE_PSION);
}