//::///////////////////////////////////////////////
//:: PRC Prerequisites
//:: prc_prereq.nss
//:://////////////////////////////////////////////
//:: Check to see what classes a PC is capable of taking.
//:://////////////////////////////////////////////
//:: Created By: Stratovarius.
//:: Created On: July 3rd, 2004
//:://////////////////////////////////////////////
#include "prc_alterations"
#include "prc_inc_sneak"
#include "psi_inc_psifunc"
#include "inc_newspellbook"
#include "prc_allow_const"

// this creates a clone of the PC in limbo, removes the effects and equipment,
// then stores the results of a ability score query onto the PC's hide.
void FindTrueAbilityScoresPhaseTwo(object oPC, object oClone);
void FindTrueAbilityScores()
{
    object oPC = OBJECT_SELF;
    int i = 0;
    int bFoundLimbo = FALSE;
    object oLimbo = GetObjectByTag("Limbo",i);
    location lLimbo;
    while(!bFoundLimbo && i < 100)
    {
        if (GetIsObjectValid(oLimbo))
        {
            if (GetName(oLimbo) == "Limbo")
            {
                bFoundLimbo = TRUE;
                lLimbo = Location(oLimbo, Vector(0.0f, 0.0f, 0.0f), 0.0f);
                break;
            }
        }
        i++;
        object oLimbo = GetObjectByTag("Limbo",i);
    }
    //create copy of the PC for getting base ability scores
    object oClone;
    if(bFoundLimbo)
    {
        oClone = CopyObject(oPC, lLimbo, OBJECT_INVALID, "PRC_AbilityScore_Clone_" + ObjectToString(oPC));
    }
    else
    {
        // create a clone but make it completely uninteractive
        oClone = CopyObject(oPC, GetLocation(oPC), OBJECT_INVALID, "PRC_AbilityScore_Clone_" + ObjectToString(oPC));
        effect eClone = EffectVisualEffect(VFX_DUR_CUTSCENE_INVISIBILITY);
               eClone = EffectLinkEffects(eClone, EffectCutsceneGhost());
               eClone = SupernaturalEffect(eClone);
        DelayCommand(0.1, ApplyEffectToObject(DURATION_TYPE_PERMANENT, eClone, oClone));
    }

    ChangeToStandardFaction(oClone, STANDARD_FACTION_MERCHANT);

    object oItem;
    int nSlot;

    for (nSlot = 0 ; nSlot < NUM_INVENTORY_SLOTS ; nSlot++)
    {
        oItem = GetItemInSlot(nSlot, oClone);
        //remove if valid, unless in the creature hide slot
        if (GetIsObjectValid(oItem)) // && nSlot != INVENTORY_SLOT_CARMOUR) -- I'd rather play it safe.
        {
            DestroyObject(oItem);
        }
    }

    effect eEffect = GetFirstEffect(oClone);
    while (GetIsEffectValid(eEffect))
    {
        RemoveEffect(oClone, eEffect);
        eEffect = GetNextEffect(oClone);
    }

    DelayCommand(0.5, FindTrueAbilityScoresPhaseTwo(oPC, oClone));
    DelayCommand(3.0, DestroyObject(oClone));
}

void FindTrueAbilityScoresPhaseTwo(object oPC, object oClone)
{
    int i;

    int iStr = GetAbilityScore(oClone, ABILITY_STRENGTH);
    int iDex = GetAbilityScore(oClone, ABILITY_DEXTERITY);
    int iCon = GetAbilityScore(oClone, ABILITY_CONSTITUTION);
    int iInt = GetAbilityScore(oClone, ABILITY_INTELLIGENCE);
    int iWis = GetAbilityScore(oClone, ABILITY_WISDOM);
    int iCha = GetAbilityScore(oClone, ABILITY_CHARISMA);

    // hack - the clone gets double the benefit from the Epic Great Attribute feats
    for (i = FEAT_EPIC_GREAT_STRENGTH_1 ; i <= FEAT_EPIC_GREAT_STRENGTH_10 ; i++) if (GetHasFeat(i, oPC)) iStr--;
    for (i = FEAT_EPIC_GREAT_DEXTERITY_1 ; i <= FEAT_EPIC_GREAT_DEXTERITY_10 ; i++) if (GetHasFeat(i, oPC)) iDex--;
    for (i = FEAT_EPIC_GREAT_CONSTITUTION_1 ; i <= FEAT_EPIC_GREAT_CONSTITUTION_10 ; i++) if (GetHasFeat(i, oPC)) iCon--;
    for (i = FEAT_EPIC_GREAT_INTELLIGENCE_1 ; i <= FEAT_EPIC_GREAT_INTELLIGENCE_10 ; i++) if (GetHasFeat(i, oPC)) iInt--;
    for (i = FEAT_EPIC_GREAT_WISDOM_1 ; i <= FEAT_EPIC_GREAT_WISDOM_10 ; i++) if (GetHasFeat(i, oPC)) iWis--;
    for (i = FEAT_EPIC_GREAT_CHARISMA_1 ; i <= FEAT_EPIC_GREAT_CHARISMA_10 ; i++) if (GetHasFeat(i, oPC)) iCha--;

    object oHide = GetPCSkin(oPC);

    SetLocalInt(oHide, "PRC_trueSTR", iStr);
    SetLocalInt(oHide, "PRC_trueDEX", iDex);
    SetLocalInt(oHide, "PRC_trueCON", iCon);
    SetLocalInt(oHide, "PRC_trueINT", iInt);
    SetLocalInt(oHide, "PRC_trueWIS", iWis);
    SetLocalInt(oHide, "PRC_trueCHA", iCha);
}

void SneakRequirement(object oPC)
{
   int iSneak = GetTotalSneakAttackDice(oPC);
   int iCount;
   string sVariable;

   for (iCount = 1; iCount <= 30; iCount++)
   {
      sVariable = "PRC_SneakLevel" + IntToString(iCount);
      if (iSneak >= iCount)
         SetLocalInt(oPC, sVariable, 0);
   }
}

void Hathran(object oPC)
{

    SetLocalInt(oPC, "PRC_Female", 1);

    if (GetGender(oPC) == GENDER_FEMALE)
    {
    SetLocalInt(oPC, "PRC_Female", 0);
    }
}

