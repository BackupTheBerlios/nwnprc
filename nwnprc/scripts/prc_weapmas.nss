#include "inc_item_props"
#include "prc_feat_const"
#include "inc_combat2"

void main()
{
    object oPC = OBJECT_SELF;
    object oWeap ;
    int iEquip = GetLocalInt(oPC,"ONEQUIP");
    int iLevel = (iEquip == 1) ? 0:1;

    if (iEquip ==1)
      oWeap = GetPCItemLastUnequipped();
    else
      oWeap = GetItemInSlot(INVENTORY_SLOT_RIGHTHAND,oPC);

    int iType = GetBaseItemType(oWeap);

    
    switch (iType)
    {
       case BASE_ITEM_LONGBOW:
       case BASE_ITEM_SHORTBOW:
         if ( GetHasFeat(FEAT_BOWMASTERY, oPC)) SetCompositeBonusT(oWeap,"WpMasBow",iLevel,ITEM_PROPERTY_ATTACK_BONUS);
         break;
       case BASE_ITEM_LIGHTCROSSBOW:
       case BASE_ITEM_HEAVYCROSSBOW:
         if ( GetHasFeat(FEAT_XBOWMASTERY, oPC)) SetCompositeBonusT(oWeap,"WpMasXBow",iLevel,ITEM_PROPERTY_ATTACK_BONUS);
       break;
       case BASE_ITEM_SHURIKEN:
         if ( GetHasFeat(FEAT_SHURIKENMASTERY, oPC)) 
               SetCompositeBonusT(oWeap,"WpMasShu",iLevel,ITEM_PROPERTY_ATTACK_BONUS);
       break;


    }

}
