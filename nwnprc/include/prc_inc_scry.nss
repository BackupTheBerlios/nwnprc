//::///////////////////////////////////////////////
//:: Scrying include
//:: prc_inc_scry
//::///////////////////////////////////////////////
/** @file
    This include contains all of the code that is used
    to scry. At the moment, this is the basic scrying
    and will be expanded with the additional material
    as coding goes along. This is based on the code
    of the Baelnorn Project written by Ornedan.

    All the operations work only on PCs, as there is no
    AI that could have NPCs take any advantage of the
    system.
*/
//:://////////////////////////////////////////////
//:: Created By: Stratovarius
//:: Created On: 30.04.2007
//:://////////////////////////////////////////////

#include "inc_utility"

///////////////////////
/* Public Constants  */
///////////////////////

const string COPY_LOCAL_NAME             = "Scry_Copy";
const string ALREADY_IMMORTAL_LOCAL_NAME = "Scry_ImmortalAlready";
const float  SCRY_HB_DELAY         = 1.0f;
// Will be moved out when its created.
const int SPELL_END_SCRY = -1;

//////////////////////////////////////////////////
/* Function prototypes                          */
//////////////////////////////////////////////////

/**
 * Moves all of the PC's items to the copy creature
 * Switches locations of the two creatures
 *
 * @param oPC     The PC on whom to operate.
 * @param oCopy   The copy of the PC
 * @param oTarget The target
 */
void DoScryBegin(object oPC, object oCopy, object oTarget);

/**
 * Undoes all the effects of DoScryBegin
 *
 * @param oPC   The PC on whom to operate.
 * @param oCopy The copy of the PC
 */
void DoScryEnd(object oPC, object oCopy);

/**
 * Runs tests to see if the Scry effect can still continue.
 * If the copy is dead, end Scry and kill the PC.
 *
 * @param oPC   The PC on whom to operate.
 * @param oCopy The copy of the PC
 */
void ScryMonitor(object oPC, object oCopy);

/**
 * Nerfs any weapon the PC holds to prevent them from dealing damage
 *
 * @param oPC   The PC on whom to operate.
 */
void ApplyScryEffects(object oPC);

/**
 * Reverses ApplyScryEffects
 *
 * @param oPC   The PC on whom to operate.
 */
void RemoveScryEffects(object oPC);

/**
 * Checks whether the PC is scrying or not
 *
 * @param oPC   The PC on whom to operate.
 */
int GetIsScrying(object oPC);

//////////////////////////////////////////////////
/* Function definitions                         */
//////////////////////////////////////////////////

