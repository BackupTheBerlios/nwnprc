/*
    Drunken Master Prestige Class functions.
    This script holds all the functions the Drunken Master
    feats/abilities use.

    Jeremiah Teague
*/

// Include Files:
#include "nw_i0_spells"
#include "nw_i0_generic"
#include "x2_inc_spellhook"
#include "x2_inc_itemprop"
#include "prc_class_const"
#include "prc_feat_const"

// Function Definitions:

// Searches oPC's inventory and finds the first valid alcoholic beverage container
// (empty) and returns TRUE if a proper container was found. This function takes
// action and returns a boolean.
int UseBottle(object oPC);

// Searches oPC's inventory for an alcoholic beverage and if one is found it's
// destroyed and replaced by an empty container. This function is only used in
// the Breath of Fire spell script.
int UseAlcohol(object oPC);

// Removes Drunken Rage effects for oTarget. Used in B o Flame.
void RemoveDrunkenRageEffects(object oTarget = OBJECT_SELF);

// Creates an empty bottle on oPC.
// sTag: the tag of the alcoholic beverage used (ale, spirits, wine)
void CreateBottleOnObject(object oPC, string sTag);

// Returns the size modifier for the Drunken Embrace grapple check.
int GetSizeModifier(object oTarget);

// Returns an approximate damage roll so it can be doubled for Stagger's double
// damage effect.
int GetCreatureDamage(object oTarget = OBJECT_SELF);

// See if oTarget has a free hand to weild an empty bottle with.
int GetHasFreeHand(object oTarget = OBJECT_SELF);

// Have non-drunken masters burp after drinking alcohol.
void DrinkIt(object oTarget);

// Add the non-drunken master drinking effects.
void MakeDrunk(object oTarget, int nPoints);

// Have the drunken master say one of 6 phrases.
void DrunkenMasterSpeakString(object oTarget);

// Creates an empty bottle on oPC.
// nBeverage: the spell id of the alcoholic beverage used (ale, spirits, wine)
void DrunkenMasterCreateEmptyBottle(object oTarget, int nBeverage);

// Add's all the AC bonuses and other permanent effects to the drunken master's
// creature skin.
int AddDrunkenMasterSkinProperties(object oPC, object oSkin);



// Functions:
int UseBottle(object oPC)
{
object oItem = GetFirstItemInInventory(oPC);
//search oPC for a bottle:
while(oItem != OBJECT_INVALID)
    {
    if(GetTag(oItem) == "NW_IT_THNMISC001" || GetTag(oItem) == "NW_IT_THNMISC002" ||
       GetTag(oItem) == "NW_IT_THNMISC003" || GetTag(oItem) == "NW_IT_THNMISC004")
        {
        SetPlotFlag(oItem, FALSE);
        DestroyObject(oItem);
        return TRUE;
        }
    else
        oItem = GetNextItemInInventory();
    }
return FALSE;
}

int UseAlcohol(object oPC)
{
object oItem = GetFirstItemInInventory(oPC);
//search oPC for alcohol:
while(oItem != OBJECT_INVALID)
    {
    if(GetTag(oItem) == "NW_IT_MPOTION021" || GetTag(oItem) == "NW_IT_MPOTION022" ||
       GetTag(oItem) == "NW_IT_MPOTION023" || GetTag(oItem) == "DragonsBreath")
        {
        string sTag = GetTag(oItem);
        SetPlotFlag(oItem, FALSE);
        if(GetItemStackSize(oItem) > 1)
            {
            SetItemStackSize(oItem, GetItemStackSize(oItem) - 1);
            // Create an Empty Bottle:
            CreateBottleOnObject(oPC, sTag);
            return TRUE;
            }
        else
            {
            DestroyObject(oItem);
            // Create an Empty Bottle:
            CreateBottleOnObject(oPC, sTag);
            return TRUE;
            }
        }
    else
        {oItem = GetNextItemInInventory();}
    }
return FALSE;
}

