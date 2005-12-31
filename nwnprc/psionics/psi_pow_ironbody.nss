/*
   ----------------
   Iron Body, Psionic

   psi_pow_ironbody
   ----------------

   25/2/04 by Stratovarius
*/ /** @file

    Iron Body, Psionic

    Metacreativity (Creation)
    Level: Psion/wilder 8
    Manifesting Time: 1 standard action
    Range: Personal
    Target: You
    Duration: 1 min./level
    Power Points: 15
    Metapsionics: Extend

    This power transforms your body into living iron, which grants you several
    powerful resistances and abilities.

    You gain damage reduction 15/+5. You are immune to blindness, critical hits,
    ability score damage, deafness, disease, drowning, electricity, poison, and
    stunning. You take only half damage from acid and fire of all kinds.

    You gain a +6 enhancement bonus to your Strength score, but you take a �6
    penalty to Dexterity as well (to a minimum Dexterity score of 1), and your
    speed is reduced to half normal. You have an arcane spell failure chance of
    50%, just as if you were clad in full plate armor.
*/

#include "psi_inc_psifunc"
#include "psi_inc_pwresist"
#include "psi_spellhook"
#include "X0_I0_SPELLS"

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
        effect eLink    =                          EffectDamageReduction(15, DAMAGE_POWER_PLUS_FIVE);
               eLink    = EffectLinkEffects(eLink, EffectImmunity(IMMUNITY_TYPE_BLINDNESS));
               eLink    = EffectLinkEffects(eLink, EffectImmunity(IMMUNITY_TYPE_CRITICAL_HIT));
               eLink    = EffectLinkEffects(eLink, EffectImmunity(IMMUNITY_TYPE_ABILITY_DECREASE));
               eLink    = EffectLinkEffects(eLink, EffectImmunity(IMMUNITY_TYPE_DEAFNESS));
               eLink    = EffectLinkEffects(eLink, EffectImmunity(IMMUNITY_TYPE_DISEASE));
               eLink    = EffectLinkEffects(eLink, EffectSpellImmunity(SPELL_DROWN));
               eLink    = EffectLinkEffects(eLink, EffectDamageImmunityIncrease(DAMAGE_TYPE_ELECTRICAL, 100));
               eLink    = EffectLinkEffects(eLink, EffectImmunity(IMMUNITY_TYPE_POISON));
               eLink    = EffectLinkEffects(eLink, EffectImmunity(IMMUNITY_TYPE_STUN));
               eLink    = EffectLinkEffects(eLink, EffectDamageImmunityIncrease(DAMAGE_TYPE_ACID, 50));
               eLink    = EffectLinkEffects(eLink, EffectDamageImmunityIncrease(DAMAGE_TYPE_FIRE, 50));
               eLink    = EffectLinkEffects(eLink, EffectAbilityIncrease(ABILITY_STRENGTH, 6));
               eLink    = EffectLinkEffects(eLink, EffectMovementSpeedDecrease(50));
               eLink    = EffectLinkEffects(eLink, EffectSpellFailure(50, SPELL_SCHOOL_GENERAL));
               eLink    = EffectLinkEffects(eLink, EffectVisualEffect(VFX_DUR_BLUR));
               eLink    = EffectLinkEffects(eLink, EffectVisualEffect(VFX_DUR_GLOBE_INVULNERABILITY));
               eLink    = EffectLinkEffects(eLink, EffectVisualEffect(VFX_DUR_PROT_SHADOW_ARMOR));
               eLink    = EffectLinkEffects(eLink, EffectVisualEffect(VFX_DUR_PROTECTION_ELEMENTS));
        effect eVis     =                         EffectVisualEffect(VFX_IMP_HEAD_ODD);
               eVis     = EffectLinkEffects(eVis, EffectVisualEffect(VFX_FNF_MYSTICAL_EXPLOSION));
               eVis     = EffectLinkEffects(eVis, EffectVisualEffect(VFX_IMP_IMPROVE_ABILITY_SCORE));
        float fDuration = 60.0f * manif.nManifesterLevel;
        if(manif.bExtend) fDuration *= 2;

        SPApplyEffectToObject(DURATION_TYPE_TEMPORARY, eLink, oTarget, fDuration, TRUE, manif.nSpellID, manif.nManifesterLevel);
        SPApplyEffectToObject(DURATION_TYPE_INSTANT, eVis, oTarget);
        ApplyAbilityDamage(oTarget, ABILITY_DEXTERITY, 6, DURATION_TYPE_TEMPORARY, FALSE, fDuration, TRUE, manif.nSpellID, manif.nManifesterLevel);
    }
}
