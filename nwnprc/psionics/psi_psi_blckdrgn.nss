/*
    ----------------
    Breath of the Black Dragon
    
    psi_all_blckdrgn
    ----------------

    21/10/04 by Stratovarius

    Class: Psion/Wilder 6, Psychic Warrior 6
    Power Level: 6
    Range: Short
    Target: AoE
    Shape: Cone
    Duration: Instantaneous
    Saving Throw: Reflex half
    Power Resistance: Yes
    Power Point Cost: 11
 
    Your mouth spews forth vitriolic acid that deals 11d6 damage to any targets in the area

    Augment: For every additional power point spend, this power's damage increases by 1d6. 
*/

#include "psi_inc_psifunc"

void main()
{
    UsePower(POWER_BREATHBLACKDRAGON, CLASS_TYPE_PSION);
}