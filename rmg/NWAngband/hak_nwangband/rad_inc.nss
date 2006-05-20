//lCorner1       = location to use as corner for inital room checks
//lCorner2       = location to use as corner for inital room checks
//sFilename     = 2da file to use to read resrefs from
//                  ResRef      resref to use
//                  Room        0.0 = centre
//                                  max prop outwards
//                              1.0 = wall
//                                  max prop inwards
//                              2.0 = random
//                  Facing      rotation interval
//                  Size        distance from other placeables, walkable, seams
//fCR           = CR as passed on via local float. Could be used for spawns, loot, etc
//nFreqPerim    = 1 object per nFreqPerim m of perimeter
//nFreqArea     = 1 object per nFreqArea m2 of area
//fRoomMinSize  = minimum dimension of room
//fRoomMinArea  = minimum area of room (1 tile == 100.0m2)
//fShapeLimit   = degrees of deformation of room shape
void SpawnRoom(location lCorner1, location lCorner2, string sFilename,
    float fCR, int nFreqPerim = 4, int nFreqArea = 100, float fRoomMinSize = 8.0,
    float fRoomMinArea = 100.0, float fShapeLimit = 45.0, int nCount = 10,
    float fMaxSize = -1.0);

//attempt to spawn an object in a room
//fAngle            = degrees
//lAverage          = centre of room
//sResRef           = resref of placeable
//fRoom             = scalar for distance
//                    2.0 means at the wall
//                    1.0 means random
//                    0.0 means centre
//fFacingInterval   = interval for facing
//fDistance = minimum distance to nearest non-plot placeable
//            maximum distance to nearest walkable location
//            minimum distance to nearest tile seam
void TryToSpawn(float fAngle, location lAverage, float fCR,
    string sFilename, float fFreeLocationGap = 5.0, int nTrial = 0,
    float fMaxSize = -1.0);

location GetNearestWalkableLocation(location lLoc);

const string RAD_DEBUG_PLCAEABLE_RESREF = "rad_beam_debug";
const string RAD_DUMMY_RESREF           = "rad_dummy";
const string RAD_ROOM                   = "rad_room";
const string RAD_SPAWN                  = "rad_spawn";
const int RAD_DEBUG = TRUE;
const int RAD_FLAG_SEAM                 = 1;
const int RAD_FLAG_WALK                 = 2;
const int RAD_FLAG_PLACE                = 4;
const int RAD_FLAG_TRIGGER              = 8;

#include "x0_i0_position"
#include "prc_gateway"
#include "random_inc"
#include "rad_inc_util"

