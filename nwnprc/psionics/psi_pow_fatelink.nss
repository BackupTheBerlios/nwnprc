/*
   ----------------
   Fate Link

   psi_pow_fatelink
   ----------------

   15/7/05 by Stratovarius
*/ /** @file

    Fate Link

    Clairsentience
    Level: Seer 3
    Manifesting Time: 1 standard action
    Range: Close (25 ft. + 5 ft./2 levels)
    Target: Any two living creatures that are initially no more than 30 ft. apart.
    Duration: 10 min./level
    Saving Throw: Will negates
    Power Resistance: Yes
    Power Points: 5
    Metapsionics: Extend

    You temporarily link the fates of any two creatures, if both fail their
    saving throws. If either linked creature experiences pain, both feel it.
    When one loses hit points, the other loses the same amount. If one takes
    nonlethal damage, so does the other. If one creature is subjected to an
    effect to which it is immune (such as a type of energy damage), the linked
    creature is not subjected to it either. If one dies, the other must
    immediately succeed on a Fortitude save against this power’s save DC or gain
    two negative levels.

    No other effects are transferred by the fate link.

    Augment: For every 2 additional power points you spend, this power’s save DC
    increases by 1.
*/

#include "psi_inc_psifunc"
#include "psi_inc_pwresist"
#include "psi_spellhook"
#include "spinc_common"

void DispelMonitor(object oManifester, object oTarget1, object oTarget2, int nSpellID, int nBeatsRemaining);

void main()
{
    // Are we running the manifestation part or the onhit part?
    if(GetRunningEvent() != EVENT_ONHIT)
    {
        if(!PsiPrePowerCastCode()) return;

        object oManifester  = OBJECT_SELF;
        object oFirstTarget = PRCGetSpellTargetObject();
        struct manifestation manif =
            EvaluateManifestation(oManifester, oFirstTarget,
                                  PowerAugmentationProfile(PRC_NO_GENERIC_AUGMENTS,
                                                           2, PRC_UNLIMITED_AUGMENTATION
                                                           ),
                                  METAPSIONIC_EXTEND
                                  );

        if(manif.bCanManifest)
        {
            int nDC           = GetManifesterDC(oManifester) + manif.nTimesAugOptUsed_1;
            int nPen          = GetPsiPenetration(oManifester);
            int nRacialType;
            effect eVis       = EffectVisualEffect(VFX_IMP_HEAD_MIND);
            effect eDur       = EffectVisualEffect(VFX_DUR_PROTECTION_EVIL_MINOR);
            location lTarget  = GetLocation(oFirstTarget);
            float fRadius     = FeetToMeters(30.0f);
            float fDuration   = 600.0f * manif.nManifesterLevel;
            if(manif.bExtend) fDuration *= 2;

            // Make sure the first target is alive
            nRacialType = MyPRCGetRacialType(oFirstTarget);
            if(nRacialType != RACIAL_TYPE_CONSTRUCT &&
               nRacialType != RACIAL_TYPE_UNDEAD    &&
               !GetIsDead(oFirstTarget)
               )
            {
                // Get the second target to link with the first
                object oSecondTarget = OBJECT_INVALID;
                object oTest = MyFirstObjectInShape(SHAPE_SPHERE, fRadius, lTarget, TRUE, OBJECT_TYPE_CREATURE);
                while(GetIsObjectValid(oTest))
                {
                    // Reasonable targeting
                    if(oTest != oManifester  &&
                       spellsIsTarget(oTest, SPELL_TARGET_SELECTIVEHOSTILE, oManifester)
                       )
                    {
                        // Livingness check
                        nRacialType = MyPRCGetRacialType(oTest);
                        if(nRacialType != RACIAL_TYPE_CONSTRUCT &&
                           nRacialType != RACIAL_TYPE_UNDEAD    &&
                           !GetIsDead(oTest)
                           )
                        {
                            // Found the target
                            oSecondTarget = oTest;
                            // End loop
                            break;
                        }// end if - The target is alive
                    }// end if - Target validity check
                }// end while - Target loop

                // Make sure we have two valid targets
                if(GetIsObjectValid(oFirstTarget) && GetIsObjectValid(oSecondTarget))
                {
                    // Let the AI know
                    SPRaiseSpellCastAt(oFirstTarget, TRUE, manif.nSpellID, oManifester);
                    SPRaiseSpellCastAt(oSecondTarget, TRUE, manif.nSpellID, oManifester);

                    // SR checks
                    if(PRCMyResistPower(oManifester, oFirstTarget, nPen) &&
                       PRCMyResistPower(oManifester, oSecondTarget, nPen)
                       )
                    {
                        if(!PRCMySavingThrow(SAVING_THROW_WILL, oFirstTarget, nDC, SAVING_THROW_TYPE_NONE) &&
                           !PRCMySavingThrow(SAVING_THROW_WILL, oSecondTarget, nDC, SAVING_THROW_TYPE_NONE)
                           )
                        {
                            // No stacking - concurrency issues
                            if(!GetLocalInt(oFirstTarget, "PRC_Power_FateLink_DC") &&
                               !GetLocalInt(oSecondTarget, "PRC_Power_FateLink_DC")
                               )
                            {
                                // Impact visuals
                                SPApplyEffectToObject(DURATION_TYPE_INSTANT, eVis, oFirstTarget);
                                SPApplyEffectToObject(DURATION_TYPE_INSTANT, eVis, oSecondTarget);

                                // VFX for the monitor to look for
                                SPApplyEffectToObject(DURATION_TYPE_TEMPORARY, eDur, oFirstTarget,  fDuration, TRUE, manif.nSpellID, manif.nManifesterLevel);
                                SPApplyEffectToObject(DURATION_TYPE_TEMPORARY, eDur, oSecondTarget, fDuration, TRUE, manif.nSpellID, manif.nManifesterLevel);

                                // Make sure the targets will have an OnHit event fire
                                ExecuteScript("prc_keep_onhit_a", oFirstTarget);
                                ExecuteScript("prc_keep_onhit_a", oSecondTarget);

                                // Set up the Fate Link locals
                                SetLocalInt(oFirstTarget,  "PRC_Power_FateLink_DC", nDC);
                                SetLocalInt(oSecondTarget, "PRC_Power_FateLink_DC", nDC);
                                SetLocalObject(oFirstTarget,  "PRC_Power_FateLink_LinkedTo", oSecondTarget);
                                SetLocalObject(oSecondTarget, "PRC_Power_FateLink_LinkedTo", oFirstTarget);

                                // Set eventscripts
                                AddEventScript(oFirstTarget,  EVENT_ONHIT, "psi_pow_fatelink", TRUE, FALSE);
                                AddEventScript(oSecondTarget, EVENT_ONHIT, "psi_pow_fatelink", TRUE, FALSE);

                                // Start end monitor
                                DelayCommand(6.0f, DispelMonitor(oManifester, oFirstTarget, oSecondTarget,  manif.nSpellID, FloatToInt(fDuration) / 6));
                            }// end if - Neither of the targets is already affected by Fate Link
                        }// end if - Targets failed their saves
                    }// end if - Targets failed SR
                }// end if - Both targets are valid
            }// end if - The first target is living
        }// end if - Successfull manifestation
    }
    // Running OnHit for one of the targets
    else
    {
        object oHit  = OBJECT_SELF;
        object oItem = GetSpellCastItem();

        // Make sure the Fate Linked one was the one hit
        if(GetBaseItemType(oItem) == BASE_ITEM_ARMOR ||
           GetBaseItemType(oItem) == BASE_ITEM_CREATUREITEM
           )
        {
            int nDC        = GetLocalInt(oHit, "PRC_Power_FateLink_DC");
            int nDamage    = GetTotalDamageDealt();
            object oTarget = GetLocalObject(oHit, "PRC_Power_FateLink_LinkedTo");
            effect eDrain  = EffectNegativeLevel(2);
            effect eDamage = EffectDamage(nDamage, DAMAGE_TYPE_MAGICAL);

            // Apply the damage
            ApplyEffectToObject(DURATION_TYPE_INSTANT, eDamage, oTarget);

            // Death checks
            if(GetIsDead(oHit))
            {
                if(!PRCMySavingThrow(SAVING_THROW_WILL, oTarget, nDC, SAVING_THROW_TYPE_NONE))
                {
                    ApplyEffectToObject(DURATION_TYPE_TEMPORARY, eDrain, oTarget, HoursToSeconds(24));
                }
            }
            if(GetIsDead(oTarget))
            {
                if(!PRCMySavingThrow(SAVING_THROW_WILL, oHit, nDC, SAVING_THROW_TYPE_NONE))
                {
                    ApplyEffectToObject(DURATION_TYPE_TEMPORARY, eDrain, oHit, HoursToSeconds(24));
                }
            }
        }// end if - The one being hit had the Fate Link
    }// end if - Running OnHit
}

