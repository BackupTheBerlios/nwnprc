/*
   ----------------
   Touchsight
   
   prc_pow_tchsght
   ----------------

   17/2/05 by Stratovarius

   Class: Psion/Wilder
   Power Level: Psion/Wilder 3
   Range: Personal
   Target: Caster
   Duration: 1 Min/level
   Saving Throw: None
   Power Resistance: None
   Power Point Cost: 5
   
   You generate a subtle telekinetic field of mental contact, allowing you to "feel" your surroundings. You can spot creatures
   hidden, even by magical means. 
*/

#include "psi_inc_psifunc"

void main()
{
    UsePower(POWER_TOUCHSIGHT, CLASS_TYPE_WILDER);
}