void Kord(object oPC)
{
     SetLocalInt(oPC, "PRC_PrereqKord", 1);

     if (GetFortitudeSavingThrow(oPC) >= 6)
     {
        SetLocalInt(oPC, "PRC_PrereqKord", 0);
     }
}

void Shifter(object oPC, int iArcSpell, int iDivSpell)
{

     SetLocalInt(oPC, "PRC_PrereqShift", 1);

     if (GetLevelByClass(CLASS_TYPE_CLERIC, oPC) && GetHasFeat(FEAT_ANIMAL_DOMAIN_POWER, oPC) && iDivSpell >= 5)
     {
          SetLocalInt(oPC, "PRC_PrereqShift", 0);
     }
     if (GetLevelByClass(CLASS_TYPE_SORCERER, oPC) && iArcSpell >= 4)
     {
          SetLocalInt(oPC, "PRC_PrereqShift", 0);
     }
     if (GetLevelByClass(CLASS_TYPE_WIZARD, oPC) && iArcSpell >= 4)
     {
          SetLocalInt(oPC, "PRC_PrereqShift", 0);
     }
     if (GetLevelByClass(CLASS_TYPE_DRUID, oPC) >= 5)
     {
          SetLocalInt(oPC, "PRC_PrereqShift", 0);
     }
     if (GetLevelByClass(CLASS_TYPE_RANGER, oPC) >= 15)
     {
          SetLocalInt(oPC, "PRC_PrereqShift", 0);
     }
     if (GetLevelByClass(CLASS_TYPE_INITIATE_DRACONIC, oPC) >= 10)
     {
          SetLocalInt(oPC, "PRC_PrereqShift", 0);
     }
     if (GetLevelByClass(CLASS_TYPE_NINJA_SPY, oPC) >= 7)
     {
          SetLocalInt(oPC, "PRC_PrereqShift", 0);
     }
     if (GetLevelByClass(CLASS_TYPE_WEREWOLF, oPC) >= 1)
     {
          SetLocalInt(oPC, "PRC_PrereqShift", 0);
     }
     if (GetLevelByClass(CLASS_TYPE_BONDED_SUMMONNER, oPC) >= 10)
     {
          SetLocalInt(oPC, "PRC_PrereqShift", 0);
     }

     // these races have an alternate form
     if(GetRacialType(oPC) == RACIAL_TYPE_PURE_YUAN) SetLocalInt(oPC, "PRC_PrereqShift", 0);
     if(GetRacialType(oPC) == RACIAL_TYPE_ABOM_YUAN) SetLocalInt(oPC, "PRC_PrereqShift", 0);
     if(GetRacialType(oPC) == RACIAL_TYPE_PIXIE) SetLocalInt(oPC, "PRC_PrereqShift", 0);
     if(GetRacialType(oPC) == RACIAL_TYPE_RAKSHASA) SetLocalInt(oPC, "PRC_PrereqShift", 0);
     if(GetRacialType(oPC) == RACIAL_TYPE_FEYRI) SetLocalInt(oPC, "PRC_PrereqShift", 0);

     // not counted since it is just "disguise self" and not alter self or shape change
     //if(MyPRCGetRacialType(oPC) == RACIAL_TYPE_DEEP_GNOME) SetLocalInt(oPC, "PRC_PrereqShift", 0);
}

void Tempest(object oPC)
{
     SetLocalInt(oPC, "PRC_PrereqTemp", 1);

     if ((GetHasFeat(FEAT_AMBIDEXTERITY, oPC) && GetHasFeat(FEAT_TWO_WEAPON_FIGHTING, oPC)) || GetHasFeat(FEAT_RANGER_DUAL, oPC))
     {
     SetLocalInt(oPC, "PRC_PrereqTemp", 0);
     }
}

void KOTC(object oPC)
{
     SetLocalInt(oPC, "PRC_PrereqKOTC", 1);


     if (GetLevelByClass(CLASS_TYPE_CLERIC, oPC) >= 1)
     {
     SetLocalInt(oPC, "PRC_PrereqKOTC", 0);
     }
     if (GetLevelByClass(CLASS_TYPE_PALADIN, oPC) >= 4)
     {
     SetLocalInt(oPC, "PRC_PrereqKOTC", 0);
     }
}

void Shadowlord(object oPC, int iArcSpell)
{
     int iShadLevel = GetLevelByClass(CLASS_TYPE_SHADOWDANCER, oPC);

     int iShadItem;
     if(GetHasItem(oPC,"shadowwalkerstok")
        || GetPersistantLocalInt(oPC, "shadowwalkerstok"))
     {
     iShadItem = 1;
     }

     SetLocalInt(oPC, "PRC_PrereqTelflam", 1);

     if ( iArcSpell >= 4 || iShadLevel  || iShadItem)
     {
        SetLocalInt(oPC, "PRC_PrereqTelflam", 0);
     }
}

void SOL(object oPC)
{
     int iCleric = GetLevelByClass(CLASS_TYPE_CLERIC, oPC);

     SetLocalInt(oPC, "PRC_PrereqSOL", 0);
     if (GetAlignmentGoodEvil(oPC) != ALIGNMENT_GOOD)
     {
         SetLocalInt(oPC, "PRC_PrereqSOL", 1);
     }
     else if (GetAlignmentGoodEvil(oPC) == ALIGNMENT_GOOD && iCleric)
     {
          SetLocalInt(oPC, "PRC_PrereqSOL", 1);
          int iElishar = GetHasFeat(FEAT_GOOD_DOMAIN_POWER,oPC) +
                         GetHasFeat(FEAT_HEALING_DOMAIN_POWER,oPC) +
                         GetHasFeat(FEAT_KNOWLEDGE_DOMAIN_POWER,oPC) +
                         GetHasFeat(FEAT_LUCK_DOMAIN_POWER,oPC) +
                         GetHasFeat(FEAT_PROTECTION_DOMAIN_POWER,oPC) +
                         GetHasFeat(FEAT_SUN_DOMAIN_POWER,oPC);
          if (iElishar >= 2)
          {
               SetLocalInt(oPC, "PRC_PrereqSOL", 0);
          }
     }
}

