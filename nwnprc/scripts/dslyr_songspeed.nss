
#include "spinc_common"
#include "minstrelsong"
#include "NW_I0_SPELLS"

void main()
{
    if (!GetHasFeat(FEAT_DRAGONSONG_STRENGTH, OBJECT_SELF))
    {
        FloatingTextStringOnCreature("This ability is tied to your dragons song ability, which has no more uses for today.",OBJECT_SELF); // no more bardsong uses left
        return;
    }

    if (GetHasEffect(EFFECT_TYPE_SILENCE,OBJECT_SELF))
    {
       FloatingTextStrRefOnCreature(85764,OBJECT_SELF); // not useable when silenced
       return;
    }
  
    //Declare major variables
    object oTarget;
    effect eDur = EffectVisualEffect(VFX_DUR_CESSATE_POSITIVE);
    effect eFast = EffectMovementSpeedIncrease(50);

    effect eLink = EffectLinkEffects(eFast, eDur);
    int nLevel = GetLevelByClass(CLASS_TYPE_DRAGONSONG_LYRIST);

    //Determine spell duration as an integer for later conversion to Rounds, Turns or Hours.
    int nDuration = 10*nLevel;
    
        //Check to see if the caster has Lasting Impression and increase duration.
    if(GetHasFeat(870))
    {
        nDuration *= 10;
    }

    // lingering song
    if(GetHasFeat(424)) // lingering song
    {
        nDuration += 5;
    }

    location lSpell = GetSpellTargetLocation();
 
    RemoveOldSongEffects(OBJECT_SELF,GetSpellId());
    
    effect eVis = EffectVisualEffect(VFX_DUR_BARD_SONG);  
   // SPApplyEffectToObject(DURATION_TYPE_TEMPORARY, eVis, OBJECT_SELF,RoundsToSeconds(nDuration),FALSE); 


    //Declare the spell shape, size and the location.  Capture the first target object in the shape.
    oTarget = GetFirstObjectInShape(SHAPE_SPHERE, RADIUS_SIZE_HUGE, lSpell);
    //Cycle through the targets within the spell shape until an invalid object is captured or the number of
    //targets affected is equal to the caster level.
    while(GetIsObjectValid(oTarget))
    {
        //Make faction check on the target
        if(oTarget == OBJECT_SELF)
        {
            SPApplyEffectToObject(DURATION_TYPE_TEMPORARY, eLink, oTarget, RoundsToSeconds(nDuration),FALSE);
            SPApplyEffectToObject(DURATION_TYPE_TEMPORARY, eVis, oTarget, RoundsToSeconds(nDuration),FALSE);
            StoreSongRecipient(oTarget, OBJECT_SELF, GetSpellId(), nDuration);
        }
        else if(GetIsFriend(oTarget))
        {
            SPApplyEffectToObject(DURATION_TYPE_TEMPORARY, eLink, oTarget, RoundsToSeconds(nDuration),FALSE);
            SPApplyEffectToObject(DURATION_TYPE_TEMPORARY, eVis, oTarget, RoundsToSeconds(nDuration),FALSE);
            StoreSongRecipient(oTarget, OBJECT_SELF, GetSpellId(), nDuration);
        }
        //Select the next target within the spell shape.
        oTarget = GetNextObjectInShape(SHAPE_SPHERE, RADIUS_SIZE_HUGE, lSpell);
    }
    DecrementRemainingFeatUses(OBJECT_SELF, FEAT_LYRITHSONG1);
    DeleteLocalInt(OBJECT_SELF, "SpellConc");

}
