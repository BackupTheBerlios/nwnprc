//::///////////////////////////////////////////////
//:: Fist of Hextor
//:: prc_hextor.nss
//:://////////////////////////////////////////////
//:: Applies Fist of Hextor Bonuses
//:://////////////////////////////////////////////
//:: Created By: Stratovarius
//:: Created On: April 20, 2004
//:://////////////////////////////////////////////

#include "inc_item_props"
#include "prc_feat_const"
#include "prc_class_const"


/// Removes the Fist of Hextor Brutal Strike ///
void RemoveBrutalStrike(object oPC, int iEquip)
{
     object oItem = GetPCItemLastUnequipped();
     int bHasBow = FALSE;
     
     if (GetHasFeat(FEAT_BSTRIKE_A4, oPC))
     {
         RemoveSpecificProperty(oItem, ITEM_PROPERTY_ATTACK_BONUS, IP_CONST_FEAT_ROGUE_SA_4D6);
     }
     else if (GetHasFeat(FEAT_BSTRIKE_A3, oPC))
     {
         RemoveSpecificProperty(oItem, ITEM_PROPERTY_ATTACK_BONUS, IP_CONST_FEAT_ROGUE_SA_3D6);
     }
     else if (GetHasFeat(FEAT_BSTRIKE_A2, oPC))
     {
         RemoveSpecificProperty(oItem, ITEM_PROPERTY_ATTACK_BONUS, IP_CONST_FEAT_ROGUE_SA_2D6);
     }
     else if (GetHasFeat(FEAT_BSTRIKE_A1, oPC))
     {
         RemoveSpecificProperty(oItem, ITEM_PROPERTY_ATTACK_BONUS, IP_CONST_FEAT_ROGUE_SA_1D6);
     }

     SetLocalInt(oPC, "BSHextor", 1);
}


