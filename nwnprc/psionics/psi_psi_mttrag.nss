/*
   ----------------
   Matter Agitation
   
   prc_all_mttrag
   ----------------

   6/12/04 by Stratovarius

   Class: Psion/Wilder
   Power Level: 1
   Range: Short
   Target: One Creature
   Duration: 1 Round/level
   Saving Throw: None
   Power Resistance: Yes
   Power Point Cost: 1
   
   You excite the structure of an object, heating it to the point of combustion over time.
   First Round: 1 point of fire damage.
   Second Round: 1d4 points of fire damage.
   All following rounds: 1d6 points of fire damage.
*/

#include "psi_inc_psifunc"

void main()
{
    UsePower(POWER_MATTERAGITATION, CLASS_TYPE_PSION);
}