/*
   Nimbus of Light

   Shown a light with radius 5 feets and +2 circumstance bonus to
   persuade, taunt

   Created By: Starlight
   Created On: 2004-5-5
*/

#include "prc_feat_const"
#include "inc_item_props"
#include "x2_inc_itemprop"
#include "nw_i0_spells"

void main(){
   object oPC = OBJECT_SELF;
   object oSkin = GetPCSkin(OBJECT_SELF);
   string nMes = "";
   int nBrightness = IP_CONST_LIGHTBRIGHTNESS_DIM;
   int nColor = IP_CONST_LIGHTCOLOR_WHITE;
   itemproperty ipAdd = ItemPropertyLight(nBrightness, nColor);
   effect ePersuade;
   effect eTaunt;
   effect eLink;

   ePersuade = EffectSkillIncrease(SKILL_PERSUADE, 2);
   eTaunt = EffectSkillIncrease(SKILL_TAUNT, 2);
   eLink = ExtraordinaryEffect(EffectLinkEffects(ePersuade, eTaunt));

   if (GetAlignmentGoodEvil(oPC) == ALIGNMENT_GOOD){
      if (!GetHasFeatEffect(FEAT_NIMBUS_OF_LIGHT) && !GetHasFeatEffect(FEAT_HOLY_RADIANCE)){
         if (!GetIsObjectValid(oSkin)) return;

         // Apply the Light and Skill increase
         IPSafeAddItemProperty(oSkin, ipAdd);
         ApplyEffectToObject(DURATION_TYPE_PERMANENT, eLink, oPC);

         // Display the message
         nMes = "*Nimbus of Light Activated*";
         FloatingTextStringOnCreature(nMes, oPC, FALSE);
      }
      else{
         // Remove the Light and Skill increase
         IPRemoveMatchingItemProperties(oSkin, ITEM_PROPERTY_LIGHT, DURATION_TYPE_PERMANENT);
         RemoveSpecificEffect(EFFECT_TYPE_SKILL_INCREASE, oPC);
         RemoveSpecificEffect(EFFECT_TYPE_SKILL_INCREASE, oPC);
   
         // Display the message
         nMes = "*Nimbus of Light Deactivated*";
         FloatingTextStringOnCreature(nMes, oPC, FALSE);
      }
   }
}
