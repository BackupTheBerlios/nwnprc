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
    
    string sSpellLocal = "MINSTREL_SONG_CHARM_" + ObjectToString(OBJECT_SELF);
    
    //Do the visual effects
    effect eVis = EffectLinkEffects(EffectVisualEffect(VFX_DUR_BARD_SONG), EffectVisualEffect(VFX_DUR_CESSATE_POSITIVE));
    ApplyEffectToObject(DURATION_TYPE_TEMPORARY, eVis, OBJECT_SELF, RoundsToSeconds(nDuration));

    int iRandomSound = d3(1);
    if (iRandomSound = 1)
    {
        PlaySound("as_cv_lute1");
    }
    else if (iRandomSound = 2)
    {
        PlaySound("as_cv_lute1b");
    }
    else
    {
        PlaySound("srd_bardsong");
    }    
    
    effect eFNF = EffectVisualEffect(VFX_FNF_LOS_NORMAL_30);
    ApplyEffectAtLocation(DURATION_TYPE_INSTANT, eFNF, GetLocation(OBJECT_SELF));

    int iPerformReq = 50;
    if (!GetIsSkillSuccessful(OBJECT_SELF, SKILL_PERFORM, iPerformReq))
    {
        FloatingTextStringOnCreature("*Minstrel Song Failure*", OBJECT_SELF);
        DecrementRemainingFeatUses(OBJECT_SELF, FEAT_BARD_SONGS);
        return;
    }
    
    object oTarget = GetFirstObjectInShape(SHAPE_SPHERE, RADIUS_SIZE_COLOSSAL, GetLocation(OBJECT_SELF));
    float fDelay;
    
    while(GetIsObjectValid(oTarget))
    {
        if (spellsIsTarget(oTarget, SPELL_TARGET_SELECTIVEHOSTILE, OBJECT_SELF)
            && MyPRCGetRacialType(oTarget) != RACIAL_TYPE_CONSTRUCT
            && MyPRCGetRacialType(oTarget) != RACIAL_TYPE_UNDEAD)  //constructs & undead are immune
        {
            if (!GetHasEffect(EFFECT_TYPE_DEAF,oTarget)) // deaf targets can't hear the song.
            {
                iAlreadyAffected = GetLocalInt(oTarget, sSpellLocal);
                if (!iAlreadyAffected) // don't want to check the targets more than once.
                {
                    if (GetIsImmune(oTarget, IMMUNITY_TYPE_CHARM) == FALSE)
                    {
                        if (!MySavingThrow(SAVING_THROW_WILL, oTarget, nDC))
                        {
                            if (!GetHasSpellEffect(GetSpellId(),oTarget))
                            {
                                ApplyEffectToObject(DURATION_TYPE_TEMPORARY, eCharm, oTarget, RoundsToSeconds(nDuration));
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
        SetLocalInt(oTarget, sSpellLocal, TRUE);
	DelayCommand(0.5, SetLocalInt(oTarget, sSpellLocal, FALSE));
	DelayCommand(0.5, DeleteLocalInt(oTarget, sSpellLocal));

        oTarget = GetNextObjectInShape(SHAPE_SPHERE, RADIUS_SIZE_COLOSSAL, GetLocation(OBJECT_SELF));
    }
    DecrementRemainingFeatUses(OBJECT_SELF, FEAT_BARD_SONGS);
}