void CreateBottleOnObject(object oPC, string sTag)
{
    if(sTag == "NW_IT_MPOTION021") // Ale
    {
        CreateItemOnObject("nw_it_thnmisc002", oPC);
    }
    else if(sTag == "NW_IT_MPOTION022") // Spirits
    {
        CreateItemOnObject("nw_it_thnmisc003", oPC);
    }
    else if(sTag == "NW_IT_MPOTION023") // Wine
    {
        CreateItemOnObject("nw_it_thnmisc004", oPC);
    }
    else // Other beverage
    {
        CreateItemOnObject("nw_it_thnmisc001", oPC);
    }
}

void RemoveDrunkenRageEffects(object oTarget = OBJECT_SELF)
{

    RemoveSpecificEffect(EFFECT_TYPE_ABILITY_INCREASE, oTarget);
    RemoveSpecificEffect(EFFECT_TYPE_SAVING_THROW_INCREASE, oTarget);
    RemoveSpecificEffect(EFFECT_TYPE_AC_DECREASE, oTarget);
    RemoveSpecificEffect(EFFECT_TYPE_VISUALEFFECT, oTarget);

    SetLocalInt(oTarget, "DRUNKEN_MASTER_IS_IN_DRUNKEN_RAGE", 0);
}

int GetSizeModifier(object oTarget)
{
int nSizeMod = 0;
switch(GetCreatureSize(oTarget))
    {
    case CREATURE_SIZE_HUGE:
        {
        nSizeMod = 8;
        break;
        }
    case CREATURE_SIZE_LARGE:
        {
        nSizeMod = 4;
        break;
        }
    case CREATURE_SIZE_MEDIUM:
        {
        nSizeMod = 0;
        break;
        }
    case CREATURE_SIZE_SMALL:
        {
        nSizeMod = -4;
        break;
        }
    case CREATURE_SIZE_TINY:
        {
        nSizeMod = -8;
        break;
        }
    case CREATURE_SIZE_INVALID:
        {
        nSizeMod = 0;
        break;
        }
    }
return nSizeMod;
}

