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

// Module events

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

// This has special handling. See prc_onuserdef.nss
const int EVENT_ONUSERDEFINED            = 19;
const string NAME_ONUSERDEFINED          = "prc_event_array_onuserdefined";


// Other events

const int EVENT_ONHIT                 = 20;
const string NAME_ONHIT               = "prc_event_array_onhit";
const int EVENT_ONSPELLCAST           = 21;
const string NAME_ONSPELLCAST         = "prc_event_array_onspellcast";
const int EVENT_ONPOWERMANIFEST       = 22;
const string NAME_ONPOWERMANIFEST     = "prc_event_array_onpowermanifest";


// NPC events

const int EVENT_NPC_ONBLOCKED            = 23;
const string NAME_NPC_ONBLOCKED          = "prc_event_array_npc_onblocked";
const int EVENT_NPC_ONCOMBATROUNDEND     = 24;
const string NAME_NPC_ONCOMBATROUNDEND   = "prc_event_array_npc_oncombatroundend";
const int EVENT_NPC_ONCONVERSATION       = 25;
const string NAME_NPC_ONCONVERSATION     = "prc_event_array_npc_onconversation";
const int EVENT_NPC_ONDAMAGED            = 26;
const string NAME_NPC_ONDAMAGED          = "prc_event_array_npc_ondamaged";
const int EVENT_NPC_ONDEATH              = 27;
const string NAME_NPC_ONDEATH            = "prc_event_array_npc_ondeath";
const int EVENT_NPC_ONDISTURBED          = 28;
const string NAME_NPC_ONDISTURBED        = "prc_event_array_npc_ondisturbed";
const int EVENT_NPC_ONHEARTBEAT          = 29;
const string NAME_NPC_ONHEARTBEAT        = "prc_event_array_npc_onheartbeat";
const int EVENT_NPC_ONPERCEPTION         = 30;
const string NAME_NPC_ONPERCEPTION       = "prc_event_array_npc_onperception";
const int EVENT_NPC_ONPHYSICALATTACKED   = 31;
const string NAME_NPC_ONPHYSICALATTACKED = "prc_event_array_npc_onphysicalattacked";
const int EVENT_NPC_ONRESTED             = 32;
const string NAME_NPC_ONRESTED           = "prc_event_array_npc_onrested";
const int EVENT_NPC_ONSPELLCASTAT        = 34;
const string NAME_NPC_ONSPELLCASTAT      = "prc_event_array_npc_onspellcastat";


// Unused events
//const int EVENT_ONMODULELOAD          = 7;                              // Not included, since anything that would be hooked to this event
//const string NAME_ONMODULELOAD        = "prc_event_array_onmoduleload"; // should be directly in the eventscript anyway.
//const int EVENT_NPC_ONSPAWN         = 33;                           // No way to add script to the hook for a creature before this fires
//const string NAME_NPC_ONSPAWN       = "prc_event_array_npc_onspawn";


/* Callback hooks */

const int CALLBACKHOOK_UNARMED           = 100;
const string NAME_CALLBACKHOOK_UNARMED   = "prc_callbackhook_array_unarmed";



const string PERMANENCY_SUFFIX = "_permanent";


//////////////////////////////////////////////////
/* Function prototypes                          */
//////////////////////////////////////////////////

// Adds the given script to be fired when the event next occurs for the given PC.
//
// oPC        The object that the script is to be fired for. Usually a PC.
// nEvent     One of the EVENT_* constants defined in "inc_eventhook"
// sScript    The script to be fired on the event
// bPermanent Unless this is set, the script will be only fired once, after which it
//            is removed from the list
//
// bAllowDuplicate This being set makes the function first check if a script with
//                 the same name is already queued for the event and avoids adding a
//                 duplicate. This will not remove duplicates already present, though.
void AddEventScript(object oPC, int nEvent, string sScript, int bPermanent = FALSE, int bAllowDuplicate = TRUE);

// Removes all instances of the given script from the event's hook.
//
// oPC        The object that the script is to be removed from the list for.
// nEvent     One of the EVENT_* constants defined in "inc_eventhook"
// sScript    The script to be removed from the event
//
// bPermanent Depending on the state of this switch, the script is either removed
//            from the one-shot or permanent list.
//
// bIgnorePermanency Setting this to true will make the function clear the script from
//                   both one-shot and permanent lists, regardless of the value of bPermanent
void RemoveEventScript(object oPC, int nEvent, string sScript, int bPermanent = FALSE, int bIgnorePermanency = FALSE);

