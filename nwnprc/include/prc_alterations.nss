//
//   This is the original include file for the PRC Spell Engine.
//
//   Various spells, components and designs within this system have
//   been contributed by many individuals within and without the PRC.
//

// Checks if target is a frenzied Bersker with Deathless Frenzy Active
// If so removes imortality flag so that Death Spell can kill them
void DeathlessFrenzyCheck(object oTarget);

// Get the size (CREATURE_SIZE_*) of oCreature.
//including any PRC size modification feats
int PRCGetCreatureSize(object oObject = OBJECT_SELF);
const int CREATURE_SIZE_FINE            = -1;
const int CREATURE_SIZE_DIMINUTIVE      =  0; //yes this is the same as CREATURE_SIZE_INVALID, live with it
                                              //if it isnt, then they are not a straight series any longer
const int CREATURE_SIZE_GARGANTUAN      =  6;
const int CREATURE_SIZE_COLOSSAL        =  7;

const int SAVING_THROW_NONE = 4;

//this is here rather than inc_utility because it uses creature size and screws compiling if its elsewhere

//  int GetSkill(object oObject, int nSkill, int bSynergy = FALSE,
//      int bSize = FALSE, int bAbilityMod = TRUE, int bEffect = TRUE,
//      int bArmor = TRUE, int bShield = TRUE, int bFeat = TRUE);
//  by Primogenitor
//  oObject     subject to get skills of
//  nSkill      SKILL_*
//  bSynergy    include any applicable synergy bonus
//  bSize       include any applicable size bonus
//  bAbilityMod include relevant ability modification (including effects on that ability)
//  bEffect     include skill changing effects and itemproperties
//  bArmor      include armor mod if applicable (excluding shield)
//  bShield     include shield mod if applicable (excluding armor)
//  bFeat       include any applicable feats, including racial ones
//  this returns 0 if the subject does not have any ranks in the skill and the skill is trained only
//  the defaults are the same as biowares GetSkillRank function
int GetSkill(object oObject, int nSkill, int bSynergy = FALSE, int bSize = FALSE, int bAbilityMod = TRUE, int bEffect = TRUE, int bArmor = TRUE, int bShield = TRUE, int bFeat = TRUE);

// Generic includes
#include "prcsp_engine"
#include "inc_utility"
#include "x2_inc_switches"
#include "prc_feat_const"
#include "prc_class_const"
#include "prc_spell_const"
#include "prc_racial_const"
#include "prc_ipfeat_const"
#include "prc_misc_const"
#include "inc_fileends"
#include "inc_acp"

// PRC Spell Engine Utility Functions
#include "lookup_2da_spell"
#include "prc_inc_spells"
#include "prcsp_reputation"
#include "prcsp_archmaginc"
#include "prcsp_spell_adjs"
#include "prc_inc_clsfunc"
#include "prc_inc_racial"
#include "inc_abil_damage"
#include "inc_persist_loca"
#include "NW_I0_GENERIC"
#include "inc_abil_damage"
#include "prc_inc_combat"




// Added by Oni5115
void DeathlessFrenzyCheck(object oTarget)
{
     if(GetHasFeat(FEAT_DEATHLESS_FRENZY, oTarget) && GetHasFeatEffect(FEAT_FRENZY, oTarget) )
     {
          SetImmortal(oTarget, FALSE);
     }
}

//return a location that PCs will never be able to access
location PRC_GetLimbo()
{
    int i = 0;
    location lLimbo;

    while (1)
    {
        object oLimbo = GetObjectByTag("Limbo", i++);
    
        if (oLimbo == OBJECT_INVALID) {
            PrintString("PRC ERROR: no Limbo area! (did you import the latest PRC .ERF file?)");
            return lLimbo;
        }

        if (GetName(oLimbo) == "Limbo" && GetArea(oLimbo) == OBJECT_INVALID)
        {
            vector vLimbo = Vector(0.0f, 0.0f, 0.0f);
            lLimbo = Location(oLimbo, vLimbo, 0.0f);
        }
    }
    return lLimbo;      //never reached
}

