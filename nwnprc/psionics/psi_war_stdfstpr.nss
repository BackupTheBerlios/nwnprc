/*
   ----------------
   Steadfast Perception
   
   prc_war_stdfstpr
   ----------------

   28/10/04 by Stratovarius

   Class: Psychic Warrior
   Power Level: 4
   Range: Personal
   Target: Self
   Duration: 10 Min/level
   Saving Throw: None
   Power Resistance: No
   Power Point Cost: 4
   
   Your vision cannot be distracted or mislead, granting you immunity to all figments and glamers,
   such as invisibility. Moreover, your Spot and Search skills gain +6 for the duration of the spell,
   as well as See Invisibility.
*/

#include "psi_inc_psifunc"

void main()
{
    UsePower(POWER_STEADFASTPERCEP, CLASS_TYPE_PSYWAR);
}