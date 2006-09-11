/*
    prc_craft_include

    Include file for forge scripts, currently restricted to equipable items

    By: Flaming_Sword
    Created: Jul 12, 2006
    Modified: Sept 10, 2006

    GetItemPropertySubType() returns 0 or 65535, not -1
        on no subtype as in Lexicon

    Some hardcoded functions for itemprops to avoid looping through
        the 2das multiple times:

        Get2DALineFromItemprop()
        DisallowType()
        PrereqSpecialHandling()
        PropSpecialHandling()

*/

itemproperty ConstructIP(int nType, int nSubTypeValue = 0, int nCostTableValue = 0, int nParam1Value = 0);

//Partly ripped off the lexicon :P
int GetItemBaseAC(object oItem);

int GetItemArmourCheckPenalty(object oItem);

#include "prc_alterations"
#include "inc_newspellbook"
#include "prc_inc_spells"
#include "prc_inc_listener"
#include "prc_inc_fileend"

const int NUM_MAX_PROPERTIES            = 200;
const int NUM_MAX_SUBTYPES              = 256;
//const int NUM_MAX_FEAT_SUBTYPES         = 16384;    //because iprp_feats is frickin' huge
const int NUM_MAX_FEAT_SUBTYPES         = 397;      //because the above screwed the game

//const int NUM_MAX_SPELL_SUBTYPES        = 540;      //restricted to bioware spells
                                                    //  to avoid crashes
const int NUM_MAX_SPELL_SUBTYPES        = 1172;     //new value for list skipping

const int PRC_CRAFT_SIMPLE_WEAPON       = 1;
const int PRC_CRAFT_MARTIAL_WEAPON      = 2;
const int PRC_CRAFT_EXOTIC_WEAPON       = 3;

const int PRC_CRAFT_MATERIAL_METAL      = 1;
const int PRC_CRAFT_MATERIAL_WOOD       = 2;
const int PRC_CRAFT_MATERIAL_LEATHER    = 3;
const int PRC_CRAFT_MATERIAL_CLOTH      = 4;

const string PRC_CRAFT_UID_SUFFIX       = "_UID_PRC";
const string PRC_CRAFT_STORAGE_CHEST    = "PRC_CRAFT_STORAGE_CHEST";
const string PRC_CRAFT_TEMPORARY_CHEST  = "PRC_CRAFT_TEMPORARY_CHEST";
const string PRC_CRAFT_ITEMPROP_ARRAY   = "PRC_CRAFT_ITEMPROP_ARRAY";

const int PRC_CRAFT_FLAG_NONE               = 0;
const int PRC_CRAFT_FLAG_MASTERWORK         = 1;
const int PRC_CRAFT_FLAG_ADAMANTINE         = 2;
const int PRC_CRAFT_FLAG_DARKWOOD           = 4;
const int PRC_CRAFT_FLAG_DRAGONHIDE         = 8;
const int PRC_CRAFT_FLAG_MITHRAL            = 16;
const int PRC_CRAFT_FLAG_COLD_IRON          = 32;   //not implemented
const int PRC_CRAFT_FLAG_ALCHEMICAL_SILVER  = 64;   //not implemented
const int PRC_CRAFT_FLAG_MUNDANE_CRYSTAL    = 128;
const int PRC_CRAFT_FLAG_DEEP_CRYSTAL       = 256;

const int PRC_CRAFT_ITEM_TYPE_WEAPON    = 1;
const int PRC_CRAFT_ITEM_TYPE_ARMOUR    = 2;
const int PRC_CRAFT_ITEM_TYPE_SHIELD    = 3;
const int PRC_CRAFT_ITEM_TYPE_AMMO      = 4;

const string PRC_CRAFT_SPECIAL_BANE     = "PRC_CRAFT_SPECIAL_BANE";
const string PRC_CRAFT_SPECIAL_BANE_RACE = "PRC_CRAFT_SPECIAL_BANE_RACE";

struct itemvars
{
    object item;
    int enhancement;
    int additionalcost;
    int epic;
};

int GetCraftingTime(int nCost)
{
    int nTemp = nCost / 1000;
    if(nCost % 1000) nTemp++;
    float fDelay;
    switch(GetPRCSwitch(PRC_CRAFTING_TIME_SCALE))
    {
        case 0: fDelay = HoursToSeconds(nTemp); break;          //1 hour/1000gp, default
        case 1: fDelay = 0.0; break;                            //off, no delay
        case 2: fDelay = RoundsToSeconds(nTemp); break;         //1 round/1000gp
        case 3: fDelay = TurnsToSeconds(nTemp); break;          //1 turn/1000gp
        case 4: fDelay = HoursToSeconds(nTemp); break;          //1 hour/1000gp
        case 5: fDelay = 24 * HoursToSeconds(nTemp); break;     //1 day/1000gp
    }
    int nMultiplyer = GetPRCSwitch(PRC_CRAFT_TIMER_MULTIPLIER);
    if(nMultiplyer)
        fDelay *= (IntToFloat(nMultiplyer) / 100.0);
    return FloatToInt(fDelay / 6);
}

object GetCraftChest()
{
    return GetObjectByTag(PRC_CRAFT_STORAGE_CHEST);
}

object GetTempCraftChest()
{
    return GetObjectByTag(PRC_CRAFT_TEMPORARY_CHEST);
}

int GetCraftingSkill(object oItem)
{
    int nType = StringToInt(Get2DACache("prc_craft_gen_it", "Type", GetBaseItemType(oItem)));
    if((nType == PRC_CRAFT_ITEM_TYPE_WEAPON) || (nType == PRC_CRAFT_ITEM_TYPE_AMMO))
        return SKILL_CRAFT_WEAPON;
    return SKILL_CRAFT_ARMOR;
}

string GetMaterialString(int nType)
{
    string sType = IntToString(nType);
    int nLen = GetStringLength(sType);
    switch(nLen)
    {
        case 1: sType = "0" + sType;
        case 2: sType = "0" + sType; break;
    }
    return sType;
}

//Will replace first 3 chars of item's tag with material flags
string GetNewItemTag(object oItem, int nType)
{
    string sTag = GetTag(oItem);
    return GetMaterialString(nType) + GetStringRight(sTag, GetStringLength(sTag) - 3);
}

int GetArmourCheckPenaltyReduction(object oItem)
{
    int nBase = GetBaseItemType(oItem);
    int nBonus = 0;
    if(((nBase == BASE_ITEM_ARMOR) ||
        (nBase == BASE_ITEM_SMALLSHIELD) ||
        (nBase == BASE_ITEM_LARGESHIELD) ||
        (nBase == BASE_ITEM_TOWERSHIELD))
        )
    {
        int nMaterial = StringToInt(GetStringLeft(GetTag(oItem), 3));
        int nACPenalty = GetItemArmourCheckPenalty(oItem);
        if(nMaterial & PRC_CRAFT_FLAG_MASTERWORK)
        {
            nBonus = min(1, nACPenalty);
        }
        if(nMaterial & PRC_CRAFT_FLAG_DARKWOOD)
        {
            nBonus = min(2, nACPenalty);
        }
        if(nMaterial & PRC_CRAFT_FLAG_MITHRAL)
        {
            nBonus = min(3, nACPenalty);
        }
    }
    return nBonus;
}

int SkillHasACPenalty(int nSkill)
{
    return StringToInt(Get2DACache("skills", "ArmorCheckPenalty", nSkill));
}

