/*
   ----------------
   Reddopsi
   
   psi_pow_reddopsi
   ----------------

   6/10/05 by Stratovarius
*/ /** @file

    Reddopsi

    Psychokinesis
    Level: Kineticist 7
    Manifesting Time: 1 standard action
    Range: Personal
    Target: You
    Duration: 10 min./level
    Power Points: 13
    Metapsionics: Extend

    When you manifest reddopsi, powers targeted against you rebound to affect the original manifester. This effect reverses powers 
    that have only you as a target (except dispel psionics and similar powers or effects). Powers that affect an area can’t be 
    reversed. 

    Should you rebound a power back against a manifester who also is protected by reddopsi, the power rebounds once more upon you.
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
                              METAPSIONIC_EXTEND
                              );

    if(manif.bCanManifest)
    {
	float fDuration = 600.0 * manif.nManifesterLevel;
	if(manif.bExtend) fDuration *= 2;	
		
	effect eDur = EffectVisualEffect(VFX_DUR_PROT_EPIC_ARMOR);
	SetLocalInt(oTarget, "Reddopsi", TRUE);
	SPApplyEffectToObject(DURATION_TYPE_TEMPORARY, eDur, oTarget, fDuration);
	DelayCommand(fDuration, DeleteLocalInt(oTarget, "Reddopsi"));
    }
    	
}