void ManAtArms(object oPC)
{
    int iWF;

    // Calculate the total number of Weapon Focus feats the character has
    iWF = GetHasFeat(FEAT_WEAPON_FOCUS_BASTARD_SWORD,oPC)   +GetHasFeat(FEAT_WEAPON_FOCUS_BATTLE_AXE,oPC)  +GetHasFeat(FEAT_WEAPON_FOCUS_CLUB,oPC)+
          GetHasFeat(FEAT_WEAPON_FOCUS_DAGGER,oPC)          +GetHasFeat(FEAT_WEAPON_FOCUS_DART,oPC)        +GetHasFeat(FEAT_WEAPON_FOCUS_DIRE_MACE,oPC)+
          GetHasFeat(FEAT_WEAPON_FOCUS_DOUBLE_AXE,oPC)      +GetHasFeat(FEAT_WEAPON_FOCUS_DWAXE,oPC)       +GetHasFeat(FEAT_WEAPON_FOCUS_GREAT_AXE,oPC)+
          GetHasFeat(FEAT_WEAPON_FOCUS_GREAT_SWORD,oPC)     +GetHasFeat(FEAT_WEAPON_FOCUS_HALBERD,oPC)     +GetHasFeat(FEAT_WEAPON_FOCUS_HAND_AXE,oPC)+
          GetHasFeat(FEAT_WEAPON_FOCUS_HEAVY_CROSSBOW,oPC)  +GetHasFeat(FEAT_WEAPON_FOCUS_HEAVY_FLAIL,oPC) +GetHasFeat(FEAT_WEAPON_FOCUS_KAMA,oPC)+
          GetHasFeat(FEAT_WEAPON_FOCUS_TWO_BLADED_SWORD,oPC)+GetHasFeat(FEAT_WEAPON_FOCUS_LONG_SWORD,oPC)  +GetHasFeat(FEAT_WEAPON_FOCUS_RAPIER,oPC)+
          GetHasFeat(FEAT_WEAPON_FOCUS_KATANA,oPC)          +GetHasFeat(FEAT_WEAPON_FOCUS_KUKRI,oPC)       +GetHasFeat(FEAT_WEAPON_FOCUS_LIGHT_CROSSBOW,oPC)+
          GetHasFeat(FEAT_WEAPON_FOCUS_LIGHT_FLAIL,oPC)     +GetHasFeat(FEAT_WEAPON_FOCUS_LIGHT_HAMMER,oPC)+GetHasFeat(FEAT_WEAPON_FOCUS_LIGHT_MACE,oPC)+
          GetHasFeat(FEAT_WEAPON_FOCUS_LONGBOW,oPC)         +GetHasFeat(FEAT_WEAPON_FOCUS_MORNING_STAR,oPC)+GetHasFeat(FEAT_WEAPON_FOCUS_SCIMITAR,oPC)+
          GetHasFeat(FEAT_WEAPON_FOCUS_SCYTHE,oPC)          +GetHasFeat(FEAT_WEAPON_FOCUS_SHORT_SWORD,oPC) +GetHasFeat(FEAT_WEAPON_FOCUS_SHORTBOW,oPC)+
          GetHasFeat(FEAT_WEAPON_FOCUS_SHURIKEN,oPC)        +GetHasFeat(FEAT_WEAPON_FOCUS_SICKLE,oPC)      +GetHasFeat(FEAT_WEAPON_FOCUS_SLING,oPC)+
          GetHasFeat(FEAT_WEAPON_FOCUS_SPEAR,oPC)           +GetHasFeat(FEAT_WEAPON_FOCUS_STAFF,oPC)       +GetHasFeat(FEAT_WEAPON_FOCUS_THROWING_AXE,oPC)+
          GetHasFeat(FEAT_WEAPON_FOCUS_WAR_HAMMER,oPC)      +GetHasFeat(FEAT_WEAPON_FOCUS_MINDBLADE, oPC)  +GetHasFeat(FEAT_WEAPON_FOCUS_WHIP,oPC); //why was whip commented out?

    // If they are a soulknife, their WF Mindblade might be counting twice due to how it is implemented, so account for it if necessary
    if(GetStringLeft(GetTag(GetItemInSlot(INVENTORY_SLOT_RIGHTHAND, oPC)), 14) == "prc_sk_mblade_" ||
       GetStringLeft(GetTag(GetItemInSlot(INVENTORY_SLOT_LEFTHAND, oPC)), 14) == "prc_sk_mblade_")
        iWF--;

    SetLocalInt(oPC, "PRC_PrereqMAA", 1);

    if (iWF > 3)
    {
        SetLocalInt(oPC, "PRC_PrereqMAA", 0);
    }

    // Foe Hunters also require at least one weapon focus feat
    if (iWF > 0)
        SetLocalInt(oPC, "PRC_PrereqFH", 1);
    else
        SetLocalInt(oPC, "PRC_PrereqFH", 2);
}

void BFZ(object oPC)
{
     int iCleric = GetLevelByClass(CLASS_TYPE_CLERIC, oPC);


     if (iCleric > 0)
     {
          SetLocalInt(oPC, "PRC_PrereqBFZ", 1);
          if (GetHasFeat(FEAT_FIRE_DOMAIN_POWER,oPC) && GetHasFeat(FEAT_DESTRUCTION_DOMAIN_POWER,oPC))
          {
          SetLocalInt(oPC, "PRC_PrereqBFZ", 0);
          }
     }
}

void ShiningBlade(object oPC)
{
     int iCleric = GetLevelByClass(CLASS_TYPE_CLERIC, oPC);


     if (iCleric > 0)
     {
          SetLocalInt(oPC, "PRC_PrereqSBHeir", 1);
          if (GetHasFeat(FEAT_WAR_DOMAIN_POWER,oPC) && GetHasFeat(FEAT_GOOD_DOMAIN_POWER,oPC))
          {
          SetLocalInt(oPC, "PRC_PrereqSBHeir", 0);
          }
     }
}

