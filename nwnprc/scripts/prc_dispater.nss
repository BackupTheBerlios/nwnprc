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

///Iron Power Bonus to Attack and Damage /////////
void Iron_Power(object oPC, object oWeap, int iIronPower)
{

    int iEnhance = GetWeaponEnhancement(oWeap);
    //int iAB = GetWeaponAtkBonusIP(oWeap,oPC);

    iIronPower = iIronPower + iEnhance;

    string irp = IntToString(iIronPower);
    SendMessageToPC(GetFirstPC(), "Attack Bonus:" + irp);



        if(GetLocalInt(oWeap, "IPowerBonus") != iIronPower)
        {
            RemoveIronPower(oWeap);
            AddItemProperty(DURATION_TYPE_PERMANENT, ItemPropertyAttackBonus(iIronPower), oWeap);
           // AddItemProperty(DURATION_TYPE_PERMANENT, ItemPropertyDamageBonus(IP_CONST_DAMAGETYPE_PHYSICAL,iHitBonus), oWeap);
            AddItemProperty(DURATION_TYPE_PERMANENT, ItemPropertyKeen(), oWeap);
            SetLocalInt(oWeap, "IPowerBonus", iIronPower);
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

    if (IsItemMetal(oWeap) == 2)
    {
        if (GetLevelByClass(CLASS_TYPE_DISPATER,oPC) >= 4)
        {
        Iron_Power(oPC, oWeap, 1);
        }
        else if (GetLevelByClass(CLASS_TYPE_DISPATER,oPC) >= 8)
        {
        Iron_Power(oPC, oWeap, 2);
        }
    }

        if(bDivLor > 0) Device_Lore(oPC,oSkin,bDivLor);

        //if(bIrnPwr > 0 && (IsItemMetal(oWeap) == 2))
        //    Iron_Power(oPC,oWeap,bIrnPwr);
        //else
        //    Iron_Power(oPC,oWeap,0);

}