int GetCreatureDamage(object oTarget = OBJECT_SELF)
{
int nDamage = 0;
object oItem = GetItemInSlot(INVENTORY_SLOT_RIGHTHAND);

switch(GetBaseItemType(oItem))
    {
    case BASE_ITEM_INVALID:
        {//Unarmed:
        int nlvl = GetLevelByClass(CLASS_TYPE_MONK, oTarget) + GetLevelByClass(CLASS_TYPE_DRUNKEN_MASTER, oTarget);
        if(nlvl < 4)
            {nDamage = d6();}
        else if(nlvl < 8)
            {nDamage = d8();}
        else if(nlvl < 12)
            {nDamage = d10();}
        else if(nlvl < 16)
            {nDamage = d12();}
        else
            {nDamage = d20();}
        return nDamage;
        break;
        }
    case BASE_ITEM_BASTARDSWORD:
        {
        nDamage = d10();
        break;
        }
    case BASE_ITEM_BATTLEAXE:
        {
        nDamage = d8();
        break;
        }
    case BASE_ITEM_CBLUDGWEAPON:
        {
        nDamage = d6();
        break;
        }
    case BASE_ITEM_CLUB:
        {
        nDamage = d6();
        break;
        }
    case BASE_ITEM_CPIERCWEAPON:
        {
        nDamage = d6();
        break;
        }
    case BASE_ITEM_DAGGER:
        {
        nDamage = d4();
        break;
        }
    case BASE_ITEM_DART:
        {
        FloatingTextStringOnCreature("You can't use the equiped weapon in a charge", oTarget);
        return -1;
        break;
        }
    case BASE_ITEM_DIREMACE:
        {
        nDamage = d8();
        break;
        }
    case BASE_ITEM_DOUBLEAXE:
        {
        nDamage = d8();
        break;
        }
    case BASE_ITEM_DWARVENWARAXE:
        {
        nDamage = d10();
        break;
        }
    case BASE_ITEM_GREATAXE:
        {
        nDamage = d12();
        break;
        }
    case BASE_ITEM_GREATSWORD:
        {
        nDamage = d6();
        break;
        }
    case BASE_ITEM_GRENADE:
        {
        FloatingTextStringOnCreature("You can't use the equiped weapon in a charge", oTarget);
        return -1;
        break;
        }
    case BASE_ITEM_HALBERD:
        {
        nDamage = d10();
        break;
        }
    case BASE_ITEM_HANDAXE:
        {
        nDamage = d6();
        break;
        }
    case BASE_ITEM_HEAVYCROSSBOW:
        {
        FloatingTextStringOnCreature("You can't use the equiped weapon in a charge", oTarget);
        return -1;
        break;
        }
    case BASE_ITEM_HEAVYFLAIL:
        {
        nDamage = d10();
        break;
        }
    case BASE_ITEM_KAMA:
        {
        nDamage = d6();
        break;
        }
    case BASE_ITEM_KATANA:
        {
        nDamage = d10();
        break;
        }
    case BASE_ITEM_KUKRI:
        {
        nDamage = d8();
        break;
        }
    case BASE_ITEM_LIGHTCROSSBOW:
        {
        FloatingTextStringOnCreature("You can't use the equiped weapon in a charge", oTarget);
        return -1;
        break;
        }
    case BASE_ITEM_LIGHTFLAIL:
        {
        nDamage = d8();
        break;
        }
    case BASE_ITEM_LIGHTHAMMER:
        {
        nDamage = d4();
        break;
        }
    case BASE_ITEM_LIGHTMACE:
        {
        nDamage = d8();
        break;
        }
    case BASE_ITEM_LONGBOW:
        {
        FloatingTextStringOnCreature("You can't use the equiped weapon in a charge", oTarget);
        return -1;
        break;
        }
    case BASE_ITEM_LONGSWORD:
        {
        nDamage = d8();
        break;
        }
    case BASE_ITEM_MORNINGSTAR:
        {
        nDamage = d6();
        break;
        }
    case BASE_ITEM_QUARTERSTAFF:
        {
        nDamage = d6();
        break;
        }
    case BASE_ITEM_RAPIER:
        {
        nDamage = d6();
        break;
        }
    case BASE_ITEM_SCIMITAR:
        {
        nDamage = d6();
        break;
        }
    case BASE_ITEM_SCYTHE:
        {
        nDamage = d4(2);
        break;
        }
    case BASE_ITEM_SHORTBOW:
        {
        FloatingTextStringOnCreature("You can't use the equiped weapon in a charge", oTarget);
        return -1;
        break;
        }
    case BASE_ITEM_SHORTSPEAR:
        {
        nDamage = d8();
        break;
        }
    case BASE_ITEM_SHORTSWORD:
        {
        nDamage = d6();
        break;
        }
    case BASE_ITEM_SHURIKEN:
        {
        FloatingTextStringOnCreature("You can't use the equiped weapon in a charge", oTarget);
        return -1;
        break;
        }
    case BASE_ITEM_SICKLE:
        {
        nDamage = d6();
        break;
        }
    case BASE_ITEM_SLING:
        {
        FloatingTextStringOnCreature("You can't use the equiped weapon in a charge", oTarget);
        return -1;
        break;
        }
    case BASE_ITEM_THROWINGAXE:
        {
        FloatingTextStringOnCreature("You can't use the equiped weapon in a charge", oTarget);
        return -1;
        break;
        }
    case BASE_ITEM_TORCH:
        {
        FloatingTextStringOnCreature("You can't use the equiped weapon in a charge", oTarget);
        return -1;
        break;
        }
    case BASE_ITEM_TWOBLADEDSWORD:
        {
        nDamage = d8();
        break;
        }
    case BASE_ITEM_WARHAMMER:
        {
        nDamage = d8();
        break;
        }
    case BASE_ITEM_WHIP:
        {
        nDamage = d2();
        break;
        }
    }//end switch

int nlvl = GetLevelByClass(CLASS_TYPE_DRUNKEN_MASTER, oTarget);

//find out Drunken Master's damage roll:
if(nDamage == 0)//oItem =='d OBJECT_INVALID
    {
    if(nlvl < 5)         {nDamage = d8();}
    else if(nlvl < 9)    {nDamage = d10();}
    else                 {nDamage = d12();}
    }

return nDamage;
}

