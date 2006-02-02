//::///////////////////////////////////////////////
//:: OnAcquireItem eventscript
//:: prc_onaquire
//:://////////////////////////////////////////////
#include "prc_alterations"
#include "inc_utility"
#include "psi_inc_manifest"

void main()
{
    object oCreature = GetModuleItemAcquiredBy();
    object oItem = GetModuleItemAcquired();
    // Do not run for the Ability Score clone, since it's getting destroyed in a moment anyway
    if(GetStringLeft(GetTag(oCreature), 23) == "PRC_AbilityScore_Clone_")
        return;
    // Do not run for the Manifestation tokens
    if(GetTag(oItem) == PRC_MANIFESTATION_TOKEN_NAME)
        return;

//if(DEBUG) DoDebug("Running OnAcquireItem, creature = '" + GetName(oCreature) + "' is PC: " + BooleanToString(GetIsPC(oCreature)) + "; Item = '" + GetName(oItem) + "' - '" + GetTag(oItem) + "'");

    //rest kits
    if(GetPRCSwitch(PRC_SUPPLY_BASED_REST))
        ExecuteScript("sbr_onaquire", OBJECT_SELF);

    ExecuteScript("race_ev_aquire", OBJECT_SELF);

    // Execute scripts hooked to this event for the creature and item triggering it
    ExecuteAllScriptsHookedToEvent(oCreature, EVENT_ONACQUIREITEM);
    ExecuteAllScriptsHookedToEvent(oItem, EVENT_ITEM_ONACQUIREITEM);
}
