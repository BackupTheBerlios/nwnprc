/*
   ----------------
   Mind Blank, Psionic

   psi_pow_psimndbk
   ----------------

   25/2/05 by Stratovarius
*/ /** @file

    Mind Blank, Psionic

    Telepathy [Mind-Affecting]
    Level: Psion/wilder 8
    Manifesting Time: 1 standard action
    Range: Close (25 ft. + 5 ft./2 levels)
    Target: One creature
    Duration: One day
    Saving Throw: None
    Power Resistance: No
    Power Points: 15
    Metapsionics: Extend

    The subject is protected from all devices, powers, and spells that detect,
    influence, or read emotions or thoughts. This power protects against powers
    with the mind-affecting or scrying descriptors. Psionic mind blank even
    foils bend reality, limited wish, miracle, reality revision, and wish when
    they are used in such a way as to affect the subject�s mind or to gain
    information about it (however, metafaculty can pierce the protective quality
    of psionic mind blank). Remote viewing (scrying) attempts that are targeted
    specifically at the subject do not work at all.
*/

#include "psi_inc_psifunc"
#include "psi_inc_pwresist"
#include "psi_spellhook"
#include "spinc_common"

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
        effect eLink    =                          EffectImmunity(IMMUNITY_TYPE_MIND_SPELLS);
               eLink    = EffectLinkEffects(eLink, EffectVisualEffect(VFX_DUR_CESSATE_POSITIVE));
               eLink    = EffectLinkEffects(eLink, EffectVisualEffect(VFX_DUR_MAGIC_RESISTANCE));
        effect eVis     = EffectVisualEffect(VFX_IMP_MAGIC_PROTECTION);
        float fDuration = HoursToSeconds(24);
        if(manif.bExtend) fDuration *= 2;

        // Let the AI know
        SPRaiseSpellCastAt(oTarget, FALSE, manif.nSpellID, oManifester);

        // Apply effects
        SPApplyEffectToObject(DURATION_TYPE_TEMPORARY, eLink, oTarget, fDuration, TRUE, manif.nSpellID, manif.nManifesterLevel);
        SPApplyEffectToObject(DURATION_TYPE_INSTANT, eVis, oTarget);
    }// end if - Successfull manifestation
}