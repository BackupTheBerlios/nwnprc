/*
   ----------------
   Empathic Transfer, Hostile

   psi_pow_emptrnh
   ----------------

   19/4/05 by Stratovarius
*/ /** @file

    Empathic Transfer, Hostile

    Telepathy [Mind-Affecting]
    Level: Telepath 3, psychic warrior 3
    Manifesting Time: 1 standard action
    Range: Touch
    Target: Creature touched
    Duration: Instantaneous
    Saving Throw: Will half
    Power Resistance: Yes
    Power Points: 5
    Metapsionics: Twin, Widen

    You transfer your hurt to another. When you manifest this power and then
    make a successful touch attack, you can transfer 50 points of damage (or
    less, if you choose) from yourself to the touched creature. You immediately
    regain hit points equal to the amount of damage you transfer.

    You cannot use this power to gain hit points in excess of your full normal
    total. The transferred damage is empathic in nature, so powers and abilities
    the subject may have such as damage reduction and regeneration do not lessen
    or change this damage.

    The damage transferred by this power has no type, so even if the subject has
    immunity to the type of damage you originally took, the transfer occurs
    normally and deals hit point damage to the subject.

    Augment: You can augment this power in one or both of the following ways.
    1. For every additional power point you spend, you can transfer an additional
       10 points of damage (maximum 90 points per manifestation).
    2. If you spend 6 additional power points, this power affects all creatures
       in a 20-foot-radius spread centered on you. The amount of damage
       transferred is divided evenly among all hostile creatures in the area.

*/

#include "psi_inc_psifunc"
#include "psi_inc_pwresist"
#include "psi_spellhook"
#include "spinc_common"

