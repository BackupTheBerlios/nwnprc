
float floatModulo(float f1, float f2);
void DrawBeam(location lFrom, location lTo, int nVFX, string sFromName = "", string sToName = "", float fDuration = 500.0);
location GetNearestWalkableLocation(location lLoc);

//Original by Themicles
//http://nwn.bioware.com/forums/viewtopic.html?topic=447343&forum=47
//Reposted & edited by Primogenitor
//This uses the GetAreaWidth and GetAreaHeight
//functions by Knat & Zaddix avaliable at:
//http://nwn.bioware.com/forums/viewpost.html?topic=234960&post=2087696&forum=47
//lValidLocation        Location to check
//bIsWalkable           Copies nearest creature, may cause lag if used lots
//                      If >1 creature must be within this distance
//                      if >100, this distance is divided by 100
int GetIsLocValid(location lValidLocation, int bIsWalkable = FALSE);

location GetFreeLocation(location lStart, float fAngle, float fGap = 5.0, float fMaxDist = -1.0);

int GetIsLocationInTrigger(location lLoc, object oTrigger = OBJECT_INVALID);
object GetNearestTriggerToLocationWithTag(location lLoc, string sTag);

float floatModulo(float f1, float f2)
{
    int n1 = FloatToInt(f1*10000);
    int n2 = FloatToInt(f2*10000);
    int n3 = n1%n2;
    float f3 = IntToFloat(n3)/10000.0;
//DoDebug(FloatToString(f1)+" % "+FloatToString(f2)+" = "+FloatToString(f3));
    return f3;
}

void DrawBeam(location lFrom, location lTo, int nVFX, string sFromName = "", string sToName = "", float fDuration = 500.0)
{
    if(!RAD_DEBUG)
        return;
    object oCentre = CreateObject(OBJECT_TYPE_PLACEABLE, RAD_DEBUG_PLCAEABLE_RESREF, lFrom);
    DestroyObject(oCentre, fDuration);
    SetName(oCentre, sFromName);

    effect eBeam = EffectBeam(nVFX, oCentre, BODY_NODE_CHEST);

    object oDEBUG = CreateObject(OBJECT_TYPE_PLACEABLE, RAD_DEBUG_PLCAEABLE_RESREF,lTo);
    ApplyEffectToObject(DURATION_TYPE_TEMPORARY, eBeam, oDEBUG, 99999.9);
    SetName(oDEBUG, sToName);
    DestroyObject(oDEBUG, fDuration);
}

location GetNearestWalkableLocation(location lLoc)
{
    object oCopy = CreateObject(OBJECT_TYPE_CREATURE, RAD_DUMMY_RESREF, lLoc);
    AssignCommand(oCopy, SetIsDestroyable(TRUE));
    DestroyObject(oCopy); //this doesnt take effect until the end of the script
    ApplyEffectToObject(DURATION_TYPE_PERMANENT, EffectCutsceneGhost(), oCopy);
    //this should cut down on heard/seen events I hope!
    ApplyEffectToObject(DURATION_TYPE_PERMANENT, EffectBlindness(), oCopy);
    ApplyEffectToObject(DURATION_TYPE_PERMANENT, EffectDeaf(), oCopy);
    ApplyEffectToObject(DURATION_TYPE_PERMANENT, EffectEthereal(), oCopy);
    location lReturn = GetLocation(oCopy);
    return lReturn;
}

