/*
   ----------------
   Oak Body
   
   prc_pow_oakbody
   ----------------

   25/2/04 by Stratovarius

   Class: Psion/Wilder, Psychic Warrior
   Power Level: 7 P/W, 5 PsyWar
   Range: Personal
   Target: Self
   Duration: 1 Min/level
   Saving Throw: None
   Power Resistance: No
   Power Point Cost: P/W 13, PsyWar 9
   
   You gain the advantages of a living oak. This grants you Damage Reduction 10/+2, +5 Natural Armour, Immunity to Blindness, Deafness,
   Disease, Poison, Stunning, 50% Cold Immunity, +4 to Strength, Immunity to Drown, 50% Fire Vulnerability, -2 Dexterity, 
   25% Arcane Spell Failure and 50% movement speed.
   
   Augment: For every additional power point spent, this power's duration increases by 1 minute.  
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
        effect eDeaf = EffectImmunity(IMMUNITY_TYPE_DEAFNESS);
        effect eDisease = EffectImmunity(IMMUNITY_TYPE_DISEASE);
        effect ePoison = EffectImmunity(IMMUNITY_TYPE_POISON);
        effect eStun = EffectImmunity(IMMUNITY_TYPE_STUN);
        effect eStr = EffectAbilityIncrease(ABILITY_STRENGTH, 4);
        //effect eDex = EffectAbilityDecrease(ABILITY_DEXTERITY, 2);
        effect eCold = EffectDamageImmunityIncrease(DAMAGE_TYPE_COLD, 50);
        effect eFire = EffectDamageImmunityDecrease(DAMAGE_TYPE_FIRE, 50);
        effect eMove = EffectMovementSpeedDecrease(50);
        effect eDR = EffectDamageReduction(10, DAMAGE_POWER_PLUS_TWO);
        effect eDrown = EffectSpellImmunity(SPELL_DROWN);
        effect eAC = EffectACIncrease(5, AC_NATURAL_BONUS);
        effect eSpell = EffectSpellFailure(50,SPELL_SCHOOL_GENERAL);

        effect eVis1 = EffectVisualEffect(VFX_DUR_FREEDOM_OF_MOVEMENT);
        effect eVis2 = EffectVisualEffect(VFX_DUR_GLOBE_INVULNERABILITY);
        effect eVis3 = EffectVisualEffect(VFX_DUR_PROT_BARKSKIN);
        effect eVis4 = EffectVisualEffect(VFX_DUR_PROTECTION_ELEMENTS);
        // Apply as instant
        effect eVis5 = EffectVisualEffect(VFX_IMP_HEAD_NATURE);
        effect eVis6 = EffectVisualEffect(VFX_FNF_NATURES_BALANCE);
        effect eVis7 = EffectVisualEffect(VFX_IMP_IMPROVE_ABILITY_SCORE);

        effect eLink = EffectLinkEffects(eBlind, eDeaf);
        eLink = EffectLinkEffects(eLink, eDisease);
        eLink = EffectLinkEffects(eLink, ePoison);
        eLink = EffectLinkEffects(eLink, eStun);
        eLink = EffectLinkEffects(eLink, eStr);
        //eLink = EffectLinkEffects(eLink, eDex);
        eLink = EffectLinkEffects(eLink, eCold);
        eLink = EffectLinkEffects(eLink, eFire);
        eLink = EffectLinkEffects(eLink, eMove);
        eLink = EffectLinkEffects(eLink, eDR);
        eLink = EffectLinkEffects(eLink, eDrown);
        eLink = EffectLinkEffects(eLink, eAC);
        eLink = EffectLinkEffects(eLink, eSpell);
        eLink = EffectLinkEffects(eLink, eVis1);
        eLink = EffectLinkEffects(eLink, eVis2);
        eLink = EffectLinkEffects(eLink, eVis3);
        eLink = EffectLinkEffects(eLink, eVis4);

        effect eLink2 = EffectLinkEffects(eVis5, eVis6);
        eLink2 = EffectLinkEffects(eLink2, eVis7);

        SPApplyEffectToObject(DURATION_TYPE_TEMPORARY, eLink, oTarget, fDur,TRUE,-1,nCaster);
        SPApplyEffectToObject(DURATION_TYPE_INSTANT, eLink2, oTarget);
        ApplyAbilityDamage(oTarget, ABILITY_DEXTERITY, 2, TRUE, DURATION_TYPE_TEMPORARY, fDur, TRUE, -1, nCaster);
    }
}