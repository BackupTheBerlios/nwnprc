/*
   ----------------
   Dimension Door, Psionic: Self Only
   
   psi_war_ddoor_a
   ----------------

   19/2/04 by Stratovarius
   05.07.2005 by Ornedan
*/
/** @file
    Dimension Door, Psionic
    
    Level: Psion/Wilder 4, Psychic Warrior 4
    Range: Long (400 ft. + 40 ft./level)
    Target or Targets: You and touched objects or other touched willing creatures
    Duration: Instantaneous
    Saving Throw: None
    Power Resistance: No
    Power Point Cost: 7
    
    You instantly transfer yourself from your current location to any other spot within range.
    You always arrive at exactly the spot desired—whether by simply visualizing the area or by
    stating direction. You may also bring one additional willing Medium or smaller creature or
    its equivalent per three caster levels. A Large creature counts as two Medium creatures, a
    Huge creature counts as two Large creatures, and so forth. All creatures to be transported
    must be in contact with you. *
    
    Notes:
     * Implemented as within 10ft of you due to the lovely quality of NWN location tracking code.
*/

#include "psi_inc_psifunc"

void main()
{
    UsePower(POWER_DIMENSIONDOOR_SELFONLY, CLASS_TYPE_PSYWAR);
}