int GetIsLocValid(location lValidLocation, int bIsWalkable = FALSE)
{
    //Setup location information.
    vector vPos = GetPositionFromLocation(lValidLocation);
    float fLocX = vPos.x;
    float fLocY = vPos.y;
    float fLocZ = vPos.z;
    //check its not equal to a null location
    location lNull;
    if(lValidLocation == lNull)
        return FALSE;
    //check no part is negative
    if(fLocX < 0.0
        || fLocY < 0.0)
        //z can be negative for placeables
        return FALSE;
    //Setup area information.
    object oArea = GetAreaFromLocation(lValidLocation);
    //check area object is valid
    if(!GetIsObjectValid(oArea))
        return FALSE;
    float fAreaX = IntToFloat(GetAreaSize(AREA_WIDTH, oArea)*10);
    float fAreaY = IntToFloat(GetAreaSize(AREA_HEIGHT, oArea)*10);
    //check x and y are within bounds
    if(fLocX > fAreaX
        || fLocY > fAreaY)
    //cant check z max without spawning
        return FALSE;
    if(bIsWalkable)
    {
        location lTest = GetNearestWalkableLocation(lValidLocation);
        //check location distances
        float fDistance = GetDistanceBetweenLocations(lTest, lValidLocation);
        float fWalkableDistance = IntToFloat(bIsWalkable);
        if(fWalkableDistance > 100.0)
            fWalkableDistance /= 100.0;
        if(bIsWalkable == TRUE)
        {
            if(lValidLocation != lTest)
                return FALSE;
        }
        else if(fDistance > fWalkableDistance)
            return FALSE;
    }
    //all checks passed, valid location
    return TRUE;
}

location GetFreeLocation(location lStart, float fAngle, float fGap = 5.0, float fMaxDist = -1.0)
{
    location lInvalid;
    if(fGap <= 0.0)
        return lInvalid;
    if(fMaxDist > 0.0
        && fGap > fMaxDist)
    {
//        DoDebug("GetFreeLocation() gap larger than max, capping");
        fGap = fMaxDist;
    }
    float fDist = fGap;
    vector vStart = GetPositionFromLocation(lStart);
    vector vTarget = GetChangedPosition(vStart, fDist, fAngle);
    object oArea = GetAreaFromLocation(lStart);

    location lTest = Location(oArea, vTarget, fAngle);
    location lOld = lStart;
    while(GetIsLocValid(lTest, 101)
        && LineOfSightVector(vStart, vTarget)
        && (fMaxDist < 0.0 || fMaxDist > fDist))
    {
        fDist += fGap;
        vTarget = GetChangedPosition(vStart, fDist, fAngle);
        lOld = lTest;
        lTest = Location(oArea, vTarget, fAngle);
    }
    //backtrack a bit
    lTest = lOld;

    //retest with smaller gap
    if(fGap>1.0)
    {
        if(fMaxDist < 0.0)
            lTest = GetFreeLocation(lTest, fAngle, fGap*0.5, -1.0);
        else if(fMaxDist > fDist)
            lTest = GetFreeLocation(lTest, fAngle, fGap*0.5, fMaxDist-fDist);
    }

    return lTest;
}

struct room
{
    location lE;
    location lNE;
    location lN;
    location lNW;
    location lW;
    location lSW;
    location lS;
    location lSE;
    location lCenter;
    float    fNS;
    float    fEW;
};

