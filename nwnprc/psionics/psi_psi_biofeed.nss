/*
   ----------------
   Biofeedback
   
   prc_all_biofeed
   ----------------

   1/11/04 by Stratovarius

   Class: Psion/Wilder, Psychic Warrior
   Power Level: Psion/Wilder 2, Psychic Warrior 1
   Range: Personal
   Target: Self
   Duration: 1 Min/level
   Saving Throw: None
   Power Resistance: No
   Power Point Cost: 1
   
   You toughen your body against wounds, lessening their impact. During the duration
   of this power, you gain 2/- DR.
   
   Augment: For every 3 additional power points you spend, the damage reduction improves by 1.
*/
#include "psi_inc_psifunc"

void main()
{
    UsePower(POWER_BIOFEEDBACK, CLASS_TYPE_PSION);
}