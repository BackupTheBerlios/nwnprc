#include "prc_inc_combmove"
#include "prc_inc_sneak"

void FastMovement(object oPC, int nClass)
{
    // Speed bonus. +10 feet at level 1
    ApplyEffectToObject(DURATION_TYPE_PERMANENT, ExtraordinaryEffect(EffectMovementSpeedIncrease(33)), oPC);
}

void main()
{
    int nEvent = GetRunningEvent();
    if(DEBUG) DoDebug("prc_bowman running, event: " + IntToString(nEvent));

    // Get the PC. This is event-dependent
    object oPC;
    switch(nEvent)
    {
        case EVENT_ONPLAYEREQUIPITEM:   oPC = GetItemLastEquippedBy();   break;
        case EVENT_ONPLAYERUNEQUIPITEM: oPC = GetItemLastUnequippedBy(); break;

        default:
            oPC = OBJECT_SELF;
    }

    object oItem;
    object oArmour = GetItemInSlot(INVENTORY_SLOT_CHEST, oPC);
    object oAmmo;
    int nClass = GetLevelByClass(CLASS_TYPE_BOWMAN, oPC);
    int nArmour = GetBaseAC(oArmour);


    // We aren't being called from any event, instead from EvalPRCFeats
    if(nEvent == FALSE)
    {
        // Light armour only
        if (5 >= nArmour)
        {
            FastMovement(oPC, nClass);
        }

        // Hook in the events, needed from level 1 for Skirmish
        if(DEBUG) DoDebug("prc_bowman: Adding eventhooks");
        AddEventScript(oPC, EVENT_ONPLAYEREQUIPITEM,   "prc_bowman", TRUE, FALSE);
        AddEventScript(oPC, EVENT_ONPLAYERUNEQUIPITEM, "prc_bowman", TRUE, FALSE);
    }
    // We are called from the OnPlayerEquipItem eventhook. Add OnHitCast: Unique Power to oPC's weapon
    else if(nEvent == EVENT_ONPLAYEREQUIPITEM && nClass >= 5)
    {
        oPC   = GetItemLastEquippedBy();
        oItem = GetItemLastEquipped();
        if(DEBUG) DoDebug("prc_bowman - OnEquip\n"
                        + "oPC = " + DebugObject2Str(oPC) + "\n"
                        + "oItem = " + DebugObject2Str(oItem) + "\n"
                          );

        // Only applies to weapons
        if(GetWeaponRanged(oItem))
        {
            // Add eventhook to the item
            AddEventScript(oItem, EVENT_ITEM_ONHIT, "prc_bowman", TRUE, FALSE);
            int ipDam = GetIntToDamage(GetAbilityModifier(ABILITY_DEXTERITY, oPC));

            // Makes sure to get ammo
            oAmmo = GetItemInSlot(INVENTORY_SLOT_BOLTS, oPC);
            IPSafeAddItemProperty(oAmmo, ItemPropertyDamageBonus(IP_CONST_DAMAGETYPE_PIERCING, ipDam), 99999.0, X2_IP_ADDPROP_POLICY_KEEP_EXISTING, FALSE, FALSE);

            oAmmo = GetItemInSlot(INVENTORY_SLOT_BULLETS, oPC);
            IPSafeAddItemProperty(oAmmo, ItemPropertyDamageBonus(IP_CONST_DAMAGETYPE_PIERCING, ipDam), 99999.0, X2_IP_ADDPROP_POLICY_KEEP_EXISTING, FALSE, FALSE);

            oAmmo = GetItemInSlot(INVENTORY_SLOT_ARROWS, oPC);
            IPSafeAddItemProperty(oAmmo, ItemPropertyDamageBonus(IP_CONST_DAMAGETYPE_PIERCING, ipDam), 99999.0, X2_IP_ADDPROP_POLICY_KEEP_EXISTING, FALSE, FALSE);
        }
    }
    // We are called from the OnPlayerUnEquipItem eventhook. Remove OnHitCast: Unique Power from oPC's weapon
    else if(nEvent == EVENT_ONPLAYERUNEQUIPITEM && nClass >= 5)
    {
        oPC   = GetItemLastUnequippedBy();
        oItem = GetItemLastUnequipped();
        if(DEBUG) DoDebug("prc_bowman - OnUnEquip\n"
                        + "oPC = " + DebugObject2Str(oPC) + "\n"
                        + "oItem = " + DebugObject2Str(oItem) + "\n"
                          );

        // Only applies to weapons
        if(GetWeaponRanged(oItem))
        {
            // Add eventhook to the item
            RemoveEventScript(oItem, EVENT_ITEM_ONHIT, "prc_bowman", TRUE, FALSE);
            int ipDam = GetIntToDamage(GetAbilityModifier(ABILITY_DEXTERITY, oPC));

            // Makes sure to get ammo if its a ranged weapon
            oAmmo = GetItemInSlot(INVENTORY_SLOT_BOLTS, oPC);
            RemoveSpecificProperty(oAmmo, ITEM_PROPERTY_DAMAGE_BONUS, IP_CONST_DAMAGETYPE_PIERCING, ipDam, 1, "", -1, DURATION_TYPE_TEMPORARY);

            oAmmo = GetItemInSlot(INVENTORY_SLOT_BULLETS, oPC);
            RemoveSpecificProperty(oAmmo, ITEM_PROPERTY_DAMAGE_BONUS, IP_CONST_DAMAGETYPE_PIERCING, ipDam, 1, "", -1, DURATION_TYPE_TEMPORARY);

            oAmmo = GetItemInSlot(INVENTORY_SLOT_ARROWS, oPC);
            RemoveSpecificProperty(oAmmo, ITEM_PROPERTY_DAMAGE_BONUS, IP_CONST_DAMAGETYPE_PIERCING, ipDam, 1, "", -1, DURATION_TYPE_TEMPORARY);
        }
    }
}