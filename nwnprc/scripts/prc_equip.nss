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

#include "prc_alterations"
#include "prc_inc_function"
#include "inc_utility"
#include "inc_timestop"


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
//Removed the delay. It was messing up evaluation scripts that use GetItemLastEquipped(By)
//  Ornedan - 07.03.2005

void main()
{
    object oItem = GetItemLastEquipped();
    object oPC   = GetItemLastEquippedBy();
    // Do not run the event for ability score testing clones. Their equipments gets deleted in a few milliseconds anyway
    if(GetStringLeft(GetTag(oPC), 23) == "PRC_AbilityScore_Clone_")
        return;
//if(DEBUG) DoDebug("Running OnEquip, creature = '" + GetName(oPC) + "' is PC: " + BooleanToString(GetIsPC(oPC)) + "; Item = '" + GetName(oItem) + "' - '" + GetTag(oItem) + "'");

    //DelayCommand(0.3, PrcFeats(oPC));
    PrcFeats(oPC);

    // Handle ability skill limited items
    ExecuteScript("prc_equip_rstr", OBJECT_SELF);
    //timestop noncombat equip
    DoTimestopEquip();

    //Handle lack of fingers/hands
    if(GetPersistantLocalInt(oPC, "LEFT_HAND_USELESS"))
    {
        //Force unequip
        ForceUnequip(oPC, GetItemInSlot(INVENTORY_SLOT_LEFTHAND, oPC), INVENTORY_SLOT_LEFTHAND, TRUE);
        SendMessageToPC(oPC, "You cannot use your left hand");
    }

    if(GetPersistantLocalInt(oPC, "RIGHT_HAND_USELESS"))
    {
        //Force unequip
        ForceUnequip(oPC, GetItemInSlot(INVENTORY_SLOT_RIGHTHAND, oPC), INVENTORY_SLOT_RIGHTHAND, TRUE);
        SendMessageToPC(oPC, "You cannot use your right hand");
    }

    // Execute scripts hooked to this event for the creature and item triggering it
    ExecuteAllScriptsHookedToEvent(oPC, EVENT_ONPLAYEREQUIPITEM);
    ExecuteAllScriptsHookedToEvent(oItem, EVENT_ITEM_ONPLAYEREQUIPITEM);
}
