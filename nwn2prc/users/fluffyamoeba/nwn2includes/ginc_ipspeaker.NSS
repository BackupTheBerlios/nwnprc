// ginc_ipspeaker
/*
   Various functions for IPoint Speaker pending conversations

   Used in gp_ipspeaker_hb, gg_death_talk
*/
// BMA-OEI 1/23/06
// BMA-OEI 2/8/06 - Added bDeleteSelf, bFadeOut
// DBR 2/09/06 - Temporarily removed return on not finding a speaker tag to prevent drop-outs
// BMA-OEI 2/14/06 - removed fade out
// BMA-OEI 2/15/06 - set plot false on delete self
// BMA-OEI 3/6/06 - added IPS_RESREF, updated prototypes, revised comments, added CombatCutsceneSetup
// BMA-OEI 3/7/06 - modified CombatCutsceneCleanUp to use IPoint Cleaner
// BMA-OEI 3/8/06 - minimum distance for JumpPartyToSpeaker()
// BMA-OEI 3/14/06 - added CreateIPSpeaker()
// BMA-OEI 4/13/06 - added fDelay param to CreateIPSpeaker() and ResetIPSpeaker()

#include "ginc_cutscene"	
#include "ginc_debug"

// ***** CONSTANTS *****

const string IPS_RESREF			= "plc_ipspeaker";	
	
const string IPS_SPEAKER_TAG 	= "__sSpeakerTag";
const string IPS_CONVERSATION 	= "__sConversation";

const string IPS_PENDING 		= "__bPendingConv";
const string IPS_DELETE_SELF	= "__bDeleteSelf";

const string IPS_LOCK_VAR		= "__bIPSLocked";

// ***** PROTOTYPES *****	

// Create and setup IPSpeaker for pending conversation
// - sSpeakerTag: Non-hostile owner to assign conversation
// - sConversation: Conversation to use
// - lLoc: Location to create IPSpeaker conversation manager
// - fDelay: Delay before first conversation attempt
object CreateIPSpeaker(string sSpeakerTag, string sConversation, location lLoc, float fDelay=0.0f);
	
// Setup IPoint Speaker for pending conversation
// - oIPSpeaker: IPSpeaker object ID
// - sSpeakerTag: Non-hostile owner to assign conversation
// - sConversation: Conversation to use
// - bPending: Flags that a conversation is pending for conversation attempts
// - bDeleteSelf: Flag to Delete IPSpeaker after conversation is fired
// - fDelay: Delay before first conversation attempt
void ResetIPSpeaker(object oIPSpeaker, string sSpeakerTag, string sConversation, int bPending=TRUE, int bDeleteSelf=FALSE, float fDelay=0.0f);

// Check if AttemptIPSConversation() has been recently executed
int GetIsIPSLocked();

// Set IPS_LOCK_VAR local var to avoid synchronous AttemptIPSConversation() execution
void SetIPSLocked(int bLocked);

// Attempt pending conversation if conditions are met
void AttemptIPSConversation(object oIPSpeaker=OBJECT_SELF);

// Check if a pending conversation is ready to play
int GetIsIPSConversationPending(object oIPSpeaker=OBJECT_SELF);

// Set IPS_PENDING local var to flag a pending conversation as ready to play
void SetIPSConversationPending(object oIPSpeaker=OBJECT_SELF, int bPending=TRUE);

// Check if oObject is safe to conversate (in area, not in conversation)
int GetIsIPSConversible(object oObject, object oIPSpeaker=OBJECT_SELF);


// ***** DEFINITIONS *****

// Create and setup IPSpeaker for pending conversation
object CreateIPSpeaker(string sSpeakerTag, string sConversation, location lLoc, float fDelay=0.0f)
{
	//PrettyDebug("CreateIPSpeaker: " + sSpeakerTag + sConversation);
	
	object oIPS = CreateObject(OBJECT_TYPE_PLACEABLE, IPS_RESREF, lLoc);
	
	if ( GetIsObjectValid(oIPS) == FALSE ) PrettyError("CreateIPSpeaker: oIPS is not valid!");

	AssignCommand(oIPS, ResetIPSpeaker(oIPS, sSpeakerTag, sConversation, TRUE, TRUE, fDelay));

	return ( oIPS );
}
	

// Setup IPoint Speaker for pending conversation
void ResetIPSpeaker(object oIPSpeaker, string sSpeakerTag, string sConversation, int bPending=TRUE, int bDeleteSelf=FALSE, float fDelay=0.0f)
{
	//PrettyMessage("ResetIPSpeaker: !");
	SetLocalString(oIPSpeaker, IPS_SPEAKER_TAG, sSpeakerTag);
	SetLocalString(oIPSpeaker, IPS_CONVERSATION, sConversation);
	SetLocalInt(oIPSpeaker, IPS_PENDING, bPending);
	SetLocalInt(oIPSpeaker, IPS_DELETE_SELF, bDeleteSelf);
	
	DelayCommand(fDelay, AttemptIPSConversation());
	DelayCommand(3.0f, AttemptIPSConversation());
}

// Heartbeat handler for gp_ipspeaker_hb
void IPSpeakerHeartbeat()
{
	AttemptIPSConversation();
	DelayCommand(1.5f, AttemptIPSConversation());
	DelayCommand(3.0f, AttemptIPSConversation());
}

// Check if AttemptIPSConversation() has been recently executed
int GetIsIPSLocked()
{
	return GetGlobalInt(IPS_LOCK_VAR);
}	

// Set IPS_LOCK_VAR local var to avoid synchronous AttemptIPSConversation() execution
void SetIPSLocked(int bLocked)
{
	SetGlobalInt(IPS_LOCK_VAR, bLocked);
}

