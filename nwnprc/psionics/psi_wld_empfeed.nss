/*
   ----------------
   Empathic Feedback
   
   prc_pow_empfeed
   ----------------

   19/2/04 by Stratovarius

   Class: Psion/Wilder, Psychic Warrior
   Power Level: 4, Psychic Warrior 3
   Range: Personal
   Target: Self
   Duration: 10 Min/level
   Saving Throw: None
   Power Resistance: No
   Power Point Cost: 7, Psychic Warrior 5
   
   You share your pain and suffering with your attacker. Each time a creature strikes you in melee, it takes damage equal
   to the amount dealt or 5, whichever is less. 
   
   Augment: For every additional power point spend, the damage empathic feedback can deal increases by 1.
*/

#include "psi_inc_psifunc"

void main()
{
    UsePower(POWER_EMPATHICFEEDBACK, CLASS_TYPE_WILDER);
}