#include "inc_item_props"
#include "prc_feat_const"
#include "inc_combat"
#include "prc_ipfeat_const"


int isSimple(object oItem)
{
      int iType= GetBaseItemType(oItem);

      switch (iType)
      {            
        case BASE_ITEM_MORNINGSTAR:
        case BASE_ITEM_QUARTERSTAFF:
        case BASE_ITEM_SHORTSPEAR:
        case BASE_ITEM_HEAVYCROSSBOW:
          return 1;
          break;
        case BASE_ITEM_CLUB:  
        case BASE_ITEM_DAGGER:
        case BASE_ITEM_LIGHTMACE:
        case BASE_ITEM_SICKLE:
        case BASE_ITEM_SLING:
        case BASE_ITEM_DART:
        case BASE_ITEM_LIGHTCROSSBOW:
          return 2;
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
      int iMod = iWis > iStr  ? iWis-iStr :0;

      if (iEquip == 1)
           oItem = GetPCItemLastUnequipped();
      else
           oItem = GetItemInSlot(INVENTORY_SLOT_RIGHTHAND,oPC);

      object oBrac = GetItemInSlot(INVENTORY_SLOT_ARMS,oPC);

      if (GetAlignmentGoodEvil(oPC)!= ALIGNMENT_GOOD)
         SetCompositeBonus(oBrac,"IntuiAtk",0,ITEM_PROPERTY_ATTACK_BONUS);
      else if ( !GetIsObjectValid(GetItemInSlot(INVENTORY_SLOT_RIGHTHAND,oPC)) &&  !GetIsObjectValid(GetItemInSlot(INVENTORY_SLOT_LEFTHAND,oPC)))
      {
          int iMonk = GetLevelByClass(CLASS_TYPE_MONK,oPC);
          if (iMonk||GetIsObjectValid(GetItemInSlot(INVENTORY_SLOT_CWEAPON_B,oPC))||GetIsObjectValid(GetItemInSlot(INVENTORY_SLOT_CWEAPON_L,oPC))||GetIsObjectValid(GetItemInSlot(INVENTORY_SLOT_CWEAPON_R,oPC)))
          SetCompositeBonus(oBrac,"IntuiAtk",iMod,ITEM_PROPERTY_ATTACK_BONUS);
      }
      else
        SetCompositeBonus(oBrac,"IntuiAtk",0,ITEM_PROPERTY_ATTACK_BONUS);

      if(iEquip == 1)
       SetCompositeBonus(oItem,"IntuiAtk",0,ITEM_PROPERTY_ATTACK_BONUS);

      int iSimple = isSimple(oItem);
      if (iSimple)
      {
        if (iSimple == 2 && GetHasFeat(FEAT_WEAPON_FINESSE,oPC))
        {
           int iDex = GetAbilityModifier(ABILITY_DEXTERITY, oPC);
           if (iDex>iStr)
           {
             if (iWis > iDex)
                iMod = iWis-iDex ;
             else
                iMod = 0;
           }

        }

        if(GetAlignmentGoodEvil(oPC)!= ALIGNMENT_GOOD)
           SetCompositeBonus(oItem,"IntuiAtk",GetWeaponEnhancement(oItem),ITEM_PROPERTY_ATTACK_BONUS);
        else
          SetCompositeBonus(oItem,"IntuiAtk",iMod+GetWeaponEnhancement(oItem),ITEM_PROPERTY_ATTACK_BONUS);
      }




   }

   if (GetHasFeat(FEAT_RAVAGEGOLDENICE, oPC))
   {

       int iEquip = GetLocalInt(oPC,"ONEQUIP") ;
       object oItem;
       
       if (iEquip == 1)
            oItem = GetPCItemLastUnequipped();
       else
            oItem = GetItemInSlot(INVENTORY_SLOT_RIGHTHAND,oPC);
      
       
       if (iEquip == 1||GetAlignmentGoodEvil(oPC)!= ALIGNMENT_GOOD)
       {
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

        if (GetAlignmentGoodEvil(oPC)== ALIGNMENT_GOOD)
        {
          AddItemProperty(DURATION_TYPE_PERMANENT,ItemPropertyOnHitCastSpell(IP_CONST_ONHIT_CASTSPELL_RAVAGEGOLDENICE,2),oCweapB);
          AddItemProperty(DURATION_TYPE_PERMANENT,ItemPropertyOnHitCastSpell(IP_CONST_ONHIT_CASTSPELL_RAVAGEGOLDENICE,2),oCweapL);
          AddItemProperty(DURATION_TYPE_PERMANENT,ItemPropertyOnHitCastSpell(IP_CONST_ONHIT_CASTSPELL_RAVAGEGOLDENICE,2),oCweapR);
        }


   }

}
