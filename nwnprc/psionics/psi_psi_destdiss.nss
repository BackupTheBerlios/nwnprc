/*
   ----------------
   Destiny Dissonance
   
   prc_pow_destdiss
   ----------------

   15/7/05 by Stratovarius

   Class: Psion (Seer)
   Power Level: 1
   Range: Touch
   Target: Creature Touched
   Duration: 1 Round/level
   Saving Throw: None
   Power Resistance: Yes
   Power Point Cost: 1
   
   Your mere touch grants your foe an imperfect, unfocused glimpse of the many possible futures in store. Unaccustomed to and 
   unable process this information, the subject becomes sickened.
*/

#include "psi_inc_psifunc"

void main()
{
    UsePower(POWER_DESTINYDISSONANCE, CLASS_TYPE_PSION);
}