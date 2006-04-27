/*
   ----------------
   Form of Doom

   psi_pow_formdoom
   ----------------

   13/12/05 by Stratovarius
*/ /** @file

    Form of Doom

    Psychometabolism
    Level: Psychic warrior 6
    Manifesting Time: 1 standard action
    Range: Personal; see text
    Target: You
    Duration: 1 round/level
    Power Points: 11
    Metapsionics: Extend

    You wrench from your subconscious a terrifying visage of deadly hunger and
    become one with it. You are transformed into a nightmarish version of
    yourself, complete with an ooze-sleek skin coating, lashing tentacles, and a
    fright-inducing countenance. You retain your basic shape and can continue to
    use your equipment. This power cannot be used to impersonate someone; while
    horrible, your form is recognizably your own.

    You gain the frightful presence extraordinary ability, which takes effect
    automatically. Opponents within 30 feet of you that have fewer Hit Dice or
    levels than you become shaken for 5d6 rounds if they fail a Will save
    (DC 16 + your Cha modifier). An opponent that succeeds on the saving throw
    is immune to your frightful presence for 24 hours. Frightful presence is a
    mind-affecting fear effect.

    Your horrific form grants you a natural armor bonus of +5, damage reduction
    5/-, and a +4 bonus to your Strength score. In addition, you gain +33% to
    your land speed as well as a +10 bonus on Jump checks.

    A nest of violently flailing black tentacles sprout from your hair and back.
    You can make up to four additional attacks with these tentacles in addition
    to your regular melee attacks. You can make tentacle attacks within the
    space you normally threaten. Each tentacle attacks at your highest base
    attack bonus with a -5 penalty. These tentacles deal 2d8 points of damage
    plus one-half your Strength bonus on each successful strike.

    This power functions only while you inhabit your base form (for instance,
    you can’t be metamorphed or polymorphed into another form, though you can
    use, claws of the beast, and bite of the wolf in conjunction with this power
    for your regular attacks), and while your mind resides within your own body.

    Augment: For every additional power point you spend, this power’s duration
             increases by 2 rounds.
*/

#include "psi_inc_psifunc"
#include "psi_inc_pwresist"
#include "psi_spellhook"
#include "spinc_common"

void FormOfDoomHB(object oManifester, object oTarget, int nSpellID, int nBeatsRemaining);
void TentacleAttack(object oAttacker);


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
                                                       1, PRC_UNLIMITED_AUGMENTATION
                                                       ),
                              METAPSIONIC_EXTEND
                              );

    if(manif.bCanManifest)
    {
        effect eLink    =                          EffectAreaOfEffect(AOE_MOB_FORM_DOOM);
               eLink    = EffectLinkEffects(eLink, EffectACIncrease(5, AC_NATURAL_BONUS));
               eLink    = EffectLinkEffects(eLink, EffectDamageResistance(DAMAGE_TYPE_SLASHING,    5));
               eLink    = EffectLinkEffects(eLink, EffectDamageResistance(DAMAGE_TYPE_PIERCING,    5));
               eLink    = EffectLinkEffects(eLink, EffectDamageResistance(DAMAGE_TYPE_BLUDGEONING, 5));
               eLink    = EffectLinkEffects(eLink, EffectAbilityIncrease(ABILITY_STRENGTH, 4));
               eLink    = EffectLinkEffects(eLink, EffectMovementSpeedIncrease(33));
               eLink    = EffectLinkEffects(eLink, EffectSkillIncrease(SKILL_JUMP, 10));
               //eLink    = EffectLinkEffects(eLink, EffectSkillIncrease(SKILL_INTIMIDATE, 10));
               eLink    = EffectLinkEffects(eLink, EffectVisualEffect(VFX_DUR_PROT_SHADOW_ARMOR));
               eLink    = EffectLinkEffects(eLink, EffectVisualEffect(PSI_DUR_SHADOW_BODY));
               eLink    = EffectLinkEffects(eLink, EffectVisualEffect(VFX_DUR_TENTACLE));
        effect eTest;
        float fDuration = 6.0f * (manif.nManifesterLevel + (2 * manif.nTimesAugOptUsed_1));
        if(manif.bExtend) fDuration *= 2;

        // Will not work if under the effects of Polymorph. Also will not stack with itself
        eTest = GetFirstEffect(oTarget);
        while(GetIsEffectValid(eTest))
        {
            if(GetEffectType(eTest) == EFFECT_TYPE_POLYMORPH ||
               GetEffectSpellId(eTest) == POWER_FORM_OF_DOOM
               )
                return;
            eTest = GetNextEffect(oTarget);
        }

        // Apply the effects
        SPApplyEffectToObject(DURATION_TYPE_TEMPORARY, eLink, oTarget, fDuration, TRUE, manif.nSpellID ,manif.nManifesterLevel);

        // Start dispelling monitor and tentacles heartbeat
        FormOfDoomHB(oManifester, oTarget, manif.nSpellID, FloatToInt(fDuration) / 6);
    }// end if - Successfull manifestation
}

void FormOfDoomHB(object oManifester, object oTarget, int nSpellID, int nBeatsRemaining)
{
    if(!((nBeatsRemaining-- == 0)                                         || // Has the power ended since the last beat, or does the duration run out now
         GZGetDelayedSpellEffectsExpired(nSpellID, oTarget, oManifester)  || // Has the power been dispelled
         GetHasEffect(EFFECT_TYPE_POLYMORPH, oTarget)                        // Has the target been polymorphed
         )
       )
    {
        // Determine if we are in combat
        if(GetIsInCombat(oTarget))
        {
            // Spread the attacks out over a round, there's 4 total
            //bioware splits attacks over 3 flurries/round
            TentacleAttack(oTarget);
            TentacleAttack(oTarget);
            DelayCommand(2.0f, TentacleAttack(oTarget));
            DelayCommand(4.0f, TentacleAttack(oTarget));
        }

        // Schedule next HB
        DelayCommand(6.0f, FormOfDoomHB(oManifester, oTarget, nSpellID, nBeatsRemaining));
    }
    // Power expired
    else
    {
        if(DEBUG) DoDebug("psi_pow_formdoom: Power expired, exiting HB");
        RemoveSpellEffects(nSpellID, oManifester, oTarget);
    }
}

void TentacleAttack(object oAttacker)
{
    // Get the target
    object oTarget = GetAttackTarget(oAttacker);

    // Make sure this is melee combat
    if(GetIsInMeleeRange(oTarget, oAttacker))
    {
        // Roll the attack
        int nAttack = GetAttackRoll(oTarget, oAttacker, OBJECT_INVALID, 0, 0, -5);
        // If the tentacle hits
        if(nAttack > 0)
        {
            // Do damage and visual effects
            effect eHit = EffectVisualEffect(VFX_COM_HIT_ACID);
            int nDamage = d8(2) + (GetAbilityModifier(ABILITY_STRENGTH, oAttacker) / 2);
            // Critical hit, double damage
            if (nAttack == 2) nDamage += d8(2) + (GetAbilityModifier(ABILITY_STRENGTH, oAttacker) / 2);
            effect eDam = EffectDamage(nDamage, DAMAGE_TYPE_BLUDGEONING);

            // Extraordinarify the effect, since the damage is non-magical
            ApplyEffectToObject(DURATION_TYPE_INSTANT, ExtraordinaryEffect(EffectLinkEffects(eHit, eDam)), oTarget);
        }
    }
}
