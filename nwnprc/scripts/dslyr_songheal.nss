//::///////////////////////////////////////////////
//:: Heal
//:: [NW_S0_Heal.nss]
//:: Copyright (c) 2000 Bioware Corp.
//:://////////////////////////////////////////////
//:: Heals the target to full unless they are undead.
//:: If undead they reduced to 1d4 HP.
//:://////////////////////////////////////////////
//:: Created By: Preston Watamaniuk
//:: Created On: Jan 12, 2001
//:://////////////////////////////////////////////
//:: Update Pass By: Preston W, On: Aug 1, 2001

//:: modified by mr_bumpkin Dec 4, 2003 for PRC stuff

//::Added code to maximize for Faith Healing and Blast Infidel
//::Aaon Graywolf - Jan 7, 2004

#include "spinc_common"
#include "minstrelsong"
#include "NW_I0_SPELLS"
#include "x2_inc_spellhook"

void main()
{


  //Declare major variables
  object oTarget = OBJECT_SELF;
  effect eHeal;
  int  nHeal;
  effect eSun = EffectVisualEffect(VFX_IMP_SUNSTRIKE);
  effect eHealVis = EffectVisualEffect(VFX_IMP_HEALING_X);

  if (!GetHasFeat(FEAT_LYRITHSONG1, OBJECT_SELF))
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
  
  //Fire cast spell at event for the specified target
  SignalEvent(oTarget, EventSpellCastAt(OBJECT_SELF, SPELL_HEAL, FALSE));

  
  //Get first target in shape
  oTarget = GetFirstObjectInShape(SHAPE_SPHERE, RADIUS_SIZE_HUGE, GetSpellTargetLocation());
  while (GetIsObjectValid(oTarget))
  {

     if(GetIsReactionTypeFriendly(oTarget)|| GetFactionEqual(oTarget))
     {

        //Figure out how much to heal
        nHeal = GetMaxHitPoints(oTarget);

        //Set the heal effect
        eHeal = EffectHeal(nHeal);
        //Apply the heal effect and the VFX impact
        SPApplyEffectToObject(DURATION_TYPE_INSTANT, eHealVis, oTarget);
        SPApplyEffectToObject(DURATION_TYPE_INSTANT, eHeal, oTarget);
        
        // Code for FB to remove damage that would be caused at end of Frenzy
        SetLocalInt(oTarget, "PC_Damage", 0);
     }
     //Get next target in the shape
     oTarget = GetNextObjectInShape(SHAPE_SPHERE, RADIUS_SIZE_HUGE, GetSpellTargetLocation());
  }
 
  DecrementRemainingFeatUses(OBJECT_SELF, FEAT_LYRITHSONG1);
  DeleteLocalInt(OBJECT_SELF, "SpellConc");

}
