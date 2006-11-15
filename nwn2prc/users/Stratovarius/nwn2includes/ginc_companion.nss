// ginc_companion
/*
	Helper functions for companions.
*/

// ChazM 8/24/06 - split from ginc_companions, added SetInfluence()

// void main(){}

#include "nw_i0_generic"	// has SetAssociateState()
#include "ginc_misc"
#include "x0_i0_petrify"	// has RemoveEffectOfType()
#include "ginc_henchman"

const string INFLUENCE_PREFIX	= "00_nInfluence";
const int INFLUENCE_MIN = -100; // Companion Influence cap
const int INFLUENCE_MAX = 100;

// Prototypes
void SetAssociatesState(int nAssociateType, object oPC, int nCondition, int bValid = TRUE);
void SetAllAssociatesState(object oMaster, int nCondition, int bValid = TRUE);
void ClearAssociatesActions(int nAssociateType, object oPC, int nClearCombatState = FALSE);
void ClearAllAssociatesActions(object oMaster, int nClearCombatState = FALSE);
void SetAllAssociatesFollow(object oMaster, int bValid=TRUE);


int IsHenchman(object oThisHenchman, object oPC);
int IsHenchmanByTag(object oPC, string sHenchmanTag="");
object GetHenchmanByTag(object oPC, string sHenchmanTag="");
int RemoveHenchmanByTag(object oPC, string sHenchmanTag="");
void ApplyHenchmanModifier(object oHenchman = OBJECT_SELF);
void RemoveHenchmanModifier(object oHenchman = OBJECT_SELF);
void AddHenchmanToCompanion(object oCompanionMaster, object oHenchman = OBJECT_SELF);
void RemoveHenchmanFromCompanion(object oCompanionMaster, object oHenchman = OBJECT_SELF);


object GetPCLeader(object oPC=OBJECT_SELF);
int GetIsInRoster(string sRosterName);
int IsInParty(string sRosterName);
void PrintRosterList();
void ClearRosterList();
void TestAddRosterMemberByTemplate(string sRosterName, string sTemplate);
void TestRemoveRosterMember(string sRosterName);
int GetIsObjectInParty(object oMember);
void DespawnAllRosterMembers(int bExcludeParty=FALSE);

// Remove all selectable roster members from oPC's party
// - bIgnoreSelectable: If TRUE, also despawn non-Selectable roster members
void RemoveRosterMembersFromParty( object oPC, int bDespawnNPC=TRUE, int bIgnoreSelectable=FALSE );

// Return the number of roster members in oPC's party
int GetNumRosterMembersInParty( object oPC );
	
// Despawn non-party roster members and save module state before transitioning to a new module
// - sModuleName: Name of module to load
// - sWaypoint: Optional starting point for party
void SaveRosterLoadModule( string sModuleName, string sWaypoint="" );


// ForceRest() oPC's party
void ForceRestParty( object oPC );

int GetInfluence(object oCompanion);
int SetInfluence(object oCompanion, int nInfluence);

//-------------------------------------------------
// Function Definitions
//-------------------------------------------------


// Return faction leader of oPC. If faction leader is not a PC, return OBJECT_INVALID.
object GetPCLeader(object oPC=OBJECT_SELF)
{
	object oMaster = GetFactionLeader(oPC);

	if (GetIsPC(oMaster) == FALSE)
	{
		oMaster = OBJECT_INVALID;
	}

	return (oMaster);
}

// Check if sRosterName is a valid RosterID
int GetIsInRoster(string sRosterName)
{
	string sRosterID = GetFirstRosterMember();
	
	while (sRosterID != "")
	{
		if (sRosterID == sRosterName) 
		{
			return (TRUE);
		}

		sRosterID = GetNextRosterMember();
	}

	return (FALSE);
}

// Add specified companion to roster using either an instance found or else the Template
void AddCompanionToRoster(string sRosterName, string sTagName, string sResRef)
{
	string WP_Prefix = "spawn_";

	object oCompanion 	= GetObjectByTag(sTagName);
	int bInRoster		= GetIsInRoster(sRosterName);

	// check if companion already in roster.
	if (bInRoster)
	{
		// already in roster	
		// shouldn't need to do anything?
	}		
	else
	{
		// not in roster.
		if (GetIsObjectValid(oCompanion))
		{
			
			// instance of companion is in world - add him to roster
			AddRosterMemberByCharacter(sRosterName, oCompanion);
		}
		else
		{
			// Add companion Blueprint instead
				AddRosterMemberByTemplate(sRosterName, sResRef);
		}
	}
}






