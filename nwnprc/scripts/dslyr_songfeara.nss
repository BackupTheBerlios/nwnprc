//::///////////////////////////////////////////////
//:: Aura of Fear On Enter
//:: NW_S1_AuraFearA.nss
//:: Copyright (c) 2001 Bioware Corp.
//:://////////////////////////////////////////////
/*
    Upon entering the aura of the creature the player
    must make a will save or be struck with fear because
    of the creatures presence.
*/
//:://////////////////////////////////////////////
//:: Created By: Preston Watamaniuk
//:: Created On: May 25, 2001
//:://////////////////////////////////////////////


// shaken   -2 attack,weapon dmg,save.
// panicked -2 save + flee away ,50 % drop object holding
#include "NW_I0_SPELLS"
#include "minstrelsong"

void main()
{
    //Declare major variables
    object oTarget = GetEnteringObject();

    effect eVis = EffectVisualEffect(VFX_IMP_FEAR_S);
    effect eDur = EffectVisualEffect(VFX_DUR_MIND_AFFECTING_FEAR);
    effect eDur2 = EffectVisualEffect(VFX_DUR_CESSATE_NEGATIVE);
    effect eDur3 = EffectVisualEffect(VFX_DUR_MIND_AFFECTING_NEGATIVE);

    effect eFear = EffectFrightened();
    effect eAttackD = EffectAttackDecrease(2);
    effect eDmgD = EffectDamageDecrease(2,DAMAGE_TYPE_BLUDGEONING|DAMAGE_TYPE_PIERCING|DAMAGE_TYPE_SLASHING);
    effect SaveD = EffectSavingThrowDecrease(SAVING_THROW_ALL,2);
    effect Skill = EffectSkillDecrease(SKILL_ALL_SKILLS,2);
    
    effect eLink = EffectLinkEffects(eDmgD, eDur2);
           eLink = EffectLinkEffects(eLink, eAttackD);
           eLink = EffectLinkEffects(eLink, SaveD);
           eLink = EffectLinkEffects(eLink, eFear);
           eLink = EffectLinkEffects(eLink, Skill);
           
    effect eLink2 = EffectLinkEffects(eDur3, SaveD);
           eLink2 = EffectLinkEffects(eLink2, Skill);
           
    int nHD = GetHitDice(GetAreaOfEffectCreator());
    int nDC = 12 + GetLevelByClass(CLASS_TYPE_DRAGONSONG_LYRIST,GetAreaOfEffectCreator())+ GetAbilityModifier(ABILITY_CHARISMA,GetAreaOfEffectCreator());
    int nDuration = d6(2);
    if(GetIsEnemy(oTarget, GetAreaOfEffectCreator()))
    {
        if (!GetHasEffect(EFFECT_TYPE_DEAF,oTarget)) // deaf targets can't hear the song.
        {
           //Fire cast spell at event for the specified target
           SignalEvent(oTarget, EventSpellCastAt(GetAreaOfEffectCreator(), SPELLABILITY_AURA_FEAR));
           //Make a saving throw check
           if(!PRCMySavingThrow(SAVING_THROW_WILL, oTarget, nDC, SAVING_THROW_TYPE_FEAR))
           {
  
              if (nHD>GetHitDice(oTarget)/2)
                 //Apply the VFX impact and effects
                 SPApplyEffectToObject(DURATION_TYPE_TEMPORARY, eLink, oTarget, RoundsToSeconds(nDuration),FALSE);
              else
                 SPApplyEffectToObject(DURATION_TYPE_TEMPORARY, eLink2, oTarget, RoundsToSeconds(nDuration),FALSE);

              SPApplyEffectToObject(DURATION_TYPE_INSTANT, eVis, oTarget);
              StoreSongRecipient(oTarget, OBJECT_SELF, SPELL_DSL_SONG_FEAR, 0);
           }
        }
     }
     
  
}
