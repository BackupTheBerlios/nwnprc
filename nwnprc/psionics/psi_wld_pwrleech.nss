/*
   ----------------
   Power Leech
   
   prc_pow_pwrleech
   ----------------

   19/2/04 by Stratovarius

   Class: Psion/Wilder
   Power Level: 4
   Range: Short
   Target: One Psionic Creature
   Duration: 1 Round/Level
   Saving Throw: Will negates
   Power Resistance: Yes
   Power Point Cost: 7
   
   Your brow erupts with an arc of dark crackling energy that connects with your foe, draining it of 1d6
   power points and adding 1 point to your reserve. If the subject is drained of points, the power ends.
*/

#include "psi_inc_psifunc"

void main()
{
    UsePower(POWER_POWERLEECH, CLASS_TYPE_WILDER);
}