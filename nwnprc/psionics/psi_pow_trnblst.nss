/*
   ----------------
   Tornado Blast
   
   psi_pow_trnblst
   ----------------

   6/10/05 by Stratovarius
*/ /** @file

    Tornado Blast

    Psychokinesis
    Level: Kineticist 9
    Manifesting Time: 1 standard action
    Range: Long (400 ft. + 40 ft./ level)
    Area: 40-ft.-radius burst
    Duration: Instantaneous
    Saving Throw: Reflex half; see text
    Power Resistance: No
    Power Points: 17
    Metapsionics: Empower, Maximize, Twin, Widen

    You induce the formation of a slender vortex of fiercely swirling air. When you manifest it, a vortex of air visibly and 
    audibly snakes out from your outstretched hand.
    If you want to aim the vortex at a specific creature, you can make a ranged touch attack to strike the creature. If you 
    succeed, direct contact with the vortex deals 8d6 points of damage to the creature (no save).
    Regardless of whether your ranged touch attack hits (and even if you forgo the attack), all creatures in the area (including 
    the one possibly damaged by direct contact) are picked up and violently dashed about, dealing 17d6 points of damage to each 
    one. Creatures that make a successful Reflex save take half damage.

    Augment: For every additional power point you spend, this power’s area damage (not the damage from direct contact dealt 
             to a specific creature) increases by 1d6 points (to a maximum of 24d6 points). For each extra 2d6 points of 
             damage, this power’s save DC increases by 1.
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
    object oBallTarget = PRCGetSpellTargetObject();
    struct manifestation manif =
        EvaluateManifestation(oManifester, OBJECT_INVALID,
                              PowerAugmentationProfile(2,
                                                       1, PRC_UNLIMITED_AUGMENTATION
                                                       ),
                              METAPSIONIC_EMPOWER | METAPSIONIC_MAXIMIZE | METAPSIONIC_TWIN | METAPSIONIC_WIDEN
                              );

    if(manif.bCanManifest)
    {
        int nDC                   = GetManifesterDC(oManifester);
        int nPen                  = GetPsiPenetration(oManifester);
        int nNumberOfDice_Explode = 17 + manif.nTimesAugOptUsed_1;
        int nNumberOfDice_Ball    = 8;
        int nDieSize              = 6;
        int nDamage, nTouchAttack;
        location lTarget          = PRCGetSpellTargetLocation();
	effect eImpact = EffectVisualEffect(VFX_IMP_PULSE_WIND);
	effect eExplode = EffectVisualEffect(VFX_FNF_STORM);
        effect eDamage;
        float fRadius             = EvaluateWidenPower(manif, FeetToMeters(40.0f));
        object oExplodeTarget;


        // Handle Twin Power
        int nRepeats = manif.bTwin ? 2 : 1;
        for(; nRepeats > 0; nRepeats--)
        {
            // Check if a particular creature was targeted
            if(GetIsObjectValid(oBallTarget))
            {
                // Let the AI know
                SPRaiseSpellCastAt(oBallTarget, TRUE, manif.nSpellID, oManifester);

                // Roll touch attack
                nTouchAttack = PRCDoRangedTouchAttack(oBallTarget);
                if(nTouchAttack > 0)
                {
                    // Roll damage
                    nDamage = MetaPsionicsDamage(manif, nDieSize, nNumberOfDice_Ball, 0, 0, TRUE, TRUE);
                    // Target-specific stuff
                    nDamage = GetTargetSpecificChangesToDamage(oBallTarget, oManifester, nDamage, TRUE, FALSE);

                    // Apply the damage and VFX. No Reflex save here, they got hit by a touch attack
                    ApplyTouchAttackDamage(oManifester, oBallTarget, nTouchAttack, nDamage, DAMAGE_TYPE_MAGICAL);
                    SPApplyEffectToObject(DURATION_TYPE_INSTANT, eImpact, oBallTarget);
                }// end if - Touch attack hit
            }// end if - A creature was targeted with the ball

            // Either way, shrapnel time
            ApplyEffectAtLocation(DURATION_TYPE_INSTANT, eExplode, lTarget);
            oExplodeTarget = MyFirstObjectInShape(SHAPE_SPHERE, fRadius, lTarget, TRUE, OBJECT_TYPE_CREATURE | OBJECT_TYPE_DOOR | OBJECT_TYPE_PLACEABLE);
            while(GetIsObjectValid(oExplodeTarget))
            {
                if(spellsIsTarget(oExplodeTarget, SPELL_TARGET_STANDARDHOSTILE, oManifester))
                {
                    // Let the AI know
                    SPRaiseSpellCastAt(oExplodeTarget, TRUE, manif.nSpellID, oManifester);

                    // Roll damage
                    nDamage = MetaPsionicsDamage(manif, nDieSize, nNumberOfDice_Explode, 0, 0, TRUE, TRUE);
                    // Target-specific stuff
                    nDamage = GetTargetSpecificChangesToDamage(oExplodeTarget, oManifester, nDamage, TRUE, FALSE);
                    // Adjust damage according to Reflex Save, Evasion or Improved Evasion
                    nDamage = PRCGetReflexAdjustedDamage(nDamage, oExplodeTarget, nDC, SAVING_THROW_TYPE_NONE);

                    // Apply effects if the target didn't Evade
                    if(nDamage > 0)
                    {
                        eDamage = EffectDamage(nDamage, DAMAGE_TYPE_SLASHING);
                        SPApplyEffectToObject(DURATION_TYPE_INSTANT, eDamage, oExplodeTarget);
                        SPApplyEffectToObject(DURATION_TYPE_INSTANT, eImpact, oExplodeTarget);
                    }// end if - There was still damage remaining to be dealt after adjustments
                }// end if - Difficulty check

                // Get next target
                oExplodeTarget = MyNextObjectInShape(SHAPE_SPHERE, fRadius, lTarget, TRUE, OBJECT_TYPE_CREATURE | OBJECT_TYPE_DOOR | OBJECT_TYPE_PLACEABLE);
            }// end while - Explosion target loop
        }// end for - Twin Power
    }// end if - Successfull manifestation
}