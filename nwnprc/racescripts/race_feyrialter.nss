//::///////////////////////////////////////////////
//:: Name        Fey'ri alter self
//:: FileName    race_feyrialter
//:: Copyright (c) 2001 Bioware Corp.
//:://////////////////////////////////////////////
/*

*/
//:://////////////////////////////////////////////
//:: Created By: Shane Hennessy
//:: Created On:
//:://////////////////////////////////////////////
// disguise for fey'ri

#include "prc_alterations"

//internal function to remove wings
void RemoveWings(object oPC)
{
    object oSkin = GetPCSkin(oPC);
    //if not shifted
    //store current appearance to be safe 
    StoreAppearance(oPC);
    SetPersistantLocalInt(oPC, "WingsOff", TRUE);
    SetCreatureWingType(CREATURE_WING_TYPE_NONE, oPC);
}

//internal function to turn wings on
void AddWings(object oPC)
{
    object oSkin = GetPCSkin(oPC);
    //grant wings
    SetPersistantLocalInt(oPC, "WingsOff", FALSE);
    SetCreatureWingType(CREATURE_WING_TYPE_DEMON, oPC);
}

void main()
{
    object oPC = OBJECT_SELF;
    if(!GetIsPolyMorphedOrShifted(oPC))
    {
    	if(!GetPersistantLocalInt(oPC, "WingsOff")) 
            RemoveWings(oPC);
        else
            AddWings(oPC);
    }
    else
        FloatingTextStringOnCreature("You cannot use this ability while shifted.", oPC, FALSE);
}
