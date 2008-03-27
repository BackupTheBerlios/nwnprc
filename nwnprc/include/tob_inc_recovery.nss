//::///////////////////////////////////////////////
//:: Tome of Battle include: Maneuver Recovery
//:: tob_inc_martlore
//::///////////////////////////////////////////////
/** @file
    Defines various functions and other stuff that
    do something related to recovery and readying maneuvers
    See page #28 of Tome of Battle
    
    Functions below are called by the initiator as
    he makes a maneuver, or when recovering or readying

    @author Stratovarius
    @date   Created - 2007.3.25
*/
//:://////////////////////////////////////////////
//:://////////////////////////////////////////////

//////////////////////////////////////////////////
/*                 Constants                    */
//////////////////////////////////////////////////

const int MANEUVER_READIED   = 1;
const int MANEUVER_RECOVERED = 2;
const int MANEUVER_GRANTED   = 3;
const int MANEVUER_WITHHELD  = 4;

//////////////////////////////////////////////////
/*             Function prototypes              */
//////////////////////////////////////////////////

/**
 * Gets the number of Maneuvers a character has readied
 *
 * @param oPC       The creature whose Maneuvers to check
 * @param nList     The list to check. One of MANEUVER_LIST_*
 * @return          The number of Maneuvers readied
 */
int GetReadiedCount(object oPC, int nList);

/**
 * Gets the maximum number of Maneuvers a character may ready.
 *
 * @param oPC       Character to determine maximum Maneuvers readied
 * @param nList     MANEUVER_LIST_* of the list to determine maximum Maneuvers for
 * @return          Maximum number of Maneuvers that oPC may ready
 */
int GetMaxReadiedCount(object oPC, int nList);

/**
 * Readies the chosen Maneuver. Also checks to see if there are any slots left
 *
 * @param oPC       Character readying maneuver
 * @param nList     MANEUVER_LIST_* of the list to ready
 * @param nMoveId   Maneuver to ready
 */
void ReadyManeuver(object oPC, int nList, int nMoveId);

/**
 * Returns whether maneuver is readied or not
 *
 * @param oPC       Character to check
 * @param nList     MANEUVER_LIST_*
 * @param nMoveId   Maneuver to check
 * @return          TRUE or FALSE
 */
int GetIsManeuverReadied(object oPC, int nList, int nMoveId);

/**
 * Returns whether maneuver is expended or not
 *
 * @param oPC       Character to check
 * @param nList     MANEUVER_LIST_*
 * @param nMoveId   Maneuver to check
 * @return          TRUE or FALSE
 */
int GetIsManeuverExpended(object oPC, int nList, int nMoveId);

/**
 * Expends the chosen Maneuver. 
 *
 * @param oPC       Character to check
 * @param nList     MANEUVER_LIST_*
 * @param nMoveId   Maneuver to expend
 */
void ExpendManeuver(object oPC, int nList, int nMoveId);

/**
 * Clears all local ints marking maneuvers as expended
 *
 * @param oPC       Character to clear
 * @param nList     MANEUVER_LIST_*
 */
void RecoverExpendedManeuvers(object oPC, int nList);

/**
 * Recovers the chosen Maneuver. 
 *
 * @param oPC       Character to check
 * @param nList     MANEUVER_LIST_*
 * @param nMoveId   Maneuver to recover
 */
void RecoverManeuver(object oPC, int nList, int nMoveId);

/**
 * Checks to see if the PC is in a Warblade recovery round
 * This prevents all use of maneuvers or stances during that round.
 *
 * @param oPC       Character to clear
 * @return          TRUE or FALSE
 */
int GetIsWarbladeRecoveryRound(object oPC);

/**
 * Marks maneuvers as granted or withheld. 
 *
 * @param oPC       Character to grant maneuvers to
 * @param nList     MANEUVER_LIST_*
 */
void GrantManeuvers(object oPC, int nList);

/**
 * Clears all local ints marking maneuvers as readied
 *
 * @param oPC       Character to clear
 * @param nList     MANEUVER_LIST_*
 */
void ClearReadiedManeuvers(object oPC, int nList);

/**
 * Grants a withheld maneuver
 * Only works on Crusaders
 *
 * @param oPC       Character to grant maneuvers to
 * @param nList     MANEUVER_LIST_*
 */
