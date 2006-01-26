//:://////////////////////////////////////////////
//:: Unarmed evaluation include
//:: prc_inc_unarmed
//:://////////////////////////////////////////////
/*
    Handles attack bonus, damage and itemproperties
    for creature weapons created based on class
    and race abilities.
*/
//:://////////////////////////////////////////////
//:://////////////////////////////////////////////



//////////////////////////////////////////////////
/* Constant declarations                        */
//////////////////////////////////////////////////

const int ITEM_PROPERTY_WOUNDING = 69;

const string CALL_UNARMED_FEATS = "CALL_UNARMED_FEATS";
const string CALL_UNARMED_FISTS = "CALL_UNARMED_FISTS";
const string UNARMED_CALLBACK   = "UNARMED_CALLBACK";

//////////////////////////////////////////////////
/* Function prototypes                          */
//////////////////////////////////////////////////


// Determines the amount of unarmed damage a character can do
// ==========================================================
// oCreature    a creature whose unarmed damage dice are
//              being evaluated
//
// Returns one of the IP_CONST_MONSTERDAMAGE_* constants
int FindUnarmedDamage(object oCreature);

// Adds appropriate unarmed feats to the skin. Goes with UnarmedFists()
// ====================================================================
// oCreature    a creature whose unarmed combat feats to handle
//
// Do not call this directly from your evaluation script. Instead, set
// the local variable CALL_UNARMED_FEATS on the creature to TRUE.
// This is done to avoid bugs from redundant calls to these functions.
void UnarmedFeats(object oCreature);

// Creates/strips a creature weapon and applies bonuses. Goes with UnarmedFeats()
// ==============================================================================
// oCreature    a creature whose creature weapon to handle
//
// Do not call this directly from your evaluation script. Instead, set
// the local variable CALL_UNARMED_FISTS on the creature to TRUE.
// This is done to avoid bugs from redundant calls to these functions.
//
// If you are going to add properties to the creature weapons, hook
// your script for callback after this is evaluated by calling
// AddEventScript(oPC, CALLBACKHOOK_UNARMED, "your_script", FALSE, FALSE);
// When the callback is running, a local int UNARMED_CALLBACK will be
// set on OBJECT_SELF
void UnarmedFists(object oCreature);

/**
 * Determines whether the given object is one of the PRC creature weapons based
 * on it's resref and tag. Resref is tested first, then tag.
 *
 * @param oTest Object to test
 * @return      TRUE if the object is a PRC creature weapon, FALSE otherwise
 */
int GetIsPRCCreatureWeapon(object oTest);


#include "prc_alterations"
#include "prc_feat_const"
#include "prc_ipfeat_const"
#include "prc_class_const"
#include "prc_racial_const"
#include "prc_spell_const"
#include "inc_utility"

//////////////////////////////////////////////////
/* Function defintions                          */
//////////////////////////////////////////////////

// Clean up any extras in the inventory.
void CleanExtraFists(object oCreature)
{
    int iIsCWeap, iIsEquip;

    object oClean = GetFirstItemInInventory(oCreature);

    while (GetIsObjectValid(oClean))
    {
        iIsCWeap = GetIsPRCCreatureWeapon(oClean);

        iIsEquip = oClean == GetItemInSlot(INVENTORY_SLOT_CWEAPON_L) ||
                   oClean == GetItemInSlot(INVENTORY_SLOT_CWEAPON_R) ||
                   oClean == GetItemInSlot(INVENTORY_SLOT_CWEAPON_B);

        if (iIsCWeap && !iIsEquip)
        {
            DestroyObject(oClean);
        }

        oClean = GetNextItemInInventory(oCreature);
    }
}

int GetIsPRCCreatureWeapon(object oTest)
{
    string sTest = GetStringUpperCase(GetResRef(oTest));

    return // First, test ResRef
           sTest == "PRC_UNARMED_B"   ||
           sTest == "PRC_UNARMED_S"   ||
           sTest == "PRC_UNARMED_P"   ||
           sTest == "PRC_UNARMED_SP"  ||
           sTest == "NW_IT_CREWPB010" || // Legacy item, should not be used anymore
           // If resref doesn't match, try tag
           (sTest = GetStringUpperCase(GetTag(oTest))) == "PRC_UNARMED_B" ||
           sTest == "PRC_UNARMED_S"   ||
           sTest == "PRC_UNARMED_P"   ||
           sTest == "PRC_UNARMED_SP"  ||
           sTest == "NW_IT_CREWPB010"
           ;
}