/// Applies the Fist of Hextor Brutal Strike to its weapon ///
void AddBrutalStrike(object oPC , int iEquip)
{
      object oWeapon = GetPCItemLastEquipped();

      if (iEquip = 2)      // On Equip
      {
                     //Fist of Hextor Attack from Brutal Strike
                     if (GetHasFeat(FEAT_BSTRIKE_A4 oPC))
                     {
                     AddItemProperty(DURATION_TYPE_PERMANENT, ItemPropertyBonusFeat(IP_CONST_FEAT_ROGUE_SA_4D6), oWeapon);
                     }
                     else if (GetHasFeat(FEAT_BSTRIKE_A3 oPC))
                     {
                     AddItemProperty(DURATION_TYPE_PERMANENT, ItemPropertyBonusFeat(IP_CONST_FEAT_ROGUE_SA_3D6), oWeapon);
                     }
                     else if (GetHasFeat(FEAT_BSTRIKE_A2 oPC))
                     {
                     AddItemProperty(DURATION_TYPE_PERMANENT, ItemPropertyBonusFeat(IP_CONST_FEAT_ROGUE_SA_2D6), oWeapon);
                     }
                     else if (GetHasFeat(FEAT_BSTRIKE_A1, oPC))
                     {
                     AddItemProperty(DURATION_TYPE_PERMANENT, ItemPropertyBonusFeat(IP_CONST_FEAT_ROGUE_SA_1D6), oWeapon);
                     }

                     //Fist of Hextor Damage from Brutal Strike
                     if (GetHasFeat(FEAT_BSTRIKE_D4 oPC))
                     {
                     AddItemProperty(DURATION_TYPE_PERMANENT, ItemPropertyDamageBonus(DAMAGE_TYPE_BLUDGEONING, DAMAGE_BONUS_4), oWeapon);
                     }
                     else if (GetHasFeat(FEAT_BSTRIKE_D3 oPC))
                     {
                     AddItemProperty(DURATION_TYPE_PERMANENT, ItemPropertyDamageBonus(DAMAGE_TYPE_BLUDGEONING, DAMAGE_BONUS_3), oWeapon);
                     }
                     else if (GetHasFeat(FEAT_BSTRIKE_D2 oPC))
                     {
                     AddItemProperty(DURATION_TYPE_PERMANENT, ItemPropertyDamageBonus(DAMAGE_TYPE_BLUDGEONING, DAMAGE_BONUS_2), oWeapon);
                     }
                     else if (GetHasFeat(FEAT_BSTRIKE_D1, oPC))
                     {
                     AddItemProperty(DURATION_TYPE_PERMANENT, ItemPropertyDamageBonus(DAMAGE_TYPE_BLUDGEONING, DAMAGE_BONUS_1), oWeapon);
                     }

             SetLocalInt(oPC, "BSHextor", 2);
      }
      else if(iEquip = 1)  // Unequip
      {
          RemoveBrutalStrike(oPC, iEquip);
          return;
      }
      else
      {

                     //Fist of Hextor Attack from Brutal Strike
                     if (GetHasFeat(FEAT_BSTRIKE_A4 oPC))
                     {
                     AddItemProperty(DURATION_TYPE_PERMANENT, ItemPropertyBonusFeat(IP_CONST_FEAT_ROGUE_SA_4D6), oWeapon);
                     }
                     else if (GetHasFeat(FEAT_BSTRIKE_A3 oPC))
                     {
                     AddItemProperty(DURATION_TYPE_PERMANENT, ItemPropertyBonusFeat(IP_CONST_FEAT_ROGUE_SA_3D6), oWeapon);
                     }
                     else if (GetHasFeat(FEAT_BSTRIKE_A2 oPC))
                     {
                     AddItemProperty(DURATION_TYPE_PERMANENT, ItemPropertyBonusFeat(IP_CONST_FEAT_ROGUE_SA_2D6), oWeapon);
                     }
                     else if (GetHasFeat(FEAT_BSTRIKE_A1, oPC))
                     {
                     AddItemProperty(DURATION_TYPE_PERMANENT, ItemPropertyBonusFeat(IP_CONST_FEAT_ROGUE_SA_1D6), oWeapon);
                     }

                     //Fist of Hextor Damage from Brutal Strike
                     if (GetHasFeat(FEAT_BSTRIKE_D4 oPC))
                     {
                     AddItemProperty(DURATION_TYPE_PERMANENT, ItemPropertyDamageBonus(DAMAGE_TYPE_BLUDGEONING, DAMAGE_BONUS_4), oWeapon);
                     }
                     else if (GetHasFeat(FEAT_BSTRIKE_D3 oPC))
                     {
                     AddItemProperty(DURATION_TYPE_PERMANENT, ItemPropertyDamageBonus(DAMAGE_TYPE_BLUDGEONING, DAMAGE_BONUS_3), oWeapon);
                     }
                     else if (GetHasFeat(FEAT_BSTRIKE_D2 oPC))
                     {
                     AddItemProperty(DURATION_TYPE_PERMANENT, ItemPropertyDamageBonus(DAMAGE_TYPE_BLUDGEONING, DAMAGE_BONUS_2), oWeapon);
                     }
                     else if (GetHasFeat(FEAT_BSTRIKE_D1, oPC))
                     {
                     AddItemProperty(DURATION_TYPE_PERMANENT, ItemPropertyDamageBonus(DAMAGE_TYPE_BLUDGEONING, DAMAGE_BONUS_1), oWeapon);
                     }

             SetLocalInt(oPC, "BSHextor", 2);

      }
}



void main()
{
    //Declare main variables.
    object oPC = OBJECT_SELF;
    object oSkin = GetPCSkin(oPC);
    int iEquip = GetLocalInt(oPC, "ONEQUIP");

    if (iEquip == 1)    RemoveBrutalStrike(oPC, iEquip);
    if (iEquip == 2)    AddBrutalStrike(oPC, iEquip);
}