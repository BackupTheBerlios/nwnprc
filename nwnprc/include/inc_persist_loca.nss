//::///////////////////////////////////////////////
//:: Persistant local variables include
//:: inc_persist_loca
//:://////////////////////////////////////////////
/*
    A set of functions for storing local variables
    on a token item stored in the creature's skin.
    Since local variables on items within containers
    are not stripped during serialization, these
    variables persist across module changes and
    server resets.
    
    These functions work on NPCs in addition to PCs,
    but the persitence is mostly useless for them,
    since NPCs are usually not serialized in a way
    that would remove normal locals from them, if
    they are serialized at all.
*/
//:://////////////////////////////////////////////
//:://////////////////////////////////////////////

//////////////////////////////////////////////////
/* Function prototypes                          */
//////////////////////////////////////////////////

// Returns the token item inside the given creature's hide that the persistant
// variables are stored on.
// ---------------------------------------------------------------------------
// oPC      the creature whose token to get
//
// Creates hide and/or token if needed.
// Behaviour is unspecified if this is called on a non-creature object.
object GetHideToken(object oPC);

// Set oPC's hide container token's local string variable sVarName to sValue
void SetPersistantLocalString(object oPC, string sName, string sValue);

// Set oPC's hide container token's local integer variable sVarName to nValue
void SetPersistantLocalInt(object oPC, string sName, int nValue);

// Set oPC's hide container token's local float variable sVarName to fValue
void SetPersistantLocalFloat(object oPC, string sName, float fValue);

// Set oPC's hide container token's local location variable sVarName to lValue
// ---------------------------------------------------------------------------
//
// CAUTION! See note in SetPersistantLocalObject. Location also contains
// an object reference, though it will only break across module changes, not
// across server resets.
void SetPersistantLocalLocation(object oPC, string sName, location lValue);

// Set oPC's hide container token's local object variable sVarName to nValue
// -------------------------------------------------------------------------
//
// CAUTION! Object references are likely (and in some cases, quaranteed) to
// break when transferring across modules or upon server reset. This means
// that persistently stored local objects may not refer to the same object
// after such a change, if they refer to a valid object at all.
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
// -----------------------------------------------------------------
//
// CAUTION! See note in SetPersistantLocalLocation.
location GetPersistantLocalLocation(object oPC, string sName);

// Get oPC's hide container token's local object variable sVarName
// * Return value on error: OBJECT_INVALID
// ---------------------------------------------------------------
//
// CAUTION! See note in SetPersistantLocalObject.
object GetPersistantLocalObject(object oPC, string sName);


// inc_item_props refuses to compile if this is not below the function prototypes.
// Yay for broken circular include support
#include "inc_item_props"

//////////////////////////////////////////////////
/* Function defintions                          */
//////////////////////////////////////////////////

object GetHideToken(object oPC)
{
    object oHide = GetPCSkin(oPC);
    object oToken = GetLocalObject(oPC, "PRC_HideTokenCache");

    if(!GetIsObjectValid(oToken))
    {
        object oTest = GetFirstItemInInventory(oHide);
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

            // Move the token to hide's inventory
            if(GetIsObjectValid(oToken))
                AssignCommand(oHide, ActionTakeItem(oToken, oPC)); // Does this work? - Ornedan
        }
        if(!GetIsObjectValid(oToken))
        {
    //        oToken = CreateItemOnObject("hidetoken", oPC);
    //        AssignCommand(oHide, ActionTakeItem(oToken, oPC));
            oToken = CreateItemOnObject("hidetoken", oHide);
        }

        // Cache the token so that there needn't be multiple loops over an inventory
        SetLocalObject(oPC, "PRC_HideTokenCache", oToken);
        //- If the cache reference is found to break under any conditions, uncomment this.
        //looks like logging off then back on without the server rebooting breaks it
        //I guess because the token gets a new ID, but the local still points to the old one
        //Ive changed it to delete the local in OnClientEnter. Primogenitor
        //DelayCommand(1.0f, DeleteLocalObject(oPC, "PRC_HideTokenCache")); 
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

void DeletePersistantLocalString(object oPC, string sName)
{
    object oToken = GetHideToken(oPC);
    DeleteLocalString(oToken, sName);
}

void DeletePersistantLocalInt(object oPC, string sName)
{
    object oToken = GetHideToken(oPC);
    DeleteLocalInt(oToken, sName);
}

void DeletePersistantLocalFloat(object oPC, string sName)
{
    object oToken = GetHideToken(oPC);
    DeleteLocalFloat(oToken, sName);
}

void DeletePersistantLocalLocation(object oPC, string sName)
{
    object oToken = GetHideToken(oPC);
    DeleteLocalLocation(oToken, sName);
}

void DeletePersistantLocalObject(object oPC, string sName)
{
    object oToken = GetHideToken(oPC);
    DeleteLocalObject(oToken, sName);
}