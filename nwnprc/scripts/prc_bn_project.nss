//::///////////////////////////////////////////////
//:: Baelnorn projection script
//:: prc_bn_project
//::///////////////////////////////////////////////
/*
    This script creates a copy of the PC casting it,
    switches the PC and copy's inventories and their
    locations. The PC is set to immortal.

    The projection ends when one of the following
    happens:

    1) This script is fired while there is a valid
       copy in existence.
    2) The PC reaches 1 HP.
    3) The copy dies. In this case, the PC also dies.

    In cases other than 3), the PC's hitpoints are set
    to what the copy had when the projection ended.
    When ending projection, the PC is returned back
    to the copy's location and their inventories are
    swapped back.

    The inventory swappage happens in order to prevent
    the PC from having access to most of their items.


    POTENTIAL PROBLEMS

    - There may be a way to abuse Projection to duplicate items.
    -- Should be preventable via strict checks in OnUnacquireItem
    - It may be possible to restore charges to items using projection
*/
//:://////////////////////////////////////////////
//:: Written By: Tenjac & Primogenitor
//:: Modified By: Ornedan
//:: Modified On: 19.02.2005
//:://////////////////////////////////////////////

#include "x2_inc_itemprop"

//////////////////////////////////////////////////
/* Constant defintions                          */
//////////////////////////////////////////////////
const string COPY_LOCAL_NAME             = "Baelnorn_Projection_Copy";
const string ALREADY_IMMORTAL_LOCAL_NAME = "BaelnornProjection_ImmortalAlready";
const float PROJECTION_HB_DELAY = 1.0f;

//////////////////////////////////////////////////
/* Function prototypes                          */
//////////////////////////////////////////////////

void DoDestroy(object oObject);
void MoveInventory(object oA, object oB, int bCopyEquipped = FALSE);
void CleanTheCopy(object oCopy);
void PseudoPosses(object oPC, object oCopy);
void EndPosses(object oPC, object oCopy);
void ProjectionMonitor(object oPC, object oCopy);
void NerfWeapons(object oPC);
void UnNerfWeapons(object oPC);



//////////////////////////////////////////////////
/* Function defintions                          */
//////////////////////////////////////////////////

void main()
{
    // Get the main variables used.
    object oPC       = OBJECT_SELF;
    object oCopy     = GetLocalObject(oPC, COPY_LOCAL_NAME);
    location lPC     = GetLocation(oPC);
    location lTarget = GetSpellTargetLocation();
    effect eLight    = EffectVisualEffect(VFX_IMP_RESTORATION_GREATER, FALSE);
    effect eGlow     = EffectVisualEffect(VFX_DUR_ETHEREAL_VISAGE, FALSE);

    // Check if there is a valid copy around.
    // If so, end the projection.
    
    if(GetIsObjectValid(oCopy))
    {
        EndPosses(oPC, oCopy);
        RemoveEffect(oPC, eGlow);
       return;
    }

    // Create the copy
    oCopy = CopyObject(oPC, lTarget, OBJECT_INVALID, GetName(oPC) + "_" + COPY_LOCAL_NAME);
    // Set the copy to be undestroyable, so that it won't vanish to the ether
    // along with the PC's items.
    AssignCommand(oCopy, SetIsDestroyable(FALSE, FALSE, FALSE));
    // Make the copy immobile and minimize the AI on it
    ApplyEffectToObject(DURATION_TYPE_PERMANENT, ExtraordinaryEffect(EffectCutsceneImmobilize()), oCopy);
    SetAILevel(oCopy, AI_LEVEL_VERY_LOW);

    // Store a referece to the copy on the PC
    SetLocalObject(oPC, COPY_LOCAL_NAME, oCopy);

    //Set Immortal flag on the PC or if they were already immortal,
    //leave a note about it on them.
    //
    if(GetImmortal(oPC))
        SetLocalInt(oPC, ALREADY_IMMORTAL_LOCAL_NAME, TRUE);
    else{
        SetImmortal(oPC, TRUE);
        DeleteLocalInt(oPC, ALREADY_IMMORTAL_LOCAL_NAME); // Paranoia
    }

    // Do VFX on PC and copy
    ApplyEffectToObject(DURATION_TYPE_TEMPORARY, eLight, oCopy, 3.0);
    ApplyEffectToObject(DURATION_TYPE_TEMPORARY, eLight, oPC, 3.0);

    // Start a pseudo-hb to monitor the status of both PC and copy
    DelayCommand(PROJECTION_HB_DELAY, ProjectionMonitor(oPC, oCopy));

    NerfWeapons(oPC);

    // Delete all non-equipped items from the copy
    DelayCommand(0.05, CleanTheCopy(oCopy));
    // Do the switching around
    DelayCommand(0.2, PseudoPosses(oPC, oCopy));
    ApplyEffectToObject(DURATION_TYPE_PERMANENT, eGlow, oPC, 60.0);
}


