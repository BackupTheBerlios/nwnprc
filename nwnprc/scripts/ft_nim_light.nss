/*
   Holy Radiance

   Shown a light with radius 10 feets and all undead within the same
   radius get 1d4 damage per round

   Created By: Starlight
   Created On: 2004-5-6
   Script Originated from: Rick Burton (Midnight)
*/

#include "prc_feat_const"
#include "inc_item_props"
#include "x2_inc_itemprop"
#include "nw_i0_spells"

void main(){
   object oPC = OBJECT_SELF;
   object oSkin = GetPCSkin(OBJECT_SELF);
   string nMes = "";
   int nBrightness = IP_CONST_LIGHTBRIGHTNESS_LOW;
   int nColor = IP_CONST_LIGHTCOLOR_WHITE;
   itemproperty ipAdd = ItemPropertyLight(nBrightness, nColor);
   effect eAOE = EffectAreaOfEffect(AOE_MOB_CIRCGOOD, "enter_holy_rad", "in_holy_rad", "exit_holy_rad");
   effect eVisual = EffectVisualEffect(VFX_IMP_AURA_HOLY);
   effect eLink = EffectLinkEffects(ExtraordinaryEffect(eAOE), eVisual);

   if (GetAlignmentGoodEvil(oPC) == ALIGNMENT_GOOD){
      if (!GetHasFeatEffect(FEAT_HOLYRADIANCE) && !GetHasFeatEffect(FEAT_NIMBUSLIGHT)){
         if (!GetIsObjectValid(oSkin)) return;
   
         // Apply the Light and Skill increase
         IPSafeAddItemProperty(oSkin, ipAdd);
         ApplyEffectToObject(DURATION_TYPE_PERMANENT, eLink, oPC);

         // Display the message
         nMes = "*Holy Radiance Activated*";
         FloatingTextStringOnCreature(nMes, oPC, FALSE);
      }
      else{
         // Remove the Light and Skill increase
         IPRemoveMatchingItemProperties(oSkin, ITEM_PROPERTY_LIGHT, DURATION_TYPE_PERMANENT);
         RemoveSpecificEffect(EFFECT_TYPE_AREA_OF_EFFECT, oPC);
         RemoveSpecificEffect(EFFECT_TYPE_VISUALEFFECT, oPC);

         // Display the message
         nMes = "*Holy Radiance Deactivated*";
         FloatingTextStringOnCreature(nMes, oPC, FALSE);
      }
   }
}
