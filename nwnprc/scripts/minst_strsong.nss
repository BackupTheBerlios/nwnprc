//::///////////////////////////////////////////////
//:: Strength Song
//:://////////////////////////////////////////////
/*
   Bard song that gives everybody +4 Strength.
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
    object oTarget;
    effect eBoost = EffectAbilityIncrease(ABILITY_STRENGTH,4);
    effect eVis = EffectVisualEffect(VFX_IMP_IMPROVE_ABILITY_SCORE);
    effect eDur = EffectVisualEffect(VFX_DUR_CESSATE_POSITIVE);
    effect eLink = EffectLinkEffects(eBoost, eDur);
    effect eImpact = EffectVisualEffect(VFX_FNF_LOS_NORMAL_30);

    float fDelay;
    //Determine spell duration as an integer for later conversion to Rounds, Turns or Hours.
    int nDuration = 10;
    int nCount;
    location lSpell = GetSpellTargetLocation();

    //Check to see if the caster has Lasting Impression and increase duration.
    if(GetHasFeat(870))
    {
        nDuration *= 10;
    }

    if(GetHasFeat(424)) // lingering song
    {
        nDuration += 5;
    }

    //Do the visual effects
    effect eVis2 = EffectLinkEffects(EffectVisualEffect(VFX_DUR_BARD_SONG), EffectVisualEffect(VFX_DUR_CESSATE_POSITIVE));
    ApplyEffectToObject(DURATION_TYPE_TEMPORARY, eVis2, OBJECT_SELF, RoundsToSeconds(nDuration));

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

    ApplyEffectAtLocation(DURATION_TYPE_INSTANT, eImpact, GetSpellTargetLocation());
    
    int iPerformReq = 30;
    if (!GetIsSkillSuccessful(OBJECT_SELF, SKILL_PERFORM, iPerformReq))
    {
        FloatingTextStringOnCreature("*Minstrel Song Failure*", OBJECT_SELF);
        DecrementRemainingFeatUses(OBJECT_SELF, FEAT_BARD_SONGS);
        return;
    }
   
    //Declare the spell shape, size and the location.  Capture the first target object in the shape.
    oTarget = GetFirstObjectInShape(SHAPE_SPHERE, RADIUS_SIZE_COLOSSAL, lSpell);
    //Cycle through the targets within the spell shape until an invalid object is captured or the number of
    //targets affected is equal to the caster level.
    while(GetIsObjectValid(oTarget) && nCount != nDuration)
    {
        //Make faction check on the target
        if((GetIsFriend(oTarget) || oTarget == OBJECT_SELF) && !GetHasSpellEffect(GetSpellId(),oTarget))
        {
            fDelay = GetRandomDelay(0.0, 1.0);
            //Fire cast spell at event for the specified target
            DelayCommand(fDelay, ApplyEffectToObject(DURATION_TYPE_TEMPORARY, eLink, oTarget, RoundsToSeconds(nDuration)));
            DelayCommand(fDelay, ApplyEffectToObject(DURATION_TYPE_INSTANT, eVis, oTarget));
            nCount++;
        }
        //Select the next target within the spell shape.
        oTarget = GetNextObjectInShape(SHAPE_SPHERE, RADIUS_SIZE_COLOSSAL, lSpell);
    }
    DecrementRemainingFeatUses(OBJECT_SELF, FEAT_BARD_SONGS);
}
