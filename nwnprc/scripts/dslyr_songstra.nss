
#include "NW_I0_SPELLS"
#include "minstrelsong"

void main()
{
    //Declare major variables
    object oTarget = GetEnteringObject();

    effect eVis = EffectVisualEffect(VFX_IMP_IMPROVE_ABILITY_SCORE);
    effect eDur = EffectVisualEffect(VFX_DUR_CESSATE_POSITIVE);
    effect eStr = EffectAbilityIncrease(ABILITY_STRENGTH,4);
    effect eLink = EffectLinkEffects(eStr, eDur);
           
     if(GetIsReactionTypeFriendly(oTarget,GetAreaOfEffectCreator())|| GetFactionEqual(oTarget,GetAreaOfEffectCreator()) )
     {
        if (!GetHasEffect(EFFECT_TYPE_DEAF,oTarget)) // deaf targets can't hear the song.
        {
           //Fire cast spell at event for the specified target
           SignalEvent(oTarget, EventSpellCastAt(GetAreaOfEffectCreator(), SPELL_BULLS_STRENGTH));
           SPApplyEffectToObject(DURATION_TYPE_PERMANENT, SupernaturalEffect(eLink), oTarget, 0.0,FALSE);

           SPApplyEffectToObject(DURATION_TYPE_INSTANT, eVis, oTarget);
           
           
           StoreSongRecipient(oTarget, OBJECT_SELF, GetSpellId(), 0);
        }
     }
     
  
}