// Determine whether the character is polymorphed or shfited.
int GetIsPolyMorphedOrShifted(object oCreature)
{
    int bPoly = FALSE;

    object oHide = GetPCSkin(oCreature);

    effect eChk = GetFirstEffect(oCreature);

    while (GetIsEffectValid(eChk))
    {
        if (GetEffectType(eChk) == EFFECT_TYPE_POLYMORPH)
        {
            bPoly = TRUE;
        }

        eChk = GetNextEffect(oCreature);
    }

    if (GetLocalInt(oHide, "nPCShifted"))
    {
        bPoly = TRUE;
    }

    return bPoly;
}

// Remove the unarmed penalty effect
void RemoveUnarmedAttackEffects(object oCreature)
{
    effect e = GetFirstEffect(oCreature);

    while (GetIsEffectValid(e))
    {
        if (GetEffectSpellId(e) == SPELL_UNARMED_ATTACK_PEN)
            RemoveEffect(oCreature, e);

        e = GetNextEffect(oCreature);
    }
}

// Add the unarmed penalty effect -- the DR piercing property gives an unwanted
// attack bonus.  This clears it up.
void ApplyUnarmedAttackEffects(object oCreature)
{
    object oCastingObject = CreateObject(OBJECT_TYPE_PLACEABLE, "x0_rodwonder", GetLocation(OBJECT_SELF));

    AssignCommand(oCastingObject, ActionCastSpellAtObject(SPELL_UNARMED_ATTACK_PEN, oCreature, METAMAGIC_NONE, TRUE, 0, PROJECTILE_PATH_TYPE_DEFAULT, TRUE));

    DestroyObject(oCastingObject, 6.0);
}

