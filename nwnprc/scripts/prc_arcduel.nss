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
         RemoveSpecificProperty(oWeap, ITEM_PROPERTY_ENHANCEMENT_BONUS, -1, -1, 1, "ADEnchant", -1, DURATION_TYPE_TEMPORARY);
      }
}

int GetWeaponEnhancement(object oWeap)
{
    int iBonus = 0;
    int iTemp;

    itemproperty ip = GetFirstItemProperty(oWeap);
    while(GetIsItemPropertyValid(ip))
    {
        if(GetItemPropertyType(ip) == ITEM_PROPERTY_ENHANCEMENT_BONUS)
            iTemp = GetItemPropertyCostTableValue(ip);
            iBonus = iTemp > iBonus ? iTemp : iBonus;
        ip = GetNextItemProperty(oWeap);
    }
    return iBonus;
}

// * Applies the Arcane Duelist's Enchant Chosen Weapon bonus
void EnchantCW(object oPC, object oWeap)
{
   int iBonus = 0;

   RemoveEnchantCW(oPC, oWeap);
   iBonus = GetWeaponEnhancement(oWeap);

      if (GetLevelByClass(CLASS_TYPE_ARCANE_DUELIST, oPC) >= 1)
         iBonus += 1;

      if (GetLevelByClass(CLASS_TYPE_ARCANE_DUELIST, oPC) >= 4)
         iBonus += 1;
         
      if (GetLevelByClass(CLASS_TYPE_ARCANE_DUELIST, oPC) >= 6)
         iBonus += 1;
	 
      if (GetLevelByClass(CLASS_TYPE_ARCANE_DUELIST, oPC) >= 8)
         iBonus += 1;
               

      AddItemProperty(DURATION_TYPE_TEMPORARY, ItemPropertyEnhancementBonus(iBonus),oWeap, 9999.0);
      SetLocalInt(oWeap, "ADEnchant", iBonus);
}

void main()
{
  object oPC = OBJECT_SELF;
  object oSkin = GetPCSkin(oPC);
  object oWeapon = GetLocalObject(oPC, "CHOSEN_WEAPON");

  if (GetHasFeat(FEAT_AD_APPARENT_DEFENSE, oPC)) ApparentDefense(oPC, oSkin);
  
  EnchantCW(oPC, oWeapon);
  
  if (GetLocalInt(oPC,"ONEQUIP") == 1)
        RemoveEnchantCW(oPC, GetPCItemLastUnequipped());

}
