/*
   ----------------
   Energy Push

   psi_pow_enpush
   ----------------

   6/11/04 by Stratovarius
*/ /** @file
    Energy Push

    Psychokinesis [see text]
    Level: Psion/wilder 2
    Manifesting Time: 1 standard action
    Range: Medium (100 ft. + 10 ft./ level)
    Duration: Instantaneous
    Saving Throw: Reflex half or Fortitude half; see text
    Power Resistance: Yes
    Power Points: 3
    Metapsionics: Chain, Empower, Maximize, Twin

    Upon manifesting this power, you choose cold, electricity, fire, or sonic.
    You project a solid blast of energy of the chosen type at a target, dealing
    it 2d6 points of damage. In addition, if a subject of up to one size
    category larger than you fails a Strength check (DC equal to the save DC of
    this power), the driving force of the energy blast pushes it back 5 feet
    plus another 5 feet for every 5 points of damage it takes. If a wall or
    other solid object prevents the subject from being pushed back, the subject
    instead slams into the object and takes an extra 2d6 points of damage from
    the impact (no save).

    Cold: A blast of this energy type deals +1 point of damage per die (damage
          from impact remains at 2d6 points). The saving throw to reduce damage
          from a cold push is a Fortitude save instead of a Reflex save.
    Electricity: Manifesting a blast of this energy type provides a +2 bonus to
                 the save DC and a +2 bonus on manifester level checks for the
                 purpose of overcoming power resistance.
    Fire: A blast of this energy type deals +1 point of damage per die (damage
          from impact remains at 2d6 points).
    Sonic: A blast of this energy type deals -1 point of damage per die (damage
           from impact remains at 2d6 points) and ignores an object�s hardness.

    This power�s subtype is the same as the type of energy you manifest.

    Augment: For every 2 additional power points you spend, this power�s damage
             increases by one die (d6) and its save DC increases by 1. The damage
             increase applies to both the initial blast and any damage from
             impact with an object.
*/

#include "psi_inc_psifunc"
#include "psi_inc_pwresist"
#include "psi_spellhook"
#include "spinc_common"
#include "psi_inc_enrgypow"

void DoPush(object oTarget, object oManifester, int nDC, int nNumberOfDice, int nDamageDealt);

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
        struct energy_adjustments enAdj =
            EvaluateEnergy(manif.nSpellID, POWER_ENERGYPUSH_COLD, POWER_ENERGYPUSH_ELEC, POWER_ENERGYPUSH_FIRE, POWER_ENERGYPUSH_SONIC,
                           VFX_BEAM_COLD, VFX_BEAM_LIGHTNING, VFX_BEAM_FIRE, VFX_BEAM_MIND);

        int nDC           = GetManifesterDC(oManifester) + manif.nTimesAugOptUsed_1 + enAdj.nDCMod;
        int nPen          = GetPsiPenetration(oManifester) + enAdj.nPenMod;
        int nNumberOfDice = 2 + manif.nTimesAugOptUsed_1;
        int nDieSize      = 6;
        int nOriginalDamage, nDamage, i;
        effect eVis       = EffectVisualEffect(enAdj.nVFX1);
        effect eRay       = EffectBeam(enAdj.nVFX2, oManifester, BODY_NODE_HAND);
        effect eDamage;
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
            // Make an SR check
            if(PRCMyResistPower(oManifester, oMainTarget, nPen))
            {
                // Roll damage
                nDamage = MetaPsionicsDamage(manif, nDieSize, nNumberOfDice, 0, enAdj.nBonusPerDie, TRUE, FALSE);
                // Target-specific stuff
                nDamage = GetTargetSpecificChangesToDamage(oMainTarget, oManifester, nDamage, TRUE, TRUE);

                // Do save
                if(enAdj.nSaveType == SAVING_THROW_TYPE_COLD)
                {
                    // Cold has a fort save for half
                    if(PRCMySavingThrow(SAVING_THROW_FORT, oMainTarget, nDC, enAdj.nSaveType))
                        nDamage /= 2;
                }
                else
                    // Adjust damage according to Reflex Save, Evasion or Improved Evasion
                    nDamage = PRCGetReflexAdjustedDamage(nDamage, oMainTarget, nDC, enAdj.nSaveType);

                // Apply VFX and damage to chained target, assuming there is still damage left to deal after modification
                if(nDamage > 0)
                {
                    // Apply damage
                    eDamage = EffectDamage(nDamage, enAdj.nDamageType);
                    SPApplyEffectToObject(DURATION_TYPE_INSTANT, eDamage, oMainTarget);
                    SPApplyEffectToObject(DURATION_TYPE_INSTANT, eVis, oMainTarget);
                    SPApplyEffectToObject(DURATION_TYPE_TEMPORARY, eRay, oMainTarget, 1.7, FALSE);
                    // Do the push effect on the target
                    DoPush(oMainTarget, oManifester, nDC, nNumberOfDice, nDamage);

                    // Apply damage to Chain targets
                    if(manif.bChain)
                    {
                        // Halve the damage
                        nOriginalDamage = nDamage / 2;

                        for(i = 0; i < array_get_size(oManifester, PRC_CHAIN_POWER_ARRAY); i++)
                        {
                            oChainTarget = array_get_object(oManifester, PRC_CHAIN_POWER_ARRAY, i);

                            // Determine damage
                            nDamage = nOriginalDamage;
                            // Target-specific stuff
                            nDamage = GetTargetSpecificChangesToDamage(oChainTarget, oManifester, nDamage, TRUE, TRUE);

                            // Do save
                            if(enAdj.nSaveType == SAVING_THROW_TYPE_COLD)
                            {
                                // Cold has a fort save for half
                                if(PRCMySavingThrow(SAVING_THROW_FORT, oChainTarget, nDC, enAdj.nSaveType))
                                    nDamage /= 2;
                            }
                            else
                                // Adjust damage according to Reflex Save, Evasion or Improved Evasion
                                nDamage = PRCGetReflexAdjustedDamage(nDamage, oChainTarget, nDC, enAdj.nSaveType);

                            // Apply VFX and damage to chained target, assuming there is still damage left to deal after modification
                            if(nDamage > 0)
                            {
                                eDamage = EffectDamage(nDamage, enAdj.nDamageType);
                                SPApplyEffectToObject(DURATION_TYPE_INSTANT, eDamage, oChainTarget);
                                SPApplyEffectToObject(DURATION_TYPE_INSTANT, eVis, oChainTarget);
                                SPApplyEffectToObject(DURATION_TYPE_TEMPORARY, EffectBeam(enAdj.nVFX2, oMainTarget, BODY_NODE_CHEST), oChainTarget, 1.7, FALSE);
                                // Do the push effect on the target
                                DoPush(oChainTarget, oManifester, nDC, nNumberOfDice, nDamage);
                            }// end if - There was still damage remaining to be dealt after adjustments
                        }// end for - Chain targets
                    }// end if - Chain Power
                }// end if - There was still damage remaining to be dealt after adjustments
            }// end if - SR check
        }// end for - Twin Power
    }// end if - Successfull manifestation
}