// Determines the amount of damage a character can do.
// IoDM: +1 dice at level 4, +2 dice at level 8
// Sacred Fist: Levels add to monk levels, or stand alone as monk levels.
// Shou: 1d6 at level 1, 1d8 at level 2, 1d10 at level 3, 2d6 at level 5
// Monk: 1d6 at level 1, 1d8 at level 4, 1d10 at level 8, 2d6 at level 12, 2d8 at level 16, 2d10 at level 20
// Brawler: 1d6 at level 1, 1d8 at level 6, 1d10 at level 12, 2d6 at level 18, 2d8 at level 24, 2d10 at level 30, 3d8 at level 36
int FindUnarmedDamage(object oCreature)
{
    int iDamage = 0;
    int iMonk = GetLevelByClass(CLASS_TYPE_MONK, oCreature);
    int iShou = GetLevelByClass(CLASS_TYPE_SHOU, oCreature);
    int iIoDM = GetLevelByClass(CLASS_TYPE_INITIATE_DRACONIC, oCreature);
    int iBrawler = GetLevelByClass(CLASS_TYPE_BRAWLER, oCreature);
    int iSacredFist = GetLevelByClass(CLASS_TYPE_SACREDFIST, oCreature);
    int iHenshin = GetLevelByClass(CLASS_TYPE_HENSHIN_MYSTIC, oCreature);
    int iZuoken = GetLevelByClass(CLASS_TYPE_FIST_OF_ZUOKEN, oCreature);
    int iMonkDamage = 0;
    int iShouDamage = 0;
    int iBrawlerDamage = 0;
    int iRacialDamage = 0;
    int iDamageToUse = 0;
    int iDieIncrease = 0;
    int bUseMonkAlt = FALSE;

    // Determine creature size by feats.
    int bTinySize   = GetHasFeat(FEAT_TINY, oCreature);
    int bSmallSize  = GetHasFeat(FEAT_SMALL, oCreature);
    int bLargeSize  = GetHasFeat(FEAT_LARGE, oCreature);
    int bHugeSize   = GetHasFeat(FEAT_HUGE, oCreature);
    int bMediumSize = !bTinySize && !bSmallSize && !bLargeSize && !bHugeSize;

    // if the creature is shifted, use model size
    // otherwise, we want to stick to what the feats say they "should" be.
    // No making pixies with Dragon Appearance for "huge" fist damage.
    if( GetIsPolyMorphedOrShifted(oCreature) )
    {
         bTinySize   = FALSE;
         bSmallSize  = FALSE;
         bMediumSize = FALSE;
         bLargeSize  = FALSE;
         bHugeSize   = FALSE;

         switch (PRCGetCreatureSize(oCreature))
         {
              case CREATURE_SIZE_TINY:   bTinySize   = TRUE; break;
              case CREATURE_SIZE_SMALL:  bSmallSize  = TRUE; break;
              case CREATURE_SIZE_MEDIUM: bMediumSize = TRUE; break;
              case CREATURE_SIZE_LARGE:  bLargeSize  = TRUE; break;
              case CREATURE_SIZE_HUGE:   bHugeSize   = TRUE; break;
         }
    }

    // Sacred Fist cannot add their levels if they've broken their code.
    if (GetHasFeat(FEAT_SF_CODE,oCreature)) iSacredFist = 0;

    // Sacred Fist adds their levels to the monk class otherwise.
    // Note: If a Sacred Fist has 0 levels of monk, it is considered to be a monk
    // of equal level when considering damage (and unarmed attack schedule, which
    // is not implemented.)
    if (iSacredFist) iMonk += iSacredFist;

    // Henshin Mystic stacks with monk levels (or uses monk progression.)
    if (iHenshin) iMonk += iHenshin;

    // Shou Disciple stacks with monk levels (or uses monk progression.)
    if (iShou) iMonk += iShou;

    // Fist of Zuoken stacks with monk levels (or uses monk progression.)
    if (iZuoken) iMonk += iZuoken;

    // In 3.0e, Monk progression stops after level 16:
    if (iMonk > 16 && !GetPRCSwitch(PRC_3_5e_FIST_DAMAGE) ) iMonk = 16;
    // in 3.5e, monk progression stops at 20.
    else if(iMonk > 20) iMonk = 20;

    // Calculating size modifier for damage dice, defaults to 2 as a standard.
    int iSizeModifier = 2;
    if      (bTinySize)   iSizeModifier = 0; // Tiny monks  - 1d3,  1d4,  1d6,  1d8,  1d10
    else if (bSmallSize)  iSizeModifier = 1; // Small monks - 1d4,  1d6,  1d8,  1d10, 2d6
    else if (bMediumSize) iSizeModifier = 2; // Medium monk - 1d6,  1d8,  1d10, 1d12, 1d20
    else if (bLargeSize)  iSizeModifier = 3; // Large monks - 1d8,  1d10, 1d12, 2d8,  2d10
    else if (bHugeSize)   iSizeModifier = 4; // Huge monks  - 1d10, 1d12, 2d8,  2d10, 2d12

    // calculates monk damage with proper size modifer
    iMonkDamage = iMonk / 4 + iSizeModifier;

    // For medium monks in 3.0e skip 2d6 and go to 1d20
    if(bMediumSize && iMonkDamage == 6 && !GetPRCSwitch(PRC_3_5e_FIST_DAMAGE) ) iMonkDamage = 7;

    // Shou Disciple either adds its level to existing class or does its own damage, depending
    // on which is better. Here we will determine how much damage the Shou Disciple does
    // without stacking.
    if (iShou > 0) iShouDamage = iShou + 1; // Lv. 1: 1d6, Lv. 2: 1d8, Lv. 3: 1d10
    if (iShou > 3) iShouDamage--;           // Lv. 4: 1d10, Lv. 5: 2d6

    // Modify the Shou Disciples damage based on size.
    iShouDamage += iSizeModifier;

    // Brawler has a very simple damage progression (regardless of size):
    if (iBrawler) iBrawlerDamage = iBrawler / 6 + 2;   // 1d6, 1d8, 1d10, 2d6, 2d8, 2d10, 3d8

    // Optional code for "sized" bralwers
    if(GetPRCSwitch(PRC_BRAWLER_SIZE) && iBrawler > 0)
        iBrawlerDamage = iBrawler / 6 + iSizeModifier;

    // Certain race pack creatures use different damages.
    if      (GetRacialType(oCreature) == RACIAL_TYPE_MINOTAUR)   iRacialDamage = 3;
    else if (GetRacialType(oCreature) == RACIAL_TYPE_TANARUKK)   iRacialDamage = 2;
    else if (GetRacialType(oCreature) == RACIAL_TYPE_TROLL)      iRacialDamage = 2;
    else if (GetRacialType(oCreature) == RACIAL_TYPE_RAKSHASA)   iRacialDamage = 2;
    else if (GetRacialType(oCreature) == RACIAL_TYPE_CENTAUR)    iRacialDamage = 2;
    else if (GetRacialType(oCreature) == RACIAL_TYPE_ILLITHID)   iRacialDamage = 1;
    else if (GetRacialType(oCreature) == RACIAL_TYPE_LIZARDFOLK) iRacialDamage = 1;

    // For Initiate of Draconic Mysteries
    if      (GetHasFeat(FEAT_INCREASE_DAMAGE2, oCreature)) iDieIncrease = 2;
    else if (GetHasFeat(FEAT_INCREASE_DAMAGE1, oCreature)) iDieIncrease = 1;

    // Monks and monk-like classes deal no additional damage when wearing any armor, at
    // least in NWN.  This is to reflect that.  No shields too.
    if (iMonkDamage > 0 || iShouDamage > 0)
    {
        object oArmor = GetItemInSlot(INVENTORY_SLOT_CHEST, oCreature);
        object oShield = GetItemInSlot(INVENTORY_SLOT_LEFTHAND, oCreature);
        int bShieldEq = GetBaseItemType(oShield) == BASE_ITEM_SMALLSHIELD ||
                        GetBaseItemType(oShield) == BASE_ITEM_LARGESHIELD ||
                        GetBaseItemType(oShield) == BASE_ITEM_TOWERSHIELD;

        if (GetBaseAC(oArmor) > 0 || bShieldEq)
        {
            iMonkDamage = 0;
            iShouDamage = 0;
        }
    }

    // Future unarmed classes:  if you do your own damage, add in "comparisons" below here.
    iDamageToUse = (iMonkDamage    > iDamageToUse) ? iMonkDamage    : iDamageToUse;
    iDamageToUse = (iBrawlerDamage > iDamageToUse) ? iBrawlerDamage : iDamageToUse;
    iDamageToUse = (iShouDamage    > iDamageToUse) ? iShouDamage    : iDamageToUse;

    // For the creature weapon, we consider only creatures that don't have IoDM levels, for
    // "correctness"
    if (!GetHasFeat(FEAT_INCREASE_DAMAGE1, oCreature) && iRacialDamage > iDamageToUse)
    {
        iDamageToUse = iRacialDamage;
        SetLocalInt(oCreature, "UsesRacialAttack", TRUE);
    }
    else // this is so that the damage subtype is not added inappropriately.
    {
        DeleteLocalInt(oCreature, "UsesRacialAttack");
    }

    // Small characters get a penalty to damage if they've somehow ended up with no damage bonus
    // (monk wearing armor or no monk levels but IoDM levels, stuff like that.)
    // Added in tiny, large, and hugh size modifiers.
    if      (iDamageToUse == 0 && bSmallSize) iDamageToUse = -1;
    else if (iDamageToUse == 0 && bTinySize)  iDamageToUse = -1;
    else if (iDamageToUse == 0 && bLargeSize) iDamageToUse = +1;
    else if (iDamageToUse == 0 && bHugeSize)  iDamageToUse = +2;

    // Medium+ monks have some special values on the table:
    if (iDamageToUse == iMonkDamage && !bSmallSize) bUseMonkAlt = TRUE;

    // This is where the correct damage dice is calculated
    if (iDamageToUse > 10) iDamageToUse = 10;

    switch (iDamageToUse)
    {
        case -1:
            if      (iDieIncrease == 2)     iDamage = IP_CONST_MONSTERDAMAGE_1d4;
            else if (iDieIncrease == 1)     iDamage = IP_CONST_MONSTERDAMAGE_1d3;
            else                            iDamage = IP_CONST_MONSTERDAMAGE_1d2;
            break;
        case 0:
            if      (iDieIncrease == 2)     iDamage = IP_CONST_MONSTERDAMAGE_1d6;
            else if (iDieIncrease == 1)     iDamage = IP_CONST_MONSTERDAMAGE_1d4;
            else                            iDamage = IP_CONST_MONSTERDAMAGE_1d3;
            break;
        case 1:
            if      (iDieIncrease == 2)     iDamage = IP_CONST_MONSTERDAMAGE_1d8;
            else if (iDieIncrease == 1)     iDamage = IP_CONST_MONSTERDAMAGE_1d6;
            else                            iDamage = IP_CONST_MONSTERDAMAGE_1d4;
            break;
        case 2:
            if      (iDieIncrease == 2)     iDamage = IP_CONST_MONSTERDAMAGE_1d10;
            else if (iDieIncrease == 1)     iDamage = IP_CONST_MONSTERDAMAGE_1d8;
            else                            iDamage = IP_CONST_MONSTERDAMAGE_1d6;
            break;
        case 3:
            if      (iDieIncrease == 2)     iDamage = IP_CONST_MONSTERDAMAGE_1d12;
            else if (iDieIncrease == 1)     iDamage = IP_CONST_MONSTERDAMAGE_1d10;
            else                            iDamage = IP_CONST_MONSTERDAMAGE_1d8;
            break;
        case 4:
            if      (iDieIncrease == 2)     iDamage = IP_CONST_MONSTERDAMAGE_2d8;
            else if (iDieIncrease == 1)     iDamage = IP_CONST_MONSTERDAMAGE_1d12;
            else                            iDamage = IP_CONST_MONSTERDAMAGE_1d10;
            break;
        case 5:
            if (bUseMonkAlt && !GetPRCSwitch(PRC_3_5e_FIST_DAMAGE) )
            {
                if      (iDieIncrease == 2) iDamage = IP_CONST_MONSTERDAMAGE_1d20;
                else if (iDieIncrease == 1) iDamage = IP_CONST_MONSTERDAMAGE_2d8;
                else                        iDamage = IP_CONST_MONSTERDAMAGE_1d12;
            }
            else
            {
                if      (iDieIncrease == 2) iDamage = IP_CONST_MONSTERDAMAGE_2d10;
                else if (iDieIncrease == 1) iDamage = IP_CONST_MONSTERDAMAGE_2d8;
                else                        iDamage = IP_CONST_MONSTERDAMAGE_2d6;
            }
            break;
        case 6:
            if      (iDieIncrease == 2)     iDamage = IP_CONST_MONSTERDAMAGE_2d12;
            else if (iDieIncrease == 1)     iDamage = IP_CONST_MONSTERDAMAGE_2d10;
            else                            iDamage = IP_CONST_MONSTERDAMAGE_2d8;
            break;
        case 7:
            if (bUseMonkAlt && !GetPRCSwitch(PRC_3_5e_FIST_DAMAGE))
            {
                if      (iDieIncrease == 2) iDamage = IP_CONST_MONSTERDAMAGE_3d10;
                else if (iDieIncrease == 1) iDamage = IP_CONST_MONSTERDAMAGE_2d12;
                else                        iDamage = IP_CONST_MONSTERDAMAGE_1d20;
            }
            else
            {
                if      (iDieIncrease == 2) iDamage = IP_CONST_MONSTERDAMAGE_3d10;
                else if (iDieIncrease == 1) iDamage = IP_CONST_MONSTERDAMAGE_2d12;
                else                        iDamage = IP_CONST_MONSTERDAMAGE_2d10;
            }
            break;
        case 8:
            if      (iDieIncrease == 2)     iDamage = IP_CONST_MONSTERDAMAGE_3d12;
            else if (iDieIncrease == 1)     iDamage = IP_CONST_MONSTERDAMAGE_3d10;
            else                            iDamage = IP_CONST_MONSTERDAMAGE_3d8;
            break;
        case 9:
            if      (iDieIncrease == 2)     iDamage = IP_CONST_MONSTERDAMAGE_4d10;
            else if (iDieIncrease == 1)     iDamage = IP_CONST_MONSTERDAMAGE_3d12;
            else                            iDamage = IP_CONST_MONSTERDAMAGE_3d10;
            break;
        case 10:
            if      (iDieIncrease == 2)     iDamage = IP_CONST_MONSTERDAMAGE_4d12;
            else if (iDieIncrease == 1)     iDamage = IP_CONST_MONSTERDAMAGE_4d10;
            else                            iDamage = IP_CONST_MONSTERDAMAGE_3d12;
            break;

        default:
            WriteTimestampedLogEntry("Unknown value encountered in FindUnarmedDamage: " + IntToString(iDamageToUse));
            break;
    }

    return iDamage;
}

