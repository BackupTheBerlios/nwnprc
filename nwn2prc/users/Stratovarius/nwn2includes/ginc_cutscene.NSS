// ginc_cutscene
// 
// various cutscene functions
//
// EPF 4/8/05
// EPF 11/28/05 - added fSafeDelay params for the fading functions
// BMA-OEI 1/13/06 - added MakeConversable()
// BMA-OEI 1/23/06 - added FireAndForgetConversation()
// ChazM 2/7/06 - added struct CutsceneInfo, GetCutsceneData(), ThisCutsceneToPlay()
// BMA-OEI 2/7/06 - added GetIsCutscenePending(), ResetCutsceneInfo(), SetupCutsceneInfo()
// BMA-OEI 2/27/06 - added PrepareForConversation()
// BMA-OEI 3/02/06 - added GetIsPartyInConversation(), SetPartyPlotFlag(), ClearPartyActions(), Hide/ShowHostileCreatures(), JumpPartyToSpeaker()
// BMA-OEI 3/6/06 - removed PrepareForConversation(), CombatCutsceneSetup() functions
// BMA-OEI 3/7/06 - moved CombatCutsceneCleanUp to local IPoint Cleaner
// BMA-OEI 3/7/06 - added Save/LoadStandGroundState()
// BMA-OEI 4/3/06 - GetIsEffectTypeBad() - added turned, dominated, cutscene paralyze, cutscene ghost, cutscene immobilize, frightened
// BMA-OEI 4/10/06 - HideHostileCreatures() type check creatures and AoEs
// BMA-OEI 8/15/06 - Added SetCommandable(TRUE) to MakeConversable()

#include "nw_i0_generic"
#include "nw_i0_plot"

//void main(){}

// *** CONSTANTS AND STRUCTS ***

// Area Client Enter cutscene struct
struct CutsceneInfo
{
	object oSpeaker;		// Speaker of conversation to play
	string sDialog;			// Dialog of conversation to play
	
	int bCutscenePending;	// Cutscene is ready to play
	int nCutsceneInfoCount;	// Track current cutscene being checked
};

const string COMBAT_LOCK_VAR 	= "__bCombatCutsceneLocked";	
		
const string TEMP_HOSTILE_VAR 	= "__bTempHiddenForCutscene";

const string STAND_GROUND_VAR 	= "__bStandGroundValue";

const string IPC_RESREF			= "plc_ipcleaner";
const string IPC_DELETE_SELF	= "__bDeleteSelf";

// *** FUNCTION PROTOTYPES ***

// SetCutsceneModeParty()
//
// Sets the cutscene mode of oPC's party to be true, thereby freezing all PCs and associates in the party.
// if bInCutscene is FALSE, the function returns oPC's party to their normal unfrozen states.
// NOTE: internally calls FreezeAllAssociates().
void SetCutsceneModeParty(object oPC, int bInCutscene = TRUE);

// FadeToBlackParty()
//
// Fades out for all PCs in oPC's party.  Fades in (from black) if bFadeOut is FALSE.
// fFadeSpeed is the time in seconds to complete the fade
// fSafeDelay is the time after which the game will automatically fade in, in the event
// that the scripter forgot to fade in manually.
// nColor is for the color the screen should fade to.
void FadeToBlackParty(object oPC, int bFadeOut = TRUE, float fFadeSpeed = 1.f, float fSafeDelay = 15.f, int nColor = 0);

// SetCutsceneModeAllPCs()
//
// Sets the cutscene mode of all PCs in the module to the value of bInCutscene.
void SetCutsceneModeAllPCs(int bInCutscene = TRUE);

// FadeToBlackAllPCs()
//
// Fades out for all PCs.  Fades in (from black) if bFadeOut is FALSE.
// fFadeSpeed is the time in seconds to complete the fade
// fSafeDelay is the time after which the game will automatically fade in, in the event
// that the scripter forgot to fade in manually.
void FadeToBlackAllPCs(int bFadeOut = TRUE, float fFadeSpeed = 1.f, float fSafeDelay = 15.f);

// FreezeAllAssociates()
// 
// Calls FreezeAssociate for all NPCs in oPC's party, including familiars, henchmen, etc.
// if bValid is FALSE, it will unfreeze the associates.
void FreezeAllAssociates(object oPC, int bValid = TRUE);

