/*
   ----------------
   Id Insinuation
   
   prc_all_idinsin
   ----------------

   25/10/04 by Stratovarius

   Class: Psion/Wilder
   Power Level: 2
   Range: Short
   Target: One Creature
   Duration: 1 Round/level
   Saving Throw: Will negates
   Power Resistance: Yes
   Power Point Cost: 3
   
   Swift tendrils of thought disrupt the unconcious mind of the target, sapping its might.
   The target quickly becomes confused.
   
   Augment: For every 2 additional power points spent, this power's DC increases by 1,
   and affects another hostile creature within 15 feet of the first.    
*/
#include "psi_inc_psifunc"

void main()
{
    UsePower(POWER_IDINSINUATION, CLASS_TYPE_WILDER);
}