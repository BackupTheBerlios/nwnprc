/*
    ----------------
    Shatter Mind Blank
    
    psi_pow_shttrmb
    ----------------

    27/3/05 by Stratovarius

    Class: Psion/Wilder
    Power Level: 5
    Range: Personal
    Target: 30' Radius
    Duration: Instantaneous
    Saving Throw: Will Negates
    Power Resistance: Yes
    Power Point Cost: 9
 
    This power can negate a Personal Mind Blank or Psionic Mind Blank affecting the targets. If the target fails its save and you 
    overcome its power resistance, you can shatter the mind blank by making a check of 1d20 + Manifester level against a DC of
    11 + targets manifester level.
*/

#include "psi_inc_psifunc"

void main()
{
    UsePower(POWER_SHATTERMINDBLANK, CLASS_TYPE_PSION);
}