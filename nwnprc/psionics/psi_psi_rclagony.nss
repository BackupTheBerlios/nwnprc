/*
    ----------------
    Recall Agony
    
    psi_all_rclagony
    ----------------

    28/10/04 by Stratovarius

    Class: Psion/Wilder
    Power Level: 2
    Range: Medium
    Target: One Creature
    Duration: Instantaneous
    Saving Throw: Will half
    Power Resistance: Yes
    Power Point Cost: 3
 
    The fabric of time parts to your will, revealing wounds the foe has recieved in the past.
    That foe takes 2d6 damage as the past impinges on the present.

    Augment: For every additional power point spent, this power's damage increases by 1d6.
    For each extra 2d6 of damage, the DC increases by 1.
*/
#include "psi_inc_psifunc"

void main()
{
    UsePower(POWER_RECALLAGONY, CLASS_TYPE_PSION);
}