void DemiLich(object oPC)
{
    SetLocalInt(oPC, "PRC_DemiLich", 0);

    if (GetPRCSwitch(PRC_DISABLE_DEMILICH) > 0 && GetLevelByClass(CLASS_TYPE_LICH) >= 4)
    {
       SetLocalInt(oPC, "PRC_DemiLich", 1); //reverse logic.  1 means don't allow.
    }
}

void EOG(object oPC)
{
     int iCleric = GetLevelByClass(CLASS_TYPE_CLERIC, oPC);


     if (iCleric)
     {
     SetLocalInt(oPC, "PRC_PrereqEOG", 1);
     int iEOG = GetHasFeat(FEAT_WAR_DOMAIN_POWER,oPC)
        +GetHasFeat(FEAT_STRENGTH_DOMAIN_POWER,oPC)
        +GetHasFeat(FEAT_EVIL_DOMAIN_POWER,oPC);
          {
          if (iEOG>1)
               {
               SetLocalInt(oPC, "PRC_PrereqEOG", 0);
               }
          }
     }
}

void Stormlord(object oPC)
{
     int iCleric = GetLevelByClass(CLASS_TYPE_CLERIC, oPC);


     if (iCleric)
     {
     SetLocalInt(oPC, "PRC_PrereqStormL", 1);
     int iStorm = GetHasFeat(FEAT_FIRE_DOMAIN_POWER,oPC)+GetHasFeat(FEAT_DESTRUCTION_DOMAIN_POWER,oPC)+GetHasFeat(FEAT_EVIL_DOMAIN_POWER,oPC);
          {
          if (iStorm>1)
               {
               SetLocalInt(oPC, "PRC_PrereqStormL", 0);
               }
          }
     }
}

void Blightlord(object oPC)
{
     int iCleric = GetLevelByClass(CLASS_TYPE_CLERIC, oPC);


     if (iCleric)
     {
     SetLocalInt(oPC, "PRC_PrereqBlightL", 1);
     int iBlight = GetHasFeat(FEAT_DESTRUCTION_DOMAIN_POWER,oPC)+GetHasFeat(FEAT_EVIL_DOMAIN_POWER,oPC);
          {
          if (iBlight>1)
               {
               SetLocalInt(oPC, "PRC_PrereqBlightL", 0);
               }
          }
     }
}

void ShadowAdept(object oPC)
{
     int iCleric = GetLevelByClass(CLASS_TYPE_CLERIC, oPC);


     if (iCleric)
     {
     SetLocalInt(oPC, "PRC_PrereqShadAd", 1);
     int iShad = GetHasFeat(FEAT_EVIL_DOMAIN_POWER,oPC)+GetHasFeat(FEAT_KNOWLEDGE_DOMAIN_POWER,oPC)+GetHasFeat(FEAT_DARKNESS_DOMAIN,oPC);
          {
          if (iShad>1)
               {
               SetLocalInt(oPC, "PRC_PrereqShadAd", 0);
               }
          }
     }
}

void ThrallOfGrazzt(object oPC)
{
     int iCleric = GetLevelByClass(CLASS_TYPE_CLERIC, oPC);

     if (iCleric)
     {
          SetLocalInt(oPC, "PRC_PrereqTOG", 1);
          int iThrall = GetHasFeat(FEAT_EVIL_DOMAIN_POWER,oPC)+GetHasFeat(FEAT_DARKNESS_DOMAIN,oPC);
          {
          if (iThrall>1)
               {
               SetLocalInt(oPC, "PRC_PrereqTOG", 0);
               }
          }
     }
}

void Rava(object oPC)
{
    SetLocalInt(oPC, "PRC_PreReq_Rava", 1);

    if(GetAlignmentLawChaos(oPC) == ALIGNMENT_CHAOTIC && GetAlignmentGoodEvil(oPC) == ALIGNMENT_NEUTRAL)
    {
        SetLocalInt(oPC, "PRC_PreReq_Rava", 0);
    }

    if(GetAlignmentLawChaos(oPC) == ALIGNMENT_CHAOTIC && GetAlignmentGoodEvil(oPC) == ALIGNMENT_EVIL)
    {
        SetLocalInt(oPC, "PRC_PreReq_Rava", 0);
    }

    if(GetAlignmentLawChaos(oPC) == ALIGNMENT_NEUTRAL && GetAlignmentGoodEvil(oPC) == ALIGNMENT_EVIL)
    {
        SetLocalInt(oPC, "PRC_PreReq_Rava", 0);
    }
}
void WWolf(object oPC)
{
    //If not a natural lycanthrope or not already leveled in werewolf, prevent the player from taking the werewolf class
    if (!GetHasFeat(FEAT_TRUE_LYCANTHROPE, oPC) || GetLevelByClass(CLASS_TYPE_WEREWOLF, oPC) < 1)
    {
        SetLocalInt(oPC, "PRC_PrereqWWolf", 1);
    }

    //If not a natural lycanthrope or not already leveled in werewolf, prevent the player from taking the werewolf class
    if (GetHasFeat(FEAT_TRUE_LYCANTHROPE, oPC))
    {
        SetLocalInt(oPC, "PRC_PrereqWWolf", 0);
    }
}

void Maester(object oPC)
{

    SetLocalInt(oPC, "PRC_PrereqMaester", 1);

    int iFeat;

    iFeat =       GetHasFeat(FEAT_BREW_POTION, oPC)
            + GetHasFeat(FEAT_CRAFT_WAND, oPC)
            + GetHasFeat(FEAT_SCRIBE_SCROLL, oPC)
            + GetHasFeat(FEAT_CRAFT_WONDROUS, oPC)
            + GetHasFeat(FEAT_CRAFT_ARMS_ARMOR, oPC)
            + GetHasFeat(FEAT_CRAFT_ROD, oPC)
            + GetHasFeat(FEAT_CRAFT_STAFF, oPC)
            + GetHasFeat(FEAT_FORGE_RING, oPC)
            + GetHasFeat(FEAT_CRAFT_CONSTRUCT, oPC);

    int nSkill = FALSE;

    // No Int bonus to skills, just want the base ranks (and yes I know this allows items at the moment)
    if ((GetSkillRank(SKILL_CRAFT_ARMOR, oPC) - GetAbilityModifier(ABILITY_INTELLIGENCE, oPC)) >= 8) nSkill = TRUE;
    if ((GetSkillRank(SKILL_CRAFT_TRAP, oPC) - GetAbilityModifier(ABILITY_INTELLIGENCE, oPC)) >= 8) nSkill = TRUE;
    if ((GetSkillRank(SKILL_CRAFT_WEAPON, oPC) - GetAbilityModifier(ABILITY_INTELLIGENCE, oPC)) >= 8) nSkill = TRUE;

    // At least two crafting feats
    if (iFeat >= 2 && nSkill)
    {
        SetLocalInt(oPC, "PRC_PrereqMaester", 0);
    }
}

