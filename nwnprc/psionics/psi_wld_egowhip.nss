/*
    ----------------
    Ego Whip
    
    psi_all_egowhip
    ----------------

    6/11/04 by Stratovarius

    Class: Psion/Wilder
    Power Level: 2
    Range: Medium
    Target: One Creature
    Duration: Instantaneous
    Saving Throw: Will half
    Power Resistance: Yes
    Power Point Cost: 3
 
    Your rapid mental lashings assault the ego of the target, debilitating its confidence. 
    The target takes 1d4 points of Charisma damage, or half that amount on a save (minimum 1). 
    A target that fails its save is also dazed for one round.

    Augment: For every 4 additional power points spent, this power's Charisma damage increases by 1d4,
    and the save DC increases by 2.
*/
#include "psi_inc_psifunc"

void main()
{
    UsePower(POWER_EGOWHIP, CLASS_TYPE_WILDER);
}