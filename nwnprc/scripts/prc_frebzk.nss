//::///////////////////////////////////////////////
//:: Frenzied Berserker - Armor/Skin
//:://////////////////////////////////////////////
/*
    Script to modify skin of Frenzied Berserker
*/
//:://////////////////////////////////////////////
//:: Created By: Oni5115
//:: Created On: Feb 26, 2004
//:://////////////////////////////////////////////

#include "inc_item_props"

#include "prc_feat_const"
#include "prc_class_const"
#include "prc_spell_const"

#include "x2_inc_itemprop" // for checking if item is a weapon

// Used to add/remove the auto frenzy property on creature skin
void AutoFrenzy(object oPC,int iEquip)
{
     object oItem;
     if (iEquip==2)       // On Equip
     {
          oItem = GetItemInSlot(INVENTORY_SLOT_CHEST, oPC);
          if( GetLocalInt(oItem, "AFrenzy") )
          {
              return;
          }

          if(GetBaseItemType(oItem) == BASE_ITEM_ARMOR)
          {
             AddItemProperty(DURATION_TYPE_PERMANENT,ItemPropertyOnHitCastSpell(IP_CONST_ONHIT_CASTSPELL_ONHIT_UNIQUEPOWER,1),oItem);
             SetLocalInt(oItem,"AFrenzy",1);
          }
     }
     else if(iEquip == 1)  // Unequip
     {
          oItem=GetPCItemLastUnequipped();
          if(GetBaseItemType(oItem) != BASE_ITEM_ARMOR)
          {
               return;
          }
          
          RemoveSpecificProperty(oItem,ITEM_PROPERTY_ONHITCASTSPELL,IP_CONST_ONHIT_CASTSPELL_ONHIT_UNIQUEPOWER,0);
          DeleteLocalInt(oItem,"AFrenzy");
    }
    else
    {
          oItem = GetItemInSlot(INVENTORY_SLOT_CHEST, oPC);
          if( !GetLocalInt(oItem,"AFrenzy")&& GetBaseItemType(oItem) == BASE_ITEM_ARMOR)
          {
               AddItemProperty(DURATION_TYPE_PERMANENT,ItemPropertyOnHitCastSpell(IP_CONST_ONHIT_CASTSPELL_ONHIT_UNIQUEPOWER,1),oItem);
               SetLocalInt(oItem,"AFrenzy",1);
          }
    }
}

void CheckSupremePowerAttack(object oPC, int iEquip)
{
      object oWeapon = GetPCItemLastUnequipped();
      int bIsWeapon = FALSE;
      int bHasFeatActive = FALSE;
      
      if (iEquip == 1) // Unequip
      {
           AssignCommand(OBJECT_SELF, ActionUseFeat(FEAT_SUPREME_POWER_ATTACK, OBJECT_SELF) );
      }
}

void main()
{
    //Declare main variables.
    object oPC = OBJECT_SELF;
    int iEquip = GetLocalInt(oPC, "ONEQUIP");
    
    int nFrenzy = GetHasFeat(FEAT_FRENZY);
    if(nFrenzy != 0)
    {
        AutoFrenzy(oPC,GetLocalInt(oPC, "ONEQUIP") );
    }
    
    CheckSupremePowerAttack(oPC, iEquip);
}