void GrantWithheldManeuver(object oPC, int nList);

/**
 * Returns whether maneuver is granted or not
 * Only works on Crusaders
 *
 * @param oPC       Character to check
 * @param nMoveId   Maneuver to check
 * @return          TRUE or FALSE
 */
int GetIsManeuverGranted(object oPC, int nMoveId);

/**
 * Clears all local ints marking maneuvers as granted or withheld
 * Only works on Crusaders
 *
 * @param oPC       Character to clear
 */
void ClearGrantedWithheldManeuvers(object oPC);

/**
 * Starting function for Crusader recovery, calls DoCrusaderGranting
 * Only works on Crusaders
 *
 * @param oPC       Crusader
 */
void BeginCrusaderGranting(object oPC);

/**
 * Recursive function granting maneuvers each round in combat
 * Will end when combat ends
 * Only works on Crusaders
 *
 * @param oPC       Crusader
 * @param nTrip     Round of combat. Takes values from 1 to 5, always starts with 1.
 */
void DoCrusaderGranting(object oPC, int nTrip);

//////////////////////////////////////////////////
/*                  Includes                    */
//////////////////////////////////////////////////

#include "inc_lookups"
#include "tob_move_const"
#include "tob_inc_tobfunc"

//////////////////////////////////////////////////
/*             Internal functions               */
//////////////////////////////////////////////////

//////////////////////////////////////////////////
/*             Function definitions             */
//////////////////////////////////////////////////

int GetReadiedCount(object oPC, int nList)
{
	// Counting through the local ints to determine how many are readied
	int i = 1;
	int nReadied = 0;
	// 25 is the max possible for any class
        for(i = 0; i < 25; i++)
	{
		// If the value is valid, add to the count
		if (GetLocalInt(oPC, "ManeuverReadied" + IntToString(nList) + IntToString(i)) > 0) nReadied += 1;
        }
        if(DEBUG) DoDebug("tob_inc_recovery: GetReadiedCount: " +IntToString(nReadied));
        return nReadied;
}

int GetMaxReadiedCount(object oPC, int nList)
{
	int nLevel = GetInitiatorLevel(oPC, nList);
	string sPsiFile = GetAMSKnownFileName(nList);
	// 2das start at Row 0
	int nMaxReadied = StringToInt(Get2DACache(sPsiFile, "ManeuversReadied", nLevel-1));
	if(DEBUG) DoDebug("tob_inc_recovery: MaxManeuvers Readied: " +IntToString(nMaxReadied));
	
	return nMaxReadied;
}

void ReadyManeuver(object oPC, int nList, int nMoveId)
{
	int nCount = GetReadiedCount(oPC, nList);
	int nMaxCount = GetMaxReadiedCount(oPC, nList);
	
	// If the PC can ready a maneuver and hasn't filled them all up
	if (nMaxCount > nCount)
	{
		// Counting through the local ints
		int i = 1;
                while (i > 0)
		{
			// If it hits a non-valid, break
			if (GetLocalInt(oPC, "ManeuverReadied" + IntToString(nList) + IntToString(i)) == 0) break;
			i++;
                }

		// This will mark the Maneuver Readied, one further on than before
		SetLocalInt(oPC, "ManeuverReadied" + IntToString(nList) + IntToString(i+1), nMoveId);
		if(DEBUG) DoDebug("tob_inc_recovery: ReadyManeuver: " +IntToString(nMoveId));
	}
}

int GetIsManeuverReadied(object oPC, int nList, int nMoveId)
{
	// Counting through the local ints to determine if this one is readied
	int i = 1;
	// 25 is the max possible for any class
        for(i = 0; i < 25; i++)
	{
		// If the value is valid, add to the count
		if (GetLocalInt(oPC, "ManeuverReadied" + IntToString(nList) + IntToString(i)) == nMoveId)
		{
			if(DEBUG) DoDebug("tob_inc_recovery: GetIsManeuverReadied: " +IntToString(nMoveId));
			return TRUE;
		}
        }
	
	return FALSE;
}

int GetIsManeuverExpended(object oPC, int nList, int nMoveId)
{
	// Counting through the local ints to determine if this one is expended
	int i = 1;
	// 25 is the max possible for any class
        for(i = 0; i < 25; i++)
	{
		// returns if the maneuver is expended
		if (GetLocalInt(oPC, "ManeuverExpended" + IntToString(nList) + IntToString(i)) == nMoveId)
		{
			if(DEBUG) DoDebug("tob_inc_recovery: GetIsManeuverExpended: " +IntToString(nMoveId));
			return TRUE;
		}
        }
	
	return FALSE;
}

