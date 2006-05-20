//::///////////////////////////////////////////////
//:: Name       REG Dwarf spawn
//:: FileName   reg_sp_dwarf
//:: Copyright (c) 2001 Bioware Corp.
//:://////////////////////////////////////////////
/*
    This is a placeable HB.
    It destroys self and spawns a random dwarf
    that had previously been leveluped and stored.
*/
//:://////////////////////////////////////////////
//:: Created By: Primogenitor
//:: Created On: 2/03/06
//:://////////////////////////////////////////////

#include "reg_inc"
#include "spawn_inc"

void main()
{
    //clean up
    //do this first in case of TMI or other error
    //otherwise well have inifinite spawns
    DestroyObject(OBJECT_SELF);
    //create the NPCs
    location lSpawn = GetLocation(OBJECT_SELF);
    float fCR = GetLocalFloat(OBJECT_SELF, "CR");
    /*
    REG_CreateNPC(GetLocation(OBJECT_SELF),
        GetLocalFloat(OBJECT_SELF, "CR"),
        RACIAL_TYPE_DWARF);*/
    AddToSpawnQueue("", lSpawn, fCR, RACIAL_TYPE_DWARF);
}