//First sets the given item destroyable and then destroys it.
//This is used to make sure no duplicate items are created
//when using the projection.
 
void DoDestroy(object oObject){
    AssignCommand(oObject, SetIsDestroyable(TRUE, FALSE, FALSE));
    DestroyObject(oObject);
}

// Copies the contents of object oA to oB
// and destroys the originals.
 
void MoveInventory(object oA, object oB, int bCopyEquipped = FALSE)
{
    object oItem = GetFirstItemInInventory(oA);
    object oCopy;
    while(GetIsObjectValid(oItem))
    {
        CopyItem(oItem, oB, TRUE);
        DoDestroy(oItem);
        oItem = GetNextItemInInventory(oA);
    }

    if(bCopyEquipped)
    {
        // Skip creature items when copying equipped items.
        int i;
        for(i = 0; i < INVENTORY_SLOT_CWEAPON_L; i++)
        {
            oItem = GetItemInSlot(i, oA);
            oCopy = CopyItem(oItem, oB, TRUE);
            AssignCommand(oB, ActionEquipItem(oCopy, i));
            DoDestroy(oItem);
        }
    }
}

//Wipe the copy's inventory
//Does not touch equipped items, since a naked copy would look stupid :P
 
void CleanTheCopy(object oCopy)
{
    object oItem = GetFirstItemInInventory(oCopy);
    while(GetIsObjectValid(oItem))
    {
        // Unless this shows to be necessary, it's commented out to save resources
        // Clean the contents of any bags, too
        if(GetHasInventory(oItem))
        {
            object oItem2 = GetFirstItemInInventory(oItem);
            while(GetIsObjectValid(oItem2))
            {
                SetLocalInt(oItem2, "MarkedForDestruction", TRUE);
                DoDestroy(oItem2);
                oItem2 = GetNextItemInInventory(oItem);
            }
        }
        //SetLocalInt(oItem, "MarkedForDestruction", TRUE);
        DoDestroy(oItem);
        oItem = GetNextItemInInventory(oCopy);
    }
    int i;
    for(i = 0; i < 14; i++)
    {
        oItem = GetItemInSlot(i, oCopy);
        SetLocalInt(oItem, "MarkedForDestruction", TRUE);
        DoDestroy(oItem);
    }
}



 // Moves the PC's items to the copy and switches their locations around
 