//Returns -1 if itemprop is not in the list, -2 if similar and should disallow type,
//  hardcoded to avoid looping through 2das
int Get2DALineFromItemprop(string sFile, itemproperty ip, object oItem)
{   //it's either hardcoding or large numbers of 2da reads
    int nType = GetItemPropertyType(ip);
    int nSubType = GetItemPropertySubType(ip);
    int nCostTableValue = GetItemPropertyCostTableValue(ip);
    int nParam1Value = GetItemPropertyParam1Value(ip);
    int nBase = GetBaseItemType(oItem);
    if(sFile == "craft_armour")
    {
        switch(nType)
        {
            case ITEM_PROPERTY_AC_BONUS:
            {
                return (nCostTableValue - 1);
                break;
            }
            case ITEM_PROPERTY_BONUS_FEAT:
            {
                if(nSubType == 201) return 24;
                break;
            }
            case ITEM_PROPERTY_CAST_SPELL:
            {
                switch(nSubType)
                {
                    case IP_CONST_CASTSPELL_CONTROL_UNDEAD_13: return 63; break;
                    case IP_CONST_CASTSPELL_ETHEREALNESS_18: return 33; break;
                    case 928: return (GetItemPropertyCostTableValue(ip) == IP_CONST_CASTSPELL_NUMUSES_1_USE_PER_DAY) ? 43 : 44; break; //spell turning
                }
                break;
            }
            case ITEM_PROPERTY_DAMAGE_REDUCTION:
            {
                if(nSubType == IP_CONST_DAMAGEREDUCTION_1)
                {
                    switch(nCostTableValue)
                    {
                        case IP_CONST_DAMAGESOAK_5_HP: return 38; break;
                        case IP_CONST_DAMAGESOAK_10_HP: return 39; break;
                        case IP_CONST_DAMAGESOAK_15_HP: return 40; break;
                        default: return -2; break;
                    }
                }
                else if(nSubType == IP_CONST_DAMAGEREDUCTION_6)
                {
                    switch(nCostTableValue)
                    {
                        case IP_CONST_DAMAGESOAK_5_HP: return 41; break;
                        case IP_CONST_DAMAGESOAK_10_HP: return 42; break;
                        default: return -2; break;
                    }
                }
                else return -2;
                break;
            }
            case ITEM_PROPERTY_DAMAGE_RESISTANCE:
            {
                int nBaseValue = -1;
                switch(nSubType)
                {
                    case IP_CONST_DAMAGETYPE_ACID: nBaseValue = 20; break;
                    case IP_CONST_DAMAGETYPE_COLD: nBaseValue = 25; break;
                    case IP_CONST_DAMAGETYPE_ELECTRICAL: nBaseValue = 29; break;
                    case IP_CONST_DAMAGETYPE_FIRE: nBaseValue = 34; break;
                    case IP_CONST_DAMAGETYPE_SONIC: nBaseValue = 51; break;
                }
                if(nBaseValue != -1)
                {
                    switch(nCostTableValue)
                    {
                        case IP_CONST_DAMAGERESIST_10: return nBaseValue; break;
                        case IP_CONST_DAMAGERESIST_20: return nBaseValue + 1; break;
                        case IP_CONST_DAMAGERESIST_30: return nBaseValue + 2; break;
                        case IP_CONST_DAMAGERESIST_50: return nBaseValue + 3; break;
                        default: return -2; break;
                    }
                }
                else return -2;
                break;
            }
            case ITEM_PROPERTY_SPELL_RESISTANCE:
            {
                if((nCostTableValue >= 27) && (nCostTableValue <= 34)) return (nCostTableValue + 28);
                else return -2;
                break;
            }
            case ITEM_PROPERTY_SKILL_BONUS:
            {
                if(nSubType == SKILL_HIDE)
                {
                    nCostTableValue -= GetArmourCheckPenaltyReduction(oItem);
                    switch(nCostTableValue)
                    {
                        case 5: return 49; break;
                        case 10: return 50; break;
                        case 15: return 51; break;
                        default: return -1; break;
                    }
                }
                else if(nSubType == SKILL_MOVE_SILENTLY)
                {
                    nCostTableValue -= GetArmourCheckPenaltyReduction(oItem);
                    switch(nCostTableValue)
                    {
                        case 5: return 52; break;
                        case 10: return 53; break;
                        case 15: return 54; break;
                        default: return -1; break;
                    }
                }
                else
                    return -2;
                break;
            }
        }
    }
    else if(sFile == "craft_weapon")
    {
        switch(nType)
        {
            case ITEM_PROPERTY_ENHANCEMENT_BONUS:
            {
                return (nCostTableValue - 1);
                break;
            }
            case ITEM_PROPERTY_DAMAGE_BONUS:
            {
                int bAmmo = StringToInt(Get2DACache("prc_craft_gen_it", "Type", GetBaseItemType(oItem))) == PRC_CRAFT_ITEM_TYPE_AMMO;
                if(bAmmo && nSubType == ((nBase == BASE_ITEM_BULLET) ? DAMAGE_TYPE_BLUDGEONING : DAMAGE_TYPE_PIERCING))
                    return (nCostTableValue - 1);
                if(nSubType == IP_CONST_DAMAGETYPE_ACID)
                {
                    if(nCostTableValue == IP_CONST_DAMAGEBONUS_3d6) return 20;
                    else return -2;
                }
                else if(nSubType == IP_CONST_DAMAGETYPE_FIRE)
                {
                    if(nCostTableValue == IP_CONST_DAMAGEBONUS_1d6) return 29;
                    else if(nCostTableValue == IP_CONST_DAMAGEBONUS_3d6) return 30;
                    else return -2;
                }
                else if(nSubType == IP_CONST_DAMAGETYPE_COLD)
                {
                    if(nCostTableValue == IP_CONST_DAMAGEBONUS_1d6) return 31;
                    else if(nCostTableValue == IP_CONST_DAMAGEBONUS_3d6) return 32;
                    else return -2;
                }
                else if(nSubType == IP_CONST_DAMAGETYPE_ELECTRICAL)
                {
                    if(nCostTableValue == IP_CONST_DAMAGEBONUS_1d6) return 36;
                    else if(nCostTableValue == IP_CONST_DAMAGEBONUS_3d6) return 37;
                    else return -2;
                }
                else if(nSubType == IP_CONST_DAMAGETYPE_SONIC)
                {
                    if(nCostTableValue == IP_CONST_DAMAGEBONUS_3d6) return 38;
                    else return -2;
                }
                else return -2;
                break;
            }
            case ITEM_PROPERTY_DAMAGE_BONUS_VS_ALIGNMENT_GROUP:
            {
                switch(nSubType)
                {
                    case IP_CONST_ALIGNMENTGROUP_LAWFUL:
                    {
                        if(nCostTableValue == IP_CONST_DAMAGEBONUS_2d6) return 21;
                        else if(nCostTableValue == IP_CONST_DAMAGEBONUS_3d6) return 22;
                        else return -2;
                        break;
                    }
                    case IP_CONST_ALIGNMENTGROUP_CHAOTIC:
                    {
                        if(nCostTableValue == IP_CONST_DAMAGEBONUS_2d6) return 23;
                        else if(nCostTableValue == IP_CONST_DAMAGEBONUS_3d6) return 24;
                        else return -2;
                        break;
                    }
                    case IP_CONST_ALIGNMENTGROUP_EVIL:
                    {
                        if(nCostTableValue == IP_CONST_DAMAGEBONUS_2d6) return 33;
                        else if(nCostTableValue == IP_CONST_DAMAGEBONUS_3d6) return 34;
                        else return -2;
                        break;
                    }
                    case IP_CONST_ALIGNMENTGROUP_GOOD:
                    {
                        if(nCostTableValue == IP_CONST_DAMAGEBONUS_2d6) return 39;
                        else if(nCostTableValue == IP_CONST_DAMAGEBONUS_3d6) return 40;
                        else return -2;
                        break;
                    }
                    default: return -2; break;
                }
                break;
            }
            case ITEM_PROPERTY_DAMAGE_BONUS_VS_RACIAL_GROUP:
            {
                switch(nCostTableValue)
                {
                    case IP_CONST_DAMAGEBONUS_2d6: return 25; break;
                    case IP_CONST_DAMAGEBONUS_4d6: return 26; break;
                    default: return -2; break;
                }
                break;
            }
            case ITEM_PROPERTY_KEEN: return 35; break;
            case ITEM_PROPERTY_ON_HIT_PROPERTIES:
            {
                switch(nSubType)
                {
                    case IP_CONST_ONHIT_SLAYRACE:
                    {
                        if(nParam1Value == IP_CONST_RACIALTYPE_UNDEAD)
                        {
                            if(nCostTableValue == IP_CONST_ONHIT_SAVEDC_14) return 27;
                            else if(nCostTableValue == 21) return 28;
                            else return -2;
                        }
                        break;
                    }
                    case IP_CONST_ONHIT_VORPAL: return 41; break;
                    case IP_CONST_ONHIT_WOUNDING: return 42; break;
                }
                break;
            }
        }
    }
    return -1;
}

//Hardcoded properties to disallow, avoids many loops through 2das
void DisallowType(object oItem, string sFile, itemproperty ip)
{
    int i;
    int nType = GetItemPropertyType(ip);
    int nSubType = GetItemPropertySubType(ip);
    int nCostTableValue = GetItemPropertyCostTableValue(ip);
    int nParam1Value = GetItemPropertyParam1Value(ip);
    if(sFile == "craft_armour")
    {
        switch(nType)
        {
            /*
            case ITEM_PROPERTY_AC_BONUS:
            {
            }
            case ITEM_PROPERTY_BONUS_FEAT:
            {
            }
            case ITEM_PROPERTY_CAST_SPELL:
            {
            }
            */
            case ITEM_PROPERTY_DAMAGE_REDUCTION:
            {
                for(i = 38; i <= 42; i++)
                    array_set_int(oItem, PRC_CRAFT_ITEMPROP_ARRAY, i, 0);
                break;
            }
            case ITEM_PROPERTY_DAMAGE_RESISTANCE:
            {
                for(i = 20; i <= 23; i++)
                    array_set_int(oItem, PRC_CRAFT_ITEMPROP_ARRAY, i, 0);
                for(i = 25; i <= 32; i++)
                    array_set_int(oItem, PRC_CRAFT_ITEMPROP_ARRAY, i, 0);
                for(i = 34; i <= 37; i++)
                    array_set_int(oItem, PRC_CRAFT_ITEMPROP_ARRAY, i, 0);
                for(i = 51; i <= 54; i++)
                    array_set_int(oItem, PRC_CRAFT_ITEMPROP_ARRAY, i, 0);
                break;
            }
            case ITEM_PROPERTY_SPELL_RESISTANCE:
            {
                for(i = 55; i <= 62; i++)
                    array_set_int(oItem, PRC_CRAFT_ITEMPROP_ARRAY, i, 0);
                break;
            }
            case ITEM_PROPERTY_SKILL_BONUS:
            {
                for(i = 45; i <= 50; i++)
                    array_set_int(oItem, PRC_CRAFT_ITEMPROP_ARRAY, i, 0);
                break;
            }
        }
    }
    else if(sFile == "craft_weapon")
    {
        switch(nType)
        {
            /*
            case ITEM_PROPERTY_ENHANCEMENT_BONUS:
            {
            }
            */
            case ITEM_PROPERTY_DAMAGE_BONUS:
            {
                array_set_int(oItem, PRC_CRAFT_ITEMPROP_ARRAY, 20, 0);
                for(i = 29; i <= 32; i++)
                    array_set_int(oItem, PRC_CRAFT_ITEMPROP_ARRAY, i, 0);
                for(i = 36; i <= 38; i++)
                    array_set_int(oItem, PRC_CRAFT_ITEMPROP_ARRAY, i, 0);
                break;
            }
            case ITEM_PROPERTY_DAMAGE_BONUS_VS_ALIGNMENT_GROUP:
            {
                for(i = 21; i <= 24; i++)
                    array_set_int(oItem, PRC_CRAFT_ITEMPROP_ARRAY, i, 0);
                array_set_int(oItem, PRC_CRAFT_ITEMPROP_ARRAY, 33, 0);
                array_set_int(oItem, PRC_CRAFT_ITEMPROP_ARRAY, 34, 0);
                array_set_int(oItem, PRC_CRAFT_ITEMPROP_ARRAY, 39, 0);
                array_set_int(oItem, PRC_CRAFT_ITEMPROP_ARRAY, 40, 0);
                break;
            }
            case ITEM_PROPERTY_DAMAGE_BONUS_VS_RACIAL_GROUP:
            {
                array_set_int(oItem, PRC_CRAFT_ITEMPROP_ARRAY, 25, 0);
                array_set_int(oItem, PRC_CRAFT_ITEMPROP_ARRAY, 26, 0);
                break;
            }
            //case ITEM_PROPERTY_KEEN: array_set_int(oItem, PRC_CRAFT_ITEMPROP_ARRAY, 35, 0); break;
            case ITEM_PROPERTY_ON_HIT_PROPERTIES:
            {
                switch(nSubType)
                {
                    case IP_CONST_ONHIT_SLAYRACE:
                    {
                        if(nParam1Value == IP_CONST_RACIALTYPE_UNDEAD)
                        {
                            array_set_int(oItem, PRC_CRAFT_ITEMPROP_ARRAY, 27, 0);
                            array_set_int(oItem, PRC_CRAFT_ITEMPROP_ARRAY, 28, 0);
                        }
                        break;
                    }
                    /*
                    case IP_CONST_ONHIT_VORPAL: return 41; break;
                    case IP_CONST_ONHIT_WOUNDING: return 42; break;
                    */
                }
                break;
            }
        }
    }
}

//hardcoding of some prereqs
int PrereqSpecialHandling(string sFile, object oItem, int nLine)
{
    int nTemp;
    int nBase = GetBaseItemType(oItem);
    if(StringToInt(Get2DACache(sFile, "Special", nLine)))
    {
        if(sFile == "craft_armour")
        {   //nothing here yet
        }
        else if(sFile == "craft_weapon")
        {
            int nDamageType = StringToInt(Get2DACache("baseitems", "WeaponType", nBase));
            int bRangedType = StringToInt(Get2DACache("baseitems", "RangedWeapon", nBase));
            int bRanged = bRangedType;// && (bRangedType != nBase);
            switch(nLine)
            {
                case 27:
                case 28:
                {
                    return (!bRanged && ((nDamageType == 2) || (nDamageType == 5)));
                    break;
                }
                case 35:
                {
                    return (!bRanged && (nDamageType != 2));
                    break;
                }
                case 41:
                {
                    return (!bRanged && ((nDamageType == 3) || (nDamageType == 4)));
                    break;
                }
            }
        }
    }
    return TRUE;
}

