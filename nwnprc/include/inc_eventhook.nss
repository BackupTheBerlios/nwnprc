//::///////////////////////////////////////////////
//:: Generic eventhook include
//:: inc_eventhook
//:://////////////////////////////////////////////
/*
	
	
*/
//:://////////////////////////////////////////////
//:: Created By: Ornedan
//:: Created On: 28.02.2005
//:://////////////////////////////////////////////

#include "inc_utility"


//////////////////////////////////////////////////
/* Constant defintions                          */
//////////////////////////////////////////////////

// Player events
const int EVENT_ONACQUIREITEM            = 1;
const string NAME_ONACQUIREITEM          = "prc_event_array_onacquireitem";
const int EVENT_ONACTIVATEITEM           = 2;
const string NAME_ONACTIVATEITEM         = "prc_event_array_onactivateitem";
const int EVENT_ONCLIENTENTER            = 3;
const string NAME_ONCLIENTENTER          = "prc_event_array_oncliententer";
const int EVENT_ONCLIENTLEAVE            = 4;
const string NAME_ONCLIENTLEAVE          = "prc_event_array_onclientleave";
const int EVENT_ONCUTSCENEABORT          = 5;
const string NAME_ONCUTSCENEABORT        = "prc_event_array_oncutsceneabort";
const int EVENT_ONHEARTBEAT              = 6;
const string NAME_ONHEARTBEAT            = "prc_event_array_onheartbeat";
//const int EVENT_ONMODULELOAD          = 7;                              // Not included, since it is not possible for any scripts
//const string NAME_ONMODULELOAD        = "prc_event_array_onmoduleload"; // to make hook additions before this is run
//const int EVENT_ONMODULESTART         = 8;                              // PRC does not currently use have a script in this event.
//const string NAME_ONMODULESTART       = "prc_event_array_onmodulestart";
const int EVENT_ONPLAYERDEATH            = 9;
const string NAME_ONPLAYERDEATH          = "prc_event_array_onplayerdeath";
const int EVENT_ONPLAYERDYING            = 10;
const string NAME_ONPLAYERDYING          = "prc_event_array_onplayerdying";
const int EVENT_ONPLAYEREQUIPITEM        = 11;
const string NAME_ONPLAYEREQUIPITEM      = "prc_event_array_onplayerequipitem";
const int EVENT_ONPLAYERLEVELUP          = 12;
const string NAME_ONPLAYERLEVELUP        = "prc_event_array_onplayerlevelup";
const int EVENT_ONPLAYERREST_CANCELLED   = 13;
const string NAME_ONPLAYERREST_CANCELLED = "prc_event_array_onplayerrest";
const int EVENT_ONPLAYERREST_STARTED     = 14;
const string NAME_ONPLAYERREST_STARTED   = "prc_event_array_onplayerrest";
const int EVENT_ONPLAYERREST_FINISHED    = 15;
const string NAME_ONPLAYERREST_FINISHED  = "prc_event_array_onplayerrest";
const int EVENT_ONPLAYERUNEQUIPITEM      = 16;
const string NAME_ONPLAYERUNEQUIPITEM    = "prc_event_array_onplayerunequipitem";
const int EVENT_ONPLAYERRESPAWN          = 17;
const string NAME_ONPLAYERRESPAWN        = "prc_event_array_onplayerrespawn";
const int EVENT_ONUNAQUIREITEM           = 18;
const string NAME_ONUNAQUIREITEM         = "prc_event_array_onunaquireitem";
const int EVENT_ONUSERDEFINED            = 19;
const string NAME_ONUSERDEFINED          = "prc_event_array_onuserdefined";

// Other events
const int EVENT_ONHIT                 = 20;
const string NAME_ONHIT               = "prc_event_array_onhit";


const string PERMANENCY_SUFFIX = "_permanent";


//////////////////////////////////////////////////
/* Function prototypes                          */
//////////////////////////////////////////////////

// Adds the given script to be fired when the event next occurs.
// Unless bPermanent is set, the script will be removed from the
// list once it has fired
//
// bAllowDuplicate being set makes the function first check if a script with the same
// name is already queued for the event and avoids adding a duplicate. This
// will not remove duplicates already present, though.
void AddEventScript(object oPC, int nEventType, string sScript, int bPermanent = FALSE, int bAllowDuplicate = TRUE);

// Removes all instances of the given script from the event's hook.
// By default, this removes the script both from one-shot and permanent hooks,
// but the behavior can be set using bIgnorePermanency and bPermanent.
void RemoveEventScript(object oPC, int nEventType, string sScript, int bPermanent = FALSE, int bIgnorePermanency = FALSE);

// Removes all scripts in the given list.
void ClearEventScriptList(object oPC, int nEventType, int bPermanent = FALSE, int bIgnorePermanency = FALSE);

