/*
   ----------------
   Psionic Lock

   psi_pow_lock
   ----------------

   7/12/04 by Stratovarius
*/ /** @file

    Psionic Lock

    Psychoportation
    Level: Psion/wilder 2
    Manifesting Time: 1 standard action
    Range: Touch
    Target: Door or chest touched
    Duration: Permanent
    Saving Throw: None
    Power Resistance: No
    Power Points: 3

    A psionic lock manifested upon a door, chest, or portal psionically locks it.
*/

#include "psi_inc_psifunc"
#include "psi_inc_pwresist"
#include "psi_spellhook"
#include "prc_alterations"

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

    object oManifester = OBJECT_SELF;
    object oTarget     = PRCGetSpellTargetObject();
    struct manifestation manif =
        EvaluateManifestation(oManifester, oTarget,
                              PowerAugmentationProfile(),
                              METAPSIONIC_NONE
                              );

    if(manif.bCanManifest)
    {
        if(GetLockLockable(oTarget) && !GetPlotFlag(oTarget))
        {
        	SetLocked(oTarget, TRUE);
        }
        else
        {
        	FloatingTextStrRefOnCreature(16824064, oManifester, FALSE); // "This item is cannot be locked"
        }
    }// end if - Successfull manifestation
}
