//::///////////////////////////////////////////////
//:: Name           Random Area Linker include
//:: FileName       ral_inc
//:: Copyright (c) 2001 Bioware Corp.
//:://////////////////////////////////////////////
/*
    This file is the core include for the RAL system.
    It assumes that the areas to use with RAL are
    all tagged matching the constant RAL_TAG.
    The resrefs of the areas must be RAL_XX_YYY where
    XX  is a 2-digit padded number of the region
    YYY is a 3-digit padded consecutive number

    All the objects in a particular transition type
    should share the same tag. If you wish to link
    to a different type, set a variable called
    RAL_TARGETTAG to the tag of the target to use.
*/
//:://////////////////////////////////////////////
//:: Created By: Primogenitor
//:: Created On: 28/01/06
//:://////////////////////////////////////////////


//This is the major function to use in most cases
//oPC is the object to portal. If not specified
//  it uses GetEnteringObject(), GetLastUsedBy(),
//  then GetClickingObject(). If all fail, it aborts
//oTransition is the object to portal from. Defaults
//  to OBJECT_SELF if not specified
void RAL_DoTransition(object oPC = OBJECT_INVALID, object oTransition = OBJECT_SELF);

//This is used to get the object to link to for a transition
//oSelf is the object to anchor the transition to
//sTag is the tag to use for the transition. If not specified
//  it uses oSelfs tag.
//This assumes that there is at least one target in each region
object RAL_GetNextDoor(object oSelf = OBJECT_SELF, string sTag = "");

//This is used to reset all the links
//Used so that the RAL will reset and appear to be different
void RAL_ClearTransitionTargets();

//This is the variable name the transition target object is stored as
const string RAL_LOCAL_NAME     = "RAL_TransitionTarget";
//this is the tag that areas should be given
const string RAL_TAG            = "ral_area";
//these control the lengths of the parts of the areas resref
const int    RAL_ID_LENGTH      = 3;
const int    RAL_REGION_LENGTH  = 2;
//This event is signalled to an area when a link is established to it
//may fire multiple tiles for one area for the same setup
const int    RAL_SETUP_EVENT_ID = 2107;
//This event is signalled to an area when transition targets are cleared
const int    RAL_CLEAR_EVENT_ID = 2108;
//this is used to link to different tags
const string RAL_TARGETTAG      = "RAL_TARGETTAG";
//this is the delay between one transition and the next
const float RAL_TRANSIT_DELAY = 60.0;
//tis is the maximum distance between party memebers
const float RAL_TRANSIT_DIST = 10.0;

#include "prc_gateway"


int RAL_GetRegionOfObject(object oObject = OBJECT_SELF)
{
    object oArea = GetArea(oObject);
    string sTag = GetTag(oArea);
//DoDebug("RAL_GetRegionOfObject(): sTag = "+sTag);
    sTag = GetStringRight(sTag, GetStringLength(sTag)-4);//trim RAL_
    int nRegionType = StringToInt(GetStringLeft(sTag, RAL_REGION_LENGTH));
//DoDebug("RAL_GetRegionOfObject(): nRegionType = "+IntToString(nRegionType));
    return nRegionType;
}

object RAL_GetDungeonArea(int nAreaID, int nRegionType = 0)
{
//DoDebug("RAL_GetDungeonArea("+IntToString(nAreaID)+", "+IntToString(nRegionType)+")");
    if(nRegionType == 0) nRegionType = RAL_GetRegionOfObject();
    if(nRegionType == 0) nRegionType = GetLocalInt(GetModule(), "DungeonRegionID");
    string sResRef ="RAL_"+IntToPaddedString(nRegionType, RAL_REGION_LENGTH)+
        "_"+IntToPaddedString(nAreaID, RAL_ID_LENGTH);
    sResRef = GetStringLowerCase(sResRef);//resrefs area always lowercase
//DoDebug("RAL_GetDungeonArea(): sResRef = "+sResRef);
    int i;
    object oArea = GetObjectByTag(RAL_TAG, i);
    while(GetIsObjectValid(oArea))
    {
        if(GetResRef(oArea) == sResRef)
            return oArea;
        i++;
        oArea = GetObjectByTag(RAL_TAG, i);
    }
    if(!GetIsObjectValid(oArea))
        return OBJECT_INVALID;
    return oArea;
}

