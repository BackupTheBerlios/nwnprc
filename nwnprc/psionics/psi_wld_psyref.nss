/*
   ----------------
   Psychic Reformation
   
   prc_pow_psyref
   ----------------

   25/3/05 by Stratovarius

   Class: Psion/Wilder
   Power Level: 4
   Range: Personal
   Target: Self
   Duration: Instant
   Saving Throw: None
   Power Resistance: No
   Power Point Cost: 7
   
   You delevel yourself down to level 1, and then back up to your current level, allowing you to repick all feats, powers, 
   and skill assignments from those levels. You lose XP equal to 50 times the number of levels changed. A level 11 using
   this power would pay a cost of 500 XP. This XP loss can cause you to be deleveled.
*/

#include "psi_inc_psifunc"

void main()
{
    UsePower(POWER_PSYCHICREFORMATION, CLASS_TYPE_WILDER);
}