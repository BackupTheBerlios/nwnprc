#include "prc_inc_function"
#include "heartward_inc"
#include "Soul_inc"
#include "inc_item_props"
#include "ft_martialstrike"
#include "nw_i0_spells"

// Sanctify_Feat(iType);



void Sanctify()
{

   object oItem;
   object oPC = OBJECT_SELF;
   int iType;

   if (GetLocalInt(oPC,"ONENTER")) return;

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


void Pwatk(object oPC)
{
   if (GetLocalInt(oPC,"ONEQUIP")!= 2 ) return;
   
   object oItem = GetPCItemLastEquipped();
   
   if (GetWeaponRanged(oItem))
   {
      int iSpell =  GetHasSpellEffect(SPELL_POWER_ATTACK1,OBJECT_SELF)  ? SPELL_POWER_ATTACK1 : 0;
          iSpell =  GetHasSpellEffect(SPELL_POWER_ATTACK2,OBJECT_SELF)  ? SPELL_POWER_ATTACK2 : iSpell;
          iSpell =  GetHasSpellEffect(SPELL_POWER_ATTACK3,OBJECT_SELF)  ? SPELL_POWER_ATTACK3 : iSpell;
          iSpell =  GetHasSpellEffect(SPELL_POWER_ATTACK4,OBJECT_SELF)  ? SPELL_POWER_ATTACK4 : iSpell;
          iSpell =  GetHasSpellEffect(SPELL_POWER_ATTACK5,OBJECT_SELF)  ? SPELL_POWER_ATTACK5 : iSpell;
          iSpell =  GetHasSpellEffect(SPELL_POWER_ATTACK6,OBJECT_SELF)  ? SPELL_POWER_ATTACK6 : iSpell;
          iSpell =  GetHasSpellEffect(SPELL_POWER_ATTACK7,OBJECT_SELF)  ? SPELL_POWER_ATTACK7 : iSpell;
          iSpell =  GetHasSpellEffect(SPELL_POWER_ATTACK8,OBJECT_SELF)  ? SPELL_POWER_ATTACK8 : iSpell;
          iSpell =  GetHasSpellEffect(SPELL_POWER_ATTACK9,OBJECT_SELF)  ? SPELL_POWER_ATTACK9 : iSpell;
          iSpell =  GetHasSpellEffect(SPELL_POWER_ATTACK10,OBJECT_SELF) ? SPELL_POWER_ATTACK10: iSpell;
   	
      if(iSpell)
      {
     	 RemoveSpellEffects(iSpell,OBJECT_SELF,OBJECT_SELF);

         string nMes = "*Power Attack Mode Desactivated*";
         FloatingTextStringOnCreature(nMes, OBJECT_SELF, FALSE);
      }	
   	
   }
	
}

void main()
{
   object oPC = OBJECT_SELF;
   
   Pwatk(oPC);
   
   if (GetAlignmentGoodEvil(oPC)!= ALIGNMENT_GOOD)
   {

     object oItem=GetItemInSlot(INVENTORY_SLOT_RIGHTHAND,oPC);
     int iType= GetBaseItemType(oItem);

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


     if ( GetLocalInt(oItem,"SanctMar"))
     {
       RemoveSpecificProperty(oItem,ITEM_PROPERTY_DAMAGE_BONUS_VS_ALIGNMENT_GROUP,IP_CONST_ALIGNMENTGROUP_EVIL,IP_CONST_DAMAGEBONUS_1,IP_CONST_DAMAGETYPE_DIVINE);
       RemoveSpecificProperty(oItem,ITEM_PROPERTY_DAMAGE_BONUS_VS_RACIAL_GROUP,IP_CONST_RACIALTYPE_UNDEAD,IP_CONST_DAMAGEBONUS_1d4,IP_CONST_DAMAGETYPE_DIVINE);
       RemoveSpecificProperty(oItem,ITEM_PROPERTY_DAMAGE_BONUS_VS_RACIAL_GROUP,IP_CONST_RACIALTYPE_OUTSIDER,IP_CONST_DAMAGEBONUS_1d4,IP_CONST_DAMAGETYPE_DIVINE);
       RemoveSpecificProperty(oItem,ITEM_PROPERTY_VISUALEFFECT,ITEM_VISUAL_HOLY);
       DeleteLocalInt(oItem,"SanctMar");
     }

     if (GetLocalInt(oItem,"MartialStrik"))
     {
       RemoveSpecificProperty(oItem,ITEM_PROPERTY_DAMAGE_BONUS_VS_ALIGNMENT_GROUP,IP_CONST_ALIGNMENTGROUP_EVIL,IP_CONST_DAMAGEBONUS_2d6,IP_CONST_DAMAGETYPE_DIVINE);
       RemoveSpecificProperty(oItem,ITEM_PROPERTY_VISUALEFFECT,ITEM_VISUAL_HOLY);
       DeleteLocalInt(oItem,"MartialStrik");
     }
     oItem=GetItemInSlot(INVENTORY_SLOT_LEFTHAND,oPC);
     iType= GetBaseItemType(oItem);
     
     if ( GetLocalInt(oItem,"SanctMar"))
     {
       RemoveSpecificProperty(oItem,ITEM_PROPERTY_DAMAGE_BONUS_VS_ALIGNMENT_GROUP,IP_CONST_ALIGNMENTGROUP_EVIL,IP_CONST_DAMAGEBONUS_1,IP_CONST_DAMAGETYPE_DIVINE);
       RemoveSpecificProperty(oItem,ITEM_PROPERTY_DAMAGE_BONUS_VS_RACIAL_GROUP,IP_CONST_RACIALTYPE_UNDEAD,IP_CONST_DAMAGEBONUS_1d4,IP_CONST_DAMAGETYPE_DIVINE);
       RemoveSpecificProperty(oItem,ITEM_PROPERTY_DAMAGE_BONUS_VS_RACIAL_GROUP,IP_CONST_RACIALTYPE_OUTSIDER,IP_CONST_DAMAGEBONUS_1d4,IP_CONST_DAMAGETYPE_DIVINE);
       RemoveSpecificProperty(oItem,ITEM_PROPERTY_VISUALEFFECT,ITEM_VISUAL_HOLY);
       DeleteLocalInt(oItem,"SanctMar");
     }

     if ( GetLocalInt(oItem,"MartialStrik"))
     {
       RemoveSpecificProperty(oItem,ITEM_PROPERTY_DAMAGE_BONUS_VS_ALIGNMENT_GROUP,IP_CONST_ALIGNMENTGROUP_EVIL,IP_CONST_DAMAGEBONUS_2d6,IP_CONST_DAMAGETYPE_DIVINE);
       RemoveSpecificProperty(oItem,ITEM_PROPERTY_VISUALEFFECT,ITEM_VISUAL_HOLY);
       DeleteLocalInt(oItem,"MartialStrik");
     }
     return;
   }

   Sanctify();
   MartialStrike();

}