void ScryMain(object oPC, object oTarget)
{
    // Get the main variables used.
    object oCopy     = GetLocalObject(oPC, COPY_LOCAL_NAME);
    effect eLight    = EffectVisualEffect(VFX_IMP_HEALING_X , FALSE);
    effect eGlow     = EffectVisualEffect(VFX_DUR_ETHEREAL_VISAGE, FALSE);
    // Use prestored variables because of time delay
    int nCasterLevel = GetLocalInt(oPC, "ScryCasterLevel");
    int nSpell       = GetLocalInt(oPC, "ScrySpellId");
    int nDC          = GetLocalInt(oPC, "ScrySpellDC");
    float fDur       = GetLocalFloat(oPC, "ScryDuration");
    
    
    
    if(DEBUG) DoDebug("prc_inc_scry: Beginning ScryMain. nSpell: " + IntToString(nSpell));
    if (nSpell != SPELL_CLAIRAUDIENCE_AND_CLAIRVOYANCE)
    {
    	//Make SR Check
    	if (MyPRCResistSpell(oPC, oTarget, nCasterLevel)) 
    	{
    		FloatingTextStringOnCreature("Target made Spell Resistance check vs Scrying", oPC, FALSE);
    		return;
    	}
    	// Save
    	if (PRCMySavingThrow(SAVING_THROW_WILL, oTarget, nDC, SAVING_THROW_TYPE_MIND_SPELLS)) 
    	{
    		FloatingTextStringOnCreature("Target saved vs Scrying", oPC, FALSE);
    		return;
    	}
    }
    
    if(DEBUG) DoDebug("prc_inc_scry running.\n"
                    + "oPC = '" + GetName(oPC) + "' - '" + GetTag(oPC) + "' - " + ObjectToString(oPC)
                    + "Copy exists: " + BooleanToString(GetIsObjectValid(oCopy))
                      );

    // Check if there is a valid copy around.
    // If so, abort
    if(nSpell == SPELL_END_SCRY)
    {
	  DoScryEnd(oPC, oCopy);
	  return;
    }

    // Create the copy
    oCopy = CopyObject(oPC, GetLocation(oTarget), OBJECT_INVALID, GetName(oPC) + "_" + COPY_LOCAL_NAME);
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
    if(GetImmortal(oPC))
    {
        if(DEBUG) DoDebug("prc_inc_scry: The PC was already immortal");
        SetLocalInt(oPC, ALREADY_IMMORTAL_LOCAL_NAME, TRUE);
    }
    else{
        if(DEBUG) DoDebug("prc_inc_scry: Setting PC immortal");
        SetImmortal(oPC, TRUE);
        DeleteLocalInt(oPC, ALREADY_IMMORTAL_LOCAL_NAME); // Paranoia
    }

    // Do VFX on PC and copy
    SPApplyEffectToObject(DURATION_TYPE_INSTANT, eLight, oCopy);
    SPApplyEffectToObject(DURATION_TYPE_INSTANT, eLight, oPC);

    // Do the switching around
    DoScryBegin(oPC, oCopy, oTarget);
    
    //Set up duration marker for ending effect
    DelayCommand(fDur, SetLocalInt(oPC, "SCRY_EXPIRED", 1));
}

// Moves the PC's items to the copy and switches their locations around
void DoScryBegin(object oPC, object oCopy, object oTarget)
{
    if(DEBUG) DoDebug("prc_inc_scry: DoScryBegin():\n"
                    + "oPC = '" + GetName(oPC) + "'\n"
                    + "oCopy = '" + GetName(oCopy) + "'"
                      );
    // Make sure both objects are valid
    if(!GetIsObjectValid(oCopy) || !GetIsObjectValid(oPC)){
        if(DEBUG) DoDebug("DoScryBegin called, but one of the parameters wasn't a valid object. Object status:" +
                          "\nPC - " + (GetIsObjectValid(oPC) ? "valid":"invalid") +
                          "\nCopy - " + (GetIsObjectValid(oCopy) ? "valid":"invalid")
                          );

        // Some cleanup before aborting
        if(!GetLocalInt(oPC, ALREADY_IMMORTAL_LOCAL_NAME))
        {
            SetImmortal(oPC, FALSE);
            DeleteLocalInt(oPC, ALREADY_IMMORTAL_LOCAL_NAME);
        }
        MyDestroyObject(oCopy);
        DeleteLocalInt(oPC, "Scry_Active");
        RemoveScryEffects(oPC);

        return;
    }

    // Set a local on the PC telling that it's a scry. This is used
    // to keep the PC from picking up or losing objects.
    // Also stops it from casting spells
    SetLocalInt(oPC, "Scry_Active", TRUE);
    location lTarget = GetLocation(oTarget);

    // Make the PC's weapons as non-damaging as possible
    ApplyScryEffects(oPC);

    // Start a pseudo-hb to monitor the status of both PC and copy
    DelayCommand(SCRY_HB_DELAY, ScryMonitor(oPC, oCopy));

    // Add eventhooks
    
    if(DEBUG) DoDebug("AddEventScripts");
    
    AddEventScript(oPC, EVENT_ONPLAYEREQUIPITEM,    "prc_scry_event", TRUE, FALSE); // OnEquip
    AddEventScript(oPC, EVENT_ONACQUIREITEM,        "prc_scry_event", TRUE, FALSE); // OnAcquire
    AddEventScript(oPC, EVENT_ONPLAYERREST_STARTED, "prc_scry_event", FALSE, FALSE); // OnRest
    AddEventScript(oPC, EVENT_ONCLIENTENTER,        "prc_scry_event", TRUE, FALSE); //OnClientEnter
    
    // Adjust reputation so the target monster doesn't attack you
    ApplyEffectToObject(DURATION_TYPE_TEMPORARY, ExtraordinaryEffect(EffectCharmed()), oTarget, GetLocalFloat(oPC, "ScryDuration"));
    // Swap the copy and PC
    location lPC   = GetLocation(oPC);
    location lCopy = GetLocation(oCopy);
    DelayCommand(1.5f,AssignCommand(oPC, JumpToLocation(lCopy)));
    DelayCommand(1.5f,AssignCommand(oCopy, JumpToLocation(lPC)));
}


