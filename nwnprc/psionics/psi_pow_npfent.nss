/*
   ----------------
   Null Psionics Field - OnEnter

   psi_pow_npfent
   ----------------

   6/10/05 by Stratovarius
*/ /** @file

    Null Psionics Field - OnEnter

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

object GetChest(object oCreature)
{
    object oChest = GetObjectByTag("npf_chest" + ObjectToString(oCreature));
    if(oChest == OBJECT_INVALID)
    {
        object oWP = GetWaypointByTag("npf_wp_chest_sp");
        oChest = CreateObject(OBJECT_TYPE_PLACEABLE, "npf_keep_chest", GetLocation(oWP), FALSE,
                    "npf_chest" + ObjectToString(oCreature));
    }
    return oChest;
}

int GetIsAlcohol(object oItem)
{
    itemproperty ip;
    ip = GetFirstItemProperty(oItem);
    // if there is more than 1 property then this item should be stripped
    if(GetIsItemPropertyValid(GetNextItemProperty(oItem)))
        return FALSE;
    if(GetItemPropertyType(ip) == ITEM_PROPERTY_CAST_SPELL)
    {
        if(GetItemPropertySubType(ip) == IP_CONST_CASTSPELL_SPECIAL_ALCOHOL_BEER ||
           GetItemPropertySubType(ip) == IP_CONST_CASTSPELL_SPECIAL_ALCOHOL_SPIRITS ||
           GetItemPropertySubType(ip) == IP_CONST_CASTSPELL_SPECIAL_ALCOHOL_WINE)
            return TRUE;
    }
    return FALSE;
}

int GetIsPoisonAmmo(object oItem)
{
    itemproperty ip;
    ip = GetFirstItemProperty(oItem);
    // if there is more than 1 property then this item should be stripped
    if(GetIsItemPropertyValid(GetNextItemProperty(oItem)))
        return FALSE;

    if(IPGetItemHasItemOnHitPropertySubType(oItem, IP_CONST_ONHIT_ITEMPOISON))
        return TRUE; // single poison property
    return FALSE;
}

int GetIsDyeKit(object oItem)
{
    if(GetBaseItemType(oItem) == BASE_ITEM_MISCSMALL)
    {
        itemproperty ip = GetFirstItemProperty(oItem);
        if(GetItemPropertyType(ip) == ITEM_PROPERTY_CAST_SPELL)
        {
            int nSubType = GetItemPropertySubType(ip);
            return (nSubType >= 490 && nSubType <= 497);
        }
        return FALSE;
    }
    return FALSE;
}

void RemoveAllProperties(object oItem, object oPC)
{
    if(DEBUG) DoDebug("psi_pow_npfent: About to remove properties from item: " + DebugObject2Str(oItem));

    int nType = GetBaseItemType(oItem);
    if(nType == BASE_ITEM_TORCH ||
       nType == BASE_ITEM_TRAPKIT ||
       nType == BASE_ITEM_HEALERSKIT ||
       nType == BASE_ITEM_GRENADE ||
       nType == BASE_ITEM_THIEVESTOOLS ||
       nType == 109 || // crafting stuff
       nType == 110 ||
       nType == 112)
        return;

    if(GetIsAlcohol(oItem) || GetIsPoisonAmmo(oItem) || GetIsDyeKit(oItem))
        return;
    if(oItem == OBJECT_INVALID)
        return;

    object oWP = GetWaypointByTag("npf_wp_chest_sp");

    // Generate UID
    int nKey = GetLocalInt(GetModule(), "PRC_NullPsionicsField_Item_UID_Counter") + 1;
               SetLocalInt(GetModule(), "PRC_NullPsionicsField_Item_UID_Counter", nKey);
    string sKey = IntToString(nKey);
    if(DEBUG) DoDebug("prc_pow_npfent: Removing itemproperties from item " + DebugObject2Str(oItem) + " with key value of '" + sKey + "' of creature " + DebugObject2Str(oPC));

    //object oChest = GetChest(oPC);
    //object oCopy = CopyObject(oItem, GetLocation(oChest), oChest);

    // copying  original item to a secluded waypoint in the area
    // and giving it a tag that contains the key string
    object oCopy = CopyObject(oItem, GetLocation(oWP), OBJECT_INVALID, "npf_item" + sKey);

    //storing the key value on the original item (key value would point to the copy item)
    SetLocalString(oItem, "PRC_NullPsionicsField_Item_UID", sKey);

    //SetLocalObject(oItem, "ITEM_CHEST", oChest); // so the chest can be found
    //SetLocalObject(oChest, sKey, oCopy); // and referenced in the chest

    // Stripping original item from all properties
    itemproperty ip = GetFirstItemProperty(oItem);
    while(GetIsItemPropertyValid(ip))
    {
        RemoveItemProperty(oItem, ip);
        ip = GetNextItemProperty(oItem);
    }
}

void RemoveEffectsNPF(object oObject)
{
    effect eEff = GetFirstEffect(oObject);
    while(GetIsEffectValid(eEff))
    {
        int nType = GetEffectType(eEff);
        if(GetEffectSubType(eEff) != SUBTYPE_EXTRAORDINARY &&
           (nType == EFFECT_TYPE_ABILITY_INCREASE          ||
            nType == EFFECT_TYPE_AC_INCREASE               ||
            nType == EFFECT_TYPE_ATTACK_INCREASE           ||
            nType == EFFECT_TYPE_BLINDNESS                 ||
            nType == EFFECT_TYPE_CHARMED                   ||
            nType == EFFECT_TYPE_CONCEALMENT               ||
            nType == EFFECT_TYPE_CONFUSED                  ||
            nType == EFFECT_TYPE_CURSE                     ||
            nType == EFFECT_TYPE_DAMAGE_IMMUNITY_INCREASE  ||
            nType == EFFECT_TYPE_DAMAGE_INCREASE           ||
            nType == EFFECT_TYPE_DAMAGE_REDUCTION          ||
            nType == EFFECT_TYPE_DAMAGE_RESISTANCE         ||
            nType == EFFECT_TYPE_DAZED                     ||
            nType == EFFECT_TYPE_DEAF                      ||
            nType == EFFECT_TYPE_DOMINATED                 ||
            nType == EFFECT_TYPE_ELEMENTALSHIELD           ||
            nType == EFFECT_TYPE_ETHEREAL                  ||
            nType == EFFECT_TYPE_FRIGHTENED                ||
            nType == EFFECT_TYPE_HASTE                     ||
            nType == EFFECT_TYPE_IMMUNITY                  ||
            nType == EFFECT_TYPE_IMPROVEDINVISIBILITY      ||
            nType == EFFECT_TYPE_INVISIBILITY              ||
            nType == EFFECT_TYPE_INVULNERABLE              ||
            nType == EFFECT_TYPE_ABILITY_INCREASE          ||
            nType == EFFECT_TYPE_NEGATIVELEVEL             ||
            nType == EFFECT_TYPE_PARALYZE                  ||
            nType == EFFECT_TYPE_POLYMORPH                 ||
            nType == EFFECT_TYPE_REGENERATE                ||
            nType == EFFECT_TYPE_SANCTUARY                 ||
            nType == EFFECT_TYPE_SAVING_THROW_INCREASE     ||
            nType == EFFECT_TYPE_SEEINVISIBLE              ||
            nType == EFFECT_TYPE_SILENCE                   ||
            nType == EFFECT_TYPE_SKILL_INCREASE            ||
            nType == EFFECT_TYPE_SLOW                      ||
            nType == EFFECT_TYPE_SPELL_IMMUNITY            ||
            nType == EFFECT_TYPE_SPELL_RESISTANCE_INCREASE ||
            nType == EFFECT_TYPE_SPELLLEVELABSORPTION      ||
            nType == EFFECT_TYPE_TEMPORARY_HITPOINTS       ||
            nType == EFFECT_TYPE_TRUESEEING                ||
            nType == EFFECT_TYPE_ULTRAVISION               ||
            nType == EFFECT_TYPE_INVULNERABLE
            )
           )
            RemoveEffect(oObject, eEff);
        
        eEff = GetNextEffect(oObject);
    }
}

void main()
{
    object oEnter = GetEnteringObject();

    if(GetObjectType(oEnter) == OBJECT_TYPE_CREATURE)
    {
        if(DEBUG) DoDebug("psi_pow_npfent: Creatured entered Null Psionics Field: " + DebugObject2Str(oEnter));
        
        // Set the marker variable
        SetLocalInt(oEnter, "NullPsionicsField", TRUE);
        
        // Remove all non-extraordinary effects
        RemoveEffectsNPF(oEnter);
        
        // Apply absolute spell failure
        effect eSpellFailure = EffectSpellFailure(100, SPELL_SCHOOL_GENERAL);
        ApplyEffectToObject(DURATION_TYPE_PERMANENT, eSpellFailure, oEnter);
        
        
        // Handle all items in inventory:
        object oItem = GetFirstItemInInventory(oEnter);
        while(oItem != OBJECT_INVALID)
        {
            RemoveAllProperties(oItem, oEnter);
            oItem = GetNextItemInInventory(oEnter);
        }
        oItem = GetItemInSlot(INVENTORY_SLOT_ARMS, oEnter);
        RemoveAllProperties(oItem, oEnter);
        oItem = GetItemInSlot(INVENTORY_SLOT_ARROWS, oEnter);
        RemoveAllProperties(oItem, oEnter);
        oItem = GetItemInSlot(INVENTORY_SLOT_BELT, oEnter);
        RemoveAllProperties(oItem, oEnter);
        oItem = GetItemInSlot(INVENTORY_SLOT_BOLTS, oEnter);
        RemoveAllProperties(oItem, oEnter);
        oItem = GetItemInSlot(INVENTORY_SLOT_BOOTS, oEnter);
        RemoveAllProperties(oItem, oEnter);
        oItem = GetItemInSlot(INVENTORY_SLOT_BULLETS, oEnter);
        RemoveAllProperties(oItem, oEnter);
        oItem = GetItemInSlot(INVENTORY_SLOT_CHEST, oEnter);
        RemoveAllProperties(oItem, oEnter);
        oItem = GetItemInSlot(INVENTORY_SLOT_CLOAK, oEnter);
        RemoveAllProperties(oItem, oEnter);
        oItem = GetItemInSlot(INVENTORY_SLOT_HEAD, oEnter);
        RemoveAllProperties(oItem, oEnter);
        oItem = GetItemInSlot(INVENTORY_SLOT_LEFTHAND, oEnter);
        RemoveAllProperties(oItem, oEnter);
        oItem = GetItemInSlot(INVENTORY_SLOT_LEFTRING, oEnter);
        RemoveAllProperties(oItem, oEnter);
        oItem = GetItemInSlot(INVENTORY_SLOT_NECK, oEnter);
        RemoveAllProperties(oItem, oEnter);
        oItem = GetItemInSlot(INVENTORY_SLOT_RIGHTHAND, oEnter);
        RemoveAllProperties(oItem, oEnter);
        oItem = GetItemInSlot(INVENTORY_SLOT_RIGHTRING, oEnter);
        RemoveAllProperties(oItem, oEnter);
    }
}