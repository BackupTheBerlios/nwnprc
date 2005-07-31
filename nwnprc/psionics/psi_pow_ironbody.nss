/*
   ----------------
   Iron Body
   
   prc_pow_ironbody
   ----------------

   25/2/04 by Stratovarius

   Class: Psion/Wilder
   Power Level: 8
   Range: Personal
   Target: Self
   Duration: 1 Min/level
   Saving Throw: None
   Power Resistance: No
   Power Point Cost: 15
   
   You transform into a body of living iron. This grants you Damage Reduction 15/+5, Immunity to Blindness, Deafness,
   Disease, Poison, Stunning, Critical Hits, Ability Drain, Electricity, Drowning, 50% Fire Immunity, 50% Acid Immunity,
   +6 to Strength, -6 Dexterity, 50% Arcane Spell Failure and 50% movement speed.
*/

#include "psi_inc_psifunc"
#include "psi_inc_pwresist"
#include "psi_spellhook"
#include "X0_I0_SPELLS"

void main()
{
DeleteLocalInt(OBJECT_SELF, "PSI_MANIFESTER_CLASS");
SetLocalInt(OBJECT_SELF, "PSI_MANIFESTER_CLASS", 0);

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

    object oCaster = OBJECT_SELF;
    object oTarget = GetSpellTargetObject();
    int nAugCost = 0;
    int nMetaPsi = GetCanManifest(oCaster, nAugCost, oTarget, 0, 0, METAPSIONIC_EXTEND, 0, 0, 0, 0);

    if (nMetaPsi > 0)
    {
        int nCaster = GetManifesterLevel(oCaster);
        float fDur = (nCaster * 60.0);
        if (nMetaPsi == 2)	fDur *= 2;

        //Massive effect linkage, go me
        effect eBlind = EffectImmunity(IMMUNITY_TYPE_BLINDNESS);
        effect eCrit = EffectImmunity(IMMUNITY_TYPE_CRITICAL_HIT);
        effect eDeaf = EffectImmunity(IMMUNITY_TYPE_DEAFNESS);
        effect eDrain = EffectImmunity(IMMUNITY_TYPE_ABILITY_DECREASE);
        effect eDisease = EffectImmunity(IMMUNITY_TYPE_DISEASE);
        effect ePoison = EffectImmunity(IMMUNITY_TYPE_POISON);
        effect eStun = EffectImmunity(IMMUNITY_TYPE_STUN);
        effect eStr = EffectAbilityIncrease(ABILITY_STRENGTH, 6);
        //effect eDex = EffectAbilityDecrease(ABILITY_DEXTERITY, 6);
        effect eElec = EffectDamageImmunityIncrease(DAMAGE_TYPE_ELECTRICAL, 50);
        effect eFire = EffectDamageImmunityIncrease(DAMAGE_TYPE_FIRE, 50);
        effect eAcid = EffectDamageImmunityIncrease(DAMAGE_TYPE_ACID, 50);
        effect eMove = EffectMovementSpeedDecrease(50);
        effect eDR = EffectDamageReduction(15, DAMAGE_POWER_PLUS_FIVE);
        effect eDrown = EffectSpellImmunity(SPELL_DROWN);
        effect eSpell = EffectSpellFailure(50,SPELL_SCHOOL_GENERAL);

        effect eVis1 = EffectVisualEffect(VFX_DUR_BLUR);
        effect eVis2 = EffectVisualEffect(VFX_DUR_GLOBE_INVULNERABILITY);
        effect eVis3 = EffectVisualEffect(VFX_DUR_PROT_SHADOW_ARMOR);
        effect eVis4 = EffectVisualEffect(VFX_DUR_PROTECTION_ELEMENTS);
        // Apply as instant
        effect eVis5 = EffectVisualEffect(VFX_IMP_HEAD_ODD);
        effect eVis6 = EffectVisualEffect(VFX_FNF_MYSTICAL_EXPLOSION);
        effect eVis7 = EffectVisualEffect(VFX_IMP_IMPROVE_ABILITY_SCORE);

        effect eLink = EffectLinkEffects(eBlind, eDeaf);
        eLink = EffectLinkEffects(eLink, eCrit);
        eLink = EffectLinkEffects(eLink, eDrain);
        eLink = EffectLinkEffects(eLink, eDisease);
        eLink = EffectLinkEffects(eLink, ePoison);
        eLink = EffectLinkEffects(eLink, eStun);
        eLink = EffectLinkEffects(eLink, eStr);
        //eLink = EffectLinkEffects(eLink, eDex);
        eLink = EffectLinkEffects(eLink, eElec);
        eLink = EffectLinkEffects(eLink, eFire);
        eLink = EffectLinkEffects(eLink, eAcid);
        eLink = EffectLinkEffects(eLink, eMove);
        eLink = EffectLinkEffects(eLink, eDR);
        eLink = EffectLinkEffects(eLink, eDrown);
        eLink = EffectLinkEffects(eLink, eSpell);
        eLink = EffectLinkEffects(eLink, eVis1);
        eLink = EffectLinkEffects(eLink, eVis2);
        eLink = EffectLinkEffects(eLink, eVis3);
        eLink = EffectLinkEffects(eLink, eVis4);

        effect eLink2 = EffectLinkEffects(eVis5, eVis6);
        eLink2 = EffectLinkEffects(eLink2, eVis7);

        SPApplyEffectToObject(DURATION_TYPE_TEMPORARY, eLink, oTarget, fDur,TRUE,-1,nCaster);
        SPApplyEffectToObject(DURATION_TYPE_INSTANT, eLink2, oTarget);
        ApplyAbilityDamage(oTarget, ABILITY_DEXTERITY, 6, DURATION_TYPE_TEMPORARY, FALSE, fDur, -1, nCaster);
    }
}