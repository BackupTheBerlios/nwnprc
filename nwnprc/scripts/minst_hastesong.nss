//::///////////////////////////////////////////////
//:: Haste Song
//:://////////////////////////////////////////////
/*
    Effectively a bard song version of the Mass Haste spell.
    Duration is 10 rounds normally, 15 rounds with lingering
    song, and 105 (!) rounds with lasting inspiration.
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
    
    if (GetSkillRank(SKILL_PERFORM,OBJECT_SELF) < 18)
    {
        FloatingTextStringOnCreature("*You must have at least 18 perform ranks to use this song*",OBJECT_SELF);
        return;
    }

    //Declare major variables
    object oTarget;
    effect eHaste = EffectHaste();
    effect eVis = EffectVisualEffect(VFX_IMP_HASTE);
    effect eDur = EffectVisualEffect(VFX_DUR_CESSATE_POSITIVE);
    effect eLink = EffectLinkEffects(eHaste, eDur);
    effect eImpact = EffectVisualEffect(VFX_FNF_LOS_NORMAL_30);

    //Determine spell duration as an integer for later conversion to Rounds, Turns or Hours.
    int nDuration = 10;
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

    RemoveOldSongEffects(OBJECT_SELF,GetSpellId());

    //Do the visual effects
    effect eVis2 = EffectVisualEffect(VFX_DUR_BARD_SONG);
    effect eLink2 = EffectLinkEffects(eVis2,eLink);
   
    effect eFNF = EffectVisualEffect(VFX_FNF_LOS_NORMAL_30);
    ApplyEffectAtLocation(DURATION_TYPE_INSTANT, eFNF, GetLocation(OBJECT_SELF));

    ApplyEffectAtLocation(DURATION_TYPE_INSTANT, eImpact, GetSpellTargetLocation());

    //Declare the spell shape, size and the location.  Capture the first target object in the shape.
    oTarget = GetFirstObjectInShape(SHAPE_SPHERE, RADIUS_SIZE_COLOSSAL, lSpell);
    //Cycle through the targets within the spell shape until an invalid object is captured or the number of
    //targets affected is equal to the caster level.
    while(GetIsObjectValid(oTarget))
    {
        //Make faction check on the target
        if(oTarget == OBJECT_SELF)
        {
            SPApplyEffectToObject(DURATION_TYPE_TEMPORARY, eLink2, oTarget, RoundsToSeconds(nDuration));
            SPApplyEffectToObject(DURATION_TYPE_INSTANT, eVis, oTarget);
            StoreSongRecipient(oTarget, OBJECT_SELF, GetSpellId(), nDuration);
        }
        else if(GetIsFriend(oTarget))
        {
            SPApplyEffectToObject(DURATION_TYPE_TEMPORARY, eLink, oTarget, RoundsToSeconds(nDuration));
            SPApplyEffectToObject(DURATION_TYPE_INSTANT, eVis, oTarget);
            StoreSongRecipient(oTarget, OBJECT_SELF, GetSpellId(), nDuration);
        }
        //Select the next target within the spell shape.
        oTarget = GetNextObjectInShape(SHAPE_SPHERE, RADIUS_SIZE_COLOSSAL, lSpell);
    }
    DecrementRemainingFeatUses(OBJECT_SELF, FEAT_BARD_SONGS);
}