effect EffectShaken()
{
    effect eReturn = EffectVisualEffect(VFX_DUR_MIND_AFFECTING_NEGATIVE);
    int i;
    eReturn = EffectLinkEffects(eReturn, EffectAttackDecrease(2));
    eReturn = EffectLinkEffects(eReturn, EffectSavingThrowDecrease(SAVING_THROW_ALL,2));
    eReturn = EffectLinkEffects(eReturn, EffectSkillDecrease(SKILL_ALL_SKILLS, 2));
    return eReturn;
}

// Get the size (CREATURE_SIZE_*) of oCreature.
//including any PRC size modification feats / spells
int PRCGetCreatureSize(object oObject = OBJECT_SELF)
{
    int nSize = GetCreatureSize(oObject);
    if(GetHasFeat(FEAT_SIZE_DECREASE_6))
        nSize += -6;
    else if(GetHasFeat(FEAT_SIZE_DECREASE_5))
        nSize += -5;
    else if(GetHasFeat(FEAT_SIZE_DECREASE_4))
        nSize += -4;
    else if(GetHasFeat(FEAT_SIZE_DECREASE_3))
        nSize += -3;
    else if(GetHasFeat(FEAT_SIZE_DECREASE_2))
        nSize += -2;
    else if(GetHasFeat(FEAT_SIZE_DECREASE_1))
        nSize += -1;
        
    if(GetHasFeat(FEAT_SIZE_INCREASE_6))
        nSize +=  6;
    else if(GetHasFeat(FEAT_SIZE_INCREASE_5))
        nSize +=  5;
    else if(GetHasFeat(FEAT_SIZE_INCREASE_4))
        nSize +=  4;
    else if(GetHasFeat(FEAT_SIZE_INCREASE_3))
        nSize +=  3;
    else if(GetHasFeat(FEAT_SIZE_INCREASE_2))
        nSize +=  2;
    else if(GetHasFeat(FEAT_SIZE_INCREASE_1))
        nSize +=  1;
    
    if(!GetPRCSwitch(PRC_DRAGON_DISCIPLE_SIZE_CHANGES))
    {
        if(GetHasFeat(FEAT_DRACONIC_SIZE_INCREASE_2))
            nSize +=  2;
        else if(GetHasFeat(FEAT_DRACONIC_SIZE_INCREASE_1))
            nSize +=  1;    
    }    
        
    if(nSize < CREATURE_SIZE_FINE)
        nSize = CREATURE_SIZE_FINE;
    if(nSize > CREATURE_SIZE_COLOSSAL)
        nSize = CREATURE_SIZE_COLOSSAL;
    
    return nSize;   
}


