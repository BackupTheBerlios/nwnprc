/*
    Henshin Mystic class functions.
    These are all the funstions that the Henshin Mystic pr class
    uses.

    Jeremiah Teague
*/

// Include fiels:
#include "nw_i0_spells"
#include "nw_i0_generic"
#include "x2_inc_spellhook"
#include "x2_inc_itemprop"
#include "prc_class_const"
#include "prc_feat_const"

// Function Definitions:

// Add's all the permanent effects to the henshin mystic's creature skin.
int AddHenshinMysticSkinProperties(object oPC, object oSkin);


// Functions:
int AddHenshinMysticSkinProperties(object oPC, object oSkin)
{
    int bAddedProperty = FALSE;

    if(GetLevelByClass(CLASS_TYPE_HENSHIN_MYSTIC, oPC) == 0)
        {return -1;}

    // Apply Happo Zanshin at level 3:
    if(GetLevelByClass(CLASS_TYPE_HENSHIN_MYSTIC, oPC) >= 3)
    {
        IPSafeAddItemProperty(oSkin, ItemPropertyImmunityMisc(IMMUNITY_TYPE_SNEAK_ATTACK));
        bAddedProperty = TRUE;
    }

    // Add Riddle of Interaction at level 4:
    if(GetLevelByClass(CLASS_TYPE_HENSHIN_MYSTIC, oPC) >= 4)
    {
        // Add +4 to Bluff, Persuade, Taunt and Intimidate:
        IPSafeAddItemProperty(oSkin, ItemPropertySkillBonus(SKILL_BLUFF, 4));
        IPSafeAddItemProperty(oSkin, ItemPropertySkillBonus(SKILL_INTIMIDATE, 4));
        IPSafeAddItemProperty(oSkin, ItemPropertySkillBonus(SKILL_PERSUADE, 4));
        IPSafeAddItemProperty(oSkin, ItemPropertySkillBonus(SKILL_TAUNT, 4));
        bAddedProperty = TRUE;
    }

    // Add Blindsight at level 6:
    if(GetLevelByClass(CLASS_TYPE_HENSHIN_MYSTIC, oPC) >= 6)
    {
        // PC can detect Invisible creatures and has Ultravision:
        ApplyEffectToObject(DURATION_TYPE_PERMANENT, SupernaturalEffect(EffectUltravision()), OBJECT_SELF);
        ApplyEffectToObject(DURATION_TYPE_PERMANENT, SupernaturalEffect(EffectSeeInvisible()), OBJECT_SELF);
        bAddedProperty = TRUE;
    }

    // Add Riddle of Invulnerability at level 10:
    if(GetLevelByClass(CLASS_TYPE_HENSHIN_MYSTIC, oPC) >= 10)
    {
        // Add Damge Reduction 20/+1:
        IPSafeAddItemProperty(oSkin, ItemPropertyDamageReduction(IP_CONST_DAMAGEREDUCTION_1, IP_CONST_DAMAGESOAK_20_HP));
        bAddedProperty = TRUE;
    }

    return bAddedProperty;
}


