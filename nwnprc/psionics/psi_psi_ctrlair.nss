/*
    ----------------
    Control Air
    
    psi_pow_ctrlair
    ----------------

    26/3/05 by Stratovarius

    Class: Psion (Kineticist)
    Power Level: 2
    Range: Long
    Target: 50' Circle
    Duration: Instantaneous
    Saving Throw: Fort negates
    Power Resistance: Yes
    Power Point Cost: 3
 
    You summon a gust of wind, knocking down everyone in the area unless they succeed at their save.
*/

#include "psi_inc_psifunc"

void main()
{
    UsePower(POWER_CONTROLAIR, CLASS_TYPE_PSION);
}