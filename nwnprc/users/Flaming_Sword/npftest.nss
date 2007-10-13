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

int GetIsExempt(object oItem)
{
    return (GetIsAlcohol(oItem) || GetIsPoisonAmmo(oItem) || GetIsDyeKit(oItem));
}

void StoreObjects(object oCreature)
{
    int nSlotMax = INVENTORY_SLOT_CWEAPON_L;    //max slot number, to exempt creature items
    int i;
    int nObjectCount = 0;
    object oItem;
    //SetPersistantLocalInt(oCreature, "PRC_NPF", TRUE);
    persistant_array_create(oCreature, "PRC_NPF_ItemList");

    for(i = 0; i < nSlotMax; i++)
    {
        oItem = GetItemInSlot(i, oCreature);
        if(GetIsObjectValid(oItem) && !GetIsExempt(oItem))
        {
            if((i < INVENTORY_SLOT_ARROWS && i > INVENTORY_SLOT_BOLTS) || !GetIsPoisonAmmo(oItem))  //ammo placeholders
            {
                //stuff here;
            }
        }
    }
}



void main()
{
    object oEnter = GetEnteringObject();
    if(GetObjectType(oEnter) == OBJECT_TYPE_CREATURE && GetPersistentLocalInt(oEnter, "NullPsionicsField"))
    {
        if(DEBUG) DoDebug("psi_pow_npfent: Creatured entered Null Psionics Field: " + DebugObject2Str(oEnter));

        SetPersistentLocalInt(oEnter, "NullPsionicsField", TRUE);

        // Set the marker variable
        SetLocalInt(oEnter, "NullPsionicsField", TRUE);

        // Remove all non-extraordinary effects
        RemoveEffectsNPF(oEnter);

        // Apply absolute spell failure
        effect eSpellFailure = EffectSpellFailure(100, SPELL_SCHOOL_GENERAL);
        ApplyEffectToObject(DURATION_TYPE_PERMANENT, eSpellFailure, oEnter);

        // Store itemproperties and remove them from objects
        StoreObjects(oEnter);

    }
}