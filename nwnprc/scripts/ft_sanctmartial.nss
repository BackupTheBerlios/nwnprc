#include "prc_inc_function"
#include "prc_inc_clsfunc"
#include "inc_item_props"
#include "nw_i0_spells"


// Sanctify_Feat(iType);

const int SKILL_JUMP = 28;

void Sanctify()
{

   object oItem;
   object oPC = OBJECT_SELF;
   int iType;

//   if (GetLocalInt(oPC,"ONENTER")) return;

   int iEquip=GetLocalInt(oPC,"ONEQUIP");
   

   if (GetLocalInt(oItem,"MartialStrik")) return;

   if (iEquip==2)
   {
     if (GetHasFeat(FEAT_HOLY_MARTIAL_STRIKE)) return;

     oItem=GetItemLastEquipped();
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

     AddItemProperty(DURATION_TYPE_TEMPORARY,ItemPropertyDamageBonusVsAlign(IP_CONST_ALIGNMENTGROUP_EVIL,IP_CONST_DAMAGETYPE_DIVINE,IP_CONST_DAMAGEBONUS_1),oItem,9999.0);
     AddItemProperty(DURATION_TYPE_TEMPORARY,ItemPropertyDamageBonusVsRace(IP_CONST_RACIALTYPE_UNDEAD,IP_CONST_DAMAGETYPE_DIVINE,IP_CONST_DAMAGEBONUS_1d4),oItem,9999.0);
     AddItemProperty(DURATION_TYPE_TEMPORARY,ItemPropertyDamageBonusVsRace(IP_CONST_RACIALTYPE_OUTSIDER,IP_CONST_DAMAGETYPE_DIVINE,IP_CONST_DAMAGEBONUS_1d4),oItem,9999.0);
     AddItemProperty(DURATION_TYPE_TEMPORARY,ItemPropertyVisualEffect(ITEM_VISUAL_HOLY),oItem,9999.0);
     SetLocalInt(oItem,"SanctMar",1);
  }
  else if (iEquip==1)
   {
     if (GetHasFeat(FEAT_HOLY_MARTIAL_STRIKE)) return;

     oItem=GetItemLastUnequipped();
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
      RemoveSpecificProperty(oItem,ITEM_PROPERTY_DAMAGE_BONUS_VS_ALIGNMENT_GROUP,IP_CONST_ALIGNMENTGROUP_EVIL,IP_CONST_DAMAGEBONUS_1, 1,"",IP_CONST_DAMAGETYPE_DIVINE,DURATION_TYPE_TEMPORARY);
      RemoveSpecificProperty(oItem,ITEM_PROPERTY_DAMAGE_BONUS_VS_RACIAL_GROUP,IP_CONST_RACIALTYPE_UNDEAD,IP_CONST_DAMAGEBONUS_1d4, 1,"",IP_CONST_DAMAGETYPE_DIVINE,DURATION_TYPE_TEMPORARY);
      RemoveSpecificProperty(oItem,ITEM_PROPERTY_DAMAGE_BONUS_VS_RACIAL_GROUP,IP_CONST_RACIALTYPE_OUTSIDER,IP_CONST_DAMAGEBONUS_1d4, 1,"",IP_CONST_DAMAGETYPE_DIVINE,DURATION_TYPE_TEMPORARY);
      RemoveSpecificProperty(oItem,ITEM_PROPERTY_VISUALEFFECT,ITEM_VISUAL_HOLY,-1,1,"",-1,DURATION_TYPE_TEMPORARY);
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

        if ( GetLocalInt(oItem,"SanctMar"))
        {
            RemoveSpecificProperty(oItem,ITEM_PROPERTY_DAMAGE_BONUS_VS_ALIGNMENT_GROUP,IP_CONST_ALIGNMENTGROUP_EVIL,IP_CONST_DAMAGEBONUS_1, 1,"",IP_CONST_DAMAGETYPE_DIVINE,DURATION_TYPE_TEMPORARY);
            RemoveSpecificProperty(oItem,ITEM_PROPERTY_DAMAGE_BONUS_VS_RACIAL_GROUP,IP_CONST_RACIALTYPE_UNDEAD,IP_CONST_DAMAGEBONUS_1d4, 1,"",IP_CONST_DAMAGETYPE_DIVINE,DURATION_TYPE_TEMPORARY);
            RemoveSpecificProperty(oItem,ITEM_PROPERTY_DAMAGE_BONUS_VS_RACIAL_GROUP,IP_CONST_RACIALTYPE_OUTSIDER,IP_CONST_DAMAGEBONUS_1d4, 1,"",IP_CONST_DAMAGETYPE_DIVINE,DURATION_TYPE_TEMPORARY);
            RemoveSpecificProperty(oItem,ITEM_PROPERTY_VISUALEFFECT,ITEM_VISUAL_HOLY,-1,1,"",-1,DURATION_TYPE_TEMPORARY);
            DeleteLocalInt(oItem,"SanctMar");
        }
        if ( GetLocalInt(oItem2,"SanctMar"))
        {
            RemoveSpecificProperty(oItem2,ITEM_PROPERTY_DAMAGE_BONUS_VS_ALIGNMENT_GROUP,IP_CONST_ALIGNMENTGROUP_EVIL,IP_CONST_DAMAGEBONUS_1, 1,"",IP_CONST_DAMAGETYPE_DIVINE,DURATION_TYPE_TEMPORARY);
            RemoveSpecificProperty(oItem2,ITEM_PROPERTY_DAMAGE_BONUS_VS_RACIAL_GROUP,IP_CONST_RACIALTYPE_UNDEAD,IP_CONST_DAMAGEBONUS_1d4, 1,"",IP_CONST_DAMAGETYPE_DIVINE,DURATION_TYPE_TEMPORARY);
            RemoveSpecificProperty(oItem2,ITEM_PROPERTY_DAMAGE_BONUS_VS_RACIAL_GROUP,IP_CONST_RACIALTYPE_OUTSIDER,IP_CONST_DAMAGEBONUS_1d4, 1,"",IP_CONST_DAMAGETYPE_DIVINE,DURATION_TYPE_TEMPORARY);
            RemoveSpecificProperty(oItem2,ITEM_PROPERTY_VISUALEFFECT,ITEM_VISUAL_HOLY,-1,1,"",-1,DURATION_TYPE_TEMPORARY);
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

     if (Sanctify_Feat(iType) &&  (!GetLocalInt(oItem,"SanctMar")) )
     {
       AddItemProperty(DURATION_TYPE_TEMPORARY,ItemPropertyDamageBonusVsAlign(IP_CONST_ALIGNMENTGROUP_EVIL,IP_CONST_DAMAGETYPE_DIVINE,IP_CONST_DAMAGEBONUS_1),oItem,9999.0);
       AddItemProperty(DURATION_TYPE_TEMPORARY,ItemPropertyDamageBonusVsRace(IP_CONST_RACIALTYPE_UNDEAD,IP_CONST_DAMAGETYPE_DIVINE,IP_CONST_DAMAGEBONUS_1d4),oItem,9999.0);
       AddItemProperty(DURATION_TYPE_TEMPORARY,ItemPropertyDamageBonusVsRace(IP_CONST_RACIALTYPE_OUTSIDER,IP_CONST_DAMAGETYPE_DIVINE,IP_CONST_DAMAGEBONUS_1d4),oItem,9999.0);
       AddItemProperty(DURATION_TYPE_TEMPORARY,ItemPropertyVisualEffect(ITEM_VISUAL_HOLY),oItem,9999.0);
       SetLocalInt(oItem,"SanctMar",1);
     }
     oItem=GetItemInSlot(INVENTORY_SLOT_LEFTHAND,oPC);
     iType= GetBaseItemType(oItem);
      if ( Sanctify_Feat(iType) &&  (!GetLocalInt(oItem,"SanctMar")))
     {
       AddItemProperty(DURATION_TYPE_TEMPORARY,ItemPropertyDamageBonusVsAlign(IP_CONST_ALIGNMENTGROUP_EVIL,IP_CONST_DAMAGETYPE_DIVINE,IP_CONST_DAMAGEBONUS_1),oItem,9999.0);
       AddItemProperty(DURATION_TYPE_TEMPORARY,ItemPropertyDamageBonusVsRace(IP_CONST_RACIALTYPE_UNDEAD,IP_CONST_DAMAGETYPE_DIVINE,IP_CONST_DAMAGEBONUS_1d4),oItem,9999.0);
       AddItemProperty(DURATION_TYPE_TEMPORARY,ItemPropertyDamageBonusVsRace(IP_CONST_RACIALTYPE_OUTSIDER,IP_CONST_DAMAGETYPE_DIVINE,IP_CONST_DAMAGEBONUS_1d4),oItem,9999.0);
       AddItemProperty(DURATION_TYPE_TEMPORARY,ItemPropertyVisualEffect(ITEM_VISUAL_HOLY),oItem,9999.0);
       SetLocalInt(oItem,"SanctMar",1);
     }
   }

}

void Vile()
{

   object oItem;
   object oPC = OBJECT_SELF;
   int iType;

//   if (GetLocalInt(oPC,"ONENTER")) return;

   int iEquip=GetLocalInt(oPC,"ONEQUIP");
   

   //if (GetLocalInt(oItem,"UnholyStrik")) return;

   if (iEquip==2)
   {
     //if (GetHasFeat(FEAT_UNHOLY_STRIKE)) return;

     oItem=GetItemLastEquipped();
     iType= GetBaseItemType(oItem);

     if ( GetLocalInt(oItem,"USanctMar")) return ;

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

     if (!Vile_Feat(iType)) return;
     
     int nAlign = GetGoodEvilValue(OBJECT_SELF);
     if (nAlign>7)
         AdjustAlignment(oPC,ALIGNMENT_EVIL,7);
         
     AddItemProperty(DURATION_TYPE_TEMPORARY,ItemPropertyDamageBonus(IP_CONST_DAMAGETYPE_VILE,IP_CONST_DAMAGEBONUS_1),oItem,9999.0);
     AddItemProperty(DURATION_TYPE_TEMPORARY,ItemPropertyVisualEffect(ITEM_VISUAL_EVIL),oItem,9999.0);
     SetLocalInt(oItem,"USanctMar",1);
  }
  else if (iEquip==1)
   {
     //if (GetHasFeat(FEAT_UNHOLY_STRIKE)) return;

     oItem=GetItemLastUnequipped();
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


    if ( GetLocalInt(oItem,"USanctMar"))
    {
      RemoveSpecificProperty(oItem,ITEM_PROPERTY_DAMAGE_BONUS,IP_CONST_DAMAGETYPE_VILE,IP_CONST_DAMAGEBONUS_1,1,"",-1,DURATION_TYPE_TEMPORARY);
      RemoveSpecificProperty(oItem,ITEM_PROPERTY_VISUALEFFECT,ITEM_VISUAL_EVIL,-1,1,"",-1,DURATION_TYPE_TEMPORARY);
      DeleteLocalInt(oItem,"USanctMar");
    }

   }
   else
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

     if (Vile_Feat(iType) &&  (!GetLocalInt(oItem,"USanctMar")) )
     {
       AddItemProperty(DURATION_TYPE_TEMPORARY,ItemPropertyDamageBonus(IP_CONST_DAMAGETYPE_VILE,IP_CONST_DAMAGEBONUS_1),oItem,9999.0);
       AddItemProperty(DURATION_TYPE_TEMPORARY,ItemPropertyVisualEffect(ITEM_VISUAL_EVIL),oItem,9999.0);
       SetLocalInt(oItem,"USanctMar",1);     
       int nAlign = GetGoodEvilValue(OBJECT_SELF);
       if (nAlign>7)
         AdjustAlignment(oPC,ALIGNMENT_EVIL,7);
         
     }
     oItem=GetItemInSlot(INVENTORY_SLOT_LEFTHAND,oPC);
     iType= GetBaseItemType(oItem);
      if ( Vile_Feat(iType) &&  (!GetLocalInt(oItem,"USanctMar")))
     {
       AddItemProperty(DURATION_TYPE_TEMPORARY,ItemPropertyDamageBonus(IP_CONST_DAMAGETYPE_VILE,IP_CONST_DAMAGEBONUS_1),oItem,9999.0);
       AddItemProperty(DURATION_TYPE_TEMPORARY,ItemPropertyVisualEffect(ITEM_VISUAL_EVIL),oItem,9999.0);
       SetLocalInt(oItem,"USanctMar",1);
       int nAlign = GetGoodEvilValue(OBJECT_SELF);
       if (nAlign>7)
         AdjustAlignment(oPC,ALIGNMENT_EVIL,7);
     }
   }

}