// FreezeAssociate()
// 
// Sets associate state to STAND GROUND, which effectively incapacitates them until their state
// is changed again.
// oPC is the PC whose associates we're freezing
// nNth is the nth instance of that associate type (nth henchman, for instance).
// if bValid is FALSE, it will unfreeze the associates.
void FreezeAssociate(object oPC, int bValid, int nType, int nNth = 1);

// Make oCreature (or faction) conversable (remove bad effects, revive, clear actions)
void MakeConversable(object oCreature=OBJECT_SELF, int bFaction=FALSE);

// Call appropriate MakeConversable() to prepare for conversation
//void PrepareForConversation(object oCreature=OBJECT_SELF);

// Prepare and fire conversation immediately
void FireAndForgetConversation(object oSpeaker, object oPC, string sDialog);

// Determine if a cutscene is waiting to be played	
int GetIsCutscenePending(struct CutsceneInfo stCI);
	
// Initialize CutsceneInfo struct
struct CutsceneInfo ResetCutsceneInfo(struct CutsceneInfo stCI);

// Return CutsceneInfo struct of pending cutscene
struct CutsceneInfo SetupCutsceneInfo(struct CutsceneInfo stCI, string sSpeakerTag, object oPC, string sDialog, int bCutsceneCondition);

// Check if any member of oPC's party is in conversation
int GetIsPartyInConversation(object oPC);

// Set oPC's party's Plot Flag
void SetPartyPlotFlag(object oPC, int bPlotFlag);

// Clear all oPC's party's actions
void ClearPartyActions(object oPC, int bClearCombatState=FALSE);

// ScriptHide all creatures hostile to oPC in area
void HideHostileCreatures(object oPC, object oArea=OBJECT_INVALID);

// Remove effect cutscene paralyze on oCreature
void RemoveEffectCutsceneParalyze(object oCreature);

// Show all hostile creatures hidden with HideHostileCreatures()
void ShowHostileCreatures(object oPC, object oArea=OBJECT_INVALID);

// Jump PC party to oSpeaker
void JumpPartyToSpeaker(object oPC, object oSpeaker);

// Save PC party's AI states
void SavePartyAIState(object oPC);

// Load PC party's AI states
void LoadPartyAIState(object oPC);

// Lock from CombatCutsceneCleanUp until conversation has time to begin
void SetCombatCutsceneLocked(int bLocked);

// Check if CombatCutsceneSetup has recently been executed
int GetIsCombatCutsceneLocked();

// Temp-Lock, save AI states, hide hostile creatures, set party Plot Flag
void CombatCutsceneSetup(object oPC);

// load AI states, show hostile creatures, set party Plot Flag
void CombatCutsceneCleanUp(object oPC, object oArea=OBJECT_INVALID);

// Check if we should clean up a CombatCutscene (conversation has ended)
void AttemptCombatCutsceneCleanUp();

// Re-queue AttemptCombatCutsceneCleanUp()
void QueueCombatCutsceneCleanUp();


// *** IMPLEMENTATIONS ***

void SetCutsceneModeParty(object oPC, int bInCutscene)
{
	object oPCFacMem = GetFirstFactionMember(oPC);
	
	//iterate through all PCs in oPC's faction, freeze their associates.
	while(GetIsObjectValid(oPCFacMem))
	{
		SetCutsceneMode(oPCFacMem, bInCutscene);
		FreezeAllAssociates(oPCFacMem, bInCutscene);
		oPCFacMem = GetNextFactionMember(oPC);
	}
}

void FadeToBlackParty(object oPC, int bFadeOut, float fFadeSpeed, float fSafeDelay, int nColor)
{
	object oPCFacMem = GetFirstFactionMember(oPC);	
	while(GetIsObjectValid(oPCFacMem))
    {
        if(bFadeOut)
		{
			FadeToBlack(oPCFacMem, fFadeSpeed, fSafeDelay, nColor);
		}
		else 
		{
			FadeFromBlack(oPCFacMem, fFadeSpeed);
		}
        oPCFacMem = GetNextFactionMember(oPC);
    } 
}

void SetCutsceneModeAllPCs(int bInCutscene)
{
	object oPC = GetFirstPC();
	
	while(GetIsObjectValid(oPC))
    {
		AssignCommand(oPC, ClearAllActions(TRUE));
        SetCutsceneMode(oPC, bInCutscene);
        oPC = GetNextPC();
    } 
}