void PseudoPosses(object oPC, object oCopy)
{
    // Make sure both objects are valid
    if(!GetIsObjectValid(oCopy) || !GetIsObjectValid(oPC)){
        WriteTimestampedLogEntry("PseudoPosses called, but one of the parameters wasn't a valid object. Object status:" +
                                 "\nPC - " + (GetIsObjectValid(oPC) ? "valid":"invalid") +
                                 "\nCopy - " + (GetIsObjectValid(oCopy) ? "valid":"invalid"));
        // Some cleanup before aborting
        if(!GetLocalInt(oPC, ALREADY_IMMORTAL_LOCAL_NAME))
            SetImmortal(oPC, FALSE);
        DoDestroy(oCopy);
        DeleteLocalInt(oPC, "BaelnornProjection_Active");
        UnNerfWeapons(oPC);

        return;
    }

    // Get the locations
    location lPC = GetLocation(oPC);
    location lCopy = GetLocation(oCopy);

    //Unless this is proved necessary by testing, skip the 3-way inventory switching
    location lLimbo = GetLocation(GetObjectByTag("HEARTOFCHAOS"));
    //temporary container
    object oContainer = CreateObject(OBJECT_TYPE_PLACEABLE, "plc_chest1" ,lLimbo);

    if(!GetIsObjectValid(oContainer)){
        WriteTimestampedLogEntry("Pseudoposses failed due to being unable to create container");
        // Remove immortality, since we aren't possessing after all
        SetImmortal(oPC, FALSE);
        // Also destroy the copy
        DoDestroy(oCopy);
        return;
    }
    //move the pc inventory to the container
    DelayCommand(0.1, MoveInventory(oPC, oContainer));
    //move the copies inventory to the PC
    DelayCommand(0.2, MoveInventory(oCopy, oPC));
    //move the container to the copy
    DelayCommand(0.3, MoveInventory(oContainer, oCopy));
    DelayCommand(1.0, DestroyObject(oContainer));
    
    // Just move the PC's stuff to the copy.
    // It doesn't matter if all the copy's own items haven't been destroyed yet, since this will not interfere
    MoveInventory(oPC, oCopy);

    // Set a local on the PC telling that it's a projection. This is used
    // to keep the PC from picking up or losing objects.
    SetLocalInt(oPC, "BaelnornProjection_Active", TRUE);

    //now jump them over
    //doesnt matter if this happens before or after inventory swapping
    AssignCommand(oPC, JumpToLocation(lCopy));
    AssignCommand(oCopy, JumpToLocation(lPC));
}


// Switches the PC's inventory back from the copy and returns the PC to the copy's location.
 
void EndPosses(object oPC, object oCopy)
{
    // See comment in PseudoPossess
    location lLimbo = GetLocation(GetObjectByTag("HEARTOFCHAOS"));
    location lCopy = GetLocation(oCopy);
    //construct visual effect
    //temporary container
    object oContainer = CreateObject(OBJECT_TYPE_PLACEABLE, "plc_chest1" ,lLimbo);
    if(!GetIsObjectValid(oContainer))
        return;
    
    effect eLight = EffectVisualEffect(VFX_IMP_RESTORATION_GREATER, FALSE);

    // Remove Immortality from the PC if necessary
    if(!GetLocalInt(oPC, ALREADY_IMMORTAL_LOCAL_NAME))
        SetImmortal(oPC, FALSE);
    // Remove the local signifying that the PC is a projection
    DeleteLocalInt(oPC, "BaelnornProjection_Active");

    UnNerfWeapons(oPC);

    // Move PC and inventory
    AssignCommand(oPC, JumpToLocation(lCopy));
    MoveInventory(oCopy, oPC);

    // Set the PC's hitpoints to be whatever the copy has
    int nOffset = GetCurrentHitPoints(oCopy) - GetCurrentHitPoints(oPC);
    if(nOffset > 0)
        ApplyEffectToObject(DURATION_TYPE_INSTANT, EffectHeal(nOffset), oPC);
    else if (nOffset < 0)
        ApplyEffectToObject(DURATION_TYPE_INSTANT, EffectDamage(-nOffset, DAMAGE_TYPE_MAGICAL, DAMAGE_POWER_ENERGY), oPC);

    // Schedule deletion of the copy
    DelayCommand(0.3f, DoDestroy(oCopy));

    //VFX
    ApplyEffectAtLocation(DURATION_TYPE_TEMPORARY, eLight, lCopy, 3.0);


    //move the copy inventory to the container
    DelayCommand(0.1, MoveInventory(oCopy, oContainer));
    //move the PC inventory to the copy
    DelayCommand(0.2, MoveInventory(oPC, oCopy));
    //move the container to the PC
    DelayCommand(0.3, MoveInventory(oContainer, oPC));
    DelayCommand(0.4, DestroyObject(oContainer));
    
}


  //Runs tests to see if the projection effect can still continue.
  //If the PC has reached 1 HP, end projection normally.
  //If the copy is dead, end projection and kill the PC.
 
