
#include "x0_i0_henchman"

void main()
{
    object oItem = GetItemInSlot(INVENTORY_SLOT_CHEST);
    if (GetIsObjectValid(oItem))
    {
        CopyObject(oItem, GetLocation(OBJECT_SELF));
        DestroyObject(oItem,1.0);
        DestroyObject(OBJECT_SELF,1.0);
//        ActionUnequipItem(oItem);
//        ActionPutDownItem(oItem);
    }
    else
    {
        oItem = GetItemInSlot(INVENTORY_SLOT_RIGHTHAND);
        if (GetIsObjectValid(oItem))
        {
            CopyObject(oItem, GetLocation(OBJECT_SELF));
            DestroyObject(oItem,1.0);
            DestroyObject(OBJECT_SELF,1.0);
        }
    }
}