// Switches the PC's inventory back from the copy and returns the PC to the copy's location.
void DoScryEnd(object oPC, object oCopy)
{
    if(DEBUG) DoDebug("prc_inc_scry: DoScryEnd():\n"
                    + "oPC = '" + GetName(oPC) + "'\n"
                    + "oCopy = '" + GetName(oCopy) + "'"
                      );

    //effect eGlow     = EffectVisualEffect(VFX_DUR_ETHEREAL_VISAGE, FALSE);
    effect eLight = EffectVisualEffect(VFX_IMP_HEALING_X , FALSE);
    
    // Remove Immortality from the PC if necessary
    if(!GetLocalInt(oPC, ALREADY_IMMORTAL_LOCAL_NAME))
        SetImmortal(oPC, FALSE);

    // Remove the VFX and the attack penalty
    RemoveSpellEffects(SPELL_SCRY, oPC, oPC);
        
    // Remove the local signifying that the PC is a projection
    DeleteLocalInt(oPC, "Scry_Active");

    // Remove the local signifying projection being terminated by an external cause
    DeleteLocalInt(oPC, "Scry_Abort");

    // Remove the heartbeat HP tracking local
    DeleteLocalInt(oPC, "Scry_HB_HP");
   // Delete all of the marker ints for the spell 
	DeleteLocalInt(oPC, "ScryCasterLevel");
	DeleteLocalInt(oPC, "ScrySpellId");
	DeleteLocalInt(oPC, "ScrySpellDC");
	DeleteLocalFloat(oPC, "ScryDuration");     

    // Remove weapons nerfing
    RemoveScryEffects(oPC);

    // Remove eventhooks
    RemoveEventScript(oPC, EVENT_ONPLAYEREQUIPITEM,    "prc_scry_event", TRUE, FALSE); // OnEquip
    RemoveEventScript(oPC, EVENT_ONACQUIREITEM,        "prc_scry_event", TRUE, FALSE); // OnAcquire
    RemoveEventScript(oPC, EVENT_ONPLAYERREST_STARTED, "prc_scry_event", FALSE, FALSE); // OnRest
    RemoveEventScript(oPC, EVENT_ONCLIENTENTER,        "prc_scry_event", TRUE, FALSE); //OnClientEnter

    // Move PC and inventory
    location lCopy = GetLocation(oCopy);
    DelayCommand(1.5f, AssignCommand(oPC, JumpToLocation(lCopy)));

    // Set the PC's hitpoints to be whatever the copy has
    int nOffset = GetCurrentHitPoints(oCopy) - GetCurrentHitPoints(oPC);
    if(nOffset > 0)
        ApplyEffectToObject(DURATION_TYPE_INSTANT, EffectHeal(nOffset), oPC);
    else if (nOffset < 0)
        ApplyEffectToObject(DURATION_TYPE_INSTANT, EffectDamage(-nOffset, DAMAGE_TYPE_MAGICAL, DAMAGE_POWER_ENERGY), oPC);

    // Schedule deletion of the copy
    DelayCommand(0.3f, MyDestroyObject(oCopy));

    //Delete the object reference
    DeleteLocalObject(oPC, COPY_LOCAL_NAME);

    // VFX
    ApplyEffectAtLocation(DURATION_TYPE_TEMPORARY, eLight, lCopy, 3.0);
    DestroyObject(oCopy);
    
    //Remove duration marker
    DeleteLocalInt(oPC, "SCRY_EXPIRED");
}

