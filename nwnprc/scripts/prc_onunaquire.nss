//
// Stub function for possible later use.
//
#include "inc_item_props"

void main()
{
    object oItem = GetModuleItemLost();
    object oPC = GetModuleItemLostBy();
   
    // Remove all temporary item properties when dropped/given away/stolen/sold.
    DeletePRCLocalIntsT(oPC,oItem);
}