void DispelMonitor(object oManifester, object oTarget1, object oTarget2, int nSpellID, int nBeatsRemaining)
{
    // Has the power ended since the last beat, or does the duration run out now
    if((--nBeatsRemaining == 0)                                         ||
       GZGetDelayedSpellEffectsExpired(nSpellID, oTarget1, oManifester) ||
       GZGetDelayedSpellEffectsExpired(nSpellID, oTarget2, oManifester)
       )
    {
        if(DEBUG) DoDebug("psi_pow_fatelink: Clearing");
        // Clear the effect presence marker
        DeleteLocalInt(oTarget1, "PRC_Power_FateLink_DC");
        DeleteLocalInt(oTarget2, "PRC_Power_FateLink_DC");
        DeleteLocalObject(oTarget1, "PRC_Power_FateLink_LinkedTo");
        DeleteLocalObject(oTarget2, "PRC_Power_FateLink_LinkedTo");
        // Remove the eventscript
        RemoveEventScript(oTarget1, EVENT_ONHIT, "psi_pow_fatelink", TRUE, FALSE);
        RemoveEventScript(oTarget2, EVENT_ONHIT, "psi_pow_fatelink", TRUE, FALSE);

        // Remove remaining effects
        RemoveSpellEffects(nSpellID, oManifester, oTarget1);
        RemoveSpellEffects(nSpellID, oManifester, oTarget2);
    }
    else
       DelayCommand(6.0f, DispelMonitor(oManifester, oTarget1, oTarget2, nSpellID, nBeatsRemaining));
}
