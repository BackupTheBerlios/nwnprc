//::///////////////////////////////////////////////
//:: Include nexus
//:: prc_alterations
//::///////////////////////////////////////////////
/*
    This is the original include file for the PRC Spell Engine.

    Various spells, components and designs within this system have
    been contributed by many individuals within and without the PRC.


    These days, it serves to gather links to almost all the PRC
    includes to one file. Should probably get sorted out someday,
    since this slows compilation. On the other hand, it may be
    necessary, since the custom compiler can't seem to handle
    the most twisted include loops.
    Related TODO to any C++ experts: Add #DEFINE support to nwnnsscomp

    Also, this file contains misceallenous functions that haven't
    got a better home.
*/
//:://////////////////////////////////////////////
//:://////////////////////////////////////////////

// Avoids adding passive spellcasting to the character's action queue by
// creating an object specifically to cast the spell on the character.
//
// NOTE: The spell script must refer to the PC as PRCGetSpellTargetObject()
// otherwise this function WILL NOT WORK.  Do not make any assumptions
// about the PC being OBJECT_SELF.
void ActionCastSpellOnSelf(int iSpell, int nMetaMagic = METAMAGIC_NONE);

// This is a wrapper function that causes OBJECT_SELF to fire the defined spell
// at the defined level.  The target is automatically the object or location
// that the user selects. Useful for SLA's to perform the casting of a true
// spell.  This is useful because:
//
// 1) If the original's spell script is updated, so is this one.
// 2) The spells are identified as the true spell.  That is, they ARE the true spell.
// 3) Spellhooks (such as item crafting) that can only identify true spells
//    will easily work.
//
// This function should only be used when SLA's are meant to simulate true
// spellcasting abilities, such as those seen when using feats with subradials
// to simulate spellbooks.
void ActionCastSpell(int iSpell, int iCasterLev = 0, int iBaseDC = 0, int iTotalDC = 0,
    int nMetaMagic = METAMAGIC_NONE, int nClass = CLASS_TYPE_INVALID,
    int bUseOverrideTargetLocation=FALSE, int bUseOverrideTargetObject=FALSE, object oOverrideTarget=OBJECT_INVALID);

/**
 * Checks if target is a Frenzied Bersker with Deathless Frenzy Active
 * If so removes immortality flag so that Death Spell can kill them
 *
 * @param oTarget Creature to test for Deathless Frenzy
 */
void DeathlessFrenzyCheck(object oTarget);

/**
 * A PRC wrapper for GetCreatureSize that takes size adjustment
 * feats into account.
 *
 * @param oObject Creature whose size to get
 * @param nAbilityAdjust Int if TRUE, it will only take into account things that affect abiliy scores as well as size
 * @return        CREATURE_SIZE_* constant
 */
int PRCGetCreatureSize(object oObject = OBJECT_SELF, int nAbilityAdjust = FALSE);


//this is here rather than inc_utility because it uses creature size and screws compiling if its elsewhere
/**
 * Returns the skill rank adjusted according to the given parameters.
 * Using the default values, the result is the same as using GetSkillRank().
 *
 * @param oObject     subject to get skill of
 * @param nSkill      SKILL_* constant
 * @param bSynergy    include any applicable synergy bonus
 * @param bSize       include any applicable size bonus
 * @param bAbilityMod include relevant ability modification (including effects on that ability)
 * @param bEffect     include skill changing effects and itemproperties
 * @param bArmor      include armor mod if applicable (excluding shield)
 * @param bShield     include shield mod if applicable (excluding armor)
 * @param bFeat       include any applicable feats, including racial ones
 *
 * @return            subject's rank in the given skill, modified according to
 *                    the above parameters. If the skill is trained-only and the
 *                    subject does not have any ranks in it, returns 0.
 */
int GetSkill(object oObject, int nSkill, int bSynergy = FALSE, int bSize = FALSE,
             int bAbilityMod = TRUE, int bEffect = TRUE, int bArmor = TRUE,
             int bShield = TRUE, int bFeat = TRUE);

/**
 * Checks whether the given creature is committing an action, or
 * under such effects that cause a breach of concentration.
 *
 * @param oConcentrator The creature to test
 * @return              TRUE if concentration is broken, FALSE otherwise
 */
int GetBreakConcentrationCheck(object oConcentrator);

/**
 * Gets a creature that can apply an effect
 * Useful to apply/remove specific effects rather than using spellID
 * Remember to assigncommand the effect creation
 */
object GetObjectToApplyNewEffect(string sTag, object oPC, int nStripEffects = TRUE);

//////////////////////////////////////////////////
/* Include section                              */
//////////////////////////////////////////////////

