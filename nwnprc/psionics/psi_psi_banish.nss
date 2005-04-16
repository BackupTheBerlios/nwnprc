/*
   ----------------
   Banishment
   
   prc_pow_banish
   ----------------

   28/4/05 by Stratovarius

   Class: Psion (Nomad)
   Power Level: 6
   Range: Close
   Target: One or more Extraplanar Creature
   Duration: Instantaneous
   Saving Throw: Will negates
   Power Resistance: Yes
   Power Point Cost: 11
   
   This spell forces extraplanar creatures back to their home plane if they fails a save. Affected creatures include summons, 
   outsiders, and elementals. You can banish up to 2 HD per caster level. 
*/

#include "psi_inc_psifunc"

void main()
{
    UsePower(POWER_BANISHMENT, CLASS_TYPE_PSION);
}