// ginc_event_handlers
/*
	event handler related
*/
// ChazM 12/21/05
// ChazM 4/30/06 - Added EventsCleared flag and SafeClearEventHandlers(), SafeRestoreEventHandlers(), added support for remainder of object types
// ChazM 6/16/06 - fixed GetNumScripts(), added ReportEventHandlers()
// 
// void main() {}		
const string EVENTS_CLEARED_FLAG 	= "EH_CLEARED";
const string EVENTS_SAVE_PREFIX 	= "EH_SAVE";

#include "ginc_debug"

int GetEventsClearedFlag(object oObject)
{
	int bEventsCleared = GetLocalInt(oObject, EVENTS_CLEARED_FLAG);
	return (bEventsCleared);	
}

void SetEventsClearedFlag(object oObject, int bFlag)
{
	SetLocalInt(oObject, EVENTS_CLEARED_FLAG, bFlag);
}
/*
int    OBJECT_TYPE_CREATURE         = 1;
int    OBJECT_TYPE_ITEM             = 2;
int    OBJECT_TYPE_TRIGGER          = 4;
int    OBJECT_TYPE_DOOR             = 8;
int    OBJECT_TYPE_AREA_OF_EFFECT   = 16;
int    OBJECT_TYPE_WAYPOINT         = 32;
int    OBJECT_TYPE_PLACEABLE        = 64;
int    OBJECT_TYPE_STORE            = 128;
int    OBJECT_TYPE_ENCOUNTER		= 256;
int    OBJECT_TYPE_LIGHT            = 512;
int    OBJECT_TYPE_PLACED_EFFECT    = 1024;
*/

			
int GetNumScripts(object oObject)
{
	int iObjectType = GetObjectType(oObject); // doesn't appear to have a value for areas and modules
	int iNumScripts = 0;
	
	// see nwscript.nss for list of script event handlers
	switch (iObjectType)
	{
		case OBJECT_TYPE_CREATURE:
			iNumScripts = 13;
			break;	
		case OBJECT_TYPE_ITEM: // items don't have scripts 
			iNumScripts = 0;	
			break;	
		case OBJECT_TYPE_TRIGGER:
			iNumScripts = 7;	
			break;	
		case OBJECT_TYPE_DOOR:
			iNumScripts = 15;	
			break;	
		case OBJECT_TYPE_AREA_OF_EFFECT:
			iNumScripts = 4;	
			break;	
		case OBJECT_TYPE_WAYPOINT:
			iNumScripts = 0;	
			break;	
		case OBJECT_TYPE_PLACEABLE:
			iNumScripts = 15;	
			break;	
		case OBJECT_TYPE_STORE:
			iNumScripts = 2;	
			break;	
		case OBJECT_TYPE_ENCOUNTER:
			iNumScripts = 5;	
			break;	
		case OBJECT_TYPE_LIGHT:
			iNumScripts = 0;	
			break;	
		case OBJECT_TYPE_PLACED_EFFECT:
			iNumScripts = 0;	
			break;	
	}
	return (iNumScripts);	
}

void SaveEventHandlers(object oObject)
{
	string sEventHandler;
	string sVarName;
	int iNumScripts = GetNumScripts(oObject);
	int i;

	for (i=0; i<iNumScripts; i++)
	{
		sEventHandler = GetEventHandler(oObject, i);
		sVarName = EVENTS_SAVE_PREFIX + IntToString(i);
		SetLocalString(oObject, sVarName, sEventHandler);
	}
}

void ClearEventHandlers(object oObject)
{
	string sScriptName = "";
	int iNumScripts = GetNumScripts(oObject);
	int i;

	for (i=0; i<iNumScripts; i++)
	{
		SetEventHandler(oObject, i, sScriptName);
	}
	SetEventsClearedFlag(oObject, TRUE);
}

void RestoreEventHandlers(object oObject)
{
	string sEventHandler;
	string sVarName;
	int iNumScripts = GetNumScripts(oObject);
	int i;

	for (i=0; i<iNumScripts; i++)
	{
		sVarName = EVENTS_SAVE_PREFIX + IntToString(i);
		sEventHandler = GetLocalString(oObject, sVarName);
		SetEventHandler(oObject, i, sEventHandler);
	}
	SetEventsClearedFlag(oObject, FALSE);
}

void DeleteSavedEventHandlers(object oObject)
{
	string sVarName;
	int iNumScripts = GetNumScripts(oObject);
	int i;

	for (i=0; i<iNumScripts; i++)
	{
		sVarName = "EH_SAVE" + IntToString(i);
		DeleteLocalString(oObject, sVarName);
	}
}

// save and clear event handlers if they haven't already been flagged as cleared.
void SafeClearEventHandlers(object oObject)
{
	if (GetEventsClearedFlag(oObject) == FALSE)		
	{
		SaveEventHandlers(oObject);
		ClearEventHandlers(oObject);
	}		
}

//	restore event handlers if they were previously flagged as cleared.
void SafeRestoreEventHandlers(object oObject)
{
	if (GetEventsClearedFlag(oObject) == TRUE)		
	{
		RestoreEventHandlers(oObject);
		DeleteSavedEventHandlers(oObject);
	}			
}
	
void ReportEventHandlers(object oObject)	
{	
	string sEventHandler;
	string sVarName;
	int iNumScripts = GetNumScripts(oObject);
	int i;
	
	int iObjectType = GetObjectType(oObject); // doesn't appear to have a value for areas and modules

	PrettyDebug (" object type of " + GetName(oObject)+ " is " + IntToString(iObjectType));
	PrettyDebug (" iNumScripts =  " + IntToString(iNumScripts));

	for (i=0; i<iNumScripts; i++)
	{
		sEventHandler = GetEventHandler(oObject, i);
		PrettyDebug(" Script " + IntToString(i) + " = " + sEventHandler);
	}
}
	
	