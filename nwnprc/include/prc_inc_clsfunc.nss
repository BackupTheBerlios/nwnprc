/*
    Class functions.
    This scripts holds all functions used for classes in includes.
    This prevents us from having one include for each class or set of classes.

    Stratovarius
*/

// Include Files:
#include "x2_inc_itemprop"
#include "prc_class_const"
#include "prc_feat_const"
#include "prc_ipfeat_const"
#include "inc_item_props"
#include "nw_i0_spells"



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
//int GetSizeModifier(object oTarget);

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

/*
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
}*/

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

////////////////Begin Soul Inc//////////////////

const int IPRP_CONST_ONHIT_DURATION_5_PERCENT_1_ROUNDS = 20;

int Sanctify_Feat(int iTypeWeap)
{
       switch(iTypeWeap)
            {
                case BASE_ITEM_BASTARDSWORD: return GetHasFeat(FEAT_SANCTIFY_MARTIAL_BASTARDSWORD);
                case BASE_ITEM_BATTLEAXE: return GetHasFeat(FEAT_SANCTIFY_MARTIAL_BATTLEAXE);
                case BASE_ITEM_CLUB: return GetHasFeat(FEAT_SANCTIFY_MARTIAL_CLUB);
                case BASE_ITEM_DAGGER: return GetHasFeat(FEAT_SANCTIFY_MARTIAL_DAGGER);
                case BASE_ITEM_DART: return GetHasFeat(FEAT_SANCTIFY_MARTIAL_DART);
                case BASE_ITEM_DIREMACE: return GetHasFeat(FEAT_SANCTIFY_MARTIAL_DIREMACE);
                case BASE_ITEM_DOUBLEAXE: return GetHasFeat(FEAT_SANCTIFY_MARTIAL_DOUBLEAXE);
                case BASE_ITEM_DWARVENWARAXE: return GetHasFeat(FEAT_SANCTIFY_MARTIAL_DWAXE);
                case BASE_ITEM_GREATAXE: return GetHasFeat(FEAT_SANCTIFY_MARTIAL_GREATAXE);
                case BASE_ITEM_GREATSWORD: return GetHasFeat(FEAT_SANCTIFY_MARTIAL_GREATSWORD);
                case BASE_ITEM_HALBERD: return GetHasFeat(FEAT_SANCTIFY_MARTIAL_HALBERD);
                case BASE_ITEM_HANDAXE: return GetHasFeat(FEAT_SANCTIFY_MARTIAL_HANDAXE);
                case BASE_ITEM_HEAVYCROSSBOW: return GetHasFeat(FEAT_SANCTIFY_MARTIAL_HEAVYCROSSBOW);
                case BASE_ITEM_HEAVYFLAIL: return GetHasFeat(FEAT_SANCTIFY_MARTIAL_HEAVYFLAIL);
                case BASE_ITEM_KAMA: return GetHasFeat(FEAT_SANCTIFY_MARTIAL_KAMA);
                case BASE_ITEM_KATANA: return GetHasFeat(FEAT_SANCTIFY_MARTIAL_KATANA);
                case BASE_ITEM_KUKRI: return GetHasFeat(FEAT_SANCTIFY_MARTIAL_KUKRI);
                case BASE_ITEM_LIGHTCROSSBOW: return GetHasFeat(FEAT_SANCTIFY_MARTIAL_LIGHTCROSSBOW);
                case BASE_ITEM_LIGHTFLAIL: return GetHasFeat(FEAT_SANCTIFY_MARTIAL_LIGHTFLAIL);
                case BASE_ITEM_LIGHTHAMMER: return GetHasFeat(FEAT_SANCTIFY_MARTIAL_LIGHTHAMMER);
                case BASE_ITEM_LIGHTMACE: return GetHasFeat(FEAT_SANCTIFY_MARTIAL_MACE);
                case BASE_ITEM_LONGBOW: return GetHasFeat(FEAT_SANCTIFY_MARTIAL_LONGBOW);
                case BASE_ITEM_LONGSWORD: return GetHasFeat(FEAT_SANCTIFY_MARTIAL_LONGSWORD);
                case BASE_ITEM_MORNINGSTAR: return GetHasFeat(FEAT_SANCTIFY_MARTIAL_MORNINGSTAR);
                case BASE_ITEM_QUARTERSTAFF: return GetHasFeat(FEAT_SANCTIFY_MARTIAL_QUATERSTAFF);
                case BASE_ITEM_RAPIER: return GetHasFeat(FEAT_SANCTIFY_MARTIAL_RAPIER);
                case BASE_ITEM_SCIMITAR: return GetHasFeat(FEAT_SANCTIFY_MARTIAL_SCIMITAR);
                case BASE_ITEM_SCYTHE: return GetHasFeat(FEAT_SANCTIFY_MARTIAL_SCYTHE);
                case BASE_ITEM_SHORTBOW: return GetHasFeat(FEAT_SANCTIFY_MARTIAL_SHORTBOW);
                case BASE_ITEM_SHORTSPEAR: return GetHasFeat(FEAT_SANCTIFY_MARTIAL_SPEAR);
                case BASE_ITEM_SHORTSWORD: return GetHasFeat(FEAT_SANCTIFY_MARTIAL_SHORTSWORD);
                case BASE_ITEM_SHURIKEN: return GetHasFeat(FEAT_SANCTIFY_MARTIAL_SHURIKEN);
                case BASE_ITEM_SLING: return GetHasFeat(FEAT_SANCTIFY_MARTIAL_SLING);
                case BASE_ITEM_SICKLE: return GetHasFeat(FEAT_SANCTIFY_MARTIAL_SICKLE);
                case BASE_ITEM_TWOBLADEDSWORD: return GetHasFeat(FEAT_SANCTIFY_MARTIAL_TWOBLADED);
                case BASE_ITEM_WARHAMMER: return GetHasFeat(FEAT_SANCTIFY_MARTIAL_WARHAMMER);
                case BASE_ITEM_WHIP: return GetHasFeat(FEAT_SANCTIFY_MARTIAL_SLING);
            }
    return 0;
}

