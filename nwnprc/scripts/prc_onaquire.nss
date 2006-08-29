//::///////////////////////////////////////////////
//:: OnAcquireItem eventscript
//:: prc_onaquire
//:://////////////////////////////////////////////
#include "prc_alterations"
#include "psi_inc_manifest"

void main()
{
    // Find out the relevant objects
    object oCreature = GetModuleItemAcquiredBy();
    object oItem     = GetModuleItemAcquired();

    // Do not run for some of the PRC special items
    if(GetTag(oItem) == PRC_MANIFESTATION_TOKEN_NAME ||
       GetTag(oItem) == "HideToken"                  ||
       GetResRef(oItem) == "base_prc_skin"
       )
        return;

//if(DEBUG) DoDebug("Running OnAcquireItem, creature = '" + GetName(oCreature) + "' is PC: " + BooleanToString(GetIsPC(oCreature)) + "; Item = '" + GetName(oItem) + "' - '" + GetTag(oItem) + "'");

    //rest kits
    if(GetPRCSwitch(PRC_SUPPLY_BASED_REST))
        ExecuteScript("sbr_onaquire", OBJECT_SELF);

    // This is a resource hog. To work around, we assume that it's not going to cause noticeable issues if
    // racial restrictions are only ever expanded when a PC is involved
    if(GetIsPC(oCreature) || GetIsPC(GetMaster(oCreature)))
        ExecuteScript("race_ev_aquire", OBJECT_SELF);

    // Execute scripts hooked to this event for the creature and item triggering it
    ExecuteAllScriptsHookedToEvent(oCreature, EVENT_ONACQUIREITEM);
    ExecuteAllScriptsHookedToEvent(oItem, EVENT_ITEM_ONACQUIREITEM);
}
