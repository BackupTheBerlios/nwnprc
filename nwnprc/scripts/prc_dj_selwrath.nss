//::///////////////////////////////////////////////
//:: Name Selvetarm's Wrath
//:: FileName prc_dj_selwrath
//:: Copyright (c) 2001 Bioware Corp.
//:://////////////////////////////////////////////
/*
The Selvetarm's Wrath feat for the Drow Judicator
*/
//:://////////////////////////////////////////////
//:: Created By: PsychicToaster
//:: Created On: 7-31-04
//:://////////////////////////////////////////////

#include "x2_inc_itemprop"
#include "prc_class_const"
#include "prc_spell_const"

int IPGetDamageBonus(object oItem);

void main()
{
object oPC   = OBJECT_SELF;
object oItem = GetItemInSlot(INVENTORY_SLOT_RIGHTHAND);

int nSpell   = GetSpellId();
int nClass   = GetLevelByClass(CLASS_TYPE_JUDICATOR);
int nDamage;

//Check if PC has a weapon equipped
if(oItem==OBJECT_INVALID)
    {
    SendMessageToPC(oPC, "You must have a melee weapon equipped to use this feat.");
    //debug
    SendMessageToPC(oPC, "Step 1 failure");
    return;
    }

nDamage = IPGetDamageBonus(oItem);

if(nSpell==SPELL_SELVETARMS_WRATH)
    {
    if(nDamage != -1)
        {
        int nNewDam = nDamage+nClass;
        itemproperty ipD8     = ItemPropertyDamageBonus(IP_CONST_DAMAGETYPE_NEGATIVE, IP_CONST_DAMAGEBONUS_1d8);
        itemproperty ipStatic = ItemPropertyEnhancementBonus(nNewDam);

        IPSafeAddItemProperty(oItem, ipD8, 12.0, X2_IP_ADDPROP_POLICY_REPLACE_EXISTING, FALSE, FALSE);
        IPSafeAddItemProperty(oItem, ipStatic, 12.0, X2_IP_ADDPROP_POLICY_REPLACE_EXISTING, FALSE, FALSE);

        ApplyEffectToObject(DURATION_TYPE_INSTANT, EffectVisualEffect(VFX_IMP_EVIL_HELP), oPC);

        //Debug
        SendMessageToPC(oPC, "Weapon infused with: "+IntToString(nNewDam)+" damage from: "+IntToString(nDamage)+" original damage.");
        }
    else SendMessageToPC(oPC, "You must have a melee weapon equipped to use this feat."+" Damage Bonus: "+IntToString(nDamage));


    }

}

