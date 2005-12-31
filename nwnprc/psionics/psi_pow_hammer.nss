/*
   ----------------
   Hammer

   psi_pow_hammer
   ----------------

   31/10/04 by Stratovarius
*/ /** @file

    Hammer

    Psychometabolism
    Level: Psion/wilder 1, psychic warrior 1
    Manifesting Time: 1 standard action
    Range: Touch
    Target: One creature or object
    Duration: Instantenous
    Saving Throw: None
    Power Resistance: Yes
    Power Points: 1
    Metapsionics: Empower, Maximize, Twin

    This power charges your touch with the force of a sledgehammer. A successful
    melee touch attack deals 1d8 points of bludgeoning damage. This damage is
    not increased or decreased by your Strength modifier.

    Augment: For every additional power point spent, this power's damage
             increases by 1d8.
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
                                                       1, PRC_UNLIMITED_AUGMENTATION
                                                       ),
                              METAPSIONIC_EMPOWER | METAPSIONIC_MAXIMIZE | METAPSIONIC_SPLIT | METAPSIONIC_TWIN
                              );

    if(manif.bCanManifest)
    {
        int nPen          = GetPsiPenetration(oManifester);
        int nNumberOfDice = 1 + manif.nTimesAugOptUsed_1;
        int nDieSize      = 8;
        int nDamage, nTouchAttack;
        effect eVis       = EffectVisualEffect(VFX_IMP_DIVINE_STRIKE_HOLY);
        effect eDamage;

        // Let the AI know
        SPRaiseSpellCastAt(oTarget, TRUE, manif.nSpellID, oManifester);

        // Handle Twin Power
        int nRepeats = manif.bTwin ? 2 : 1;
        for(; nRepeats > 0; nRepeats--)
        {
            // Perform the Touch Attach
            nTouchAttack = PRCDoMeleeTouchAttack(oTarget);
            if(nTouchAttack > 0)
            {
                // Roll against SR
                if(PRCMyResistPower(oManifester, oTarget, nPen))
                {
                    // Roll damage
                    nDamage = MetaPsionicsDamage(manif, nDieSize, nNumberOfDice, 0, 0, TRUE, FALSE);
                    // Target-specific stuff
                    nDamage = GetTargetSpecificChangesToDamage(oTarget, oManifester, nDamage, TRUE, FALSE);

                    // Apply the damage and VFX
                    ApplyTouchAttackDamage(oManifester, oTarget, nTouchAttack, nDamage, DAMAGE_TYPE_BLUDGEONING);
                    SPApplyEffectToObject(DURATION_TYPE_INSTANT, eVis, oTarget);
                }// end if - SR check
            }// end if - Touch attack hit
        }// end for - Twin Power
    }// end if - Successfull manifestation
}
