/*
    ----------------
    Dispel Psionics
    
    psi_pow_dispel
    ----------------

    26/3/05 by Stratovarius

    Class: Psion/Wilder
    Power Level: 3
    Range: Medium
    Target: One Creature or 20' Radius
    Duration: Instantaneous
    Saving Throw: None
    Power Resistance: No
    Power Point Cost: 5
 
    This spell attempts to strip all magical effects from a single target. It can also target a group of creatures, 
    attempting to remove the most powerful spell effect from each creature. To remove an effect, the manifester makes a dispel 
    check of 1d20 +1 per manifester level (to a maximum of +10) against a DC of 11 + the spell effect's manifester level.

    Augment: For every additional power point spent, the manifester level limit on your dispel check increases by 2, up to a maximum
    of +20 at Augment 5.
*/

#include "psi_inc_psifunc"

void main()
{
    UsePower(POWER_DISPELPSIONICS, CLASS_TYPE_WILDER);
}