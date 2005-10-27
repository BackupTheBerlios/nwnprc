/*
   ----------------
   Dimensional Swap

   prc_pow_dimswap
   ----------------

   8/4/05 by Stratovarius

   Class: Psion (Nomad), Psychic Warrior
   Power Level: 2
   Range: Close
   Target: One Ally
   Duration: Instantaneous
   Saving Throw: None
   Power Resistance: No
   Power Point Cost: 3

   You instantly swap positions between your current position and that of a designated ally.
*/

#include "psi_inc_psifunc"
#include "psi_inc_pwresist"
#include "psi_spellhook"
#include "prc_alterations"
#include "spinc_trans"

void main()
{
/*
  Spellcast Hook Code
  Added 2004-11-02 by Stratovarius
  If you want to make changes to all powers,
  check psi_spellhook to find out more

*/

    if (!PsiPrePowerCastCode())
    {
    // If code within the PrePowerCastHook (i.e. UMD) reports FALSE, do not run this spell
        return;
    }

// End of Spell Cast Hook

    object oCaster = OBJECT_SELF;
    object oTarget = PRCGetSpellTargetObject();
    int nAugCost = 0;
    int nAugment = GetAugmentLevel(oCaster);
    int nSurge = GetLocalInt(oCaster, "WildSurge");
    int nMetaPsi = GetCanManifest(oCaster, nAugCost, oTarget, 0, 0, 0, 0, 0, 0, 0);

    if (nMetaPsi > 0)
    {
	    DoTransposition(FALSE, FALSE);
    }
}