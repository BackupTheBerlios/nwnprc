/*
   ----------------
   Entangling Ectoplasm

   psi_pow_entangle
   ----------------

   30/10/04 by Stratovarius
*/ /** @file

    Entangling Ectoplasm

    Metacreativity (Creation)
    Level: Psion/wilder 1
    Manifesting Time: 1 standard action
    Range: Close (25 ft. + 5 ft./2 levels)
    Target: One Medium or smaller creature
    Duration: 5 rounds
    Saving Throw: None
    Power Resistance: No
    Power Points: 1
    Metapsionics: Extend, Twin

    You draw forth a glob of ectoplasmic goo from the Astral Plane and
    immediately throw it as a ranged touch attack at any creature in range. On a
    successful hit, the subject is covered in goo and becomes entangled. The goo
    evaporates at the end of the power�s duration.

    Augment: For every 2 additional power points you spend, this power can affect
             a target one size category larger.
*/

#include "psi_inc_psifunc"
#include "psi_inc_pwresist"
#include "psi_spellhook"
#include "prc_inc_sp_tch"

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
                              PowerAugmentationProfile(PRC_NO_GENERIC_AUGMENTS,
                                                       2, 4
                                                       ),
                              METAPSIONIC_EXTEND | METAPSIONIC_TWIN
                              );

    if(manif.bCanManifest)
    {
        int nMaxSize = CREATURE_SIZE_MEDIUM + manif.nTimesAugOptUsed_1;
        int nSize    = PRCGetCreatureSize(oTarget);
        effect eLink =                          EffectEntangle();
               eLink = EffectLinkEffects(eLink, EffectVisualEffect(VFX_DUR_CESSATE_NEGATIVE));
        effect eVis  = EffectVisualEffect(VFX_IMP_SLOW);
        float fDuration = RoundsToSeconds(5);
        if(manif.bExtend) fDuration *= 2;

        // Check size
        if(nSize <= nMaxSize)
        {
            // Let the AI know
            PRCSignalSpellEvent(oTarget, TRUE, manif.nSpellID, oManifester);

            // Handle Twin Power
            int nRepeats = manif.bTwin ? 2 : 1;
            for(; nRepeats > 0; nRepeats--)
            {
                if(PRCDoRangedTouchAttack(oTarget) > 0)
                {
                    //Apply VFX Impact and daze effect
                    SPApplyEffectToObject(DURATION_TYPE_TEMPORARY, eLink, oTarget, fDuration, TRUE, manif.nSpellID, manif.nManifesterLevel);
                    SPApplyEffectToObject(DURATION_TYPE_INSTANT, eVis, oTarget);
                }// end if - Successfull touch attack
            }// end for - Twin Power
        }// end if - Size check
    }// end if - Successfull manifestation
}