void Pwatk(object oPC)
{
   if (GetLocalInt(oPC,"ONEQUIP")!= 2 ) return;
   
   object oItem = GetItemLastEquipped();
   
   // don't run this if the equipped item is not a weapon
   if (GetItemInSlot(INVENTORY_SLOT_RIGHTHAND, oPC) != oItem) return;
   
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
          iSpell =  GetHasSpellEffect(SPELL_SUPREME_POWER_ATTACK,OBJECT_SELF) ? SPELL_SUPREME_POWER_ATTACK: iSpell;
   	
      if(iSpell)
      {
     	 RemoveSpellEffects(iSpell,OBJECT_SELF,OBJECT_SELF);

         string nMes = "*Power Attack Mode Deactivated*";
         FloatingTextStringOnCreature(nMes, OBJECT_SELF, FALSE);
      }	
   	
   }
   else
   { 
      int iSpell =  GetHasSpellEffect(SPELL_PA_POWERSHOT,OBJECT_SELF)      ? SPELL_PA_POWERSHOT : 0;
          iSpell =  GetHasSpellEffect(SPELL_PA_IMP_POWERSHOT,OBJECT_SELF)  ? SPELL_PA_IMP_POWERSHOT : iSpell;
          iSpell =  GetHasSpellEffect(SPELL_PA_SUP_POWERSHOT,OBJECT_SELF)  ? SPELL_PA_SUP_POWERSHOT : iSpell;

      if(iSpell)
      {
     	 RemoveSpellEffects(iSpell,OBJECT_SELF,OBJECT_SELF);

         string nMes = "*Power Shot Mode Deactivated*";
         FloatingTextStringOnCreature(nMes, OBJECT_SELF, FALSE);
      }	        
   }
	
}

