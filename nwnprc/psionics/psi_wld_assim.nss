/*
   ----------------
   Assimilate
   
   prc_pow_assim
   ----------------

   26/2/05 by Stratovarius

   Class: Psion/Wilder
   Power Level: 9
   Range: Touch
   Target: One Creature
   Duration: Instantaneous
   Saving Throw: Fortitude half.
   Power Resistance: Yes
   Power Point Cost: 17
   
   Your pointing finger turns black as obsidian. A creature touched by you is partially assimilated into your form and takes
   20d6 points of damage. If the creature survives this damage, you gain half of the damage dealt as temporary hitpoints. If the 
   creature dies, you gain all of the damage dealt as temporary hitpoints, and +4 to all stats. All bonuses last for 1 hour.
*/

#include "psi_inc_psifunc"

void main()
{
    UsePower(POWER_ASSIMILATE, CLASS_TYPE_WILDER);
}