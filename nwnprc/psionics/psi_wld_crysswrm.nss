/*
    ----------------
    Crystal Swarm
    
    psi_all_crysswrm
    ----------------

    9/11/04 by Stratovarius

    Class: Psion/Wilder
    Power Level: 2
    Range: Short
    Shape: 15' Cone
    Duration: Instantaneous
    Saving Throw: None
    Power Resistance: No
    Power Point Cost: 3
 
    Thousands of tiny crystal shards spray forth in an arc from your hand. These razorlike crystals
    slice anything in their path. Anything caught in the cone takes 3d4 points of slashing damage. 

    Augment: For every additional power point spend, this power's damage increases by 1d4. 
*/

#include "psi_inc_psifunc"

void main()
{
    UsePower(POWER_CRYSTALSWARM, CLASS_TYPE_WILDER);
}