void main()
{
   object oPC = OBJECT_SELF;
   
   Pwatk(oPC);

  
   object oSkin = GetPCSkin(oPC);
   
   if (GetSkillRank(SKILL_JUMP,oPC)>4) 
       SetCompositeBonus(oSkin, "SkillJTum", 2, ITEM_PROPERTY_SKILL_BONUS,SKILL_TUMBLE);
   
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
        RemoveSpecificProperty(oItem,ITEM_PROPERTY_DAMAGE_BONUS_VS_ALIGNMENT_GROUP,IP_CONST_ALIGNMENTGROUP_EVIL,IP_CONST_DAMAGEBONUS_1, 1,"",IP_CONST_DAMAGETYPE_DIVINE,DURATION_TYPE_TEMPORARY);
        RemoveSpecificProperty(oItem,ITEM_PROPERTY_DAMAGE_BONUS_VS_RACIAL_GROUP,IP_CONST_RACIALTYPE_UNDEAD,IP_CONST_DAMAGEBONUS_1d4, 1,"",IP_CONST_DAMAGETYPE_DIVINE,DURATION_TYPE_TEMPORARY);
        RemoveSpecificProperty(oItem,ITEM_PROPERTY_DAMAGE_BONUS_VS_RACIAL_GROUP,IP_CONST_RACIALTYPE_OUTSIDER,IP_CONST_DAMAGEBONUS_1d4, 1,"",IP_CONST_DAMAGETYPE_DIVINE,DURATION_TYPE_TEMPORARY);
        RemoveSpecificProperty(oItem,ITEM_PROPERTY_VISUALEFFECT,ITEM_VISUAL_HOLY,-1,1,"",-1,DURATION_TYPE_TEMPORARY);
        DeleteLocalInt(oItem,"SanctMar");
     }

     if (GetLocalInt(oItem,"MartialStrik"))
     {
       RemoveSpecificProperty(oItem,ITEM_PROPERTY_DAMAGE_BONUS_VS_ALIGNMENT_GROUP,IP_CONST_ALIGNMENTGROUP_EVIL,IP_CONST_DAMAGEBONUS_2d6, 1,"",IP_CONST_DAMAGETYPE_DIVINE,DURATION_TYPE_TEMPORARY);
       RemoveSpecificProperty(oItem,ITEM_PROPERTY_VISUALEFFECT,ITEM_VISUAL_HOLY,-1,1,"",-1,DURATION_TYPE_TEMPORARY);
       DeleteLocalInt(oItem,"MartialStrik");
     }
     oItem=GetItemInSlot(INVENTORY_SLOT_LEFTHAND,oPC);
     iType= GetBaseItemType(oItem);
     
     if ( GetLocalInt(oItem,"SanctMar"))
     {
        RemoveSpecificProperty(oItem,ITEM_PROPERTY_DAMAGE_BONUS_VS_ALIGNMENT_GROUP,IP_CONST_ALIGNMENTGROUP_EVIL,IP_CONST_DAMAGEBONUS_1, 1,"",IP_CONST_DAMAGETYPE_DIVINE,DURATION_TYPE_TEMPORARY);
        RemoveSpecificProperty(oItem,ITEM_PROPERTY_DAMAGE_BONUS_VS_RACIAL_GROUP,IP_CONST_RACIALTYPE_UNDEAD,IP_CONST_DAMAGEBONUS_1d4, 1,"",IP_CONST_DAMAGETYPE_DIVINE,DURATION_TYPE_TEMPORARY);
        RemoveSpecificProperty(oItem,ITEM_PROPERTY_DAMAGE_BONUS_VS_RACIAL_GROUP,IP_CONST_RACIALTYPE_OUTSIDER,IP_CONST_DAMAGEBONUS_1d4, 1,"",IP_CONST_DAMAGETYPE_DIVINE,DURATION_TYPE_TEMPORARY);
        RemoveSpecificProperty(oItem,ITEM_PROPERTY_VISUALEFFECT,ITEM_VISUAL_HOLY,-1,1,"",-1,DURATION_TYPE_TEMPORARY);
        DeleteLocalInt(oItem,"SanctMar");
     }

     if ( GetLocalInt(oItem,"MartialStrik"))
     {
       RemoveSpecificProperty(oItem,ITEM_PROPERTY_DAMAGE_BONUS_VS_ALIGNMENT_GROUP,IP_CONST_ALIGNMENTGROUP_EVIL,IP_CONST_DAMAGEBONUS_2d6, 1,"",IP_CONST_DAMAGETYPE_DIVINE,DURATION_TYPE_TEMPORARY);
       RemoveSpecificProperty(oItem,ITEM_PROPERTY_VISUALEFFECT,ITEM_VISUAL_HOLY,-1,1,"",-1,DURATION_TYPE_TEMPORARY);
       DeleteLocalInt(oItem,"MartialStrik");
     }
     if (GetAlignmentGoodEvil(oPC) == ALIGNMENT_EVIL) 
     {
        //Vile();
        UnholyStrike();
     }
     
   }
   else if (GetAlignmentGoodEvil(oPC)!= ALIGNMENT_EVIL)
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