//Checks and decrements spells based on property to add
int CheckCraftingSpells(object oPC, string sFile, int nLine, int bDecrement = FALSE)
{
    if(nLine == -1) return FALSE;
    int nSpellPattern = StringToInt(Get2DACache(sFile, "SpellPattern", nLine));
    int nSpell1, nSpell2, nSpell3, nSpellOR1, nSpellOR2;
    int bOR = FALSE;
    if(nSpellPattern)
    {
        if(nSpellPattern & 1)
        {
            nSpell1 = StringToInt(Get2DACache(sFile, "Spell1", nLine));
            if(!PRCGetHasSpell(nSpell1))
                return FALSE;
        }
        if(nSpellPattern & 2)
        {
            nSpell2 = StringToInt(Get2DACache(sFile, "Spell2", nLine));
            if(!PRCGetHasSpell(nSpell2))
                return FALSE;
        }
        if(nSpellPattern & 4)
        {
            nSpell3 = StringToInt(Get2DACache(sFile, "Spell3", nLine));
            if(!PRCGetHasSpell(nSpell3))
                return FALSE;
        }
        if(nSpellPattern & 8)
        {
            nSpellOR1 = StringToInt(Get2DACache(sFile, "SpellOR1", nLine));
            if(!PRCGetHasSpell(nSpellOR1))
                if(nSpellPattern & 16)
                {
                    bOR = TRUE;
                    nSpellOR2 = StringToInt(Get2DACache(sFile, "SpellOR2", nLine));
                    if(!PRCGetHasSpell(nSpellOR2))
                        return FALSE;
                }
                else
                    return FALSE;
        }
        else if(nSpellPattern & 16)
        {
            nSpellOR2 = StringToInt(Get2DACache(sFile, "SpellOR2", nLine));
            if(!PRCGetHasSpell(nSpellOR2))
                return FALSE;
        }
        if(bDecrement)
        {
            if(nSpellPattern & 1)
                PRCDecrementRemainingSpellUses(oPC, nSpell1);
            if(nSpellPattern & 2)
                PRCDecrementRemainingSpellUses(oPC, nSpell2);
            if(nSpellPattern & 4)
                PRCDecrementRemainingSpellUses(oPC, nSpell3);
            if(nSpellPattern & 8)
                PRCDecrementRemainingSpellUses(oPC, (bOR) ? nSpellOR2 : nSpellOR1);
            else if(nSpellPattern & 16)
                PRCDecrementRemainingSpellUses(oPC, nSpellOR2);
        }
    }
    return TRUE;
}

//Checks and decrements power points based on property to add
int CheckCraftingPowerPoints(object oPC, string sFile, int nLine, int bDecrement = FALSE)
{
    if(nLine == -1) return FALSE;
    int nSpellPattern = StringToInt(Get2DACache(sFile, "SpellPattern", nLine));
    int nPower;
    int bOR = TRUE;
    int nLoss = 0;
    if(nSpellPattern)
    {
        if(nSpellPattern & 1)
        {
            nPower = StringToInt(Get2DACache(sFile, "Spell1", nLine));
            if(GetHasPower(nPower, oPC))
                nLoss += (StringToInt(lookup_spell_innate(nPower)) * 2 - 1);
            else
                return FALSE;
        }
        if(nSpellPattern & 2)
        {
            nPower = StringToInt(Get2DACache(sFile, "Spell2", nLine));
            if(GetHasPower(nPower, oPC))
                nLoss += (StringToInt(lookup_spell_innate(nPower)) * 2 - 1);
            else
                return FALSE;
        }
        if(nSpellPattern & 4)
        {
            nPower = StringToInt(Get2DACache(sFile, "Spell3", nLine));
            if(GetHasPower(nPower, oPC))
                nLoss += (StringToInt(lookup_spell_innate(nPower)) * 2 - 1);
            else
                return FALSE;
        }
        if(nSpellPattern & 8)
        {
            nPower = StringToInt(Get2DACache(sFile, "SpellOR1", nLine));
            if(GetHasPower(nPower, oPC))
                nLoss += (StringToInt(lookup_spell_innate(nPower)) * 2 - 1);
            else if(nSpellPattern & 16)
            {
                nPower = StringToInt(Get2DACache(sFile, "SpellOR2", nLine));
                if(GetHasPower(nPower, oPC))
                    nLoss += (StringToInt(lookup_spell_innate(nPower)) * 2 - 1);
                else
                    return FALSE;
            }
            else
                return FALSE;
        }
        else if(nSpellPattern & 16)
        {
            nPower = StringToInt(Get2DACache(sFile, "SpellOR2", nLine));
            if(GetHasPower(nPower, oPC))
                nLoss += (StringToInt(lookup_spell_innate(nPower)) * 2 - 1);
            else
                return FALSE;
        }
    }
    if(GetCurrentPowerPoints(oPC) < nLoss)
        return FALSE;

    if(bDecrement) LosePowerPoints(oPC, nLoss, TRUE);

    return TRUE;
}

//Returns a struct containing enhancement and additional cost values, don't bother with array when bSet == 0
struct itemvars GetItemVars(object oPC, object oItem, string sFile, int bEpic = 0, int bSet = 0)
{
    struct itemvars strTemp;
    int i;
    int j, k, bEnhanced, count;
    int nEnhancement;
    int nSpellPattern;
    int nSpell1, nSpell2, nSpell3, nSpellOR1, nSpellOR2;
    int nCasterLevel = max(GetLevelByTypeArcane(oPC), GetLevelByTypeDivine(oPC));
    int nManifesterLevel = GetManifesterLevel(oPC);
    int nLevel;
    int nFileEnd = PRCGetFileEnd(sFile);
    int nRace = MyPRCGetRacialType(oPC);
    string sPropertyType;
    strTemp.item = oItem;
    if(bSet)
    {
        if(array_exists(oPC, PRC_CRAFT_ITEMPROP_ARRAY))
            array_delete(oPC, PRC_CRAFT_ITEMPROP_ARRAY);
        array_create(oPC, PRC_CRAFT_ITEMPROP_ARRAY);
        //Setup
        for(i = 0; i <= nFileEnd; i++)
        {
            if(!GetPRCSwitch("PRC_CRAFT_DISABLE_" + sFile + "_" + IntToString(i)) && PrereqSpecialHandling(sFile, oItem, i))
                array_set_int(oPC, PRC_CRAFT_ITEMPROP_ARRAY, i, 1);
        }
        int nBase = GetBaseItemType(oItem);
        int bRangedType = StringToInt(Get2DACache("baseitems", "RangedWeapon", nBase));
        if(bRangedType && (bRangedType != nBase))
        {   //disallowed because ranged weapons can't have onhit
            array_set_int(oPC, PRC_CRAFT_ITEMPROP_ARRAY, 22, 0);
            array_set_int(oPC, PRC_CRAFT_ITEMPROP_ARRAY, 24, 0);
            array_set_int(oPC, PRC_CRAFT_ITEMPROP_ARRAY, 26, 0);
            array_set_int(oPC, PRC_CRAFT_ITEMPROP_ARRAY, 34, 0);
            array_set_int(oPC, PRC_CRAFT_ITEMPROP_ARRAY, 40, 0);
            array_set_int(oPC, PRC_CRAFT_ITEMPROP_ARRAY, 42, 0);
        }
    }
    itemproperty ip = GetFirstItemProperty(oItem);
    if(DEBUG) DoDebug("GetItemVars: " + GetName(oItem) + ", before itemprop loop");
    //Checking itemprops
    count = 0;
    while(GetIsItemPropertyValid(ip))
    {   //assumes no duplicated enhancement itemprops
        k = Get2DALineFromItemprop(sFile, ip, oItem);   //is causing TMI with armour with skill props
        count++;
        if(DEBUG) DoDebug("GetItemVars: itemprop number " + IntToString(count) +
                            " " + IntToString(GetItemPropertyType(ip)) +
                            " " + IntToString(GetItemPropertySubType(ip)) +
                            " " + IntToString(GetItemPropertyCostTableValue(ip)) +
                            " " + IntToString(GetItemPropertyParam1Value(ip))
                            );

        if(k >= 0)
        {
            if(k < 20) bEnhanced = TRUE;
            if(bSet)
            {
                for(j = StringToInt(Get2DACache(sFile, "ReplaceLast", k)); j >= 0; j--)
                {
                    array_set_int(oPC, PRC_CRAFT_ITEMPROP_ARRAY, k - j, 0);
                }
            }
            nEnhancement = StringToInt(Get2DACache(sFile, "Enhancement", k));
            strTemp.enhancement += nEnhancement;
            if(nEnhancement > 5) strTemp.epic = TRUE;
            strTemp.additionalcost += StringToInt(Get2DACache(sFile, "AdditionalCost", k));

            if(DEBUG)
            {
                sPropertyType = GetStringByStrRef(StringToInt(Get2DACache(sFile, "Name", k)));
                if(sPropertyType != "")
                    DoDebug("GetItemVars: " + sPropertyType);
            }
        }
        else if(bSet && k == -2)
        {
            DisallowType(oPC, sFile, ip);
        }

        ip = GetNextItemProperty(oItem);
    }
    if(strTemp.enhancement > 10) strTemp.epic = TRUE;
    if(DEBUG) DoDebug("GetItemVars: " + GetName(oItem) + ", after itemprop loop");

    if(DEBUG)
    {
        DoDebug("GetItemVars: " + GetName(oItem) +
                ", Enhancement: " + IntToString(strTemp.enhancement) +
                ", AdditionalCost: " + IntToString(strTemp.additionalcost));
    }

    if(!bSet) return strTemp;   //don't bother with array

    if(!bEpic && strTemp.epic)
    {   //attempting to craft epic item without epic crafting feat, fails
        for(i = 0; i <= nFileEnd; i++)
            array_set_int(oPC, PRC_CRAFT_ITEMPROP_ARRAY, i, 0);
        return strTemp;
    }
    if(!bEnhanced && ((sFile == "craft_armour") || (sFile == "craft_weapon")))
    {   //no enhancement value, cannot add more itemprops, stop right there
        array_set_int(oPC, PRC_CRAFT_ITEMPROP_ARRAY, 0, 1);
        for(i = 1; i <= nFileEnd; i++)
            array_set_int(oPC, PRC_CRAFT_ITEMPROP_ARRAY, i, 0);
        return strTemp;
    }
    string sTemp;
    //Checking available spells, epic flag, caster level
    for(i = 0; i <= nFileEnd; i++)
    {   //will skip over properties already disallowed
        if(array_get_int(oPC, PRC_CRAFT_ITEMPROP_ARRAY, i))
        {
            sPropertyType = Get2DACache(sFile, "PropertyType", i);
            if(sPropertyType == "M")
                nLevel = nCasterLevel;
            else if(sPropertyType == "P")
                nLevel = nManifesterLevel;
            else
                nLevel = max(nCasterLevel, nManifesterLevel);
            if(!bEpic && Get2DACache(sFile, "Epic", i) == "1")
                array_set_int(oPC, PRC_CRAFT_ITEMPROP_ARRAY, i, 0);
            else if(!bEpic && ((StringToInt(Get2DACache(sFile, "Enhancement", i)) + strTemp.enhancement) > 10))
                array_set_int(oPC, PRC_CRAFT_ITEMPROP_ARRAY, i, 0);
            else if(nLevel < StringToInt(Get2DACache(sFile, "Level", i)))
                array_set_int(oPC, PRC_CRAFT_ITEMPROP_ARRAY, i, 0);
            else
            {
                if(StringToInt(Get2DACache(sFile, "SpellPattern", i)))
                {
                    if(
                        (sPropertyType == "M") &&
                        !CheckCraftingSpells(oPC, sFile, i)
                        )
                    {
                        array_set_int(oPC, PRC_CRAFT_ITEMPROP_ARRAY, i, 0);
                        continue;
                    }
                    if(
                        (sPropertyType == "P") &&
                        !CheckCraftingPowerPoints(oPC, sFile, i)
                        )
                    {
                        array_set_int(oPC, PRC_CRAFT_ITEMPROP_ARRAY, i, 0);
                        continue;
                    }
                }
                sTemp = Get2DACache(sFile, "Race", i);
                if(sTemp != "" && nRace != StringToInt(sTemp))
                {
                    array_set_int(oPC, PRC_CRAFT_ITEMPROP_ARRAY, i, 0);
                    continue;
                }
                sTemp = Get2DACache(sFile, "Feat", i);
                if(sTemp != "" && !GetHasFeat(StringToInt(sTemp)))
                {
                    array_set_int(oPC, PRC_CRAFT_ITEMPROP_ARRAY, i, 0);
                    continue;
                }
                sTemp = Get2DACache(sFile, "AlignGE", i);
                if((sTemp == "G" && GetAlignmentGoodEvil(oPC) != ALIGNMENT_GOOD) ||
                    (sTemp == "E" && GetAlignmentGoodEvil(oPC) != ALIGNMENT_EVIL) ||
                    (sTemp == "N" && GetAlignmentGoodEvil(oPC) != ALIGNMENT_NEUTRAL))
                {
                    array_set_int(oPC, PRC_CRAFT_ITEMPROP_ARRAY, i, 0);
                    continue;
                }
                sTemp = Get2DACache(sFile, "AlignLC", i);
                if((sTemp == "L" && GetAlignmentLawChaos(oPC) != ALIGNMENT_LAWFUL) ||
                    (sTemp == "C" && GetAlignmentLawChaos(oPC) != ALIGNMENT_CHAOTIC) ||
                    (sTemp == "N" && GetAlignmentLawChaos(oPC) != ALIGNMENT_NEUTRAL))
                {
                    array_set_int(oPC, PRC_CRAFT_ITEMPROP_ARRAY, i, 0);
                    continue;
                }
            }
        }
    }
    return strTemp;
}