int GetSkill(object oObject, int nSkill, int bSynergy = FALSE, int bSize = FALSE, int bAbilityMod = TRUE, int bEffect = TRUE, int bArmor = TRUE, int bShield = TRUE, int bFeat = TRUE)
{
    if(!GetIsObjectValid(oObject))
        return 0;
    if(!GetHasSkill(nSkill, oObject))
        return 0;//no skill set it to zero
    int nSkillRank;  //get the current value at the end, after effects are applied
    if(bSynergy)
    {
        if(nSkill == SKILL_SET_TRAP
            && GetSkill(oObject, SKILL_DISABLE_TRAP, FALSE, FALSE, FALSE,
                FALSE, FALSE, FALSE, FALSE) >= 5)
                nSkillRank += 2;
        if(nSkill == SKILL_DISABLE_TRAP
            && GetSkill(oObject, SKILL_SET_TRAP, FALSE, FALSE, FALSE,
                FALSE, FALSE, FALSE, FALSE) >= 5)
                nSkillRank += 2;
    }
    if(bSize)
        nSkillRank += (PRCGetCreatureSize(oObject)-3)*(0-4);
    if(!bAbilityMod)
    {
        string sAbility = Get2DACache("skills", "KeyAbility", nSkill);
        int nAbility;
        if(sAbility == "STR")
            nAbility = ABILITY_STRENGTH;
        else if(sAbility == "DEX")
            nAbility = ABILITY_DEXTERITY;
        else if(sAbility == "CON")
            nAbility = ABILITY_CONSTITUTION;
        else if(sAbility == "INT")
            nAbility = ABILITY_INTELLIGENCE;
        else if(sAbility == "WIS")
            nAbility = ABILITY_WISDOM;
        else if(sAbility == "CHA")
            nAbility = ABILITY_CHARISMA;
        nSkillRank -= GetAbilityModifier(nAbility, oObject);
    }
    if(!bEffect)
    {
        ApplyEffectToObject(DURATION_TYPE_TEMPORARY, EffectSkillIncrease(nSkill, 30), oObject, 0.001);
        nSkillRank -= 30;
    }
    if(!bArmor
        && GetIsObjectValid(GetItemInSlot(INVENTORY_SLOT_CHEST, oObject))
        && Get2DACache("skills", "ArmorCheckPenalty", nSkill) == "1")
    {
        object oItem = GetItemInSlot(INVENTORY_SLOT_CHEST, oObject);
        // Get the torso model number
        int nTorso = GetItemAppearance( oItem, ITEM_APPR_TYPE_ARMOR_MODEL, ITEM_APPR_ARMOR_MODEL_TORSO);
        // Read 2DA for base AC
        // Can also use "parts_chest" which returns it as a "float"
        int nACBase = StringToInt(Get2DACache( "des_crft_appear", "BaseAC", nTorso));
        int nSkillMod;
        switch(nACBase)
        {
            case 0: nSkillMod = 0; break;
            case 1: nSkillMod = 0; break;
            case 2: nSkillMod = 0; break;
            case 3: nSkillMod = -1; break;
            case 4: nSkillMod = -2; break;
            case 5: nSkillMod = -5; break;
            case 6: nSkillMod = -7; break;
            case 7: nSkillMod = -7; break;
            case 8: nSkillMod = -8; break;
        }
        nSkillRank -= nSkillMod;
    }
    if(!bShield
        && GetIsObjectValid(GetItemInSlot(INVENTORY_SLOT_LEFTHAND, oObject))
        && Get2DACache("skills", "ArmorCheckPenalty", nSkill) == "1")
    {
        object oItem = GetItemInSlot(INVENTORY_SLOT_CHEST, oObject);
        int nBase = GetBaseItemType(oItem);
        int nSkillMod;
        switch(nBase)
        {
            case BASE_ITEM_TOWERSHIELD: nSkillMod = -10; break;
            case BASE_ITEM_LARGESHIELD: nSkillMod = -2; break;
            case BASE_ITEM_SMALLSHIELD: nSkillMod = -1; break;
        }
        nSkillRank -= nSkillMod;
    }
    if(!bFeat)
    {
        int nSkillMod;
        int nEpicFeat;
        int nFocusFeat;
        switch(nSkill)
        {
            case SKILL_ANIMAL_EMPATHY:
                nEpicFeat  = FEAT_EPIC_SKILL_FOCUS_ANIMAL_EMPATHY;
                nFocusFeat = FEAT_SKILL_FOCUS_ANIMAL_EMPATHY;
                break;
            case SKILL_APPRAISE:
                nEpicFeat  = FEAT_EPIC_SKILL_FOCUS_APPRAISE;
                nFocusFeat = FEAT_SKILLFOCUS_APPRAISE;
                if(GetHasFeat(FEAT_SILVER_PALM, oObject))
                    nSkillMod += 2;
                break;
            case SKILL_BLUFF:
                nEpicFeat  = FEAT_EPIC_SKILL_FOCUS_BLUFF;
                nFocusFeat = FEAT_SKILL_FOCUS_BLUFF;
                break;
            case SKILL_CONCENTRATION:
                nEpicFeat  = FEAT_EPIC_SKILL_FOCUS_CONCENTRATION;
                nFocusFeat = FEAT_SKILL_FOCUS_CONCENTRATION;
                if(GetHasFeat(FEAT_SKILL_AFFINITY_CONCENTRATION, oObject))
                    nSkillMod += 2;
                break;
            case SKILL_CRAFT_ARMOR:
                nEpicFeat  = FEAT_EPIC_SKILL_FOCUS_CRAFT_ARMOR;
                nFocusFeat = FEAT_SKILL_FOCUS_CRAFT_ARMOR;
                break;
            case SKILL_CRAFT_TRAP:
                nEpicFeat  = FEAT_EPIC_SKILL_FOCUS_CRAFT_TRAP;
                nFocusFeat = FEAT_SKILL_FOCUS_CRAFT_TRAP;
                break;
            case SKILL_CRAFT_WEAPON:
                nEpicFeat  = FEAT_EPIC_SKILL_FOCUS_CRAFT_WEAPON;
                nFocusFeat = FEAT_SKILL_FOCUS_CRAFT_WEAPON;
                break;
            case SKILL_DISABLE_TRAP:
                nEpicFeat  = FEAT_EPIC_SKILL_FOCUS_DISABLETRAP;
                nFocusFeat = FEAT_SKILL_FOCUS_DISABLE_TRAP;
                break;
            case SKILL_DISCIPLINE:
                nEpicFeat  = FEAT_EPIC_SKILL_FOCUS_DISCIPLINE;
                nFocusFeat = FEAT_SKILL_FOCUS_DISCIPLINE;
                break;
            case SKILL_HEAL:
                nEpicFeat  = FEAT_EPIC_SKILL_FOCUS_HEAL;
                nFocusFeat = FEAT_SKILL_FOCUS_HEAL;
                break;
            case SKILL_HIDE:
                nEpicFeat  = FEAT_EPIC_SKILL_FOCUS_HIDE;
                nFocusFeat = FEAT_SKILL_FOCUS_HIDE;
                break;
            case SKILL_INTIMIDATE:
                nEpicFeat  = FEAT_EPIC_SKILL_FOCUS_INTIMIDATE;
                nFocusFeat = FEAT_SKILL_FOCUS_INTIMIDATE;
                break;
            case SKILL_LISTEN:
                nEpicFeat  = FEAT_EPIC_SKILL_FOCUS_LISTEN;
                nFocusFeat = FEAT_SKILL_FOCUS_LISTEN;
                if(GetHasFeat(FEAT_SKILL_AFFINITY_LISTEN, oObject))
                    nSkillMod += 2;
                if(GetHasFeat(FEAT_PARTIAL_SKILL_AFFINITY_LISTEN, oObject))
                    nSkillMod += 1;
                break;
            case SKILL_LORE:
                nEpicFeat  = FEAT_EPIC_SKILL_FOCUS_LORE;
                nFocusFeat = FEAT_SKILL_FOCUS_LORE;
                if(GetHasFeat(FEAT_SKILL_AFFINITY_LORE, oObject))
                    nSkillMod += 2;
                if(GetHasFeat(FEAT_COURTLY_MAGOCRACY, oObject))
                    nSkillMod += 2;
                break;
            case SKILL_MOVE_SILENTLY:
                nEpicFeat  = FEAT_EPIC_SKILL_FOCUS_MOVESILENTLY;
                nFocusFeat = FEAT_SKILL_FOCUS_MOVE_SILENTLY;
                if(GetHasFeat(FEAT_SKILL_AFFINITY_MOVE_SILENTLY, oObject))
                    nSkillMod += 2;
                break;
            case SKILL_OPEN_LOCK:
                nEpicFeat  = FEAT_EPIC_SKILL_FOCUS_OPENLOCK;
                nFocusFeat = FEAT_SKILL_FOCUS_OPEN_LOCK;
                break;
            case SKILL_PARRY:
                nEpicFeat  = FEAT_EPIC_SKILL_FOCUS_PARRY;
                nFocusFeat = FEAT_SKILL_FOCUS_PARRY;
                break;
            case SKILL_PERFORM:
                nEpicFeat  = FEAT_EPIC_SKILL_FOCUS_PERFORM;
                nFocusFeat = FEAT_SKILL_FOCUS_PERFORM;
                if(GetHasFeat(FEAT_ARTIST, oObject))
                    nSkillMod += 2;
                break;
            case SKILL_PERSUADE:
                nEpicFeat  = FEAT_EPIC_SKILL_FOCUS_PERSUADE;
                nFocusFeat = FEAT_SKILL_FOCUS_PERSUADE;
                if(GetHasFeat(FEAT_SILVER_PALM, oObject))
                    nSkillMod += 2;
                break;
            case SKILL_PICK_POCKET:
                nEpicFeat  = FEAT_EPIC_SKILL_FOCUS_PICKPOCKET;
                nFocusFeat = FEAT_SKILL_FOCUS_PICK_POCKET;
                break;
            case SKILL_SEARCH:
                nEpicFeat  = FEAT_EPIC_SKILL_FOCUS_SEARCH;
                nFocusFeat = FEAT_SKILL_FOCUS_SEARCH;
                if(GetHasFeat(FEAT_SKILL_AFFINITY_SEARCH, oObject))
                    nSkillMod += 2;
                if(GetHasFeat(FEAT_PARTIAL_SKILL_AFFINITY_SEARCH, oObject))
                    nSkillMod += 1;
                break;
            case SKILL_SET_TRAP:
                nEpicFeat  = FEAT_EPIC_SKILL_FOCUS_SETTRAP;
                nFocusFeat = FEAT_SKILL_FOCUS_SET_TRAP;
                break;
            case SKILL_SPELLCRAFT:
                nEpicFeat  = FEAT_EPIC_SKILL_FOCUS_SPELLCRAFT;
                nFocusFeat = FEAT_SKILL_FOCUS_SPELLCRAFT;
                if(GetHasFeat(FEAT_COURTLY_MAGOCRACY, oObject))
                    nSkillMod += 2;
                break;
            case SKILL_SPOT:
                nEpicFeat  = FEAT_EPIC_SKILL_FOCUS_SPOT;
                nFocusFeat = FEAT_SKILL_FOCUS_SPOT;
                if(GetHasFeat(FEAT_SKILL_AFFINITY_SPOT, oObject))
                    nSkillMod += 2;
                if(GetHasFeat(FEAT_PARTIAL_SKILL_AFFINITY_SPOT, oObject))
                    nSkillMod += 1;
                if(GetHasFeat(FEAT_ARTIST, oObject))
                    nSkillMod += 2;
                if(GetHasFeat(FEAT_BLOODED, oObject))
                    nSkillMod += 2;
                break;
            case SKILL_TAUNT:
                nEpicFeat  = FEAT_EPIC_SKILL_FOCUS_TAUNT;
                nFocusFeat = FEAT_SKILL_FOCUS_TAUNT;
                break;
            case SKILL_TUMBLE:
                nEpicFeat  = FEAT_EPIC_SKILL_FOCUS_TUMBLE;
                nFocusFeat = FEAT_SKILL_FOCUS_TUMBLE;
                break;
            case SKILL_USE_MAGIC_DEVICE:
                nEpicFeat  = FEAT_EPIC_SKILL_FOCUS_USEMAGICDEVICE;
                nFocusFeat = FEAT_SKILL_FOCUS_USE_MAGIC_DEVICE;
                break;
        }
        if(nEpicFeat != 0
            && GetHasFeat(nEpicFeat, oObject))
            nSkillMod += 10;
        if(nFocusFeat != 0
            && GetHasFeat(nFocusFeat, oObject))
            nSkillMod += 3;
        nSkillRank -= nSkillMod;
    }
    //add this at the end so any effects applied are counted
    nSkillRank += GetSkillRank(nSkill, oObject);
    return nSkillRank;
}