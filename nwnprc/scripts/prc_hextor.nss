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

     if (GetHasFeat(FEAT_BSTRIKE_A4, oPC))
     {
         RemoveSpecificProperty(oItem, ITEM_PROPERTY_ATTACK_BONUS, 4);
     }
     else if (GetHasFeat(FEAT_BSTRIKE_A3, oPC))
     {
         RemoveSpecificProperty(oItem, ITEM_PROPERTY_ATTACK_BONUS, 3);
     }
     else if (GetHasFeat(FEAT_BSTRIKE_A2, oPC))
     {
         RemoveSpecificProperty(oItem, ITEM_PROPERTY_ATTACK_BONUS, 2);
     }
     else if (GetHasFeat(FEAT_BSTRIKE_A1, oPC))
     {
         RemoveSpecificProperty(oItem, ITEM_PROPERTY_ATTACK_BONUS, 1);
     }

     if (GetHasFeat(FEAT_BSTRIKE_D4, oPC))
     {
         RemoveSpecificProperty(oItem, ITEM_PROPERTY_DAMAGE_BONUS, IP_CONST_DAMAGEBONUS_4);
     }
     else if (GetHasFeat(FEAT_BSTRIKE_D3, oPC))
     {
         RemoveSpecificProperty(oItem, ITEM_PROPERTY_DAMAGE_BONUS, IP_CONST_DAMAGEBONUS_3);
     }
     else if (GetHasFeat(FEAT_BSTRIKE_D2, oPC))
     {
         RemoveSpecificProperty(oItem, ITEM_PROPERTY_DAMAGE_BONUS, IP_CONST_DAMAGEBONUS_2);
     }
     else if (GetHasFeat(FEAT_BSTRIKE_D1, oPC))
     {
         RemoveSpecificProperty(oItem, ITEM_PROPERTY_DAMAGE_BONUS, IP_CONST_DAMAGEBONUS_1);
     }

     SetLocalInt(oPC, "BSHextor", 1);
}


/// Applies the Fist of Hextor Brutal Strike to its weapon ///
void AddBrutalStrike(object oPC , int iEquip)
{
      SendMessageToPC(oPC, "You Have Activated Brutal Strike");
      object oWeapon = GetPCItemLastEquipped();

      if (iEquip = 2)      // On Equip
      {

      SendMessageToPC(oPC, "You Have Equipped a Weapon");

                     //Fist of Hextor Attack from Brutal Strike
                     if (GetHasFeat(FEAT_BSTRIKE_A4, oPC))
                     {
                     AddItemProperty(DURATION_TYPE_PERMANENT, ItemPropertyAttackBonus(4), oWeapon);
                     }
                     else if (GetHasFeat(FEAT_BSTRIKE_A3, oPC))
                     {
                     AddItemProperty(DURATION_TYPE_PERMANENT, ItemPropertyAttackBonus(3), oWeapon);
                     }
                     else if (GetHasFeat(FEAT_BSTRIKE_A2, oPC))
                     {
                     AddItemProperty(DURATION_TYPE_PERMANENT, ItemPropertyAttackBonus(2), oWeapon);
                     }
                     else if (GetHasFeat(FEAT_BSTRIKE_A1, oPC))
                     {
                     AddItemProperty(DURATION_TYPE_PERMANENT, ItemPropertyAttackBonus(1), oWeapon);
                     }

                     //Fist of Hextor Damage from Brutal Strike
                     if (GetHasFeat(FEAT_BSTRIKE_D4, oPC))
                     {
                     AddItemProperty(DURATION_TYPE_PERMANENT, ItemPropertyDamageBonus(DAMAGE_TYPE_BLUDGEONING, DAMAGE_BONUS_4), oWeapon);
                     }
                     else if (GetHasFeat(FEAT_BSTRIKE_D3, oPC))
                     {
                     AddItemProperty(DURATION_TYPE_PERMANENT, ItemPropertyDamageBonus(DAMAGE_TYPE_BLUDGEONING, DAMAGE_BONUS_3), oWeapon);
                     }
                     else if (GetHasFeat(FEAT_BSTRIKE_D2, oPC))
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
                     if (GetHasFeat(FEAT_BSTRIKE_A4, oPC))
                     {
                     AddItemProperty(DURATION_TYPE_PERMANENT, ItemPropertyAttackBonus(4), oWeapon);
                     }
                     else if (GetHasFeat(FEAT_BSTRIKE_A3, oPC))
                     {
                     AddItemProperty(DURATION_TYPE_PERMANENT, ItemPropertyAttackBonus(3), oWeapon);
                     }
                     else if (GetHasFeat(FEAT_BSTRIKE_A2, oPC))
                     {
                     AddItemProperty(DURATION_TYPE_PERMANENT, ItemPropertyAttackBonus(2), oWeapon);
                     }
                     else if (GetHasFeat(FEAT_BSTRIKE_A1, oPC))
                     {
                     AddItemProperty(DURATION_TYPE_PERMANENT, ItemPropertyAttackBonus(1), oWeapon);
                     }

                     //Fist of Hextor Damage from Brutal Strike
                     if (GetHasFeat(FEAT_BSTRIKE_D4, oPC))
                     {
                     AddItemProperty(DURATION_TYPE_PERMANENT, ItemPropertyDamageBonus(DAMAGE_TYPE_BLUDGEONING, DAMAGE_BONUS_4), oWeapon);
                     }
                     else if (GetHasFeat(FEAT_BSTRIKE_D3, oPC))
                     {
                     AddItemProperty(DURATION_TYPE_PERMANENT, ItemPropertyDamageBonus(DAMAGE_TYPE_BLUDGEONING, DAMAGE_BONUS_3), oWeapon);
                     }
                     else if (GetHasFeat(FEAT_BSTRIKE_D2, oPC))
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

void Test(object oPC , int iEquip)
{
    SendMessageToPC(oPC, "iEquip = " + IntToString(iEquip));
}

void main()
{
    //Declare main variables.
    object oPC = OBJECT_SELF;
    object oSkin = GetPCSkin(oPC);
    int iEquip = GetLocalInt(oPC, "ONEQUIP");

    SendMessageToPC(oPC, "You are a Fist of Hextor");
    Test(oPC, iEquip);

if (iEquip == 2)
    {
        AddBrutalStrike(oPC , iEquip);
    }
/*
    if (iEquip == 1)    RemoveBrutalStrike(oPC, iEquip);
    if (iEquip == 2)    AddBrutalStrike(oPC, iEquip);
*/
}