void ProjectionMonitor(object oPC, object oCopy)
{
    // First, some paranoia checks. The player might have ended the projection in meantime.
    if(!(GetIsObjectValid(oPC) && GetIsObjectValid(oCopy))){
        WriteTimestampedLogEntry("Baelnorn Projection hearbeat aborting due to an invalid object. Object status:" +
                                 "\nPC - " + (GetIsObjectValid(oPC) ? "valid":"invalid") +
                                 "\nCopy - " + (GetIsObjectValid(oCopy) ? "valid":"invalid"));
        return;
    }

    // Start the actual work by checking the copy's status. The death thing should take priority
    if(GetIsDead(oCopy))
    {
        EndPosses(oPC, oCopy);
        effect eKill = EffectDamage(GetCurrentHitPoints(oPC), DAMAGE_TYPE_MAGICAL, DAMAGE_POWER_ENERGY);
        ApplyEffectToObject(DURATION_TYPE_INSTANT, eKill, oPC);
    }
    else if(GetCurrentHitPoints(oPC) == 1)
    {
        EndPosses(oPC, oCopy);
    }
    else
        DelayCommand(PROJECTION_HB_DELAY, ProjectionMonitor(oPC, oCopy));
}


//Gives the PC -50 to attack and places No Damage iprop to all equipped weapons.
 
void NerfWeapons(object oPC){
    effect eAB = EffectAttackDecrease(50);
    ApplyEffectToObject(DURATION_TYPE_PERMANENT, eAB, oPC);

    object oWeapon;
    itemproperty ipNoDam = ItemPropertyNoDamage();
    oWeapon = GetItemInSlot(INVENTORY_SLOT_RIGHTHAND, oPC);
    if(IPGetIsMeleeWeapon(oWeapon)){
        if(!GetItemHasItemProperty(oWeapon, ITEM_PROPERTY_NO_DAMAGE)){
            SetLocalInt(oWeapon, "BaelnornProjection_NoDamage", TRUE);
            AddItemProperty(DURATION_TYPE_PERMANENT, ipNoDam, oWeapon);
        }
        // Check left hand only if right hand had a weapon
        oWeapon = GetItemInSlot(INVENTORY_SLOT_LEFTHAND, oPC);
        if(IPGetIsMeleeWeapon(oWeapon)){
            if(!GetItemHasItemProperty(oWeapon, ITEM_PROPERTY_NO_DAMAGE)){
                SetLocalInt(oWeapon, "BaelnornProjection_NoDamage", TRUE);
                AddItemProperty(DURATION_TYPE_PERMANENT, ipNoDam, oWeapon);
        }}
    }else if(IPGetIsRangedWeapon(oWeapon)){
        if(!GetItemHasItemProperty(oWeapon, ITEM_PROPERTY_NO_DAMAGE)){
            SetLocalInt(oWeapon, "BaelnornProjection_NoDamage", TRUE);
            AddItemProperty(DURATION_TYPE_PERMANENT, ipNoDam, oWeapon);
    }}

    oWeapon = GetItemInSlot(INVENTORY_SLOT_CWEAPON_B, oPC);
    if(GetIsObjectValid(oWeapon)){
        if(!GetItemHasItemProperty(oWeapon, ITEM_PROPERTY_NO_DAMAGE)){
            SetLocalInt(oWeapon, "BaelnornProjection_NoDamage", TRUE);
            AddItemProperty(DURATION_TYPE_PERMANENT, ipNoDam, oWeapon);
    }}
    oWeapon = GetItemInSlot(INVENTORY_SLOT_CWEAPON_L, oPC);
    if(GetIsObjectValid(oWeapon)){
        if(!GetItemHasItemProperty(oWeapon, ITEM_PROPERTY_NO_DAMAGE)){
            SetLocalInt(oWeapon, "BaelnornProjection_NoDamage", TRUE);
            AddItemProperty(DURATION_TYPE_PERMANENT, ipNoDam, oWeapon);
    }}
    oWeapon = GetItemInSlot(INVENTORY_SLOT_CWEAPON_R, oPC);
    if(GetIsObjectValid(oWeapon)){
        if(!GetItemHasItemProperty(oWeapon, ITEM_PROPERTY_NO_DAMAGE)){
            SetLocalInt(oWeapon, "BaelnornProjection_NoDamage", TRUE);
            AddItemProperty(DURATION_TYPE_PERMANENT, ipNoDam, oWeapon);
    }}
}



