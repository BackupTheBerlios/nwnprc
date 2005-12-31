/*
   ----------------
   Dissolving Touch

   psi_pow_dsslvtch
   ----------------

   27/10/04 by Stratovarius
*/ /** @file

    Dissolving Touch

    Psychometabolism [Acid]
    Level: Psychic warrior 2
    Manifesting Time: 1 standard action
    Range: Touch
    Target: Creature or object touched
    Duration: Instantaneous
    Saving Throw: None
    Power Resistance: No
    Power Points: 3
    Metapsionics: Chain, Empower, Maximize, Twin

    Your touch, claw, or bite is corrosive, and sizzling moisture visibly oozes
    from your natural weapon or hand. You deal 4d6 points of acid damage to any
    creature or object you touch with your successful melee touch attack.

    Augment: For every 2 additional power points you spend, this power’s damage
             increases by 1d6 points.
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
    object oMainTarget = PRCGetSpellTargetObject();
    struct manifestation manif =
        EvaluateManifestation(oManifester, oMainTarget,
                              PowerAugmentationProfile(PRC_NO_GENERIC_AUGMENTS,
                                                       2, PRC_UNLIMITED_AUGMENTATION
                                                       ),
                              METAPSIONIC_CHAIN | METAPSIONIC_EMPOWER | METAPSIONIC_MAXIMIZE | METAPSIONIC_TWIN
                              );

    if(manif.bCanManifest)
    {
        int nNumberOfDice = 4 + manif.nTimesAugOptUsed_1;
        int nDieSize      = 6;
        int nTouchAttack, i, nDamage;
        effect eVis = EffectVisualEffect(VFX_IMP_ACID_S);
        object oChainTarget;

        // Determine Chain Power targets
        if(manif.bChain)
            EvaluateChainPower(manif, oMainTarget, TRUE);

        // Let the AI know
        SPRaiseSpellCastAt(oMainTarget, TRUE, manif.nSpellID, oManifester);
        if(manif.bChain)
            for(i = 0; i < array_get_size(oManifester, PRC_CHAIN_POWER_ARRAY); i++)
                SPRaiseSpellCastAt(array_get_object(oManifester, PRC_CHAIN_POWER_ARRAY, i), TRUE, manif.nSpellID, oManifester);

        // Handle Twin Power
        int nRepeats = manif.bTwin ? 2 : 1;
        for(; nRepeats > 0; nRepeats--)
        {
            // Perform the Touch Attach
            nTouchAttack = PRCDoMeleeTouchAttack(oMainTarget);
            if(nTouchAttack > 0)
            {
                // Calculate damage
                nDamage = MetaPsionicsDamage(manif, nDieSize, nNumberOfDice, 0, 0, TRUE, FALSE);

                // Apply VFX and damage to main target
                SPApplyEffectToObject(DURATION_TYPE_INSTANT, eVis, oMainTarget);
                ApplyTouchAttackDamage(oManifester, oMainTarget, nTouchAttack,
                                       GetTargetSpecificChangesToDamage(oMainTarget, oManifester, nDamage, TRUE, TRUE),
                                       DAMAGE_TYPE_ACID
                                       );
                // Apply damage to Chain targets
                if(manif.bChain)
                {
                    // Halve the damage
                    nDamage /= 2;

                    for(i = 0; i < array_get_size(oManifester, PRC_CHAIN_POWER_ARRAY); i++)
                    {
                        oChainTarget = array_get_object(oManifester, PRC_CHAIN_POWER_ARRAY, i);
                        // Apply VFX and damage to chained target. No criticals or precision-based damage here
                        SPApplyEffectToObject(DURATION_TYPE_INSTANT, eVis, oChainTarget);
                        SPApplyEffectToObject(DURATION_TYPE_INSTANT,
                                              EffectDamage(GetTargetSpecificChangesToDamage(oChainTarget, oManifester, nDamage, TRUE, TRUE),
                                                           DAMAGE_TYPE_ACID
                                                           ),
                                              oChainTarget
                                              );
                    }// end for - Chain targets
                }// end if - Chain Power
            }// end if - Touch attack hit
        }// end for - Twin Power
    }// end if - Successfull manifestation
}
