/*
    ----------------
    Crisis of Life
    
    psi_psi_crslife
    ----------------

    21/10/04 by Stratovarius

    Class: Psion (Telepath)
    Power Level: 7
    Range: Medium
    Target: One Creature
    Duration: Instantaneous
    Saving Throw: Fortitude partial, see text.
    Power Resistance: Yes
    Power Point Cost: 13
 
    You interrupt the target's autonomic heart rhythm, killing it instantly on a 
    failed saving throw if it has 11 Hit Dice or less. If the target makes its 
    saving throw or has greater than 11 Hit Dice, it takes 7d6 damage.

    Augment: For every additional power point spend, this power can kill
    a subject that has Hit Dice equal to 11 + the number of additional points spent. 
*/

#include "psi_inc_psifunc"

void main()
{
    UsePower(POWER_CRISISLIFE, CLASS_TYPE_PSION);
}