void ExpendManeuver(object oPC, int nList, int nMoveId)
{
	// Counting through the local ints
	int i = 1;
        while (i > 0)
	{
		// If it hits a non-valid, break
		if (GetLocalInt(oPC, "ManeuverExpended" + IntToString(nList) + IntToString(i)) == 0) break;
		i++;
        }

	// This will mark the Maneuver Expended, one further on than before
	SetLocalInt(oPC, "ManeuverExpended" + IntToString(nList) + IntToString(i+1), nMoveId);
	if(DEBUG) DoDebug("tob_inc_recovery: Expending Maneuver: " + IntToString(nMoveId));
}

void RecoverExpendedManeuvers(object oPC, int nList)
{
	// Counting through the local ints to clear them all
	if(DEBUG) DoDebug("tob_inc_recovery: Clearing expended maneuvers");
	int i = 1;
	// 25 is the max possible for any class (Swordsage)
        for(i = 0; i < 25; i++)
	{
		// Clear them all
		DeleteLocalInt(oPC, "ManeuverExpended" + IntToString(nList) + IntToString(i));
        }
        // Do Grant/Withheld Maneuvers whenever this is called on a Crusader
        if (nList == MANEUVER_LIST_CRUSADER)
        {
        	// Make sure to clear them all first
        	ClearGrantedWithheldManeuvers(oPC);
        	// Then re-grant/withhold them
        	GrantManeuvers(oPC, nList);
        }
}

void RecoverManeuver(object oPC, int nList, int nMoveId)
{
	// Counting through the local ints to determine if this one is expended
	int i = 1;
	// 25 is the max possible for any class
        for(i = 0; i < 25; i++)
	{
		// If it has been expended, clear that
		if (GetLocalInt(oPC, "ManeuverExpended" + IntToString(nList) + IntToString(i)) == nMoveId)
		{
			DeleteLocalInt(oPC, "ManeuverExpended" + IntToString(nList) + IntToString(i));
			if(DEBUG) DoDebug("tob_inc_recovery: Recovering Maneuver: " + IntToString(nMoveId));
		}
        }
}

int GetIsWarbladeRecoveryRound(object oPC)
{
	if(DEBUG) DoDebug("tob_inc_recovery: Warblade recovery check");
	if (GetLocalInt(oPC, "WarbladeRecoveryRound")) return TRUE;
	
	return FALSE;
}

void GrantManeuvers(object oPC, int nList)
{
	// Counting through the local ints to determine how many are readied
	int i;
        string sPsiFile = GetAMSKnownFileName(nList);
	// 2das start at Row 0
	int nGranted = StringToInt(Get2DACache(sPsiFile, "ManeuversGranted", nList-1));	
	// is the max possible for a Crusader
        for(i = 0; i < 7; i++)
	{
		// If the value is readied, mark it and store it
		int nMoveId = GetLocalInt(oPC, "ManeuverReadied" + IntToString(nList) + IntToString(i));
		if (nMoveId > 0) 
		{
			// First nGranted maneuvers are marked as granted
			// Rest are marked as withheld, no need to use list because only one class has this
			if (i >= nGranted)
			{
				SetLocalInt(oPC, "ManeuverGranted" + IntToString(i), nMoveId);
				FloatingTextStringOnCreature(GetManeuverName(nMoveId) + " is granted", oPC, FALSE);
				if(DEBUG) DoDebug("tob_inc_recovery: Maneuvers Granted: " + IntToString(i));
			}
			else // Mark the rest as Withheld for the moment
			{
				SetLocalInt(oPC, "ManeuverWithheld" + IntToString(i), nMoveId);
				FloatingTextStringOnCreature(GetManeuverName(nMoveId) + " is withheld", oPC, FALSE);
				if(DEBUG) DoDebug("tob_inc_recovery: Maneuvers Withheld: " + IntToString(i));
			}
		}
        }
}

