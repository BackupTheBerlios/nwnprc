/*
   ----------------
   Moment of Prescience
   
   prc_pow_mmntpre
   ----------------

   25/3/05 by Stratovarius

   Class: Psion/Wilder
   Power Level: 7
   Range: Personal
   Target: Self
   Duration: 1 Round
   Saving Throw: None
   Power Resistance: No
   Power Point Cost: 13
   
   You add a bonus equal to your manifester level (max 20) to attack, armour class, saves, or skills. This lasts
   one round. This power is an instant power.
*/

#include "psi_inc_psifunc"

void main()
{
    UsePower(POWER_MOMENTOFPRESCIENCEARMOUR, CLASS_TYPE_WILDER);
}