int DamageConv(int iMonsDmg)
{

   switch(iMonsDmg)
   {
     case IP_CONST_MONSTERDAMAGE_1d4:  return 1;
     case IP_CONST_MONSTERDAMAGE_1d6:  return 2;
     case IP_CONST_MONSTERDAMAGE_1d8:  return 3;
     case IP_CONST_MONSTERDAMAGE_1d10: return 4;
     case IP_CONST_MONSTERDAMAGE_1d12: return 5;
     case IP_CONST_MONSTERDAMAGE_1d20: return 6;

     case IP_CONST_MONSTERDAMAGE_2d4:  return 10;
     case IP_CONST_MONSTERDAMAGE_2d6:  return 11;
     case IP_CONST_MONSTERDAMAGE_2d8:  return 12;
     case IP_CONST_MONSTERDAMAGE_2d10: return 13;
     case IP_CONST_MONSTERDAMAGE_2d12: return 14;
     case IP_CONST_MONSTERDAMAGE_2d20: return 15;

     case IP_CONST_MONSTERDAMAGE_3d4:  return 20;
     case IP_CONST_MONSTERDAMAGE_3d6:  return 21;
     case IP_CONST_MONSTERDAMAGE_3d8:  return 22;
     case IP_CONST_MONSTERDAMAGE_3d10: return 23;
     case IP_CONST_MONSTERDAMAGE_3d12: return 24;
     case IP_CONST_MONSTERDAMAGE_3d20: return 25;


   }


  return 0;
}

int ConvMonsterDmg(int iMonsDmg)
{

   switch(iMonsDmg)
   {
     case 1:  return IP_CONST_MONSTERDAMAGE_1d4;
     case 2:  return IP_CONST_MONSTERDAMAGE_1d6;
     case 3:  return IP_CONST_MONSTERDAMAGE_1d8;
     case 4:  return IP_CONST_MONSTERDAMAGE_1d10;
     case 5:  return IP_CONST_MONSTERDAMAGE_1d12;
     case 6:  return IP_CONST_MONSTERDAMAGE_1d20;
     case 10: return IP_CONST_MONSTERDAMAGE_2d4;
     case 11: return IP_CONST_MONSTERDAMAGE_2d6;
     case 12: return IP_CONST_MONSTERDAMAGE_2d8;
     case 13: return IP_CONST_MONSTERDAMAGE_2d10;
     case 14: return IP_CONST_MONSTERDAMAGE_2d12;
     case 15: return IP_CONST_MONSTERDAMAGE_2d20;
     case 20: return IP_CONST_MONSTERDAMAGE_3d4;
     case 21: return IP_CONST_MONSTERDAMAGE_3d6;
     case 22: return IP_CONST_MONSTERDAMAGE_3d8;
     case 23: return IP_CONST_MONSTERDAMAGE_3d10;
     case 24: return IP_CONST_MONSTERDAMAGE_3d12;
     case 25: return IP_CONST_MONSTERDAMAGE_3d20;

   }

   return 0;
}

int MonsterDamage(object oItem)
{
   int iBonus;
   int iTemp ;
    itemproperty ip = GetFirstItemProperty(oItem);
    while(GetIsItemPropertyValid(ip))
    {
        if(GetItemPropertyType(ip) == ITEM_PROPERTY_MONSTER_DAMAGE)
        {
          iTemp= GetItemPropertyCostTableValue(ip);
          iBonus = iTemp > iBonus ? iTemp : iBonus ;
        }
        ip = GetNextItemProperty(oItem);
    }

   return iBonus;
}

int FeatIniDmg(object oItem)
{
    itemproperty ip = GetFirstItemProperty(oItem);
    while (GetIsItemPropertyValid(ip))
    { 
	if (GetItemPropertyType(ip) == ITEM_PROPERTY_BONUS_FEAT)
        {

          if (GetItemPropertySubType(ip)==IP_CONST_FEAT_WeapFocCreature) return 1;
        }
	ip = GetNextItemProperty(oItem);
    }
    return 0;
}
	

