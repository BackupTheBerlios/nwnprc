/*
   ----------------
   Demoralize
   
   prc_all_demoral
   ----------------

   29/10/04 by Stratovarius

   Class: Psion/Wilder
   Power Level: 1
   Range: 30 ft
   Area: 30 ft radius centered on caster
   Duration: 1 Min/level
   Saving Throw: Will negates
   Power Resistance: Yes
   Power Point Cost: 1
   
   You fill your enemies with self doubt. Any enemy in the area that fails its save becomes shaken.
   
   Augment: For every 2 additional power points spent, the DC on this power increases by 1.
*/

#include "psi_inc_psifunc"
#include "psi_inc_pwresist"
#include "psi_spellhook"
#include "X0_I0_SPELLS"

#include "psi_inc_psifunc"

void main()
{
    UsePower(POWER_DEMORALIZE, CLASS_TYPE_PSION);
}