/*
     if ( GetLocalInt(oItem,"USanctMar"))
     {
        RemoveSpecificProperty(oItem,ITEM_PROPERTY_DAMAGE_BONUS,IP_CONST_DAMAGETYPE_DIVINE,IP_CONST_DAMAGEBONUS_1,1,"",-1,DURATION_TYPE_TEMPORARY);
        RemoveSpecificProperty(oItem,ITEM_PROPERTY_VISUALEFFECT,ITEM_VISUAL_EVIL,-1,1,"",-1,DURATION_TYPE_TEMPORARY);
        DeleteLocalInt(oItem,"USanctMar");
     }
*/
     if (GetLocalInt(oItem,"UnholyStrik"))
     {
       RemoveSpecificProperty(oItem,ITEM_PROPERTY_DAMAGE_BONUS_VS_ALIGNMENT_GROUP,IP_CONST_ALIGNMENTGROUP_GOOD,IP_CONST_DAMAGEBONUS_2d6, 1,"",IP_CONST_DAMAGETYPE_DIVINE,DURATION_TYPE_TEMPORARY);
       RemoveSpecificProperty(oItem,ITEM_PROPERTY_VISUALEFFECT,ITEM_VISUAL_EVIL,-1,1,"",-1,DURATION_TYPE_TEMPORARY);
       DeleteLocalInt(oItem,"UnholyStrik");
     }
     
     oItem=GetItemInSlot(INVENTORY_SLOT_LEFTHAND,oPC);
     iType= GetBaseItemType(oItem);