// Attempt pending conversation if conditions are met
void AttemptIPSConversation(object oIPSpeaker=OBJECT_SELF)
{
	//PrettyMessage("AttemptIPSConversation: checking...");

	if (GetIsIPSLocked() == 1) 
	{
		//PrettyError("IPS is locked! Unlocking in 0.5fs");
		DelayCommand(0.5f, SetIPSLocked(0));
		return;
	}

	//PrettyMessage(GetLocalString(oIPSpeaker, IPS_SPEAKER_TAG));
	//PrettyMessage(GetLocalString(oIPSpeaker, IPS_CONVERSATION));
	//PrettyMessage(IntToString(GetLocalInt(oIPSpeaker, IPS_PENDING)));
	//PrettyMessage(IntToString(GetLocalInt(oIPSpeaker, IPS_DELETE_SELF)));

	// Lock to avoid near future execution
	SetIPSLocked(1);
	
	// If a conversation is pending
	if (GetIsIPSConversationPending() == TRUE)
	{
		//PrettyDebug( "AttemptIPSConversation: IPS conversation is pending..." );
		object oPC = GetFactionLeader(GetFirstPC());

		string sSpeakerTag = GetLocalString(oIPSpeaker, IPS_SPEAKER_TAG);
		if (sSpeakerTag == "")
		{
			PrettyError("ERROR: gp_ipspeaker_hb: sSpeakerTag is not set. Please bug this.");
		}
		
		object oSpeaker = GetNearestObjectByTag(sSpeakerTag, oIPSpeaker);

		// DEBUG
		if ( GetIsObjectValid( oPC ) == FALSE )
			PrettyError( "AttemptIPSConversation: oPC is not valid!" );

		if ( GetIsObjectValid( oSpeaker ) == FALSE )
			PrettyError( "AttemptIPSConversation: oSpeaker is not valid!" );

		
		// Check if conditions are safe
		if ((GetIsIPSConversible(oPC, oIPSpeaker) == TRUE) && (GetIsIPSConversible(oSpeaker, oIPSpeaker) == TRUE))
		{
			//PrettyMessage("Participants ready...");
			// Stop the IPSpeaker
			SetIPSConversationPending(oIPSpeaker, FALSE);

			string sConversation = GetLocalString(oIPSpeaker, IPS_CONVERSATION);
			if (sConversation == "")
			{
				PrettyError("WARNING: gp_ipspeaker_hb: sConversation is not set. Attempting default conversation. Conversation may be missing.");
			}

			// Plot party, hide hostiles, save AI
			CombatCutsceneSetup(oPC);

			// Revive and remove bad effects
			MakeConversable(oPC, TRUE);
			MakeConversable(oSpeaker, FALSE);

			// Begin conversation
			ClearPartyActions(oPC, TRUE);

			//if (GetDistanceBetween(oPC, oSpeaker) > 20.0f)
			//{
			//	AssignCommand(oPC, JumpPartyToSpeaker(oPC, oSpeaker));
			//}
			//else
			//{
				//AssignCommand(oPC, JumpPartyToSpeaker(oPC, oPC));
			//}

			//PrettyDebug("AttemptIPSpeaker: Conversation starting...");
			AssignCommand(oSpeaker, ClearAllActions(TRUE));
			AssignCommand(oSpeaker, ActionStartConversation(oPC, sConversation, FALSE, FALSE, TRUE, FALSE));

			// Clean up when conversation ends
			//object oIPCleaner = CreateObject(OBJECT_TYPE_PLACEABLE, IPC_RESREF, GetLocation(oPC));
			//AssignCommand(oIPCleaner, QueueCombatCutsceneCleanUp());

			int bDeleteSelf = GetLocalInt(oIPSpeaker, IPS_DELETE_SELF);
			if (bDeleteSelf == TRUE)
			{
				SetPlotFlag(oIPSpeaker, FALSE);
				DelayCommand(2.0f, DestroyObject(oIPSpeaker));
			}
		}
	}
	
	DelayCommand(0.5f, SetIPSLocked(0));
}

// Check if a pending conversation is ready to play
int GetIsIPSConversationPending(object oIPSpeaker=OBJECT_SELF)
{
	return GetLocalInt(oIPSpeaker, IPS_PENDING);
}

// Set IPS_PENDING local var to flag a pending conversation as ready to play
void SetIPSConversationPending(object oIPSpeaker=OBJECT_SELF, int bPending=TRUE)
{
	SetLocalInt(oIPSpeaker, IPS_PENDING, bPending);
}

// Check if oObject is safe to conversate (valid, in area, not in conversation)
// IPS conversation can start despite death or combat state
int GetIsIPSConversible(object oObject, object oIPSpeaker=OBJECT_SELF)
{
	// Verify oObject is valid
	if (GetIsObjectValid(oObject) == FALSE)
	{
		PrettyError( "GetIsIPSConversible: oObject is not valid" );
		return (FALSE);
	}

	// Verify oObject and oIPSpeaker are in the same area
	if (GetArea(oIPSpeaker) != GetArea(oObject)) 
	{
		PrettyError( "GetIsIPSConversible: " + GetName( oObject ) + " is not in IPS' area" );
		return (FALSE);
	}

	// Verify oObject (or PC party) is not already in a conversation	
	if ((GetIsPC(oObject) == TRUE) && (GetIsPartyInConversation(oObject) == TRUE))
	{
		PrettyError( "GetIsIPSConversible: oObject or a party member is already in a conversation" );
		return (FALSE);
	}
	else if (IsInConversation(oObject) == TRUE)
	{
		PrettyError( "GetIsIPSConversible: oObject is in a conversation" );
		return (FALSE);
	}

	// Solid gold!
	return (TRUE);
}