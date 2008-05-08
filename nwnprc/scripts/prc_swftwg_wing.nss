//::///////////////////////////////////////////////
//:: Wing Activation and Deactivation for Swift Wing
//:: prc_swftwg_wing.nss
//::///////////////////////////////////////////////
/*
    Handles the wing activation and deactivation for the Swift Wing class.
*/
//:://////////////////////////////////////////////
//:: Created By: Fox
//:: Created On: Nov 20, 2007
//:://////////////////////////////////////////////

#include "pnp_shft_poly"

//internal fucntion to remove wings
void RemoveSWWings(object oPC)
{
    object oSkin = GetPCSkin(oPC);
    //if not shifted
    SetPersistantLocalInt(oPC, "WingsOn", FALSE);
    int nOriginalWings = GetPersistantLocalInt(oPC, "AppearanceStoredWing");
    SetCreatureWingType(nOriginalWings, oPC);
    IPRemoveMatchingItemProperties(oSkin, ITEM_PROPERTY_SKILL_BONUS, DURATION_TYPE_TEMPORARY, SKILL_JUMP);
}

//internal function to turn wings on
void AddSWWings(object oPC)
{
    object oSkin = GetPCSkin(oPC);
    //if not shifted
    //store current appearance to be safe 
    StoreAppearance(oPC);
    //grant wings
    SetPersistantLocalInt(oPC, "WingsOn", TRUE);
    SetCreatureWingType(CREATURE_WING_TYPE_DRAGON, oPC);
    AddItemProperty(DURATION_TYPE_TEMPORARY, ItemPropertySkillBonus(SKILL_JUMP, 10), oSkin, 9999.0);
}

void main()
{
    object oPC = OBJECT_SELF;
    if(!GetIsPolyMorphedOrShifted(oPC))
    {
    	if(!GetPersistantLocalInt(oPC, "WingsOn")) 
            AddSWWings(oPC);
        else
            RemoveSWWings(oPC);
    }
    else
        FloatingTextStringOnCreature("You cannot use this ability while shifted.", oPC, FALSE);
}
