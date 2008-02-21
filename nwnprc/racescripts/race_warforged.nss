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

void CreateWarforgedArmor(object oPC)
{
    object oArmor;
    object oHelm;
    object oFeatHide = CreateItemOnObject("prc_wf_feats", oPC);
        
    if(GetHasFeat(FEAT_IRONWOOD_PLATING, oPC))
    {
    	oArmor = CreateItemOnObject("prc_wf_woodbody", oPC);
        oHelm = CreateItemOnObject("prc_wf_helmwood", oPC);
    }
    else if(GetHasFeat(FEAT_MITHRIL_PLATING, oPC))
    {
    	oArmor = CreateItemOnObject("prc_wf_mithbody", oPC);
        oHelm = CreateItemOnObject("prc_wf_helmmith", oPC);
    }
    else if(GetHasFeat(FEAT_ADAMANTINE_PLATING, oPC))
    {
    	oArmor = CreateItemOnObject("prc_wf_admtbody", oPC);
        oHelm = CreateItemOnObject("prc_wf_helmadmt", oPC);
    }
    else if(GetHasFeat(FEAT_UNARMORED_BODY, oPC))
    {
        oArmor = CreateItemOnObject("prc_wf_unacbody", oPC);
        oHelm = CreateItemOnObject("prc_wf_helmhead", oPC);
    }
    else if(GetHasFeat(FEAT_COMPOSITE_PLATING, oPC))
    {
        oArmor = CreateItemOnObject("prc_wf_compbody", oPC);
        oHelm = CreateItemOnObject("prc_wf_helmhead", oPC);
    }
    
    //Circumvention for armor prof feats on CARMOR not working
    AssignCommand(oPC, ActionEquipItem(oFeatHide, INVENTORY_SLOT_CWEAPON_B)); 
                   
    // Force equip
    AssignCommand(oPC, ActionEquipItem(oArmor, INVENTORY_SLOT_CHEST));
    AssignCommand(oPC, ActionEquipItem(oHelm, INVENTORY_SLOT_HEAD));
}

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
    	int nArmorExists = GetItemPossessedBy(oPC, "prc_wf_unacbody") != OBJECT_INVALID
    	                   || GetItemPossessedBy(oPC, "prc_wf_woodbody") != OBJECT_INVALID
    	                   || GetItemPossessedBy(oPC, "prc_wf_mithbody") != OBJECT_INVALID
    	                   || GetItemPossessedBy(oPC, "prc_wf_admtbody") != OBJECT_INVALID
    	                   || GetItemPossessedBy(oPC, "prc_wf_compbody") != OBJECT_INVALID;
        // Hook in the events
        if(DEBUG) DoDebug("race_warforged: Adding eventhooks");
        AddEventScript(oPC, EVENT_ONPLAYERUNEQUIPITEM, "race_warforged", TRUE, FALSE);
        //may not be needed, put in just in case(ala HotU start)
        AddEventScript(oPC, EVENT_ONUNAQUIREITEM, "race_warforged", TRUE, FALSE);
        
        if(!nArmorExists)
        {
            CreateWarforgedArmor(oPC);
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
            //Add proficiency
            itemproperty ipIP =ItemPropertyBonusFeat(IP_CONST_FEAT_ARMOR_PROF_LIGHT);
            IPSafeAddItemProperty(GetPCSkin(oPC), ipIP, 0.0, X2_IP_ADDPROP_POLICY_REPLACE_EXISTING, FALSE, FALSE);
            // Force equip
            AssignCommand(oPC, ActionEquipItem(oItem, INVENTORY_SLOT_CHEST)); 
        }
        
        else if(oItem == GetItemInSlot(INVENTORY_SLOT_CHEST, oPC) 
           && GetHasFeat(FEAT_MITHRIL_PLATING, oPC)
           && GetResRef(oItem) == "prc_wf_mithbody")
        {
            itemproperty ipIP =ItemPropertyBonusFeat(IP_CONST_FEAT_ARMOR_PROF_LIGHT);
            IPSafeAddItemProperty(GetPCSkin(oPC), ipIP, 0.0, X2_IP_ADDPROP_POLICY_REPLACE_EXISTING, FALSE, FALSE);
            // Force equip
            AssignCommand(oPC, ActionEquipItem(oItem, INVENTORY_SLOT_CHEST)); 
        }
        
        else if(oItem == GetItemInSlot(INVENTORY_SLOT_CHEST, oPC) 
           && GetHasFeat(FEAT_ADAMANTINE_PLATING, oPC)
           && GetResRef(oItem) == "prc_wf_admtbody")
        {        	
            itemproperty ipIP =ItemPropertyBonusFeat(IP_CONST_FEAT_ARMOR_PROF_HEAVY);
            IPSafeAddItemProperty(GetPCSkin(oPC), ipIP, 0.0, X2_IP_ADDPROP_POLICY_REPLACE_EXISTING, FALSE, FALSE);
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
    
    else if(nEvent == EVENT_ONUNAQUIREITEM)
    {
        if(DEBUG) DoDebug("race_warforged: OnUnAcquire");
        object oItem = GetModuleItemLost();
        if(GetStringLeft(GetTag(oItem), 7) == "prc_wf_")
        {
            if(DEBUG) DoDebug("Destroying lost warforged stuff");
            MyDestroyObject(oItem);
        }
        
        //recreates armor after 1 second to avoid triggering any infinite loops from HotU-type scripts
        DelayCommand(1.0, CreateWarforgedArmor(oPC));
    }
}