void ClearReadiedManeuvers(object oPC, int nList)
{
	// Counting through the local ints to clear them all
	int i = 1;
	if(DEBUG) DoDebug("tob_inc_recovery: Clearing readied maneuvers");
	// 25 is the max possible for any class (Swordsage)
        for(i = 0; i < 25; i++)
	{
		// Clear them all
		DeleteLocalInt(oPC, "ManeuverReadied" + IntToString(nList) + IntToString(i));
        }
}

void GrantWithheldManeuver(object oPC, int nList)
{
	int i, nMoveId;
        string sPsiFile = GetAMSKnownFileName(nList);
	// 2das start at Row 0
	int nLevel = GetInitiatorLevel(oPC, nList);
	int nGranted = StringToInt(Get2DACache(sPsiFile, "ManeuversGranted", nLevel-1));	
	int nReadied = StringToInt(Get2DACache(sPsiFile, "ManeuversReadied", nLevel-1));	
	if(DEBUG) DoDebug("tob_inc_recovery: Maneuvers Granted: " + IntToString(nGranted));
	if(DEBUG) DoDebug("tob_inc_recovery: Maneuvers Readied: " + IntToString(nReadied));
	// 3 is always the number withheld
        for(i = nGranted; i < nReadied; i++)
	{
		nMoveId = GetLocalInt(oPC, "ManeuverWithheld" + IntToString(i));
		// If it exists, mark it as ready and break out 
		if (nMoveId > 0)
		{
			if(DEBUG) DoDebug("tob_inc_recovery: Withheld Maneuver Granted: " + IntToString(nMoveId));
			DeleteLocalInt(oPC, "ManeuverWithheld" + IntToString(i));
			FloatingTextStringOnCreature(GetManeuverName(nMoveId) + " is granted", oPC, FALSE);
			SetLocalInt(oPC, "ManeuverGranted" + IntToString(i), nMoveId);
			break;
		}
	}
}

int GetIsManeuverGranted(object oPC, int nMoveId)
{
	// Counting through the local ints to determine if this one is expended
	int i = 1;
	// 7 is the max possible for Crusader
        for(i = 0; i < 7; i++)
	{
		// returns if the maneuver is expended
		if (GetLocalInt(oPC, "ManeuverGranted" + IntToString(i)) == nMoveId)
		{
			if(DEBUG) DoDebug("tob_inc_recovery: GetIsManeuverGranted: " +IntToString(nMoveId));
			return TRUE;
		}
        }
	
	return FALSE;
}

void ClearGrantedWithheldManeuvers(object oPC)
{
	// Counting through the local ints to clear them all
	int i = 1;
	if(DEBUG) DoDebug("tob_inc_recovery: Clearing Granted and Withheld Maneuvers");
	// 7 is the max possible for Crusader
        for(i = 0; i < 7; i++)
	{
		// Clear them all
		DeleteLocalInt(oPC, "ManeuverWithheld" + IntToString(i));
		DeleteLocalInt(oPC, "ManeuverGranted"  + IntToString(i));
        }
}

void BeginCrusaderGranting(object oPC)
{
	// Stops it from being called more than once.
	if (GetLocalInt(oPC, "CrusaderGrantLoop")) return;
	
	// Starts the granting process
	DoCrusaderGranting(oPC, 1);
	SetLocalInt(oPC, "CrusaderGrantLoop", TRUE);
}

void DoCrusaderGranting(object oPC, int nTrip)
{	
	// First round of combat, no granting.
	// Last round of the 5, clear and recover/grant maneuvers
	if (nTrip == 5) // Granted maneuvers empty, restart
		RecoverExpendedManeuvers(oPC, MANEUVER_LIST_CRUSADER);
	else if (nTrip > 1)
		// Rounds 2-4, grant a single maneuver
		GrantWithheldManeuver(oPC, MANEUVER_LIST_CRUSADER);

	// Increment the round counter
	nTrip += 1;
	// If it's greater than round 5, restart
	if (nTrip > 5) nTrip = 1;
	
	// If in combat, keep the loop going
	if (GetIsInCombat(oPC)) DelayCommand(6.0, DoCrusaderGranting(oPC, nTrip)); // Increment counter
	// Recover and stop loop otherwise.
	else
	{
		RecoverExpendedManeuvers(oPC, MANEUVER_LIST_CRUSADER);
		// Resent Int for next time out
		DeleteLocalInt(oPC, "CrusaderGrantLoop");
	}
}