/*
   ----------------
   Shadow Body
   
   prc_pow_shadbody
   ----------------

   27/3/05 by Stratovarius

   Class: Psion/Wilder
   Power Level: 8
   Range: Personal
   Target: Self
   Duration: 1 Min/level
   Saving Throw: None
   Power Resistance: No
   Power Point Cost: 15
   
   Your body and all equipment become a living shadow. You cannot harm anyone physically, but can manifest powers as normal.
   You gain 10/+3 DR, Immunity to Critical Hits, Ability Damage, Disease, and Poison. You take half damage from Fire, Electricity
   and Acid. You also gain Darkvision. You drift in and out of the shadow plane, giving you 50% concealment and causing you 
   to disappear, although this is negated should you attack anyone. 
*/

#include "psi_inc_psifunc"

void main()
{
    UsePower(POWER_SHADOWBODY, CLASS_TYPE_PSION);
}