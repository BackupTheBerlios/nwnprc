#include "inc_item_props"
#include "prc_feat_const"
#include "inc_combat"
#include "prc_ipfeat_const"


int isSimple(object oItem)
{
      int iType= GetBaseItemType(oItem);

      switch (iType)
      {
        case BASE_ITEM_CLUB:
        case BASE_ITEM_DAGGER:
        case BASE_ITEM_LIGHTMACE:
        case BASE_ITEM_MORNINGSTAR:
        case BASE_ITEM_QUARTERSTAFF:
        case BASE_ITEM_SHORTSPEAR:
        case BASE_ITEM_SICKLE:
        case BASE_ITEM_SLING:
        case BASE_ITEM_DART:
        case BASE_ITEM_LIGHTCROSSBOW:
        case BASE_ITEM_HEAVYCROSSBOW:
          return 1;
          break;
      }
      return 0;
}

void main()
{
   object oPC = OBJECT_SELF;
   object oSkin = GetPCSkin(oPC);

   if(GetHasFeat(FEAT_INTUITIVE_ATTACK, oPC))
   {
      object oItem ;
      int iEquip = GetLocalInt(oPC,"ONEQUIP") ;
      int iStr =  GetAbilityModifier(ABILITY_STRENGTH,oPC);
      int iWis =  GetAbilityModifier(ABILITY_WISDOM,oPC);
          iWis = iWis > iStr ? iWis : 0;

      if (iEquip == 1)
           oItem = GetPCItemLastUnequipped();
      else
           oItem = GetItemInSlot(INVENTORY_SLOT_RIGHTHAND,oPC);

      if (isSimple(oItem))
      {
        if(iEquip == 1)
          SetCompositeBonus(oItem,"IntuiAtk",0,ITEM_PROPERTY_ATTACK_BONUS);
        else
          SetCompositeBonus(oItem,"IntuiAtk",iWis+GetWeaponEnhancement(oItem),ITEM_PROPERTY_ATTACK_BONUS);
      }

      if (iEquip ==0)
      {
         oItem = GetItemInSlot(INVENTORY_SLOT_LEFTHAND,oPC);
         SetCompositeBonus(oItem,"IntuiAtk",iWis+GetWeaponEnhancement(oItem),ITEM_PROPERTY_ATTACK_BONUS);
      }

     object oCweapB = GetItemInSlot(INVENTORY_SLOT_CWEAPON_B,oPC);
     object oCweapL = GetItemInSlot(INVENTORY_SLOT_CWEAPON_L,oPC);
     object oCweapR = GetItemInSlot(INVENTORY_SLOT_CWEAPON_R,oPC);
     SetCompositeBonus(oCweapB,"IntuiAtk",iWis,ITEM_PROPERTY_ATTACK_BONUS);
     SetCompositeBonus(oCweapL,"IntuiAtk",iWis,ITEM_PROPERTY_ATTACK_BONUS);
     SetCompositeBonus(oCweapR,"IntuiAtk",iWis,ITEM_PROPERTY_ATTACK_BONUS);


   }

   if (GetHasFeat(FEAT_RAVAGEGOLDENICE, oPC))
   {


       int iEquip = GetLocalInt(oPC,"ONEQUIP") ;
       object oItem;
       if (iEquip == 1)
       {
          oItem = GetPCItemLastUnequipped();
          if (GetBaseItemType(oItem)==BASE_ITEM_GLOVES)
             RemoveSpecificProperty(oItem,ITEM_PROPERTY_ONHITCASTSPELL,IP_CONST_ONHIT_CASTSPELL_RAVAGEGOLDENICE);
       }
       else
       {
         oItem = GetItemInSlot(INVENTORY_SLOT_ARMS,oPC);
         RemoveSpecificProperty(oItem,ITEM_PROPERTY_ONHITCASTSPELL,IP_CONST_ONHIT_CASTSPELL_RAVAGEGOLDENICE);
         AddItemProperty(DURATION_TYPE_PERMANENT,ItemPropertyOnHitCastSpell(IP_CONST_ONHIT_CASTSPELL_RAVAGEGOLDENICE,2),oItem);
       }

        object oCweapB = GetItemInSlot(INVENTORY_SLOT_CWEAPON_B,oPC);
        object oCweapL = GetItemInSlot(INVENTORY_SLOT_CWEAPON_L,oPC);
        object oCweapR = GetItemInSlot(INVENTORY_SLOT_CWEAPON_R,oPC);
        RemoveSpecificProperty(oCweapB,ITEM_PROPERTY_ONHITCASTSPELL,IP_CONST_ONHIT_CASTSPELL_RAVAGEGOLDENICE);
        RemoveSpecificProperty(oCweapL,ITEM_PROPERTY_ONHITCASTSPELL,IP_CONST_ONHIT_CASTSPELL_RAVAGEGOLDENICE);
        RemoveSpecificProperty(oCweapR,ITEM_PROPERTY_ONHITCASTSPELL,IP_CONST_ONHIT_CASTSPELL_RAVAGEGOLDENICE);
        AddItemProperty(DURATION_TYPE_PERMANENT,ItemPropertyOnHitCastSpell(IP_CONST_ONHIT_CASTSPELL_RAVAGEGOLDENICE,2),oCweapB);
        AddItemProperty(DURATION_TYPE_PERMANENT,ItemPropertyOnHitCastSpell(IP_CONST_ONHIT_CASTSPELL_RAVAGEGOLDENICE,2),oCweapL);
        AddItemProperty(DURATION_TYPE_PERMANENT,ItemPropertyOnHitCastSpell(IP_CONST_ONHIT_CASTSPELL_RAVAGEGOLDENICE,2),oCweapR);


   }

}
