/*
   ----------------
   Assimilate

   psi_pow_assim
   ----------------

   26/2/05 by Stratovarius
*/ /** @file

    Assimilate

    Psychometabolism
    Level: Psion/wilder 9
    Manifesting Time: 1 standard action
    Range: Touch
    Target: One living creature touched
    Duration: Instantaneous and 1 hour; see text
    Saving Throw: Fortitude half
    Power Resistance: Yes
    Power Points: 17
    Metapsionics: Empower, Maximize, Twin

    Your pointing finger turns black as obsidian. A creature touched by you is
    partially assimilated into your form and takes 20d6 points of damage. Any
    creature reduced to 0 or fewer hit points by this power is killed, entirely
    assimilated into your form, leaving behind only a trace of fine dust. An
    assimilated creature’s equipment is unaffected.

    A creature that is partially assimilated into your form (that is, a creature
    that has at least 1 hit point following your use of this power) grants you a
    number of temporary hit points equal to half the damage you dealt for 1
    hour.

    A creature that is completely assimilated grants you a number of temporary
    hit points equal to the damage you dealt and a +4 bonus to each of your
    ability scores for 1 hour. If the assimilated creature knows psionic powers,
    you gain knowledge of one of its powers for 1 hour.


    @todo Gaining a temporary power
*/

#include "psi_inc_psifunc"
#include "psi_inc_pwresist"
#include "psi_spellhook"
#include "prc_alterations"


void DoPower(struct manifestation manif, object oTarget, int nDC, int nPen, effect eVis, effect eLink)
{
    // Roll touch
    int nTouchAttack = PRCDoMeleeTouchAttack(oTarget);
    if(nTouchAttack > 0)
    {
        //Check for Power Resistance
        if(PRCMyResistPower(manif.oManifester, oTarget, nPen))
        {
            // Determine damage
            int nNumberOfDice = 20;
            int nDieSize      = 6;
            int nDamage       = MetaPsionicsDamage(manif, nDieSize, nNumberOfDice, 0, 0, TRUE, FALSE);
            // Fort save for half
            if(PRCMySavingThrow(SAVING_THROW_FORT, oTarget, nDC, SAVING_THROW_TYPE_NONE))
                nDamage /= 2;

            nDamage = GetTargetSpecificChangesToDamage(oTarget, manif.oManifester, nDamage);

            // Apply damage and the accompanying VFX
            ApplyTouchAttackDamage(manif.oManifester, oTarget, nTouchAttack, nDamage, DAMAGE_TYPE_MAGICAL, TRUE);
            SPApplyEffectToObject(DURATION_TYPE_INSTANT, eVis, oTarget);

            // Give the temp HP, and if the target was dead, the stat boosts
            effect eTempHP;
            if(GetIsDead(oTarget))
            {
                eTempHP = EffectTemporaryHitpoints(nDamage);
                SPApplyEffectToObject(DURATION_TYPE_TEMPORARY, eLink, manif.oManifester, HoursToSeconds(1), TRUE, -1, manif.nManifesterLevel);
            }
            else
                eTempHP = EffectTemporaryHitpoints(nDamage / 2);

            SPApplyEffectToObject(DURATION_TYPE_TEMPORARY, eTempHP, manif.oManifester, HoursToSeconds(1), TRUE, -1, manif.nManifesterLevel);
        }// end if - resist failed
    }// end if - touch attack succeeded
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
                              METAPSIONIC_EMPOWER | METAPSIONIC_MAXIMIZE | METAPSIONIC_TWIN
                              );

    if(manif.bCanManifest)
    {
        // Get some more data
        int nDC           = GetManifesterDC(oManifester);
        int nPen          = GetPsiPenetration(oManifester);

        // Build effects
        effect eVis  = EffectVisualEffect(VFX_COM_HIT_NEGATIVE);
        effect eLink =                          EffectAbilityIncrease(ABILITY_CHARISMA,     4);
               eLink = EffectLinkEffects(eLink, EffectAbilityIncrease(ABILITY_CONSTITUTION, 4));
               eLink = EffectLinkEffects(eLink, EffectAbilityIncrease(ABILITY_DEXTERITY,    4));
               eLink = EffectLinkEffects(eLink, EffectAbilityIncrease(ABILITY_INTELLIGENCE, 4));
               eLink = EffectLinkEffects(eLink, EffectAbilityIncrease(ABILITY_STRENGTH,     4));
               eLink = EffectLinkEffects(eLink, EffectAbilityIncrease(ABILITY_WISDOM,       4));
               eLink = EffectLinkEffects(eLink, EffectVisualEffect(VFX_DUR_PROTECTION_GOOD_MAJOR));

        // Let the target know
        SignalEvent(oTarget, EventSpellCastAt(OBJECT_SELF, GetSpellId()));

        DoPower(manif, oTarget, nDC, nPen, eVis, eLink);
        // If the target dies on the first attempt, a Twin Power will be wasted
        if(manif.bTwin && !GetIsDead(oTarget))
            DoPower(manif, oTarget, nDC, nPen, eVis, eLink);
    }// end if - could manifest
}