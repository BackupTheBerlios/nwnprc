//::///////////////////////////////////////////////
//:: skin include
//:: prc_inc_skin
//::///////////////////////////////////////////////
/** @file
    This include contains GetPCSkin(). If only using
    this function please include this directly and not via
    the entire spell engine :p
    
    Is included by inc_persist_loca for persistent
    local variables
*/
//:://////////////////////////////////////////////
//:: Created By: fluffyamoeba
//:: Created On: 2008-4-23
//:://////////////////////////////////////////////

//////////////////////////////////////////////////
/* Function prototypes                          */
//////////////////////////////////////////////////

/**
 * Sets up the pcskin object on oPC.
 * If it already exists, simply return it. Otherwise, create and equip it.
 *
 * @param oPC The creature whose skin object to look for.
 * @return    Either the skin found or the skin created.
 */
object GetPCSkin(object oPC);

//////////////////////////////////////////////////
/*                  Includes                    */
//////////////////////////////////////////////////

#include "inc_debug"
#include "inc_utility"

//////////////////////////////////////////////////
/* Function defintions                          */
//////////////////////////////////////////////////

object GetPCSkin(object oPC)
{
    // According to a bug report, this is being called on non-creature objects. This should catch the culprit
    if(DEBUG) Assert(GetObjectType(oPC) == OBJECT_TYPE_CREATURE, "GetObjectType(oPC) == OBJECT_TYPE_CREATURE", "GetPRCSkin() called on non-creature object: " + DebugObject2Str(oPC), "prc_inc_skin", "object GetPCSkin(object oPC)");
    object oSkin = GetItemInSlot(INVENTORY_SLOT_CARMOUR, oPC);
    if (!GetIsObjectValid(oSkin))
    {
        oSkin = GetLocalObject(oPC, "PRCSkinCache");
        if(!GetIsObjectValid(oSkin))
        {
            if(GetHasItem(oPC, "base_prc_skin"))
            {
                oSkin = GetItemPossessedBy(oPC, "base_prc_skin");
                ForceEquip(oPC, oSkin, INVENTORY_SLOT_CARMOUR);
                //AssignCommand(oPC, ActionEquipItem(oSkin, INVENTORY_SLOT_CARMOUR));
            }

            //Added GetHasItem check to prevent creation of extra skins on module entry
            else {
                oSkin = CreateItemOnObject("base_prc_skin", oPC);
                ForceEquip(oPC, oSkin, INVENTORY_SLOT_CARMOUR);
                //AssignCommand(oPC, ActionEquipItem(oSkin, INVENTORY_SLOT_CARMOUR));

                // The skin should not be droppable
                SetDroppableFlag(oSkin, FALSE);
            }

            // Cache the skin reference for further lookups during the same script
            SetLocalObject(oPC, "PRCSkinCache", oSkin);
            DelayCommand(0.0f, DeleteLocalObject(oPC, "PRCSkinCache"));
        }
    }
    return oSkin;
}