void AddIniDmg(object oPC)
{

   int bUnarmedDmg = GetHasFeat(FEAT_INCREASE_DAMAGE1,oPC) ? 1:0;
       bUnarmedDmg = GetHasFeat(FEAT_INCREASE_DAMAGE2,oPC) ? 2:bUnarmedDmg;

   if (!bUnarmedDmg) return;

   object oCweapB = GetItemInSlot(INVENTORY_SLOT_CWEAPON_B,oPC);
   object oCweapL = GetItemInSlot(INVENTORY_SLOT_CWEAPON_L,oPC);
   object oCweapR = GetItemInSlot(INVENTORY_SLOT_CWEAPON_R,oPC);

   int iDmg;
   int iConv;
   int iStr =  GetAbilityModifier(ABILITY_STRENGTH,oPC);
   int iWis =  GetAbilityModifier(ABILITY_WISDOM,oPC);
       iWis = iWis > iStr ? iWis : 0;


   if(GetHasFeat(FEAT_INTUITIVE_ATTACK, oPC))
   {
     SetCompositeBonusT(oCweapB,"",iWis,ITEM_PROPERTY_ATTACK_BONUS);
     SetCompositeBonusT(oCweapL,"",iWis,ITEM_PROPERTY_ATTACK_BONUS);
     SetCompositeBonusT(oCweapR,"",iWis,ITEM_PROPERTY_ATTACK_BONUS);
   }
   if (GetHasFeat(FEAT_RAVAGEGOLDENICE, oPC))
   {
     AddItemProperty(DURATION_TYPE_TEMPORARY,ItemPropertyOnHitCastSpell(IP_CONST_ONHIT_CASTSPELL_RAVAGEGOLDENICE,2),oCweapB,9999.0);
     AddItemProperty(DURATION_TYPE_TEMPORARY,ItemPropertyOnHitCastSpell(IP_CONST_ONHIT_CASTSPELL_RAVAGEGOLDENICE,2),oCweapL,9999.0);
     AddItemProperty(DURATION_TYPE_TEMPORARY,ItemPropertyOnHitCastSpell(IP_CONST_ONHIT_CASTSPELL_RAVAGEGOLDENICE,2),oCweapR,9999.0);
   }

   
   if ( oCweapB != OBJECT_INVALID && !FeatIniDmg(oCweapB))
   {
      iDmg =  MonsterDamage(oCweapB);
      iConv = DamageConv(iDmg);
      iConv = ConvMonsterDmg(iConv+bUnarmedDmg);
      TotalAndRemoveProperty(oCweapB,ITEM_PROPERTY_MONSTER_DAMAGE,-1);
      AddItemProperty(DURATION_TYPE_PERMANENT,ItemPropertyMonsterDamage(iConv),oCweapB);
      AddItemProperty(DURATION_TYPE_PERMANENT,ItemPropertyBonusFeat(IP_CONST_FEAT_WeapFocCreature),oCweapB);

   }
   if ( oCweapL != OBJECT_INVALID && !FeatIniDmg(oCweapL))
   {
      iDmg =  MonsterDamage(oCweapL);
      iConv = DamageConv(iDmg);
      iConv = ConvMonsterDmg(iConv+bUnarmedDmg);
      TotalAndRemoveProperty(oCweapL,ITEM_PROPERTY_MONSTER_DAMAGE,-1);
      AddItemProperty(DURATION_TYPE_PERMANENT,ItemPropertyMonsterDamage(iConv),oCweapL);
      AddItemProperty(DURATION_TYPE_PERMANENT,ItemPropertyBonusFeat(IP_CONST_FEAT_WeapFocCreature),oCweapL);

   }
   if ( oCweapR != OBJECT_INVALID && !FeatIniDmg(oCweapR))
   {
      iDmg =  MonsterDamage(oCweapR);
      iConv = DamageConv(iDmg);
      iConv = ConvMonsterDmg(iConv+bUnarmedDmg);
      TotalAndRemoveProperty(oCweapR,ITEM_PROPERTY_MONSTER_DAMAGE,-1);
      AddItemProperty(DURATION_TYPE_PERMANENT,ItemPropertyMonsterDamage(iConv),oCweapR);
      AddItemProperty(DURATION_TYPE_PERMANENT,ItemPropertyBonusFeat(IP_CONST_FEAT_WeapFocCreature),oCweapR);

   }



}




void AddCriti(object oPC,object oSkin,int ip_feat_crit,int nFeat)
{
  //if (GetLocalInt(oSkin, "ManAcriT"+IntToString(ip_feat_crit))) return;
    if (GetHasFeat(nFeat,oPC))return;
  AddItemProperty(DURATION_TYPE_PERMANENT,ItemPropertyBonusFeat(ip_feat_crit),oSkin);


}

