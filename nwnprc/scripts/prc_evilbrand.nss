#include "inc_item_props"
#include "prc_feat_const"

/// +2 on Intimidate and Persuade /////////
void Evilbrand(object oPC ,object oSkin ,int iLevel)
{

   if(GetLocalInt(oSkin, "EvilbrandPe") == iLevel) return;
    SetCompositeBonus(oSkin, "EvilbrandPe", iLevel, ITEM_PROPERTY_SKILL_BONUS,SKILL_PERSUADE);
    SetCompositeBonus(oSkin, "EvilbrandI", iLevel, ITEM_PROPERTY_SKILL_BONUS,SKILL_INTIMIDATE);
}

void EB_app(object oPC,int iEquip)
{
  object oItem;
  object oPC = OBJECT_SELF;
  object oSkin = GetPCSkin(oPC);

  if (iEquip==2)
  {
     if ( GetLocalInt(oItem,"Evilbrand"))
         return;

     if (GetBaseItemType(oItem)==BASE_ITEM_INVALID)
     {
        Evilbrand(oPC, oSkin, 2);
        SetLocalInt(oItem,"Evilbrand",1);
     }
  }
  else if (iEquip==1)
  {
      oItem=GetPCItemLastUnequipped();
      if (GetBaseItemType(oItem)!=BASE_ITEM_INVALID) return;
         RemoveSpecificProperty(oSkin,ITEM_PROPERTY_SKILL_BONUS,SKILL_INTIMIDATE,2,GetLocalInt(oSkin, "EvilbrandI"));
         RemoveSpecificProperty(oSkin,ITEM_PROPERTY_SKILL_BONUS,SKILL_PERSUADE,2,GetLocalInt(oSkin, "EvilbrandPe"));
         DeleteLocalInt(oItem,"Evilbrand");
  }
   else
  {
     if ( !GetLocalInt(oItem,"Evilbrand")&& GetBaseItemType(oItem)==BASE_ITEM_INVALID)
     {
       Evilbrand(oPC, oSkin, 2);
       SetLocalInt(oItem,"Evilbrand",1);
     }
  }
}

void main()
{
    object oPC = OBJECT_SELF;
    object oSkin = GetPCSkin(oPC);

    //Check which feats the PC has
    int bEBHand;
    int bEBHead;
    int bEBChest;
    int bEBNeck;
    int bEBArm;
    if (GetHasFeat(FEAT_EB_HAND, oPC) > 0)
    {
     bEBHand == 1;
    }
    if (GetHasFeat(FEAT_EB_HEAD, oPC) > 0)
    {
     bEBHead == 1;
    }
    if (GetHasFeat(FEAT_EB_CHEST, oPC) > 0)
    {
     bEBChest == 1;
    }
    if (GetHasFeat(FEAT_EB_NECK, oPC)  > 0)
    {
     bEBNeck == 1;
    }
    if (GetHasFeat(FEAT_EB_ARM, oPC) > 0)
    {
     bEBArm == 1;
    }

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
    EB_app(oPC, GetLocalInt(oPC,"ONEQUIP"));
    }

    if(bEBHead > 0)
    {
    object oItem=GetItemInSlot(INVENTORY_SLOT_HEAD,oPC);
    EB_app(oPC, GetLocalInt(oPC,"ONEQUIP"));
    }
    if(bEBChest > 0)
    {
    object oItem=GetItemInSlot(INVENTORY_SLOT_CHEST,oPC);
    EB_app(oPC, GetLocalInt(oPC,"ONEQUIP"));
    }

    if(bEBNeck > 0)
    {
    object oItem=GetItemInSlot(INVENTORY_SLOT_CLOAK,oPC);
    EB_app(oPC, GetLocalInt(oPC,"ONEQUIP"));
    }

    if(bEBArm > 0)
    {
    object oItem=GetItemInSlot(INVENTORY_SLOT_LEFTHAND,oPC);
    EB_app(oPC, GetLocalInt(oPC,"ONEQUIP"));
    }
    }
    else
    {
      EB_app(oPC, GetLocalInt(oPC,"ONEQUIP"));
    }
}