int GetHasFreeHand(object oTarget = OBJECT_SELF)
{
// Check to see if one hand is free:
if(GetItemInSlot(INVENTORY_SLOT_RIGHTHAND, oTarget) == OBJECT_INVALID)
    {
    return TRUE;
    }
else if(GetItemInSlot(INVENTORY_SLOT_LEFTHAND, oTarget) == OBJECT_INVALID)
    {
    return TRUE;
    }
else
    {
    return FALSE;
    }
}

void DrinkIt(object oTarget)
{
   AssignCommand(oTarget, ActionSpeakStringByStrRef(10499));
}

void MakeDrunk(object oTarget, int nPoints)
{
    if (Random(100) + 1 < 40)
        AssignCommand(oTarget, ActionPlayAnimation(ANIMATION_LOOPING_TALK_LAUGHING));
    else
        AssignCommand(oTarget, ActionPlayAnimation(ANIMATION_LOOPING_PAUSE_DRUNK));

    effect eDumb = EffectAbilityDecrease(ABILITY_INTELLIGENCE, nPoints);
    ApplyEffectToObject(DURATION_TYPE_TEMPORARY, eDumb, oTarget, 60.0);
    AssignCommand(oTarget, SpeakString("*Burp!*"));
}

void DrunkenMasterSpeakString(object oTarget)
{
switch(d6())
    {
    case 1:
      AssignCommand(oTarget, ActionSpeakString("Now that's the stuff!"));
      break;
    case 2:
      AssignCommand(oTarget, ActionSpeakString("That one really hit the spot!"));
      break;
    case 3:
      AssignCommand(oTarget, ActionSpeakString("That should keep me warm!"));
      break;
    case 4:
      AssignCommand(oTarget, ActionSpeakString("Good stuff!"));
      break;
    case 5:
      AssignCommand(oTarget, ActionSpeakString("Bless the Wine Gods!"));
      break;
    case 6:
      AssignCommand(oTarget, ActionSpeakString("Just what I needed!"));
      break;
    }
}

void DrunkenMasterCreateEmptyBottle(object oTarget, int nBeverage)
{
if(nBeverage == 406)//Ale
    {
    CreateItemOnObject("nw_it_thnmisc002", oTarget);
    }
else if(nBeverage == 408)//Spirits
    {
    CreateItemOnObject("nw_it_thnmisc003", oTarget);
    }
else if(nBeverage == 407)//Wine
    {
    CreateItemOnObject("nw_it_thnmisc004", oTarget);
    }
else//Other
    {
    CreateItemOnObject("nw_it_thnmisc001", oTarget);
    }
}

int AddDrunkenMasterSkinProperties(object oPC, object oSkin)
{
    int bAddedProperty = FALSE;

    if(GetLevelByClass(CLASS_TYPE_DRUNKEN_MASTER, oPC) == 0)
        {return -1;}// Exit if oPC isn't a Drunken Master

    if(GetLevelByClass(CLASS_TYPE_DRUNKEN_MASTER, oPC) == 9)
    {
        // Add +2 AC Bonus
        IPSafeAddItemProperty(oSkin, ItemPropertyACBonus(4));
        bAddedProperty = TRUE;
    }
    else if(GetLevelByClass(CLASS_TYPE_DRUNKEN_MASTER, oPC) == 4)
    {
        // Add +1 AC Bonus
        IPSafeAddItemProperty(oSkin, ItemPropertyACBonus(3));
        bAddedProperty = TRUE;
    }
    else if(GetLevelByClass(CLASS_TYPE_DRUNKEN_MASTER, oPC) == 3)
    {
        // Add Swaying Waist AC Bonus:
        IPSafeAddItemProperty(oSkin, ItemPropertyACBonus(2));
        bAddedProperty = TRUE;
    }

    return bAddedProperty;
}


