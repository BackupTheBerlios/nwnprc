/*
   ----------------
   Bestow Power
   
   prc_all_bstpwr
   ----------------

   22/10/04 by Stratovarius

   Class: Psion / Wilder
   Power Level: 2
   Range: Short
   Target: One Creature
   Duration: Instantaneous
   Saving Throw: None
   Power Resistance: No
   Power Point Cost: 3
   
   When you manifest this power, the subject gains up to 2 power points. You can transfer only
   as many power points to a subject as it has manifester levels.
   
   Augment: For every 3 additional power points spent, subject gains 2 additional power points.
*/

#include "psi_inc_psifunc"

void main()
{
    UsePower(POWER_BESTOWPOWER, CLASS_TYPE_WILDER);
}