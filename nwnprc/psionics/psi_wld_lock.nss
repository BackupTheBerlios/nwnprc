/*
   ----------------
   Psionic Lock
   
   prc_all_lock
   ----------------

   7/12/04 by Stratovarius

   Class: Psion/Wilder
   Power Level: 2
   Range: Medium
   Target: One Chest or Door
   Duration: Instantaneous
   Saving Throw: None
   Power Resistance: No
   Power Point Cost: 3
   
   You lock and trap a chest or door. This will prevent anyone from opening the chest without harm. Be careful
   as the trap will target anyone attempting to open the chest.
*/

#include "psi_inc_psifunc"

void main()
{
    UsePower(POWER_LOCK, CLASS_TYPE_WILDER);
}