// Removes all scripts in the given list.
//
// oPC        The object to clear script list for.
// nEvent     One of the EVENT_* constants defined in "inc_eventhook"
//
// bPermanent Depending on the state of this switch, the scripts are either removed
//            from the one-shot or permanent list.
//
// bIgnorePermanency Setting this to true will make the function clear both one-shot and
//                   permanent lists, regardless of the value of bPermanent
void ClearEventScriptList(object oPC, int nEvent, int bPermanent = FALSE, int bIgnorePermanency = FALSE);

// Gets the first script hooked to the given event. This must be called before any calls
// to GetNextEventScript() are made.
// Returns the name of the first script stored, or "", if one was not found.
//
// oPC        The object to get a script for.
// nEvent     One of the EVENT_* constants defined in "inc_eventhook"
// bPermanent Which list to get the first script from.
string GetFirstEventScript(object oPC, int nEvent, int bPermanent);

// Gets the next script hooked to the given event. You should call GetFirstEventScript
// before calling this.
// Returns the name of the next script in the list, or "" if there are no more scripts
// left. Also returns "" if GetFirstEventScript hasn't been called.
//
// oPC        The object to get a script for.
// nEvent     One of the EVENT_* constants defined in "inc_eventhook"
// bPermanent Which list to get the first script from.
string GetNextEventScript(object oPC, int nEvent, int bPermanent);

// Executes all scripts in both the one-shot and permanent hooks and
// clears scripts off the one-shot hook afterwards.
// All the scripts will be ExecuteScripted on OBJECT_SELF, so they will
// behave as if being in the script slot for that event.
//
// It is recommended this be used instead of manually going through
// the script lists with Get(First|Next)EventScript.
//
// oPC        The object to execute listed scripts for.
// nEvent     One of the EVENT_* constants defined in "inc_eventhook"
void ExecuteAllScriptsHookedToEvent(object oPC, int nEvent);

// Internal function. Returns the name matching the given integer constant
string EventTypeIdToName(int nEvent);

//////////////////////////////////////////////////
/* Function defintions                          */
//////////////////////////////////////////////////


