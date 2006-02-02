//::///////////////////////////////////////////////
//:: OnUnaquireItem eventscript
//:: prc_onunaquire
//:://////////////////////////////////////////////
//Include required for Imbue Arrow functionality.
#include "prc_alterations"
#include "prc_inc_clsfunc"
#include "inc_utility"
#include "psi_inc_manifest"

void main()
{
    object oItem = GetModuleItemLost();
    object oPC = GetModuleItemLostBy();
    // Do not run for the Ability Score clone, since it's getting destroyed in a moment anyway
    if(GetStringLeft(GetTag(oPC), 23) == "PRC_AbilityScore_Clone_")
        return;
    // Do not run for the Manifestation tokens
    if(GetTag(oItem) == PRC_MANIFESTATION_TOKEN_NAME)
        return;

//if(DEBUG) DoDebug("Running OnUnaquireItem, creature = '" + GetName(oPC) + "' is PC: " + BooleanToString(GetIsPC(oPC)) + "; Item = '" + GetName(oItem) + "' - '" + GetTag(oItem) + "'");


    // Remove all temporary item properties when dropped/given away/stolen/sold.
    if(GetIsObjectValid(oItem))//needed for last of stack etc items
        DeletePRCLocalIntsT(oPC,oItem);

    // Execute scripts hooked to this event for the creature and item triggering it
    ExecuteAllScriptsHookedToEvent(oPC, EVENT_ONUNAQUIREITEM);
    ExecuteAllScriptsHookedToEvent(oItem, EVENT_ITEM_ONUNAQUIREITEM);
}
