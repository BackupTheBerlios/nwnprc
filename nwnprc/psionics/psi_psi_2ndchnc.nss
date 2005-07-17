/*
   ----------------
   Second Chance
   
   prc_pow_2ndchnc
   ----------------

   16/7/05 by Stratovarius

   Class: Psion (Seer)
   Power Level: 5
   Range: Personal
   Target: Self
   Duration: 1 Round/level
   Saving Throw: None
   Power Resistance: No
   Power Point Cost: 9
   
   You take a hand in influencing the probable outcomes of your immediate environment. You see the many alternative branches that 
   reality could take in the next few seconds, and with this foreknowledge you gain the ability to reroll the first failed saving throw
   each round. You must take the result of the reroll, even if it’s worse than the original roll. (Because of Bioware Hardcoding, this
   will not work on reflex saves vs damage dealing spells).
*/

#include "psi_inc_psifunc"

void main()
{
    UsePower(POWER_SECONDCHANCE, CLASS_TYPE_PSION);
}