/*
    ----------------
    Control Sound
    
    psi_pow_ctrlsnd
    ----------------

    26/3/05 by Stratovarius

    Class: Psion/Wilder
    Power Level: 2
    Range: Medium
    Target: One Creature
    Duration: 1 Round/level
    Saving Throw: Will negates
    Power Resistance: Yes
    Power Point Cost: 3
 
    You shape and alter existing sounds, creating a zone of silence around the target. If the target is hostile, it recieves a will
    save and power resistance, otherwise the effect automatically takes place.
*/

#include "psi_inc_psifunc"

void main()
{
    UsePower(POWER_CONTROLSOUND, CLASS_TYPE_WILDER);
}