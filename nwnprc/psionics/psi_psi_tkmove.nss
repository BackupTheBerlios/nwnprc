/*
   ----------------
   Telekinetic Maneuver
   
   prc_pow_tkmove
   ----------------

   26/3/05 by Stratovarius

   Class: Psion/Wilder
   Power Level: 4
   Range: Medium
   Target: One Creature
   Duration: 1 Round/2 levels
   Saving Throw: None
   Power Resistance: Yes
   Power Point Cost: 7
   
   You mentally push your foe or his weapon, attempting to knock him down and disarm him. The DC of the discipline check
   to knock him down and disarm is your manifester level plus your intelligence modifier. The target gets a seperate check
   for knockdown and for disarm.
   
   Augment: For every 2 additional power points spent, the DC of the discipline check goes up by 1.
*/

#include "psi_inc_psifunc"

void main()
{
    UsePower(POWER_TELEKINETICMANEUVER, CLASS_TYPE_PSION);
}