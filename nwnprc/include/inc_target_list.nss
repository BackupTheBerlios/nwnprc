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
    This is because the system cleans up after itself
    and the object references from which the list is
    built up of are deleted when current script execution
    ends.
    
    Also, do not manipulate the list structure with means
    other than the functions provided here.
    
    Any particular list should be built using only a signle
    bias and ordering direction.
    
    
    Behavior in circumstances other than the recommended
    is non-deterministic. In other words, you've been warned :D
    
    
    One can utilise the insertion bias constants to change
    the ordering of the creatures in the list.
    All orders are descending by default.
*/
//:://////////////////////////////////////////////
//:: Created By: Ornedan
//:: Created On: 18.01.2005
//:: Modified By: Ornedan
//:: Modified On: 15.03.2005
//:://////////////////////////////////////////////


//////////////////////////////////////////////////
/* Public constants                             */
//////////////////////////////////////////////////

// Inserts based on Challenge Rating
const int INSERTION_BIAS_CR       = 1;

// Inserts based on Hit Dice
const int INSERTION_BIAS_HD       = 2;

// Inserts based on the ratio of CurrentHP / MaxHP
const int INSERTION_BIAS_HP_RATIO = 3;

// Inserts based on distance from the object list is being built on
const int INSERTION_BIAS_DISTANCE = 4;

//////////////////////////////////////////////////
/* Public functions                             */
//////////////////////////////////////////////////

// Adds the given object to a list. If no list exists when this is called,
// it is created
// =======================================================================
// oInsert    The object to insert into the list
// oCaster    The object that holds the head of the list.
//            This should be whatever object is casting the
//            spell that uses the list
//
// If either oInsert or oCaster is not valid, nothing happens.
void AddToTargetList(object oInsert, object oCaster, int nInsertionBias = INSERTION_BIAS_CR, int bDescendingOrder = TRUE);


// Gets the head a target list
// ==========================================================
// oCaster    An object a target list has been built on
//
// Returns the head of the list built on oCaster and removes it
// from the list.
// If there are no more entries in the list, return OBJECT_INVALID
object GetTargetListHead(object oCaster);



//////////////////////////////////////////////////
/* Private constants                            */
//////////////////////////////////////////////////

const string TARGET_LIST_HEAD = "TargetListHead";
const string TARGET_LIST_NEXT = "TargetListNext";


//////////////////////////////////////////////////
/* Private functions                            */
//////////////////////////////////////////////////

int GetIsInsertPosition(object oInsert, object oCompare, object oCaster, int nInsertionBias, int bDescendingOrder);



//////////////////////////////////////////////////
/* function definitions                         */
//////////////////////////////////////////////////

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
    if(GetIsInsertPosition(oInsert, oCurrent, oCaster, nInsertionBias, bDescendingOrder))
    {
        SetLocalObject(oCaster, TARGET_LIST_HEAD, oInsert);
        SetLocalObject(oInsert, TARGET_LIST_NEXT, oCurrent);
        // Schedule deletions
        DelayCommand(0.0f, DeleteLocalObject(oCaster, TARGET_LIST_HEAD));
        DelayCommand(0.0f, DeleteLocalObject(oInsert, TARGET_LIST_NEXT));
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
                DelayCommand(0.0f, DeleteLocalObject(oCurrent, TARGET_LIST_NEXT));
                // Some paranoia to make sure the last element of the list always points
                // to invalid
                if(GetIsObjectValid(oNext)){
                    SetLocalObject(oInsert, TARGET_LIST_NEXT, oNext);
                    DelayCommand(0.0f, DeleteLocalObject(oInsert, TARGET_LIST_NEXT));
                }
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
 /* OBSOLETE
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
*/


// This is an internal function intended only for use in inc_target_list.nss
int GetIsInsertPosition(object oInsert, object oCompare, object oCaster, int nInsertionBias, int bDescendingOrder)
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
            bReturn  = (IntToFloat(GetCurrentHitPoints(oInsert)) / ((GetMaxHitPoints(oInsert) > 0) ? IntToFloat(GetMaxHitPoints(oInsert)) : 0.001f))
                        >
                       (IntToFloat(GetCurrentHitPoints(oCompare)) / ((GetMaxHitPoints(oCompare) > 0) ? IntToFloat(GetMaxHitPoints(oCompare)) : 0.001f));
            break;
        case INSERTION_BIAS_DISTANCE:
            bReturn = GetDistanceBetween(oInsert, oCaster) > GetDistanceBetween(oCompare, oCaster);
            break;
        default:
            WriteTimestampedLogEntry("Invalid target selection bias given. Value: " + IntToString(nInsertionBias));
            return TRUE;
    }
    
    return bDescendingOrder ? bReturn : !bReturn;
}