void CombatMedic(object oPC)
{
    /* The combat medic can only be taken if the player is able to cast Cure Light Wounds.
     * Base classes:
     * With druids and clerics, that's no problem - they get it at first level. Paladins and
     * rangers are a bit more complicated, due to their bonus spells and later spell gains.
     * Prestige classes:
     * Currently, BioWare Blackguard, Knight of the Middle Circle, Ocular Adept and Soldier
     * of Light can cast CLW.
     */

    SetLocalInt(oPC, "PRC_PrereqCbtMed", 1);
    object oSkin = GetPCSkin(oPC);
    int iWis = GetLocalInt(oSkin, "PRC_trueWIS");

    if (GetLevelByClass(CLASS_TYPE_CLERIC) || GetLevelByClass(CLASS_TYPE_DRUID))
    {
        SetLocalInt(oPC, "PRC_PrereqCbtMed", 0);
        return;
    }

    if (GetLevelByClass(CLASS_TYPE_PALADIN))
    {
        if(iWis > 11 && GetLevelByClass(CLASS_TYPE_PALADIN) >= 4)
        {
            SetLocalInt(oPC, "PRC_PrereqCbtMed", 0);
            return;
        }
        else if (GetLevelByClass(CLASS_TYPE_PALADIN) >= 6)
        {
            SetLocalInt(oPC, "PRC_PrereqCbtMed", 0);
            return;
        }
    }

    if (GetLevelByClass(CLASS_TYPE_RANGER))
    {
            if(iWis > 11 && GetLevelByClass(CLASS_TYPE_RANGER) >= 4)
            {
                SetLocalInt(oPC, "PRC_PrereqCbtMed", 0);
                return;
            }
            else if (GetLevelByClass(CLASS_TYPE_RANGER) >= 6)
            {
                SetLocalInt(oPC, "PRC_PrereqCbtMed", 0);
                return;
            }
    }

    if (GetLevelByClass(CLASS_TYPE_OCULAR))
    {
        SetLocalInt(oPC, "PRC_PrereqCbtMed", 0);
        return;
    }

    if (GetLevelByClass(CLASS_TYPE_BLACKGUARD) || GetLevelByClass(CLASS_TYPE_KNIGHT_MIDDLECIRCLE)
     || GetLevelByClass(CLASS_TYPE_SOLDIER_OF_LIGHT))
    {
        if (iWis > 11 && (GetLevelByClass(CLASS_TYPE_BLACKGUARD) || GetLevelByClass(CLASS_TYPE_SOLDIER_OF_LIGHT)
          || GetLevelByClass(CLASS_TYPE_KNIGHT_MIDDLECIRCLE)))
        {
            SetLocalInt(oPC, "PRC_PrereqCbtMed", 0);
            return;
        }
        else if (GetLevelByClass(CLASS_TYPE_BLACKGUARD) >= 2 || GetLevelByClass(CLASS_TYPE_SOLDIER_OF_LIGHT >= 2)
               || GetLevelByClass(CLASS_TYPE_KNIGHT_MIDDLECIRCLE) >= 3)
        {
            SetLocalInt(oPC, "PRC_PrereqCbtMed", 0);
        }
    }
}

