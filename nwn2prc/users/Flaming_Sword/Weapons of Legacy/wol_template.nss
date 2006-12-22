/*
    wol_template

    Weapons of Legacy script template

    By: Flaming_Sword
    Created: Dec 10, 2006
    Modified: Dec 10, 2006


    Notes:
        restricted to 1 per character at a time
*/

#include "prc_inc_wol"

int WoL_Prereqs(object oPC)
{
    return TRUE;
}

void main()
{
    object oPC = OBJECT_SELF;
    int iEquip = GetLocalInt(oPC,"ONEQUIP");  //2 = equip, 1 = unequip
    int iRest = GetLocalInt(oPC,"ONREST");  //1 = rest finished
    int iEnter = GetLocalInt(oPC,"ONENTER");  //1 = rest finished
}