void FadeToBlackAllPCs(int bFadeOut, float fFadeSpeed, float fSafeDelay)
{
	object oPC = GetFirstPC();
	
	while(GetIsObjectValid(oPC))
    {
		AssignCommand(oPC, ClearAllActions(TRUE));
        if(bFadeOut)
		{
			FadeToBlack(oPC, fFadeSpeed, fSafeDelay);
		}
		else 
		{
			FadeFromBlack(oPC, fFadeSpeed);
		}
        oPC = GetNextPC();
    } 
}

void FreezeAssociate(object oPC, int bValid, int nType, int nNth)
{
    object oAssoc = GetAssociate(nType, oPC, nNth);

    //OnHeartbeat calls ActionForceFollow if the NW_ASC_MODE_STAND_GROUND
    //flag is set to FALSE.
    SetAssociateState(NW_ASC_MODE_STAND_GROUND, bValid, oAssoc);

    //If we're freezing...
    if(bValid)
    {
        //clear any currently active ActionForceFollow commands that
        //OnHeartbeat might've already triggered.
        AssignCommand(oAssoc, ClearAllActions(TRUE));
    }
}

void FreezeAllAssociates(object oPC, int bValid)
{
    //Iterate through all possible associates, freezing them one-by-one.
    UnpossessFamiliar(oPC);
    object oAssoc;

    FreezeAssociate(oPC, bValid, ASSOCIATE_TYPE_ANIMALCOMPANION);
    FreezeAssociate(oPC, bValid, ASSOCIATE_TYPE_DOMINATED);
    FreezeAssociate(oPC, bValid, ASSOCIATE_TYPE_FAMILIAR);
    FreezeAssociate(oPC, bValid, ASSOCIATE_TYPE_SUMMONED);

    int i;
    for(i = 1; i <= GetMaxHenchmen(); i++)
    {
        FreezeAssociate(oPC, bValid, ASSOCIATE_TYPE_HENCHMAN, i);
    }
}

// Check if a status effect type can break a conversation
// Based on effect types defined in nwscript.nss as of 1/18/06
int GetIsEffectTypeBad(int nEffectType)
{
	return ((nEffectType == EFFECT_TYPE_ENTANGLE) ||
			(nEffectType == EFFECT_TYPE_DEAF) ||
			(nEffectType == EFFECT_TYPE_ARCANE_SPELL_FAILURE) ||
			(nEffectType == EFFECT_TYPE_CHARMED) ||
			(nEffectType == EFFECT_TYPE_CONFUSED) ||
			(nEffectType == EFFECT_TYPE_FRIGHTENED) ||
			(nEffectType == EFFECT_TYPE_PARALYZE) ||
			(nEffectType == EFFECT_TYPE_DAZED) ||
			(nEffectType == EFFECT_TYPE_STUNNED) ||
			(nEffectType == EFFECT_TYPE_SLEEP) ||
			(nEffectType == EFFECT_TYPE_POISON) ||
			(nEffectType == EFFECT_TYPE_DISEASE) ||
			(nEffectType == EFFECT_TYPE_CURSE) ||
			(nEffectType == EFFECT_TYPE_SILENCE) ||
			(nEffectType == EFFECT_TYPE_SLOW) ||
			(nEffectType == EFFECT_TYPE_MOVEMENT_SPEED_DECREASE) ||
			(nEffectType == EFFECT_TYPE_INVISIBILITY) ||
			(nEffectType == EFFECT_TYPE_GREATERINVISIBILITY) ||
			(nEffectType == EFFECT_TYPE_DARKNESS) ||
			(nEffectType == EFFECT_TYPE_BLINDNESS) ||
			(nEffectType == EFFECT_TYPE_PETRIFY) ||
			(nEffectType == EFFECT_TYPE_TURNED) ||
			(nEffectType == EFFECT_TYPE_DOMINATED) ||
			(nEffectType == EFFECT_TYPE_CUTSCENE_PARALYZE) ||
			(nEffectType == EFFECT_TYPE_CUTSCENEGHOST) ||
			(nEffectType == EFFECT_TYPE_CUTSCENEIMMOBILIZE) ||					
			(nEffectType == EFFECT_TYPE_FRIGHTENED)	||
			(nEffectType == EFFECT_TYPE_POLYMORPH) ||
			(nEffectType == EFFECT_TYPE_SWARM)
			);
			//(nEffectType == EFFECT_TYPE_NEGATIVELEVEL) ||
			//(nEffectType == EFFECT_TYPE_MOVEMENT_SPEED_INCREASE) ||
			//(nEffectType == EFFECT_TYPE_ETHEREAL) ||
}