object RAL_GetFirstDungeonArea(int nRegionType = 0)
{
//DoDebug("RAL_GetFirstDungeonArea("+IntToString(nRegionType)+")");
    if(nRegionType == 0)
        nRegionType = RAL_GetRegionOfObject();
    if(nRegionType == 0)
        nRegionType = GetLocalInt(GetModule(), "DungeonRegionID");
    if(nRegionType == 0)
    {
        //random region
        int nRegionCount = 1;
        object oArea = RAL_GetDungeonArea(1, nRegionCount);
        while(GetIsObjectValid(oArea))
        {
            nRegionCount++;
            oArea = RAL_GetDungeonArea(1, nRegionCount);
        }
        nRegionCount--;
//DoDebug("RAL_GetFirstDungeonArea(): nRegionCount = "+IntToString(nRegionCount));
        nRegionType = Random(nRegionCount)+1;
        SetLocalInt(GetModule(), "DungeonRegionID", nRegionType);
        DelayCommand(0.0, DeleteLocalInt(GetModule(), "DungeonRegionID"));
    }
    object oArea = RAL_GetDungeonArea(1, nRegionType);
    SetLocalInt(GetModule(), "DungeonAreaID_"+IntToString(nRegionType), 1);
    return oArea;
}

object RAL_GetNextDungeonArea(int nRegionType = 0)
{
//DoDebug("RAL_GetNextDungeonArea("+IntToString(nRegionType)+")");
    if(nRegionType == 0)
        nRegionType = RAL_GetRegionOfObject();
    if(nRegionType == 0)
        nRegionType = GetLocalInt(GetModule(), "DungeonRegionID");
    int nAreaID = GetLocalInt(GetModule(), "DungeonAreaID_"+IntToString(nRegionType));
    nAreaID++;
    object oArea = RAL_GetDungeonArea(nAreaID, nRegionType);
    SetLocalInt(GetModule(), "DungeonAreaID_"+IntToString(nRegionType), nAreaID);
    return oArea;
}

void RAL_ClearTransitionTargets()
{
//DoDebug("ClearTransitionTargets()");
    int nRegionID = 1;
    object oArea = RAL_GetFirstDungeonArea(nRegionID);
    while(GetIsObjectValid(oArea))
    {
        object oArea2 = oArea;
        while(GetIsObjectValid(oArea2))
        {
            SignalEvent(GetArea(oArea2),
                EventUserDefined(RAL_CLEAR_EVENT_ID));
            object oTest = GetFirstObjectInArea(oArea2);
            while(GetIsObjectValid(oTest))
            {
                DeleteLocalObject(oTest, RAL_LOCAL_NAME);
                oTest = GetNextObjectInArea(oArea2);
            }
            oArea2 = RAL_GetNextDungeonArea(nRegionID);
        }
        nRegionID++;
        oArea = RAL_GetFirstDungeonArea(nRegionID);
    }
    oArea = GetArea(OBJECT_SELF);//fudge for hub
    object oTest = GetFirstObjectInArea(oArea);
    while(GetIsObjectValid(oTest))
    {
        DeleteLocalObject(oTest, RAL_LOCAL_NAME);
        oTest = GetNextObjectInArea(oArea);
    }
}

