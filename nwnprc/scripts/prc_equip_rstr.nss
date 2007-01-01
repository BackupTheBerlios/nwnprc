#include "prc_alterations"
#include "prc_inc_itmrstr"

/*
Script to handle removal of items with the ability
or skill restriction itemproperties.

Fired from prc_equip

*/

void main()
{
    object oPC   = GetItemLastEquippedBy();
    object oItem = GetItemLastEquipped();
    int bUnequip = !CheckPRCLimitations(oItem, oPC);
    if(bUnequip)
    {
        // "You cannot equip " + GetName(oItem)
        SendMessageToPC(oPC, ReplaceChars(GetStringByStrRef(16828407), "<itemname>", GetName(oItem)));
        int i = 0;
        object oTest;
        do {
            oTest = GetItemInSlot(i, oPC);
            if(oTest == oItem)
            {
                DelayCommand(0.3f, ForceUnequip(oPC, oItem, i));
                return;
            }
            i++;
        } while(i < NUM_INVENTORY_SLOTS);
    }
}