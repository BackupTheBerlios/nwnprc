// ginc_behavior
/*
    support file for behavior related functions (complex sets of actions and conditions)
*/
// ChazM 3/9/05
// DBR 5/30/06 - Added mutator SetIsFocused(). Also encapsulated explicit target check into a function.

const int FOCUSED_FULL 		= 2;	// fully focused
const int FOCUSED_PARTIAL 	= 1;	// will only become unfocused if attacked
const int FOCUSED_STANDARD 	= 0;	// treated as full focus when in conversations
const int FOCUSED_NONE 		= -1;	// same as original scripts
const string VAR_FOCUSED	= "Focused";

// ---------------------------------------------	
// Prototypes
// ---------------------------------------------	
int GetIsFocused(object oTarget=OBJECT_SELF);
void SetIsFocused(int nFocusLevel, object oTarget=OBJECT_SELF); //DBR 5/30/06
void StopBehavior(object oObject);
void StartBehavior(object oObject);
int IsBusy();
int GetIsValidRetaliationTarget(object oTarget, object oRetaliator=OBJECT_SELF); //DBR 5/30/06

// ---------------------------------------------	
// Functions
// ---------------------------------------------	
int GetIsFocused(object oTarget=OBJECT_SELF)
{
    int iFocused = GetLocalInt(oTarget, VAR_FOCUSED);
	if (IsInConversation(oTarget)  && iFocused != FOCUSED_NONE)
	{
		iFocused = FOCUSED_FULL;
	}
	return (iFocused);
}

// Set a creature to be focused     DBR 5/30/06
void SetIsFocused(int nFocusLevel, object oTarget=OBJECT_SELF)
{
	SetLocalInt(oTarget, VAR_FOCUSED, nFocusLevel);
}	
	
// Flag creature's behavior to be stopped
void StopBehavior(object oObject)
{
    SetLocalInt(oObject, "Behavior", 1);
}

// Flag creature's behavior to be started
// (on by defualt)
void StartBehavior(object oObject)
{
    SetLocalInt(oObject, "Behavior", 0);
}


// check if creature is busy doing something else, be it combat, conversation,
// or some other action on the action queue
int IsBusy()
{
    // Behavior flagged to be stopped?
    if (GetLocalInt(OBJECT_SELF, "Behavior") == 1)
        return FALSE;

    if (GetIsInCombat()){
        int iTargetType = GetObjectType(GetAttemptedAttackTarget());
        // only busy if target is a creature.
        if (iTargetType == OBJECT_TYPE_CREATURE)
            return TRUE;
        else if (Random(10)+1 >= 8) {
            //SpeakString ("attacking a non creature");
            ClearAllActions(TRUE);
            return FALSE;
        }
        else
            return TRUE;
    }


    int iAction = GetCurrentAction();
/*
    if (iAction == ACTION_ATTACKOBJECT) {
        SpeakString ("attacking an object");
        int iTargetType = GetObjectType(GetAttackTarget());
        // only busy if target is a creature.
        if (iTargetType == OBJECT_TYPE_CREATURE)
            return TRUE;
        else {
            // SpeakString ("attacking a non creature");
            return FALSE;
        }

        //return FALSE;
    }
*/
    if (IsInConversation(OBJECT_SELF))
        return TRUE;

    if (iAction != ACTION_INVALID)
        return TRUE;

    return FALSE;

}

// This check is run before the default scripts (nw_c2's) explicitly tell a creature to attack a target
// it is NOT checked in Determine Combat Round. 
int GetIsValidRetaliationTarget(object oTarget, object oRetaliator=OBJECT_SELF) 
{
	if (GetPlotFlag(oRetaliator) && !GetIsEnemy(oTarget, oRetaliator))	//please don't attack any neutral or friends if I am plot
		return FALSE; //not cool to attack this guy
	return TRUE; //ok to attack this guy
}
	
	