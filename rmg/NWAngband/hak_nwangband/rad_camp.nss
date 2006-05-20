
#include "rad_inc"

void main()
{
//DoDebug("rad_camp firing");
    //clean up
    //delay it slightly so it stops other spawns nearby.
    DestroyObject(OBJECT_SELF, 5.0);


    location lSpawn            = GetLocation(OBJECT_SELF);
    vector vPos1 = GetPositionFromLocation(lSpawn);
    vPos1.x -= 5.0;
    vPos1.y += 5.0;
    vector vPos2 = GetPositionFromLocation(lSpawn);
    vPos2.x += 5.0;
    vPos2.y -= 5.0;
    location lSpawn1           = Location(GetAreaFromLocation(lSpawn), vPos1, 0.0);
    location lSpawn2           = Location(GetAreaFromLocation(lSpawn), vPos2, 0.0);

    string sResRef             =               Get2DACache(RAD_ROOM, "ResRef",      1);
    int nFreqPerim             = StringToInt(  Get2DACache(RAD_ROOM, "FreqPerim",   1));
    int nFreqArea              = StringToInt(  Get2DACache(RAD_ROOM, "FreqArea",    1));
    float fRoomMinSize         = StringToFloat(Get2DACache(RAD_ROOM, "RoomMinSize", 1));
    float fRoomMinArea         = StringToFloat(Get2DACache(RAD_ROOM, "RoomMinArea", 1));
    float fShapeLimit          = StringToFloat(Get2DACache(RAD_ROOM, "ShapeLimit",  1));
    float fRoomMaxSize         = StringToFloat(Get2DACache(RAD_ROOM, "RoomMaxSize", 1));
    float fCR = GetLocalFloat(OBJECT_SELF, "CR");
    SpawnRoom(lSpawn1, lSpawn2, "rad_camp_sp", fCR,
        nFreqPerim, nFreqArea, fRoomMinSize, fRoomMinArea, fShapeLimit,
        10, fRoomMaxSize);
}
