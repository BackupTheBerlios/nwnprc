//
// Evil Brand By Zedium
//

#include "inc_item_props"
#include "prc_feat_const"
#include "prc_class_const"

///Evil Brand +2 on persuade and intimidate /////////
void EvilBrand(object oPC,int iEquip ,int iLevel)
    {
    object oItem ;
    object oSkin = GetPCSkin(OBJECT_SELF);

    if (iEquip==2)
    {
        if ( GetLocalInt(oItem,"Evilbrand"))
        return;

     if (GetBaseItemType(oItem)==BASE_ITEM_INVALID)
        {
            SetCompositeBonus(oSkin, "EB_I", iLevel, ITEM_PROPERTY_SKILL_BONUS,SKILL_INTIMIDATE);
            SetCompositeBonus(oSkin, "EB_I", iLevel, ITEM_PROPERTY_SKILL_BONUS,SKILL_PERSUADE);
            SetLocalInt(oSkin,"Evilbrand",1);
        }
    }
    else if (iEquip==1)
    {
        if (GetBaseItemType(oItem)!=BASE_ITEM_INVALID)
        {
            SetCompositeBonus(oSkin, "EB_I", iLevel, ITEM_PROPERTY_SKILL_BONUS,SKILL_INTIMIDATE);
            SetCompositeBonus(oSkin, "EB_I", iLevel, ITEM_PROPERTY_SKILL_BONUS,SKILL_PERSUADE);
            DeleteLocalInt(oSkin,"Evilbrand");
        }
    }
    else
    {
        if ( !GetLocalInt(oItem,"Evilbrand")&& GetBaseItemType(oItem)==BASE_ITEM_INVALID)
        {
        SetCompositeBonus(oSkin, "EB_I", iLevel, ITEM_PROPERTY_SKILL_BONUS,SKILL_INTIMIDATE);
        SetCompositeBonus(oSkin, "EB_I", iLevel, ITEM_PROPERTY_SKILL_BONUS,SKILL_PERSUADE);
        SetLocalInt(oSkin,"Evilbrand",1);
    }
    }
    }


void main()
{
//
// Evil Brand By Zedium
//

#include "inc_item_props"
#include "prc_feat_const"
#include "prc_class_const"

///Evil Brand +2 on persuade and intimidate /////////
void EvilBrand(object oPC,int iEquip ,int iLevel)
    {
    object oItem ;
    object oSkin = GetPCSkin(OBJECT_SELF);

    if (iEquip==2)
    {
        if ( GetLocalInt(oItem,"Evilbrand"))
        return;

     if (GetBaseItemType(oItem)==BASE_ITEM_INVALID)
        {
            SetCompositeBonus(oSkin, "EB_I", iLevel, ITEM_PROPERTY_SKILL_BONUS,SKILL_INTIMIDATE);
            SetCompositeBonus(oSkin, "EB_I", iLevel, ITEM_PROPERTY_SKILL_BONUS,SKILL_PERSUADE);
            SetLocalInt(oSkin,"Evilbrand",1);
        }
    }
    else if (iEquip==1)
    {
        if (GetBaseItemType(oItem)!=BASE_ITEM_INVALID)
        {
            SetCompositeBonus(oSkin, "EB_I", iLevel, ITEM_PROPERTY_SKILL_BONUS,SKILL_INTIMIDATE);
            SetCompositeBonus(oSkin, "EB_I", iLevel, ITEM_PROPERTY_SKILL_BONUS,SKILL_PERSUADE);
            DeleteLocalInt(oSkin,"Evilbrand");
        }
    }
    else
    {
        if ( !GetLocalInt(oItem,"Evilbrand")&& GetBaseItemType(oItem)==BASE_ITEM_INVALID)
        {
        SetCompositeBonus(oSkin, "EB_I", iLevel, ITEM_PROPERTY_SKILL_BONUS,SKILL_INTIMIDATE);
        SetCompositeBonus(oSkin, "EB_I", iLevel, ITEM_PROPERTY_SKILL_BONUS,SKILL_PERSUADE);
        SetLocalInt(oSkin,"Evilbrand",1);
    }
    }
    }


void main()
{
    object oPC = OBJECT_SELF;
    object oSkin = GetPCSkin(oPC);

    //Check which feats the PC has
    int bEBHand = GetHasFeat(FEAT_EB_HAND, oPC) ? 2 : 0;
    int bEBHead = GetHasFeat(FEAT_EB_HEAD, oPC) ? 2 : 0;
    int bEBChest = GetHasFeat(FEAT_EB_CHEST, oPC) ? 2 : 0;
    int bEBNeck = GetHasFeat(FEAT_EB_NECK, oPC) ? 2 : 0;
    int bEBArm = GetHasFeat(FEAT_EB_ARM, oPC) ? 2 : 0;

    //Define the objects
    object oHand = GetItemInSlot(INVENTORY_SLOT_ARMS, oPC);
    object oHead = GetItemInSlot(INVENTORY_SLOT_HEAD, oPC);
    object oChest = GetItemInSlot(INVENTORY_SLOT_CHEST, oPC);
    object oNeck = GetItemInSlot(INVENTORY_SLOT_CLOAK, oPC);
    object oArm = GetItemInSlot(INVENTORY_SLOT_LEFTHAND, oPC);

    //Check alignment and check what bonus applies
    if(GetAlignmentGoodEvil(oPC) == ALIGNMENT_EVIL)
    {
    if(bEBHand > 0)
    {
    object oItem=GetItemInSlot(INVENTORY_SLOT_ARMS,oPC);
    EvilBrand(oPC, GetLocalInt(oPC,"ONEQUIP"), 2);
    }

    if(bEBHead > 0)
    {
    object oItem=GetItemInSlot(INVENTORY_SLOT_HEAD,oPC);
    EvilBrand(oPC, GetLocalInt(oPC,"ONEQUIP"), 2);
    }
    if(bEBChest > 0)
    {
    object oItem=GetItemInSlot(INVENTORY_SLOT_CHEST,oPC);
    EvilBrand(oPC, GetLocalInt(oPC,"ONEQUIP"), 2);
    }

    if(bEBNeck > 0)
    {
    object oItem=GetItemInSlot(INVENTORY_SLOT_CLOAK,oPC);
    EvilBrand(oPC, GetLocalInt(oPC,"ONEQUIP"), 2);
    }

    if(bEBArm > 0)
    {
    object oItem=GetItemInSlot(INVENTORY_SLOT_LEFTHAND,oPC);
    EvilBrand(oPC, GetLocalInt(oPC,"ONEQUIP"), 2);
    }
    }
    else
    {
      EvilBrand(oPC, GetLocalInt(oPC,"ONEQUIP"), 0);
    }
}