void ImpCrit(object oPC,object oSkin)
{
  if (GetHasFeat(FEAT_WEAPON_FOCUS_BASTARD_SWORD,oPC)) AddCriti(oPC,oSkin,IP_CONST_FEAT_IMPROVED_CRITICAL_BASTARD_SWORD,FEAT_IMPROVED_CRITICAL_BASTARD_SWORD);
  if (GetHasFeat(FEAT_WEAPON_FOCUS_BATTLE_AXE,oPC)) AddCriti(oPC,oSkin,IP_CONST_FEAT_IMPROVED_CRITICAL_BATTLE_AXE,FEAT_IMPROVED_CRITICAL_BATTLE_AXE);
  if (GetHasFeat(FEAT_WEAPON_FOCUS_CLUB,oPC)) AddCriti(oPC,oSkin,IP_CONST_FEAT_IMPROVED_CRITICAL_CLUB,FEAT_IMPROVED_CRITICAL_CLUB);
  if (GetHasFeat(FEAT_WEAPON_FOCUS_DAGGER,oPC)) AddCriti(oPC,oSkin,IP_CONST_FEAT_IMPROVED_CRITICAL_DAGGER,FEAT_IMPROVED_CRITICAL_DAGGER);
  if (GetHasFeat(FEAT_WEAPON_FOCUS_DART,oPC)) AddCriti(oPC,oSkin,IP_CONST_FEAT_IMPROVED_CRITICAL_DART,FEAT_IMPROVED_CRITICAL_DART);
  if (GetHasFeat(FEAT_WEAPON_FOCUS_DIRE_MACE,oPC)) AddCriti(oPC,oSkin,IP_CONST_FEAT_IMPROVED_CRITICAL_DIRE_MACE,FEAT_IMPROVED_CRITICAL_DIRE_MACE);
  if (GetHasFeat(FEAT_WEAPON_FOCUS_DOUBLE_AXE,oPC)) AddCriti(oPC,oSkin,IP_CONST_FEAT_IMPROVED_CRITICAL_DOUBLE_AXE,FEAT_IMPROVED_CRITICAL_DOUBLE_AXE);
  if (GetHasFeat(FEAT_WEAPON_FOCUS_DWAXE,oPC)) AddCriti(oPC,oSkin,IP_CONST_FEAT_IMPROVED_CRITICAL_DWAXE,FEAT_IMPROVED_CRITICAL_DWAXE);
  if (GetHasFeat(FEAT_WEAPON_FOCUS_GREAT_AXE,oPC)) AddCriti(oPC,oSkin,IP_CONST_FEAT_IMPROVED_CRITICAL_GREAT_AXE,FEAT_IMPROVED_CRITICAL_GREAT_AXE);
  if (GetHasFeat(FEAT_WEAPON_FOCUS_GREAT_SWORD,oPC)) AddCriti(oPC,oSkin,IP_CONST_FEAT_IMPROVED_CRITICAL_GREAT_SWORD,FEAT_IMPROVED_CRITICAL_GREAT_SWORD);
  if (GetHasFeat(FEAT_WEAPON_FOCUS_HALBERD,oPC)) AddCriti(oPC,oSkin,IP_CONST_FEAT_IMPROVED_CRITICAL_HALBERD,FEAT_IMPROVED_CRITICAL_HALBERD);
  if (GetHasFeat(FEAT_WEAPON_FOCUS_HAND_AXE,oPC)) AddCriti(oPC,oSkin,IP_CONST_FEAT_IMPROVED_CRITICAL_HAND_AXE,FEAT_IMPROVED_CRITICAL_HAND_AXE);
  if (GetHasFeat(FEAT_WEAPON_FOCUS_HEAVY_CROSSBOW,oPC)) AddCriti(oPC,oSkin,IP_CONST_FEAT_IMPROVED_CRITICAL_HEAVY_CROSSBOW,FEAT_IMPROVED_CRITICAL_HEAVY_CROSSBOW);
  if (GetHasFeat(FEAT_WEAPON_FOCUS_HEAVY_FLAIL,oPC)) AddCriti(oPC,oSkin,IP_CONST_FEAT_IMPROVED_CRITICAL_HEAVY_FLAIL,FEAT_IMPROVED_CRITICAL_HEAVY_FLAIL);
  if (GetHasFeat(FEAT_WEAPON_FOCUS_KAMA,oPC)) AddCriti(oPC,oSkin,IP_CONST_FEAT_IMPROVED_CRITICAL_KAMA,FEAT_IMPROVED_CRITICAL_KAMA);
  if (GetHasFeat(FEAT_WEAPON_FOCUS_KATANA,oPC)) AddCriti(oPC,oSkin,IP_CONST_FEAT_IMPROVED_CRITICAL_KATANA,FEAT_IMPROVED_CRITICAL_KATANA);
  if (GetHasFeat(FEAT_WEAPON_FOCUS_KUKRI,oPC)) AddCriti(oPC,oSkin,IP_CONST_FEAT_IMPROVED_CRITICAL_KUKRI,FEAT_IMPROVED_CRITICAL_KUKRI);
  if (GetHasFeat(FEAT_WEAPON_FOCUS_LIGHT_CROSSBOW,oPC)) AddCriti(oPC,oSkin,IP_CONST_FEAT_IMPROVED_CRITICAL_LIGHT_CROSSBOW,FEAT_IMPROVED_CRITICAL_LIGHT_CROSSBOW);
  if (GetHasFeat(FEAT_WEAPON_FOCUS_LIGHT_FLAIL,oPC)) AddCriti(oPC,oSkin,IP_CONST_FEAT_IMPROVED_CRITICAL_LIGHT_FLAIL,FEAT_IMPROVED_CRITICAL_LIGHT_FLAIL);
  if (GetHasFeat(FEAT_WEAPON_FOCUS_LIGHT_HAMMER,oPC)) AddCriti(oPC,oSkin,IP_CONST_FEAT_IMPROVED_CRITICAL_LIGHT_HAMMER,FEAT_IMPROVED_CRITICAL_LIGHT_HAMMER);
  if (GetHasFeat(FEAT_WEAPON_FOCUS_LIGHT_MACE,oPC)) AddCriti(oPC,oSkin,IP_CONST_FEAT_IMPROVED_CRITICAL_LIGHT_MACE,FEAT_IMPROVED_CRITICAL_LIGHT_MACE);
  if (GetHasFeat(FEAT_WEAPON_FOCUS_LONG_SWORD,oPC)) AddCriti(oPC,oSkin,IP_CONST_FEAT_IMPROVED_CRITICAL_LONG_SWORD,FEAT_IMPROVED_CRITICAL_LONG_SWORD);
  if (GetHasFeat(FEAT_WEAPON_FOCUS_LONGBOW,oPC)) AddCriti(oPC,oSkin,IP_CONST_FEAT_IMPROVED_CRITICAL_LONGBOW,FEAT_IMPROVED_CRITICAL_LONGBOW);
  if (GetHasFeat(FEAT_WEAPON_FOCUS_MORNING_STAR,oPC)) AddCriti(oPC,oSkin,IP_CONST_FEAT_IMPROVED_CRITICAL_MORNING_STAR,FEAT_IMPROVED_CRITICAL_MORNING_STAR);
  if (GetHasFeat(FEAT_WEAPON_FOCUS_RAPIER,oPC)) AddCriti(oPC,oSkin,IP_CONST_FEAT_IMPROVED_CRITICAL_RAPIER,FEAT_IMPROVED_CRITICAL_RAPIER);
  if (GetHasFeat(FEAT_WEAPON_FOCUS_SCIMITAR,oPC)) AddCriti(oPC,oSkin,IP_CONST_FEAT_IMPROVED_CRITICAL_SCIMITAR,FEAT_IMPROVED_CRITICAL_SCIMITAR);
  if (GetHasFeat(FEAT_WEAPON_FOCUS_SCYTHE,oPC)) AddCriti(oPC,oSkin,IP_CONST_FEAT_IMPROVED_CRITICAL_SCYTHE,FEAT_IMPROVED_CRITICAL_SCYTHE);
  if (GetHasFeat(FEAT_WEAPON_FOCUS_SHORT_SWORD,oPC)) AddCriti(oPC,oSkin,IP_CONST_FEAT_IMPROVED_CRITICAL_SHORT_SWORD,FEAT_IMPROVED_CRITICAL_SHORT_SWORD);
  if (GetHasFeat(FEAT_WEAPON_FOCUS_SHORTBOW,oPC)) AddCriti(oPC,oSkin,IP_CONST_FEAT_IMPROVED_CRITICAL_SHORTBOW,FEAT_IMPROVED_CRITICAL_SHORTBOW);
  if (GetHasFeat(FEAT_WEAPON_FOCUS_SHURIKEN,oPC)) AddCriti(oPC,oSkin,IP_CONST_FEAT_IMPROVED_CRITICAL_SHURIKEN,FEAT_IMPROVED_CRITICAL_SHURIKEN);
  if (GetHasFeat(FEAT_WEAPON_FOCUS_SICKLE,oPC)) AddCriti(oPC,oSkin,IP_CONST_FEAT_IMPROVED_CRITICAL_SICKLE,FEAT_IMPROVED_CRITICAL_SICKLE);
  if (GetHasFeat(FEAT_WEAPON_FOCUS_SLING,oPC)) AddCriti(oPC,oSkin,IP_CONST_FEAT_IMPROVED_CRITICAL_SLING,FEAT_IMPROVED_CRITICAL_SLING);
  if (GetHasFeat(FEAT_WEAPON_FOCUS_SPEAR,oPC)) AddCriti(oPC,oSkin,IP_CONST_FEAT_IMPROVED_CRITICAL_SPEAR,FEAT_IMPROVED_CRITICAL_SPEAR);
  if (GetHasFeat(FEAT_WEAPON_FOCUS_STAFF,oPC)) AddCriti(oPC,oSkin,IP_CONST_FEAT_IMPROVED_CRITICAL_STAFF,FEAT_IMPROVED_CRITICAL_STAFF);
  if (GetHasFeat(FEAT_WEAPON_FOCUS_THROWING_AXE,oPC)) AddCriti(oPC,oSkin,IP_CONST_FEAT_IMPROVED_CRITICAL_THROWING_AXE,FEAT_IMPROVED_CRITICAL_THROWING_AXE);
  if (GetHasFeat(FEAT_WEAPON_FOCUS_TWO_BLADED_SWORD,oPC)) AddCriti(oPC,oSkin,IP_CONST_FEAT_IMPROVED_CRITICAL_TWO_BLADED_SWORD,FEAT_IMPROVED_CRITICAL_TWO_BLADED_SWORD);
  if (GetHasFeat(FEAT_WEAPON_FOCUS_WAR_HAMMER,oPC)) AddCriti(oPC,oSkin,IP_CONST_FEAT_IMPROVED_CRITICAL_WAR_HAMMER,FEAT_IMPROVED_CRITICAL_WAR_HAMMER);
  if (GetHasFeat(FEAT_WEAPON_FOCUS_WHIP,oPC)) AddCriti(oPC,oSkin,IP_CONST_FEAT_IMPROVED_CRITICAL_WHIP,FEAT_IMPROVED_CRITICAL_WHIP);

}