void AddEventScript(object oPC, int nEvent, string sScript, int bPermanent = FALSE, int bAllowDuplicate = TRUE){
	// If an eventhook is running, place the call into queue
	if(GetLocalInt(GetModule(), "prc_eventhook_running")){
		int nQueue = GetLocalInt(GetModule(), "prc_eventhook_pending_queue") + 1;
		SetLocalInt(GetModule(), "prc_eventhook_pending_queue", nQueue);
		SetLocalInt(GetModule(), "prc_eventhook_pending_queue_" + IntToString(nQueue) + "_operation", 1);
		SetLocalObject(GetModule(), "prc_eventhook_pending_queue_" + IntToString(nQueue) + "_target", oPC);
		SetLocalInt(GetModule(), "prc_eventhook_pending_queue_" + IntToString(nQueue) + "_event", nEvent);
		SetLocalString(GetModule(), "prc_eventhook_pending_queue_" + IntToString(nQueue) + "_script", sScript);
		SetLocalInt(GetModule(), "prc_eventhook_pending_queue_" + IntToString(nQueue) + "_flags", ((!!bPermanent) << 1) | (!!bAllowDuplicate));
		return;
	}
		
	string sArrayName = EventTypeIdToName(nEvent);
	
	// Abort if the object given / event isn't valid 
	if(!GetIsObjectValid(oPC) || sArrayName == "") return;
	
	
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


void RemoveEventScript(object oPC, int nEvent, string sScript, int bPermanent = FALSE, int bIgnorePermanency = FALSE){
	// If an eventhook is running, place the call into queue
	if(GetLocalInt(GetModule(), "prc_eventhook_running")){
		int nQueue = GetLocalInt(GetModule(), "prc_eventhook_pending_queue") + 1;
		SetLocalInt(GetModule(), "prc_eventhook_pending_queue", nQueue);
		SetLocalInt(GetModule(), "prc_eventhook_pending_queue_" + IntToString(nQueue) + "_operation", 2);
		SetLocalObject(GetModule(), "prc_eventhook_pending_queue_" + IntToString(nQueue) + "_target", oPC);
		SetLocalInt(GetModule(), "prc_eventhook_pending_queue_" + IntToString(nQueue) + "_event", nEvent);
		SetLocalString(GetModule(), "prc_eventhook_pending_queue_" + IntToString(nQueue) + "_script", sScript);
		SetLocalInt(GetModule(), "prc_eventhook_pending_queue_" + IntToString(nQueue) + "_flags", ((!!bPermanent) << 1) | (!!bIgnorePermanency));
		return;
	}
	
	string sArrayNameBase = EventTypeIdToName(nEvent),
	       sArrayName;
	
	// Abort if the object given / event isn't valid 
	if(!GetIsObjectValid(oPC) || sArrayNameBase == "") return;
	
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


void ClearEventScriptList(object oPC, int nEvent, int bPermanent = FALSE, int bIgnorePermanency = FALSE){
	// If an eventhook is running, place the call into queue
	if(GetLocalInt(GetModule(), "prc_eventhook_running")){
		int nQueue = GetLocalInt(GetModule(), "prc_eventhook_pending_queue") + 1;
		SetLocalInt(GetModule(), "prc_eventhook_pending_queue", nQueue);
		SetLocalInt(GetModule(), "prc_eventhook_pending_queue_" + IntToString(nQueue) + "_operation", 3);
		SetLocalObject(GetModule(), "prc_eventhook_pending_queue_" + IntToString(nQueue) + "_target", oPC);
		SetLocalInt(GetModule(), "prc_eventhook_pending_queue_" + IntToString(nQueue) + "_event", nEvent);
		SetLocalInt(GetModule(), "prc_eventhook_pending_queue_" + IntToString(nQueue) + "_flags", ((!!bPermanent) << 1) | (!!bIgnorePermanency));
		return;
	}
	
	string sArrayNameBase = EventTypeIdToName(nEvent),
	       sArrayName;
	
	// Abort if the object given / event isn't valid 
	if(!GetIsObjectValid(oPC) || sArrayNameBase == "") return;
	
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


string GetFirstEventScript(object oPC, int nEvent, int bPermanent){
	string sArrayName = EventTypeIdToName(nEvent);
	
	// Abort if the object given / event isn't valid 
	if(!GetIsObjectValid(oPC) || sArrayName == "") return "";
	
	sArrayName += bPermanent ? PERMANENCY_SUFFIX : "";
	
	SetLocalInt(oPC, sArrayName + "_index", 1);
	DelayCommand(0.0f, DeleteLocalInt(oPC, sArrayName + "_index"));
	
	return persistant_array_get_string(oPC, sArrayName, 0);
}


string GetNextEventScript(object oPC, int nEvent, int bPermanent){
	string sArrayName = GetLocalInt(GetModule(), "prc_eventhook_running") ?
	                     GetLocalString(GetModule(), "prc_eventhook_running_sArrayName") :
	                     EventTypeIdToName(nEvent);
	
	// Abort if the object given / event isn't valid 
	if(!GetIsObjectValid(oPC) || sArrayName == "") return "";
	
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


void ExecuteAllScriptsHookedToEvent(object oPC, int nEvent){
	// Mark that an eventhook is being run, so calls to modify the
	// scripts listed are delayd until the eventhook is done.
	SetLocalInt(GetModule(), "prc_eventhook_running", TRUE);
	SetLocalString(GetModule(), "prc_eventhook_running_sArrayName", EventTypeIdToName(nEvent));
	
	// Loop through the scripts to be fired only once
	string sScript = GetFirstEventScript(oPC, nEvent, FALSE);
	while(sScript != ""){
		ExecuteScript(sScript, OBJECT_SELF);
		sScript = GetNextEventScript(oPC, nEvent, FALSE);
	}
	
	// Clear the one-shot script list
	ClearEventScriptList(oPC, nEvent, FALSE, FALSE);
	
	// Loop through the persistent scripts
	sScript = GetFirstEventScript(oPC, nEvent, TRUE);
	while(sScript != ""){
		ExecuteScript(sScript, OBJECT_SELF);
		sScript = GetNextEventScript(oPC, nEvent, TRUE);
	}
	
	// Remove the lock on modifying the script lists
	DeleteLocalInt(GetModule(), "prc_eventhook_running");
	DeleteLocalString(GetModule(), "prc_eventhook_running_sArrayName");
	
	// Run the delayed commands
	int nQueued = GetLocalInt(GetModule(), "prc_eventhook_pending_queue"),
	nOperation, nFlags, i;
	object oTarget;
	for(i = 1; i <= nQueued; i++){
		nOperation = GetLocalInt(GetModule(), "prc_eventhook_pending_queue_" + IntToString(i) + "_operation");
		oTarget = GetLocalObject(GetModule(), "prc_eventhook_pending_queue_" + IntToString(i) + "_target");
		nEvent     = GetLocalInt(GetModule(), "prc_eventhook_pending_queue_" + IntToString(i) + "_event");
		sScript = GetLocalString(GetModule(), "prc_eventhook_pending_queue_" + IntToString(i) + "_script");
		nFlags     = GetLocalInt(GetModule(), "prc_eventhook_pending_queue_" + IntToString(i) + "_flags");
	
		switch(nOperation){
			case 1:
				AddEventScript(oTarget, nEvent, sScript, nFlags >>> 1, nFlags & 1);
				break;
			case 2:
				RemoveEventScript(oTarget, nEvent, sScript, nFlags >>> 1, nFlags & 1);
				break;
			case 3:
				ClearEventScriptList(oTarget, nEvent, nFlags >>> 1, nFlags & 1);
				break;
	
			default:
				WriteTimestampedLogEntry("Invalid value in delayed eventhook manipulation operation queue");
		}
		
		DeleteLocalInt(GetModule(), "prc_eventhook_pending_queue_" + IntToString(i) + "_operation");
		DeleteLocalObject(GetModule(), "prc_eventhook_pending_queue_" + IntToString(i) + "_target");
		DeleteLocalInt(GetModule(), "prc_eventhook_pending_queue_" + IntToString(i) + "_event");
		DeleteLocalString(GetModule(), "prc_eventhook_pending_queue_" + IntToString(i) + "_script");
		DeleteLocalInt(GetModule(), "prc_eventhook_pending_queue_" + IntToString(i) + "_flags");
	}
	
	DeleteLocalInt(GetModule(), "prc_eventhook_pending_queue");
	
}


string EventTypeIdToName(int nEvent){
	switch(nEvent){
	    // Module events
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
		
		// NPC events
		case EVENT_NPC_ONBLOCKED:
			return NAME_NPC_ONBLOCKED;
		case EVENT_NPC_ONCOMBATROUNDEND:
			return NAME_NPC_ONCOMBATROUNDEND;
		case EVENT_NPC_ONCONVERSATION:
			return NAME_NPC_ONCONVERSATION;
		case EVENT_NPC_ONDAMAGED:
			return NAME_NPC_ONDAMAGED;
		case EVENT_NPC_ONDEATH:
			return NAME_NPC_ONDEATH;
		case EVENT_NPC_ONDISTURBED:
			return NAME_NPC_ONDISTURBED;
		case EVENT_NPC_ONHEARTBEAT:
			return NAME_NPC_ONHEARTBEAT;
		case EVENT_NPC_ONPERCEPTION:
			return NAME_NPC_ONPERCEPTION;
		case EVENT_NPC_ONPHYSICALATTACKED:
			return NAME_NPC_ONPHYSICALATTACKED;
		case EVENT_NPC_ONRESTED:
			return NAME_NPC_ONRESTED;
//		case EVENT_NPC_ONSPAWN:
//			return NAME_NPC_ONSPAWN;
		case EVENT_NPC_ONSPELLCASTAT:
			return NAME_NPC_ONSPELLCASTAT;
		
		// Other events
		case EVENT_ONHIT:
			return NAME_ONHIT;
		case EVENT_ONSPELLCAST:
			return NAME_ONSPELLCAST;
		case EVENT_ONPOWERMANIFEST:
			return NAME_ONPOWERMANIFEST;

        // Callbackhooks
        case CALLBACKHOOK_UNARMED:
			return NAME_CALLBACKHOOK_UNARMED;

		default:
			WriteTimestampedLogEntry("Unknown event id passed to EventTypeIdToName: " + IntToString(nEvent));
	}
	
	return "";
}