int IsInParty(string sRosterName)
{
	object oPC = GetFirstPC();
	object oFM = GetFirstFactionMember(oPC, FALSE);
    object oCompanion = GetObjectFromRosterName(sRosterName);
    
	while(GetIsObjectValid(oFM))
	{
		if(oFM == oCompanion)
		{
			return 1;
		}
		oFM = GetNextFactionMember(oPC, FALSE);
	}
	return 0;
}

// returns true or false
int IsHenchman(object oThisHenchman, object oPC)
{
	if (!GetIsPC(oPC)) 
		return FALSE;

	object oHenchman;
	int i;
	for (i=1; i<=GetMaxHenchmen(); i++)
   	{
		oHenchman = GetHenchman(oPC, i);
	   	if (GetIsObjectValid(oHenchman))
			if (oHenchman == oThisHenchman)
	   			return TRUE;
	}
	return FALSE;
}

// returns true or false
int IsHenchmanByTag(object oPC, string sHenchmanTag="")
{
	return (GetIsObjectValid(GetHenchmanByTag( oPC, sHenchmanTag)));
}


// Returns henchman with specified tag if found
object GetHenchmanByTag(object oPC, string sHenchmanTag="")
{
	if (sHenchmanTag == "")
		sHenchmanTag = GetTag(OBJECT_SELF);

	object oHenchman;
	int i;
	for (i=1; i<=GetMaxHenchmen(); i++)
   	{
		oHenchman = GetHenchman(oPC, i);
		//PrintString ("Henchman [" + IntToString(i) + "] = " + GetName(oHenchman));
	   	if (GetIsObjectValid(oHenchman))
		{
			//PrintString ("Henchman [" + IntToString(i) + "] = " + GetName(oHenchman));
			if (sHenchmanTag == GetTag(oHenchman))
	   			return oHenchman;
		}
	}
	return OBJECT_INVALID;
}

// Removes henchman with specified tag if found
int RemoveHenchmanByTag(object oPC, string sHenchmanTag = "")
{
    object oHenchman = GetHenchmanByTag(oPC, sHenchmanTag);

    if (GetIsObjectValid(oHenchman))
    {
        RemoveHenchman(oPC, oHenchman);
		AssignCommand(oHenchman, ClearAllActions(TRUE)); // needed to get rid of autofollow
		return TRUE;
    }
	return FALSE;
}		



// Despawn all companions in oPC's party (faction)
void DespawnAllCompanions(object oPC)
{
	object oFM = GetFirstFactionMember(oPC, FALSE);
	string sRosterName;
	while (GetIsObjectValid(oFM) == TRUE)
	{
		PrintString("DespawnAllCompanions: "+GetName(oFM));
		if (GetIsRosterMember(oFM) == TRUE)
		{
			sRosterName = GetRosterNameFromObject(oFM);
			DespawnRosterMember(sRosterName);
			oFM = GetFirstFactionMember(oPC, FALSE);
		}
		else
		{
			oFM = GetNextFactionMember(oPC, FALSE);
		}
	}
}

void SetAssociatesState(int nAssociateType, object oPC, int nCondition, int bValid = TRUE)
{
	int i = 1;
	object oAssoc = GetAssociate(nAssociateType, oPC, i);
	while (GetIsObjectValid(oAssoc))
	{
		AssignCommand(oAssoc, SetAssociateState(nCondition, bValid));
		//PrintString("" + GetName(oAssoc) + " - state set to not follow - " + IntToString(bValid));
		i++;
		oAssoc = GetAssociate(nAssociateType, oPC, i);

	}
	return;
}

void SetAllAssociatesState(object oMaster, int nCondition, int bValid = TRUE)
{
 	SetAssociatesState(ASSOCIATE_TYPE_ANIMALCOMPANION, oMaster, nCondition, bValid);
 	SetAssociatesState(ASSOCIATE_TYPE_DOMINATED, oMaster, nCondition, bValid);
 	SetAssociatesState(ASSOCIATE_TYPE_FAMILIAR, oMaster, nCondition, bValid);
 	SetAssociatesState(ASSOCIATE_TYPE_HENCHMAN, oMaster, nCondition, bValid);
 	SetAssociatesState(ASSOCIATE_TYPE_SUMMONED, oMaster, nCondition, bValid);
	return;
}

void ClearAssociatesActions(int nAssociateType, object oPC, int nClearCombatState = FALSE)
{
	int i = 1;
	object oAssoc = GetAssociate(nAssociateType, oPC, i);
	while (GetIsObjectValid(oAssoc))
	{
		AssignCommand(oAssoc, ClearAllActions(nClearCombatState));
		i++;
		oAssoc = GetAssociate(nAssociateType, oPC, i);

	}
	return;

}