void AvoidDR(object oTarget, int nDamage);

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
                                                       1, 4,
                                                       6, 1
                                                       ),
                              METAPSIONIC_TWIN | METAPSIONIC_WIDEN
                              );

    if(manif.bCanManifest)
    {
        int nDC          = GetManifesterDC(oManifester);
        int nPen         = GetPsiPenetration(oManifester);
        int nMaxTran     = min(50 + (10 * manif.nTimesAugOptUsed_1),                           // Maximum transferrable is 50 + 10* augmentation
                               GetMaxHitPoints(oManifester) - GetCurrentHitPoints(oManifester) // Limited to the amount of damage the manifester has actually suffered
                               );
        float fRadius    = EvaluateWidenPower(manif, FeetToMeters(20.0f));
        location lTarget = PRCGetSpellTargetLocation();

        // Handle Twin Power
        int nRepeats = manif.bTwin ? 2 : 1;
        for(; nRepeats > 0; nRepeats--)
        {
            // Touch or burst
            if(manif.nTimesAugOptUsed_2 != 1)
            {
                // Let the AI know
                SPRaiseSpellCastAt(oTarget, TRUE, manif.nSpellID, oManifester);

                // Try to touch the single target
                if(PRCDoMeleeTouchAttack(oTarget) > 0) // No need to store the result, critical hits nor precision-based damage work with this power
                {
                    // Mind-affecting immunity
                    if(!GetIsImmune(oTarget, IMMUNITY_TYPE_MIND_SPELLS))
                    {
                        if(PRCMyResistPower(oManifester, oTarget, nPen))
                        {
                            // Save for half
                            if(PRCMySavingThrow(SAVING_THROW_WILL, oTarget, nDC, SAVING_THROW_TYPE_MIND_SPELLS))
                            {
                                nMaxTran /= 2;
                    		
                    		if (GetHasMettle(oTarget, SAVING_THROW_WILL)) // Ignores partial effects
                    		{
                			nMaxTran = 0;
                    		}                                  
                            }

                            // Apply the healing
                            effect eHeal = EffectHeal(nMaxTran);
                            SPApplyEffectToObject(DURATION_TYPE_INSTANT, eHeal, oManifester);

                            // Use some trickery to attempt passing damage resistance / immunity
                            AvoidDR(oTarget, nMaxTran);
                        }// end if - SR check
                    }// end if - Mind-affecting immunity check
                }// end if - Hit with a touch attack
            }// end if - Single target
            else
            {
                // Delete the array if one exists already
                if(array_exists(oManifester, "PRC_Power_EmpTranHostile_Targets"))
                    array_delete(oManifester, "PRC_Power_EmpTranHostile_Targets");
                // Create array
                array_create(oManifester, "PRC_Power_EmpTranHostile_Targets");

                // Determine eligible targets
                oTarget = MyFirstObjectInShape(SHAPE_SPHERE, fRadius, lTarget, TRUE, OBJECT_TYPE_CREATURE);
                while(GetIsObjectValid(oTarget))
                {
                    if(oTarget != oManifester                                             && // Only hurt other people
                       //!GetIsImmune(oTarget, IMMUNITY_TYPE_MIND_SPELLS)                   && // Mind-affecting immunity check
                       spellsIsTarget(oTarget, SPELL_TARGET_SELECTIVEHOSTILE, oManifester)   // User can select targets
                       )
                    {
                        // Add target to list
                        array_set_object(oManifester, "PRC_Power_EmpTranHostile_Targets",
                	                     array_get_size(oManifester, "PRC_Power_EmpTranHostile_Targets"),
                	                     oTarget
                	                     );
                    }// end if - Is this something to target?
                }// end while - Target getting loop

                // Calculate damage per target
                int nDamagePerTarget = nMaxTran / array_get_size(oManifester, "PRC_Power_EmpTranHostile_Targets");
                // Calculate the remainder. This will be applied only to the first target
                int nRemainder       = nMaxTran - (nDamagePerTarget * array_get_size(oManifester, "PRC_Power_EmpTranHostile_Targets"));
                int nDamage;

                // Loop over targets and apply damage
                int i;
                for(i = 0; i < array_get_size(oManifester, "PRC_Power_EmpTranHostile_Targets"); i++)
                {
                    // Let the AI know
                    SPRaiseSpellCastAt(oTarget, TRUE, manif.nSpellID, oManifester);

                    // Mind-affecting immunity
                    if(!GetIsImmune(oTarget, IMMUNITY_TYPE_MIND_SPELLS))
                    {
                        if(PRCMyResistPower(oManifester, oTarget, nPen))
                        {
                            // Set the initial damage
                            nDamage = nDamagePerTarget;
                            if(i == 0) nDamage += nRemainder; // First target may get extra

                            // Save for half
                            if(PRCMySavingThrow(SAVING_THROW_WILL, oTarget, nDC, SAVING_THROW_TYPE_MIND_SPELLS))
                            {
                                nDamage /= 2;
                            }

                            // Apply the healing
                            effect eHeal = EffectHeal(nDamage);
                            SPApplyEffectToObject(DURATION_TYPE_INSTANT, eHeal, oManifester);

                            // Use some trickery to attempt passing damage resistance / immunity
                            AvoidDR(oTarget, nDamage);
                        }// end if - SR check
                    }// end if - Mind-affecting immunity check
                }// end for - Target affecting loop
            }// end else - Augmented to affect an area
        }// end for - Twin Power
    }// end if - Successfull manifestation
}

void AvoidDR(object oTarget, int nDamage)
{
    int nCurHP         = GetCurrentHitPoints(oTarget);
    int nTargetHP      = nCurHP - nDamage;
    int nDamageToApply = nDamage;
    effect eDamage;

    // Try magical damage
    eDamage = EffectDamage(nDamageToApply, DAMAGE_TYPE_MAGICAL);
    ApplyEffectToObject(DURATION_TYPE_INSTANT, eDamage, oTarget);

    // Check if the target's HP dropped enough. Skip if the target died on the way
    if(GetCurrentHitPoints(oTarget) > nTargetHP && !GetIsDead(oTarget))
    {
        // Didn't, try again, this time with Divine damage
        nDamageToApply = GetCurrentHitPoints(oTarget) - nTargetHP;

        eDamage = EffectDamage(nDamageToApply, DAMAGE_TYPE_DIVINE);
        ApplyEffectToObject(DURATION_TYPE_INSTANT, eDamage, oTarget);

        // Check if the target's HP dropped enough. Skip if the target died on the way
        if(GetCurrentHitPoints(oTarget) > nTargetHP && !GetIsDead(oTarget))
        {
            // Didn't, try again, this time with Positive damage
            nDamageToApply = GetCurrentHitPoints(oTarget) - nTargetHP;

            eDamage = EffectDamage(nDamageToApply, DAMAGE_TYPE_POSITIVE);
            ApplyEffectToObject(DURATION_TYPE_INSTANT, eDamage, oTarget);

            // If it still didn't work, just give up. The blighter probably has immunities to everything else, too, anyway
            return;
        }
    }
}