//Returns an int depending on the weapon type
//  returns 0 if not a weapon
int GetWeaponType(int nBaseItem)
{
    int nFeat = StringToInt(Get2DACache("baseitems", "ReqFeat0", nBaseItem));
    switch(nFeat)
    {
        case 44: return PRC_CRAFT_EXOTIC_WEAPON; break;
        case 45: return PRC_CRAFT_MARTIAL_WEAPON; break;
        case 46: return PRC_CRAFT_SIMPLE_WEAPON; break;
        default: return 0; break;
    }
    return 0;
}

//Hardcoding of some adjustments
itemproperty PropSpecialHandling(object oItem, string sFile, int nLine, int nIndex)
{
    itemproperty ip;
    int nTemp;
    string sTemp = Get2DACache(sFile, "Type" + IntToString(nIndex), nLine);
    if(sTemp == "") return ip;
    int nType = StringToInt(sTemp);
    int nSubType = StringToInt(Get2DACache(sFile, "SubType" + IntToString(nIndex), nLine));
    int nCostTableValue = StringToInt(Get2DACache(sFile, "CostTableValue" + IntToString(nIndex), nLine));
    int nParam1Value = StringToInt(Get2DACache(sFile, "Param1Value" + IntToString(nIndex), nLine));
    int nBase = GetBaseItemType(oItem);
    if(StringToInt(Get2DACache(sFile, "Special", nLine)))
    {
        if(sFile == "craft_armour")
        {
            if(nType == ITEM_PROPERTY_SKILL_BONUS && SkillHasACPenalty(nSubType))
                nCostTableValue += GetArmourCheckPenaltyReduction(oItem);
        }
        else if(sFile == "craft_weapon")
        {
            switch(nLine)
            {
                case 25:
                case 26:
                {
                    nTemp = GetLocalInt(GetItemPossessor(oItem), PRC_CRAFT_SPECIAL_BANE_RACE);
                    if(nIndex == 1)
                    {
                        nSubType = nTemp;
                        nTemp = StringToInt(Get2DACache("baseitems", "WeaponType", nBase));
                        switch(nTemp)
                        {
                            case 1: nParam1Value = IP_CONST_DAMAGETYPE_PIERCING; break;
                            case 2:
                            case 5: nParam1Value = IP_CONST_DAMAGETYPE_BLUDGEONING; break;
                            case 3:
                            case 4: nParam1Value = IP_CONST_DAMAGETYPE_SLASHING; break;
                        }
                    }
                    else if(nIndex == 2)
                        nCostTableValue += IPGetWeaponEnhancementBonus(oItem);
                    else if(nIndex == 3)
                        nParam1Value = nTemp;
                    break;
                }
            }
            if(nType == ITEM_PROPERTY_ENHANCEMENT_BONUS &&
                StringToInt(Get2DACache("prc_craft_gen_it", "Type", nBase)) == PRC_CRAFT_ITEM_TYPE_AMMO)
            {
                nType = ITEM_PROPERTY_DAMAGE_BONUS;
                nSubType = (nBase == BASE_ITEM_BULLET) ? DAMAGE_TYPE_BLUDGEONING : DAMAGE_TYPE_PIERCING;
            }
        }
    }

    return ConstructIP(nType, nSubType, nCostTableValue, nParam1Value);
}

void ApplyItemProps(object oItem, string sFile, int nLine)
{
    int i;
    itemproperty ip;
    for(i == 1; i <= 3; i++)
    {
        ip = PropSpecialHandling(oItem, sFile, nLine, i);
        if(GetIsItemPropertyValid(ip))
            IPSafeAddItemProperty(oItem, ip, 0.0, X2_IP_ADDPROP_POLICY_REPLACE_EXISTING);
    }
}

//Partly ripped off the lexicon :P
int GetItemBaseAC(object oItem)
{
    int nAC = -1;
    int nBase = GetBaseItemType(oItem);
    int bID = GetIdentified(oItem);
    if(bID) SetIdentified(oItem, FALSE);

    if(nBase == BASE_ITEM_ARMOR)
    {
        switch(GetGoldPieceValue(oItem))
        {
            case    1: nAC = 0; break; // None
            case    5: nAC = 1; break; // Padded
            case   10: nAC = 2; break; // Leather
            case   15: nAC = 3; break; // Studded Leather / Hide
            case  100: nAC = 4; break; // Chain Shirt / Scale Mail
            case  150: nAC = 5; break; // Chainmail / Breastplate
            case  200: nAC = 6; break; // Splint Mail / Banded Mail
            case  600: nAC = 7; break; // Half-Plate
            case 1500: nAC = 8; break; // Full Plate
        }
    }
    else if(nBase == BASE_ITEM_SMALLSHIELD)
        nAC = 1;
    else if(nBase == BASE_ITEM_LARGESHIELD)
        nAC = 2;
    else if(nBase == BASE_ITEM_TOWERSHIELD)
        nAC = 3;

    if(bID) SetIdentified(oItem, TRUE);
    return nAC;
}

int GetItemArmourCheckPenalty(object oItem)
{
    int nBase = GetBaseItemType(oItem);
    int nPenalty = 0;
    if(nBase == BASE_ITEM_SMALLSHIELD)
        nPenalty = 1;
    else if(nBase == BASE_ITEM_LARGESHIELD)
        nPenalty = 2;
    else if(nBase == BASE_ITEM_TOWERSHIELD)
        nPenalty = 10;
    else if(nBase == BASE_ITEM_ARMOR)
    {
        switch(GetItemBaseAC(oItem))
        {
            case 3: nPenalty = 1; break;
            case 4: nPenalty = 2; break;
            case 5: nPenalty = 5; break;
            case 6: nPenalty = 7; break;
            case 7: nPenalty = 7; break;
            case 8: nPenalty = 8; break;
        }
    }
    return nPenalty;
}

string GetCrafting2DA(object oItem)
{
    int nBase = GetBaseItemType(oItem);
    if(((nBase == BASE_ITEM_ARMOR) ||
        (nBase == BASE_ITEM_SMALLSHIELD) ||
        (nBase == BASE_ITEM_LARGESHIELD) ||
        (nBase == BASE_ITEM_TOWERSHIELD))
        )
    {
        if(GetItemBaseAC(oItem) == 0) return "craft_wondrous";
        return "craft_armour";
    }

    if(GetWeaponType(nBase) ||
        (nBase == BASE_ITEM_ARROW) ||
        (nBase == BASE_ITEM_BOLT) ||
        (nBase == BASE_ITEM_BULLET)
        )
        return "craft_weapon";
    if(nBase == BASE_ITEM_RING) return "craft_ring";
    if(((nBase == BASE_ITEM_HELMET) ||
        (nBase == BASE_ITEM_AMULET) ||
        (nBase == BASE_ITEM_BELT) ||
        (nBase == BASE_ITEM_BOOTS) ||
        (nBase == BASE_ITEM_GLOVES) ||
        (nBase == BASE_ITEM_BRACER) ||
        (nBase == BASE_ITEM_CLOAK))
        )
        return "craft_wondrous";

    //restrict to castspell itemprops?
    /*
    if(nBase == BASE_ITEM_MAGICROD) return FEAT_CRAFT_ROD;
    if(nBase == BASE_ITEM_MAGICSTAFF) return FEAT_CRAFT_STAFF;
    if(nBase == BASE_ITEM_MAGICWAND) return FEAT_CRAFT_WAND;
    */
    return "";
}

int GetCraftingFeat(object oItem)
{
    int nBase = GetBaseItemType(oItem);
    if(((nBase == BASE_ITEM_ARMOR) ||
        (nBase == BASE_ITEM_SMALLSHIELD) ||
        (nBase == BASE_ITEM_LARGESHIELD) ||
        (nBase == BASE_ITEM_TOWERSHIELD)) ||
        (GetWeaponType(nBase) ||
        (nBase == BASE_ITEM_ARROW) ||
        (nBase == BASE_ITEM_BOLT) ||
        (nBase == BASE_ITEM_BULLET)
        )
        )
    {
        if(GetItemBaseAC(oItem) == 0) return FEAT_CRAFT_WONDROUS;
        return FEAT_CRAFT_ARMS_ARMOR;
    }

    if(nBase == BASE_ITEM_RING) return FEAT_FORGE_RING;
    if(nBase == BASE_ITEM_MAGICROD) return FEAT_CRAFT_ROD;
    if(nBase == BASE_ITEM_MAGICSTAFF) return FEAT_CRAFT_STAFF;
    if(nBase == BASE_ITEM_MAGICWAND) return FEAT_CRAFT_WAND;

    if(((nBase == BASE_ITEM_HELMET) ||
        (nBase == BASE_ITEM_AMULET) ||
        (nBase == BASE_ITEM_BELT) ||
        (nBase == BASE_ITEM_BOOTS) ||
        (nBase == BASE_ITEM_GLOVES) ||
        (nBase == BASE_ITEM_BRACER) ||
        (nBase == BASE_ITEM_CLOAK))
        )
    return FEAT_CRAFT_WONDROUS;

    return -1;
}

int GetEpicCraftingFeat(int nFeat)
{
    switch(nFeat)
    {
        case FEAT_CRAFT_WONDROUS: return FEAT_CRAFT_EPIC_WONDROUS_ITEM;
        case FEAT_CRAFT_ARMS_ARMOR: return FEAT_CRAFT_EPIC_MAGIC_ARMS_ARMOR;
        case FEAT_CRAFT_ROD: return FEAT_CRAFT_EPIC_ROD;
        case FEAT_CRAFT_STAFF: return FEAT_CRAFT_EPIC_STAFF;
        case FEAT_FORGE_RING: return FEAT_FORGE_EPIC_RING;
    }
    return -1;
}