// Clear effects on oCreature
void RemoveAllEffects(object oCreature, int bBadOnly)
{
	// Check if oCreature is valid
	if (GetIsObjectValid(oCreature) == FALSE) return;
	
	effect eEffect = GetFirstEffect(oCreature);
	int nEffectType;

	// For each effect
	while (GetIsEffectValid(eEffect) == TRUE)
	{
		if (bBadOnly == FALSE)
		{
			// Remove them all
			RemoveEffect(oCreature, eEffect);
		}
		else
		{
			nEffectType = GetEffectType(eEffect);
			
			// Remove if bad
			if (GetIsEffectTypeBad(nEffectType) == TRUE)
			{
				RemoveEffect(oCreature, eEffect);
			}
		}

		eEffect = GetNextEffect(oCreature);
	}
}

// Make oCreature (or faction) conversable (remove bad effects, revive)
void MakeConversable(object oCreature=OBJECT_SELF, int bFaction=FALSE)
{
	if (bFaction == TRUE)
	{
		// Make faction conversable
		object oMember = GetFirstFactionMember(oCreature, FALSE);
		while (GetIsObjectValid(oMember) == TRUE)
		{
			AssignCommand(oMember, MakeConversable(oMember, FALSE));
			oMember = GetNextFactionMember(oCreature, FALSE);
		}
	}
	else
	{
		// BMA-OEI 8/15/06 -- Unlock action queue
		SetCommandable( TRUE, oCreature );
		RemoveAllEffects(oCreature, TRUE);
				
		if (GetIsDead(oCreature) == TRUE)
		{
			ApplyEffectToObject(DURATION_TYPE_INSTANT, EffectResurrection(), oCreature);
		}
	}
}

// Call appropriate MakeConversable() to prepare for conversation
//void PrepareForConversation(object oCreature=OBJECT_SELF)
//{
//	// Include faction if oCreature is PC
//	MakeConversable(oCreature, GetIsPC(oCreature));
//}

// Prepare and fire conversation immediately
void FireAndForgetConversation(object oSpeaker, object oPC, string sDialog)
{
	MakeConversable(oPC, TRUE);
	MakeConversable(oSpeaker, FALSE);
	AssignCommand(oSpeaker, ClearAllActions(TRUE));
	AssignCommand(oSpeaker, ActionStartConversation(oPC, sDialog, FALSE, FALSE, TRUE, FALSE));
}

// Determine if a cutscene is waiting to be played	
int GetIsCutscenePending(struct CutsceneInfo stCI)
{
	return (stCI.bCutscenePending);
}	
	
// Initialize CutsceneInfo struct
struct CutsceneInfo ResetCutsceneInfo(struct CutsceneInfo stCI)
{
	stCI.bCutscenePending = FALSE;
	stCI.nCutsceneInfoCount = 0;

	return (stCI);
}

// Return CutsceneInfo struct of pending cutscene
struct CutsceneInfo SetupCutsceneInfo(struct CutsceneInfo stCI, string sSpeakerTag, object oPC, string sDialog, int bCutsceneCondition)
{
	// Unique cutscene identifier
	stCI.nCutsceneInfoCount = stCI.nCutsceneInfoCount + 1;

	if (bCutsceneCondition == TRUE)
	{
		string sPlayedVar = "CI_CS_" + IntToString(stCI.nCutsceneInfoCount) + "_PLAYED";
		int bPlayedAlready = GetLocalInt(OBJECT_SELF, sPlayedVar);
		
		if (bPlayedAlready == FALSE)
		{
			if (sSpeakerTag != "")
			{
				stCI.oSpeaker = GetNearestObjectByTag(sSpeakerTag, oPC);
			}
	
			if (GetIsObjectValid(stCI.oSpeaker) == FALSE)
			{
				PrettyError("SetupCutsceneInfo: ERROR - Pending cutscene with invalid SPEAKER: " + sSpeakerTag + "!");
				return (stCI);
			}
		
			if (GetIsPC(stCI.oSpeaker) == TRUE)
				PrettyError("SetupCutsceneInfo: WARNING - SPEAKER: " + sSpeakerTag + " is controlled by a PC.");
		
			stCI.sDialog = sDialog;
	
			if (sDialog == "")
				PrettyError("SetupCutsceneInfo: WARNING - Pending cutscene with unspecified dialog.");
	
			stCI.bCutscenePending = TRUE;
			SetLocalInt(OBJECT_SELF, sPlayedVar, TRUE);
		}
	}
	
