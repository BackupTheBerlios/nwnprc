#include "spinc_common"
#include "minstrelsong"
#include "NW_I0_SPELLS"

void DominatedDuration(object oTarget, object oCaster)
{
   int iConc = GetLocalInt(oCaster, "SpellConc");
   
   if (!iConc)
   {
        RemoveOldSongEffects(oCaster,SPELL_DSL_SONG_COMPULSION);
        return ;
   }

   if (GetHasSpellEffect(SPELL_DSL_SONG_COMPULSION,oTarget))
   {
      DelayCommand(6.0f,DominatedDuration(oTarget,oCaster) );
   }
}

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
  
    RemoveOldSongEffects(OBJECT_SELF,GetSpellId());
    //Declare major variables
    object oTarget = GetSpellTargetObject();
    object oCaster = OBJECT_SELF;
    effect eDom = EffectDominated();
    eDom = GetScaledEffect(eDom, oTarget);
    effect eMind = EffectVisualEffect(VFX_DUR_MIND_AFFECTING_DOMINATED);
    effect eDur = EffectVisualEffect(VFX_DUR_CESSATE_NEGATIVE);

    //Link domination and persistant VFX
    effect eLink = EffectLinkEffects(eMind, eDom);

    effect eVis = EffectVisualEffect(VFX_IMP_DOMINATE_S);
    int nLevel = GetLevelByClass(CLASS_TYPE_DRAGONSONG_LYRIST);
    effect eVis2 = EffectVisualEffect(VFX_DUR_BARD_SONG);
 
    int nRacial = MyPRCGetRacialType(oTarget);
    int nDC = 12 + GetLevelByClass(CLASS_TYPE_DRAGONSONG_LYRIST,OBJECT_SELF)+ GetAbilityModifier(ABILITY_CHARISMA,OBJECT_SELF);
 
    if (nRacial== RACIAL_TYPE_DRAGON ) nDC-=2;
     
    //Fire cast spell at event for the specified target
    SignalEvent(oTarget, EventSpellCastAt(OBJECT_SELF, SPELL_DOMINATE_MONSTER, FALSE));
    //Make sure the target is a monster
    if(!GetIsReactionTypeFriendly(oTarget))
    {
          //Make a Will Save
          if (!PRCMySavingThrow(SAVING_THROW_WILL, oTarget, nDC, SAVING_THROW_TYPE_MIND_SPELLS))
          {
               //Apply linked effects and VFX Impact
               SPApplyEffectToObject(DURATION_TYPE_PERMANENT, eLink, oTarget, 0.0,FALSE);
               SPApplyEffectToObject(DURATION_TYPE_INSTANT, eVis, oTarget);  
               SPApplyEffectToObject(DURATION_TYPE_PERMANENT, eVis2, OBJECT_SELF,0.0,FALSE);             
               StoreSongRecipient(oTarget, OBJECT_SELF, SPELL_DSL_SONG_COMPULSION, 0);
               SetLocalInt(OBJECT_SELF, "SpellConc", 1);
               DelayCommand(6.0f,DominatedDuration(oTarget,oCaster) );   
          }

     }   
    
    DecrementRemainingFeatUses(OBJECT_SELF, FEAT_LYRITHSONG1);
 

}