//Returns whether the item can be made of a material
int CheckCraftingMaterial(int nBaseItem, int nMaterial, int nBaseAC = -1)
{
    if(nBaseItem == BASE_ITEM_WHIP) return (nMaterial == PRC_CRAFT_MATERIAL_LEATHER);

    if((nBaseItem == BASE_ITEM_SMALLSHIELD) ||
        (nBaseItem == BASE_ITEM_LARGESHIELD) ||
        (nBaseItem == BASE_ITEM_TOWERSHIELD)
        )
        return ((nMaterial == PRC_CRAFT_MATERIAL_METAL) || (nMaterial == PRC_CRAFT_MATERIAL_WOOD));

    if(nBaseItem == BASE_ITEM_ARMOR)
    {
        /*
        if(nBaseAC >= 0 && nBaseAC <= 1) return (nMaterial == PRC_CRAFT_MATERIAL_CLOTH);
        if(nBaseAC >= 2 && nBaseAC <= 3) return (nMaterial == PRC_CRAFT_MATERIAL_LEATHER);
        else return (nMaterial == PRC_CRAFT_MATERIAL_METAL);
        */
        return ((nMaterial == PRC_CRAFT_MATERIAL_METAL) || (nMaterial == PRC_CRAFT_MATERIAL_LEATHER));
    }
    //since you can't make adamantine weapons at the moment
    if((nBaseItem == BASE_ITEM_HEAVYCROSSBOW) ||
        (nBaseItem == BASE_ITEM_LIGHTCROSSBOW) ||
        (nBaseItem == BASE_ITEM_LONGBOW) ||
        (nBaseItem == BASE_ITEM_SHORTBOW) ||
        (nBaseItem == BASE_ITEM_QUARTERSTAFF) ||
        (nBaseItem == BASE_ITEM_CLUB) ||
        (nBaseItem == 304) ||   //nunchaku
        (nBaseItem == BASE_ITEM_SCYTHE) ||
        (nBaseItem == BASE_ITEM_SHORTSPEAR) ||
        (nBaseItem == BASE_ITEM_TRIDENT) ||
        (nBaseItem == BASE_ITEM_HALBERD) ||
        (nBaseItem == 322) ||   //goad
        (nBaseItem == BASE_ITEM_CLUB)
        )
    {
        return (nMaterial == PRC_CRAFT_MATERIAL_WOOD);
    }
    //assume stuff is made of metal (most of it is)
    return (nMaterial == PRC_CRAFT_MATERIAL_METAL);
}

//Returns the DC for crafting a particular item
int GetCraftingDC(object oItem)
{
    int nDC = 0;
    int nBase = GetBaseItemType(oItem);
    int nType = GetWeaponType(nBase);
    if(((nBase == BASE_ITEM_ARMOR) ||
        (nBase == BASE_ITEM_SMALLSHIELD) ||
        (nBase == BASE_ITEM_LARGESHIELD) ||
        (nBase == BASE_ITEM_TOWERSHIELD))
        )
    {
        nDC = 10 + GetItemBaseAC(oItem);
    }
    else if(((nBase == BASE_ITEM_HEAVYCROSSBOW) ||
        (nBase == BASE_ITEM_LIGHTCROSSBOW))
        )
    {
        nDC = 15;
    }
    else if(((nBase == BASE_ITEM_LONGBOW) ||
        (nBase == BASE_ITEM_SHORTBOW))
        )
    {
        nDC = 12;
        itemproperty ip = GetFirstItemProperty(oItem);
        while(GetIsItemPropertyValid(ip))
        {
            if(GetItemPropertyType(ip) == ITEM_PROPERTY_MIGHTY)
            {
                nDC = 15 + 2 * GetItemPropertyCostTableValue(ip);
                break;
            }
            ip = GetNextItemProperty(oItem);
        }
    }
    else if(nType == PRC_CRAFT_SIMPLE_WEAPON)
        nDC = 12;
    else if(nType == PRC_CRAFT_MARTIAL_WEAPON)
        nDC = 15;
    else if(nType == PRC_CRAFT_EXOTIC_WEAPON)
        nDC = 18;
    return nDC;
}

//Applies Masterwork properties to oItem
void MakeMasterwork(object oItem)
{
    if(GetPlotFlag(oItem)) return;  //sanity check
    int nBase = GetBaseItemType(oItem);
    if((nBase == BASE_ITEM_ARMOR) ||
        (nBase == BASE_ITEM_SMALLSHIELD) ||
        (nBase == BASE_ITEM_LARGESHIELD) ||
        (nBase == BASE_ITEM_TOWERSHIELD)
        )
    {
        //no armour check penalty here
        if(GetItemArmourCheckPenalty(oItem) == 0) return;

        itemproperty ip1 = ConstructIP(ITEM_PROPERTY_SKILL_BONUS, SKILL_HIDE, 1);
        itemproperty ip2 = ConstructIP(ITEM_PROPERTY_SKILL_BONUS, SKILL_MOVE_SILENTLY, 1);
        itemproperty ip3 = ConstructIP(ITEM_PROPERTY_SKILL_BONUS, SKILL_PARRY, 1);
        itemproperty ip4 = ConstructIP(ITEM_PROPERTY_SKILL_BONUS, SKILL_PICK_POCKET, 1);
        itemproperty ip5 = ConstructIP(ITEM_PROPERTY_SKILL_BONUS, SKILL_SET_TRAP, 1);
        itemproperty ip6 = ConstructIP(ITEM_PROPERTY_SKILL_BONUS, SKILL_TUMBLE, 1);
        itemproperty ip7 = ConstructIP(ITEM_PROPERTY_SKILL_BONUS, SKILL_JUMP, 1);
        IPSafeAddItemProperty(oItem, ip1, 0.0, X2_IP_ADDPROP_POLICY_REPLACE_EXISTING);
        IPSafeAddItemProperty(oItem, ip2, 0.0, X2_IP_ADDPROP_POLICY_REPLACE_EXISTING);
        IPSafeAddItemProperty(oItem, ip3, 0.0, X2_IP_ADDPROP_POLICY_REPLACE_EXISTING);
        IPSafeAddItemProperty(oItem, ip4, 0.0, X2_IP_ADDPROP_POLICY_REPLACE_EXISTING);
        IPSafeAddItemProperty(oItem, ip5, 0.0, X2_IP_ADDPROP_POLICY_REPLACE_EXISTING);
        IPSafeAddItemProperty(oItem, ip6, 0.0, X2_IP_ADDPROP_POLICY_REPLACE_EXISTING);
        IPSafeAddItemProperty(oItem, ip7, 0.0, X2_IP_ADDPROP_POLICY_REPLACE_EXISTING);
    }
    else if(GetWeaponType(nBase))
    {
        itemproperty ip1 = ConstructIP(ITEM_PROPERTY_ATTACK_BONUS, 0, 1);
        IPSafeAddItemProperty(oItem, ip1, 0.0, X2_IP_ADDPROP_POLICY_KEEP_EXISTING);
    }
    else if(StringToInt(Get2DACache("prc_craft_gen_it", "Type", nBase)) == PRC_CRAFT_ITEM_TYPE_AMMO)
    {
        /*
        int nDamageType = (nBase == BASE_ITEM_BULLET) ? DAMAGE_TYPE_BLUDGEONING : DAMAGE_TYPE_PIERCING;
        itemproperty ip1 = ConstructIP(ITEM_PROPERTY_DAMAGE_BONUS, nDamageType, IP_CONST_DAMAGEBONUS_1);
        */
        itemproperty ip1 = ConstructIP(ITEM_PROPERTY_ATTACK_BONUS, 0, 1);
        IPSafeAddItemProperty(oItem, ip1, 0.0, X2_IP_ADDPROP_POLICY_KEEP_EXISTING);
    }
    else
        return;
}

void MakeAdamantine(object oItem)
{
    if(GetPlotFlag(oItem)) return;  //sanity check
    if(GetBaseItemType(oItem) == BASE_ITEM_ARMOR)
    {
        int nBonus = 0;
        switch(GetItemBaseAC(oItem))
        {
            case 1:
            case 2:
            case 3: nBonus = IP_CONST_DAMAGERESIST_1; break;
            case 4:
            case 5: nBonus = IP_CONST_DAMAGERESIST_2; break;
            case 6:
            case 7:
            case 8: nBonus = IP_CONST_DAMAGERESIST_3; break;
        }
        if(nBonus)
        {
            itemproperty ip1 = ConstructIP(ITEM_PROPERTY_DAMAGE_RESISTANCE, IP_CONST_DAMAGETYPE_BLUDGEONING, nBonus);
            itemproperty ip2 = ConstructIP(ITEM_PROPERTY_DAMAGE_RESISTANCE, IP_CONST_DAMAGETYPE_PIERCING, nBonus);
            itemproperty ip3 = ConstructIP(ITEM_PROPERTY_DAMAGE_RESISTANCE, IP_CONST_DAMAGETYPE_SLASHING, nBonus);
            IPSafeAddItemProperty(oItem, ip1, 0.0, X2_IP_ADDPROP_POLICY_REPLACE_EXISTING);
            IPSafeAddItemProperty(oItem, ip2, 0.0, X2_IP_ADDPROP_POLICY_REPLACE_EXISTING);
            IPSafeAddItemProperty(oItem, ip3, 0.0, X2_IP_ADDPROP_POLICY_REPLACE_EXISTING);
        }
    }
}

void MakeDarkwood(object oItem)
{
    if(GetPlotFlag(oItem)) return;  //sanity check
    itemproperty ip = ConstructIP(ITEM_PROPERTY_BASE_ITEM_WEIGHT_REDUCTION, 0, IP_CONST_REDUCEDWEIGHT_50_PERCENT);
    IPSafeAddItemProperty(oItem, ip, 0.0, X2_IP_ADDPROP_POLICY_KEEP_EXISTING);
    int nBase = GetBaseItemType(oItem);
    if(((nBase == BASE_ITEM_SMALLSHIELD) ||
        (nBase == BASE_ITEM_LARGESHIELD) ||
        (nBase == BASE_ITEM_TOWERSHIELD))
        )
    {
        int nBonus = 2;
        if(nBase == BASE_ITEM_SMALLSHIELD) nBonus = 1;
        itemproperty ip1 = ConstructIP(ITEM_PROPERTY_SKILL_BONUS, SKILL_HIDE, nBonus);
        itemproperty ip2 = ConstructIP(ITEM_PROPERTY_SKILL_BONUS, SKILL_MOVE_SILENTLY, nBonus);
        itemproperty ip3 = ConstructIP(ITEM_PROPERTY_SKILL_BONUS, SKILL_PARRY, nBonus);
        itemproperty ip4 = ConstructIP(ITEM_PROPERTY_SKILL_BONUS, SKILL_PICK_POCKET, nBonus);
        itemproperty ip5 = ConstructIP(ITEM_PROPERTY_SKILL_BONUS, SKILL_SET_TRAP, nBonus);
        itemproperty ip6 = ConstructIP(ITEM_PROPERTY_SKILL_BONUS, SKILL_TUMBLE, nBonus);
        itemproperty ip7 = ConstructIP(ITEM_PROPERTY_SKILL_BONUS, SKILL_JUMP, nBonus);
        IPSafeAddItemProperty(oItem, ip1, 0.0, X2_IP_ADDPROP_POLICY_REPLACE_EXISTING);
        IPSafeAddItemProperty(oItem, ip2, 0.0, X2_IP_ADDPROP_POLICY_REPLACE_EXISTING);
        IPSafeAddItemProperty(oItem, ip3, 0.0, X2_IP_ADDPROP_POLICY_REPLACE_EXISTING);
        IPSafeAddItemProperty(oItem, ip4, 0.0, X2_IP_ADDPROP_POLICY_REPLACE_EXISTING);
        IPSafeAddItemProperty(oItem, ip5, 0.0, X2_IP_ADDPROP_POLICY_REPLACE_EXISTING);
        IPSafeAddItemProperty(oItem, ip6, 0.0, X2_IP_ADDPROP_POLICY_REPLACE_EXISTING);
        IPSafeAddItemProperty(oItem, ip7, 0.0, X2_IP_ADDPROP_POLICY_REPLACE_EXISTING);
    }
}

void MakeDragonhide(object oItem)
{
    //Does nothing so far
}

