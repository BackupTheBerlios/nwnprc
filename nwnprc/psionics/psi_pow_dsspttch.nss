/*
   ----------------
   Dissipating Touch

   psi_pow_dsspttch
   ----------------

   27/10/04 by Stratovarius
*/ /** @file

    Dissipating Touch

    Psychoportation (Teleportation)
    Level: Psion/wilder 1, psychic warrior 1
    Manifesting Time: 1 standard action
    Range: Touch
    Target: Creature touched
    Duration: Instantaneous
    Saving Throw: None
    Power Resistance: Yes
    Power Points: 1
    Metapsionics: Empower, Maximize, Twin

    Your mere touch can disperse the surface material of a foe, sending a tiny
    portion of it far away. This effect is disruptive; thus, your successful
    melee touch attack deals 1d6 points of damage.

    Augment: For every additional power point you spend, this power’s damage
             increases by 1d6 points.
*/

#include "psi_inc_psifunc"
#include "psi_inc_pwresist"
#include "psi_spellhook"
#include "spinc_common"
#include "prc_inc_teleport"

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
                              METAPSIONIC_EMPOWER | METAPSIONIC_MAXIMIZE | METAPSIONIC_TWIN
                              );

    if(manif.bCanManifest)
    {
        int nPen          = GetPsiPenetration(oManifester);
        int nNumberOfDice = 1 + manif.nTimesAugOptUsed_1;
        int nDieSize      = 6;
        int nTouchAttack, nDamage;
        effect eVis = EffectVisualEffect(VFX_FNF_LOS_NORMAL_10);

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
                //Check for Power Resistance
                if(PRCMyResistPower(oManifester, oTarget, nPen))
                {
                    // Check if the target can be teleported
                    if(GetCanTeleport(oTarget, GetLocation(oTarget), FALSE))
                    {
                        // Roll damage
                        nDamage = MetaPsionicsDamage(manif, nDieSize, nNumberOfDice, 0, 0, TRUE, TRUE);
                        // Target-specific stuff
                        nDamage = GetTargetSpecificChangesToDamage(oTarget, oManifester, nDamage, TRUE, FALSE);

                        // Apply VFX and damage
                        SPApplyEffectToObject(DURATION_TYPE_INSTANT, eVis, oTarget);
                        ApplyTouchAttackDamage(oManifester, oTarget, nTouchAttack, nDamage, DAMAGE_TYPE_MAGICAL);
                    }
                }
            }
        }
    }
}
