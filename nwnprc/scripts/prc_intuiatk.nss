#include "inc_item_props"
#include "prc_feat_const"
#include "inc_combat"
#include "prc_ipfeat_const"
#include "nw_i0_spells"

const int SPELL_INTUITIVE_ATK = 2090;

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
      int iStr = GetAbilityModifier(ABILITY_STRENGTH,oPC);
      int iDex = GetAbilityModifier(ABILITY_DEXTERITY,oPC);
      int iWis = GetAbilityModifier(ABILITY_WISDOM,oPC);
      int iCreature = GetLocalInt(oPC, "CreatureFinesse");
      int iMod = (iWis > iStr) ? (iWis - iStr) : 0;
      int iXBowEq = GetBaseItemType(GetItemInSlot(INVENTORY_SLOT_RIGHTHAND, oPC)) == BASE_ITEM_LIGHTCROSSBOW ||
                    GetBaseItemType(GetItemInSlot(INVENTORY_SLOT_RIGHTHAND, oPC)) == BASE_ITEM_HEAVYCROSSBOW;
      
      if (GetHasFeat(FEAT_WEAPON_FINESSE,oPC) && iWis > iDex && iDex > iStr)
          iMod = iWis - iDex;
          
      if (GetHasFeat(FEAT_ZEN_ARCHERY,oPC) && iXBowEq)
          iMod = 0;

      SetCompositeAttackBonus(oPC, "IntuitiveAttackR", 0, ATTACK_BONUS_ONHAND);
      SetCompositeAttackBonus(oPC, "IntuitiveAttackL", 0, ATTACK_BONUS_OFFHAND);
      
      if (GetAlignmentGoodEvil(oPC) == ALIGNMENT_GOOD && iMod > iCreature)
      {
          SetCompositeAttackBonus(oPC, "CreatureFinesse", 0);

          if (!GetIsObjectValid(GetItemInSlot(INVENTORY_SLOT_RIGHTHAND, oPC))) // unarmed
          {
              SetCompositeAttackBonus(oPC, "IntuitiveAttackR", iMod, ATTACK_BONUS_ONHAND);
          }
          else if (isSimple(GetItemInSlot(INVENTORY_SLOT_RIGHTHAND, oPC))) // right hand
          {
                  SetCompositeAttackBonus(oPC, "IntuitiveAttackR", iMod, ATTACK_BONUS_ONHAND);
              if (isSimple(GetItemInSlot(INVENTORY_SLOT_LEFTHAND, oPC))) // left hand
                  SetCompositeAttackBonus(oPC, "IntuitiveAttackL", iMod, ATTACK_BONUS_OFFHAND);
          }
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