void MakeMithral(object oItem)
{
    if(GetPlotFlag(oItem)) return;  //sanity check
    itemproperty ip = ConstructIP(ITEM_PROPERTY_BASE_ITEM_WEIGHT_REDUCTION, 0, IP_CONST_REDUCEDWEIGHT_50_PERCENT);
    IPSafeAddItemProperty(oItem, ip, 0.0, X2_IP_ADDPROP_POLICY_REPLACE_EXISTING);
    int nBase = GetBaseItemType(oItem);
    if(((nBase == BASE_ITEM_ARMOR) ||
        (nBase == BASE_ITEM_SMALLSHIELD) ||
        (nBase == BASE_ITEM_LARGESHIELD) ||
        (nBase == BASE_ITEM_TOWERSHIELD))
        )
    {
        int nBonus = 3;
        int nPenalty = GetItemArmourCheckPenalty(oItem);
        if(nBonus > nPenalty) nBonus = nPenalty;
        itemproperty ip1 = ConstructIP(ITEM_PROPERTY_SKILL_BONUS, SKILL_HIDE, nBonus);
        itemproperty ip2 = ConstructIP(ITEM_PROPERTY_SKILL_BONUS, SKILL_MOVE_SILENTLY, nBonus);
        itemproperty ip3 = ConstructIP(ITEM_PROPERTY_SKILL_BONUS, SKILL_PARRY, nBonus);
        itemproperty ip4 = ConstructIP(ITEM_PROPERTY_SKILL_BONUS, SKILL_PICK_POCKET, nBonus);
        itemproperty ip5 = ConstructIP(ITEM_PROPERTY_SKILL_BONUS, SKILL_SET_TRAP, nBonus);
        itemproperty ip6 = ConstructIP(ITEM_PROPERTY_SKILL_BONUS, SKILL_TUMBLE, nBonus);
        itemproperty ip7 = ConstructIP(ITEM_PROPERTY_SKILL_BONUS, SKILL_JUMP, nBonus);
        itemproperty ip8 = ConstructIP(ITEM_PROPERTY_ARCANE_SPELL_FAILURE, 0, IP_CONST_ARCANE_SPELL_FAILURE_MINUS_10_PERCENT);
        if(GetItemBaseAC(oItem) == 1)
            ip8 = ConstructIP(ITEM_PROPERTY_ARCANE_SPELL_FAILURE, 0, IP_CONST_ARCANE_SPELL_FAILURE_MINUS_5_PERCENT);
        IPSafeAddItemProperty(oItem, ip1, 0.0, X2_IP_ADDPROP_POLICY_REPLACE_EXISTING);
        IPSafeAddItemProperty(oItem, ip2, 0.0, X2_IP_ADDPROP_POLICY_REPLACE_EXISTING);
        IPSafeAddItemProperty(oItem, ip3, 0.0, X2_IP_ADDPROP_POLICY_REPLACE_EXISTING);
        IPSafeAddItemProperty(oItem, ip4, 0.0, X2_IP_ADDPROP_POLICY_REPLACE_EXISTING);
        IPSafeAddItemProperty(oItem, ip5, 0.0, X2_IP_ADDPROP_POLICY_REPLACE_EXISTING);
        IPSafeAddItemProperty(oItem, ip6, 0.0, X2_IP_ADDPROP_POLICY_REPLACE_EXISTING);
        IPSafeAddItemProperty(oItem, ip7, 0.0, X2_IP_ADDPROP_POLICY_REPLACE_EXISTING);
        IPSafeAddItemProperty(oItem, ip8, 0.0, X2_IP_ADDPROP_POLICY_REPLACE_EXISTING);
    }
}

void MakeColdIron(object oItem)
{
    //Does nothing so far
}

void MakeSilver(object oItem)
{
    //Does nothing so far
}

void MakeMundaneCrystal(object oItem)
{
    //Does nothing so far
}

void MakeDeepCrystal(object oItem)
{
    //Does nothing so far
}

//Creates an item on oOwner, from the baseitemtype and base AC (for armour)
object CreateStandardItem(object oOwner, int nBaseItemType, int nBaseAC = -1)
{
    string sResRef = Get2DACache("prc_craft_gen_it", "Blueprint", nBaseItemType);
    int nStackSize = StringToInt(Get2DACache("baseitems", "ILRStackSize", nBaseItemType));
    if(nBaseItemType == BASE_ITEM_ARMOR)
    {
        switch(nBaseAC)
        {
            case 0: sResRef = "x2_cloth008"; break;
            case 1: sResRef = "nw_aarcl009"; break;
            case 2: sResRef = "nw_aarcl001"; break;
            case 3: sResRef = "nw_aarcl002"; break;
            case 4: sResRef = "nw_aarcl012"; break;
            case 5: sResRef = "nw_aarcl004"; break;
            case 6: sResRef = "nw_aarcl005"; break;
            case 7: sResRef = "nw_aarcl006"; break;
            case 8: sResRef = "nw_aarcl007"; break;
        }
    }

    return CreateItemOnObject(sResRef, oOwner, nStackSize);
}

int GetEnhancementBaseCost(object oItem)
{
    string sFile = GetCrafting2DA(oItem);
    if(sFile == "craft_armour") return 1000;
    if(sFile == "craft_weapon") return 2000;

    return 0;
}

//returns pnp market price of an item
int GetPnPItemCost(struct itemvars strTemp)
{
    int nTemp, nMaterial, nEnhancement;
    int nType = GetBaseItemType(strTemp.item);
    SetIdentified(strTemp.item, FALSE);
    int nMultiplyer = StringToInt(Get2DACache("baseitems", "ItemMultiplier", nType));
    if(nMultiplyer < 1) nMultiplyer = 1;
    nTemp = GetGoldPieceValue(strTemp.item) / nMultiplyer;
    SetIdentified(strTemp.item, TRUE);
    int nFlag = StringToInt(Get2DACache("prc_craft_gen_it", "Type", nType));
    int nAdd = 0;
    string sMaterial = GetStringLeft(GetTag(strTemp.item), 3);
    nMaterial = StringToInt(sMaterial);
    if(GetMaterialString(nMaterial) != sMaterial)
        nMaterial = 0;
    if(nMaterial & PRC_CRAFT_FLAG_MASTERWORK)
    {
        switch(nFlag)
        {
            case PRC_CRAFT_ITEM_TYPE_WEAPON: nAdd = 300; break;
            case PRC_CRAFT_ITEM_TYPE_ARMOUR: nAdd = 150; break;
            case PRC_CRAFT_ITEM_TYPE_SHIELD: nAdd = 150; break;
            case PRC_CRAFT_ITEM_TYPE_AMMO: nAdd = 594; break;
        }
    }
    if(nMaterial & PRC_CRAFT_FLAG_ADAMANTINE)
    {
        switch(GetItemBaseAC(strTemp.item))
        {
            case 1:
            case 2:
            case 3: nAdd = 5000; break;
            case 4:
            case 5: nAdd = 10000; break;
            case 6:
            case 7:
            case 8: nAdd = 15000; break;
        }
    }
    if(nMaterial & PRC_CRAFT_FLAG_DARKWOOD)
    {
        nAdd += StringToInt(Get2DACache("baseitems", "TenthLBS", nType));
    }
    if(nMaterial & PRC_CRAFT_FLAG_DRAGONHIDE)
    {
        nAdd += nAdd + nTemp;
    }
    if(nMaterial & PRC_CRAFT_FLAG_MITHRAL)
    {
        if(nType == BASE_ITEM_ARMOR)
        {
            switch(GetItemBaseAC(strTemp.item))
            {
                case 1:
                case 2:
                case 3: nAdd = 1000; break;
                case 4:
                case 5: nAdd = 4000; break;
                case 6:
                case 7:
                case 8: nAdd = 9000; break;
            }
        }
        else
        {
            switch(nFlag)
            {
                case PRC_CRAFT_ITEM_TYPE_WEAPON: nAdd = 50 * StringToInt(Get2DACache("baseitems", "TenthLBS", nType)); break;
                case PRC_CRAFT_ITEM_TYPE_SHIELD: nAdd = 1000; break;
            }
        }
    }
    if(nMaterial & PRC_CRAFT_FLAG_COLD_IRON)
    {
        //not implemented
    }
    if(nMaterial & PRC_CRAFT_FLAG_ALCHEMICAL_SILVER)
    {
        //not implemented
    }
    if(nMaterial & PRC_CRAFT_FLAG_MUNDANE_CRYSTAL)
    {
        //not implemented
    }
    if(nMaterial & PRC_CRAFT_FLAG_DEEP_CRYSTAL)
    {
        //not implemented
    }
    nTemp += nAdd;
    nEnhancement = GetEnhancementBaseCost(strTemp.item) * strTemp.enhancement * strTemp.enhancement;
    if(strTemp.epic) nEnhancement *= 10;
    nTemp += nEnhancement + strTemp.additionalcost;

    int nScale = GetPRCSwitch(PRC_CRAFTING_COST_SCALE);
    if(nScale > 0)
    {   //you're not getting away with negative values that easily :P
        nTemp = FloatToInt(IntToFloat(nTemp) * IntToFloat(nScale) / 100.0);
    }
    if(StringToInt(Get2DACache("baseitems", "Stacking", nType)) > 1)
        nTemp = FloatToInt(IntToFloat(nTemp) * IntToFloat(GetItemStackSize(strTemp.item))/ 50.0);
    if(nTemp < 1) nTemp = 1;

    return nTemp;
}

int GetPnPItemXPCost(struct itemvars strTemp, int nCost)
{
    int nXP = nCost / 25;
    if(strTemp.epic) nXP = (nCost / 100) + 10000;
    return nXP;
}

//Creates an item for oPC of nBaseItemType, made of nMaterial
object MakeMyItem(object oPC, int nBaseItemType, int nBaseAC = -1, int nMaterial = 0, int nMighty = -1)
{
    object oTemp = CreateStandardItem(GetTempCraftChest(), nBaseItemType, nBaseAC);
    string sMaterial = GetMaterialString(nMaterial);
    string sTag = sMaterial + GetUniqueID() + PRC_CRAFT_UID_SUFFIX;
    object oChest = GetCraftChest();
    while(GetIsObjectValid(GetItemPossessedBy(oChest, sTag)))//make sure there aren't any tag conflicts
        sTag = sMaterial + GetUniqueID() + PRC_CRAFT_UID_SUFFIX;
    object oNew = CopyObject(oTemp, GetLocation(oChest), oChest, sTag);
    string sPrefix = "";
    if(nMighty)
    {
        itemproperty ip1 = ConstructIP(ITEM_PROPERTY_MIGHTY, 0, nMighty);
        IPSafeAddItemProperty(oNew, ip1, 0.0, X2_IP_ADDPROP_POLICY_REPLACE_EXISTING);
    }
    DestroyObject(oTemp, 0.1);
    if(nMaterial & PRC_CRAFT_FLAG_MASTERWORK)   //name prefix will be overridden by materials
    {
        sPrefix = "Masterwork ";
        MakeMasterwork(oNew);
    }
    if(nMaterial & PRC_CRAFT_FLAG_ADAMANTINE)   //assumes only 1 material at a time
    {
        sPrefix = "Adamantine ";
        MakeAdamantine(oNew);
    }
    if(nMaterial & PRC_CRAFT_FLAG_DARKWOOD)
    {
        sPrefix = "Darkwood ";
        MakeDarkwood(oNew);
    }
    if(nMaterial & PRC_CRAFT_FLAG_DRAGONHIDE)
    {
        sPrefix = "Dragonhide ";
        MakeDragonhide(oNew);
    }
    if(nMaterial & PRC_CRAFT_FLAG_MITHRAL)
    {
        sPrefix = "Mithral ";
        MakeMithral(oNew);
    }
    if(nMaterial & PRC_CRAFT_FLAG_COLD_IRON)
    {
        sPrefix = "Cold Iron ";
        MakeColdIron(oNew);
    }
    if(nMaterial & PRC_CRAFT_FLAG_ALCHEMICAL_SILVER)
    {
        sPrefix = "Silver ";
        MakeSilver(oNew);
    }
    if(nMaterial & PRC_CRAFT_FLAG_MUNDANE_CRYSTAL)
    {
        sPrefix = "Crystal ";
        MakeMundaneCrystal(oNew);
    }
    if(nMaterial & PRC_CRAFT_FLAG_DEEP_CRYSTAL)
    {
        sPrefix = "Deep Crystal ";
        MakeDeepCrystal(oNew);
    }
    if(nMighty > 0) sPrefix += "Composite ";