int CanCastSpell(int iSpelllvl = 0,int iAbi = ABILITY_WISDOM,int iASF = 0,object oCaster=OBJECT_SELF)
{
   string iMsg =" You cant cast your spell because your ability score is too low";
   int iScore = GetAbilityScore(oCaster,iAbi); 
   if (iScore < 10 + iSpelllvl)
   {
       FloatingTextStringOnCreature(iMsg, oCaster, FALSE);
       return 0;
   }  
   if (iASF)
   {
     int ASF = GetArcaneSpellFailure(oCaster); 
     int idice = d100(1);
     if (idice <= ASF && idice!=100)
     {
        FloatingTextStringOnCreature("Spell failed due to arcane spell failure (roll:"+IntToString(idice)+")", oCaster, FALSE);
        return 0; 
     }
      
   }
   
   return 1;     
}

////////////////End Soul Inc//////////////////

////////////////Begin Martial Strike//////////////////

void MartialStrike()
{
   object oItem;
   object oPC = OBJECT_SELF;

   int iEquip=GetLocalInt(oPC,"ONEQUIP");
   int iType;

   if (iEquip==2)
   {
   	
     if (!GetHasFeat(FEAT_HOLY_MARTIAL_STRIKE)) return;
     
     oItem=GetPCItemLastEquipped();
     iType= GetBaseItemType(oItem);

     switch (iType)
     {
        case BASE_ITEM_BOLT:
        case BASE_ITEM_BULLET:
        case BASE_ITEM_ARROW:
          iType=GetBaseItemType(GetItemInSlot(INVENTORY_SLOT_RIGHTHAND));
          break;
        case BASE_ITEM_SHORTBOW:
        case BASE_ITEM_LONGBOW:
          oItem=GetItemInSlot(INVENTORY_SLOT_ARROWS);
          break;
        case BASE_ITEM_LIGHTCROSSBOW:
        case BASE_ITEM_HEAVYCROSSBOW:
          oItem=GetItemInSlot(INVENTORY_SLOT_BOLTS);
          break;
        case BASE_ITEM_SLING:
          oItem=GetItemInSlot(INVENTORY_SLOT_BULLETS);
          break;
     }

     AddItemProperty(DURATION_TYPE_TEMPORARY,ItemPropertyDamageBonusVsAlign(IP_CONST_ALIGNMENTGROUP_EVIL,IP_CONST_DAMAGETYPE_DIVINE,IP_CONST_DAMAGEBONUS_2d6),oItem,9999.0);
     AddItemProperty(DURATION_TYPE_TEMPORARY,ItemPropertyVisualEffect(ITEM_VISUAL_HOLY),oItem,9999.0);
     SetLocalInt(oItem,"MartialStrik",1);
  }
   else if (iEquip==1)
   {
     oItem=GetPCItemLastUnequipped();
     iType= GetBaseItemType(oItem);

     switch (iType)
     {
        case BASE_ITEM_BOLT:
        case BASE_ITEM_BULLET:
        case BASE_ITEM_ARROW:
          iType=GetBaseItemType(GetItemInSlot(INVENTORY_SLOT_RIGHTHAND));
          break;
        case BASE_ITEM_SHORTBOW:
        case BASE_ITEM_LONGBOW:
          oItem=GetItemInSlot(INVENTORY_SLOT_ARROWS);
          break;
        case BASE_ITEM_LIGHTCROSSBOW:
        case BASE_ITEM_HEAVYCROSSBOW:
          oItem=GetItemInSlot(INVENTORY_SLOT_BOLTS);
          break;
        case BASE_ITEM_SLING:
          oItem=GetItemInSlot(INVENTORY_SLOT_BULLETS);
          break;
     }

    if ( GetLocalInt(oItem,"MartialStrik"))
    {
      RemoveSpecificProperty(oItem,ITEM_PROPERTY_DAMAGE_BONUS_VS_ALIGNMENT_GROUP,IP_CONST_ALIGNMENTGROUP_EVIL,IP_CONST_DAMAGEBONUS_2d6, 1,"",IP_CONST_DAMAGETYPE_DIVINE,DURATION_TYPE_TEMPORARY);
      RemoveSpecificProperty(oItem,ITEM_PROPERTY_VISUALEFFECT,ITEM_VISUAL_HOLY,-1,1,"",-1,DURATION_TYPE_TEMPORARY);
      DeleteLocalInt(oItem,"MartialStrik");
    }

   }
   else
   {
   	
     if (!GetHasFeat(FEAT_HOLY_MARTIAL_STRIKE)) return;
     
     oItem=GetItemInSlot(INVENTORY_SLOT_RIGHTHAND,oPC);
     iType= GetBaseItemType(oItem);

     switch (iType)
     {
        case BASE_ITEM_BOLT:
        case BASE_ITEM_BULLET:
        case BASE_ITEM_ARROW:
          iType=GetBaseItemType(GetItemInSlot(INVENTORY_SLOT_RIGHTHAND));
          break;
        case BASE_ITEM_SHORTBOW:
        case BASE_ITEM_LONGBOW:
          oItem=GetItemInSlot(INVENTORY_SLOT_ARROWS);
          break;
        case BASE_ITEM_LIGHTCROSSBOW:
        case BASE_ITEM_HEAVYCROSSBOW:
          oItem=GetItemInSlot(INVENTORY_SLOT_BOLTS);
          break;
        case BASE_ITEM_SLING:
          oItem=GetItemInSlot(INVENTORY_SLOT_BULLETS);
          break;
     }
    
     if (!GetLocalInt(oItem,"MartialStrik"))
     {
       AddItemProperty(DURATION_TYPE_TEMPORARY,ItemPropertyDamageBonusVsAlign(IP_CONST_ALIGNMENTGROUP_EVIL,IP_CONST_DAMAGETYPE_DIVINE,IP_CONST_DAMAGEBONUS_2d6),oItem,9999.0);
       AddItemProperty(DURATION_TYPE_TEMPORARY,ItemPropertyVisualEffect(ITEM_VISUAL_HOLY),oItem,9999.0);
       SetLocalInt(oItem,"MartialStrik",1);
     }
     oItem=GetItemInSlot(INVENTORY_SLOT_LEFTHAND,oPC);
     iType= GetBaseItemType(oItem);
     if ( !GetLocalInt(oItem,"MartialStrik"))
     {
       AddItemProperty(DURATION_TYPE_TEMPORARY,ItemPropertyDamageBonusVsAlign(IP_CONST_ALIGNMENTGROUP_EVIL,IP_CONST_DAMAGETYPE_DIVINE,IP_CONST_DAMAGEBONUS_2d6),oItem,9999.0);
       AddItemProperty(DURATION_TYPE_TEMPORARY,ItemPropertyVisualEffect(ITEM_VISUAL_HOLY),oItem,9999.0);
       SetLocalInt(oItem,"MartialStrik",1);
     }
   }


}


