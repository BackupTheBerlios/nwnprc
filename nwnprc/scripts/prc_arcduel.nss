#include "prc_class_const"
#include "prc_feat_const"
#include "inc_item_props"


// * Applies the Arcane Duelist's AC bonus as a CompositeBonus on object's skin.
void ApparentDefense(object oPC, object oSkin)
{
    if(GetLocalInt(oSkin, "ADDef") == TRUE) return;

    SetCompositeBonus(oSkin, "ADDef", GetAbilityModifier(ABILITY_CHARISMA, oPC), ITEM_PROPERTY_AC_BONUS);
    SetLocalInt(oSkin, "ADDef", TRUE);
}


// * Removes the Arcane Duelist's Enchant Chosen Weapon bonus
void RemoveEnchantCW(object oPC, object oWeap)
{
      if (GetLocalInt(oWeap, "ADEnchant"))
      {
         SetCompositeBonusT(oWeap, "ADEnchant", 0, ITEM_PROPERTY_ENHANCEMENT_BONUS);
      }
}

// * Applies the Arcane Duelist's Enchant Chosen Weapon bonus
void EnchantCW(object oPC, object oWeap)
{
   int iBonus = 0;

   RemoveEnchantCW(oPC, oWeap);

      if (GetLevelByClass(CLASS_TYPE_ARCANE_DUELIST, oPC) >= 1)
         iBonus = 1;

      if (GetLevelByClass(CLASS_TYPE_ARCANE_DUELIST, oPC) >= 4)
         iBonus = 2;
         
      if (GetLevelByClass(CLASS_TYPE_ARCANE_DUELIST, oPC) >= 6)
         iBonus = 3;
	 
      if (GetLevelByClass(CLASS_TYPE_ARCANE_DUELIST, oPC) >= 8)
         iBonus = 4;

      if ((GetLocalInt(oWeap, "ADEnchant") != iBonus) && (iBonus))
      {
         SetCompositeBonusT(oWeap, "ADEnchant", iBonus, ITEM_PROPERTY_ENHANCEMENT_BONUS);
      }

}

void main()
{
  object oPC = OBJECT_SELF;
  object oSkin = GetPCSkin(oPC);

  int iClassLVLArcDuelist = GetLevelByClass(CLASS_TYPE_ARCANE_DUELIST, oPC);
  int iHasFeat1 = GetHasFeat(FEAT_AD_ENCHANT_CHOSEN_WEAPON, oPC);

  object oWeapon = GetLocalObject(oPC, "CHOSEN_WEAPON");

  if (GetHasFeat(FEAT_AD_APPARENT_DEFENSE, oPC)) ApparentDefense(oPC, oSkin);
  
  if (GetPCItemLastEquipped() == oWeapon)
  	EnchantCW(oPC, oWeapon);
  
  if (GetLocalInt(oPC,"ONEQUIP") == 1)
        RemoveEnchantCW(oPC, GetPCItemLastUnequipped());

}
