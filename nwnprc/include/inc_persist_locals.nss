#include "inc_item_props"

//returns the token inside oPCs hide
//creates hide and/or token as appropriate
object GetHideToken(object oPC);
// Set oPC's hide container token's local string variable sVarName to sValue
void SetPersistantLocalString(object oPC, string sName, string sValue);
// Set oPC's hide container token's local integer variable sVarName to nValue
void SetPersistantLocalInt(object oPC, string sName, int nValue);
// Set oPC's hide container token's local float variable sVarName to fValue
void SetPersistantLocalFloat(object oPC, string sName, float fValue);
// Set oPC's hide container token's local location variable sVarName to lValue
void SetPersistantLocalLocation(object oPC, string sName, location lValue);
// Set oPC's hide container token's local object variable sVarName to nValue
void SetPersistantLocalObject(object oPC, string sName, object oValue);
// Get oPC's hide container token's local string variable sVarName
// * Return value on error: ""
string GetPersistantLocalString(object oPC, string sName);
// Get oPC's hide container token's local integer variable sVarName
// * Return value on error: 0
int GetPersistantLocalInt(object oPC, string sName);
// Get oPC's hide container token's local float variable sVarName
// * Return value on error: 0.0
float GetPersistantLocalFloat(object oPC, string sName);
// Get oPC's hide container token's local location variable sVarName
location GetPersistantLocalLocation(object oPC, string sName);
// Get oPC's hide container token's local object variable sVarName
// * Return value on error: OBJECT_INVALID
object GetPersistantLocalObject(object oPC, string sName);

object GetHideToken(object oPC)
{
    object oHide = GetPCSkin(oPC);
    object oTest = GetFirstItemInInventory(oHide);
    object oToken;
    while(GetIsObjectValid(oTest))
    {
        if(GetTag(oTest) == "HideToken")
        {
            oToken = oTest;
            break;//exit while loop
        }
        oTest = GetNextItemInInventory(oHide);
    }
    if(!GetIsObjectValid(oToken))
    {
        oTest = GetFirstItemInInventory(oPC);
        while(GetIsObjectValid(oTest))
        {
            if(GetTag(oTest) == "HideToken")
            {
                oToken = oTest;
                break;//exit while loop
            }
            oTest = GetNextItemInInventory(oPC);
        }
    }
    if(!GetIsObjectValid(oToken))
    {
//        oToken = CreateItemOnObject("hidetoken", oPC);
//        AssignCommand(oHide, ActionTakeItem(oToken, oPC));
        oToken = CreateItemOnObject("hidetoken", oHide);
    }
    return oToken;
}

void SetPersistantLocalString(object oPC, string sName, string sValue)
{
    object oToken = GetHideToken(oPC);
    SetLocalString(oToken, sName, sValue);
}

void SetPersistantLocalInt(object oPC, string sName, int nValue)
{
    object oToken = GetHideToken(oPC);
    SetLocalInt(oToken, sName, nValue);
}

void SetPersistantLocalFloat(object oPC, string sName, float fValue)
{
    object oToken = GetHideToken(oPC);
    SetLocalFloat(oToken, sName, fValue);
}

void SetPersistantLocalLocation(object oPC, string sName, location lValue)
{
    object oToken = GetHideToken(oPC);
    SetLocalLocation(oToken, sName, lValue);
}

void SetPersistantLocalObject(object oPC, string sName, object oValue)
{
    object oToken = GetHideToken(oPC);
    SetLocalObject(oToken, sName, oValue);
}

string GetPersistantLocalString(object oPC, string sName)
{
    object oToken = GetHideToken(oPC);
    return GetLocalString(oToken, sName);
}

int GetPersistantLocalInt(object oPC, string sName)
{
    object oToken = GetHideToken(oPC);
    return GetLocalInt(oToken, sName);
}

float GetPersistantLocalFloat(object oPC, string sName)
{
    object oToken = GetHideToken(oPC);
    return GetLocalFloat(oToken, sName);
}

location GetPersistantLocalLocation(object oPC, string sName)
{
    object oToken = GetHideToken(oPC);
    return GetLocalLocation(oToken, sName);
}

object GetPersistantLocalObject(object oPC, string sName)
{
    object oToken = GetHideToken(oPC);
    return GetLocalObject(oToken, sName);
}