object RAL_GetNextDoor(object oSelf = OBJECT_SELF, string sTag = "")
{
//DoDebug("RAL_GetNextDoor("+GetName(oSelf)+", "+sTag+")");
    //check if already has a transition assigned
    object oTarget = GetLocalObject(oSelf, RAL_LOCAL_NAME);
    if(GetIsObjectValid(oTarget))
        return oTarget;
    if(sTag == "")
        sTag = GetTag(oSelf);
    //variables well need later
    int nAreaCount;
    int nDoorCount;
    int nAreaID;
    object oArea = RAL_GetFirstDungeonArea();
    while(GetIsObjectValid(oArea))
    {
        nAreaCount++;
        oArea = RAL_GetNextDungeonArea();
    }
//DoDebug("RAL_GetNextDoor(): nAreaCount = "+IntToString(nAreaCount));
    nDoorCount = 0;
    while(nDoorCount == 0)
    {
        nDoorCount = 0;
        nAreaID = RandomI(nAreaCount)+1;
        oArea = RAL_GetDungeonArea(nAreaID);
        object oTest = GetFirstObjectInArea(oArea);
        if(!GetIsObjectValid(oArea))
            return OBJECT_INVALID;
        while(GetIsObjectValid(oTest) && oArea != GetArea(OBJECT_SELF))
        {
            if(GetTag(oTest) == sTag
                && !GetIsObjectValid(GetLocalObject(oTest, RAL_LOCAL_NAME))
                && oTest != oSelf)
                nDoorCount++;
            oTest = GetNextObjectInArea(oArea);
        }
    }
//DoDebug("RAL_GetNextDoor():nDoorCount = "+IntToString(nDoorCount));
    int nDoorID = RandomI(nDoorCount)+1;
    //now re-get the random door selected
    nDoorCount = 0;
    object oTest = GetFirstObjectInArea(oArea);
    while(GetIsObjectValid(oTest))
    {
        if(GetTag(oTest) == sTag
            && !GetIsObjectValid(GetLocalObject(oTest, RAL_LOCAL_NAME))
                && oTest != oSelf)
            nDoorCount++;
        if(nDoorCount == nDoorID)
        {
            oTarget = oTest;
            break;// end while loop
        }
        oTest = GetNextObjectInArea(oArea);
    }
    if(!GetIsObjectValid(oTarget))
        return oTarget;
    SetLocalObject(oSelf, RAL_LOCAL_NAME, oTarget);
    SetLocalObject(oTarget, RAL_LOCAL_NAME, oSelf);
    return oTarget;
}

void RAL_DoTransition(object oPC = OBJECT_INVALID, object oTransition = OBJECT_SELF)
{
    if(!GetIsObjectValid(oPC))
        oPC = GetEnteringObject();
    if(!GetIsObjectValid(oPC))
        oPC = GetLastUsedBy();
    if(!GetIsObjectValid(oPC))
        oPC = GetClickingObject();
    if(!GetIsObjectValid(oPC))
        oPC = GetPCSpeaker();
    if(!GetIsObjectValid(oPC))
    {
        DoDebug("RAL_DoTransition(): oPC is not valid");
        return;
    }
    //time check
    if(GetLocalInt(oTransition, "RAL_TRANSIT_DELAY"))
    {
        FloatingTextStringOnCreature("You cannot leave so soon after arriving", oPC);
        return;
    }
    //distance check
    object oTest = GetFirstFactionMember(oPC, FALSE);
    float fDist = GetDistanceBetween(oTransition, oTest);
    while(GetIsObjectValid(oTest)
        && fDist < RAL_TRANSIT_DIST
        && fDist > 0.0)
    {
        oTest = GetNextFactionMember(oPC, FALSE);
        fDist = GetDistanceBetween(oPC, oTest);
    }
    if(GetIsObjectValid(oTest)
        && (fDist > RAL_TRANSIT_DIST
            || fDist == 0.0))
    {
        FloatingTextStringOnCreature("You must gather your party before venturing forth", oPC);
        return;
    }
    string sTag = GetLocalString(oTransition, RAL_TARGETTAG);
    object oTarget = RAL_GetNextDoor(oTransition, sTag);
    if(!GetIsObjectValid(oTarget))
    {
        DoDebug("RAL_DoTransition(): oTarget is not valid");
        return;
    }
    //dont enter through a trapped door or door-like placeable
    if(GetObjectType(oTarget) == OBJECT_TYPE_DOOR
        || GetObjectType(oTarget) == OBJECT_TYPE_PLACEABLE)
    {
        if(GetObjectType(oTarget) == OBJECT_TYPE_DOOR)
            AssignCommand(oTarget, ActionOpenDoor(oTarget));
        else if(GetObjectType(oTarget) == OBJECT_TYPE_PLACEABLE)
            AssignCommand(oTarget, PlayAnimation(ANIMATION_PLACEABLE_OPEN));
        SetLocked(oTarget, FALSE);
        SetTrapActive(oTarget, FALSE);
    }
    SignalEvent(GetArea(oTarget),
        EventUserDefined(RAL_SETUP_EVENT_ID));
    AssignCommand(oPC, JumpToObject(oTarget));
    SetLocalInt(oTransition, "RAL_TRANSIT_DELAY", TRUE);
    DelayCommand(RAL_TRANSIT_DELAY, DeleteLocalInt(oTransition, "RAL_TRANSIT_DELAY"));
    SetLocalInt(oTarget, "RAL_TRANSIT_DELAY", TRUE);
    DelayCommand(RAL_TRANSIT_DELAY, DeleteLocalInt(oTarget, "RAL_TRANSIT_DELAY"));
}
