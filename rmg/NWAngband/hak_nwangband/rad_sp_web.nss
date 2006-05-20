//::///////////////////////////////////////////////
//:: Name       Spawn web room
//:: FileName   rad_sp_web
//:: Copyright (c) 2001 Bioware Corp.
//:://////////////////////////////////////////////
/*
    Handle ambience and creatures for spawning spider encounters
*/
//:://////////////////////////////////////////////
//:: Created By: Primogenitor
//:: Created On: 05/05/06
//:://////////////////////////////////////////////

#include "rad_inc"


void main()
{
    //clean up
    //delay it slightly so it stops other spawns nearby.
    DestroyObject(OBJECT_SELF, 5.0);
    location lSpawn            = GetLocation(OBJECT_SELF);
    vector vPos1               = GetPositionFromLocation(lSpawn);
    vPos1.x -= 5.0;
    vPos1.y += 5.0;
    vector vPos2               = GetPositionFromLocation(lSpawn);
    vPos2.x += 5.0;
    vPos2.y -= 5.0;
    location lSpawn1           = Location(GetAreaFromLocation(lSpawn), vPos1, 0.0);
    location lSpawn2           = Location(GetAreaFromLocation(lSpawn), vPos2, 0.0);

    string sResRef             =               Get2DACache(RAD_ROOM, "ResRef",      3);
    int nFreqPerim             = StringToInt(  Get2DACache(RAD_ROOM, "FreqPerim",   3));
    int nFreqArea              = StringToInt(  Get2DACache(RAD_ROOM, "FreqArea",    3));
    float fRoomMinSize         = StringToFloat(Get2DACache(RAD_ROOM, "RoomMinSize", 3));
    float fRoomMinArea         = StringToFloat(Get2DACache(RAD_ROOM, "RoomMinArea", 3));
    float fShapeLimit          = StringToFloat(Get2DACache(RAD_ROOM, "ShapeLimit",  3));
    float fRoomMaxSize         = StringToFloat(Get2DACache(RAD_ROOM, "RoomMaxSize", 3));
    float fCR = GetLocalFloat(OBJECT_SELF, "CR");
    DelayCommand(1.0,
        SpawnRoom(lSpawn1, lSpawn2, sResRef, fCR,
            nFreqPerim, nFreqArea, fRoomMinSize, fRoomMinArea, fShapeLimit,
            10, fRoomMaxSize));
}
