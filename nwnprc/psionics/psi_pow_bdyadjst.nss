/*
   ----------------
   Body Adjustment

   psi_pow_bdyadjst
   ----------------

   22/10/04 by Stratovarius
*/ /** @file

    Body Adjustment

    Psychometabolism (Healing)
    Level: Psion/wilder 3, psychic warrior 2
    Manifesting Time: 1 round
    Range: Personal
    Target: You
    Duration: Instantaneous
    Power Points: Psion/wilder 5, psychic warrior 3
    Metapsionics: Empower, Maximize, Twin

    You take control of your body’s healing process, curing yourself of 1d12
    points of damage.

    Augment: For every 2 additional power points you spend, this power heals an
             additional 1d12 points of damage.
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
                              PowerAugmentationProfile(PRC_NO_GENERIC_AUGMENTS,
                                                       2, PRC_UNLIMITED_AUGMENTATION
                                                       ),
                              METAPSIONIC_EMPOWER | METAPSIONIC_MAXIMIZE | METAPSIONIC_TWIN
                              );

    if(manif.bCanManifest)
    {
        int nNumberOfDice = 1 + manif.nTimesAugOptUsed_1;
        int nDieSize      = 12;
        int nHeal;
        effect eHeal, eHealVis = EffectVisualEffect(VFX_IMP_HEALING_L);

        // Handle Twin Power
        int nRepeats = manif.bTwin ? 2 : 1;
        for(; nRepeats > 0; nRepeats--)
        {
            nHeal = MetaPsionicsDamage(manif, nDieSize, nNumberOfDice, 0, 0, FALSE, FALSE);
            eHeal = EffectHeal(nHeal);

            SPApplyEffectToObject(DURATION_TYPE_INSTANT, eHeal,    oTarget);
    	    SPApplyEffectToObject(DURATION_TYPE_INSTANT, eHealVis, oTarget);
    	}
    }
}