// Generic includes
#include "inc_item_props"
#include "inc_utility"
#include "prc_inc_spells"
#include "prcsp_engine"
#include "x2_inc_switches"
#include "prc_feat_const"
#include "prc_class_const"
#include "prc_spell_const"
#include "prc_racial_const"
#include "prc_ipfeat_const"
#include "prc_misc_const"
#include "inc_acp"
//#include "prc_inc_leadersh"


// PRC Spell Engine Utility Functions
#include "lookup_2da_spell"
#include "prcsp_reputation"
#include "prcsp_archmaginc"
#include "prcsp_spell_adjs"
//#include "prc_inc_clsfunc"
#include "prc_inc_racial"
#include "inc_abil_damage"
#include "NW_I0_GENERIC"
#include "prc_inc_combat"
#include "inc_lookups"
#include "x0_I0_spells"
//#include "x2_i0_spells"
//#include "prc_inc_s_det"



//////////////////////////////////////////////////
/* Function Definitions                         */
//////////////////////////////////////////////////

void ActionCastSpellOnSelf(int iSpell, int nMetaMagic = METAMAGIC_NONE)
{
    object oCastingObject = CreateObject(OBJECT_TYPE_PLACEABLE, "x0_rodwonder", GetLocation(OBJECT_SELF));
    object oTarget = OBJECT_SELF;

    AssignCommand(oCastingObject, ActionCastSpellAtObject(iSpell, oTarget, nMetaMagic, TRUE, 0, PROJECTILE_PATH_TYPE_DEFAULT, TRUE));

    DestroyObject(oCastingObject, 6.0);
}

