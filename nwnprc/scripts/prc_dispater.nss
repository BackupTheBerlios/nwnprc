#include "inc_item_props"
#include "prc_feat_const"
#include "prc_class_const"
#include "inc_combat"


///Checks to see if weapon is metal///
int IsItemMetal(object oItem)
{
  int nReturnVal=0;
  int type=GetBaseItemType(oItem);
   if((type==BASE_ITEM_BASTARDSWORD)
     ||type==BASE_ITEM_BATTLEAXE
     ||type==BASE_ITEM_DAGGER
     ||type==BASE_ITEM_DIREMACE
     ||type==BASE_ITEM_DOUBLEAXE
     ||type==BASE_ITEM_DWARVENWARAXE
     ||type==BASE_ITEM_GREATAXE
     ||type==BASE_ITEM_GREATSWORD
     ||type==BASE_ITEM_HALBERD
     ||type==BASE_ITEM_HANDAXE
     ||type==BASE_ITEM_HEAVYFLAIL
     ||type==BASE_ITEM_KAMA
     ||type==BASE_ITEM_KATANA
     ||type==BASE_ITEM_KUKRI
     ||type==BASE_ITEM_LIGHTFLAIL
     ||type==BASE_ITEM_LIGHTHAMMER
     ||type==BASE_ITEM_LIGHTMACE
     ||type==BASE_ITEM_LONGSWORD
     ||type==BASE_ITEM_MORNINGSTAR
     ||type==BASE_ITEM_RAPIER
     ||type==BASE_ITEM_SCIMITAR
     ||type==BASE_ITEM_SCYTHE
     ||type==BASE_ITEM_SHORTSWORD
     ||type==BASE_ITEM_SHURIKEN
     ||type==BASE_ITEM_SICKLE
     ||type==BASE_ITEM_THROWINGAXE
     ||type==BASE_ITEM_TWOBLADEDSWORD
     ||type==BASE_ITEM_WARHAMMER)
  {
    nReturnVal=2;// Mostly metal
  }
  return nReturnVal;
}

///Device Lore +2 on Search/Disable Device /////////
void Device_Lore(object oPC ,object oSkin ,int iLevel)
{
   if(GetLocalInt(oSkin, "DeviceSear") == iLevel) return;

    SetCompositeBonus(oSkin, "DeviceSear", iLevel, ITEM_PROPERTY_SKILL_BONUS,SKILL_SEARCH);
    SetCompositeBonus(oSkin, "DeviceDisa", iLevel, ITEM_PROPERTY_SKILL_BONUS,SKILL_DISABLE_TRAP);
}

void RemoveIronPower(object oPC, object oWeap)
{
      if (GetLocalInt(oWeap, "DispIronPowerD"))
      {
         SetCompositeDamageBonusT(oWeap, "DispIronPowerD", 0);
         RemoveSpecificProperty(oWeap, ITEM_PROPERTY_KEEN,-1,-1, 1,"",-1,DURATION_TYPE_TEMPORARY);
      }
}

void IronPower(object oPC, object oWeap, int iBonusType)
{
   int iBonus = 0;

   string sIronPower = "DispIronPowerA"+IntToString(iBonusType);

   RemoveIronPower(oPC, oWeap);

   if (IsItemMetal(oWeap) == 2)
   {
      if (GetHasFeat(FEAT_IRON_POWER_2,oPC))
         iBonus = 2;
      else if (GetHasFeat(FEAT_IRON_POWER_1,oPC))
         iBonus = 1;

      if (iBonus)
      {
         SetCompositeDamageBonusT(oWeap, "DispIronPowerD", iBonus);
         SetCompositeAttackBonus(oPC, sIronPower, iBonus, iBonusType);
         AddItemProperty(DURATION_TYPE_TEMPORARY, ItemPropertyKeen(), oWeap,9999.0);
      }

   }
}

void main()
{

        object oPC = OBJECT_SELF;
        object oSkin = GetPCSkin(oPC);
        object oWeap1 = GetItemInSlot(INVENTORY_SLOT_RIGHTHAND);
        object oWeap2 = GetItemInSlot(INVENTORY_SLOT_LEFTHAND);

        int bDivLor = GetHasFeat(FEAT_DEVICE_LORE, oPC) ? 2 : 0;

        string sIronPowerR = "DispIronPowerA"+IntToString(ATTACK_BONUS_ONHAND);
        string sIronPowerL = "DispIronPowerA"+IntToString(ATTACK_BONUS_OFFHAND);
        SetCompositeAttackBonus(oPC, sIronPowerR, 0, ATTACK_BONUS_ONHAND);
        SetCompositeAttackBonus(oPC, sIronPowerL, 0, ATTACK_BONUS_OFFHAND);

        IronPower(oPC, oWeap1, ATTACK_BONUS_ONHAND);
        IronPower(oPC, oWeap2, ATTACK_BONUS_OFFHAND);

        if (GetLocalInt(oPC,"ONEQUIP") == 1)
            RemoveIronPower(oPC, GetPCItemLastUnequipped());

        if(bDivLor > 0) Device_Lore(oPC,oSkin,bDivLor);
}