/*
    ----------------
    Crystallize
    
    psi_psi_crystlz
    ----------------

    25/10/04 by Stratovarius

    Class: Psion (Shaper)
    Power Level: 6
    Range: Medium
    Target: One Creature
    Duration: Permanent
    Saving Throw: Fortitude negates
    Power Resistance: Yes
    Power Point Cost: 11
 
    You seed the subject's flesh with super-saturated crystal. In an eyeblink, the subjects
    form seems to freeze over, as its flesh and fuilds are instantly crystallized. This has 
    the effect of petrifying the target permanently. 
*/

#include "psi_inc_psifunc"

void main()
{
    UsePower(POWER_CRYSTALLIZE, CLASS_TYPE_PSION);
}