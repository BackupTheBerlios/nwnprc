/*
   ----------------
   Timeless Body

   prc_pow_timebody
   ----------------

   26/2/05 by Stratovarius

   Class: Psion/Wilder
   Power Level: 9
   Range: Personal
   Target: Self
   Duration: 1 Round
   Saving Throw: None
   Power Resistance: No
   Power Point Cost: 17

   Your body ignores all harmful effects, making you invulnerable to all spells, powers, damage, or any other damaging effect.
*/

#include "psi_inc_psifunc"
#include "psi_inc_pwresist"
#include "psi_spellhook"
#include "prc_alterations"

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

    object oCaster = OBJECT_SELF;
    object oTarget = PRCGetSpellTargetObject();
    int nAugCost = 0;
    int nMetaPsi = GetCanManifest(oCaster, nAugCost, oTarget, 0, 0, METAPSIONIC_EXTEND, 0, 0, 0, 0);

    if (nMetaPsi > 0)
    {
        int nCaster = GetManifesterLevel(oCaster);
        int nDur = 1;
        if (nMetaPsi == 2)	nDur *= 2;

        //Massive effect linkage, go me
        effect eSpell = EffectSpellImmunity(SPELL_ALL_SPELLS);
        effect eDam1  = EffectDamageImmunityIncrease(DAMAGE_TYPE_ACID,        100);
        effect eDam2  = EffectDamageImmunityIncrease(DAMAGE_TYPE_BLUDGEONING, 100);
        effect eDam3  = EffectDamageImmunityIncrease(DAMAGE_TYPE_COLD,        100);
        effect eDam4  = EffectDamageImmunityIncrease(DAMAGE_TYPE_DIVINE,      100);
        effect eDam5  = EffectDamageImmunityIncrease(DAMAGE_TYPE_ELECTRICAL,  100);
        effect eDam6  = EffectDamageImmunityIncrease(DAMAGE_TYPE_FIRE,        100);
        effect eDam7  = EffectDamageImmunityIncrease(DAMAGE_TYPE_MAGICAL,     100);
        effect eDam8  = EffectDamageImmunityIncrease(DAMAGE_TYPE_NEGATIVE,    100);
        effect eDam9  = EffectDamageImmunityIncrease(DAMAGE_TYPE_PIERCING,    100);
        effect eDam10 = EffectDamageImmunityIncrease(DAMAGE_TYPE_POSITIVE,    100);
        effect eDam11 = EffectDamageImmunityIncrease(DAMAGE_TYPE_SLASHING,    100);
        effect eDam12 = EffectDamageImmunityIncrease(DAMAGE_TYPE_SONIC,       100);

        effect eAbil  = EffectImmunity(IMMUNITY_TYPE_ABILITY_DECREASE);
        effect eBlind = EffectImmunity(IMMUNITY_TYPE_BLINDNESS);
        effect eDeaf  = EffectImmunity(IMMUNITY_TYPE_DEAFNESS);
        effect eCrit  = EffectImmunity(IMMUNITY_TYPE_CRITICAL_HIT);
        effect eDeath = EffectImmunity(IMMUNITY_TYPE_DEATH);
        effect eDis   = EffectImmunity(IMMUNITY_TYPE_DISEASE);
        effect eEnt   = EffectImmunity(IMMUNITY_TYPE_ENTANGLE);
        effect eSlow  = EffectImmunity(IMMUNITY_TYPE_SLOW);
        effect eKD    = EffectImmunity(IMMUNITY_TYPE_KNOCKDOWN);
        effect eNeg   = EffectImmunity(IMMUNITY_TYPE_NEGATIVE_LEVEL);
        effect ePara  = EffectImmunity(IMMUNITY_TYPE_PARALYSIS);
        effect eSil   = EffectImmunity(IMMUNITY_TYPE_SILENCE);
        effect eSneak = EffectImmunity(IMMUNITY_TYPE_SNEAK_ATTACK);
        effect eTrap  = EffectImmunity(IMMUNITY_TYPE_TRAP);
        effect eMind  = EffectImmunity(IMMUNITY_TYPE_MIND_SPELLS);

        effect eVis = EffectVisualEffect(VFX_IMP_MAGIC_PROTECTION);
        effect eDur = EffectVisualEffect(PSI_DUR_TIMELESS_BODY);//VFX_DUR_CESSATE_POSITIVE);
        //effect eDur2 = EffectVisualEffect(VFX_DUR_MAGIC_RESISTANCE);
        effect eLink = EffectLinkEffects(eMind, eDur);
        //eLink = EffectLinkEffects(eLink, eDur2);
        eLink = EffectLinkEffects(eLink, eSpell);
        eLink = EffectLinkEffects(eLink, eDam1);
        eLink = EffectLinkEffects(eLink, eDam2);
        eLink = EffectLinkEffects(eLink, eDam3);
        eLink = EffectLinkEffects(eLink, eDam4);
        eLink = EffectLinkEffects(eLink, eDam5);
        eLink = EffectLinkEffects(eLink, eDam6);
        eLink = EffectLinkEffects(eLink, eDam7);
        eLink = EffectLinkEffects(eLink, eDam8);
        eLink = EffectLinkEffects(eLink, eDam9);
        eLink = EffectLinkEffects(eLink, eDam10);
        eLink = EffectLinkEffects(eLink, eDam11);
        eLink = EffectLinkEffects(eLink, eDam12);
        eLink = EffectLinkEffects(eLink, eAbil);
        eLink = EffectLinkEffects(eLink, eBlind);
        eLink = EffectLinkEffects(eLink, eDeaf);
        eLink = EffectLinkEffects(eLink, eCrit);
        eLink = EffectLinkEffects(eLink, eDeath);
        eLink = EffectLinkEffects(eLink, eDis);
        eLink = EffectLinkEffects(eLink, eEnt);
        eLink = EffectLinkEffects(eLink, eSlow);
        eLink = EffectLinkEffects(eLink, eKD);
        eLink = EffectLinkEffects(eLink, eNeg);
        eLink = EffectLinkEffects(eLink, ePara);
        eLink = EffectLinkEffects(eLink, eSil);
        eLink = EffectLinkEffects(eLink, eSneak);
        eLink = EffectLinkEffects(eLink, eTrap);

        SPApplyEffectToObject(DURATION_TYPE_TEMPORARY, eLink, oTarget, RoundsToSeconds(nDur),TRUE,-1,nCaster);
        SPApplyEffectToObject(DURATION_TYPE_INSTANT, eVis, oTarget);
    }
}