void ClearAllAssociatesActions(object oMaster, int nClearCombatState = FALSE)
{
 	ClearAssociatesActions(ASSOCIATE_TYPE_ANIMALCOMPANION, oMaster, nClearCombatState);
 	ClearAssociatesActions(ASSOCIATE_TYPE_DOMINATED, oMaster, nClearCombatState);
 	ClearAssociatesActions(ASSOCIATE_TYPE_FAMILIAR, oMaster, nClearCombatState);
 	ClearAssociatesActions(ASSOCIATE_TYPE_HENCHMAN, oMaster, nClearCombatState);
 	ClearAssociatesActions(ASSOCIATE_TYPE_SUMMONED, oMaster, nClearCombatState);

}

void SetAllAssociatesFollow(object oMaster, int bValid=TRUE)
{
	// followers use ActionForceFollowObject to follow PC.  This can only be stopped with a
	// Clear all actions.
	if (bValid == FALSE)
		ClearAllAssociatesActions(oMaster);

	SetAllAssociatesState(oMaster, NW_ASC_MODE_STAND_GROUND, !bValid);
}


// apply an AttackIncrease or Decrease effect to henchman of a companion based on the influence 
// the PC has with the companion
void ApplyHenchmanModifier(object oHenchman = OBJECT_SELF)
{
	object oCompanionMaster = GetMaster(oHenchman);
	int iInfluence = GetInfluence(oCompanionMaster);
	int iModifier = iInfluence/10;
	effect eAttack;

	if (iModifier > 0)
		eAttack = EffectAttackIncrease(iModifier);
	else if (iModifier < 0)
		eAttack = EffectAttackDecrease(abs(iModifier));

	if (iModifier != 0)
		ApplyEffectToObject(DURATION_TYPE_PERMANENT, eAttack, oHenchman);
}

// Remove the effect applied with ApplyHenchmanModifier().  Note that all effects of given types are removed 
// (including those derived from other sources such as spells).
void RemoveHenchmanModifier(object oHenchman = OBJECT_SELF)
{
	RemoveEffectOfType(oHenchman, EFFECT_TYPE_ATTACK_DECREASE);
	RemoveEffectOfType(oHenchman, EFFECT_TYPE_ATTACK_INCREASE);
}

// Adds a henchman and applies modifiers
void AddHenchmanToCompanion(object oCompanionMaster, object oHenchman = OBJECT_SELF)
{
	AddHenchman (oCompanionMaster, oHenchman);
	ApplyHenchmanModifier(oHenchman);
}

// Removes a henchman and modifiers
void RemoveHenchmanFromCompanion(object oCompanionMaster, object oHenchman = OBJECT_SELF)
{
	RemoveHenchmanModifier(oHenchman);
	RemoveHenchman(oCompanionMaster, oHenchman);
}

// List roster member names on screen
void PrintRosterList()
{
	int nCount = 0;
	string sRosterName = GetFirstRosterMember();

	PrettyMessage("Printing Roster List...");

	while (sRosterName != "")
	{
		nCount = nCount + 1;
		PrettyMessage(" Member " + IntToString(nCount) + ": " + sRosterName);
		sRosterName = GetNextRosterMember();
	}
	
	PrettyMessage("Roster List finished (" + IntToString(nCount) + " members).");
}

// Remove all members from roster
void ClearRosterList()
{
	int nCount = 0;
	int bSuccess = 0;
	string sMember = GetFirstRosterMember();
	
	while (sMember != "")
	{
		nCount++;
		bSuccess = RemoveRosterMember(sMember);
		if (bSuccess == TRUE)
		{
			PrettyMessage("ginc_roster: ClearRosterList() successfully removed " + sMember);
		}	
		else
		{
			PrettyError("ginc_roster: ClearRosterList() could not find " + sMember);
		}
	
		// Reset iterator
		sMember = GetFirstRosterMember();
	}
}

// Attempt AddRosterMemberByTemplate()
void TestAddRosterMemberByTemplate(string sRosterName, string sTemplate)
{
	int bResult = AddRosterMemberByTemplate(sRosterName, sTemplate);
	if (bResult == TRUE)
	{
		PrettyMessage("ginc_roster: successfully added " + sRosterName + " (" + sTemplate + ")");	
	}
	else
	{
		PrettyError( "ginc_roster: failed to add " + sRosterName + " (" + sTemplate + ")");
	}
}

