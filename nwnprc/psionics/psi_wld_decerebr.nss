/*
    ----------------
    Decerebrate
    
    psi_pow_decerebr
    ----------------

    25/2/05 by Stratovarius

    Class: Psion/Wilder
    Power Level: 7
    Range: Close
    Target: One Creature
    Duration: Instantaneous
    Saving Throw: Fortitude negates
    Power Resistance: Yes
    Power Point Cost: 13
 
    With decerebrate, you selectively remove a portion of the creatures brain stem. The creature loses all cerebral functions,
    vision, hearing, and the ability to move. If greater restoration is cast on the target within 1 hour, the target lives. 
    Otherwise, the target will die from the brain damage.
*/

#include "psi_inc_psifunc"

void main()
{
    UsePower(POWER_DECEREBRATE, CLASS_TYPE_WILDER);
}