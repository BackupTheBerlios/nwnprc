/*
   ----------------
   Thought Shield
   
   prc_all_tghtshld
   ----------------

   9/11/04 by Stratovarius

   Class: Psion/Wilder, Psychic Warrior
   Power Level: 2
   Range: Personal
   Target: Self
   Duration: 1 Round/level
   Saving Throw: None
   Power Resistance: No
   Power Point Cost: 3
   
   Your fortify your mind against intrusion, gaining 13 Power Resistance.
*/
#include "psi_inc_psifunc"

void main()
{
    UsePower(POWER_THOUGHTSHIELD, CLASS_TYPE_WILDER);
}