/*
    Class functions.
    This scripts holds all functions used for classes in includes.
    This prevents us from having one include for each class or set of classes.

    Stratovarius
*/

// Include Files:
#include "nw_i0_spells"
#include "x2_inc_itemprop"
#include "prc_class_const"
#include "prc_feat_const"



////////////////Begin Drunken Master//////////////////////


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

////////////////End Drunken Master//////////////////

////////////////Begin Samurai//////////////////


int GetPropertyValue(object oWeapon, int iType, int iSubType = -1, int bDebug = FALSE);

int GetPropertyValue(object oWeapon, int iType, int iSubType = -1, int bDebug = FALSE)
{
    int bReturn = -1;
    if(oWeapon == OBJECT_INVALID){return FALSE;}
    int bMatch = FALSE;
    if (GetItemHasItemProperty(oWeapon, iType))
    {
        if(bDebug){AssignCommand(GetFirstPC(), SpeakString("It has the property."));}
        itemproperty ip = GetFirstItemProperty(oWeapon);
        while(GetIsItemPropertyValid(ip))
        {
            if(GetItemPropertyType(ip) == iType)
            {
                if(bDebug){AssignCommand(GetFirstPC(), SpeakString("Again..."));}
                bMatch = TRUE;
                if (iSubType > -1)
                {
                    if(bDebug){AssignCommand(GetFirstPC(), SpeakString("Subtype Required."));}
                    if(GetItemPropertySubType(ip) != iSubType)
                    {
                        if(bDebug){AssignCommand(GetFirstPC(), SpeakString("Subtype wrong."));}
                        bMatch = FALSE;
                    }
                    else
                    {
                        if(bDebug){AssignCommand(GetFirstPC(), SpeakString("Subtype Correct."));}
                    }
                }
            }
            if (bMatch)
            {
                if(bDebug){AssignCommand(GetFirstPC(), SpeakString("Match found."));}
                if (GetItemPropertyCostTableValue(ip) > -1)
                {
                    if(bDebug){AssignCommand(GetFirstPC(), SpeakString("Cost value found, returning."));}
                    bReturn = GetItemPropertyCostTableValue(ip);
                }
                else
                {
                    if(bDebug){AssignCommand(GetFirstPC(), SpeakString("No cost value for property, returning TRUE."));}
                    bReturn = 1;
                }
            }
            else
            {
                if(bDebug){AssignCommand(GetFirstPC(), SpeakString("Match not found."));}
            }
            ip = GetNextItemProperty(oWeapon);
        }
    }
    return bReturn;
}


void WeaponUpgradeVisual();

object GetSamuraiToken(object oSamurai);

void WeaponUpgradeVisual()
{
    object oPC = GetPCSpeaker();
    int iCost = GetLocalInt(oPC, "CODI_SAM_WEAPON_COST");
    object oToken = GetSamuraiToken(oPC);
    int iToken = StringToInt(GetTag(oToken));
    int iGold = GetGold(oPC);
    if(iGold + iToken < iCost)
    {
        SendMessageToPC(oPC, "You sense the gods are angered!");
        AdjustAlignment(oPC, ALIGNMENT_CHAOTIC, 25);
        object oWeapon = GetItemPossessedBy(oPC, "codi_sam_mw");
        DestroyObject(oWeapon);
        return;
    }
    else if(iToken <= iCost)
    {
        iCost = iCost - iToken;
        DestroyObject(oToken);
        TakeGoldFromCreature(iCost, oPC, TRUE);
    }
    else if (iToken > iCost)
    {
        object oNewToken = CopyObject(oToken, GetLocation(oPC), oPC, IntToString(iToken - iCost));
        DestroyObject(oToken);
    }
    effect eVis = EffectVisualEffect(VFX_FNF_DISPEL_DISJUNCTION);
    AssignCommand(oPC, ClearAllActions());
    AssignCommand(oPC, ActionPlayAnimation(ANIMATION_LOOPING_MEDITATE,1.0,6.0));
    AssignCommand(oPC, ActionPlayAnimation(ANIMATION_FIREFORGET_VICTORY2));
    DelayCommand(0.1, SetCommandable(FALSE, oPC));
    DelayCommand(6.5, SetCommandable(TRUE, oPC));
    DelayCommand(5.0,ApplyEffectAtLocation(DURATION_TYPE_INSTANT, eVis, GetLocation(oPC)));
}

object GetSamuraiToken(object oSamurai)
{
    object oItem = GetFirstItemInInventory(oSamurai);
    while(oItem != OBJECT_INVALID)
    {
        if(GetResRef(oItem) == "codi_sam_token")
        {
            return oItem;
        }
        oItem = GetNextItemInInventory(oSamurai);
    }
    return OBJECT_INVALID;
}




////////////////End Samurai//////////////////

////////////////Begin Vile Feat//////////////////


