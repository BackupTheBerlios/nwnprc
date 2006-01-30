/*
   ----------------
   Form of Doom (THIS IS THE LAST POWER TO BE CODED BEFORE BETA)
   
   psi_pow_formdoom
   ----------------

   13/12/05 by Stratovarius

   Class: Psychic Warrior
   Power Level: 6
   Range: Personal
   Target: Self
   Duration: 1 Round/level
   Saving Throw: None
   Power Resistance: No
   Power Point Cost: 11
   
   You wrench from your subconscious a terrifying visage of deadly hunger and become one with it. You are transformed into a 
   nightmarish version of yourself, complete with an ooze-sleek skin coating, lashing tentacles, and a fright-inducing countenance. 
   You effectively gain a +10 bonus on Intimidate. Opponents within 30 feet of you that have fewer Hit Dice or levels than you become
   shaken for 5d6 rounds if they fail a Will save (DC 16 + your Cha modifier). An opponent that succeeds on the saving throw is 
   immune to your frightful presence for 24 hours. Frightful presence is a mind-affecting fear effect. Your horrific form grants you
   a natural armor bonus of +5, damage reduction 5/-, and a +4 bonus to your Strength score. In addition, you gain a 1/3rd increase
   to your land speed as well as a +10 bonus on Jump checks. A nest of violently flailing black tentacles sprout from your hair and
   back. You can make up to four additional attacks with these tentacles in addition to your regular melee attacks. Each tentacle 
   attacks at your highest base attack bonus with a -5 penalty. These tentacles deal 2d8 points of damage plus one-half your 
   Strength bonus on each successful strike.
   
   Augment: For every additional power point spent, the duration increases by 2. 
*/
#include "NW_I0_SPELLS"

void main()
{
    //Declare major variables
    object oTarget = GetEnteringObject();
    effect eVis = EffectVisualEffect(VFX_IMP_FEAR_S);
    effect eDur = EffectVisualEffect(VFX_DUR_MIND_AFFECTING_FEAR);
    effect eDur2 = EffectVisualEffect(VFX_DUR_CESSATE_NEGATIVE);
    effect eFear = CreateDoomEffectsLink();
    effect eLink = EffectLinkEffects(eFear, eDur);
    eLink = EffectLinkEffects(eLink, eDur2);

    int nDC = 16 + GetAbilityModifier(ABILITY_CHARISMA, GetAreaOfEffectCreator());
    int nDuration = d6(5);
    
    if(GetIsEnemy(oTarget, GetAreaOfEffectCreator()))
    {
        //Fire cast spell at event for the specified target
        SignalEvent(oTarget, EventSpellCastAt(GetAreaOfEffectCreator(), SPELLABILITY_AURA_FEAR));
        //Make a saving throw check
        if(!PRCMySavingThrow(SAVING_THROW_WILL, oTarget, nDC, SAVING_THROW_TYPE_FEAR))
        {
            //Apply the VFX impact and effects
            ApplyEffectToObject(DURATION_TYPE_TEMPORARY, eLink, oTarget, RoundsToSeconds(nDuration));
            ApplyEffectToObject(DURATION_TYPE_INSTANT, eVis, oTarget);
        }
    }
}