/*
This function will determine the exact damage bonus up to 10 points.  It is
necessary to determine how much additional damage will be done beyond what
the weapon is normally capable of.

*/
int IPGetDamageBonus(object oItem)
{
int nDamage = -1;
object oPC;

if(IPGetIsMeleeWeapon(oItem))
    {
    if (IPGetItemHasProperty(oItem, ItemPropertyDamageBonus(DAMAGE_TYPE_BLUDGEONING, 1), DURATION_TYPE_PERMANENT))
            nDamage=1;
    else if (IPGetItemHasProperty(oItem, ItemPropertyDamageBonus(DAMAGE_TYPE_BLUDGEONING, 2), DURATION_TYPE_PERMANENT))
            nDamage=2;
    else if (IPGetItemHasProperty(oItem, ItemPropertyDamageBonus(DAMAGE_TYPE_BLUDGEONING, 3), DURATION_TYPE_PERMANENT))
            nDamage=3;
    else if (IPGetItemHasProperty(oItem, ItemPropertyDamageBonus(DAMAGE_TYPE_BLUDGEONING, 4), DURATION_TYPE_PERMANENT))
            nDamage=4;
    else if (IPGetItemHasProperty(oItem, ItemPropertyDamageBonus(DAMAGE_TYPE_BLUDGEONING, 5), DURATION_TYPE_PERMANENT))
            nDamage=5;
    else if (IPGetItemHasProperty(oItem, ItemPropertyDamageBonus(DAMAGE_TYPE_BLUDGEONING, 6), DURATION_TYPE_PERMANENT))
            nDamage=6;
    else if (IPGetItemHasProperty(oItem, ItemPropertyDamageBonus(DAMAGE_TYPE_BLUDGEONING, 7), DURATION_TYPE_PERMANENT))
            nDamage=7;
    else if (IPGetItemHasProperty(oItem, ItemPropertyDamageBonus(DAMAGE_TYPE_BLUDGEONING, 8), DURATION_TYPE_PERMANENT))
            nDamage=8;
    else if (IPGetItemHasProperty(oItem, ItemPropertyDamageBonus(DAMAGE_TYPE_BLUDGEONING, 9), DURATION_TYPE_PERMANENT))
            nDamage=9;
    else if (IPGetItemHasProperty(oItem, ItemPropertyDamageBonus(DAMAGE_TYPE_BLUDGEONING, 10), DURATION_TYPE_PERMANENT))
            nDamage=10;
    else if (IPGetItemHasProperty(oItem, ItemPropertyDamageBonus(DAMAGE_TYPE_SLASHING, 1), DURATION_TYPE_PERMANENT))
            nDamage=1;
    else if (IPGetItemHasProperty(oItem, ItemPropertyDamageBonus(DAMAGE_TYPE_SLASHING, 2), DURATION_TYPE_PERMANENT))
            nDamage=2;
    else if (IPGetItemHasProperty(oItem, ItemPropertyDamageBonus(DAMAGE_TYPE_SLASHING, 3), DURATION_TYPE_PERMANENT))
            nDamage=3;
    else if (IPGetItemHasProperty(oItem, ItemPropertyDamageBonus(DAMAGE_TYPE_SLASHING, 4), DURATION_TYPE_PERMANENT))
            nDamage=4;
    else if (IPGetItemHasProperty(oItem, ItemPropertyDamageBonus(DAMAGE_TYPE_SLASHING, 5), DURATION_TYPE_PERMANENT))
            nDamage=5;
    else if (IPGetItemHasProperty(oItem, ItemPropertyDamageBonus(DAMAGE_TYPE_SLASHING, 6), DURATION_TYPE_PERMANENT))
            nDamage=6;
    else if (IPGetItemHasProperty(oItem, ItemPropertyDamageBonus(DAMAGE_TYPE_SLASHING, 7), DURATION_TYPE_PERMANENT))
            nDamage=7;
    else if (IPGetItemHasProperty(oItem, ItemPropertyDamageBonus(DAMAGE_TYPE_SLASHING, 8), DURATION_TYPE_PERMANENT))
            nDamage=8;
    else if (IPGetItemHasProperty(oItem, ItemPropertyDamageBonus(DAMAGE_TYPE_SLASHING, 9), DURATION_TYPE_PERMANENT))
            nDamage=9;
    else if (IPGetItemHasProperty(oItem, ItemPropertyDamageBonus(DAMAGE_TYPE_SLASHING, 10), DURATION_TYPE_PERMANENT))
            nDamage=10;
    else if (IPGetItemHasProperty(oItem, ItemPropertyDamageBonus(DAMAGE_TYPE_PIERCING, 1), DURATION_TYPE_PERMANENT))
            nDamage=1;
    else if (IPGetItemHasProperty(oItem, ItemPropertyDamageBonus(DAMAGE_TYPE_PIERCING, 2), DURATION_TYPE_PERMANENT))
            nDamage=2;
    else if (IPGetItemHasProperty(oItem, ItemPropertyDamageBonus(DAMAGE_TYPE_PIERCING, 3), DURATION_TYPE_PERMANENT))
            nDamage=3;
    else if (IPGetItemHasProperty(oItem, ItemPropertyDamageBonus(DAMAGE_TYPE_PIERCING, 4), DURATION_TYPE_PERMANENT))
            nDamage=4;
    else if (IPGetItemHasProperty(oItem, ItemPropertyDamageBonus(DAMAGE_TYPE_PIERCING, 5), DURATION_TYPE_PERMANENT))
            nDamage=5;
    else if (IPGetItemHasProperty(oItem, ItemPropertyDamageBonus(DAMAGE_TYPE_PIERCING, 6), DURATION_TYPE_PERMANENT))
            nDamage=6;
    else if (IPGetItemHasProperty(oItem, ItemPropertyDamageBonus(DAMAGE_TYPE_PIERCING, 7), DURATION_TYPE_PERMANENT))
            nDamage=7;
    else if (IPGetItemHasProperty(oItem, ItemPropertyDamageBonus(DAMAGE_TYPE_PIERCING, 8), DURATION_TYPE_PERMANENT))
            nDamage=8;
    else if (IPGetItemHasProperty(oItem, ItemPropertyDamageBonus(DAMAGE_TYPE_PIERCING, 9), DURATION_TYPE_PERMANENT))
            nDamage=9;
    else if (IPGetItemHasProperty(oItem, ItemPropertyDamageBonus(DAMAGE_TYPE_PIERCING, 10), DURATION_TYPE_PERMANENT))
            nDamage=10;
    else nDamage=0;

    }

    return nDamage;

}