// Gets the first script hooked to the given event
string GetFirstEventScript(object oPC, int nEventType, int bPermanent);

// Gets the next script hooked to the given event.
// You should call GetFirstEventScript before calling this.
string GetNextEventScript(object oPC, int nEventType, int bPermanent);

// Executes all scripts in both the one-shot and permanent hooks and
// clears scripts off the one-shot hook afterwards.
// All the scripts will be executed on OBJECT_SELF, which in most
// cases would be the module
void ExecuteAllScriptsHookedToEvent(object oPC, int nEventType);

// Internal function. Returns the name matching the given integer constant
string EventTypeIdToName(int nEventType);

//////////////////////////////////////////////////
/* Function defintions                          */
//////////////////////////////////////////////////


void AddEventScript(object oPC, int nEventType, string sScript, int bPermanent = FALSE, int bAllowDuplicate = TRUE){
	string sArrayName = EventTypeIdToName(nEventType);
	
	// Abort if the event type wasn't valid
	if(sArrayName == "") return;
	
	
	sArrayName += bPermanent ? PERMANENCY_SUFFIX : "";
	
	// Create the array if necessary
	if(!persistant_array_exists(oPC, sArrayName)){
		persistant_array_create(oPC, sArrayName);
	}
	
	// Check for duplicates if necessary
	int bAdd = TRUE;
	if(bAllowDuplicate){
		int i = 0;
		for(; i <= persistant_array_get_size(oPC, sArrayName); i++){
			if(persistant_array_get_string(oPC, sArrayName, i) == sScript){
				bAdd = FALSE;
				break;
			}
		}
	}
	// Add to the array if needed
	if(bAdd)
		persistant_array_set_string(oPC, sArrayName, persistant_array_get_size(oPC, sArrayName), sScript);
}


void RemoveEventScript(object oPC, int nEventType, string sScript, int bPermanent = FALSE, int bIgnorePermanency = FALSE){
	string sArrayNameBase = EventTypeIdToName(nEventType),
	       sArrayName;
	
	// Abort if the event type wasn't valid
	if(sArrayNameBase == "") return;
	
	// Go through one-shot array
	if(!bPermanent || bIgnorePermanency){
		sArrayName = sArrayNameBase;
		// First, check if there is an array to look through at all
		if(persistant_array_exists(oPC, sArrayName)){
			int nMoveBackBy = 0;
			int i = 0;
			// Loop through the array elements
			for(; i <= persistant_array_get_size(oPC, sArrayName); i++){
				// See if we have an entry to remove
				if(persistant_array_get_string(oPC, sArrayName, i) == sScript){
					nMoveBackBy++;
				}
				// Move the entris in the array back by an amount great enough to overwrite entries containing sScript
				else if(nMoveBackBy){
					persistant_array_set_string(oPC, sArrayName, i - nMoveBackBy,
					                            persistant_array_get_string(oPC, sArrayName, i));
			}}
			// Shrink the array by the number of entries removed
			persistant_array_shrink(oPC, sArrayName, persistant_array_get_size(oPC, sArrayName) + 1 - nMoveBackBy);
	}}
	
	// Go through the permanent array
	if(bPermanent || bIgnorePermanency){
		sArrayName = sArrayNameBase + PERMANENCY_SUFFIX;
		// First, check if there is an array to look through at all
		if(persistant_array_exists(oPC, sArrayName)){
			int nMoveBackBy = 0;
			int i = 0;
			// Loop through the array elements
			for(; i <= persistant_array_get_size(oPC, sArrayName); i++){
				// See if we have an entry to remove
				if(persistant_array_get_string(oPC, sArrayName, i) == sScript){
					nMoveBackBy++;
				}
				// Move the entris in the array back by an amount great enough to overwrite entries containing sScript
				else if(nMoveBackBy){
					persistant_array_set_string(oPC, sArrayName, i - nMoveBackBy,
					                            persistant_array_get_string(oPC, sArrayName, i));
			}}
			// Shrink the array by the number of entries removed
			persistant_array_shrink(oPC, sArrayName, persistant_array_get_size(oPC, sArrayName) + 1 - nMoveBackBy);
	}}
}


void ClearEventScriptList(object oPC, int nEventType, int bPermanent = FALSE, int bIgnorePermanency = FALSE){
	string sArrayNameBase = EventTypeIdToName(nEventType),
	       sArrayName;
	
	// Abort if the event type wasn't valid
	if(sArrayNameBase == "") return;
	
	// Go through one-shot array
	if(!bPermanent || bIgnorePermanency){
		sArrayName = sArrayNameBase;
		// First, check if there is an array present
		if(persistant_array_exists(oPC, sArrayName)){
			// Shrink the array to 0
			persistant_array_shrink(oPC, sArrayName, 0);
	}}
	
	// Go through the permanent array
	if(bPermanent || bIgnorePermanency){
		sArrayName = sArrayNameBase + PERMANENCY_SUFFIX;
		// First, check if there is an array present
		if(persistant_array_exists(oPC, sArrayName)){
			// Shrink the array to 0
			persistant_array_shrink(oPC, sArrayName, 0);
	}}
}


