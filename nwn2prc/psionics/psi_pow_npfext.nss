/*
   ----------------
   Null Psionics Field - OnExit

   psi_pow_npfext
   ----------------

   6/10/05 by Stratovarius
*/ /** @file

    Null Psionics Field - OnExit

    Psychokinesis
    Level: Kineticist 6
    Manifesting Time: 1 standard action
    Range: 10 ft.
    Area: 10-ft.-radius emanation centered on you
    Duration: 10 min./level(D)
    Saving Throw: None
    Power Resistance: See text
    Power Points: 11
    Metapsionics: Extend, Widen
    
    An invisible barrier surrounds you and moves with you. The space within this 
    barrier is impervious to most psionic effects, including powers, psi-like 
    abilities, and supernatural abilities. Likewise, it prevents the functioning 
    of any psionic items or powers within its confines. A null psionics field 
    negates any power or psionic effect used within, brought into, or manifested 
    into its area.
    
    Dispel psionics does not remove the field. Two or more null psionics fields 
    sharing any of the same space have no effect on each other. Certain powers 
    may be unaffected by null psionics field (see the individual power 
    descriptions).
    
    
    Implementation note: To dismiss the power, use the control feat again. If 
                         the power is active, that will end it instead of 
                         manifesting it.
*/

#include "prc_alterations"

void RestoreAllProperties(object oItem, object oPC, int nSlot = -1)
{
    if(DEBUG) DoDebug("psi_pow_npfext: Attempting to restore itemproperties to: " + DebugObject2Str(oItem));
    
    if(oPC != OBJECT_INVALID) // this is a pc object that has an item in inventory slot or normal inventory
    {
        if(oItem == OBJECT_INVALID)
            oItem = GetItemInSlot(nSlot, oPC);
        if(oItem == OBJECT_INVALID)
            return;
    }
    //object oChest = GetLocalObject(oItem, "ITEM_CHEST");
    // getting the key value - this points to the tag of the copy item
    string sKey = GetLocalString(oItem, "PRC_NullPsionicsField_Item_UID");
    // retrieving the copy item that is in this area
    object oOriginalItem = GetObjectByTag("npf_item" + sKey);
    if(DEBUG) DoDebug("psi_pow_npfext: Restoring itemproperties to item: " + DebugObject2Str(oItem) + " with key value of '" + sKey + "' for creature " + DebugObject2Str(oPC));

    //object oOriginalItem = GetLocalObject(oChest, sKey);

    object oNewItem;
    if(oOriginalItem != OBJECT_INVALID) // item has not been restored yet
    {
        // replace current item with original
        IPCopyItemProperties(oOriginalItem, oItem);
        DestroyObject(oOriginalItem); // destroy dup item on player
        //DeleteLocalObject(oChest, GetResRef(oItem)); // so it won't be restored again
        DeleteLocalString(oItem, "PRC_NullPsionicsField_Item_UID");
    }
}

void RemoveEffectsNPF(object oObject)
{
    effect eEff = GetFirstEffect(oObject);
    while(GetIsEffectValid(eEff))
    {
        if(GetEffectType(eEff) == EFFECT_TYPE_SPELL_FAILURE)
            RemoveEffect(oObject, eEff);
        eEff = GetNextEffect(oObject);
    }
}

void main()
{
    object oExit = GetExitingObject();
    if(GetObjectType(oExit) == OBJECT_TYPE_CREATURE)
    // iterate through all creature's items and if there is one in the chest, replace it with
    // the current one.
    {
        if(DEBUG) DoDebug("psi_pow_npfext: Creature exiting NPF: " + DebugObject2Str(oExit));
        DeleteLocalInt(oExit, "NullPsionicsField");

        RemoveEffectsNPF(oExit);
        // Handle all items in inventory:
        object oItem = GetFirstItemInInventory(oExit);
        while(oItem != OBJECT_INVALID)
        {
            DelayCommand(4.0, RestoreAllProperties(oItem, oExit, -1));
            oItem = GetNextItemInInventory(oExit);
        }
        DelayCommand(4.0, RestoreAllProperties(OBJECT_INVALID, oExit, INVENTORY_SLOT_ARMS));
        DelayCommand(4.0, RestoreAllProperties(OBJECT_INVALID, oExit, INVENTORY_SLOT_ARROWS));
        DelayCommand(4.0, RestoreAllProperties(OBJECT_INVALID, oExit, INVENTORY_SLOT_BELT));
        DelayCommand(4.0, RestoreAllProperties(OBJECT_INVALID, oExit, INVENTORY_SLOT_BOLTS));
        DelayCommand(4.0, RestoreAllProperties(OBJECT_INVALID, oExit, INVENTORY_SLOT_BOOTS));
        DelayCommand(4.0, RestoreAllProperties(OBJECT_INVALID, oExit, INVENTORY_SLOT_BULLETS));
        DelayCommand(4.0, RestoreAllProperties(OBJECT_INVALID, oExit, INVENTORY_SLOT_CHEST));
        DelayCommand(4.0, RestoreAllProperties(OBJECT_INVALID, oExit, INVENTORY_SLOT_CLOAK));
        DelayCommand(4.0, RestoreAllProperties(OBJECT_INVALID, oExit, INVENTORY_SLOT_HEAD));
        DelayCommand(4.0, RestoreAllProperties(OBJECT_INVALID, oExit, INVENTORY_SLOT_LEFTHAND));
        DelayCommand(4.0, RestoreAllProperties(OBJECT_INVALID, oExit, INVENTORY_SLOT_LEFTRING));
        DelayCommand(4.0, RestoreAllProperties(OBJECT_INVALID, oExit, INVENTORY_SLOT_NECK));
        DelayCommand(4.0, RestoreAllProperties(OBJECT_INVALID, oExit, INVENTORY_SLOT_RIGHTHAND));
        DelayCommand(4.0, RestoreAllProperties(OBJECT_INVALID, oExit, INVENTORY_SLOT_RIGHTRING));
    }
}