struct room GetRoom(location lStart, float fRoomMinSize = 8.0,
    float fRoomMinArea = 100.0, float fShapeLimit = 45.0,
    float fFreeLocationGap = 5.0, float fRoomMaxSize = -1.0)
{
    struct room rRoom;

    location lEast  = GetFreeLocation(lStart,    0.0, fFreeLocationGap, fRoomMaxSize);
    location lNE    = GetFreeLocation(lStart,   45.0, fFreeLocationGap, fRoomMaxSize);
    location lNorth = GetFreeLocation(lStart,   90.0, fFreeLocationGap, fRoomMaxSize);
    location lNW    = GetFreeLocation(lStart,  135.0, fFreeLocationGap, fRoomMaxSize);
    location lWest  = GetFreeLocation(lStart,  180.0, fFreeLocationGap, fRoomMaxSize);
    location lSW    = GetFreeLocation(lStart,  225.0, fFreeLocationGap, fRoomMaxSize);
    location lSouth = GetFreeLocation(lStart,  270.0, fFreeLocationGap, fRoomMaxSize);
    location lSE    = GetFreeLocation(lStart,  315.0, fFreeLocationGap, fRoomMaxSize);

    vector vNorth   = GetPositionFromLocation(lNorth);
    vector vSouth   = GetPositionFromLocation(lSouth);
    vector vEast    = GetPositionFromLocation(lEast);
    vector vWest    = GetPositionFromLocation(lWest);
    vector vNE      = GetPositionFromLocation(lNE);
    vector vNW      = GetPositionFromLocation(lNW);
    vector vSE      = GetPositionFromLocation(lSE);
    vector vSW      = GetPositionFromLocation(lSW);

    float fYMax = (vNorth.y+vNE.y+vNW.y)/3.0; //average not absolute
    float fYMin = (vSouth.y+vSE.y+vSW.y)/3.0;
    float fXMax = (vEast.x +vNE.x+vSE.x)/3.0;
    float fXMin = (vWest.x +vNW.x+vSW.x)/3.0;

    float fXSize = fXMax-fXMin;
    float fYSize = fYMax-fYMin;
    float fArea = fXSize*fYSize;

    float fZAv = (vNorth.z+vSouth.z+vEast.z+vWest.z+vNW.z+vNW.z+vSE.z+vSW.z)/8.0;
    float fXAv = (fXMax+fXMin)/2.0;
    float fYAv = (fYMax+fYMin)/2.0;
    vector vAverage = Vector(fXAv, fYAv, fZAv);
    location lAverage = Location(GetArea(OBJECT_SELF), vAverage, 0.0);
    lAverage = GetNearestWalkableLocation(lAverage);


    //sanity checks
    //and room too small
    //and angles too weird
    //and can see average
    float fEast = GetRelativeAngleBetweenLocations(lStart, lEast);
    float fWest = GetRelativeAngleBetweenLocations(lStart, lWest);
    float fSouth = GetRelativeAngleBetweenLocations(lStart, lSouth);
    float fNorth = GetRelativeAngleBetweenLocations(lStart, lNorth);
    if(fXMax <= fXMin
        || fYMax <= fYMin
        || fXSize<  fRoomMinSize
        || fYSize<  fRoomMinSize
        || fArea <  fRoomMinArea
        || fNorth<  DIRECTION_NORTH-fShapeLimit
        || fNorth>  DIRECTION_NORTH+fShapeLimit
        || fWest < DIRECTION_WEST-fShapeLimit
        || fWest > DIRECTION_WEST+fShapeLimit
        || fSouth< DIRECTION_SOUTH-fShapeLimit
        || fSouth> DIRECTION_SOUTH+fShapeLimit
        || (fEast < 650.0-fShapeLimit
            && fEast > fShapeLimit)
        || !LineOfSightVector(vAverage, GetPositionFromLocation(lStart))
        )
    {
        //DoDebug("Room Invalid");
             /*
        if(fXMax <= fXMin)
            DoDebug("GetRoom() : room invalid : fXSize = "+FloatToString(fXSize));
        if(fYMax <= fYMin)
            DoDebug("GetRoom() : room invalid : fYSize = "+FloatToString(fYSize));
        if(fArea <   20.0)
            DoDebug("GetRoom() : room invalid : fArea = "+FloatToString(fArea));
        if((fEast < 315.0 && fEast > 45.0))
            DoDebug("GetRoom() : room invalid : fEast = "+FloatToString(fEast));
        if(fWest < 135.0 || fWest > 225.0)
            DoDebug("GetRoom() : room invalid : fWest = "+FloatToString(fWest));
        if(fSouth< 225.0 || fSouth> 315.0)
            DoDebug("GetRoom() : room invalid : fSouth = "+FloatToString(fSouth));
        if(fNorth<  45.0 || fNorth> 135.0)
            DoDebug("GetRoom() : room invalid : fNorth = "+FloatToString(fNorth));
        if(!LineOfSightVector(vAverage, GetPositionFromLocation(lStart)))
            DoDebug("GetRoom() : room invalid : no line of sight");
                         */
        struct room rInvalid;
        return rInvalid;
    }
//DEBUG
//mark the room out
DrawBeam(lStart, lEast,  VFX_BEAM_SILENT_FIRE);
DrawBeam(lStart, lNE,    VFX_BEAM_SILENT_FIRE);
DrawBeam(lStart, lNorth, VFX_BEAM_SILENT_FIRE);
DrawBeam(lStart, lNW,    VFX_BEAM_SILENT_FIRE);
DrawBeam(lStart, lWest,  VFX_BEAM_SILENT_FIRE);
DrawBeam(lStart, lSW,    VFX_BEAM_SILENT_FIRE);
DrawBeam(lStart, lSouth, VFX_BEAM_SILENT_FIRE);
DrawBeam(lStart, lSE,    VFX_BEAM_SILENT_FIRE);
DrawBeam(lAverage, lEast,  VFX_BEAM_SILENT_MIND);
DrawBeam(lAverage, lNE,    VFX_BEAM_SILENT_MIND);
DrawBeam(lAverage, lNorth, VFX_BEAM_SILENT_MIND);
DrawBeam(lAverage, lNW,    VFX_BEAM_SILENT_MIND);
DrawBeam(lAverage, lWest,  VFX_BEAM_SILENT_MIND);
DrawBeam(lAverage, lSW,    VFX_BEAM_SILENT_MIND);
DrawBeam(lAverage, lSouth, VFX_BEAM_SILENT_MIND);
DrawBeam(lAverage, lSE,    VFX_BEAM_SILENT_MIND);

    rRoom.lCenter = lAverage;
    rRoom.lE = lEast;
    rRoom.lNE = lNE;
    rRoom.lN = lNorth;
    rRoom.lNW = lNW;
    rRoom.lW = lWest;
    rRoom.lSW = lSW;
    rRoom.lS = lSouth;
    rRoom.lSE = lSE;
    rRoom.fNS = fYMax-fYMin;
    rRoom.fEW = fXMax-fXMin;
    return rRoom;
}