void TryToSpawn(float fAngle, location lAverage, float fCR,
    string sFilename, float fFreeLocationGap = 5.0, int nTrial = 0,
    float fMaxSize = -1.0)
{
DoDebug("Start of TryToSpawn()");
//    DoDebug("TryToSpawn() fMaxSize = "+FloatToString(fMaxSize));
    location lSpawn = GetFreeLocation(lAverage, fAngle, fFreeLocationGap, fMaxSize);
    if(GetIsLocValid(lSpawn))
    {
        SetLocalInt(GetModule(), "RIG_LEVEL", FloatToInt(fCR));
        int nCount                  = StringToInt(GetRandomFrom2DA(sFilename));
        DeleteLocalInt(GetModule(), "RIG_LEVEL");
        string sResRef              =               Get2DACache(RAD_SPAWN, "ResRef", nCount);
        float fRoom                 = StringToFloat(Get2DACache(RAD_SPAWN, "Room",   nCount));
        float fFacingInterval       = StringToFloat(Get2DACache(RAD_SPAWN, "Facing", nCount));
        float fDistance             = StringToFloat(Get2DACache(RAD_SPAWN, "Size",   nCount));
        int nFlags                  = StringToInt  (Get2DACache(RAD_SPAWN, "Flags",   nCount));

        //spawn in the room, not at the end
        //use sin because its kind of circular, so avoids central clumping
        float fTotalDistance =  GetDistanceBetweenLocations(lSpawn, lAverage);
        float fRandomDistance = sin(IntToFloat(RandomI(900))/10.0)*fTotalDistance;
        float fDistanceToUse;

        if(fRoom > 0.0)
        {
            //scale the distance
            if(fRoom >= 2.0)
            {
                fDistanceToUse = fTotalDistance;
                lSpawn = lSpawn; //keep it at max
            }
            else if(fRoom > 1.0)
            {
                fDistanceToUse = (fRandomDistance*(1.0-(fRoom-1.0))) + ((fRoom-1.0)*fTotalDistance);
                vector vNewPos = GetChangedPosition(GetPositionFromLocation(lAverage), fDistanceToUse, fAngle);
                lSpawn = Location(GetArea(OBJECT_SELF), vNewPos, fAngle);
            }
            else
            {
                fDistanceToUse = fRandomDistance*fRoom;
                vector vNewPos = GetChangedPosition(GetPositionFromLocation(lAverage), fDistanceToUse, fAngle);
                lSpawn = Location(GetArea(OBJECT_SELF), vNewPos, fAngle);
            }
        }
        else
            lSpawn = lAverage;


        location lOriginalSpawn = lSpawn;
        //check not on/near a seam
        float fXRemainder = floatModulo(GetPositionFromLocation(lSpawn).x, 10.0);
        float fYRemainder = floatModulo(GetPositionFromLocation(lSpawn).y, 10.0);
//DoDebug("fDistance = "+FloatToString(fDistance));
        if(RAD_FLAG_SEAM & nFlags
            || (fXRemainder > fDistance
                && fXRemainder < 10.0-fDistance
                && fYRemainder > fDistance
                && fYRemainder < 10.0-fDistance))
        {
            //check walkable
            lSpawn = GetNearestWalkableLocation(lSpawn);
            if(RAD_FLAG_WALK & nFlags
                ||(GetIsLocValid(lSpawn)
                    && GetDistanceBetweenLocations(lSpawn, lOriginalSpawn) < fDistance))
            {
                if(RAD_FLAG_PLACE & nFlags
                    || (GetDistanceToNearestPlaceable(lSpawn) > fDistance
                        && GetDistanceToNearestDoor(lSpawn) > fDistance))
                {
                    object oTrigger = GetNearestTriggerToLocationWithTag(lSpawn, "rad_avoid");
                    if(RAD_FLAG_TRIGGER & nFlags
                        ||!GetIsObjectValid(oTrigger)
                        ||(GetIsObjectValid(oTrigger)
                            && !GetIsLocationInTrigger(lSpawn, oTrigger)))
                    {
                        //convert angly to a room edge one
                        //normally 90 degree, but can to 45 angles if needed
                        float fPosAngle = ConvertToSemiRoundedAngle(fAngle, fFacingInterval);
                        lSpawn = Location(GetArea(OBJECT_SELF), GetPositionFromLocation(lSpawn), fPosAngle);
                        if(GetIsLocValid(lSpawn))
                        {
                            lSpawn = GetAngleFacingWall(lSpawn, fDistance, fPosAngle);
                            if(GetIsLocValid(lSpawn))
                            {
                                object                              oSpawn = CreateObject(OBJECT_TYPE_PLACEABLE, sResRef, lSpawn);
                                if(!GetIsObjectValid(oSpawn))       oSpawn = CreateObject(OBJECT_TYPE_CREATURE, sResRef, lSpawn);
                                if(!GetIsObjectValid(oSpawn))       oSpawn = CreateObject(OBJECT_TYPE_ITEM, sResRef, lSpawn);
                                if(!GetIsObjectValid(oSpawn))       oSpawn = CreateObject(OBJECT_TYPE_WAYPOINT, sResRef, lSpawn);
                                if(!GetIsObjectValid(oSpawn))       oSpawn = CreateObject(OBJECT_TYPE_STORE, sResRef, lSpawn);
                                if(!GetIsObjectValid(oSpawn))       WriteTimestampedLogEntry("Error spawning "+sResRef);
                            //ApplyEffectAtLocation(DURATION_TYPE_INSTANT, EffectVisualEffect(VFX_FNF_SUMMON_MONSTER_1), lSpawn);
                                int nVarNo;
                                for(nVarNo = 1; nVarNo <=5; nVarNo++)
                                {
                                    string sVarType = Get2DACache(RAD_SPAWN, "VarType"+IntToString(nVarNo), nCount);
                                    if(sVarType == "int")
                                        SetLocalInt(oSpawn,
                                            Get2DACache(RAD_SPAWN, "VarName"+IntToString(nVarNo), nCount),
                                            StringToInt(Get2DACache(RAD_SPAWN, "VarVal"+IntToString(nVarNo), nCount)));
                                    else if(sVarType == "string")
                                        SetLocalString(oSpawn,
                                            Get2DACache(RAD_SPAWN, "VarName"+IntToString(nVarNo), nCount),
                                            Get2DACache(RAD_SPAWN, "VarVal"+IntToString(nVarNo), nCount));
                                    else if(sVarType == "float")
                                        SetLocalFloat(oSpawn,
                                            Get2DACache(RAD_SPAWN, "VarName"+IntToString(nVarNo), nCount),
                                            StringToFloat(Get2DACache(RAD_SPAWN, "VarVal"+IntToString(nVarNo), nCount)));
                                }
                                DoDebug( "Creating "+sResRef);
                                SetLocalFloat(oSpawn, "CR", fCR);
                                ExecuteScript(sResRef, oSpawn);
DoDebug("End of TryToSpawn()");
                                return;
                            }
//                            else
//                                DoDebug("unable to find suitable facing");
                        }
//                        else
//                            DoDebug("unable to convert to semi-rounded");
                    }
//                    else
//                        DoDebug("location is in a trigger");
                }
//                else
//                    DoDebug("too close to another placeable");
            }
//            else
//                DoDebug("no valid walkables nearby");
        }
//        else
//            DoDebug("too near a tile seam");
    }
//    else
//        DoDebug("lSpawn is not valid");
    //if we got here, something went wrong
    //try again with a delay
    if(nTrial < 25)
    {
        //move the angle a little bit +/-5%
        fAngle = fAngle*(1.0+((IntToFloat(RandomI(101))/10.0)-5.0));
        DelayCommand(0.1, TryToSpawn(fAngle, lAverage, fCR,
            sFilename, fFreeLocationGap, nTrial+1, fMaxSize));
    }
DoDebug("End of TryToSpawn()");
}