	return (stCI);
}
	
// Check if any member of oPC's party is in conversation
int GetIsPartyInConversation(object oPC)
{
	object oMember = GetFirstFactionMember(oPC, FALSE);

	while (GetIsObjectValid(oMember) == TRUE)
	{
		if (IsInConversation(oMember) == TRUE)
		{
			return (TRUE);
		}

		oMember = GetNextFactionMember(oPC, FALSE);
	}
	
	return (FALSE);
}

// Set oPC's party's Plot Flag
void SetPartyPlotFlag(object oPC, int bPlotFlag)
{
	object oMember = GetFirstFactionMember(oPC, FALSE);

	while (GetIsObjectValid(oMember) == TRUE)
	{
		SetPlotFlag(oMember, bPlotFlag);

		oMember = GetNextFactionMember(oPC, FALSE);
	}
}

// Clear all oPC's party's actions
void ClearPartyActions(object oPC, int bClearCombatState=FALSE)
{
	object oMember = GetFirstFactionMember(oPC, FALSE);

	while (GetIsObjectValid(oMember) == TRUE)
	{
		AssignCommand(oMember, ClearAllActions(bClearCombatState));

		oMember = GetNextFactionMember(oPC, FALSE);
	}
}

// ScriptHide all creatures hostile to oPC in area
void HideHostileCreatures( object oPC, object oArea=OBJECT_INVALID )
{
	// Guarantee a valid oArea
	if ( GetIsObjectValid( oArea ) == FALSE )
	{
		oArea = GetArea( oPC );
	}

	// Search oArea for valid creatures and area_of_effects
	//int nCount = 1;		
	//object oCreature = GetNearestCreature( CREATURE_TYPE_IS_ALIVE, CREATURE_ALIVE_TRUE, OBJECT_SELF, nCount, CREATURE_TYPE_SCRIPTHIDDEN, CREATURE_SCRIPTHIDDEN_TRUE );
	int nType;
	object oCreature = GetFirstObjectInArea( oArea );
	
	while (GetIsObjectValid(oCreature) == TRUE)
	{
		nType = GetObjectType( oCreature );
	
		// If our object is a creature
		if ( nType == OBJECT_TYPE_CREATURE )
		{	
			// Check if it's visible
			if ( GetScriptHidden( oCreature ) == FALSE )
			{
				// Check if it's alive
				if ( GetIsDead( oCreature ) == FALSE )
				{
					// And check if it's hostile to oPC
					if ( GetIsEnemy( oCreature, oPC ) == TRUE )
					{
						SetScriptHidden( oCreature, TRUE );
						SetLocalInt( oCreature, TEMP_HOSTILE_VAR, 1 );
					}
				}
			}
		}
		else if ( nType == OBJECT_TYPE_AREA_OF_EFFECT )
		{
			// Destroy potential problem causing AoEs
				// The conditional has been commented out because GetIsEnemy may be returning unwanted results
				// For all intents and purposes, AoEs can be considered harmful in this case and we need to destroy them.
			//if ( GetIsEnemy( oCreature, oPC) == TRUE )
			//{
				DestroyObject( oCreature, 0.1f );
			//}
		}
	
		//nCount = nCount + 1;
		//oCreature = GetNearestCreature( CREATURE_TYPE_IS_ALIVE, CREATURE_ALIVE_TRUE, OBJECT_SELF, nCount, CREATURE_TYPE_SCRIPTHIDDEN, CREATURE_SCRIPTHIDDEN_TRUE );
		oCreature = GetNextObjectInArea( oArea );
	}
}

// Remove effect cutscene paralyze on oCreature
void RemoveEffectCutsceneParalyze(object oCreature)
{
	effect eEffect = GetFirstEffect(oCreature);

	while (GetIsEffectValid(eEffect) == TRUE)
	{
		if (GetEffectType(eEffect) == EFFECT_TYPE_CUTSCENE_PARALYZE)
		{
			RemoveEffect(oCreature, eEffect);
			return;
		}
		
		eEffect = GetNextEffect(oCreature);
	}
}

