//if you have the PRC installed, uncomment this include and
//uncomment the lines marked with //**** above and below them

#include "sy_inc_random"
#include "prc_alterations"

//****
/*
//****
#include "x2_inc_itemprop"

int GetECL(object oTarget)
{
    return GetHitDice(oTarget);
}
void DoDebug(string sString, object oAdditionalRecipient = OBJECT_INVALID)
{
    SendMessageToPC(GetFirstPC(), sString);
    if(oAdditionalRecipient != OBJECT_INVALID)
        SendMessageToPC(oAdditionalRecipient, sString);
    WriteTimestampedLogEntry(sString);
}

string Get2DACache(string s2DA, string sColumn, int nRow)
{
//StartTimer(OBJECT_SELF, "Get2DACache");
    string sTag = "2DACache_"+s2DA;
    object oWP = GetObjectByTag(sTag);
    if(!GetIsObjectValid(oWP))
        oWP = CreateObject(OBJECT_TYPE_WAYPOINT, "nw_waypoint001", GetStartingLocation(), FALSE, sTag);
    if(!GetIsObjectValid(oWP))
        DoDebug("Get2DACache() problem creating waypoint");
    string sReturn;
    sReturn = GetLocalString(oWP, sColumn+"_"+IntToString(nRow));
    if(sReturn == "****")
        sReturn = "";
    else if(sReturn == "")
    {
        sReturn = Get2DAString(s2DA, sColumn, nRow);
        if(sReturn == "")
            SetLocalString(oWP, sColumn+"_"+IntToString(nRow), "****");
        else
            SetLocalString(oWP, sColumn+"_"+IntToString(nRow), sReturn);
    }
//DoDebug("Timer Get2DACache(): "+StopTimer(OBJECT_SELF, "Get2DACache"));
    return sReturn;
}


int GetACBonus(object oItem)
{
    if(!GetIsObjectValid(oItem)) return 0;

    itemproperty ip = GetFirstItemProperty(oItem);
    int iTotal = 0;

    while(GetIsItemPropertyValid(ip)){
        if(GetItemPropertyType(ip) == ITEM_PROPERTY_AC_BONUS)
            iTotal += GetItemPropertyCostTableValue(ip);
        ip = GetNextItemProperty(oItem);
    }
    return iTotal;
}

int GetBaseAC(object oItem){ return GetItemACValue(oItem) - GetACBonus(oItem); }

void ForceEquip(object oPC, object oItem, int nSlot, int nThCall = 0)
{
    // Sanity checks
    // Make sure the parameters are valid
    if(!GetIsObjectValid(oPC)) return;
    if(!GetIsObjectValid(oItem)) return;
    // Make sure that the object we are attempting equipping is the latest one to be ForceEquipped into this slot
    if(GetIsObjectValid(GetLocalObject(oPC, "ForceEquipToSlot_" + IntToString(nSlot)))
        &&
       GetLocalObject(oPC, "ForceEquipToSlot_" + IntToString(nSlot)) != oItem
       )
        return;

    float fDelay;

    // Check if the equipping has already happened
    if(GetItemInSlot(nSlot, oPC) != oItem)
    {
        // Test and increment the control counter
        if(nThCall++ == 0)
        {
            // First, try to do the equipping non-intrusively and give the target a reasonable amount of time to do it
            AssignCommand(oPC, ActionEquipItem(oItem, nSlot));
            fDelay = 1.0f;
            // Store the item to be equipped in a local variable to prevent contest between two different calls to ForceEquip
            SetLocalObject(oPC, "ForceEquipToSlot_" + IntToString(nSlot), oItem);
        }
        else
        {
            // Nuke the target's action queue. This should result in "immediate" equipping of the item
            AssignCommand(oPC, ClearAllActions());
            AssignCommand(oPC, ActionEquipItem(oItem, nSlot));
            fDelay = 0.1f;
        }

        // Loop
        DelayCommand(fDelay, ForceEquip(oPC, oItem, nSlot, nThCall));
    }
    // It has, so clean up
    else
        DeleteLocalObject(oPC, "ForceEquipToSlot_" + IntToString(nSlot));
}

int HexToInt(string sHex)
{
    if(sHex == "") return 0;                            // Some quick optimisation for empty strings
    sHex = GetStringRight(GetStringLowerCase(sHex), 8); // Trunctate to last 8 characters and convert to lowercase
    if(GetStringLeft(sHex, 2) == "0x")                  // Cut out '0x' if it's still present
        sHex = GetStringRight(sHex, 6);
    string sConvert = "0123456789abcdef";               // The string to index using the characters in sHex
    int nReturn, nHalfByte;
    while(sHex != "")
    {
        nHalfByte = FindSubString(sConvert, GetStringRight(sHex, 1)); // Get the value of the next hexadecimal character
        if(nHalfByte == -1) return 0;                                 // Invalid character in the string!
        nReturn  = nReturn << 4;                                      // Rightshift by 4 bits
        nReturn |= nHalfByte;                                         // OR in the next bits
        sHex = GetStringLeft(sHex, GetStringLength(sHex) - 1);        // Remove the parsed character from the string
    }

    return nReturn;
}

string IntToPaddedString(int nX, int nLength = 4, int nSigned = FALSE)
{
    if(nSigned)
        nLength--;//to allow for sign
    string sResult = IntToString(nX);
    // Trunctate to nLength rightmost characters
    if(GetStringLength(sResult) > nLength)
        sResult = GetStringRight(sResult, nLength);
    // Pad the left side with zero
    while(GetStringLength(sResult) < nLength)
    {
        sResult = "0" +sResult;
    }
    if(nSigned)
    {
        if(nX>=0)
            sResult = "+"+sResult;
        else
            sResult = "-"+sResult;
    }
    return sResult;
}


// Determines the angle between two given locations. Angle returned
// is relative to the first location.
//
// @param lFrom The base location
// @param lTo   The other location
// @return      The angle between the two locations, relative to lFrom
float GetRelativeAngleBetweenLocations(location lFrom, location lTo)
{
    vector vPos1 = GetPositionFromLocation(lFrom);
    vector vPos2 = GetPositionFromLocation(lTo);

    float fDist = GetDistanceBetweenLocations(lFrom, lTo);
    if(fDist == 0.0)
        return 1000.0;
    float fAngle = acos((vPos2.x - vPos1.x) / fDist);
    // The above formula only returns values [0, 180], so test for negative y movement
    if((vPos2.y - vPos1.y) < 0.0f)
        fAngle = 360.0f -fAngle;

    return fAngle;
}




//changes portrait, head, and appearance
//based on the target race with a degree of randomization.
void DoDisguise(int nRace, object oTarget = OBJECT_SELF)
{
    //store current appearance to be safe
//    StoreAppearance(oTarget);
    int nAppearance; //appearance to change into
    int nHeadMax;    //max head ID, changed to random 1-max
    int nGender = GetGender(oTarget);
    int nPortraitMin;//minimum row in portraits.2da
    int nPortraitMax;//maximum row in portraits.2da
    switch(nRace)
    {
        case RACIAL_TYPE_DWARF:
            nAppearance = APPEARANCE_TYPE_DWARF;
            if(nGender == GENDER_MALE)
            {   nHeadMax = 10; nPortraitMin =   9;  nPortraitMax =  17; }
            else
            {   nHeadMax = 12; nPortraitMin =   1;  nPortraitMax =   8; }
            break;
        case RACIAL_TYPE_ELF:
            nAppearance = APPEARANCE_TYPE_ELF;
            if(nGender == GENDER_MALE)
            {   nHeadMax = 10; nPortraitMin =  31;  nPortraitMax =  40; }
            else
            {   nHeadMax = 16; nPortraitMin =  18;  nPortraitMax =  30; }
            break;
        case RACIAL_TYPE_HALFELF:
            nAppearance = APPEARANCE_TYPE_HALF_ELF;
            if(nGender == GENDER_MALE)
            {   nHeadMax = 18; nPortraitMin =  93;  nPortraitMax = 112; }
            else
            {   nHeadMax = 15; nPortraitMin =  67;  nPortraitMax = 92;  }
            break;
        case RACIAL_TYPE_HALFORC:
            nAppearance = APPEARANCE_TYPE_HALF_ORC;
            if(nGender == GENDER_MALE)
            {   nHeadMax = 11; nPortraitMin = 134;  nPortraitMax = 139; }
            else
            {   nHeadMax = 1;  nPortraitMin = 130;  nPortraitMax = 133; }
            break;
        case RACIAL_TYPE_HUMAN:
            nAppearance = APPEARANCE_TYPE_HUMAN;
            if(nGender == GENDER_MALE)
            {   nHeadMax = 18; nPortraitMin = 93;   nPortraitMax = 112; }
            else
            {   nHeadMax = 15; nPortraitMin = 67;   nPortraitMax = 92;  }
            break;
        case RACIAL_TYPE_HALFLING:
            nAppearance = APPEARANCE_TYPE_HALFLING;
            if(nGender == GENDER_MALE)
            {   nHeadMax =  8; nPortraitMin = 61;   nPortraitMax = 66; }
            else
            {   nHeadMax = 11; nPortraitMin = 54;   nPortraitMax = 59;  }
            break;
        case RACIAL_TYPE_GNOME:
            nAppearance = APPEARANCE_TYPE_GNOME;
            if(nGender == GENDER_MALE)
            {   nHeadMax = 11; nPortraitMin = 47;   nPortraitMax = 53; }
            else
            {   nHeadMax =  9; nPortraitMin = 41;   nPortraitMax = 46;  }
            break;
        default: //not a normal race, abort
            return;
    }
    //change the appearance
    SetCreatureAppearanceType(oTarget, nAppearance);

    //need to be delayed a bit otherwise you get "supergnome" and "exploded elf" effects
    AssignCommand(oTarget, ActionDoCommand(SetCreatureBodyPart(CREATURE_PART_RIGHT_SHIN,       d2(), oTarget)));
    AssignCommand(oTarget, ActionDoCommand(SetCreatureBodyPart(CREATURE_PART_LEFT_SHIN,        d2(), oTarget)));
    AssignCommand(oTarget, ActionDoCommand(SetCreatureBodyPart(CREATURE_PART_RIGHT_THIGH,      d2(), oTarget)));
    AssignCommand(oTarget, ActionDoCommand(SetCreatureBodyPart(CREATURE_PART_LEFT_THIGH,       d2(), oTarget)));
    AssignCommand(oTarget, ActionDoCommand(SetCreatureBodyPart(CREATURE_PART_TORSO,            d2(), oTarget)));
    AssignCommand(oTarget, ActionDoCommand(SetCreatureBodyPart(CREATURE_PART_RIGHT_FOREARM,    d2(), oTarget)));
    AssignCommand(oTarget, ActionDoCommand(SetCreatureBodyPart(CREATURE_PART_LEFT_FOREARM,     d2(), oTarget)));
    AssignCommand(oTarget, ActionDoCommand(SetCreatureBodyPart(CREATURE_PART_RIGHT_BICEP,      d2(), oTarget)));
    AssignCommand(oTarget, ActionDoCommand(SetCreatureBodyPart(CREATURE_PART_LEFT_BICEP,       d2(), oTarget)));

    //dont do these body parts, they dont have tattoos and weird things could happen
    //SetCreatureBodyPart(CREATURE_PART_BELT,             d2(), oTarget);
    //SetCreatureBodyPart(CREATURE_PART_NECK,             d2(), oTarget);
    //SetCreatureBodyPart(CREATURE_PART_RIGHT_SHOULDER,   d2(), oTarget);
    //SetCreatureBodyPart(CREATURE_PART_LEFT_SHOULDER,    d2(), oTarget);
    //SetCreatureBodyPart(CREATURE_PART_RIGHT_HAND,       d2(), oTarget);
    //SetCreatureBodyPart(CREATURE_PART_LEFT_HAND,        d2(), oTarget);
    //SetCreatureBodyPart(CREATURE_PART_PELVIS,           d2(), oTarget);
    //SetCreatureBodyPart(CREATURE_PART_RIGHT_FOOT,       d2(), oTarget);
    //SetCreatureBodyPart(CREATURE_PART_LEFT_FOOT,        d2(), oTarget);
    //randomise the head
    AssignCommand(oTarget, ActionDoCommand(SetCreatureBodyPart(CREATURE_PART_HEAD, RandomI(nHeadMax)+1, oTarget)));

    //remove any wings/tails
    SetCreatureWingType(CREATURE_WING_TYPE_NONE, oTarget);
    SetCreatureTailType(CREATURE_TAIL_TYPE_NONE, oTarget);

    int nPortraitID = RandomI(nPortraitMax-nPortraitMin+1)+nPortraitMin;
    string sPortraitResRef = Get2DAString("portraits", "BaseResRef", nPortraitID);
    sPortraitResRef = GetStringLeft(sPortraitResRef, GetStringLength(sPortraitResRef)-1); //trim the trailing _
    SetPortraitId(oTarget, nPortraitID); //do portaitID first cos it overrides resref
    SetPortraitResRef(oTarget, sPortraitResRef);
}


/////////////////////////////////////
// Error Returns
/////////////////////////////////////

const int SDL_SUCCESS = 1;
const int SDL_ERROR_ALREADY_EXISTS = 1001;
const int SDL_ERROR_DOES_NOT_EXIST = 1002;
const int SDL_ERROR_OUT_OF_BOUNDS  = 1003;
//int SDL_ERROR_NO_ZERO_SIZE = 1004;  - Not used
const int SDL_ERROR_NOT_VALID_OBJECT = 1005;

/////////////////////////////////////
// Implementation
/////////////////////////////////////

int array_create(object store, string name)
{
    // error checking
    if(!GetIsObjectValid(store))
        return SDL_ERROR_NOT_VALID_OBJECT;
    else if(GetLocalInt(store,name))
        return SDL_ERROR_ALREADY_EXISTS;
    else
    {
        // Initialize the size (always one greater than the actual size)
        SetLocalInt(store,name,1);
        return SDL_SUCCESS;
    }
}

int array_delete(object store, string name)
{
    // error checking
    int size=GetLocalInt(store,name);
    if (size==0)
        return SDL_ERROR_DOES_NOT_EXIST;

    int i;
    for (i=0; i < size; i++)
    {
        DeleteLocalString(store,name+"_"+IntToString(i));

        // just in case, delete possible object names
        DeleteLocalObject(store,name+"_"+IntToString(i)+"_OBJECT");
    }

    DeleteLocalInt(store,name);

    return SDL_SUCCESS;
}

int array_set_string(object store, string name, int i, string entry)
{
    int size = GetLocalInt(store,name);
    if(size == 0)
        return SDL_ERROR_DOES_NOT_EXIST;
    if(i < 0)
        return SDL_ERROR_OUT_OF_BOUNDS;

    SetLocalString(store,name+"_"+IntToString(i),entry);

    // save size if we've enlarged it
    if(i+2>size)
        SetLocalInt(store,name,i+2);

    return SDL_SUCCESS;
}

int array_set_int(object store, string name, int i, int entry)
{
    return array_set_string(store,name,i,IntToString(entry));
}

int array_set_float(object store, string name, int i, float entry)
{
    return array_set_string(store,name,i,FloatToString(entry));
}

int array_set_object(object store, string name, int i, object entry)
{
    // object is a little more complicated.
    // we want to create an object as a local variable too
    if (!GetIsObjectValid(entry))
        return SDL_ERROR_NOT_VALID_OBJECT;

    int results=array_set_string(store,name,i,"OBJECT");
    if (results==SDL_SUCCESS)
        SetLocalObject(store,name+"_"+IntToString(i)+"_OBJECT",entry);

    return results;
}

string array_get_string(object store, string name, int i)
{
    // error checking
    int size=GetLocalInt(store,name);
    if (size==0 || i>size || i < 0)
        return "";

    return GetLocalString(store,name+"_"+IntToString(i));
}

int array_get_int(object store, string name, int i)
{
    return StringToInt(array_get_string(store,name,i));
}

float array_get_float(object store, string name, int i)
{
    return StringToFloat(array_get_string(store,name,i));
}

object array_get_object(object store, string name, int i)
{
    if(array_get_string(store, name, i) == "OBJECT")
        return GetLocalObject(store,name+"_"+IntToString(i)+"_OBJECT");
    else
        return OBJECT_INVALID;
}

int array_shrink(object store, string name, int size_new)
{
    // error checking
    int size = GetLocalInt(store,name);
    if(size == 0)
        return SDL_ERROR_DOES_NOT_EXIST;
    if(size <= size_new)
        return SDL_SUCCESS;

    int i;
    for(i = size_new; i < size; i++)
    {
        DeleteLocalString(store,name+"_"+IntToString(i));

        // just in case, delete possible object names
        DeleteLocalString(store,name+"_"+IntToString(i)+"_OBJECT");
    }

    SetLocalInt(store,name,size_new+1);

    return SDL_SUCCESS;
}

int array_get_size(object store, string name)
{
    return GetLocalInt(store,name)-1;
}

int array_exists(object store, string name)
{
    if (GetLocalInt(store,name)==0)
        return FALSE;
    else
        return TRUE;
}



//****
*/
//****
