/*
   ----------------
   Inertial Barrier
   
   prc_all_inertbar
   ----------------

   28/10/04 by Stratovarius

   Class: Psion (Kineticist), Psychic Warrior
   Power Level: 4
   Range: Personal
   Target: Self
   Duration: 10 Min/level
   Saving Throw: None
   Power Resistance: No
   Power Point Cost: 7
   
   You create a skin-tight psychokinetic barrier around you that resists cuts, slashes, stabs and blows.
   This provides 5/- Damage Resistance to all physical damage.
*/

#include "psi_inc_psifunc"

void main()
{
    UsePower(POWER_INERTBARRIER, CLASS_TYPE_PSYWAR);
}