//::///////////////////////////////////////////////
//:: OnUnaquireItem eventscript
//:: prc_onunaquire
//:://////////////////////////////////////////////
//Include required for Imbue Arrow functionality.
#include "prc_inc_clsfunc"
#include "inc_item_props"
#include "inc_eventhook"

void main()
{
    object oItem = GetModuleItemLost();
    object oPC = GetModuleItemLostBy();
    if (GetResRef(oItem) == AA_IMBUED_ARROW)
    {
        DestroyObject(oItem);
    }

   
    // Remove all temporary item properties when dropped/given away/stolen/sold.
    DeletePRCLocalIntsT(oPC,oItem);
    
    // Execute scripts hooked to this event for the player triggering it
	ExecuteAllScriptsHookedToEvent(oPC, EVENT_ONUNAQUIREITEM);
}
