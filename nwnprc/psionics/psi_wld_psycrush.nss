/*
    ----------------
    Psychic Crush
    
    psi_pow_psycrush
    ----------------

    23/2/04 by Stratovarius

    Class: Psion/Wilder
    Power Level: 5
    Range: Close
    Target: One Creature
    Duration: Instantaneous
    Saving Throw: Will partial, see text.
    Power Resistance: Yes
    Power Point Cost: 9
 
    Your will abruptly and brutally crushes the essence of any one creature. The target must make a will save
    with a +4 bonus or be stunned for 1 round and reduced to 1 hit point. If the target makes the save, it takes
    3d6 points of damage.

    Augment: For every 2 additional power points spend, this power's damage on a made save increases by 1d6.
*/

#include "psi_inc_psifunc"

void main()
{
    UsePower(POWER_PSYCHICCRUSH, CLASS_TYPE_WILDER);
}