void SpawnRoom(location lCorner1, location lCorner2, string sFilename,
    float fCR, int nFreqPerim = 4, int nFreqArea = 100, float fRoomMinSize = 8.0,
    float fRoomMinArea = 100.0, float fShapeLimit = 45.0, int nCount = 10,
    float fMaxSize = -1.0)
{
DoDebug("Start of SpawnRoom()");
//DoDebug("SpawnRoom(lCorner1, lCorner2, "+sFilename+", "+FloatToString(fCR)+", "+IntToString(nFreqPerim)+", "+IntToString(nFreqArea)+", "+FloatToString(fRoomMinSize)
//    +", "+FloatToString(fRoomMinArea)+", "+FloatToString(fShapeLimit)+", "+IntToString(nCount)+", "+FloatToString(fMaxSize)+");");
    //sanity check
    object oArea = GetAreaFromLocation(lCorner1);
    if(!GetIsObjectValid(oArea))
    {
//        DoDebug("SpawnRoom() : Area is not valid");
DoDebug("End of SpawnRoom()");
        return;
    }
    //if the corners are different,
    //get a location between them
    location lStart;
    if(lCorner1 != lCorner2)
    {
        float fMinX = GetPositionFromLocation(lCorner1).x;
        float fMaxX = GetPositionFromLocation(lCorner2).x;
        float fMinY = GetPositionFromLocation(lCorner1).y;
        float fMaxY = GetPositionFromLocation(lCorner2).y;
        if(fMinX > fMaxX)
        {
            float fTemp = fMinX;
            fMinX = fMaxX;
            fMaxX = fTemp;
        }
        if(fMinY > fMaxY)
        {
            float fTemp = fMinY;
            fMinY = fMaxY;
            fMaxY = fTemp;
        }
        float fStartX = (fMaxX*1000.0-(fMinX*1000.0));
        fStartX = IntToFloat(RandomI(FloatToInt(fStartX)));
        fStartX = fStartX + (fMinX*1000.0);
        fStartX = fStartX / 1000.0;
        float fStartY = (fMaxY*1000.0-(fMinY*1000.0));
        fStartY = IntToFloat(RandomI(FloatToInt(fStartY)));
        fStartY = fStartY + (fMinY*1000.0);
        fStartY = fStartY / 1000.0;
//DoDebug("fMinX = "+FloatToString(fMinX));
//DoDebug("fMaxX = "+FloatToString(fMaxX));
//DoDebug("fMinY = "+FloatToString(fMinY));
//DoDebug("fMaxY = "+FloatToString(fMaxY));
//DoDebug("fStartX = "+FloatToString(fStartX));
//DoDebug("fStartY = "+FloatToString(fStartY));
        lStart = Location(oArea, Vector(fStartX, fStartY, 20.0), 0.0);
    }
    else
    //corners are the same, use them
        lStart = lCorner1;
    //get the ground nearby
    lStart = GetNearestWalkableLocation(lStart);
    //set the gap to be the minimum size of the room or 2m
    float fGap = fRoomMinSize;
    if(fGap < 2.0)
        fGap = 2.0;
    //get a room from the location
    struct room ROOM_INVALID;
    struct room rRoom = GetRoom(lStart, fRoomMinSize, fRoomMinArea, fShapeLimit, fGap, fMaxSize);
    //if the room doesnt make sense, retry
    if(rRoom == ROOM_INVALID)
    {
        //try again
//        DoDebug("room invalid, retrying");
        if(nCount)
            DelayCommand(0.1, SpawnRoom(lCorner1, lCorner2, sFilename, fCR,
                nFreqPerim, nFreqArea, fRoomMinSize, fRoomMinArea, fShapeLimit,
                nCount-1, fMaxSize));
DoDebug("End of SpawnRoom()");
        return;
    }

    float fXSize = rRoom.fEW;
    float fYSize = rRoom.fNS;
    location lAverage = rRoom.lCenter;

    int nTotalCount;
    //1 object per nFreqPerim m of perimeter
    if(nFreqPerim)
        nTotalCount = FloatToInt((2.0*fXSize)+(2.0*fYSize)) / nFreqPerim;
    //1 object per nFreqArea m2 of area
    if(nFreqArea)
        nTotalCount = FloatToInt((fXSize*fYSize)) / nFreqArea;
    //sanity check
    //spawn at least 1 object
    if(nTotalCount < 1)
        nTotalCount = 1;
    //get a starting angle
    float fAngle = IntToFloat(RandomI(360));
    //and get the gap between placeables
    float fAngleMod = IntToFloat(360/nTotalCount);
    // calculate a reasonablly efficient gap for wall tracking
    // 3 steps on average to edge
    float fFreeLocationGap = ((fXSize+fYSize)/4.0)/3.0;
    int i;
    for(i=0;i<nTotalCount;i++)
    {
        //step round the circle, not just pure random
        fAngle = fAngle + fAngleMod + IntToFloat(RandomI(360/nTotalCount))-((360/nTotalCount)/2);
        if(fAngle > 360.0)
            fAngle = fAngle - 360.0;

        DelayCommand(0.1, TryToSpawn(fAngle, lAverage, fCR, sFilename, fFreeLocationGap, 0, fMaxSize));
    }
DoDebug("End of SpawnRoom()");
}

