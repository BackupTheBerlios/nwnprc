#include "prc_inc_function"
#include "heartward_inc"
#include "Soul_inc"
#include "inc_item_props"
#include "ft_martialstrike"

// Sanctify_Feat(iType);



void Sanctify()
{

   object oItem;
   object oPC = OBJECT_SELF;
   int iType;

   if (GetLocalInt(oPC,"ONENTER")) return;

   if (GetAlignmentGoodEvil(oPC)!= ALIGNMENT_GOOD)
   {
     oItem=GetItemInSlot(INVENTORY_SLOT_RIGHTHAND,oPC);
     iType= GetBaseItemType(oItem);

     switch (iType)
     {
        case BASE_ITEM_BOLT:
        case BASE_ITEM_BULLET:
        case BASE_ITEM_ARROW:
          iType=GetBaseItemType(GetItemInSlot(INVENTORY_SLOT_RIGHTHAND));
          break;
        case BASE_ITEM_SHORTBOW:
        case BASE_ITEM_LONGBOW:
          oItem=GetItemInSlot(INVENTORY_SLOT_ARROWS);
          break;
        case BASE_ITEM_LIGHTCROSSBOW:
        case BASE_ITEM_HEAVYCROSSBOW:
          oItem=GetItemInSlot(INVENTORY_SLOT_BOLTS);
          break;
        case BASE_ITEM_SLING:
          oItem=GetItemInSlot(INVENTORY_SLOT_BULLETS);
          break;
     }

     if (GetLocalInt(oItem,"MartialStrik"))
     {
       RemoveSpecificProperty(oItem,ITEM_PROPERTY_DAMAGE_BONUS_VS_ALIGNMENT_GROUP,IP_CONST_ALIGNMENTGROUP_EVIL,IP_CONST_DAMAGEBONUS_2d6,IP_CONST_DAMAGETYPE_DIVINE);
       RemoveSpecificProperty(oItem,ITEM_PROPERTY_VISUALEFFECT,ITEM_VISUAL_HOLY);
       DeleteLocalInt(oItem,"MartialStrik");
     }
     oItem=GetItemInSlot(INVENTORY_SLOT_LEFTHAND,oPC);
     iType= GetBaseItemType(oItem);
     if ( GetLocalInt(oItem,"MartialStrik"))
     {
       RemoveSpecificProperty(oItem,ITEM_PROPERTY_DAMAGE_BONUS_VS_ALIGNMENT_GROUP,IP_CONST_ALIGNMENTGROUP_EVIL,IP_CONST_DAMAGEBONUS_2d6,IP_CONST_DAMAGETYPE_DIVINE);
       RemoveSpecificProperty(oItem,ITEM_PROPERTY_VISUALEFFECT,ITEM_VISUAL_HOLY);
       DeleteLocalInt(oItem,"MartialStrik");
     }
     return;
   }

   int iEquip=GetLocalInt(oPC,"ONEQUIP");
   

   if (GetLocalInt(oItem,"MartialStrik")) return;

   if (iEquip==2)
   {
     if (GetHasFeat(FEAT_HOLY_MARTIAL_STRIKE)) return;

     oItem=GetPCItemLastEquipped();
     iType= GetBaseItemType(oItem);

     if ( GetLocalInt(oItem,"SanctMar")) return ;

     switch (iType)
     {
        case BASE_ITEM_BOLT:
        case BASE_ITEM_BULLET:
        case BASE_ITEM_ARROW:
          iType=GetBaseItemType(GetItemInSlot(INVENTORY_SLOT_RIGHTHAND));
          break;
        case BASE_ITEM_SHORTBOW:
        case BASE_ITEM_LONGBOW:
          oItem=GetItemInSlot(INVENTORY_SLOT_ARROWS);
          break;
        case BASE_ITEM_LIGHTCROSSBOW:
        case BASE_ITEM_HEAVYCROSSBOW:
          oItem=GetItemInSlot(INVENTORY_SLOT_BOLTS);
          break;
        case BASE_ITEM_SLING:
          oItem=GetItemInSlot(INVENTORY_SLOT_BULLETS);
          break;
     }

     if (!Sanctify_Feat(iType)) return;

     AddItemProperty(DURATION_TYPE_PERMANENT,ItemPropertyDamageBonusVsAlign(IP_CONST_ALIGNMENTGROUP_EVIL,IP_CONST_DAMAGETYPE_DIVINE,IP_CONST_DAMAGEBONUS_1),oItem);
     AddItemProperty(DURATION_TYPE_PERMANENT,ItemPropertyDamageBonusVsRace(IP_CONST_RACIALTYPE_UNDEAD,IP_CONST_DAMAGETYPE_DIVINE,IP_CONST_DAMAGEBONUS_1d4),oItem);
     AddItemProperty(DURATION_TYPE_PERMANENT,ItemPropertyDamageBonusVsRace(IP_CONST_RACIALTYPE_OUTSIDER,IP_CONST_DAMAGETYPE_DIVINE,IP_CONST_DAMAGEBONUS_1d4),oItem);
     AddItemProperty(DURATION_TYPE_PERMANENT,ItemPropertyVisualEffect(ITEM_VISUAL_HOLY),oItem);
     SetLocalInt(oItem,"SanctMar",1);
  }
  else if (iEquip==1)
   {
     if (GetHasFeat(FEAT_HOLY_MARTIAL_STRIKE)) return;

     oItem=GetPCItemLastUnequipped();
     iType= GetBaseItemType(oItem);

     switch (iType)
     {
        case BASE_ITEM_BOLT:
        case BASE_ITEM_BULLET:
        case BASE_ITEM_ARROW:
          iType=GetBaseItemType(GetItemInSlot(INVENTORY_SLOT_RIGHTHAND));
          break;
        case BASE_ITEM_SHORTBOW:
        case BASE_ITEM_LONGBOW:
          oItem=GetItemInSlot(INVENTORY_SLOT_ARROWS);
          break;
        case BASE_ITEM_LIGHTCROSSBOW:
        case BASE_ITEM_HEAVYCROSSBOW:
          oItem=GetItemInSlot(INVENTORY_SLOT_BOLTS);
          break;
        case BASE_ITEM_SLING:
          oItem=GetItemInSlot(INVENTORY_SLOT_BULLETS);
          break;
     }

//    if (!Sanctify_Feat(iType)) return;


    if ( GetLocalInt(oItem,"SanctMar"))
    {
      RemoveSpecificProperty(oItem,ITEM_PROPERTY_DAMAGE_BONUS_VS_ALIGNMENT_GROUP,IP_CONST_ALIGNMENTGROUP_EVIL,IP_CONST_DAMAGEBONUS_1,IP_CONST_DAMAGETYPE_DIVINE);
      RemoveSpecificProperty(oItem,ITEM_PROPERTY_DAMAGE_BONUS_VS_RACIAL_GROUP,IP_CONST_RACIALTYPE_UNDEAD,IP_CONST_DAMAGEBONUS_1d4,IP_CONST_DAMAGETYPE_DIVINE);
      RemoveSpecificProperty(oItem,ITEM_PROPERTY_DAMAGE_BONUS_VS_RACIAL_GROUP,IP_CONST_RACIALTYPE_OUTSIDER,IP_CONST_DAMAGEBONUS_1d4,IP_CONST_DAMAGETYPE_DIVINE);
      RemoveSpecificProperty(oItem,ITEM_PROPERTY_VISUALEFFECT,ITEM_VISUAL_HOLY);
      DeleteLocalInt(oItem,"SanctMar");
    }

   }
   else
   {

     oItem=GetItemInSlot(INVENTORY_SLOT_RIGHTHAND,oPC);
     iType= GetBaseItemType(oItem);

     if (GetHasFeat(FEAT_HOLY_MARTIAL_STRIKE))
     {
        object oItem2=GetItemInSlot(INVENTORY_SLOT_LEFTHAND,oPC);

        switch (iType)
        {

            case BASE_ITEM_SHORTBOW:
            case BASE_ITEM_LONGBOW:
                oItem=GetItemInSlot(INVENTORY_SLOT_ARROWS);
                break;
            case BASE_ITEM_LIGHTCROSSBOW:
            case BASE_ITEM_HEAVYCROSSBOW:
                oItem=GetItemInSlot(INVENTORY_SLOT_BOLTS);
                break;
            case BASE_ITEM_SLING:
                oItem=GetItemInSlot(INVENTORY_SLOT_BULLETS);
                break;
        }

        if (!GetLocalInt(oItem,"SanctMar") && !GetLocalInt(oItem2,"SanctMar"))
          return;

        if ( GetLocalInt(oItem,"SanctMar"))
        {
            RemoveSpecificProperty(oItem,ITEM_PROPERTY_DAMAGE_BONUS_VS_ALIGNMENT_GROUP,IP_CONST_ALIGNMENTGROUP_EVIL,IP_CONST_DAMAGEBONUS_1,IP_CONST_DAMAGETYPE_DIVINE);
            RemoveSpecificProperty(oItem,ITEM_PROPERTY_DAMAGE_BONUS_VS_RACIAL_GROUP,IP_CONST_RACIALTYPE_UNDEAD,IP_CONST_DAMAGEBONUS_1d4,IP_CONST_DAMAGETYPE_DIVINE);
            RemoveSpecificProperty(oItem,ITEM_PROPERTY_DAMAGE_BONUS_VS_RACIAL_GROUP,IP_CONST_RACIALTYPE_OUTSIDER,IP_CONST_DAMAGEBONUS_1d4,IP_CONST_DAMAGETYPE_DIVINE);
            RemoveSpecificProperty(oItem,ITEM_PROPERTY_VISUALEFFECT,ITEM_VISUAL_HOLY);
            DeleteLocalInt(oItem,"SanctMar");
        }
        if ( GetLocalInt(oItem2,"SanctMar"))
        {
            RemoveSpecificProperty(oItem2,ITEM_PROPERTY_DAMAGE_BONUS_VS_ALIGNMENT_GROUP,IP_CONST_ALIGNMENTGROUP_EVIL,IP_CONST_DAMAGEBONUS_1,IP_CONST_DAMAGETYPE_DIVINE);
            RemoveSpecificProperty(oItem2,ITEM_PROPERTY_DAMAGE_BONUS_VS_RACIAL_GROUP,IP_CONST_RACIALTYPE_UNDEAD,IP_CONST_DAMAGEBONUS_1d4,IP_CONST_DAMAGETYPE_DIVINE);
            RemoveSpecificProperty(oItem2,ITEM_PROPERTY_DAMAGE_BONUS_VS_RACIAL_GROUP,IP_CONST_RACIALTYPE_OUTSIDER,IP_CONST_DAMAGEBONUS_1d4,IP_CONST_DAMAGETYPE_DIVINE);
            RemoveSpecificProperty(oItem2,ITEM_PROPERTY_VISUALEFFECT,ITEM_VISUAL_HOLY);
            DeleteLocalInt(oItem2,"SanctMar");
        }
        return;
     }

     switch (iType)
     {
        case BASE_ITEM_BOLT:
        case BASE_ITEM_BULLET:
        case BASE_ITEM_ARROW:
          iType=GetBaseItemType(GetItemInSlot(INVENTORY_SLOT_RIGHTHAND));
          break;
        case BASE_ITEM_SHORTBOW:
        case BASE_ITEM_LONGBOW:
          oItem=GetItemInSlot(INVENTORY_SLOT_ARROWS);
          break;
        case BASE_ITEM_LIGHTCROSSBOW:
        case BASE_ITEM_HEAVYCROSSBOW:
          oItem=GetItemInSlot(INVENTORY_SLOT_BOLTS);
          break;
        case BASE_ITEM_SLING:
          oItem=GetItemInSlot(INVENTORY_SLOT_BULLETS);
          break;
     }

     if (Sanctify_Feat(iType) &&  !GetLocalInt(oItem,"SanctMar"))
     {
       AddItemProperty(DURATION_TYPE_PERMANENT,ItemPropertyDamageBonusVsAlign(IP_CONST_ALIGNMENTGROUP_EVIL,IP_CONST_DAMAGETYPE_DIVINE,IP_CONST_DAMAGEBONUS_1),oItem);
       AddItemProperty(DURATION_TYPE_PERMANENT,ItemPropertyDamageBonusVsRace(IP_CONST_RACIALTYPE_UNDEAD,IP_CONST_DAMAGETYPE_DIVINE,IP_CONST_DAMAGEBONUS_1d4),oItem);
       AddItemProperty(DURATION_TYPE_PERMANENT,ItemPropertyDamageBonusVsRace(IP_CONST_RACIALTYPE_OUTSIDER,IP_CONST_DAMAGETYPE_DIVINE,IP_CONST_DAMAGEBONUS_1d4),oItem);
       AddItemProperty(DURATION_TYPE_PERMANENT,ItemPropertyVisualEffect(ITEM_VISUAL_HOLY),oItem);
       SetLocalInt(oItem,"SanctMar",1);
     }
     oItem=GetItemInSlot(INVENTORY_SLOT_LEFTHAND,oPC);
     iType= GetBaseItemType(oItem);
      if (Sanctify_Feat(iType) &&  !GetLocalInt(oItem,"SanctMar"))
     {
       AddItemProperty(DURATION_TYPE_PERMANENT,ItemPropertyDamageBonusVsAlign(IP_CONST_ALIGNMENTGROUP_EVIL,IP_CONST_DAMAGETYPE_DIVINE,IP_CONST_DAMAGEBONUS_1),oItem);
       AddItemProperty(DURATION_TYPE_PERMANENT,ItemPropertyDamageBonusVsRace(IP_CONST_RACIALTYPE_UNDEAD,IP_CONST_DAMAGETYPE_DIVINE,IP_CONST_DAMAGEBONUS_1d4),oItem);
       AddItemProperty(DURATION_TYPE_PERMANENT,ItemPropertyDamageBonusVsRace(IP_CONST_RACIALTYPE_OUTSIDER,IP_CONST_DAMAGETYPE_DIVINE,IP_CONST_DAMAGEBONUS_1d4),oItem);
       AddItemProperty(DURATION_TYPE_PERMANENT,ItemPropertyVisualEffect(ITEM_VISUAL_HOLY),oItem);
       SetLocalInt(oItem,"SanctMar",1);
     }
   }

}



void main()
{

   Sanctify();
   MartialStrike();

}