// Attempt RemoveRosterMember()
void TestRemoveRosterMember(string sMember)
{
	int bResult = RemoveRosterMember(sMember);
	if (bResult == TRUE)
	{
		PrettyMessage("ginc_roster: successfully removed " + sMember);
	}
	else
	{
		PrettyError("ginc_error: failed to remove " + sMember);	
	}
}

// Check if oMember is in first PC's party (faction)
int GetIsObjectInParty(object oMember)
{
	return (GetFactionEqual(oMember, GetFirstPC()));
}

// Despawn all roster members in module. Option bExcludeParty=TRUE to ignore party members.
// Useful to update roster state before a module transition.
void DespawnAllRosterMembers(int bExcludeParty=FALSE)
{
	object oMember;
	string sRosterID = GetFirstRosterMember();

	// For each roster ID
	while (sRosterID != "")
	{
		oMember = GetObjectFromRosterName(sRosterID);
		
		// If they're in the game
		if (GetIsObjectValid(oMember) == TRUE)
		{
			// And in my party
			if (GetIsObjectInParty(oMember) == TRUE)
			{
				if (bExcludeParty == FALSE)
				{
					RemoveRosterMemberFromParty(sRosterID, GetFirstPC(), TRUE);
				}
			}
			else
			{
				DespawnRosterMember(sRosterID);
			}
		}
	
		sRosterID = GetNextRosterMember();
	}
}
	
// Remove all selectable roster members from oPC's party
// - bIgnoreSelectable: If TRUE, also despawn non-Selectable roster members
void RemoveRosterMembersFromParty( object oPC, int bDespawnNPC=TRUE, int bIgnoreSelectable=FALSE )
{
	string sRosterName;
		
	// For each party member
	object oMember = GetFirstFactionMember( oPC, FALSE );
	while ( GetIsObjectValid( oMember ) == TRUE )
	{
		sRosterName = GetRosterNameFromObject( oMember );

		// If party member is a roster member	
		if ( sRosterName != "" )
		{
			// And party member is not required
			if ( ( bIgnoreSelectable ) || ( GetIsRosterMemberSelectable( sRosterName ) == TRUE ) )
			{
				// If party member is controlled by a PC
				if ( GetIsPC( oMember ) == TRUE )
				{
					// Force PC into original character
					SetOwnersControlledCompanion( oMember );
				}		
				
				RemoveRosterMemberFromParty( sRosterName, oPC, bDespawnNPC );
				oMember = GetFirstFactionMember( oPC, FALSE );
			}
			else
			{
				oMember = GetNextFactionMember( oPC, FALSE );
			}
		}
		else
		{
			oMember = GetNextFactionMember( oPC, FALSE );
		}
	}	
}
	
// Return the number of roster members in oPC's party
int GetNumRosterMembersInParty( object oPC )
{
	int nCount = 0;

	object oMember = GetFirstFactionMember( oPC, FALSE );

	while ( GetIsObjectValid( oMember ) == TRUE )
	{
		// If party member has a roster name
		if ( GetRosterNameFromObject( oMember ) != "" )
		{
			nCount = nCount + 1;
		}

		oMember = GetNextFactionMember( oPC, FALSE );
	}
	
	return ( nCount );
}
	
// Despawn non-party roster members and save module state before transitioning to a new module
// - sModuleName: Name of module to load
// - sWaypoint: Optional starting point for party
void SaveRosterLoadModule( string sModuleName, string sWaypoint="" )
{
	// Save non-party roster member states
	DespawnAllRosterMembers( TRUE );
	LoadNewModule( sModuleName, sWaypoint );
}

// ForceRest() oPC's party
void ForceRestParty( object oPC )
{
	object oFM = GetFirstFactionMember( oPC, FALSE );
	while ( GetIsObjectValid( oFM ) == TRUE )
	{
		ForceRest( oFM );
		oFM = GetNextFactionMember( oPC, FALSE );
	}
}


////////////////////////////
// Influence
//////////////////////////// 


int GetInfluence(object oCompanion)
{
	string sVarInfluence = INFLUENCE_PREFIX + GetTag(oCompanion);
	int iInfluence = GetGlobalInt(sVarInfluence);
	return (iInfluence);
}

void SetInfluence(object oCompanion, int nInfluence)
{
	string sVarInfluence = INFLUENCE_PREFIX + GetTag(oCompanion);
	if ( nInfluence < INFLUENCE_MIN )
		nInfluence = INFLUENCE_MIN;
	else if ( nInfluence > INFLUENCE_MAX )
		nInfluence = INFLUENCE_MAX;
		
	SetGlobalInt( sVarInfluence, nInfluence);
}