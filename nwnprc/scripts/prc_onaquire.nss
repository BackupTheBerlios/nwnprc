//::///////////////////////////////////////////////
//:: OnAcquireItem eventscript
//:: prc_onaquire
//:://////////////////////////////////////////////

#include "inc_eventhook"

void main()
{
    // Handle someone acquiring an poisoned item.
    //ExecuteScript("poison_onaquire", OBJECT_SELF);
    //rest kits
    if(GetPRCSwitch(PRC_SUPPLY_BASED_REST))
        ExecuteScript("sbr_onaquire", OBJECT_SELF);
    
    // Execute scripts hooked to this event for the creature and item triggering it
    object oCreature = GetModuleItemAcquiredBy();
    object oItem = GetModuleItemAcquired();
    ExecuteAllScriptsHookedToEvent(oCreature, EVENT_ONACQUIREITEM);
    ExecuteAllScriptsHookedToEvent(oItem, EVENT_ITEM_ONACQUIREITEM);
}
