/*
    ----------------
    Recall Death
    
    psi_all_rcldeath
    ----------------

    28/10/04 by Stratovarius

    Class: Psion/Wilder
    Power Level: 8
    Range: Medium
    Target: One Creature
    Duration: Instantaneous
    Saving Throw: Will half
    Power Resistance: Yes
    Power Point Cost: 15
 
    The fabric of time parts to your will, revealing wounds the foe has recieved in the past.
    These wounds are potentially fatal. If the target succeeds on its throw, it takes 5d6 damage.
    If it fails, it dies.
*/

#include "psi_inc_psifunc"

void main()
{
    UsePower(POWER_RECALLDEATH, CLASS_TYPE_PSION);
}