/*
   ----------------
   Shadow Body

   psi_pow_shadbody
   ----------------

   27/3/05 by Stratovarius
*/ /** @file

    Shadow Body

    Psychometabolism
    Level: Psion/wilder 8
    Manifesting Time: 1 standard action
    Range: Personal
    Target: You
    Duration: 1 min./level
    Power Points: 15
    Metapsionics: Extend

    Your body and all your equipment are subsumed by your shadow. As a living
    shadow, you drift in and out of the shadow plane, giving you total
    concealement (50% miss chance).

    While in your shadow body, you gain damage reduction 10/+1 and darkvision.
    You are immune to extra damage from critical hits, ability damage, disease,
    drowning, and poison. You take only half damage from acid, electricity, and
    fire of all kinds.

    While affected by this power, you can be detected by powers that read
    thoughts, life, or presences (including true seeing).

    If you take any hostile actions, you will return fully to the Prime Material
    plane for a round.
*/

#include "psi_inc_psifunc"
#include "psi_inc_pwresist"
#include "psi_spellhook"
#include "spinc_common"
#include "prc_inc_teleport"

void GoInvis(struct manifestation manif, object oTarget)
{
    // Check for effect expiration
    if(!GZGetDelayedSpellEffectsExpired(manif.nSpellID, oTarget, manif.oManifester))
    {
        effect eInvis   = EffectInvisibility(INVISIBILITY_TYPE_NORMAL);
       	effect eConceal = EffectConcealment(50);
       	effect eLink    = EffectLinkEffects(eInvis, eConceal);
       	SPApplyEffectToObject(DURATION_TYPE_TEMPORARY, eLink, oTarget, 6.0f, TRUE, manif.nSpellID, manif.nManifesterLevel);
        DelayCommand(6.0f, GoInvis(manif, oTarget));
    }
}

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
                              PowerAugmentationProfile(),
                              METAPSIONIC_EXTEND
                              );

    if(manif.bCanManifest)
    {
        effect eLink =                          EffectDamageReduction(10, DAMAGE_POWER_PLUS_ONE);
               eLink = EffectLinkEffects(eLink, EffectUltravision());
               eLink = EffectLinkEffects(eLink, EffectImmunity(IMMUNITY_TYPE_CRITICAL_HIT));
               eLink = EffectLinkEffects(eLink, EffectImmunity(IMMUNITY_TYPE_ABILITY_DECREASE));
               eLink = EffectLinkEffects(eLink, EffectImmunity(IMMUNITY_TYPE_DISEASE));
               eLink = EffectLinkEffects(eLink, EffectSpellImmunity(SPELL_DROWN));
               eLink = EffectLinkEffects(eLink, EffectImmunity(IMMUNITY_TYPE_POISON));
               eLink = EffectLinkEffects(eLink, EffectDamageImmunityIncrease(DAMAGE_TYPE_ACID,       50));
               eLink = EffectLinkEffects(eLink, EffectDamageImmunityIncrease(DAMAGE_TYPE_ELECTRICAL, 50));
               eLink = EffectLinkEffects(eLink, EffectDamageImmunityIncrease(DAMAGE_TYPE_FIRE,       50));
               eLink = EffectLinkEffects(eLink, EffectVisualEffect(PSI_DUR_SHADOW_BODY));
        effect eVis  = EffectVisualEffect(VFX_IMP_MAGIC_PROTECTION);
        float fDuration = 60.0f * manif.nManifesterLevel;
        if(manif.bExtend) fDuration *= 2;

        // Make sure the target is not prevented from extra-dimensional movement
        if(GetCanTeleport(oTarget, GetLocation(oTarget), FALSE, TRUE))
        {
            SPApplyEffectToObject(DURATION_TYPE_TEMPORARY, eLink, oTarget, fDuration, TRUE, manif.nSpellID, manif.nManifesterLevel);
            SPApplyEffectToObject(DURATION_TYPE_INSTANT, eVis, oTarget);
            GoInvis(manif, oTarget);
        }// end if - The target can move extradimensionally
    }// end if - Successfull manifestation
}