void UnholyStrike()
{
   object oItem;
   object oPC = OBJECT_SELF;

   int iEquip=GetLocalInt(oPC,"ONEQUIP");
   int iType;

   if (iEquip==2)
   {
   	
     if (!GetHasFeat(FEAT_UNHOLY_STRIKE)) return;
     
     oItem=GetPCItemLastEquipped();
     iType= GetBaseItemType(oItem);

     switch (iType)
     {
        case BASE_ITEM_BOLT:
        case BASE_ITEM_BULLET:
        case BASE_ITEM_ARROW:
          iType=GetBaseItemType(GetItemInSlot(INVENTORY_SLOT_RIGHTHAND));
          break;
        case BASE_ITEM_SHORTBOW:
        case BASE_ITEM_LONGBOW:
          oItem=GetItemInSlot(INVENTORY_SLOT_ARROWS);
          break;
        case BASE_ITEM_LIGHTCROSSBOW:
        case BASE_ITEM_HEAVYCROSSBOW:
          oItem=GetItemInSlot(INVENTORY_SLOT_BOLTS);
          break;
        case BASE_ITEM_SLING:
          oItem=GetItemInSlot(INVENTORY_SLOT_BULLETS);
          break;
     }


     AddItemProperty(DURATION_TYPE_TEMPORARY,ItemPropertyDamageBonusVsAlign(IP_CONST_ALIGNMENTGROUP_GOOD,IP_CONST_DAMAGETYPE_DIVINE,IP_CONST_DAMAGEBONUS_2d6),oItem,9999.0);
     AddItemProperty(DURATION_TYPE_TEMPORARY,ItemPropertyVisualEffect(ITEM_VISUAL_EVIL),oItem,9999.0);
     SetLocalInt(oItem,"UnholyStrik",1);
  }
   else if (iEquip==1)
   {
     oItem=GetPCItemLastUnequipped();
     iType= GetBaseItemType(oItem);

     switch (iType)
     {
        case BASE_ITEM_BOLT:
        case BASE_ITEM_BULLET:
        case BASE_ITEM_ARROW:
          iType=GetBaseItemType(GetItemInSlot(INVENTORY_SLOT_RIGHTHAND));
          break;
        case BASE_ITEM_SHORTBOW:
        case BASE_ITEM_LONGBOW:
          oItem=GetItemInSlot(INVENTORY_SLOT_ARROWS);
          break;
        case BASE_ITEM_LIGHTCROSSBOW:
        case BASE_ITEM_HEAVYCROSSBOW:
          oItem=GetItemInSlot(INVENTORY_SLOT_BOLTS);
          break;
        case BASE_ITEM_SLING:
          oItem=GetItemInSlot(INVENTORY_SLOT_BULLETS);
          break;
     }

    if ( GetLocalInt(oItem,"UnholyStrik"))
    {
      RemoveSpecificProperty(oItem,ITEM_PROPERTY_DAMAGE_BONUS_VS_ALIGNMENT_GROUP,IP_CONST_ALIGNMENTGROUP_GOOD,IP_CONST_DAMAGEBONUS_2d6, 1,"",IP_CONST_DAMAGETYPE_DIVINE,DURATION_TYPE_TEMPORARY);
      RemoveSpecificProperty(oItem,ITEM_PROPERTY_VISUALEFFECT,ITEM_VISUAL_EVIL,-1,1,"",-1,DURATION_TYPE_TEMPORARY);
      DeleteLocalInt(oItem,"UnholyStrik");
    }

   }
   else
   {
   	
     if (!GetHasFeat(FEAT_UNHOLY_STRIKE)) return;
     
     oItem=GetItemInSlot(INVENTORY_SLOT_RIGHTHAND,oPC);
     iType= GetBaseItemType(oItem);

     switch (iType)
     {
        case BASE_ITEM_BOLT:
        case BASE_ITEM_BULLET:
        case BASE_ITEM_ARROW:
          iType=GetBaseItemType(GetItemInSlot(INVENTORY_SLOT_RIGHTHAND));
          break;
        case BASE_ITEM_SHORTBOW:
        case BASE_ITEM_LONGBOW:
          oItem=GetItemInSlot(INVENTORY_SLOT_ARROWS);
          break;
        case BASE_ITEM_LIGHTCROSSBOW:
        case BASE_ITEM_HEAVYCROSSBOW:
          oItem=GetItemInSlot(INVENTORY_SLOT_BOLTS);
          break;
        case BASE_ITEM_SLING:
          oItem=GetItemInSlot(INVENTORY_SLOT_BULLETS);
          break;
     }
    
     if (!GetLocalInt(oItem,"UnholyStrik"))
     {
       AddItemProperty(DURATION_TYPE_TEMPORARY,ItemPropertyDamageBonusVsAlign(IP_CONST_ALIGNMENTGROUP_GOOD,IP_CONST_DAMAGETYPE_DIVINE,IP_CONST_DAMAGEBONUS_2d6),oItem,9999.0);
       AddItemProperty(DURATION_TYPE_TEMPORARY,ItemPropertyVisualEffect(ITEM_VISUAL_EVIL),oItem,9999.0);
       SetLocalInt(oItem,"UnholyStrik",1);
     }
     oItem=GetItemInSlot(INVENTORY_SLOT_LEFTHAND,oPC);
     iType= GetBaseItemType(oItem);
     if ( !GetLocalInt(oItem,"UnholyStrik"))
     {
       AddItemProperty(DURATION_TYPE_TEMPORARY,ItemPropertyDamageBonusVsAlign(IP_CONST_ALIGNMENTGROUP_GOOD,IP_CONST_DAMAGETYPE_DIVINE,IP_CONST_DAMAGEBONUS_2d6),oItem,9999.0);
       AddItemProperty(DURATION_TYPE_TEMPORARY,ItemPropertyVisualEffect(ITEM_VISUAL_EVIL),oItem,9999.0);
       SetLocalInt(oItem,"UnholyStrik",1);
     }
   }


}

