//::///////////////////////////////////////////////
//:: Shou Disciple
//:: prc_shou.nss
//:://////////////////////////////////////////////
//:: Check to see which Shou Disciple feats a PC
//:: has and apply the appropriate bonuses.
//:://////////////////////////////////////////////
//:: Created By: Stratovarius
//:: Created On: June 28, 2004
//:://////////////////////////////////////////////

#include "inc_item_props"
#include "nw_i0_spells"
#include "x2_inc_itemprop"

#include "prc_feat_const"
#include "prc_class_const"
#include "prc_spell_const"

void DodgeBonus(object oPC, object oSkin)
{
     int ACBonus = 0;
     int iShou = GetLevelByClass(CLASS_TYPE_SHOU, oPC);

     if(iShou >= 2 && iShou < 4)
     {
          ACBonus = 1;
     }
     else if(iShou >= 4)
     {
          ACBonus = 2;
     }

     SetCompositeBonus(oSkin, "ShouDodge", ACBonus, ITEM_PROPERTY_AC_BONUS);
     SetLocalInt(oPC, "HasShouDodge", 2);
}


void RemoveDodge(object oPC, object oSkin)
{
     SetCompositeBonus(oSkin, "ShouDodge", 0, ITEM_PROPERTY_AC_BONUS);
     SetLocalInt(oPC, "HasShouDodge", 1);
}

void main()
{
    //Declare main variables.
    object oPC = OBJECT_SELF;
    object oSkin = GetPCSkin(oPC);
    object oArmor = GetItemInSlot(INVENTORY_SLOT_CHEST, oPC);

    object oWeapR = GetItemInSlot(INVENTORY_SLOT_RIGHTHAND, oPC);
    object oWeapL = GetItemInSlot(INVENTORY_SLOT_LEFTHAND, oPC);
    int iShield = GetItemACValue(oWeapL);
    int iEquip = GetLocalInt(oPC,"ONEQUIP");
    int armorType = GetArmorType(oArmor);
    string nMes = "";


    if( armorType > ARMOR_TYPE_LIGHT )
    {
         RemoveDodge(oPC, oSkin);

         if(GetHasSpellEffect(SPELL_MARTIAL_FLURRY, oPC) )
         {
              RemoveSpellEffects(SPELL_MARTIAL_FLURRY, oPC, oPC);
         }

         nMes = "*Shou Disciple Abilities Disabled Due To Equipped Armor*";
         FloatingTextStringOnCreature(nMes, oPC, FALSE);
    }
    else if(iShield > 0)
    {
         RemoveDodge(oPC, oSkin);

         if(GetHasSpellEffect(SPELL_MARTIAL_FLURRY, oPC) )
         {
              RemoveSpellEffects(SPELL_MARTIAL_FLURRY, oPC, oPC);
         }

         nMes = "*Shou Disciple Abilities Disabled Due To Equipped Shield*";
         FloatingTextStringOnCreature(nMes, oPC, FALSE);
    }
    else
    {
          if(GetLevelByClass(CLASS_TYPE_SHOU, oPC) > 1 )
          {
               RemoveDodge(oPC, oSkin);
               DodgeBonus(oPC, oSkin);
          }
     }


}