/*    
     if ( GetLocalInt(oItem,"USanctMar"))
     {
        RemoveSpecificProperty(oItem,ITEM_PROPERTY_DAMAGE_BONUS,IP_CONST_DAMAGETYPE_DIVINE,IP_CONST_DAMAGEBONUS_1,1,"",-1,DURATION_TYPE_TEMPORARY);
        RemoveSpecificProperty(oItem,ITEM_PROPERTY_VISUALEFFECT,ITEM_VISUAL_EVIL,-1,1,"",-1,DURATION_TYPE_TEMPORARY);
        DeleteLocalInt(oItem,"USanctMar");
     }
*/
     if ( GetLocalInt(oItem,"UnholyStrik"))
     {
       RemoveSpecificProperty(oItem,ITEM_PROPERTY_DAMAGE_BONUS_VS_ALIGNMENT_GROUP,IP_CONST_ALIGNMENTGROUP_GOOD,IP_CONST_DAMAGEBONUS_2d6, 1,"",IP_CONST_DAMAGETYPE_DIVINE,DURATION_TYPE_TEMPORARY);
       RemoveSpecificProperty(oItem,ITEM_PROPERTY_VISUALEFFECT,ITEM_VISUAL_EVIL,-1,1,"",-1,DURATION_TYPE_TEMPORARY);
       DeleteLocalInt(oItem,"UnholyStrik");
     }
 
     if (GetAlignmentGoodEvil(oPC) == ALIGNMENT_GOOD)
     {
        Sanctify();
        MartialStrike();
     }   

   }

   Vile();
   //WeapEnh();
}