float ConvertToSemiRoundedAngle(float fAngle, float fInterval = 45.0)
{
    if(fInterval == 0.0)
        return fAngle;
    int nIntervals = FloatToInt((fAngle+(0.5*fInterval))/fInterval);
    float fPosAngle = IntToFloat(nIntervals)*fInterval;
    return fPosAngle;
}

int CheckSymetry(location lTest, float fDist = 2.0)
{
    vector vOldPos = GetPositionFromLocation(lTest);
    location lLeft;
    location lRight;
    vector vLeft = GetChangedPosition(vOldPos, fDist,
        GetLeftDirection(GetFacingFromLocation(lTest)));
    lLeft = Location(GetAreaFromLocation(lTest),
        vLeft, 0.0);
    vector vRight = GetChangedPosition(vOldPos, fDist,
        GetRightDirection(GetFacingFromLocation(lTest)));
    lRight = Location(GetAreaFromLocation(lTest),
        vRight, 0.0);
    int nLeft  = GetIsLocValid(lLeft, 101);
    int nRight = GetIsLocValid(lRight, 101);
    if(nLeft)
        nLeft += LineOfSightVector(vLeft, vOldPos);
    if(nRight)
        nRight += LineOfSightVector(vRight, vOldPos);
    if(nLeft == nRight)
    {
//        DoDebug("CheckSymetry = TRUE");
DrawBeam(lRight, lLeft, VFX_BEAM_SILENT_LIGHTNING);
        return TRUE;
    }
//    DoDebug("CheckSymetry = FALSE");
    return FALSE;
}