//Runs tests to see if the projection effect can still continue.
//If the PC has reached 1 HP, end projection normally.
//If the copy is dead, end projection and kill the PC.
void ScryMonitor(object oPC, object oCopy)
{
    if(DEBUG) DoDebug("prc_inc_scry: ScryMonitor():\n"
                    + "oPC = '" + GetName(oPC) + "'\n"
                    + "oCopy = '" + GetName(oCopy) + "'"
                      );
    // Abort if the projection is no longer marked as being active
    if(!GetLocalInt(oPC, "Scry_Active"))
        return;

    // Some paranoia in case something interfered and either PC or copy has been destroyed
    if(!(GetIsObjectValid(oPC) && GetIsObjectValid(oCopy))){
        WriteTimestampedLogEntry("Baelnorn Projection hearbeat aborting due to an invalid object. Object status:" +
                                 "\nPC - " + (GetIsObjectValid(oPC) ? "valid":"invalid") +
                                 "\nCopy - " + (GetIsObjectValid(oCopy) ? "valid":"invalid"));
        return;
    }

    // Start the actual work by checking the copy's status. The death thing should take priority
    if(GetIsDead(oCopy))
    {
        DoScryEnd(oPC, oCopy);
        effect eKill = EffectDamage(GetCurrentHitPoints(oPC), DAMAGE_TYPE_MAGICAL, DAMAGE_POWER_ENERGY);
        ApplyEffectToObject(DURATION_TYPE_INSTANT, eKill, oPC);
    }
    else
    {
        // Check if the "projection" has been destroyed or if some other event has caused the projection to end
        if(GetLocalInt(oPC, "Scry_Abort"))
        {
            if(DEBUG) DoDebug("prc_inc_scry: ScryMonitor(): The Projection has been terminated, ending projection");
            DoScryEnd(oPC, oCopy);
        }
        else
            DelayCommand(SCRY_HB_DELAY, ScryMonitor(oPC, oCopy));
        
        //If duration expired, end effect
        if(GetLocalInt(oPC, "SCRY_EXPIRED"))
        {
		DoScryEnd(oPC, oCopy);
	}
    }
}

