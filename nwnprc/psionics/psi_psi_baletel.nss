/*
    ----------------
    Baleful Teleport
    
    psi_psi_baletel
    ----------------

    21/10/04 by Stratovarius

    Class: Psion (Nomad)
    Power Level: 5
    Range: Short
    Target: One Creature
    Duration: Instantaneous
    Saving Throw: Fortitude half
    Power Resistance: Yes
    Power Point Cost: 9
 
    You psychoportively disperse miniscule portions of the target, dealing 9d6 points of damage.

    Augment: For every additional power point spend, this power's damage increases by 1d6. 
    For each extra 2d6 points of damage, this power's save DC increases by 1, 
    and your manifester level increases by 1.
*/

#include "psi_inc_psifunc"

void main()
{
    UsePower(POWER_BALEFULTEL, CLASS_TYPE_PSION);
}