////////////////End Martial Strike//////////////////

////////////////Begin Soldier of Light Spells//////////////////

void spellsCureMod(int nCasterLvl ,int nDamage, int nMaxExtraDamage, int nMaximized, int vfx_impactHurt, int vfx_impactHeal, int nSpellID)
{
    //Declare major variables
    object oTarget = GetSpellTargetObject();
    int nHeal;
    int nMetaMagic = GetMetaMagicFeat();
    effect eVis = EffectVisualEffect(vfx_impactHurt);
    effect eVis2 = EffectVisualEffect(vfx_impactHeal);
    effect eHeal, eDam;

    int nExtraDamage = nCasterLvl; // * figure out the bonus damage
    if (nExtraDamage > nMaxExtraDamage)
    {
        nExtraDamage = nMaxExtraDamage;
    }
    // * if low or normal difficulty is treated as MAXIMIZED
    if(GetIsPC(oTarget) && GetGameDifficulty() < GAME_DIFFICULTY_CORE_RULES)
    {
        nDamage = nMaximized + nExtraDamage;
    }
    else
    {
        nDamage = nDamage + nExtraDamage;
    }


    //Make metamagic checks
    int iBlastFaith = BlastInfidelOrFaithHeal(OBJECT_SELF, oTarget, DAMAGE_TYPE_POSITIVE, TRUE);
    if (nMetaMagic == METAMAGIC_MAXIMIZE || iBlastFaith)
    {
        nDamage = 8 + nExtraDamage;
        // * if low or normal difficulty then MAXMIZED is doubled.
        if(GetIsPC(OBJECT_SELF) && GetGameDifficulty() < GAME_DIFFICULTY_CORE_RULES)
        {
            nDamage = nDamage + nExtraDamage;
        }
    }
    if (nMetaMagic == METAMAGIC_EMPOWER || GetHasFeat(FEAT_HEALING_DOMAIN_POWER))
    {
        nDamage = nDamage + (nDamage/2);
    }


    if (MyPRCGetRacialType(oTarget) != RACIAL_TYPE_UNDEAD)
    {
        //Figure out the amount of damage to heal
        nHeal = nDamage;
        //Set the heal effect
        eHeal = EffectHeal(nHeal);
        //Apply heal effect and VFX impact
        SPApplyEffectToObject(DURATION_TYPE_INSTANT, eHeal, oTarget);
        SPApplyEffectToObject(DURATION_TYPE_INSTANT, eVis2, oTarget);
        //Fire cast spell at event for the specified target
        SignalEvent(oTarget, EventSpellCastAt(OBJECT_SELF, nSpellID, FALSE));


    }
    //Check that the target is undead
    else
    {
        int nTouch = TouchAttackMelee(oTarget);
        if (nTouch > 0)
        {
            if(!GetIsReactionTypeFriendly(oTarget))
            {
                //Fire cast spell at event for the specified target
                SignalEvent(oTarget, EventSpellCastAt(OBJECT_SELF, nSpellID));
                if (!MyPRCResistSpell(OBJECT_SELF, oTarget,nCasterLvl+add_spl_pen(OBJECT_SELF)))
                {
                    eDam = EffectDamage(nDamage,DAMAGE_TYPE_NEGATIVE);
                    //Apply the VFX impact and effects
                    DelayCommand(1.0, SPApplyEffectToObject(DURATION_TYPE_INSTANT, eDam, oTarget));
                    SPApplyEffectToObject(DURATION_TYPE_INSTANT, eVis, oTarget);
                }
            }
        }
    }
}

////////////////End Soldier of Light Spells//////////////////