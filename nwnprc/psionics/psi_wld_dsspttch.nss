/*
   ----------------
   Dissipating Touch
   
   prc_all_dsspttch
   ----------------

   27/10/04 by Stratovarius

   Class: Psion/Wilder, Psychic Warrior
   Power Level: 1
   Range: Touch
   Target: One Creature
   Duration: Instantaneous
   Saving Throw: None
   Power Resistance: Yes
   Power Point Cost: 1
   
   Your mere touch can dispere the surface material of a foe, sending a tiny portion
   of it far away. This effect is disruptive; thus your melee touch attack deals 1d6 damage.
   
   Augment: For every additional power point spent, this power's damage increases by 1d6. 
*/

#include "psi_inc_psifunc"

void main()
{
    UsePower(POWER_DISSIPATINGTOUCH, CLASS_TYPE_WILDER);
}