/*

This has been moved to the individual spell scripts, because that way it is attached to SpellId.

//Gives the PC -50 to attack and places No Damage iprop to all equipped weapons.
void ApplyScryEffects(object oPC)
{
    if(DEBUG) DoDebug("prc_inc_scry: ApplyScryEffects():\n"
                    + "oPC = '" + GetName(oPC) + "'"
                      );
    // The Scryer is not supposed to be visible, nor can he move or cast
    // He also can't take damage from scrying
        effect eLink    = EffectSpellImmunity(SPELL_ALL_SPELLS);
        // Damage immunities
               eLink    = EffectLinkEffects(eLink, EffectDamageImmunityIncrease(DAMAGE_TYPE_ACID,        100));
               eLink    = EffectLinkEffects(eLink, EffectDamageImmunityIncrease(DAMAGE_TYPE_BLUDGEONING, 100));
               eLink    = EffectLinkEffects(eLink, EffectDamageImmunityIncrease(DAMAGE_TYPE_COLD,        100));
               eLink    = EffectLinkEffects(eLink, EffectDamageImmunityIncrease(DAMAGE_TYPE_DIVINE,      100));
               eLink    = EffectLinkEffects(eLink, EffectDamageImmunityIncrease(DAMAGE_TYPE_ELECTRICAL,  100));
               eLink    = EffectLinkEffects(eLink, EffectDamageImmunityIncrease(DAMAGE_TYPE_FIRE,        100));
               eLink    = EffectLinkEffects(eLink, EffectDamageImmunityIncrease(DAMAGE_TYPE_MAGICAL,     100));
               eLink    = EffectLinkEffects(eLink, EffectDamageImmunityIncrease(DAMAGE_TYPE_NEGATIVE,    100));
               eLink    = EffectLinkEffects(eLink, EffectDamageImmunityIncrease(DAMAGE_TYPE_PIERCING,    100));
               eLink    = EffectLinkEffects(eLink, EffectDamageImmunityIncrease(DAMAGE_TYPE_POSITIVE,    100));
               eLink    = EffectLinkEffects(eLink, EffectDamageImmunityIncrease(DAMAGE_TYPE_SLASHING,    100));
               eLink    = EffectLinkEffects(eLink, EffectDamageImmunityIncrease(DAMAGE_TYPE_SONIC,       100));
        // Specific immunities
               eLink    = EffectLinkEffects(eLink, EffectImmunity(IMMUNITY_TYPE_ABILITY_DECREASE));
               eLink    = EffectLinkEffects(eLink, EffectImmunity(IMMUNITY_TYPE_BLINDNESS));
               eLink    = EffectLinkEffects(eLink, EffectImmunity(IMMUNITY_TYPE_DEAFNESS));
               eLink    = EffectLinkEffects(eLink, EffectImmunity(IMMUNITY_TYPE_CRITICAL_HIT));
               eLink    = EffectLinkEffects(eLink, EffectImmunity(IMMUNITY_TYPE_DEATH));
               eLink    = EffectLinkEffects(eLink, EffectImmunity(IMMUNITY_TYPE_DISEASE));
               eLink    = EffectLinkEffects(eLink, EffectImmunity(IMMUNITY_TYPE_ENTANGLE));
               eLink    = EffectLinkEffects(eLink, EffectImmunity(IMMUNITY_TYPE_SLOW));
               eLink    = EffectLinkEffects(eLink, EffectImmunity(IMMUNITY_TYPE_KNOCKDOWN));
               eLink    = EffectLinkEffects(eLink, EffectImmunity(IMMUNITY_TYPE_NEGATIVE_LEVEL));
               eLink    = EffectLinkEffects(eLink, EffectImmunity(IMMUNITY_TYPE_PARALYSIS));
               eLink    = EffectLinkEffects(eLink, EffectImmunity(IMMUNITY_TYPE_SILENCE));
               eLink    = EffectLinkEffects(eLink, EffectImmunity(IMMUNITY_TYPE_SNEAK_ATTACK));
               eLink    = EffectLinkEffects(eLink, EffectImmunity(IMMUNITY_TYPE_TRAP));
               eLink    = EffectLinkEffects(eLink, EffectImmunity(IMMUNITY_TYPE_MIND_SPELLS));
       // Random stuff
       	       eLink      = EffectLinkEffects(eLink, EffectCutsceneGhost());
       	       eLink      = EffectLinkEffects(eLink, EffectCutsceneImmobilize());
       	       eLink      = EffectLinkEffects(eLink, EffectEthereal());
       	       eLink      = EffectLinkEffects(eLink, EffectAttackDecrease(50));
       	       eLink      = EffectLinkEffects(eLink, EffectVisualEffect(VFX_DUR_CUTSCENE_INVISIBILITY));
       	       // Permanent until Scry ends
       	       ApplyEffectToObject(DURATION_TYPE_TEMPORARY, ExtraordinaryEffect(eLink), oPC, GetLocalFloat(oPC, "ScryDuration") + 6.0);

    // Create array for storing a list of the nerfed weapons in
    array_create(oPC, "Scry_Nerfed");

    object oWeapon;
    itemproperty ipNoDam = ItemPropertyNoDamage();
    oWeapon = GetItemInSlot(INVENTORY_SLOT_RIGHTHAND, oPC);
    if(IPGetIsMeleeWeapon(oWeapon)){
        if(!GetItemHasItemProperty(oWeapon, ITEM_PROPERTY_NO_DAMAGE)){
            //SetLocalInt(oWeapon, "BaelnornProjection_NoDamage", TRUE);
            AddItemProperty(DURATION_TYPE_PERMANENT, ipNoDam, oWeapon);
            array_set_object(oPC, "Scry_Nerfed", array_get_size(oPC, "Scry_Nerfed"), oWeapon);
        }
        // Check left hand only if right hand had a weapon
        oWeapon = GetItemInSlot(INVENTORY_SLOT_LEFTHAND, oPC);
        if(IPGetIsMeleeWeapon(oWeapon)){
            if(!GetItemHasItemProperty(oWeapon, ITEM_PROPERTY_NO_DAMAGE)){
                //SetLocalInt(oWeapon, "BaelnornProjection_NoDamage", TRUE);
                AddItemProperty(DURATION_TYPE_PERMANENT, ipNoDam, oWeapon);
                array_set_object(oPC, "Scry_Nerfed", array_get_size(oPC, "Scry_Nerfed"), oWeapon);
        }}
    }else if(IPGetIsRangedWeapon(oWeapon)){
        if(!GetItemHasItemProperty(oWeapon, ITEM_PROPERTY_NO_DAMAGE)){
            //SetLocalInt(oWeapon, "BaelnornProjection_NoDamage", TRUE);
            AddItemProperty(DURATION_TYPE_PERMANENT, ipNoDam, oWeapon);
            array_set_object(oPC, "Scry_Nerfed", array_get_size(oPC, "Scry_Nerfed"), oWeapon);
    }}

    oWeapon = GetItemInSlot(INVENTORY_SLOT_CWEAPON_B, oPC);
    if(GetIsObjectValid(oWeapon)){
        if(!GetItemHasItemProperty(oWeapon, ITEM_PROPERTY_NO_DAMAGE)){
            //SetLocalInt(oWeapon, "BaelnornProjection_NoDamage", TRUE);
            AddItemProperty(DURATION_TYPE_PERMANENT, ipNoDam, oWeapon);
            array_set_object(oPC, "Scry_Nerfed", array_get_size(oPC, "Scry_Nerfed"), oWeapon);
    }}
    oWeapon = GetItemInSlot(INVENTORY_SLOT_CWEAPON_L, oPC);
    if(GetIsObjectValid(oWeapon)){
        if(!GetItemHasItemProperty(oWeapon, ITEM_PROPERTY_NO_DAMAGE)){
            //SetLocalInt(oWeapon, "BaelnornProjection_NoDamage", TRUE);
            AddItemProperty(DURATION_TYPE_PERMANENT, ipNoDam, oWeapon);
            array_set_object(oPC, "Scry_Nerfed", array_get_size(oPC, "Scry_Nerfed"), oWeapon);
    }}
    oWeapon = GetItemInSlot(INVENTORY_SLOT_CWEAPON_R, oPC);
    if(GetIsObjectValid(oWeapon)){
        if(!GetItemHasItemProperty(oWeapon, ITEM_PROPERTY_NO_DAMAGE)){
            //SetLocalInt(oWeapon, "BaelnornProjection_NoDamage", TRUE);
            AddItemProperty(DURATION_TYPE_PERMANENT, ipNoDam, oWeapon);
            array_set_object(oPC, "Scry_Nerfed", array_get_size(oPC, "Scry_Nerfed"), oWeapon);
    }}
}
*/


//Undoes changes made in ApplyScryEffects().
void RemoveScryEffects(object oPC)
{
    if(DEBUG) DoDebug("prc_inc_scry: RemoveScryEffects():\n"
                    + "oPC = '" + GetName(oPC) + "'"
                      );
    effect eCheck = GetFirstEffect(oPC);
    while(GetIsEffectValid(eCheck)){
        if(GetEffectSpellId(eCheck) == GetLocalInt(oPC, "ScrySpellId"))
        {
            RemoveEffect(oPC, eCheck);
        }
        eCheck = GetNextEffect(oPC);
    }

    // Remove the no-damage property from all weapons it was added to
    int i;
    object oWeapon;
    for(i = 0; i < array_get_size(oPC, "Scry_Nerfed"); i++)
    {
        oWeapon = array_get_object(oPC, "Scry_Nerfed", i);
        IPRemoveMatchingItemProperties(oWeapon, ITEM_PROPERTY_NO_DAMAGE, DURATION_TYPE_PERMANENT);
    }

    array_delete(oPC, "Scry_Nerfed");
}

int GetIsScrying(object oPC)
{
	return GetLocalInt(oPC, "Scry_Active");
}