    SetName(oNew, sPrefix + GetName(oNew));
    if((nBaseItemType == BASE_ITEM_ARMOR) && (nBaseAC == 0))
        SetName(oNew, "Robe");

    return oNew;
}

//Adds action highlight to a conversation string
string ActionString(string sString)
{
    return "<cþ>" + sString + "</c>";
}

//Inserts a space at the end of a string if the string
//  is not empty
string InsertSpaceAfterString(string sString)
{
    if(sString != "")
        return sString + " ";
    else return "";
}

string GetItemPropertyString(itemproperty ip)
{
    int nType = GetItemPropertyType(ip);
    if(nType == -1) return "";
    int nSubType = GetItemPropertySubType(ip);
    int nCostTable = GetItemPropertyCostTable(ip);
    int nCostTableValue = GetItemPropertyCostTableValue(ip);
    int nParam1 = GetItemPropertyParam1(ip);
    int nParam1Value = GetItemPropertyParam1Value(ip);
    string sDesc = InsertSpaceAfterString(
                GetStringByStrRef(StringToInt(Get2DACache("itempropdef", "GameStrRef", nType)))
                );
    string sSubType = Get2DACache("itempropdef", "SubTypeResRef", nType);
    sSubType = Get2DACache(sSubType, "Name", nSubType);
    if(sSubType != "")
        sDesc += InsertSpaceAfterString(GetStringByStrRef(StringToInt(sSubType)));
    string sCostTable = Get2DACache("itempropdef", "CostTableResRef", nType);
    sCostTable = Get2DACache("iprp_costtable", "Name", StringToInt(sCostTable));
    sCostTable = Get2DACache(sCostTable, "Name", nCostTableValue);
    if(sCostTable != "")
        sDesc += InsertSpaceAfterString(GetStringByStrRef(StringToInt(sCostTable)));
    string sParam1;
    if(nType == ITEM_PROPERTY_ON_HIT_PROPERTIES)    //Param1 depends on subtype
    {
        sParam1 = Get2DACache(Get2DACache("itempropdef", "SubTypeResRef", nType), "Param1ResRef", nSubType);
    }
    else
    {
        sParam1 = Get2DACache("itempropdef", "Param1ResRef", nType);
    }
    if(sParam1 != "")
    {
        sDesc += InsertSpaceAfterString(GetStringByStrRef(StringToInt(Get2DACache("iprp_paramtable", "Name", StringToInt(sParam1)))));
        sParam1 = Get2DACache("iprp_paramtable", "TableResRef", StringToInt(sParam1));
        sParam1 = Get2DACache(sParam1, "Name", nParam1Value);
        if(sParam1 != "")
            sDesc += InsertSpaceAfterString(GetStringByStrRef(StringToInt(sParam1)));
    }
    sDesc += "\n";

    return sDesc;
}

//Returns a string describing the item
string ItemStats(object oItem)
{
    string sDesc = GetName(oItem) +
                    "\n\n" +
                    GetStringByStrRef(StringToInt(Get2DACache("baseitems", "Name", GetBaseItemType(oItem)))) +
                    "\n\n";

    itemproperty ip = GetFirstItemProperty(oItem);
    while(GetIsItemPropertyValid(ip))
    {
        if(GetItemPropertyDurationType(ip) == DURATION_TYPE_PERMANENT)
        {
            sDesc += GetItemPropertyString(ip);
        }
        ip = GetNextItemProperty(oItem);
    }
    return sDesc;
}

//Returns TRUE if nBaseItem can have nItemProp
int ValidProperty(object oItem, int nItemProp)
{
    int nPropColumn = StringToInt(Get2DACache("baseitems", "PropColumn", GetBaseItemType(oItem)));
    string sPropCloumn = "";
    switch(nPropColumn)
    {
        case 0: sPropCloumn = "0_Melee"; break;
        case 1: sPropCloumn = "1_Ranged"; break;
        case 2: sPropCloumn = "2_Thrown"; break;
        case 3: sPropCloumn = "3_Staves"; break;
        case 4: sPropCloumn = "4_Rods"; break;
        case 5: sPropCloumn = "5_Ammo"; break;
        case 6: sPropCloumn = "6_Arm_Shld"; break;
        case 7: sPropCloumn = "7_Helm"; break;
        case 8: sPropCloumn = "8_Potions"; break;
        case 9: sPropCloumn = "9_Scrolls"; break;
        case 10: sPropCloumn = "10_Wands"; break;
        case 11: sPropCloumn = "11_Thieves"; break;
        case 12: sPropCloumn = "12_TrapKits"; break;
        case 13: sPropCloumn = "13_Hide"; break;
        case 14: sPropCloumn = "14_Claw"; break;
        case 15: sPropCloumn = "15_Misc_Uneq"; break;
        case 16: sPropCloumn = "16_Misc"; break;
        case 17: sPropCloumn = "17_No_Props"; break;
        case 18: sPropCloumn = "18_Containers"; break;
        case 19: sPropCloumn = "19_HealerKit"; break;
        case 20: sPropCloumn = "20_Torch"; break;
        case 21: sPropCloumn = "21_Glove"; break;
    }
    return(Get2DACache("itemprops", sPropCloumn, nItemProp) == "1");
}