// Adds appropriate feats to the skin. Stolen from SoulTaker + expanded with overwhelming/devastating critical.
void UnarmedFeats(object oCreature)
{
    object oSkin = GetPCSkin(oCreature);

    if (!GetHasFeat(FEAT_WEAPON_PROFICIENCY_CREATURE, oCreature))
        AddItemProperty(DURATION_TYPE_PERMANENT,ItemPropertyBonusFeat(IP_CONST_FEAT_WEAPON_PROF_CREATURE),oSkin);

    if (GetHasFeat(FEAT_WEAPON_FOCUS_UNARMED_STRIKE, oCreature) && !GetHasFeat(FEAT_WEAPON_FOCUS_CREATURE, oCreature))
        AddItemProperty(DURATION_TYPE_PERMANENT,ItemPropertyBonusFeat(IP_CONST_FEAT_WeapFocCreature),oSkin);

    if (GetHasFeat(FEAT_WEAPON_SPECIALIZATION_UNARMED_STRIKE, oCreature) && !GetHasFeat(FEAT_WEAPON_SPECIALIZATION_CREATURE, oCreature))
        AddItemProperty(DURATION_TYPE_PERMANENT,ItemPropertyBonusFeat(IP_CONST_FEAT_WeapSpecCreature),oSkin);

    if (GetHasFeat(FEAT_IMPROVED_CRITICAL_UNARMED_STRIKE, oCreature) && !GetHasFeat(FEAT_IMPROVED_CRITICAL_CREATURE, oCreature))
        AddItemProperty(DURATION_TYPE_PERMANENT,ItemPropertyBonusFeat(IP_CONST_FEAT_ImpCritCreature),oSkin);

    if (GetHasFeat(FEAT_EPIC_WEAPON_FOCUS_UNARMED, oCreature) && !GetHasFeat(FEAT_EPIC_WEAPON_FOCUS_CREATURE, oCreature))
        AddItemProperty(DURATION_TYPE_PERMANENT,ItemPropertyBonusFeat(IP_CONST_FEAT_WeapEpicFocCreature),oSkin);

    if (GetHasFeat(FEAT_EPIC_WEAPON_SPECIALIZATION_UNARMED, oCreature) && !GetHasFeat(FEAT_EPIC_WEAPON_SPECIALIZATION_CREATURE, oCreature))
        AddItemProperty(DURATION_TYPE_PERMANENT,ItemPropertyBonusFeat(IP_CONST_FEAT_WeapEpicSpecCreature),oSkin);

    if (GetHasFeat(FEAT_EPIC_OVERWHELMING_CRITICAL_UNARMED, oCreature) && !GetHasFeat(FEAT_EPIC_OVERWHELMING_CRITICAL_CREATURE, oCreature))
        AddItemProperty(DURATION_TYPE_PERMANENT,ItemPropertyBonusFeat(IP_CONST_FEAT_OVERCRITICAL_CREATURE),oSkin);

    if (GetHasFeat(FEAT_EPIC_DEVASTATING_CRITICAL_UNARMED, oCreature) && !GetHasFeat(FEAT_EPIC_DEVASTATING_CRITICAL_CREATURE, oCreature))
        AddItemProperty(DURATION_TYPE_PERMANENT,ItemPropertyBonusFeat(IP_CONST_FEAT_DEVCRITICAL_CREATURE),oSkin);
}