location GetAngleFacingWall(location lSpawn, float fDist = 2.0,  float fGap = 3.0)
{
    vector vPos     = GetPositionFromLocation(lSpawn);
    object oArea    = GetAreaFromLocation(lSpawn);
    float fOriginal = GetFacingFromLocation(lSpawn);
    float fPlus     = fOriginal+fGap;
    float fMinus     = fOriginal-fGap;
    location lPlus  = lSpawn;
    location lMinus = lSpawn;
    int nPlusSym    = CheckSymetry(lSpawn, fDist);
    int nMinusSym   = nPlusSym;//same location, same result
    while(!nPlusSym && !nMinusSym
        && fPlus  < fOriginal + 180.0
        && fMinus > fOriginal - 180.0
        && GetIsLocValid(lPlus,  FALSE)
        && GetIsLocValid(lMinus, FALSE))
    {
        lPlus  = Location(oArea, vPos, fPlus);
        lMinus = Location(oArea, vPos, fMinus);
        nPlusSym  = CheckSymetry(lPlus);
        nMinusSym = CheckSymetry(lMinus);
        fPlus += fGap;
        fMinus -= fGap;
    }
    if(nPlusSym)
        lSpawn = lPlus;
    else if(nMinusSym)
        lSpawn = lMinus;
    else
    {
        location lNull;
        lSpawn = lNull;
    }
    return lSpawn;
}

float GetDistanceToNearestPlaceable(location lSpawn)
{
    int i = 1;
    object oNearest = GetNearestObjectToLocation(OBJECT_TYPE_PLACEABLE, lSpawn, i);
    while(GetPlotFlag(oNearest) && GetIsObjectValid(oNearest))
    {
        i++;
        oNearest = GetNearestObjectToLocation(OBJECT_TYPE_PLACEABLE, lSpawn, i);
    }
    if(!GetIsObjectValid(oNearest))
        return 999999999.9; //as near infinite as I can get practically
    location lNearest = GetLocation(oNearest);
    return GetDistanceBetweenLocations(lSpawn, lNearest);
}

float GetDistanceToNearestDoor(location lSpawn)
{
    int i = 1;
    object oNearest = GetNearestObjectToLocation(OBJECT_TYPE_DOOR, lSpawn, i);
    if(!GetIsObjectValid(oNearest))
        return 999999999.9; //as near infinite as I can get practically
    location lNearest = GetLocation(oNearest);
    return GetDistanceBetweenLocations(lSpawn, lNearest);
}

object GetNearestTriggerToLocationWithTag(location lLoc, string sTag)
{
    int i = 1;
    object oTest = GetNearestObjectToLocation(OBJECT_TYPE_TRIGGER, lLoc, i);
    while(GetIsObjectValid(oTest))
    {
        if(GetTag(oTest) == sTag)
            return oTest;
        i++;
        oTest = GetNearestObjectToLocation(OBJECT_TYPE_TRIGGER, lLoc, i);
    }
    return OBJECT_INVALID;
}

int GetIsLocationInTrigger(location lLoc, object oTrigger = OBJECT_INVALID)
{
    if(oTrigger == OBJECT_INVALID)
        GetNearestObjectToLocation(OBJECT_TYPE_TRIGGER, lLoc);
    if(!GetIsObjectValid(oTrigger))
        return FALSE;
    object oCopy = CreateObject(OBJECT_TYPE_CREATURE, RAD_DUMMY_RESREF, lLoc);
    AssignCommand(oCopy, SetIsDestroyable(TRUE));
    DestroyObject(oCopy); //this doesnt take effect until the end of the script
    ApplyEffectToObject(DURATION_TYPE_PERMANENT, EffectCutsceneGhost(), oCopy);
    //this should cut down on heard/seen events I hope!
    ApplyEffectToObject(DURATION_TYPE_PERMANENT, EffectBlindness(), oCopy);
    ApplyEffectToObject(DURATION_TYPE_PERMANENT, EffectDeaf(), oCopy);
    ApplyEffectToObject(DURATION_TYPE_PERMANENT, EffectEthereal(), oCopy);
    object oTest = GetFirstInPersistentObject(oTrigger, OBJECT_TYPE_CREATURE);
    while(GetIsObjectValid(oTest))
    {
        if(oTest == oCopy)
            return TRUE;
        oTest = GetNextInPersistentObject(oTrigger, OBJECT_TYPE_CREATURE);
    }
    return FALSE;
}
