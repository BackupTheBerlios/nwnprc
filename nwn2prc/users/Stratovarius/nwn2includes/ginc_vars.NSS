// ginc_vars
/*
    Global/local variable related functions
*/
// ChazM 9/22/05
// ChazM 10/01/05 added IsMarkedAsDone(), MarkAsDone(), IsMarkedAsDoneForInt(), MarkAsDoneForInt()
// ChazM 1/31/06 added GetGlobalArrayString(), SetGlobalArrayString(), GetGlobalArrayInt(), SetGlobalArrayInt()
	
//void main() {}
const string DONE_ONCE 	= "DoneOnce";
//-------------------------------------------------
// Function Prototypes
//-------------------------------------------------
	
float GetGlobalIntAsFloat(string sVarName);
int ModifyGlobalInt(string sVarName, int iDelta);
int ModifyLocalInt(object oObject, string sVarName, int iDelta);
void ModifyLocalIntOnFaction(object oPC, string sVarName, int iDelta, int bPCOnly=TRUE);

object GetGlobalObject(string sVarName);
void SetGlobalObject(string sVarName, object oObj);
void DeleteGlobalObject(string sVarName);

int IsMarkedAsDone();
void MarkAsDone();
int IsMarkedAsDoneForInt(int iVal);
void MarkAsDoneForInt(int iVal);

string GetGlobalArrayString(string sVarName, int nVarNum);
void SetGlobalArrayString(string sVarName, int nVarNum, string nValue);
int GetGlobalArrayInt(string sVarName, int nVarNum);
void SetGlobalArrayInt(string sVarName, int nVarNum, int nValue);

//-------------------------------------------------
// Function Definitions
//-------------------------------------------------


// return int as float
float GetGlobalIntAsFloat(string sVarName)
{
	return (IntToFloat(GetGlobalInt(sVarName)));
}


// Change value of Global Int by iDelta amount
int ModifyGlobalInt(string sVarName, int iDelta)
{
	int iNewVal = GetGlobalInt(sVarName) + iDelta;
	SetGlobalInt(sVarName, iNewVal);
	return (iNewVal);
}

// Change value of Local Int by iDelta amount
int ModifyLocalInt(object oObject, string sVarName, int iDelta)
{
	int iNewVal = GetLocalInt(oObject, sVarName) + iDelta;
	SetLocalInt(oObject, sVarName, iNewVal);
	return (iNewVal);
}


void ModifyLocalIntOnFaction(object oPC, string sVarName, int iDelta, int bPCOnly=TRUE)
{
    object oPartyMem = GetFirstFactionMember(oPC, bPCOnly);
    while (GetIsObjectValid(oPartyMem)) 
	{
		ModifyLocalInt(oPartyMem, sVarName, iDelta);
        oPartyMem = GetNextFactionMember(oPC, bPCOnly);
    }
}		
	

// hopefully these 3 funcs will be implemented as functions in NWScript
object GetGlobalObject(string sVarName)
{
	object oMod = GetModule();
	return GetLocalObject(oMod, sVarName);
}

void SetGlobalObject(string sVarName, object oObj)
{
	object oMod = GetModule();
	SetLocalObject(oMod, sVarName, oObj);
}

void DeleteGlobalObject(string sVarName)
{
	object oMod = GetModule();
	DeleteLocalObject(oMod, sVarName);
}	

// done flags
int IsMarkedAsDone()
{
    int iDoneOnce = GetLocalInt(OBJECT_SELF, DONE_ONCE);
	return (iDoneOnce);
}

void MarkAsDone()
{
	SetLocalInt(OBJECT_SELF, DONE_ONCE, TRUE);
}


int IsMarkedAsDoneForInt(int iVal)
{
    int iDoneOnce = GetLocalInt(OBJECT_SELF, DONE_ONCE + IntToString(iVal));
	return (iDoneOnce);
}


void MarkAsDoneForInt(int iVal)
{
	SetLocalInt(OBJECT_SELF, DONE_ONCE + IntToString(iVal), TRUE);
}


// *** Global Array Functions

// Returns a string, from nVarNum in the array
string GetGlobalArrayString(string sVarName, int nVarNum)
{
    string sFullVarName = sVarName + IntToString(nVarNum) ;
    return GetGlobalString(sFullVarName);
}

// Sets the string at nVarNum position
void SetGlobalArrayString(string sVarName, int nVarNum, string nValue)
{
    string sFullVarName = sVarName + IntToString(nVarNum) ;
    SetGlobalString(sFullVarName, nValue);
}

// Returns an integer, from nVarNum in the array
int GetGlobalArrayInt(string sVarName, int nVarNum)
{
    string sFullVarName = sVarName + IntToString(nVarNum) ;
    return GetGlobalInt(sFullVarName);
}


//    Sets the integer at nVarNum position
void SetGlobalArrayInt(string sVarName, int nVarNum, int nValue)
{
    string sFullVarName = sVarName + IntToString(nVarNum) ;
    SetGlobalInt(sFullVarName, nValue);
}