void RedWizard(object oPC)
{

    SetLocalInt(oPC, "PRC_PrereqRedWiz", 1);

    int iFeat;
    int iFocus;

    iFocus = GetHasFeat(FEAT_RW_TF_ABJ, oPC)+GetHasFeat(FEAT_RW_TF_CON, oPC)+GetHasFeat(FEAT_RW_TF_DIV, oPC)+
             GetHasFeat(FEAT_RW_TF_ENC, oPC)+GetHasFeat(FEAT_RW_TF_EVO, oPC)+GetHasFeat(FEAT_RW_TF_ILL, oPC)+
             GetHasFeat(FEAT_RW_TF_NEC, oPC)+GetHasFeat(FEAT_RW_TF_TRS, oPC);

    iFeat = GetHasFeat(FEAT_ARCANE_DEFENSE_ABJURATION, oPC)             + GetHasFeat(FEAT_ARCANE_DEFENSE_CONJURATION, oPC) +
            GetHasFeat(FEAT_ARCANE_DEFENSE_DIVINATION, oPC)             + GetHasFeat(FEAT_ARCANE_DEFENSE_ENCHANTMENT, oPC) +
            GetHasFeat(FEAT_ARCANE_DEFENSE_EVOCATION, oPC)              + GetHasFeat(FEAT_ARCANE_DEFENSE_ILLUSION, oPC) +
            GetHasFeat(FEAT_ARCANE_DEFENSE_NECROMANCY, oPC)             + GetHasFeat(FEAT_ARCANE_DEFENSE_TRANSMUTATION, oPC) +
            GetHasFeat(FEAT_BREW_POTION, oPC)                           + GetHasFeat(FEAT_CRAFT_WAND, oPC) +
            GetHasFeat(FEAT_EMPOWER_SPELL, oPC)                         + GetHasFeat(FEAT_COMBAT_CASTING, oPC) +
            GetHasFeat(FEAT_EXTEND_SPELL, oPC)                          + GetHasFeat(FEAT_FOCUSED_SPELL_PENETRATION_ABJURATION, oPC) +
            GetHasFeat(FEAT_FOCUSED_SPELL_PENETRATION_CONJURATION, oPC) + GetHasFeat(FEAT_FOCUSED_SPELL_PENETRATION_DIVINATION, oPC) +
            GetHasFeat(FEAT_FOCUSED_SPELL_PENETRATION_ENCHATMENT, oPC)  + GetHasFeat(FEAT_FOCUSED_SPELL_PENETRATION_EVOCATION, oPC) +
            GetHasFeat(FEAT_FOCUSED_SPELL_PENETRATION_ILLUSION, oPC)    + GetHasFeat(FEAT_FOCUSED_SPELL_PENETRATION_NECROMANCY, oPC) +
            GetHasFeat(FEAT_FOCUSED_SPELL_PENETRATION_TRANSMUTATION, oPC) + GetHasFeat(FEAT_GREATER_SPELL_FOCUS_ABJURATION, oPC) +
            GetHasFeat(FEAT_GREATER_SPELL_FOCUS_CONJURATION, oPC)       + GetHasFeat(FEAT_GREATER_SPELL_FOCUS_DIVINIATION, oPC) +
            GetHasFeat(FEAT_GREATER_SPELL_FOCUS_ENCHANTMENT, oPC)       + GetHasFeat(FEAT_GREATER_SPELL_FOCUS_EVOCATION, oPC) +
            GetHasFeat(FEAT_GREATER_SPELL_FOCUS_ILLUSION, oPC)          + GetHasFeat(FEAT_GREATER_SPELL_FOCUS_NECROMANCY, oPC) +
            GetHasFeat(FEAT_GREATER_SPELL_FOCUS_TRANSMUTATION, oPC)     + GetHasFeat(FEAT_GREATER_SPELL_PENETRATION, oPC) +
            GetHasFeat(FEAT_MAXIMIZE_SPELL, oPC)                        + GetHasFeat(FEAT_PRACTISED_SPELLCASTER_WIZARD, oPC) +
            GetHasFeat(FEAT_QUICKEN_SPELL, oPC)                         + GetHasFeat(FEAT_SCRIBE_SCROLL, oPC) +
            GetHasFeat(FEAT_SPELL_FOCUS_ABJURATION, oPC)                + GetHasFeat(FEAT_SPELL_FOCUS_CONJURATION, oPC) +
            GetHasFeat(FEAT_SPELL_FOCUS_DIVINATION, oPC)                + GetHasFeat(FEAT_SPELL_FOCUS_ENCHANTMENT, oPC) +
            GetHasFeat(FEAT_SPELL_FOCUS_EVOCATION, oPC)                 + GetHasFeat(FEAT_SPELL_FOCUS_ILLUSION, oPC) +
            GetHasFeat(FEAT_SPELL_FOCUS_NECROMANCY, oPC)                + GetHasFeat(FEAT_SPELL_FOCUS_TRANSMUTATION, oPC) +
            GetHasFeat(FEAT_SPELL_PENETRATION, oPC)                     + GetHasFeat(FEAT_STILL_SPELL, oPC);


    // At least two arcane feats, one tattoo focus
    if (iFeat > 2 && iFocus == 1)
    {
        SetLocalInt(oPC, "PRC_PrereqRedWiz", 0);
    }
}

void FH(object oPC)
{
    int iRanger  = GetLevelByClass(CLASS_TYPE_RANGER, oPC);
    int iURanger = GetLevelByClass(CLASS_TYPE_ULTIMATE_RANGER, oPC);

    // Required that ManAtArms evaluation has happened already. Part of
    // the Foe Hunter prereqs are determined there
    int iPrereq = GetLocalInt(oPC, "PRC_PrereqFH");

    if ( iRanger > 0 || iURanger > 1 )
    {
        SetLocalInt(oPC, "PRC_PrereqFH", iPrereq - 1);
    }
}

void BloodArcher(object oPC)
{
    SetLocalInt(oPC, "PRC_PrereqBlArch", 0);

    if (MyPRCGetRacialType(oPC) == RACIAL_TYPE_ELF)
        SetLocalInt(oPC, "PRC_PrereqBlArch", 1);
}

void Alaghar(object oPC)
{
    int iProperDomains = 0;

    SetLocalInt(oPC, "PRC_PrereqAlag", 1);

    iProperDomains = GetHasFeat(FEAT_GOOD_DOMAIN_POWER, oPC) +
                     GetHasFeat(FEAT_STRENGTH_DOMAIN_POWER, oPC) +
                     GetHasFeat(FEAT_WAR_DOMAIN_POWER, oPC) +
                     GetHasFeat(4043);//dwarf

    if (iProperDomains >= 2)
    {
        SetLocalInt(oPC, "PRC_PrereqAlag", 0);
    }
}

void Thrallherd(object oPC)
{
    SetLocalInt(oPC, "PRC_PrereqThrallherd", 1);

    // @todo Replace with some mechanism that is not dependent on power enumeration. Maybe a set of variables that tell how many powers of each discipline a character knows <- requires hooking to power gain / loss
    if (GetHasPower(POWER_CHARMPERSON, oPC) || GetHasPower(POWER_AVERSION, oPC) || GetHasPower(POWER_BRAINLOCK, oPC) ||
        GetHasPower(POWER_CRISISBREATH, oPC) || GetHasPower(POWER_EMPATHICTRANSFERHOSTILE, oPC) || GetHasPower(POWER_DOMINATE, oPC) ||
        GetHasPower(POWER_CRISISLIFE, oPC) || GetHasPower(POWER_PSYCHICCHIR_REPAIR, oPC))
    {
        SetLocalInt(oPC, "PRC_PrereqThrallherd", 0);
    }
}

void PsionicCheck(object oPC)
{
    SetLocalInt(oPC, "PRC_IsPsionic", 1);
    
    if (GetIsPsionicCharacter(oPC))
    {
        SetLocalInt(oPC, "PRC_IsPsionic", 0);
    }
}

void RangerURangerMutex(object oPC)
{// Ranger and Ultimate Ranger are mutually exclusive. One can only take levels in one of them

    // Delete the old values. The character may have lost the offending levels
    DeleteLocalInt(oPC, ALLOW_CLASS_RANGER);
    DeleteLocalInt(oPC, ALLOW_CLASS_ULTIMATE_RANGER);

    if(GetLevelByClass(CLASS_TYPE_RANGER) > 0)
    {
        SetLocalInt(oPC, ALLOW_CLASS_ULTIMATE_RANGER, 1);
    }

    if(GetLevelByClass(CLASS_TYPE_ULTIMATE_RANGER) > 0)
    {
        SetLocalInt(oPC, ALLOW_CLASS_RANGER, 1);
    }
}