//Undoes changes made in NerfWeapons().

void UnNerfWeapons(object oPC){
    int nSpellId = GetSpellId();
    effect eCheck = GetFirstEffect(oPC);
    while(GetIsEffectValid(eCheck)){
        if(GetEffectSpellId(eCheck) == nSpellId &&
           GetEffectType(eCheck) == EFFECT_TYPE_ATTACK_DECREASE
          )
        {
            RemoveEffect(oPC, eCheck);
        }
        eCheck = GetNextEffect(oPC);
    }

    object oWeapon = GetItemInSlot(INVENTORY_SLOT_RIGHTHAND, oPC);
    if(GetLocalInt(oWeapon, "BaelnornProjection_NoDamage")){
        IPRemoveMatchingItemProperties(oWeapon, ITEM_PROPERTY_NO_DAMAGE, DURATION_TYPE_PERMANENT);
    }
    oWeapon = GetItemInSlot(INVENTORY_SLOT_LEFTHAND, oPC);
    if(GetLocalInt(oWeapon, "BaelnornProjection_NoDamage")){
        IPRemoveMatchingItemProperties(oWeapon, ITEM_PROPERTY_NO_DAMAGE, DURATION_TYPE_PERMANENT);
    }

    oWeapon = GetItemInSlot(INVENTORY_SLOT_CWEAPON_B, oPC);
    if(GetLocalInt(oWeapon, "BaelnornProjection_NoDamage")){
        IPRemoveMatchingItemProperties(oWeapon, ITEM_PROPERTY_NO_DAMAGE, DURATION_TYPE_PERMANENT);
    }
    oWeapon = GetItemInSlot(INVENTORY_SLOT_CWEAPON_L, oPC);
    if(GetLocalInt(oWeapon, "BaelnornProjection_NoDamage")){
        IPRemoveMatchingItemProperties(oWeapon, ITEM_PROPERTY_NO_DAMAGE, DURATION_TYPE_PERMANENT);
    }
    oWeapon = GetItemInSlot(INVENTORY_SLOT_CWEAPON_R, oPC);
    if(GetLocalInt(oWeapon, "BaelnornProjection_NoDamage")){
        IPRemoveMatchingItemProperties(oWeapon, ITEM_PROPERTY_NO_DAMAGE, DURATION_TYPE_PERMANENT);
    }

    // Remove no damage from unequipped weapons, too
    oWeapon = GetFirstItemInInventory(oPC);
    while(GetIsObjectValid(oWeapon)){
        if(GetLocalInt(oWeapon, "BaelnornProjection_NoDamage")){
            IPRemoveMatchingItemProperties(oWeapon, ITEM_PROPERTY_NO_DAMAGE, DURATION_TYPE_PERMANENT);
        }
        oWeapon = GetNextItemInInventory(oPC);
    }
}