int Vile_Feat(int iTypeWeap)
{
       switch(iTypeWeap)
            {
                case BASE_ITEM_BASTARDSWORD: return GetHasFeat(FEAT_VILE_MARTIAL_BASTARDSWORD);
                case BASE_ITEM_BATTLEAXE: return GetHasFeat(FEAT_VILE_MARTIAL_BATTLEAXE);
                case BASE_ITEM_CLUB: return GetHasFeat(FEAT_VILE_MARTIAL_CLUB);
                case BASE_ITEM_DAGGER: return GetHasFeat(FEAT_VILE_MARTIAL_DAGGER);
                case BASE_ITEM_DART: return GetHasFeat(FEAT_VILE_MARTIAL_DART);
                case BASE_ITEM_DIREMACE: return GetHasFeat(FEAT_VILE_MARTIAL_DIREMACE);
                case BASE_ITEM_DOUBLEAXE: return GetHasFeat(FEAT_VILE_MARTIAL_DOUBLEAXE);
                case BASE_ITEM_DWARVENWARAXE: return GetHasFeat(FEAT_VILE_MARTIAL_DWAXE);
                case BASE_ITEM_GREATAXE: return GetHasFeat(FEAT_VILE_MARTIAL_GREATAXE);
                case BASE_ITEM_GREATSWORD: return GetHasFeat(FEAT_VILE_MARTIAL_GREATSWORD);
                case BASE_ITEM_HALBERD: return GetHasFeat(FEAT_VILE_MARTIAL_HALBERD);
                case BASE_ITEM_HANDAXE: return GetHasFeat(FEAT_VILE_MARTIAL_HANDAXE);
                case BASE_ITEM_HEAVYCROSSBOW: return GetHasFeat(FEAT_VILE_MARTIAL_HEAVYCROSSBOW);
                case BASE_ITEM_HEAVYFLAIL: return GetHasFeat(FEAT_VILE_MARTIAL_HEAVYFLAIL);
                case BASE_ITEM_KAMA: return GetHasFeat(FEAT_VILE_MARTIAL_KAMA);
                case BASE_ITEM_KATANA: return GetHasFeat(FEAT_VILE_MARTIAL_KATANA);
                case BASE_ITEM_KUKRI: return GetHasFeat(FEAT_VILE_MARTIAL_KUKRI);
                case BASE_ITEM_LIGHTCROSSBOW: return GetHasFeat(FEAT_VILE_MARTIAL_LIGHTCROSSBOW);
                case BASE_ITEM_LIGHTFLAIL: return GetHasFeat(FEAT_VILE_MARTIAL_LIGHTFLAIL);
                case BASE_ITEM_LIGHTHAMMER: return GetHasFeat(FEAT_VILE_MARTIAL_LIGHTHAMMER);
                case BASE_ITEM_LIGHTMACE: return GetHasFeat(FEAT_VILE_MARTIAL_MACE);
                case BASE_ITEM_LONGBOW: return GetHasFeat(FEAT_VILE_MARTIAL_LONGBOW);
                case BASE_ITEM_LONGSWORD: return GetHasFeat(FEAT_VILE_MARTIAL_LONGSWORD);
                case BASE_ITEM_MORNINGSTAR: return GetHasFeat(FEAT_VILE_MARTIAL_MORNINGSTAR);
                case BASE_ITEM_QUARTERSTAFF: return GetHasFeat(FEAT_VILE_MARTIAL_QUATERSTAFF);
                case BASE_ITEM_RAPIER: return GetHasFeat(FEAT_VILE_MARTIAL_RAPIER);
                case BASE_ITEM_SCIMITAR: return GetHasFeat(FEAT_VILE_MARTIAL_SCIMITAR);
                case BASE_ITEM_SCYTHE: return GetHasFeat(FEAT_VILE_MARTIAL_SCYTHE);
                case BASE_ITEM_SHORTBOW: return GetHasFeat(FEAT_VILE_MARTIAL_SHORTBOW);
                case BASE_ITEM_SHORTSPEAR: return GetHasFeat(FEAT_VILE_MARTIAL_SPEAR);
                case BASE_ITEM_SHORTSWORD: return GetHasFeat(FEAT_VILE_MARTIAL_SHORTSWORD);
                case BASE_ITEM_SHURIKEN: return GetHasFeat(FEAT_VILE_MARTIAL_SHURIKEN);
                case BASE_ITEM_SLING: return GetHasFeat(FEAT_VILE_MARTIAL_SLING);
                case BASE_ITEM_SICKLE: return GetHasFeat(FEAT_VILE_MARTIAL_SICKLE);
                case BASE_ITEM_TWOBLADEDSWORD: return GetHasFeat(FEAT_VILE_MARTIAL_TWOBLADED);
                case BASE_ITEM_WARHAMMER: return GetHasFeat(FEAT_VILE_MARTIAL_WARHAMMER);
                case BASE_ITEM_WHIP: return GetHasFeat(FEAT_VILE_MARTIAL_SLING);
            }
    return 0;
}

////////////////End Vile Feat//////////////////