void SpawnArea(object oArea, float fCR, string sFilename, float fRoomSize)
{
DoDebug("Start of SpawnArea()");
//DoDebug("SpawnArea("+GetName(oArea)+", "+FloatToString(fCR)+", "+sFilename+", "+FloatToString(fRoomSize)+")");
    if(!GetIsObjectValid(oArea))
    {
//        DoDebug("SpawnArea() : Area is not valid");
DoDebug("End of SpawnArea()");
        return;
    }
    //spawn a number of rooms
    location lCorner1;
    location lCorner2;
    float fAreaX = IntToFloat(10*GetAreaSize(AREA_WIDTH,  oArea));
    float fAreaY = IntToFloat(10*GetAreaSize(AREA_HEIGHT, oArea));
    int x;
    int y;
    int nTotalCountX = FloatToInt(fAreaX/fRoomSize);
    int nTotalCountY = FloatToInt(fAreaY/fRoomSize);
    int nFreqPerim;
    int nFreqArea;
    float fRoomMinSize;
    float fRoomMinArea;
    float fRoomMaxSize;
    float fShapeLimit;
    string sResRef;
    for(x=0;x<nTotalCountX;x++)
    {
        for(y=0;y<nTotalCountY;y++)
        {
            //get locations for the room
            lCorner1 = Location(oArea,
                Vector(IntToFloat(x)*(fAreaX/IntToFloat(nTotalCountX)),
                    IntToFloat(y)*(fAreaY/IntToFloat(nTotalCountY)),
                    20.0),
                0.0);
            lCorner2 = Location(oArea,
                Vector(IntToFloat(x+1)*(fAreaX/IntToFloat(nTotalCountX)),
                    IntToFloat(y+1)*(fAreaY/IntToFloat(nTotalCountY)),
                    20.0),
                0.0);

            SetLocalInt(GetModule(), "RIG_LEVEL", FloatToInt(fCR));
            int nCount          = StringToInt(GetRandomFrom2DA(sFilename));
            DeleteLocalInt(GetModule(), "RIG_LEVEL");
            sResRef             =               Get2DACache(RAD_ROOM, "ResRef",      nCount);
            nFreqPerim          = StringToInt(  Get2DACache(RAD_ROOM, "FreqPerim",   nCount));
            nFreqArea           = StringToInt(  Get2DACache(RAD_ROOM, "FreqArea",    nCount));
            fRoomMinSize        = StringToFloat(Get2DACache(RAD_ROOM, "RoomMinSize", nCount));
            fRoomMinArea        = StringToFloat(Get2DACache(RAD_ROOM, "RoomMinArea", nCount));
            fShapeLimit         = StringToFloat(Get2DACache(RAD_ROOM, "ShapeLimit",  nCount));
            fRoomMaxSize        = StringToFloat(Get2DACache(RAD_ROOM, "RoomMaxSize", nCount));

            float fDelay = IntToFloat((x*nTotalCountX)+y)*0.01;
            DelayCommand(fDelay, SpawnRoom(lCorner1, lCorner2, sResRef, fCR,
                nFreqPerim, nFreqArea, fRoomMinSize, fRoomMinArea, fShapeLimit,
                10, fRoomMaxSize));
        }
    }
DoDebug("End of SpawnArea()");
}