void DragonDis(object oPC)
{
     int dBlud = GetLevelByClass(CLASS_TYPE_BARD, oPC) +
                 GetLevelByClass(CLASS_TYPE_SORCERER, oPC) +
                 GetHasFeat(DRAGON_BLOODED,oPC);

     SetLocalInt(oPC, "PRC_DraAllow", 0);

     if ( dBlud >= 1)
     {
        SetLocalInt(oPC, "PRC_DraAllow", 1);
     }
}

void RacialHD(object oPC)
{
    SetLocalInt(oPC, "PRC_PrereqAberration", 1);
    SetLocalInt(oPC, "PRC_PrereqAnimal", 1);
    SetLocalInt(oPC, "PRC_PrereqConstruct", 1);
    SetLocalInt(oPC, "PRC_PrereqHumanoid", 1);
    SetLocalInt(oPC, "PRC_PrereqMonstrous", 1);
    SetLocalInt(oPC, "PRC_PrereqElemental", 1);
    SetLocalInt(oPC, "PRC_PrereqFey", 1);
    SetLocalInt(oPC, "PRC_PrereqDragon", 1);
    SetLocalInt(oPC, "PRC_PrereqUndead", 1);
    SetLocalInt(oPC, "PRC_PrereqBeast", 1);
    SetLocalInt(oPC, "PRC_PrereqGiant", 1);
    SetLocalInt(oPC, "PRC_PrereqMagicalBeast", 1);
    SetLocalInt(oPC, "PRC_PrereqOutsider", 1);
    SetLocalInt(oPC, "PRC_PrereqShapechanger", 1);
    SetLocalInt(oPC, "PRC_PrereqVermin", 1);
    if(GetPRCSwitch(PRC_XP_USE_SIMPLE_RACIAL_HD))
    {
        int nRealRace = GetRacialType(oPC);
        int nRacialHD = StringToInt(Get2DACache("ECL", "RaceHD", nRealRace));
        int nRacialClass = StringToInt(Get2DACache("ECL", "RaceClass", nRealRace));
        if(nRacialHD && GetLevelByClass(nRacialClass, oPC) < nRacialHD)
        {
            switch(nRacialClass)
            {
                case CLASS_TYPE_ABERRATION: SetLocalInt(oPC, "PRC_PrereqAberration", 0); break;
                case CLASS_TYPE_ANIMAL: SetLocalInt(oPC, "PRC_PrereqAnmal", 0); break;
                case CLASS_TYPE_CONSTRUCT: SetLocalInt(oPC, "PRC_PrereqConstruct", 0); break;
                case CLASS_TYPE_HUMANOID: SetLocalInt(oPC, "PRC_PrereqHumanoid", 0); break;
                case CLASS_TYPE_MONSTROUS: SetLocalInt(oPC, "PRC_PrereqMonstrous", 0); break;
                case CLASS_TYPE_ELEMENTAL: SetLocalInt(oPC, "PRC_PrereqElemental", 0); break;
                case CLASS_TYPE_FEY: SetLocalInt(oPC, "PRC_PrereqFey", 0); break;
                case CLASS_TYPE_DRAGON: SetLocalInt(oPC, "PRC_PrereqDragon", 0); break;
                case CLASS_TYPE_UNDEAD: SetLocalInt(oPC, "PRC_PrereqUndead", 0); break;
                case CLASS_TYPE_BEAST: SetLocalInt(oPC, "PRC_PrereqBeast", 0); break;
                case CLASS_TYPE_GIANT: SetLocalInt(oPC, "PRC_PrereqGiant", 0); break;
                case CLASS_TYPE_MAGICAL_BEAST: SetLocalInt(oPC, "PRC_PrereqMagicalBeast", 0); break;
                case CLASS_TYPE_OUTSIDER: SetLocalInt(oPC, "PRC_PrereqOutsider", 0); break;
                case CLASS_TYPE_SHAPECHANGER: SetLocalInt(oPC, "PRC_PrereqShapechanger", 0); break;
                case CLASS_TYPE_VERMIN: SetLocalInt(oPC, "PRC_PrereqVermin", 0); break;
            }
        }

    }
}

