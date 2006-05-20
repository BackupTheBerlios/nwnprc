
#include "rad_inc"

void main()
{
DoDebug("rad_sp_mushroom firing");
SendMessageToPC(GetFirstPC(), "rad_sp_mushroom firing");
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

    string sResRef             =               Get2DACache(RAD_ROOM, "ResRef",      2);
    int nFreqPerim             = StringToInt(  Get2DACache(RAD_ROOM, "FreqPerim",   2));
    int nFreqArea              = StringToInt(  Get2DACache(RAD_ROOM, "FreqArea",    2));
    float fRoomMinSize         = StringToFloat(Get2DACache(RAD_ROOM, "RoomMinSize", 2));
    float fRoomMinArea         = StringToFloat(Get2DACache(RAD_ROOM, "RoomMinArea", 2));
    float fShapeLimit          = StringToFloat(Get2DACache(RAD_ROOM, "ShapeLimit",  2));
    float fRoomMaxSize         = StringToFloat(Get2DACache(RAD_ROOM, "RoomMaxSize", 2));
    float fCR = GetLocalFloat(OBJECT_SELF, "CR");
    SpawnRoom(lSpawn1, lSpawn2, sResRef, fCR,
        nFreqPerim, nFreqArea, fRoomMinSize, fRoomMinArea, fShapeLimit,
        10, fRoomMaxSize);
}
