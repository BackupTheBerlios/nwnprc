//::///////////////////////////////////////////////
//:: Target list management functions include
//:: inc_target_list
//::///////////////////////////////////////////////
/*
    This is a set of functions intended to be used in
    spellscripts for getting a set of targets according
    to CR.
    
    The list is built on the objects making up the list,
    so it should be extracted from this system if it is
    to be used for longer than the duration of a single
    spellscript.
    NOTE! Longer duration includes DelayCommand
    
    Also, do not manipulate the list structure with means
    other than the functions provided here.
    
    Any particular list should be built using only a signle
    bias and ordering direction.
    
    
    Behavior in circumstances other than the recommended
    is non-deterministic. In other words, you've been warned :D
    
    
    One can utilise the insertion bias constants to change
    the ordering of the creatures in the list.
    All orders are descending by default.
    
    PurgeTargetList should always be called before
    exiting a spellscript that utilises these functions.
*/
//:://////////////////////////////////////////////
//:: Created By: Ornedan
//:: Created On: 18.01.2005
//:://////////////////////////////////////////////


const string TARGET_LIST_HEAD = "TargetListHead";
const string TARGET_LIST_NEXT = "TargetListNext";

const int INSERTION_BIAS_CR       = 1;
const int INSERTION_BIAS_HD       = 2;
const int INSERTION_BIAS_HP_RATIO = 3;



void AddToTargetList(object oInsert, object oCaster, int nInsertionBias = INSERTION_BIAS_CR, int bDescendingOrder = TRUE);
object GetTargetListHead(object oCaster);
void PurgeTargetList(object oCaster);

int GetIsInsertPosition(object oInsert, object oCompare, int nInsertionBias, int bDescendingOrder);


/* Adds the object given such location in the target list where all
 * the objects after it have lower CR than it does.
 * Inserting to an empty list will also work.
 *
 *   oInsert    - The object to insert into the list
 *   oCaster    - The object that holds the head of the list.
 *                This should be whatever object is casting the
 *                spell that uses the list
 *
 * If either oInsert or oCaster is not valid, nothing happens.
 */
void AddToTargetList(object oInsert, object oCaster, int nInsertionBias = INSERTION_BIAS_CR, int bDescendingOrder = TRUE)
{
	if(!GetIsObjectValid(oInsert) ||
	   !GetIsObjectValid(oCaster))
	{
		WriteTimestampedLogEntry("AddToTargetList called with an invalid parameter");
		return;
	}
	
	object oCurrent = GetLocalObject(oCaster, TARGET_LIST_HEAD);
	
	// If the queue is empty, or the insertable just happens to belong at the head
	if(GetIsInsertPosition(oInsert, oCurrent, nInsertionBias, bDescendingOrder))
	{
		SetLocalObject(oCaster, TARGET_LIST_HEAD, oInsert);
		SetLocalObject(oInsert, TARGET_LIST_NEXT, oCurrent);
	}// end if - insertable is the new head of the list
	else
	{
		object oNext = GetLocalObject(oCurrent, TARGET_LIST_NEXT);
		int bDone = FALSE;
		while(!bDone)
		{
			if(GetIsInsertPosition(oInsert, oNext, nInsertionBias, bDescendingOrder))
			{
				SetLocalObject(oCurrent, TARGET_LIST_NEXT, oInsert);
				
				// Some paranoia to make sure the last element of the list always points
				// to invalid
				if(GetIsObjectValid(oNext))
					SetLocalObject(oInsert, TARGET_LIST_NEXT, oNext);
				else
					DeleteLocalObject(oInsert, TARGET_LIST_NEXT);
				
				bDone = TRUE;
			}// end if - this is the place to insert
			else
			{
				oCurrent = oNext;
				oNext = GetLocalObject(oCurrent, TARGET_LIST_NEXT);
			}// end else - get next object in the list
		}// end while - loop through the list, looking for the position to insert this creature
	}// end else - the insertable creature is to be in a position other than the head
}


/* Gets the head of a target list held by oCaster.
 * The object is removed from the list and returned. If either the head or oCaster
 * are not valid, OBJECT_INVALID will be returned.
 */
object GetTargetListHead(object oCaster)
{
	object oReturn = GetLocalObject(oCaster, TARGET_LIST_HEAD);
	SetLocalObject(oCaster, TARGET_LIST_HEAD, GetLocalObject(oReturn, TARGET_LIST_NEXT));
	DeleteLocalObject(oReturn, TARGET_LIST_NEXT);
	
	return oReturn;
}


/* Removes the list of target objects held by oCaster 
 * This should be called once the list is no longer used by the script that needed it
 * Failure to do so may cause problems
 */
void PurgeTargetList(object oCaster)
{
	object oCurrent = GetLocalObject(oCaster, TARGET_LIST_HEAD);
	object oNext;
	while(GetIsObjectValid(oCurrent))
	{
		oNext = GetLocalObject(oCurrent, TARGET_LIST_NEXT);
		DeleteLocalObject(oCurrent, TARGET_LIST_NEXT);
		oCurrent = oNext;
	}// end while - loop through the list erasing the links
}



// This is an internal function intended only for use in inc_target_list.nss
int GetIsInsertPosition(object oInsert, object oCompare, int nInsertionBias, int bDescendingOrder)
{		
	int bReturn;
	
	switch(nInsertionBias)
	{
		case INSERTION_BIAS_CR:
			bReturn  = GetChallengeRating(oInsert) > GetChallengeRating(oCompare);
			break;
		case INSERTION_BIAS_HD:
			bReturn  = GetHitDice(oInsert) > GetHitDice(oCompare);
			break;
		case INSERTION_BIAS_HP_RATIO:
			bReturn  = (IntToFloat(GetCurrentHitPoints(oInsert)) / IntToFloat(GetMaxHitPoints(oInsert)))
			            >
			           (IntToFloat(GetCurrentHitPoints(oCompare)) / IntToFloat(GetMaxHitPoints(oCompare)));
			break;
		default:
			WriteTimestampedLogEntry("Invalid target selection bias given. Value: " + IntToString(nInsertionBias));
			return TRUE;
	}
	
	
	return bDescendingOrder ? bReturn : !bReturn;
}