// YES, that is main2()... it's the second (delayed) phase of main.
void main2()
{
     //Declare Major Variables
     object oPC = OBJECT_SELF;
     int iArcSpell;
     int iDivSpell;
     int iArcSpell1;
     int iDivSpell1;
     int iSnkLevel;

     // Initialize all the variables.
     string sVariable;
     int iCount;
     for (iCount = 1; iCount <= 9; iCount++)
     {
        sVariable = "PRC_AllSpell" + IntToString(iCount);
        SetLocalInt(oPC, sVariable, 1);

        sVariable = "PRC_ArcSpell" + IntToString(iCount);
        SetLocalInt(oPC, sVariable, 1);

        sVariable = "PRC_DivSpell" + IntToString(iCount);
        SetLocalInt(oPC, sVariable, 1);

        sVariable = "PRC_PsiPower" + IntToString(iCount);
        SetLocalInt(oPC, sVariable, 1);
     }
     for (iCount = 1; iCount <= 30; iCount++)
     {
        sVariable = "PRC_SneakLevel" + IntToString(iCount);
        SetLocalInt(oPC, sVariable, 1);
     }

     // Find the spell levels.
    int iCha = GetLocalInt(GetPCSkin(oPC), "PRC_trueCHA") - 10;
    int iWis = GetLocalInt(GetPCSkin(oPC), "PRC_trueWIS") - 10;
    int iInt = GetLocalInt(GetPCSkin(oPC), "PRC_trueINT") - 10;
    int nArcHighest;
    int nDivHighest;
    int nPsiHighest;
    int bFirstArcClassFound, bFirstDivClassFound, bFirstPsiClassFound;
    //for(i=1;i<3;i++)
    int nSpellLevel;
    int nClassSlot = 1;
    while(nClassSlot <= 3)
    {
        int nClass = PRCGetClassByPosition(nClassSlot, oPC);
        nClassSlot += 1;
        if(GetIsDivineClass(nClass))
        {
            int nLevel = GetLevelByClass(nClass, oPC);
            if (!bFirstDivClassFound &&
                GetFirstDivineClass(oPC) == nClass)
            {
                nLevel += GetDivinePRCLevels(oPC);
                bFirstDivClassFound = TRUE;
            }
            int nAbility = GetAbilityForClass(nClass, oPC);

            for(nSpellLevel = 1; nSpellLevel <= 9; nSpellLevel++)
            {
                int nSlots = GetSlotCount(nLevel, nSpellLevel, nAbility, nClass);
                if(nSlots > 0)
                {
                    SetLocalInt(oPC, "PRC_AllSpell"+IntToString(nSpellLevel), 0);
                    SetLocalInt(oPC, "PRC_DivSpell"+IntToString(nSpellLevel), 0);
                    if(nSpellLevel > nDivHighest)
                        nDivHighest = nSpellLevel;
                }
            }
        }
        else if(GetIsArcaneClass(nClass))
        {
            int nLevel = GetLevelByClass(nClass, oPC);
            if (!bFirstArcClassFound &&
                GetFirstArcaneClass(oPC) == nClass)
            {
                nLevel += GetArcanePRCLevels(oPC);
                bFirstArcClassFound = TRUE;
            }
            int nAbility = GetAbilityForClass(nClass, oPC);

            for(nSpellLevel = 1; nSpellLevel <= 9; nSpellLevel++)
            {
                int nSlots = GetSlotCount(nLevel, nSpellLevel, nAbility, nClass);
                if(nSlots > 0)
                {
                    SetLocalInt(oPC, "PRC_AllSpell"+IntToString(nSpellLevel), 0);
                    SetLocalInt(oPC, "PRC_ArcSpell"+IntToString(nSpellLevel), 0);
                    if(nSpellLevel > nArcHighest)
                        nArcHighest = nSpellLevel;
                }
            }
        }
        else if(GetIsPsionicClass(nClass))
        {
            int nLevel = GetLevelByClass(nClass, oPC);
            if (!bFirstPsiClassFound &&
                GetFirstPsionicClass(oPC) == nClass)
            {
                nLevel += GetPsionicPRCLevels(oPC);
                bFirstPsiClassFound = TRUE;
            }
            int nAbility    = GetAbilityForClass(nClass, oPC);
            string sPsiFile = GetPsionicFileName(nClass);
            int nMaxLevel   = StringToInt(Get2DACache(sPsiFile, "MaxPowerLevel", nLevel - 1));

            int nPsiHighest = min(nMaxLevel, nAbility - 10);

            for(nSpellLevel = 1; nSpellLevel <= nPsiHighest; nSpellLevel++)
            {
                SetLocalInt(oPC, "PRC_PsiPower" + IntToString(nSpellLevel), 0);
                if(DEBUG) DoDebug("Psionics power level Prereq Variable " + IntToString(nSpellLevel) +": " + IntToString(GetLocalInt(oPC, "PRC_PsiPower"+IntToString(nSpellLevel))), oPC);
            }
        }
    }// end while - loop over all 3 class slots

     // Find the sneak attack capacity.
     SneakRequirement(oPC);

     // Special requirements for several classes.
     Hathran(oPC);
     Tempest(oPC);
     KOTC(oPC);
     BFZ(oPC);
     ManAtArms(oPC);
     SOL(oPC);
     Stormlord(oPC);
     Blightlord(oPC);
     EOG(oPC);
     RedWizard(oPC);
     ShadowAdept(oPC);
     ThrallOfGrazzt(oPC);
     ShiningBlade(oPC);
     Shadowlord(oPC, nArcHighest);
     Shifter(oPC, nArcHighest, nDivHighest);
     DemiLich(oPC);
     Rava(oPC);
     WWolf(oPC);
     FH(oPC);
     Kord(oPC);
     BloodArcher(oPC);
     Maester(oPC);
     CombatMedic(oPC);
     Alaghar(oPC);
     RangerURangerMutex(oPC);
     DragonDis(oPC);
     Thrallherd(oPC);
     PsionicCheck(oPC);
     RacialHD(oPC);
     // Truly massive debug message flood if activated.
     /*
     SendMessageToPC(oPC, "Your true Strength: " + IntToString(GetLocalInt(oHide, "PRC_trueSTR")));
     SendMessageToPC(oPC, "Your true Dexterity: " + IntToString(GetLocalInt(oHide, "PRC_trueDEX")));
     SendMessageToPC(oPC, "Your true Constitution: " + IntToString(GetLocalInt(oHide, "PRC_trueCON")));
     SendMessageToPC(oPC, "Your true Intelligence: " + IntToString(GetLocalInt(oHide, "PRC_trueINT")));
     SendMessageToPC(oPC, "Your true Wisdom: " + IntToString(GetLocalInt(oHide, "PRC_trueWIS")));
     SendMessageToPC(oPC, "Your true Charisma: " + IntToString(GetLocalInt(oHide, "PRC_trueCHA")));

     string sPRC_AllSpell;
     string sPRC_ArcSpell;
     string sPRC_DivSpell;
     for (iCount = 1; iCount <= 9; iCount++)
     {
        sPRC_AllSpell = "PRC_AllSpell" + IntToString(iCount);
        sPRC_ArcSpell = "PRC_ArcSpell" + IntToString(iCount);
        sPRC_DivSpell = "PRC_DivSpell" + IntToString(iCount);
        SendMessageToPC(oPC, sPRC_AllSpell + " is " + IntToString(GetLocalInt(oPC, sPRC_AllSpell)) + ". " +
                             sPRC_ArcSpell + " is " + IntToString(GetLocalInt(oPC, sPRC_ArcSpell)) + ". " +
                             sPRC_DivSpell + " is " + IntToString(GetLocalInt(oPC, sPRC_DivSpell)) + ".");
     }
     for (iCount = 1; iCount <= 30; iCount++)
     {
        sVariable = "PRC_SneakLevel" + IntToString(iCount);
        SendMessageToPC(oPC, sVariable + " is " + IntToString(GetLocalInt(oPC, sVariable)) + ".");
     }
     */

}

void main()
{
     FindTrueAbilityScores();

     DelayCommand(0.6, main2());
}