// Creates/strips a creature weapon and applies bonuses.  Large chunks stolen from SoulTaker.
void UnarmedFists(object oCreature)
{
    RemoveUnarmedAttackEffects(oCreature);

    object oRighthand = GetItemInSlot(INVENTORY_SLOT_RIGHTHAND, oCreature);
    object oLefthand = GetItemInSlot(INVENTORY_SLOT_LEFTHAND, oCreature);
    object oWeapL = GetItemInSlot(INVENTORY_SLOT_CWEAPON_L, oCreature);

    int iRace = GetRacialType(oCreature);
    int iMonk = GetLevelByClass(CLASS_TYPE_MONK, oCreature);
    int iShou = GetLevelByClass(CLASS_TYPE_SHOU, oCreature);
    int iSacFist = GetLevelByClass(CLASS_TYPE_SACREDFIST, oCreature);
    int iHenshin = GetLevelByClass(CLASS_TYPE_HENSHIN_MYSTIC, oCreature);
    int iIoDM = GetLevelByClass(CLASS_TYPE_INITIATE_DRACONIC, oCreature);
    int iBrawler = GetLevelByClass(CLASS_TYPE_BRAWLER, oCreature);
    int iZuoken = GetLevelByClass(CLASS_TYPE_FIST_OF_ZUOKEN, oCreature);

    // Sacred Fists who break their code get no benefits.
    if (GetHasFeat(FEAT_SF_CODE,oCreature)) iSacFist = 0;

    // The monk adds all these classes.
    int iMonkEq = iMonk + iShou + iSacFist + iHenshin + iZuoken;

    // Determine the type of damage the character should do.
    string sWeapType;
    if (GetHasFeat(FEAT_CLAWDRAGON, oCreature) ||
        iRace == RACIAL_TYPE_TROLL             ||
        iRace == RACIAL_TYPE_RAKSHASA          ||
        iRace == RACIAL_TYPE_LIZARDFOLK)
    {
        sWeapType = "PRC_UNARMED_S";
    }
    else if (iRace == RACIAL_TYPE_TANARUKK ||
             iRace == RACIAL_TYPE_MINOTAUR)
    {
        sWeapType = "PRC_UNARMED_P";
    }
    else
    {
        sWeapType = "PRC_UNARMED_B";
    }

    // If we are polymorphed/shifted, do not mess with the creature weapon.
    if (GetIsPolyMorphedOrShifted(oCreature)) return;

    // Equip the creature weapon.
    if (!GetIsObjectValid(oWeapL) || GetTag(oWeapL) != sWeapType)
    {
        if (GetHasItem(oCreature, sWeapType))
        {
            oWeapL = GetItemPossessedBy(oCreature, sWeapType);
            SetIdentified(oWeapL, TRUE);
            AssignCommand(oCreature, ActionEquipItem(oWeapL, INVENTORY_SLOT_CWEAPON_L));
        }
        else
        {
            oWeapL = CreateItemOnObject(sWeapType, oCreature);
            SetIdentified(oWeapL, TRUE);
            AssignCommand(oCreature,ActionEquipItem(oWeapL, INVENTORY_SLOT_CWEAPON_L));
        }
    }

    // Clean up the mess of extra fists made on taking first level.
    DelayCommand(1.0,CleanExtraFists(oCreature));

    // Determine the character's capacity to pierce DR.
    int iKi = (iMonkEq > 9)  ? 1 : 0;
        iKi = (iMonkEq > 12) ? 2 : iKi;
        iKi = (iMonkEq > 15) ? 3 : iKi;

    int iDragClaw = GetHasFeat(FEAT_CLAWDRAGON,oCreature) ? 1: 0;
        iDragClaw = GetHasFeat(FEAT_CLAWENH2,oCreature)   ? 2: iDragClaw;
        iDragClaw = GetHasFeat(FEAT_CLAWENH3,oCreature)   ? 3: iDragClaw;

    int iBrawlEnh = iBrawler / 6;

    int iEpicKi = GetHasFeat(FEAT_EPIC_IMPROVED_KI_STRIKE_4,oCreature) ? 1 : 0 ;
        iEpicKi = GetHasFeat(FEAT_EPIC_IMPROVED_KI_STRIKE_5,oCreature) ? 2 : iEpicKi ;

    // The total enhancement to the fist is the sum of all the enhancements above
    int iEnh = iKi + iDragClaw + iBrawlEnh + iEpicKi;

    // Strip the Fist.
    itemproperty ip = GetFirstItemProperty(oWeapL);
    while (GetIsItemPropertyValid(ip))
    {
        RemoveItemProperty(oWeapL, ip);
        ip = GetNextItemProperty(oWeapL);
    }

    // Leave the fist blank if weapons are equipped.  The only way a weapon will
    // be equipped on the left hand is if there is a weapon in the right hand.
    if (GetIsObjectValid(oRighthand)) return;

    // Add glove bonuses.
    object oItem = GetItemInSlot(INVENTORY_SLOT_ARMS,oCreature);
    int iGloveEnh = 0;
    if (GetIsObjectValid(oItem))
    {
        int iType = GetBaseItemType(oItem);
        if (iType == BASE_ITEM_GLOVES)
        {
            ip = GetFirstItemProperty(oItem);
            while(GetIsItemPropertyValid(ip))
            {
                iType = GetItemPropertyType(ip);
                switch (iType)
                {
                    case ITEM_PROPERTY_DAMAGE_BONUS:
                    case ITEM_PROPERTY_DAMAGE_BONUS_VS_ALIGNMENT_GROUP:
                    case ITEM_PROPERTY_DAMAGE_BONUS_VS_RACIAL_GROUP:
                    case ITEM_PROPERTY_DAMAGE_BONUS_VS_SPECIFIC_ALIGNMENT:
                    case ITEM_PROPERTY_ON_HIT_PROPERTIES:
                    case ITEM_PROPERTY_ONHITCASTSPELL:
                    case ITEM_PROPERTY_EXTRA_MELEE_DAMAGE_TYPE:
                    case ITEM_PROPERTY_KEEN:
                    case ITEM_PROPERTY_MASSIVE_CRITICALS:
                    case ITEM_PROPERTY_POISON:
                    case ITEM_PROPERTY_REGENERATION_VAMPIRIC:
                    case ITEM_PROPERTY_WOUNDING:
                    case ITEM_PROPERTY_DECREASED_DAMAGE:
                    case ITEM_PROPERTY_DECREASED_ATTACK_MODIFIER:
                        DelayCommand(0.1, AddItemProperty(DURATION_TYPE_PERMANENT,ip,oWeapL));
                        break;
                    case ITEM_PROPERTY_ATTACK_BONUS:
                        int iCost = GetItemPropertyCostTableValue(ip);
                        iGloveEnh = (iCost>iGloveEnh) ? iCost:iGloveEnh;
                        iEnh =      (iCost>iEnh)      ? iCost:iEnh;
                        break;
                }
                ip = GetNextItemProperty(oItem);
            }
            // handles these seperately so as not to create "attack penalties vs. xxxx"
            ip = GetFirstItemProperty(oItem);
            while(GetIsItemPropertyValid(ip))
            {
                iType = GetItemPropertyType(ip);
                switch (iType)
                {
                    case ITEM_PROPERTY_ATTACK_BONUS_VS_SPECIFIC_ALIGNMENT:
                    case ITEM_PROPERTY_ATTACK_BONUS_VS_ALIGNMENT_GROUP:
                    case ITEM_PROPERTY_ATTACK_BONUS_VS_RACIAL_GROUP:
                    if (GetItemPropertyCostTableValue(ip) > iEnh)
                        DelayCommand(0.1, AddItemProperty(DURATION_TYPE_PERMANENT,ip,oWeapL));
                    break;
                }
                ip = GetNextItemProperty(oItem);
            }
        }
    }

    // Weapon finesse or intuitive attack?
    SetLocalInt(oCreature, "UsingCreature", TRUE);
    ExecuteScript("prc_intuiatk", oCreature);
    DelayCommand(1.0f, DeleteLocalInt(oCreature, "UsingCreature"));

    // Add the appropriate damage to the fist.
    int iMonsterDamage = FindUnarmedDamage(oCreature);
    AddItemProperty(DURATION_TYPE_PERMANENT,ItemPropertyMonsterDamage(iMonsterDamage),oWeapL);

    // Add OnHitCast: Unique if necessary
    if(GetHasFeat(FEAT_REND, oCreature))
        AddItemProperty(DURATION_TYPE_PERMANENT, ItemPropertyOnHitCastSpell(IP_CONST_ONHIT_CASTSPELL_ONHIT_UNIQUEPOWER, 1), oWeapL);

    // Cool VFX when striking unarmed
    if (iMonkEq > 9)
        //DelayCommand(0.1, AddItemProperty(DURATION_TYPE_PERMANENT, ItemPropertyBonusFeat(IP_CONST_FEAT_KI_STRIKE), oWeapL));
        DelayCommand(0.1, IPSafeAddItemProperty(oWeapL, ItemPropertyBonusFeat(IP_CONST_FEAT_KI_STRIKE), 0.0f, X2_IP_ADDPROP_POLICY_KEEP_EXISTING, FALSE, FALSE));

    // Add damage resistance penetration.
    DelayCommand(0.1, AddItemProperty(DURATION_TYPE_PERMANENT,ItemPropertyAttackBonus(iEnh), oWeapL));

    // This adds creature weapon finesse and a penalty to offset the DR penetration attack bonus.
    SetLocalInt(oCreature, "UnarmedEnhancement", iEnh);
    SetLocalInt(oCreature, "UnarmedEnhancementGlove", iGloveEnh);
    ApplyUnarmedAttackEffects(oCreature);

    // Friendly message to remind players that certain things won't appear correct.
    if (GetLocalInt(oCreature, "UnarmedSubSystemMessage") != TRUE && GetHasSpellEffect(SPELL_UNARMED_ATTACK_PEN, oCreature))
    {
        SetLocalInt(oCreature, "UnarmedSubSystemMessage", TRUE);
        DelayCommand(3.001f, SendMessageToPC(oCreature, "This character uses the PRC's unarmed system.  This system has been created to"));
        DelayCommand(3.002f, SendMessageToPC(oCreature, "work around many Aurora engine bugs and limitations. Your attack roll may appear to be"));
        DelayCommand(3.003f, SendMessageToPC(oCreature, "incorrect on the character's stats. However, the attack rolls should be correct in"));
        DelayCommand(3.004f, SendMessageToPC(oCreature, "combat. Disregard any attack effects that seem extra: they are part of the workaround."));
        DelayCommand(600.0f, DeleteLocalInt(oCreature, "UnarmedSubSystemMessage"));
    }
}
