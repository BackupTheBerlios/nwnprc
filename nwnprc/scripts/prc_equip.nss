//::///////////////////////////////////////////////
//:: Example XP2 OnItemEquipped
//:: x2_mod_def_equ
//:: (c) 2003 Bioware Corp.
//:://////////////////////////////////////////////
/*
    Put into: OnEquip Event
*/
//:://////////////////////////////////////////////
//:: Created By: Georg Zoeller
//:: Created On: 2003-07-16
//:://////////////////////////////////////////////
#include "x2_inc_switches"
#include "x2_inc_intweapon"


void PrcFeats(object oPC)
{
     SetLocalInt(oPC,"ONEQUIP",2);
     EvalPRCFeats(oPC);
     DeleteLocalInt(oPC,"ONEQUIP");
}

//Added hook into EvalPRCFeats event
//  Aaon Graywolf - 6 Jan 2004
//Added delay to EvalPRCFeats event to allow module setup to take priority
//  Aaon Graywolf - Jan 6, 2004

void main()
{
    object oItem = GetItemLastEquipped();
    object oPC   = GetItemLastEquippedBy();
  

    DelayCommand(0.3, PrcFeats(oPC));

}
