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
   if(GetLocalInt(oSkin, "DeviceLore") == iLevel) return;

    SetCompositeBonus(oSkin, "DeviceSear", iLevel, ITEM_PROPERTY_SKILL_BONUS,SKILL_SEARCH);
    SetCompositeBonus(oSkin, "DeviceDisa", iLevel, ITEM_PROPERTY_SKILL_BONUS,SKILL_DISABLE_TRAP);
}

void RemoveIronPower(object oPC, object oWeap)
{
      if (GetLocalInt(oWeap, "DispIronPowerA"))
      {
         SetCompositeBonus(oWeap, "DispIronPowerA", 0, ITEM_PROPERTY_ATTACK_BONUS);
         SetCompositeDamageBonus(oWeap, "DispIronPowerD", 0);
         RemoveSpecificProperty(oWeap, ITEM_PROPERTY_KEEN);
      }
}

void IronPower(object oPC, object oWeap)
{
   int iBonus = 0;

   RemoveIronPower(oPC, oWeap);

   if (IsItemMetal(oWeap) == 2)
   {
      if (GetLevelByClass(CLASS_TYPE_DISPATER, oPC) >= 4)
         iBonus = 1;

      if (GetLevelByClass(CLASS_TYPE_DISPATER, oPC) >= 8)
         iBonus = 2;

      if ((GetLocalInt(oWeap, "DispIronPowerA") != iBonus) && (iBonus))
      {
         SetCompositeBonus(oWeap, "DispIronPowerA", iBonus, ITEM_PROPERTY_ATTACK_BONUS);
         SetCompositeDamageBonus(oWeap, "DispIronPowerD", iBonus);
         AddItemProperty(DURATION_TYPE_PERMANENT, ItemPropertyKeen(), oWeap);
      }
   }
}

void main()
{

        object oPC = OBJECT_SELF;
        object oSkin = GetPCSkin(oPC);
        object oWeap = GetItemInSlot(INVENTORY_SLOT_RIGHTHAND);

        int bDivLor = GetHasFeat(FEAT_DEVICE_LORE, oPC) ? 2 : 0;
        //int bIrnPwr = GetHasFeat(FEAT_IRON_POWER_1,oPC) ? 1 : 0;
        //    bIrnPwr = GetHasFeat(FEAT_IRON_POWER_2,oPC) ? 1 : bIrnPwr;

   IronPower(oPC, oWeap);

   if (GetLocalInt(oPC,"ONEQUIP") == 1)
        RemoveIronPower(oPC, GetPCItemLastUnequipped());

        if(bDivLor > 0) Device_Lore(oPC,oSkin,bDivLor);

        //if(bIrnPwr > 0 && (IsItemMetal(oWeap) == 2))
        //    Iron_Power(oPC,oWeap,bIrnPwr);
        //else
        //    Iron_Power(oPC,oWeap,0);

}