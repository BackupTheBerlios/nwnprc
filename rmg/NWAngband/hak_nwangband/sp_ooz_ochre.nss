//::///////////////////////////////////////////////
//:: Name       Spawn Vermin Spiders
//:: FileName   sp_ver_spider
//:: Copyright (c) 2001 Bioware Corp.
//:://////////////////////////////////////////////
/*
    Handle creatures for spawning spider encounters
*/
//:://////////////////////////////////////////////
//:: Created By: Primogenitor
//:: Created On: 05/05/06
//:://////////////////////////////////////////////

#include "reg_inc"
#include "spawn_inc"
#include "amb_inc"

void main()
{
    //clean up
    //do this first in case of TMI or other error
    //otherwise well have inifinite spawns
    DestroyObject(OBJECT_SELF, 5.0);
    //create the NPCs
    location lSpawn = GetLocation(OBJECT_SELF);
    float fCR = GetLocalFloat(OBJECT_SELF, "CR");
    REG_SpawnEncounter(fCR,
        "ooz_ochre",
        lSpawn,
        2);
}