// Show all hostile creatures hidden with HideHostileCreatures()
void ShowHostileCreatures(object oPC, object oArea=OBJECT_INVALID)
{
	if (GetIsObjectValid(oArea) == FALSE)
	{
		oArea = GetArea(oPC);
	}

	object oCreature = GetFirstObjectInArea(oArea);

	while (GetIsObjectValid(oCreature) == TRUE)
	{
		if ((GetScriptHidden(oCreature) == TRUE) && (GetLocalInt(oCreature, TEMP_HOSTILE_VAR) == 1))
		{
			SetScriptHidden(oCreature, FALSE);
			SetLocalInt(oCreature, TEMP_HOSTILE_VAR, 0);
		}

		oCreature = GetNextObjectInArea(oArea);
	}
}

// Jump PC party to oSpeaker
void JumpPartyToSpeaker(object oPC, object oSpeaker)
{
	object oArea = GetArea(oSpeaker);
	object oMember = GetFirstFactionMember(oPC, FALSE);

	while (GetIsObjectValid(oMember) == TRUE)
	{
		if (GetArea(oMember) == oArea)
		{
			AssignCommand(oMember, JumpToObject(oSpeaker));
		}

		oMember = GetNextFactionMember(oPC, FALSE);
	}
}

// Save oCreature's Stand Ground state
void SaveStandGroundState(object oCreature)
{
	int nValue = GetAssociateState(NW_ASC_MODE_STAND_GROUND);
	SetLocalInt(oCreature, STAND_GROUND_VAR, nValue);
}

// Load oCreature's Stand Ground state
void LoadStandGroundState(object oCreature)
{
	int nValue = GetLocalInt(oCreature, STAND_GROUND_VAR);
	SetAssociateState(NW_ASC_MODE_STAND_GROUND, nValue, oCreature);
}

// Lock from CombatCutsceneCleanUp until conversation has time to begin
void SetCombatCutsceneLocked(int bLocked)
{
	SetGlobalInt(COMBAT_LOCK_VAR, bLocked);
}

// Check if CombatCutsceneSetup has recently been executed
int GetIsCombatCutsceneLocked()
{
	return GetGlobalInt(COMBAT_LOCK_VAR);
}

// Temp-Lock, hide hostile creatures, set party Plot Flag
void CombatCutsceneSetup(object oPC)
{
	SetCombatCutsceneLocked(1);

	HideHostileCreatures(oPC);
	SetPartyPlotFlag(oPC, TRUE);

	DelayCommand(1.0f, SetCombatCutsceneLocked(0));
	
	// Clean up when conversation ends
	object oIPCleaner = CreateObject(OBJECT_TYPE_PLACEABLE, IPC_RESREF, GetLocation(oPC));
	AssignCommand(oIPCleaner, QueueCombatCutsceneCleanUp());	
}

// Show hostile creatures, set party Plot Flag (MUST BE EXECUTED ON AN IPOINT CLEANER)
void CombatCutsceneCleanUp(object oPC, object oArea=OBJECT_INVALID)
{
	SetPartyPlotFlag(oPC, FALSE);			
	ShowHostileCreatures(oPC, oArea);
}

// Check if we should clean up a CombatCutscene (conversation has ended) (MUST BE EXECUTED ON AN IPOINT CLEANER)
void AttemptCombatCutsceneCleanUp()
{
	if (GetLocalInt(OBJECT_SELF, IPC_DELETE_SELF) == 0)
	{
		object oPC = GetFirstPC();
	
		if ((GetIsCombatCutsceneLocked() == 0) && (GetIsPartyInConversation(oPC) == FALSE))
		{
			CombatCutsceneCleanUp(oPC, GetArea(OBJECT_SELF));
			SetLocalInt(OBJECT_SELF, IPC_DELETE_SELF, 1);
		}
	}
	else
	{
		DestroyObject(OBJECT_SELF);
	}
}

// Re-queue AttemptCombatCutsceneCleanUp() (MUST BE EXECUTED ON AN IPOINT CLEANER)
void QueueCombatCutsceneCleanUp()
{
	DelayCommand(1.5f, AttemptCombatCutsceneCleanUp());
}