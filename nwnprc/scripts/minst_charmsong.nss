//::///////////////////////////////////////////////
//:: Silence Song
//:://////////////////////////////////////////////
/*
    Causes all creatures who fail their saving throw to be silenced
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

    //Check to see if the caster has Lasting Impression and increase duration.
    if(GetHasFeat(870))
    {
        nDuration *= 10;
    }

    if(GetHasFeat(424)) // lingering song
    {
        nDuration += 5;
    }

    effect eCharm = ExtraordinaryEffect(EffectCharmed());
    effect eCharmVis = EffectVisualEffect(VFX_IMP_CHARM);
    eCharm = EffectLinkEffects(eCharm, eCharmVis);
    eCharmVis = EffectVisualEffect(VFX_DUR_CESSATE_NEGATIVE);
    eCharm = EffectLinkEffects(eCharm, eCharmVis);
    
    int iPerformReq = 50;
    if (!GetIsSkillSuccessful(OBJECT_SELF, SKILL_PERFORM, iPerformReq))
    {
        FloatingTextStringOnCreature("*Minstrel Song Failure*", OBJECT_SELF);
        DecrementRemainingFeatUses(OBJECT_SELF, FEAT_BARD_SONGS);
        return;
    }

    RemoveOldSongEffects(OBJECT_SELF);

    //Do the visual effects
    effect eVis2 = EffectVisualEffect(VFX_DUR_BARD_SONG);
    effect eVis3 = EffectVisualEffect(VFX_DUR_CESSATE_NEUTRAL);
    ApplyEffectToObject(DURATION_TYPE_TEMPORARY, EffectLinkEffects(eVis2,eVis3), OBJECT_SELF, RoundsToSeconds(nDuration));
   
    effect eFNF = EffectVisualEffect(VFX_FNF_LOS_NORMAL_30);
    ApplyEffectAtLocation(DURATION_TYPE_INSTANT, eFNF, GetLocation(OBJECT_SELF));

    object oTarget = GetFirstObjectInShape(SHAPE_SPHERE, RADIUS_SIZE_COLOSSAL, GetLocation(OBJECT_SELF));
    
    while(GetIsObjectValid(oTarget))
    {
        if (spellsIsTarget(oTarget, SPELL_TARGET_SELECTIVEHOSTILE, OBJECT_SELF)
            && MyPRCGetRacialType(oTarget) != RACIAL_TYPE_CONSTRUCT
            && MyPRCGetRacialType(oTarget) != RACIAL_TYPE_UNDEAD)  //constructs & undead are immune
        {
            if (!GetHasEffect(EFFECT_TYPE_DEAF,oTarget)) // deaf targets can't hear the song.
            {
                if (!iAlreadyAffected) // don't want to check the targets more than once.
                {
                    if (GetIsImmune(oTarget, IMMUNITY_TYPE_CHARM) == FALSE && GetIsImmune(oTarget, IMMUNITY_TYPE_MIND_SPELLS) == FALSE)
                    {
                        if (!MySavingThrow(SAVING_THROW_WILL, oTarget, nDC, SAVING_THROW_TYPE_MIND_SPELLS))
                        {
                            if (!GetHasSpellEffect(GetSpellId(),oTarget))
                            {
                                SignalEvent(oTarget, EventSpellCastAt(OBJECT_SELF, GetSpellId()));
                                ApplyEffectToObject(DURATION_TYPE_TEMPORARY, eCharm, oTarget, RoundsToSeconds(nDuration));
                                StoreSongRecipient(oTarget, OBJECT_SELF, GetSpellId(), nDuration);
                            }
                        }
                    }
                }
            }
        }
        else
        {
            ApplyEffectToObject(DURATION_TYPE_INSTANT, EffectVisualEffect(VFX_IMP_MAGIC_RESISTANCE_USE), oTarget);
        }

        oTarget = GetNextObjectInShape(SHAPE_SPHERE, RADIUS_SIZE_COLOSSAL, GetLocation(OBJECT_SELF));
    }
    DecrementRemainingFeatUses(OBJECT_SELF, FEAT_BARD_SONGS);
}