void DoPush(object oTarget, object oManifester, int nDC, int nNumberOfDice, int nDamageDealt)
{
    // Check size
    if(PRCGetCreatureSize(oTarget) <= (PRCGetCreatureSize(oManifester) + 1))
    {
        // Check STR
        if((d20() + GetAbilityModifier(ABILITY_STRENGTH, oTarget)) < nDC)
        {
            /// @todo Write the pushing part of Energy Push
            // Calculate how far the creature gets pushed
            float fDistance = FeetToMeters(5.0f) * (1 + (nDamageDealt / 5));
            // Determine if they hit a wall on the way
            location lManifester   = GetLocation(oManifester);
            location lTargetOrigin = GetLocation(oTarget);
            vector vAngle          = AngleToVector(GetRelativeAngleBetweenLocations(lManifester, lTargetOrigin));
            vector vTargetOrigin   = GetPosition(oTarget);
            vector vTarget         = vTargetOrigin + (vAngle * fDistance);

            if(!LineOfSightVector(vTargetOrigin, vTarget))
            {
                // Hit a wall, binary search for the wall
                float fEpsilon    = 1.0f; // Search precision
                float fLowerBound = 0.0f;
                float fUpperBound = fDistance;

                do{
                    // Create test vector for this iteration
                    vTarget = vTargetOrigin + (vAngle * fDistance);

                    // Determine which bound to move.
                    if(LineOfSightVector(vTargetOrigin, vTarget))
                        fLowerBound = fDistance;
                    else
                        fUpperBound = fDistance;

                    // Get the new middle point
                    fDistance = (fUpperBound + fLowerBound) / 2;
                }while(fabs(fUpperBound - fLowerBound) > fEpsilon);

                // Create the final target vector
                vTarget = vTargetOrigin + (vAngle * fDistance);

                // Determine damage and apply it
                int nDamage = d6(nNumberOfDice); // Assume the die size stays static
                effect eDamage = EffectDamage(nDamage, DAMAGE_TYPE_BLUDGEONING, DAMAGE_POWER_ENERGY); // Slamming into a solid object
                SPApplyEffectToObject(DURATION_TYPE_INSTANT, eDamage, oTarget);
            }

            // Move the target
            location lTargetDestination = Location(GetArea(oTarget), vTarget, GetFacing(oTarget));
            AssignCommand(oTarget, ClearAllActions(TRUE));
            AssignCommand(oTarget, JumpToLocation(lTargetDestination));
        }
    }
}
