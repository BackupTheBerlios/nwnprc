#include "inc_item_props"
#include "prc_feat_const"
#include "prc_class_const"

/// +3 on Craft Weapon /////////
void Expert_Bowyer(object oPC ,object oSkin ,int nBowyer)
{

   if(GetLocalInt(oSkin, "PABowyer") == nBowyer) return;

    SetCompositeBonus(oSkin, "PABowyer", nBowyer, ITEM_PROPERTY_SKILL_BONUS, SKILL_CRAFT_WEAPON);
}

/// Removes the Peerless Archer Sneak Attack ///
void RemoveSneakAttack(object oPC, int iEquip)
{

     object oItem = GetPCItemLastUnequipped();

     if(GetBaseItemType(oItem) != BASE_ITEM_LONGBOW || GetBaseItemType(oItem) != BASE_ITEM_SHORTBOW)	return;

     if (GetHasFeat(FEAT_PA_SNEAK_4D6, oPC))
     {
         RemoveSpecificProperty(oItem, ITEM_PROPERTY_BONUS_FEAT, IP_CONST_FEAT_ROGUE_SA_4D6);
     }
     else if (GetHasFeat(FEAT_PA_SNEAK_3D6, oPC))
     {
         RemoveSpecificProperty(oItem, ITEM_PROPERTY_BONUS_FEAT, IP_CONST_FEAT_ROGUE_SA_3D6);
     }
     else if (GetHasFeat(FEAT_PA_SNEAK_2D6, oPC))
     {
         RemoveSpecificProperty(oItem, ITEM_PROPERTY_BONUS_FEAT, IP_CONST_FEAT_ROGUE_SA_2D6);
     }
     else if (GetHasFeat(FEAT_PA_SNEAK_1D6, oPC))
     {
         RemoveSpecificProperty(oItem, ITEM_PROPERTY_BONUS_FEAT, IP_CONST_FEAT_ROGUE_SA_1D6);
     }

     SetLocalInt(oPC, "HasPASneak", 1);
}

/// Applies the Peerless Archer Sneak Attack to its bow ///
void AddSneakAttack(object oPC , int iEquip)
{
   object oWeapon = GetPCItemLastEquipped();


      if (iEquip = 2)      // On Equip
      {
          if (GetBaseItemType(oWeapon) == BASE_ITEM_LONGBOW || GetBaseItemType(oWeapon) == BASE_ITEM_SHORTBOW)
          {

                     if (GetHasFeat(FEAT_PA_SNEAK_4D6, oPC))
                     {
                     AddItemProperty(DURATION_TYPE_PERMANENT, ItemPropertyBonusFeat(IP_CONST_FEAT_ROGUE_SA_4D6), oWeapon);
                     }
                     else if (GetHasFeat(FEAT_PA_SNEAK_3D6, oPC))
                     {
                     AddItemProperty(DURATION_TYPE_PERMANENT, ItemPropertyBonusFeat(IP_CONST_FEAT_ROGUE_SA_3D6), oWeapon);
                     }
                     else if (GetHasFeat(FEAT_PA_SNEAK_2D6, oPC))
                     {
                     AddItemProperty(DURATION_TYPE_PERMANENT, ItemPropertyBonusFeat(IP_CONST_FEAT_ROGUE_SA_2D6), oWeapon);
                     }
                     else if (GetHasFeat(FEAT_PA_SNEAK_1D6, oPC))
                     {
                     AddItemProperty(DURATION_TYPE_PERMANENT, ItemPropertyBonusFeat(IP_CONST_FEAT_ROGUE_SA_1D6), oWeapon);
                     }

             SetLocalInt(oPC, "HasPASneak", 2);
          }
      }
      else if(iEquip = 1)  // Unequip
      {
          RemoveSneakAttack(oPC, iEquip);
          return;
      }
      else
      {
      SendMessageToPC(oPC, "Peerless has equipped a Weapon");
          if (GetBaseItemType(oWeapon) == BASE_ITEM_LONGBOW || GetBaseItemType(oWeapon) == BASE_ITEM_SHORTBOW)
          {

                     SendMessageToPC(oPC, "Peerless has equipped a Bow");
                     if (GetHasFeat(FEAT_PA_SNEAK_4D6, oPC))
                     {
                     AddItemProperty(DURATION_TYPE_PERMANENT, ItemPropertyBonusFeat(IP_CONST_FEAT_ROGUE_SA_4D6), oWeapon);
                     }
                     else if (GetHasFeat(FEAT_PA_SNEAK_3D6, oPC))
                     {
                     AddItemProperty(DURATION_TYPE_PERMANENT, ItemPropertyBonusFeat(IP_CONST_FEAT_ROGUE_SA_3D6), oWeapon);
                     }
                     else if (GetHasFeat(FEAT_PA_SNEAK_2D6, oPC))
                     {
                     AddItemProperty(DURATION_TYPE_PERMANENT, ItemPropertyBonusFeat(IP_CONST_FEAT_ROGUE_SA_2D6), oWeapon);
                     }
                     else if (GetHasFeat(FEAT_PA_SNEAK_1D6, oPC))
                     {
                     AddItemProperty(DURATION_TYPE_PERMANENT, ItemPropertyBonusFeat(IP_CONST_FEAT_ROGUE_SA_1D6), oWeapon);
                     }

             SetLocalInt(oPC, "HasPASneak", 2);
          }
      }
   
}

void main()
{

     //Declare main variables.
    object oPC = OBJECT_SELF;
    object oSkin = GetPCSkin(oPC);

    int iSneak = GetLocalInt(oPC, "HasPASneak");
    int nBowyer = GetHasFeat(FEAT_EXPERT_BOWYER, oPC) ? 3 : 0;
    int iEquip = GetLocalInt(oPC, "ONEQUIP");


    if (nBowyer>0) Expert_Bowyer(oPC, oSkin, nBowyer);

    // On error - Typically when first entering a module
    //if(iSneak = 0)
    //{
    //	 RemoveSneakAttack(oPC, iEquip);
    //}
    //else if(iSneak = 1) // if Sneak has been removed
    //{

    if (iEquip = 1)
    {
        SendMessageToPC(oPC, IntToString(iEquip));
        RemoveSneakAttack(oPC, iEquip);
        SendMessageToPC(oPC, "Peerless has unequipped a Weapon");
    }
    
    if (iEquip = 2)    AddSneakAttack(oPC, iEquip);
    //}
}