//
// Evil Brand By Zedium
//

#include "inc_item_props"
#include "prc_feat_const"

///Evil Brand +2 on persuade and intimidate /////////
void EvilBrand(object oPC ,object oSkin ,int iLevel)
{
   if(GetLocalInt(oSkin, "EB_I") == iLevel) return;

   SetCompositeBonus(oSkin, "EB_I", iLevel, ITEM_PROPERTY_SKILL_BONUS,SKILL_INTIMIDATE);
   SetCompositeBonus(oSkin, "EB_I", iLevel, ITEM_PROPERTY_SKILL_BONUS,SKILL_PERSUADE);

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
    if(bEBHand > 0 && GetBaseItemType(oHand) == BASE_ITEM_INVALID ) EvilBrand(oPC, oSkin, bEBHand);
    if(bEBHead > 0 && GetBaseItemType(oHead) == BASE_ITEM_INVALID ) EvilBrand(oPC, oSkin, bEBHand);
    if(bEBChest > 0 && GetBaseItemType(oChest) == BASE_ITEM_INVALID ) EvilBrand(oPC, oSkin, bEBHand);
    if(bEBNeck > 0 && GetBaseItemType(oNeck) == BASE_ITEM_INVALID ) EvilBrand(oPC, oSkin, bEBHand);
    if(bEBArm > 0 && GetBaseItemType(oArm) == BASE_ITEM_INVALID ) EvilBrand(oPC, oSkin, bEBHand);
    }
     else
      {
      EvilBrand(oPC, oSkin,0);
      }

}