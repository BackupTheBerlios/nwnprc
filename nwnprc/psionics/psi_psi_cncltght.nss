/*
   ----------------
   Conceal Thought
   
   prc_all_cncltght
   ----------------

   6/12/04 by Stratovarius

   Class: Psion/Wilder, Psychic Warrior
   Power Level: 1
   Range: Short
   Target: One Creature
   Duration: 1 Hour/Level
   Saving Throw: None
   Power Resistance: No
   Power Point Cost: 1
   
   You protect the subjects thoughts from analysis. While the duration lasts, the subject gains a +10 bonus
   to Bluff checks. 
*/

#include "psi_inc_psifunc"

void main()
{
    UsePower(POWER_CONCEALTHOUGHT, CLASS_TYPE_PSION);
}