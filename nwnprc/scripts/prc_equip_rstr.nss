#include "inc_prc_npc"
#include "prc_inc_itmrstr"

/*
Script to handle removal of items with the ability
or skill restriction itemproperties.

Fired from prc_equip

*/
void main()
{
    object oPC = GetItemLastEquippedBy();
    object oItem = GetItemLastEquipped();
    itemproperty ipTest = GetFirstItemProperty(oItem);
    int bUnequip = CheckPRCLimitations(oItem, oPC);
    if(!bUnequip)
    {
        SendMessageToPC(oPC, "You cannot equip "+GetName(oItem));
//        SetCommandable(TRUE, oPC);
        AssignCommand(oPC, ClearAllActions());
        AssignCommand(oPC, ActionUnequipItem(oItem));
        AssignCommand(oPC, ActionDoCommand(SetCommandable(TRUE, oPC)));
        AssignCommand(oPC, SetCommandable(FALSE, oPC));
    }
}