#include "inc_item_props"
#include "prc_feat_const"
#include "inc_combat"
#include "prc_inc_clsfunc"

void OnEquip(object oPC,object oSkin,int iLevel,object  oWeapR)
{
//  object oWeapR=GetItemInSlot(INVENTORY_SLOT_RIGHTHAND,oPC);
  int iDmg = 1;

  if(GetHasFeat(FEAT_LEGENDARY_PROWESS))  iDmg = 3;

  int iType= GetBaseItemType(oWeapR);
  object oItem=oWeapR;

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

  int iDType = GetWeaponDamageType(oWeapR);

  switch (iDType)
  {
     case DAMAGE_TYPE_SLASHING:
       iDType =IP_CONST_DAMAGETYPE_SLASHING;
       break;

     case DAMAGE_TYPE_PIERCING:
       iDType =IP_CONST_DAMAGETYPE_PIERCING;
       break;

     case DAMAGE_TYPE_BLUDGEONING:
       iDType =IP_CONST_DAMAGETYPE_BLUDGEONING;
       break;
  }

  SetCompositeDamageBonusT(oWeapR,"ManArmsDmg",iDmg,iDType);

  int bCore = 10 + GetLevelByClass(CLASS_TYPE_MANATARMS,oPC);

  if(GetHasFeat(FEAT_STRIKE_AT_CORE)&& GetLocalInt(oItem, "ManArmsCore")!= bCore)
  {
     if (GetLocalInt(oItem, "ManArmsCore"))
         RemoveSpecificProperty(oItem,ITEM_PROPERTY_ON_HIT_PROPERTIES,IP_CONST_ONHIT_ABILITYDRAIN, GetLocalInt(oItem, "ManArmsCore"),1,"ManArmsCore", IP_CONST_ABILITY_CON, DURATION_TYPE_TEMPORARY);
     AddItemProperty(DURATION_TYPE_TEMPORARY,ItemPropertyOnHitProps(IP_CONST_ONHIT_ABILITYDRAIN,bCore,IP_CONST_ABILITY_CON),oItem,9999.0);
     SetLocalInt(oItem,"ManArmsCore",bCore);

  }
}


void OnUnEquip(object oPC,object oSkin,int iLevel,object oWeapR )
{
    int iType= GetBaseItemType(oWeapR);
    object oItem=oWeapR;

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

    int iDType = GetWeaponDamageType(oWeapR);

    switch (iDType)
    {
       case DAMAGE_TYPE_SLASHING:
         iDType =IP_CONST_DAMAGETYPE_SLASHING;
         break;

       case DAMAGE_TYPE_PIERCING:
         iDType =IP_CONST_DAMAGETYPE_PIERCING;
         break;

       case DAMAGE_TYPE_BLUDGEONING:
         iDType =IP_CONST_DAMAGETYPE_BLUDGEONING;
         break;
    }

    SetCompositeDamageBonusT(oWeapR,"ManArmsDmg",0,iDType);

    RemoveSpecificProperty(oItem,ITEM_PROPERTY_ON_HIT_PROPERTIES,IP_CONST_ONHIT_ABILITYDRAIN, -1,1,"ManArmsCore", IP_CONST_ABILITY_CON, DURATION_TYPE_TEMPORARY);

}

void main()
{
  //Declare main variables.
    object oPC = OBJECT_SELF;
    object oSkin = GetPCSkin(oPC);

    int iAtk = GetHasFeat(FEAT_LEGENDARY_PROWESS,oPC) ? 3:1;

    int iEquip= GetLocalInt(oPC,"ONEQUIP");

    if (GetHasFeat(FEAT_LEGENDARY_PROWESS,oPC))
       SetCompositeBonus(oSkin,"ManArmsAC",2,ITEM_PROPERTY_AC_BONUS);
   
    if (iEquip ==1)
    {
       OnUnEquip(oPC,oSkin,iAtk,GetPCItemLastUnequipped());
    }
    else
    {
       OnEquip(oPC,oSkin,iAtk,GetItemInSlot(INVENTORY_SLOT_RIGHTHAND,oPC));
       OnEquip(oPC,oSkin,iAtk,GetItemInSlot(INVENTORY_SLOT_LEFTHAND,oPC));
    }

    if (GetIsObjectValid(GetItemInSlot(INVENTORY_SLOT_RIGHTHAND)))
       SetCompositeAttackBonus(oPC, "ManArmsGenSpe", iAtk);
    else
       SetCompositeAttackBonus(oPC, "ManArmsGenSpe", 0);

    if (GetHasFeat(FEAT_MASTER_CRITICAL,oPC)) ImpCrit(oPC,GetPCSkin(oPC));
}
