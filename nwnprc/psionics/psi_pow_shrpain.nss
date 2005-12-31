/*
   ----------------
   Share Pain

   psi_pow_shrpain
   ----------------

   19/2/04 by Stratovarius
*/ /** @file

    Share Pain

    Psychometabolism
    Level: Psion/wilder 2
    Manifesting Time: 1 standard action
    Range: Touch
    Targets: You and one willing creature
    Duration: 1 hour/level
    Power Points: 3
    Metapsionics: Extend

    This power creates a psychometabolic connection between you and a willing
    subject so that some of your wounds are transferred to the subject. You take
    half damage from all attacks that deal hit point damage to you, and the
    subject takes the remainder. The amount of damage not taken by you is taken
    by the subject. If your hit points are reduced by a lowered Constitution
    score, that reduction is not shared with the subject because it is not a
    form of hit point damage. When this power ends, subsequent damage is no
    longer divided between the subject and you, but damage already shared is not
    reassigned.

    If you and the subject move farther away from each other than close range,
    the power ends.


    Implementation notes:
    You may not have more than one Share Pain or Share Pain, Forced active at
    any one time. Any subsequent uses override the previous.
    We're lazy bastards :P
*/

#include "psi_inc_psifunc"
#include "psi_inc_pwresist"
#include "psi_spellhook"
#include "spinc_common"

void DispelMonitor(object oManifester, object oTarget, int nSpellID, int nManifesterLevel, int nBeatsRemaining);

void main()
{
    // Power use hook
    if(!PsiPrePowerCastCode()) return;

    object oManifester = OBJECT_SELF;
    object oTarget     = PRCGetSpellTargetObject();
    struct manifestation manif =
        EvaluateManifestation(oManifester, oTarget,
                              PowerAugmentationProfile(),
                              METAPSIONIC_EXTEND
                              );

    if(manif.bExtend)
    {
        effect eDur     = EffectVisualEffect(VFX_DUR_MIND_AFFECTING_POSITIVE);
        float fDuration = HoursToSeconds(manif.nManifesterLevel);
        if(manif.bExtend) fDuration *= 2;

        // Let the AI know
        SPRaiseSpellCastAt(oTarget, FALSE, manif.nSpellID, oManifester);

        // Get the OnHitCast: Unique on the manifester's armor / hide
        ExecuteScript("prc_keep_onhit_a", oManifester);

        // Hook eventscript
        AddEventScript(oManifester, EVENT_ONHIT, "psi_pow_shrpnaux", TRUE, FALSE);

        // Store the target for use in the damage script
        SetLocalObject(oManifester, "PRC_Power_SharePain_Target", oTarget);

        // Do VFX for the monitor to look for
        SPApplyEffectToObject(DURATION_TYPE_TEMPORARY, eDur, oTarget,     fDuration, TRUE, manif.nSpellID, manif.nManifesterLevel);
        SPApplyEffectToObject(DURATION_TYPE_TEMPORARY, eDur, oManifester, fDuration, TRUE, manif.nSpellID, manif.nManifesterLevel);

        // Start effect end monitor
        DelayCommand(6.0f, DispelMonitor(oManifester, oTarget, manif.nSpellID, manif.nManifesterLevel, FloatToInt(fDuration) / 6));
    }// end if - Successfull manifestation
}

void DispelMonitor(object oManifester, object oTarget, int nSpellID, int nManifesterLevel, int nBeatsRemaining)
{
    // Has the power ended since the last beat, or does the duration run out now
    if((--nBeatsRemaining == 0)                                            ||
       GetIsDead(oTarget)                                                  ||
       GZGetDelayedSpellEffectsExpired(nSpellID, oTarget, oManifester)     ||
       GZGetDelayedSpellEffectsExpired(nSpellID, oManifester, oManifester) ||
       GetDistanceBetween(oManifester, oTarget) > FeetToMeters(25.0f + (5.0f * (nManifesterLevel / 2)))
       )
    {
        if(DEBUG) DoDebug("psi_pow_shrpain: Effect expired, clearing");
        // Clear the target local
        DeleteLocalObject(oManifester, "PRC_Power_SharePain_Target");
        // Remove the eventscript
        RemoveEventScript(oManifester, EVENT_ONHIT, "psi_pow_shrpnaux", TRUE, FALSE);

        // Remove remaining effects
        RemoveSpellEffects(nSpellID, oManifester, oTarget);
        RemoveSpellEffects(nSpellID, oManifester, oManifester);
    }
    else
       DelayCommand(6.0f, DispelMonitor(oManifester, oTarget, nSpellID, nManifesterLevel, nBeatsRemaining));
}
