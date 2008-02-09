//::///////////////////////////////////////////////
//:: Bladeling Armor Restrictions
//:: race_bldlngrstct.nss
//::///////////////////////////////////////////////
/*
    Handles restrictions on Bladeling Armor(Light Armor only)
*/
//:://////////////////////////////////////////////
//:: Created By: Fox
//:: Created On: Feb 8, 2008
//:://////////////////////////////////////////////

#include "prc_alterations"


// Returns the base armor type as a number, of oItem
// -1 if invalid, or not armor, or just plain not found.
// 0 to 8 as the value of AC got from the armor - 0 for none, 8 for Full plate.
int GetBaseArmorType(object oItem)
{
    // Make sure the item is valid and is an armor.
    if (!GetIsObjectValid(oItem))
        return -1;
    if (GetBaseItemType(oItem) != BASE_ITEM_ARMOR)
        return -1;

    // Get the identified flag for safe keeping.
    int bIdentified = GetIdentified(oItem);
    SetIdentified(oItem,FALSE);

    int nType = -1;
    switch (GetGoldPieceValue(oItem))
    {
        case    1: nType = 0; break; // None
        case    5: nType = 1; break; // Padded
        case   10: nType = 2; break; // Leather
        case   15: nType = 3; break; // Studded Leather / Hide
        case  100: nType = 4; break; // Chain Shirt / Scale Mail
        case  150: nType = 5; break; // Chainmail / Breastplate
        case  200: nType = 6; break; // Splint Mail / Banded Mail
        case  600: nType = 7; break; // Half-Plate
        case 1500: nType = 8; break; // Full Plate
    }
    // Restore the identified flag, and return armor type.
    SetIdentified(oItem,bIdentified);
    return nType;
}


void main()
{
    int nEvent = GetRunningEvent();
    if(DEBUG) DoDebug("race_bldlngrstct running, event: " + IntToString(nEvent));

    // Init the PC.
    object oPC = GetItemLastEquippedBy();
    object oItem;
    
    // We aren't being called from any event, instead from race_skin.nss
    if(nEvent == FALSE)
    {
        // Hook in the events
        if(DEBUG) DoDebug("race_bldlngrstct: Adding eventhooks");
        AddEventScript(OBJECT_SELF, EVENT_ONPLAYEREQUIPITEM,   "prc_restwpnsize", TRUE, FALSE);
    }
	
    else if(nEvent == EVENT_ONPLAYEREQUIPITEM)
    {
        oItem = GetItemLastEquipped();
        
        int nArmorType = GetBaseArmorType(oItem);
        
        if(DEBUG) DoDebug("race_bldlngrstct - OnEquip");
        if(DEBUG) DoDebug("race_bldlngrstct - Armor type: " + IntToString(nArmorType));
        
        //if not light armor, then force unequip
        if(nArmorType > 4)
        {
        	AssignCommand(oPC, ActionUnequipItem(GetItemInSlot(INVENTORY_SLOT_CHEST, oPC)));
        }
    }
}