//Makes an item property from values - total pain in the arse, need 1 per itemprop
itemproperty ConstructIP(int nType, int nSubTypeValue = 0, int nCostTableValue = 0, int nParam1Value = 0)
{
    itemproperty ip;
    switch(nType)
    {
        case ITEM_PROPERTY_ABILITY_BONUS:
        {
            ip = ItemPropertyAbilityBonus(nSubTypeValue, nCostTableValue);
            break;
        }
        case ITEM_PROPERTY_AC_BONUS:
        {
            ip = ItemPropertyACBonus(nCostTableValue);
            break;
        }
        case ITEM_PROPERTY_AC_BONUS_VS_ALIGNMENT_GROUP:
        {
            ip = ItemPropertyACBonusVsAlign(nSubTypeValue, nCostTableValue);
            break;
        }
        case ITEM_PROPERTY_AC_BONUS_VS_DAMAGE_TYPE:
        {
            ip = ItemPropertyACBonusVsDmgType(nSubTypeValue, nCostTableValue);
            break;
        }
        case ITEM_PROPERTY_AC_BONUS_VS_RACIAL_GROUP:
        {
            ip = ItemPropertyACBonusVsRace(nSubTypeValue, nCostTableValue);
            break;
        }
        case ITEM_PROPERTY_AC_BONUS_VS_SPECIFIC_ALIGNMENT:
        {
            ip = ItemPropertyACBonusVsSAlign(nSubTypeValue, nCostTableValue);
            break;
        }
        case ITEM_PROPERTY_ENHANCEMENT_BONUS:
        {
            ip = ItemPropertyEnhancementBonus(nCostTableValue);
            break;
        }
        case ITEM_PROPERTY_ENHANCEMENT_BONUS_VS_ALIGNMENT_GROUP:
        {
            ip = ItemPropertyEnhancementBonusVsAlign(nSubTypeValue, nCostTableValue);
            break;
        }
        case ITEM_PROPERTY_ENHANCEMENT_BONUS_VS_RACIAL_GROUP:
        {
            ip = ItemPropertyEnhancementBonusVsRace(nSubTypeValue, nCostTableValue);
            break;
        }
        case ITEM_PROPERTY_ENHANCEMENT_BONUS_VS_SPECIFIC_ALIGNEMENT:
        {
            ip = ItemPropertyEnhancementBonusVsSAlign(nSubTypeValue, nCostTableValue);
            break;
        }
        case ITEM_PROPERTY_DECREASED_ENHANCEMENT_MODIFIER:
        {
            ip = ItemPropertyEnhancementPenalty(nCostTableValue);
            break;
        }
        case ITEM_PROPERTY_BASE_ITEM_WEIGHT_REDUCTION:
        {
            ip = ItemPropertyWeightReduction(nCostTableValue);
            break;
        }
        case ITEM_PROPERTY_BONUS_FEAT:
        {
            ip = ItemPropertyBonusFeat(nSubTypeValue);
            break;
        }
        case ITEM_PROPERTY_BONUS_SPELL_SLOT_OF_LEVEL_N:
        {
            ip = ItemPropertyBonusLevelSpell(nSubTypeValue, nCostTableValue);
            break;
        }
        case ITEM_PROPERTY_CAST_SPELL:
        {
            ip = ItemPropertyCastSpell(nSubTypeValue, nCostTableValue);
            break;
        }
        case ITEM_PROPERTY_DAMAGE_BONUS:
        {
            ip = ItemPropertyDamageBonus(nSubTypeValue, nCostTableValue);
            break;
        }
        case ITEM_PROPERTY_DAMAGE_BONUS_VS_ALIGNMENT_GROUP:
        {
            ip = ItemPropertyDamageBonusVsAlign(nSubTypeValue, nParam1Value, nCostTableValue);
            break;
        }
        case ITEM_PROPERTY_DAMAGE_BONUS_VS_RACIAL_GROUP:
        {
            ip = ItemPropertyDamageBonusVsRace(nSubTypeValue, nParam1Value, nCostTableValue);
            break;
        }
        case ITEM_PROPERTY_DAMAGE_BONUS_VS_SPECIFIC_ALIGNMENT:
        {
            ip = ItemPropertyDamageBonusVsSAlign(nSubTypeValue, nCostTableValue, nParam1Value);
            break;
        }
        case ITEM_PROPERTY_IMMUNITY_DAMAGE_TYPE:
        {
            ip = ItemPropertyDamageImmunity(nSubTypeValue, nCostTableValue);
            break;
        }
        case ITEM_PROPERTY_DECREASED_DAMAGE:
        {
            ip = ItemPropertyDamagePenalty(nCostTableValue);
            break;
        }
        case ITEM_PROPERTY_DAMAGE_REDUCTION:
        {
            ip = ItemPropertyDamageReduction(nSubTypeValue, nCostTableValue);
            break;
        }
        case ITEM_PROPERTY_DAMAGE_RESISTANCE:
        {
            ip = ItemPropertyDamageResistance(nSubTypeValue, nCostTableValue);
            break;
        }
        case ITEM_PROPERTY_DAMAGE_VULNERABILITY:
        {
            ip = ItemPropertyDamageVulnerability(nSubTypeValue, nCostTableValue);
            break;
        }
        case ITEM_PROPERTY_DARKVISION:
        {
            ip = ItemPropertyDarkvision();
            break;
        }
        case ITEM_PROPERTY_DECREASED_ABILITY_SCORE:
        {
            ip = ItemPropertyDecreaseAbility(nSubTypeValue, nCostTableValue);
            break;
        }
        case ITEM_PROPERTY_DECREASED_AC:
        {
            ip = ItemPropertyDecreaseAC(nSubTypeValue, nCostTableValue);
            break;
        }
        case ITEM_PROPERTY_DECREASED_SKILL_MODIFIER:
        {
            ip = ItemPropertyDecreaseSkill(nSubTypeValue, nCostTableValue);
            break;
        }
        case ITEM_PROPERTY_ENHANCED_CONTAINER_REDUCED_WEIGHT:
        {
            ip = ItemPropertyWeightReduction(nCostTableValue);
            break;
        }
        case ITEM_PROPERTY_EXTRA_MELEE_DAMAGE_TYPE:
        {
            ip = ItemPropertyExtraMeleeDamageType(nSubTypeValue);
            break;
        }
        case ITEM_PROPERTY_EXTRA_RANGED_DAMAGE_TYPE:
        {
            ip = ItemPropertyExtraRangeDamageType(nSubTypeValue);
            break;
        }
        case ITEM_PROPERTY_HASTE:
        {
            ip = ItemPropertyHaste();
            break;
        }
        case ITEM_PROPERTY_HOLY_AVENGER:
        {
            ip = ItemPropertyHolyAvenger();
            break;
        }
        case ITEM_PROPERTY_IMMUNITY_MISCELLANEOUS:
        {
            ip = ItemPropertyImmunityMisc(nSubTypeValue);
            break;
        }
        case ITEM_PROPERTY_IMPROVED_EVASION:
        {
            ip = ItemPropertyImprovedEvasion();
            break;
        }
        case ITEM_PROPERTY_SPELL_RESISTANCE:
        {
            ip = ItemPropertyBonusSpellResistance(nCostTableValue);
            break;
        }
        case ITEM_PROPERTY_SAVING_THROW_BONUS:
        {
            ip = ItemPropertyBonusSavingThrowVsX(nSubTypeValue, nCostTableValue);
            break;
        }
        case ITEM_PROPERTY_SAVING_THROW_BONUS_SPECIFIC:
        {
            ip = ItemPropertyBonusSavingThrow(nSubTypeValue, nCostTableValue);
            break;
        }
        case ITEM_PROPERTY_KEEN:
        {
            ip = ItemPropertyKeen();
            break;
        }
        case ITEM_PROPERTY_LIGHT:
        {
            ip = ItemPropertyLight(nCostTableValue, nParam1Value);
            break;
        }
        case ITEM_PROPERTY_MIGHTY:
        {
            ip = ItemPropertyMaxRangeStrengthMod(nCostTableValue);
            break;
        }
        case ITEM_PROPERTY_NO_DAMAGE:
        {
            ip = ItemPropertyNoDamage();
            break;
        }
        case ITEM_PROPERTY_ON_HIT_PROPERTIES:
        {
            if(nParam1Value == -1)
                ip = ItemPropertyOnHitProps(nSubTypeValue, nCostTableValue);
            else
                ip = ItemPropertyOnHitProps(nSubTypeValue, nCostTableValue, nParam1Value);
            break;
        }
        case ITEM_PROPERTY_DECREASED_SAVING_THROWS:
        {
            ip = ItemPropertyReducedSavingThrowVsX(nSubTypeValue, nCostTableValue);
            break;
        }
        case ITEM_PROPERTY_DECREASED_SAVING_THROWS_SPECIFIC:
        {
            ip = ItemPropertyReducedSavingThrow(nSubTypeValue, nCostTableValue);
            break;
        }
        case ITEM_PROPERTY_REGENERATION:
        {
            ip = ItemPropertyRegeneration(nCostTableValue);
            break;
        }
        case ITEM_PROPERTY_SKILL_BONUS:
        {
            ip = ItemPropertySkillBonus(nSubTypeValue, nCostTableValue);
            break;
        }
        case ITEM_PROPERTY_IMMUNITY_SPECIFIC_SPELL:
        {
            ip = ItemPropertySpellImmunitySpecific(nCostTableValue);
            break;
        }
        case ITEM_PROPERTY_IMMUNITY_SPELL_SCHOOL:
        {
            ip = ItemPropertySpellImmunitySchool(nSubTypeValue);
            break;
        }
        case ITEM_PROPERTY_THIEVES_TOOLS:
        {
            ip = ItemPropertyThievesTools(nCostTableValue);
            break;
        }
        case ITEM_PROPERTY_ATTACK_BONUS:
        {
            ip = ItemPropertyAttackBonus(nCostTableValue);
            break;
        }
        case ITEM_PROPERTY_ATTACK_BONUS_VS_ALIGNMENT_GROUP:
        {
            ip = ItemPropertyAttackBonusVsAlign(nSubTypeValue, nCostTableValue);
            break;
        }
        case ITEM_PROPERTY_ATTACK_BONUS_VS_RACIAL_GROUP:
        {
            ip = ItemPropertyAttackBonusVsRace(nSubTypeValue, nCostTableValue);
            break;
        }
        case ITEM_PROPERTY_ATTACK_BONUS_VS_SPECIFIC_ALIGNMENT:
        {
            ip = ItemPropertyAttackBonusVsSAlign(nSubTypeValue, nCostTableValue);
            break;
        }
        case ITEM_PROPERTY_DECREASED_ATTACK_MODIFIER:
        {
            ip = ItemPropertyAttackPenalty(nCostTableValue);
            break;
        }
        case ITEM_PROPERTY_UNLIMITED_AMMUNITION:
        {   //IP_CONST_UNLIMITEDAMMO_* is costtablevalue, not subtype
            ip = ItemPropertyUnlimitedAmmo(nCostTableValue);
            break;
        }
        case ITEM_PROPERTY_USE_LIMITATION_ALIGNMENT_GROUP:
        {
            ip = ItemPropertyLimitUseByAlign(nSubTypeValue);
            break;
        }
        case ITEM_PROPERTY_USE_LIMITATION_CLASS:
        {
            ip = ItemPropertyLimitUseByClass(nSubTypeValue);
            break;
        }
        case ITEM_PROPERTY_USE_LIMITATION_RACIAL_TYPE:
        {
            ip = ItemPropertyLimitUseByRace(nSubTypeValue);
            break;
        }
        case ITEM_PROPERTY_USE_LIMITATION_SPECIFIC_ALIGNMENT:
        {
            ip = ItemPropertyLimitUseBySAlign(nSubTypeValue);
            break;
        }
        case ITEM_PROPERTY_REGENERATION_VAMPIRIC:
        {
            ip = ItemPropertyVampiricRegeneration(nCostTableValue);
            break;
        }
        case ITEM_PROPERTY_TRAP:
        {
            ip = ItemPropertyTrap(nSubTypeValue, nCostTableValue);
            break;
        }
        case ITEM_PROPERTY_TRUE_SEEING:
        {
            ip = ItemPropertyTrueSeeing();
            break;
        }
        case ITEM_PROPERTY_ON_MONSTER_HIT:
        {
            ip = ItemPropertyOnMonsterHitProperties(nSubTypeValue);
            break;
        }
        case ITEM_PROPERTY_TURN_RESISTANCE:
        {
            ip = ItemPropertyTurnResistance(nCostTableValue);
            break;
        }
        case ITEM_PROPERTY_MASSIVE_CRITICALS:
        {
            ip = ItemPropertyMassiveCritical(nCostTableValue);
            break;
        }
        case ITEM_PROPERTY_FREEDOM_OF_MOVEMENT:
        {
            ip = ItemPropertyFreeAction();
            break;
        }
        case ITEM_PROPERTY_MONSTER_DAMAGE:
        {
            ip = ItemPropertyMonsterDamage(nCostTableValue);
            break;
        }
        case ITEM_PROPERTY_IMMUNITY_SPELLS_BY_LEVEL:
        {
            ip = ItemPropertyImmunityToSpellLevel(nCostTableValue);
            break;
        }
        case ITEM_PROPERTY_SPECIAL_WALK:
        {
            ip = ItemPropertySpecialWalk(nSubTypeValue);
            break;
        }
        case ITEM_PROPERTY_HEALERS_KIT:
        {
            ip = ItemPropertyHealersKit(nCostTableValue);
            break;
        }
        case ITEM_PROPERTY_WEIGHT_INCREASE:
        {
            ip = ItemPropertyWeightIncrease(nParam1Value);
            break;
        }
        case ITEM_PROPERTY_ONHITCASTSPELL:
        {
            ip = ItemPropertyOnHitCastSpell(nSubTypeValue, nCostTableValue);
            break;
        }
        case ITEM_PROPERTY_VISUALEFFECT:
        {
            ip = ItemPropertyVisualEffect(nSubTypeValue);
            break;
        }
        case ITEM_PROPERTY_ARCANE_SPELL_FAILURE:
        {
            ip = ItemPropertyArcaneSpellFailure(nCostTableValue);
            break;
        }
        case ITEM_PROPERTY_USE_LIMITATION_ABILITY_SCORE:
        {
            ip = ItemPropertyLimitUseByAbility(nSubTypeValue, nCostTableValue);
            break;
        }
        case ITEM_PROPERTY_USE_LIMITATION_SKILL_RANKS:
        {
            ip = ItemPropertyLimitUseBySkill(nSubTypeValue, nCostTableValue);
            break;
        }
        case ITEM_PROPERTY_USE_LIMITATION_SPELL_LEVEL:
        {
            ip = ItemPropertyLimitUseBySpellcasting(nCostTableValue);
            break;
        }
        case ITEM_PROPERTY_USE_LIMITATION_ARCANE_SPELL_LEVEL:
        {
            ip = ItemPropertyLimitUseByArcaneSpellcasting(nCostTableValue);
            break;
        }
        case ITEM_PROPERTY_USE_LIMITATION_DIVINE_SPELL_LEVEL:
        {
            ip = ItemPropertyLimitUseByDivineSpellcasting(nCostTableValue);
            break;
        }
        case ITEM_PROPERTY_USE_LIMITATION_SNEAK_ATTACK:
        {
            ip = ItemPropertyLimitUseBySneakAttackDice(nCostTableValue);
            break;
        }
        case ITEM_PROPERTY_USE_LIMITATION_GENDER:
        {   //no Use Limitation: Gender function entry
            //ip = ItemPropertyAbilityBonus(nSubTypeValue);
            break;
        }
        case ITEM_PROPERTY_SPEED_INCREASE:
        {   //no Speed Increase function entry
            //ip = ItemPropertyAbilityBonus(nCostTableValue);
            break;
        }
        case ITEM_PROPERTY_SPEED_DECREASE:
        {   //no Speed Decrease function entry
            //ip = ItemPropertyAbilityBonus(nCostTableValue);
            break;
        }
        case ITEM_PROPERTY_AREA_OF_EFFECT:
        {
            ip = ItemPropertyAreaOfEffect(nSubTypeValue, nCostTableValue);
            break;
        }
        case ITEM_PROPERTY_CAST_SPELL_CASTER_LEVEL:
        {
            ip = ItemPropertyCastSpellCasterLevel(nSubTypeValue, nCostTableValue);
            break;
        }
        case ITEM_PROPERTY_CAST_SPELL_METAMAGIC:
        {
            ip = ItemPropertyCastSpellMetamagic(nSubTypeValue, nCostTableValue);
            break;
        }
        case ITEM_PROPERTY_CAST_SPELL_DC:
        {
            ip = ItemPropertyCastSpellDC(nSubTypeValue, nCostTableValue);
            break;
        }
        case ITEM_PROPERTY_PNP_HOLY_AVENGER:
        {
            ip = ItemPropertyPnPHolyAvenger();
            break;
        }

        //ROOM FOR MORE - 89 so far, need increase/decrease cost
        /*
        case ITEM_PROPERTY_ABILITY_BONUS:
        {
            ip = ItemPropertyAbilityBonus(nSubTypeValue, nCostTableValue);
            break;
        }
        case ITEM_PROPERTY_ABILITY_BONUS:
        {
            ip = ItemPropertyAbilityBonus(nSubTypeValue, nCostTableValue);
            break;
        }
        */
    }
    return ip;
}