void ActionCastSpell(int iSpell, int iCasterLev = 0, int iBaseDC = 0, int iTotalDC = 0,
    int nMetaMagic = METAMAGIC_NONE, int nClass = CLASS_TYPE_INVALID,
    int bUseOverrideTargetLocation=FALSE, int bUseOverrideTargetObject=FALSE, object oOverrideTarget=OBJECT_INVALID)
{

    if(DEBUG) DoDebug("ActionCastSpell SpellId: " + IntToString(iSpell));
    if(DEBUG) DoDebug("ActionCastSpell Caster Level: " + IntToString(iCasterLev));
    if(DEBUG) DoDebug("ActionCastSpell Base DC: " + IntToString(iBaseDC));
    if(DEBUG) DoDebug("ActionCastSpell Total DC: " + IntToString(iTotalDC));
    if(DEBUG) DoDebug("ActionCastSpell Metamagic: " + IntToString(nMetaMagic));
    if(DEBUG) DoDebug("ActionCastSpell Caster Class: " + IntToString(nClass));

    //if its a hostile spell, clear the action queue
    //this stops people stacking hostile spells to be instacast
    //at the end, for example when coming out of invisibility
    if(Get2DACache("spells", "HostileSetting", iSpell) == "1")
        ClearAllActions();

    object oTarget = PRCGetSpellTargetObject();
    location lLoc = PRCGetSpellTargetLocation();

    //set the overriding values
    if (iCasterLev != 0)
        ActionDoCommand(SetLocalInt(OBJECT_SELF, PRC_CASTERLEVEL_OVERRIDE, iCasterLev));
    if (iTotalDC != 0)
        ActionDoCommand(SetLocalInt(OBJECT_SELF, PRC_DC_TOTAL_OVERRIDE, iTotalDC));
    if (iBaseDC != 0)
        ActionDoCommand(SetLocalInt(OBJECT_SELF, PRC_DC_BASE_OVERRIDE, iBaseDC));
    if (nClass != CLASS_TYPE_INVALID)
        ActionDoCommand(SetLocalInt(OBJECT_SELF, PRC_CASTERCLASS_OVERRIDE, nClass));
    if (nMetaMagic != METAMAGIC_NONE)
        ActionDoCommand(SetLocalInt(OBJECT_SELF, PRC_METAMAGIC_OVERRIDE, nMetaMagic));
    if (bUseOverrideTargetLocation)
    {
        ActionDoCommand(SetLocalInt(OBJECT_SELF, PRC_SPELL_TARGET_LOCATION_OVERRIDE, TRUE));
        //location must be set outside of this function at the moment
        //cant pass a location into a function as an optional parameter
        //go bioware for not defining an invalid location constant
    }
    if (bUseOverrideTargetObject)
    {
        ActionDoCommand(SetLocalInt(OBJECT_SELF, PRC_SPELL_TARGET_OBJECT_OVERRIDE, TRUE));
        ActionDoCommand(SetLocalObject(OBJECT_SELF, PRC_SPELL_TARGET_OBJECT_OVERRIDE, oTarget));
    }
    SetLocalInt(OBJECT_SELF, "UsingActionCastSpell", TRUE);
    DelayCommand(1.0, DeleteLocalInt(OBJECT_SELF, "UsingActionCastSpell"));

    //cast the spell
    if (GetIsObjectValid(oOverrideTarget))
        ActionCastSpellAtObject(iSpell, oOverrideTarget, nMetaMagic, TRUE, 0, PROJECTILE_PATH_TYPE_DEFAULT, TRUE);
    else if (GetIsObjectValid(oTarget))
        ActionCastSpellAtObject(iSpell, oTarget, nMetaMagic, TRUE, 0, PROJECTILE_PATH_TYPE_DEFAULT, TRUE);
    else
        ActionCastSpellAtLocation(iSpell, lLoc, nMetaMagic, TRUE, PROJECTILE_PATH_TYPE_DEFAULT, TRUE);

    //clean up afterwards
    if (iCasterLev != 0)
        DelayCommand(2.0, DeleteLocalInt(OBJECT_SELF, PRC_CASTERLEVEL_OVERRIDE));
    if (iTotalDC != 0)
        DelayCommand(2.0, DeleteLocalInt(OBJECT_SELF, PRC_DC_TOTAL_OVERRIDE));
    if (iBaseDC != 0)
        DelayCommand(2.0, DeleteLocalInt(OBJECT_SELF, PRC_DC_BASE_OVERRIDE));
    if (nClass != CLASS_TYPE_INVALID)
        DelayCommand(2.0, DeleteLocalInt(OBJECT_SELF, PRC_CASTERCLASS_OVERRIDE));
    if (nMetaMagic != METAMAGIC_NONE)
        DelayCommand(2.0, DeleteLocalInt(OBJECT_SELF, PRC_METAMAGIC_OVERRIDE));
    if (bUseOverrideTargetLocation)
    {
        DelayCommand(2.0, DeleteLocalInt(OBJECT_SELF, PRC_SPELL_TARGET_LOCATION_OVERRIDE));
        //location must be set outside of this function at the moment
        //cant pass a location into a function as an optional parameter
        //go bioware for not defining an invalid location constant
    }
    if (bUseOverrideTargetObject)
    {
        DelayCommand(2.0, DeleteLocalInt(OBJECT_SELF, PRC_SPELL_TARGET_OBJECT_OVERRIDE));
        DelayCommand(2.0, DeleteLocalObject(OBJECT_SELF, PRC_SPELL_TARGET_OBJECT_OVERRIDE));
    }


/*
//The problem with this approace is that the effects are then applies by the original spell, which could go wrong. What to do?
    SetLocalInt(OBJECT_SELF, PRC_SPELLID_OVERRIDE, GetSpellId());
    DelayCommand(1.0, DeleteLocalInt(OBJECT_SELF, PRC_SPELLID_OVERRIDE));
    string sScript = Get2DACache("spells", "ImpactScript", iSpell);
    ExecuteScript(sScript, OBJECT_SELF);
*/
}

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
int PRCGetCreatureSize(object oObject = OBJECT_SELF, int nAbilityAdjust = FALSE)
{
    int nSize = GetCreatureSize(oObject);
    if(GetHasFeat(FEAT_SIZE_DECREASE_6, oObject))
        nSize += -6;
    else if(GetHasFeat(FEAT_SIZE_DECREASE_5, oObject))
        nSize += -5;
    else if(GetHasFeat(FEAT_SIZE_DECREASE_4, oObject))
        nSize += -4;
    else if(GetHasFeat(FEAT_SIZE_DECREASE_3, oObject))
        nSize += -3;
    else if(GetHasFeat(FEAT_SIZE_DECREASE_2, oObject))
        nSize += -2;
    else if(GetHasFeat(FEAT_SIZE_DECREASE_1, oObject))
        nSize += -1;

    if(GetHasFeat(FEAT_SIZE_INCREASE_6, oObject))
        nSize +=  6;
    else if(GetHasFeat(FEAT_SIZE_INCREASE_5, oObject))
        nSize +=  5;
    else if(GetHasFeat(FEAT_SIZE_INCREASE_4, oObject))
        nSize +=  4;
    else if(GetHasFeat(FEAT_SIZE_INCREASE_3, oObject))
        nSize +=  3;
    else if(GetHasFeat(FEAT_SIZE_INCREASE_2, oObject))
        nSize +=  2;
    else if(GetHasFeat(FEAT_SIZE_INCREASE_1, oObject))
        nSize +=  1;

    if(!nAbilityAdjust
        || GetPRCSwitch(PRC_DRAGON_DISCIPLE_SIZE_CHANGES))
    {
        if(GetHasFeat(FEAT_DRACONIC_SIZE_INCREASE_2, oObject))
            nSize +=  2;
        else if(GetHasFeat(FEAT_DRACONIC_SIZE_INCREASE_1, oObject))
            nSize +=  1;
    }

    if(!nAbilityAdjust)
    {
        // Size changing powers
        // Compression: Size decreased by one or two categories, depending on augmentation
        if(GetLocalInt(oObject, "PRC_Power_Compression_SizeReduction"))
            nSize -= GetLocalInt(oObject, "PRC_Power_Compression_SizeReduction");
        // Expansion: Size increase by one or two categories, depending on augmentation
        if(GetLocalInt(oObject, "PRC_Power_Expansion_SizeIncrease"))
            nSize += GetLocalInt(oObject, "PRC_Power_Expansion_SizeIncrease");
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
        if(nSkill == SKILL_HIDE)//only hide is affected by size
            nSkillRank += (PRCGetCreatureSize(oObject)-3)*(-4);
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
                if(GetHasFeat(FEAT_BARDIC_KNOWLEDGE, oObject))
                    nSkillMod += GetLevelByClass(CLASS_TYPE_BARD, oObject)
                        +GetLevelByClass(CLASS_TYPE_HARPER, oObject);
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

int GetBreakConcentrationCheck(object oConcentrator)
{
    int nAction = GetCurrentAction(oConcentrator);
    // creature doing anything that requires attention and breaks concentration
    if (nAction == ACTION_DISABLETRAP  || nAction == ACTION_TAUNT        ||
        nAction == ACTION_PICKPOCKET   || nAction == ACTION_ATTACKOBJECT ||
        nAction == ACTION_COUNTERSPELL || nAction == ACTION_FLAGTRAP     ||
        nAction == ACTION_CASTSPELL    || nAction == ACTION_ITEMCASTSPELL)
    {
        return TRUE;
    }
    //suffering a mental effect
    effect e1 = GetFirstEffect(oConcentrator);
    int nType;
    while (GetIsEffectValid(e1))
    {
        nType = GetEffectType(e1);
        if (nType == EFFECT_TYPE_STUNNED   || nType == EFFECT_TYPE_PARALYZE   ||
            nType == EFFECT_TYPE_SLEEP     || nType == EFFECT_TYPE_FRIGHTENED ||
            nType == EFFECT_TYPE_PETRIFY   || nType == EFFECT_TYPE_CONFUSED   ||
            nType == EFFECT_TYPE_DOMINATED || nType == EFFECT_TYPE_POLYMORPH)
        {
            return TRUE;
        }
        e1 = GetNextEffect(oConcentrator);
    }
    return FALSE;
}


object GetObjectToApplyNewEffect(string sTag, object oPC, int nStripEffects = TRUE)
{
    object oWP = GetObjectByTag(sTag);
    object oLimbo = GetObjectByTag("HEARTOFCHAOS");
    location lLimbo = GetLocation(oLimbo);
    if(!GetIsObjectValid(oLimbo))
        lLimbo = GetStartingLocation();
    //not valid, create it
    if(!GetIsObjectValid(oWP))
    {
        //has to be a creature so it can be jumped around
        //re-used the 2da cache blueprint since it has no scripts
        oWP = CreateObject(OBJECT_TYPE_CREATURE, "prc_2da_cache", lLimbo, FALSE, sTag);
    }
    if(!GetIsObjectValid(oWP)
        && DEBUG)
    {
        DoDebug(sTag+" is not valid");
    }
    //make sure the player can never interact with WP
    SetPlotFlag(oWP, TRUE);
    SetCreatureAppearanceType(oWP, APPEARANCE_TYPE_INVISIBLE_HUMAN_MALE);
    ApplyEffectToObject(DURATION_TYPE_PERMANENT, EffectVisualEffect(VFX_DUR_CUTSCENE_INVISIBILITY), oWP);
    ApplyEffectToObject(DURATION_TYPE_PERMANENT, EffectCutsceneGhost(), oWP);
    //remove previous effects
    if(nStripEffects)
    {
        effect eTest = GetFirstEffect(oPC);
        while(GetIsEffectValid(eTest))
        {
            if(GetEffectCreator(eTest) == oWP
                && GetEffectSubType(eTest) == SUBTYPE_SUPERNATURAL)
            {   
                if(DEBUG) DoDebug("Stripping previous effect");
                RemoveEffect(oPC, eTest);
            }    
            eTest = GetNextEffect(oPC);
        }
    }
    //jump to PC
    //must be in same area to apply effect
    if(GetArea(oWP) != GetArea(oPC))
        AssignCommand(oWP, 
            ActionJumpToObject(oPC));
    return oWP;     
}


// Test main
//void main(){}

