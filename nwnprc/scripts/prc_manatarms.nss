#include "inc_item_props"
#include "prc_feat_const"
#include "inc_combat"
#include "soul_inc"

void OnEquip(object oPC,object oSkin,int iLevel,object  oWeapR)
{
//  object oWeapR=GetItemInSlot(INVENTORY_SLOT_RIGHTHAND,oPC);


 if(GetLocalInt(oWeapR, "ManArmsGenSpe")!=iLevel)
 {
    SetCompositeBonus(oWeapR,"ManArmsGenSpe",iLevel,ITEM_PROPERTY_ATTACK_BONUS);

 }

 int iDmg = IP_CONST_DAMAGEBONUS_1;

 if(GetHasFeat(FEAT_LEGENDARY_PROWESS))
      iDmg = IP_CONST_DAMAGEBONUS_3;


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

 if (GetLocalInt(oWeapR, "ManArmsDmg")!=iDmg)
 {



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


    RemoveSpecificProperty(oItem,ITEM_PROPERTY_DAMAGE_BONUS,iDType,GetLocalInt(oItem,"ManArmsDmg"));
    AddItemProperty(DURATION_TYPE_PERMANENT,ItemPropertyDamageBonus(iDType,iDmg),oItem);
    SetLocalInt(oItem,"ManArmsDmg",iDmg);


  }

  int bCore=IP_CONST_ONHIT_SAVEDC_16;   
      bCore=GetHasFeat(FEAT_STRIKE_AT_CORE2, oPC) ? IP_CONST_ONHIT_SAVEDC_17 : bCore;
      bCore=GetHasFeat(FEAT_STRIKE_AT_CORE3, oPC) ? IP_CONST_ONHIT_SAVEDC_18 : bCore;
      bCore=GetHasFeat(FEAT_STRIKE_AT_CORE4, oPC) ? IP_CONST_ONHIT_SAVEDC_19 : bCore;
      bCore=GetHasFeat(FEAT_STRIKE_AT_CORE5, oPC) ? IP_CONST_ONHIT_SAVEDC_20 : bCore;

  if(GetHasFeat(FEAT_STRIKE_AT_CORE)&& GetLocalInt(oItem, "ManArmsCore")!= bCore)
  {
     if (GetLocalInt(oItem, "ManArmsCore"))
         RemoveSpecificProperty(oItem,ITEM_PROPERTY_ON_HIT_PROPERTIES,IP_CONST_ONHIT_ABILITYDRAIN,GetLocalInt(oItem, "ManArmsCore"),1,"",IP_CONST_ABILITY_CON);
     AddItemProperty(DURATION_TYPE_PERMANENT,ItemPropertyOnHitProps(IP_CONST_ONHIT_ABILITYDRAIN,bCore,IP_CONST_ABILITY_CON),oItem);
     SetLocalInt(oItem,"ManArmsCore",bCore);

  }

}


void OnUnEquip(object oPC,object oSkin,int iLevel,object oWeapR )
{

//  object oWeapR=GetPCItemLastUnequipped();

  if(GetLocalInt(oWeapR, "ManArmsGenSpe"))
  {
    SetCompositeBonus(oWeapR,"ManArmsGenSpe",0,ITEM_PROPERTY_ATTACK_BONUS);

  }

  if (GetLocalInt(oWeapR, "ManArmsDmg"))
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

    RemoveSpecificProperty(oItem,ITEM_PROPERTY_DAMAGE_BONUS,iDType,GetLocalInt(oItem,"ManArmsDmg"));
    DeleteLocalInt(oItem,"ManArmsDmg");

    int bCore=IP_CONST_ONHIT_SAVEDC_16;   
        bCore=GetHasFeat(FEAT_STRIKE_AT_CORE2, oPC) ? IP_CONST_ONHIT_SAVEDC_17 : bCore;
        bCore=GetHasFeat(FEAT_STRIKE_AT_CORE3, oPC) ? IP_CONST_ONHIT_SAVEDC_18 : bCore;
        bCore=GetHasFeat(FEAT_STRIKE_AT_CORE4, oPC) ? IP_CONST_ONHIT_SAVEDC_19 : bCore;
        bCore=GetHasFeat(FEAT_STRIKE_AT_CORE5, oPC) ? IP_CONST_ONHIT_SAVEDC_20 : bCore;
 
    if(GetHasFeat(FEAT_STRIKE_AT_CORE)&& GetLocalInt(oItem, "ManArmsCore"))
    {	
      RemoveSpecificProperty(oItem,ITEM_PROPERTY_ON_HIT_PROPERTIES,IP_CONST_ONHIT_ABILITYDRAIN,GetLocalInt(oItem, "ManArmsCore"),1,"",IP_CONST_ABILITY_CON);
      DeleteLocalInt(oItem,"ManArmsCore");
    }
  }

}

void OnEnter(object oPC,object oSkin,int iLevel,object  oWeapR)
{

  SetLocalInt(oWeapR,"ManArmsGenSpe",iLevel);
  int iDmg = IP_CONST_DAMAGEBONUS_1;

  if(GetHasFeat(FEAT_LEGENDARY_PROWESS))
      iDmg = IP_CONST_DAMAGEBONUS_3;


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

    SetLocalInt(oItem,"ManArmsDmg",iDmg);

  int bCore=IP_CONST_ONHIT_SAVEDC_16;   
      bCore=GetHasFeat(FEAT_STRIKE_AT_CORE2, oPC) ? IP_CONST_ONHIT_SAVEDC_17 : bCore;
      bCore=GetHasFeat(FEAT_STRIKE_AT_CORE3, oPC) ? IP_CONST_ONHIT_SAVEDC_18 : bCore;
      bCore=GetHasFeat(FEAT_STRIKE_AT_CORE4, oPC) ? IP_CONST_ONHIT_SAVEDC_19 : bCore;
      bCore=GetHasFeat(FEAT_STRIKE_AT_CORE5, oPC) ? IP_CONST_ONHIT_SAVEDC_20 : bCore;

  if(GetHasFeat(FEAT_STRIKE_AT_CORE))
    SetLocalInt(oItem,"ManArmsCore",bCore);


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

    if (GetLocalInt(oPC,"ONENTER"))
    {
      
       OnEnter(oPC,oSkin,iAtk,GetItemInSlot(INVENTORY_SLOT_RIGHTHAND,oPC));
       OnEnter(oPC,oSkin,iAtk,GetItemInSlot(INVENTORY_SLOT_LEFTHAND,oPC));
       return;	
    }
    
    if (iEquip ==2)
    {
       OnEquip(oPC,oSkin,iAtk,GetPCItemLastEquipped());
    }
    else if (iEquip ==1)
    {
       OnUnEquip(oPC,oSkin,iAtk,GetPCItemLastUnequipped());
    }
    else
    {
       OnEquip(oPC,oSkin,iAtk,GetItemInSlot(INVENTORY_SLOT_RIGHTHAND,oPC));
       OnEquip(oPC,oSkin,iAtk,GetItemInSlot(INVENTORY_SLOT_LEFTHAND,oPC));
    }


 

}
