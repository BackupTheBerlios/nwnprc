/*
   ----------------
   Offensive Precognition
   
   prc_all_offpre
   ----------------

   31/10/04 by Stratovarius

   Class: Psion/Wilder, Psychic Warrior
   Power Level: 1
   Range: Personal
   Target: Self
   Duration: 1 Min/level
   Saving Throw: None
   Power Resistance: No
   Power Point Cost: 1
   
   Your awareness extends a fraction of a second into the future, allowing you to 
   better land blows against an opponent. You gain a +1 bonus to your attack rolls.
   
   Augment: For every 3 additional power points you spend, the bonus improves by 1.
*/
#include "psi_inc_psifunc"

void main()
{
    UsePower(POWER_OFFPRECOG, CLASS_TYPE_PSION);
}