string GetFirstEventScript(object oPC, int nEventType, int bPermanent){
	string sArrayName = EventTypeIdToName(nEventType);
	
	// Abort if the event type wasn't valid
	if(sArrayName == "") return "";
	
	sArrayName += bPermanent ? PERMANENCY_SUFFIX : "";
	
	SetLocalInt(oPC, sArrayName + "_index", 1);
	DelayCommand(0.0f, DeleteLocalInt(oPC, sArrayName + "_index"));
	
	return persistant_array_get_string(oPC, sArrayName, 0);
}


string GetNextEventScript(object oPC, int nEventType, int bPermanent){
	string sArrayName = EventTypeIdToName(nEventType);
	
	// Abort if the event type wasn't valid
	if(sArrayName == "") return "";
	
	sArrayName += bPermanent ? PERMANENCY_SUFFIX : "";
	
	int nIndex = GetLocalInt(oPC, sArrayName + "_index");
	if(nIndex)
		SetLocalInt(oPC, sArrayName + "_index", nIndex + 1);
	else{
		WriteTimestampedLogEntry("GetNextEventScript called without first calling GetFirstEventScript");
		return "";
	}
	
	return persistant_array_get_string(oPC, sArrayName, nIndex);
}


void ExecuteAllScriptsHookedToEvent(object oPC, int nEventType){
	// Loop through the scripts to be fired only once
	string sScript = GetFirstEventScript(oPC, nEventType, FALSE);
	while(sScript != ""){
		ExecuteScript(sScript, OBJECT_SELF);
		sScript = GetNextEventScript(oPC, nEventType, FALSE);
	}
	
	// Clear the one-shot script list
	ClearEventScriptList(oPC, nEventType, FALSE, FALSE);
	
	// Loop through the persistent scripts
	sScript = GetFirstEventScript(oPC, nEventType, TRUE);
	while(sScript != ""){
		ExecuteScript(sScript, OBJECT_SELF);
		sScript = GetNextEventScript(oPC, nEventType, TRUE);
	}
}


string EventTypeIdToName(int nEventType){
	switch(nEventType){
		case EVENT_ONACQUIREITEM:
			return NAME_ONACQUIREITEM;
		case EVENT_ONACTIVATEITEM:
			return NAME_ONACTIVATEITEM;
		case EVENT_ONCLIENTENTER:
			return NAME_ONCLIENTENTER;
		case EVENT_ONCLIENTLEAVE:
			return NAME_ONCLIENTLEAVE;
		case EVENT_ONCUTSCENEABORT:
			return NAME_ONCUTSCENEABORT;
		case EVENT_ONHEARTBEAT:
			return NAME_ONHEARTBEAT;
//		case EVENT_ONMODULELOAD:
//			return NAME_ONMODULELOAD;
//		case EVENT_ONMODULESTART:
//			return NAME_ONMODULESTART;
		case EVENT_ONPLAYERDEATH:
			return NAME_ONPLAYERDEATH;
		case EVENT_ONPLAYERDYING:
			return NAME_ONPLAYERDYING;
		case EVENT_ONPLAYEREQUIPITEM:
			return NAME_ONPLAYEREQUIPITEM;
		case EVENT_ONPLAYERLEVELUP:
			return NAME_ONPLAYERLEVELUP;
		case EVENT_ONPLAYERREST_CANCELLED:
			return NAME_ONPLAYERREST_CANCELLED;
		case EVENT_ONPLAYERREST_STARTED:
			return NAME_ONPLAYERREST_STARTED;
		case EVENT_ONPLAYERREST_FINISHED:
			return NAME_ONPLAYERREST_FINISHED;
		case EVENT_ONPLAYERUNEQUIPITEM:
			return NAME_ONPLAYERUNEQUIPITEM;
		case EVENT_ONPLAYERRESPAWN:
			return NAME_ONPLAYERRESPAWN;
		case EVENT_ONUNAQUIREITEM:
			return NAME_ONUNAQUIREITEM;
		case EVENT_ONUSERDEFINED:
			return NAME_ONUSERDEFINED;
		case EVENT_ONHIT:
			return NAME_ONHIT;
		
		default:
			WriteTimestampedLogEntry("Unknown event id passed to EventTypeIdToName: " + IntToString(nEventType));
	}
	
	return "";
}