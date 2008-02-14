//::///////////////////////////////////////////////
//:: Warforged Armor Restrictions
//:: race_warforged.nss
//::///////////////////////////////////////////////
/*
    Handles restrictions on warforged armor-equipping
*/
//:://////////////////////////////////////////////
//:: Created By: Fox
//:: Created On: Feb 12, 2008
//:://////////////////////////////////////////////

#include "prc_alterations"

void DoWarforgedCheck(object oPC)
{
    object oHelm = GetItemPossessedBy(oPC, "prc_wf_helmhead");
    object oArmor = GetItemPossessedBy(oPC, "prc_wf_unacbody");
	
    if(GetItemInSlot(INVENTORY_SLOT_HEAD, oPC) == OBJECT_INVALID)
        AssignCommand(oPC, ActionEquipItem(oHelm, INVENTORY_SLOT_HEAD));

    if(GetItemInSlot(INVENTORY_SLOT_CHEST, oPC) == OBJECT_INVALID)
        AssignCommand(oPC, ActionEquipItem(oArmor, INVENTORY_SLOT_CHEST));
}

void main()
{
    int nEvent = GetRunningEvent();
    if(DEBUG) DoDebug("race_warforged running, event: " + IntToString(nEvent));

    // Init the PC.
    object oPC;
    object oItem;
    object oArmor;
    
    // We aren't being called from any event, instead from EvalPRCFeats
    if(nEvent == FALSE)
    {
    	oPC = OBJECT_SELF;
    	//Need to replace this with a GetItemPossessed check for the actual armor/helm
    	int nArmorExists = GetPersistantLocalInt(oPC, "WarforgedArmor");
        // Hook in the events
        if(DEBUG) DoDebug("race_warforged: Adding eventhooks");
        AddEventScript(oPC, EVENT_ONPLAYERUNEQUIPITEM, "race_warforged", TRUE, FALSE);
        
        if(!nArmorExists)
        {
            if(GetHasFeat(FEAT_IRONWOOD_PLATING, oPC))
                oArmor = CreateItemOnObject("prc_wf_woodbody", oPC);
            else if(GetHasFeat(FEAT_MITHRIL_PLATING, oPC))
                oArmor = CreateItemOnObject("prc_wf_mithbody", oPC);
            else if(GetHasFeat(FEAT_ADAMANTINE_PLATING, oPC))
                oArmor = CreateItemOnObject("prc_wf_admtbody", oPC);
            else if(GetHasFeat(FEAT_UNARMORED_BODY, oPC))
                oArmor = CreateItemOnObject("prc_wf_unacbody", oPC);
            else if(GetHasFeat(FEAT_COMPOSITE_PLATING, oPC))
                oArmor = CreateItemOnObject("prc_wf_compbody", oPC);
                
            object oHelm = CreateItemOnObject("prc_wf_helmhead", oPC);
                
            // Force equip
            AssignCommand(oPC, ActionEquipItem(oArmor, INVENTORY_SLOT_CHEST));
            AssignCommand(oPC, ActionEquipItem(oHelm, INVENTORY_SLOT_HEAD));
            
            SetPersistantLocalInt(oPC, "WarforgedArmor", TRUE);
        }
    }
    
	
    else if(nEvent == EVENT_ONPLAYERUNEQUIPITEM)
    {
    	oPC = GetItemLastUnequippedBy();
        oItem = GetItemLastUnequipped();
        if(DEBUG) DoDebug("race_warforged - OnUnEquip");
        
        if(oItem == GetItemInSlot(INVENTORY_SLOT_CHEST, oPC) 
           && GetHasFeat(FEAT_UNARMORED_BODY, oPC))
        {
            // Delay a bit to make sure they haven't equipped another armor
            DelayCommand(0.5f, DoWarforgedCheck(oPC)); 
        }
        
        else if(oItem == GetItemInSlot(INVENTORY_SLOT_CHEST, oPC) 
           && GetHasFeat(FEAT_IRONWOOD_PLATING, oPC)
           && GetResRef(oItem) == "prc_wf_woodbody")
        {
            // Force equip
            AssignCommand(oPC, ActionEquipItem(oItem, INVENTORY_SLOT_CHEST)); 
        }
        
        else if(oItem == GetItemInSlot(INVENTORY_SLOT_CHEST, oPC) 
           && GetHasFeat(FEAT_MITHRIL_PLATING, oPC)
           && GetResRef(oItem) == "prc_wf_mithbody")
        {
            // Force equip
            AssignCommand(oPC, ActionEquipItem(oItem, INVENTORY_SLOT_CHEST)); 
        }
        
        else if(oItem == GetItemInSlot(INVENTORY_SLOT_CHEST, oPC) 
           && GetHasFeat(FEAT_ADAMANTINE_PLATING, oPC)
           && GetResRef(oItem) == "prc_wf_admtbody")
        {
            // Force equip
            AssignCommand(oPC, ActionEquipItem(oItem, INVENTORY_SLOT_CHEST)); 
        }
        
        else if(oItem == GetItemInSlot(INVENTORY_SLOT_CHEST, oPC) 
           && GetHasFeat(FEAT_COMPOSITE_PLATING, oPC)
           && GetResRef(oItem) == "prc_wf_compbody")
        {
            // Force equip
            AssignCommand(oPC, ActionEquipItem(oItem, INVENTORY_SLOT_CHEST)); 
        }
                
        if(oItem == GetItemInSlot(INVENTORY_SLOT_HEAD, oPC))
        {
            // Delay a bit to make sure they haven't equipped another helm
            DelayCommand(0.5f, DoWarforgedCheck(oPC)); 
        }
    }
}