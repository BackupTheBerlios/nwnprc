//::///////////////////////////////////////////////
//:: Slow Song
//:://////////////////////////////////////////////
/*
    Causes all creatures who fail their saving throw to be slowed
    for 10 rounds, 15 rounds with lingering song, and 105 rounds
    with lasting impression.
*/

#include "x2_i0_spells"
#include "prc_class_const"
#include "minstrelsong"

void main()
{

   if (!GetHasFeat(FEAT_BARD_SONGS, OBJECT_SELF))
   {
        FloatingTextStrRefOnCreature(85587,OBJECT_SELF); // no more bardsong uses left
        return;
   }

    if (GetHasEffect(EFFECT_TYPE_SILENCE,OBJECT_SELF))
    {
        FloatingTextStrRefOnCreature(85764,OBJECT_SELF); // not useable when silenced
        return;
    }


    //Declare major variables
    int nLevel = GetLevelByClass(CLASS_TYPE_MINSTREL_EDGE);
    int nCha = GetAbilityModifier(ABILITY_CHARISMA);
    int nDuration = 10; //+ nChr;
    int nDC = 10 + (nLevel / 2) + nCha;
    int iAlreadyAffected;
    if (GetHasFeat(FEAT_DRAGONSONG, OBJECT_SELF)) nDC+=2;
    
    //Check to see if the caster has Lasting Impression and increase duration.
    if(GetHasFeat(870))
    {
        nDuration *= 10;
    }

    if(GetHasFeat(424)) // lingering song
    {
        nDuration += 5;
    }

    effect eSlow = EffectSlow();
    effect eSlowVis = EffectVisualEffect(VFX_IMP_SLOW);
    eSlow = EffectLinkEffects(eSlow, eSlowVis);
    eSlowVis = EffectVisualEffect(VFX_DUR_CESSATE_NEGATIVE);
    eSlow = EffectLinkEffects(eSlow, eSlowVis);
    
    int iPerformReq = 30;
    if (GetHasFeat(FEAT_DRAGONSONG, OBJECT_SELF)) iPerformReq-= 2;
    if (!GetIsSkillSuccessful(OBJECT_SELF, SKILL_PERFORM, iPerformReq))
    {
        FloatingTextStringOnCreature("*Minstrel Song Failure*", OBJECT_SELF);
        DecrementRemainingFeatUses(OBJECT_SELF, FEAT_BARD_SONGS);
        return;
    }

    RemoveOldSongEffects(OBJECT_SELF,GetSpellId());
    
    //Do the visual effects
    effect eVis2 = EffectVisualEffect(VFX_DUR_BARD_SONG);
    effect eVis3 = EffectVisualEffect(VFX_DUR_CESSATE_NEUTRAL);
    SPApplyEffectToObject(DURATION_TYPE_TEMPORARY, EffectLinkEffects(eVis2,eVis3), OBJECT_SELF, RoundsToSeconds(nDuration));
   
    effect eFNF = EffectVisualEffect(VFX_FNF_LOS_NORMAL_30);
    ApplyEffectAtLocation(DURATION_TYPE_INSTANT, eFNF, GetLocation(OBJECT_SELF));

    object oTarget = GetFirstObjectInShape(SHAPE_SPHERE, RADIUS_SIZE_COLOSSAL, GetLocation(OBJECT_SELF));
    
    while(GetIsObjectValid(oTarget))
    {
        if (spellsIsTarget(oTarget, SPELL_TARGET_SELECTIVEHOSTILE, OBJECT_SELF))  //constructs & undead are immune
        {
            if (!GetHasEffect(EFFECT_TYPE_DEAF,oTarget)) // deaf targets can't hear the song.
            {
                if (!iAlreadyAffected) // don't want to check the targets more than once.
                {
                    if (GetIsImmune(oTarget, IMMUNITY_TYPE_SLOW) == FALSE)
                    {
                        if (!MySavingThrow(SAVING_THROW_WILL, oTarget, nDC))
                        {
                            if (!GetHasSpellEffect(GetSpellId(),oTarget))
                            {
                                SignalEvent(oTarget, EventSpellCastAt(OBJECT_SELF, GetSpellId()));
                                SPApplyEffectToObject(DURATION_TYPE_TEMPORARY, eSlow, oTarget, RoundsToSeconds(nDuration));
                                StoreSongRecipient(oTarget, OBJECT_SELF, GetSpellId(), nDuration);
                            }
                        }
                    }
                }
            }
        }
        else
        {
            SPApplyEffectToObject(DURATION_TYPE_INSTANT, EffectVisualEffect(VFX_IMP_MAGIC_RESISTANCE_USE), oTarget);
        }

        oTarget = GetNextObjectInShape(SHAPE_SPHERE, RADIUS_SIZE_COLOSSAL, GetLocation(OBJECT_SELF));
    }
    DecrementRemainingFeatUses(OBJECT_SELF, FEAT_BARD_SONGS);
}
