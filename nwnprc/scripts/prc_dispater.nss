#include "inc_item_props"
#include "prc_feat_const"
#include "prc_class_const"
#include "inc_combat"


///Checks to see if weapon is metal///
int IsItemMetal(object oItem)
{
  int nReturnVal=0;
  int type=GetBaseItemType(oItem);
  if((type<6)||type==9||type==10||type==12||type==13||type==17||type==18
     ||type==22||type==27||type==32||type==33||type==35||type==37||type==28
     ||type==40||type==41||type==42||type==47||type==51||type==52||type==53
     ||type==57||type==59||type==60||type==63||type==65||type==76||type==7
     ||type==19||type==20||type==21||type==28||type==31||type==44||type==45
     ||type==46||type==56||type==62||type==78||type==25||type==55||type==58)
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

void IronPower(object oPC, object oWeap)
{
   int iBonus = 0;

   if (IsItemMetal(oWeap) == 2)
   {
      if (GetLevelByClass(CLASS_TYPE_DISPATER, oPC) >= 4)
         iBonus = 1;

      if (GetLevelByClass(CLASS_TYPE_DISPATER, oPC) >= 8)
         iBonus = 2;

      if ((GetLocalInt(oWeap, "DispIronPowerA") != iBonus) && (iBonus))
      {
         SetCompositeBonus(oWeap, "DispIronPowerA", iBonus, ITEM_PROPERTY_ATTACK_BONUS);
         SetCompositeBonus(oWeap, "DispIronPowerD", iBonus, ITEM_PROPERTY_DAMAGE_BONUS);
         AddItemProperty(DURATION_TYPE_TEMPORARY, ItemPropertyKeen(), oWeap, 99999.0);
      }
   }
}

void RemoveIronPower(object oPC, object oWeap)
{
      if (GetLocalInt(oWeap, "DispIronPowerA"))
      {
         SetCompositeBonus(oWeap, "DispIronPowerA", 0, ITEM_PROPERTY_ATTACK_BONUS);
         SetCompositeBonus(oWeap, "DispIronPowerD", 0, ITEM_PROPERTY_DAMAGE_BONUS);
         RemoveSpecificProperty(oWeap, ITEM_PROPERTY_KEEN, -1, -1, 1, "", -1, DURATION_TYPE_TEMPORARY);
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

   if (GetLocalInt(oPC,"ONEQUIP") == 2)
   {
      IronPower(oPC, GetPCItemLastEquipped());
   }

   if (GetLocalInt(oPC,"ONEQUIP") == 1)
   {
      RemoveIronPower(oPC, GetPCItemLastUnequipped());
   }

        if(bDivLor > 0) Device_Lore(oPC,oSkin,bDivLor);

        //if(bIrnPwr > 0 && (IsItemMetal(oWeap) == 2))
        //    Iron_Power(oPC,oWeap,bIrnPwr);
        //else
        //    Iron_Power(oPC,oWeap,0);

}