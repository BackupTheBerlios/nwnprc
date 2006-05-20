//::///////////////////////////////////////////////
//:: Name       REG encounter generator
//:: FileName   reg_en_hb
//:: Copyright (c) 2001 Bioware Corp.
//:://////////////////////////////////////////////
/*
    This is a placeable HB.
    It destroys self and spawns based on resref.
*/
//:://////////////////////////////////////////////
//:: Created By: Primogenitor
//:: Created On: 2/03/06
//:://////////////////////////////////////////////

#include "reg_inc"

void main()
{
    //clean up
    //delay it slightly so it stops other spawns nearby.
    DestroyObject(OBJECT_SELF, 5.0);
    //create the NPCs
    string sResRef = GetStringRight(GetResRef(OBJECT_SELF), GetStringLength(GetResRef(OBJECT_SELF))-6);
    REG_SpawnEncounter(GetLocalFloat(OBJECT_SELF, "CR"),
        "reg_sp"+sResRef,
        GetLocation(OBJECT_SELF));
}
