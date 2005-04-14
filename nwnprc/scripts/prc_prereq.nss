//::///////////////////////////////////////////////
//:: PRC Prerequisites
//:: prc_prereq.nss
//:://////////////////////////////////////////////
//:: Check to see what classes a PC is capable of taking.
//:://////////////////////////////////////////////
//:: Created By: Stratovarius.
//:: Created On: July 3rd, 2004
//:://////////////////////////////////////////////

#include "prc_inc_spells"
#include "prc_inc_sneak"
#include "prc_alterations"
#include "inc_newspellbook"
#include "prc_allow_const"

// this creates a clone of the PC in limbo, removes the effects and equipment,
// then stores the results of a ability score query onto the PC's hide.
void FindTrueAbilityScoresPhaseTwo(object oPC, object oClone);
void FindTrueAbilityScores()
{
    object oPC = OBJECT_SELF;
    int i = 0;
    object oLimbo = GetObjectByTag("Limbo",i);
    location lLimbo;
    while (i < 100)
    {
        if (GetIsObjectValid(oLimbo))
        {
            if (GetName(oLimbo) == "Limbo")
            {
                i = 2000;
                vector vLimbo = Vector(0.0f, 0.0f, 0.0f);
                lLimbo = Location(oLimbo, vLimbo, 0.0f);
            }
        }
        i++;
        object oLimbo = GetObjectByTag("Limbo",i);
    }
    //create copy of the PC for getting base ability scores
    object oClone;
    if (i >= 2000)
    {
        oClone = CopyObject(oPC, lLimbo, OBJECT_INVALID, "clone_"+ObjectToString(oPC));
    }
    else
    {
        // create a clone but make it completely uninteractive
        oClone = CopyObject(oPC, GetLocation(oPC), OBJECT_INVALID, "clone_"+ObjectToString(oPC));
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
     if(GetHasItem(oPC,"shadowwalkerstok"))
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


  iWF = GetHasFeat(FEAT_WEAPON_FOCUS_BASTARD_SWORD,oPC)+GetHasFeat(FEAT_WEAPON_FOCUS_BATTLE_AXE,oPC)+GetHasFeat(FEAT_WEAPON_FOCUS_CLUB,oPC)+
        GetHasFeat(FEAT_WEAPON_FOCUS_DAGGER,oPC)+GetHasFeat(FEAT_WEAPON_FOCUS_DART,oPC)+GetHasFeat(FEAT_WEAPON_FOCUS_DIRE_MACE,oPC)+
        GetHasFeat(FEAT_WEAPON_FOCUS_DOUBLE_AXE,oPC)+GetHasFeat(FEAT_WEAPON_FOCUS_DWAXE,oPC)+GetHasFeat(FEAT_WEAPON_FOCUS_GREAT_AXE,oPC)+
        GetHasFeat(FEAT_WEAPON_FOCUS_GREAT_SWORD,oPC)+GetHasFeat(FEAT_WEAPON_FOCUS_HALBERD,oPC)+GetHasFeat(FEAT_WEAPON_FOCUS_HAND_AXE,oPC)+
        GetHasFeat(FEAT_WEAPON_FOCUS_HEAVY_CROSSBOW,oPC)+GetHasFeat(FEAT_WEAPON_FOCUS_HEAVY_FLAIL,oPC)+GetHasFeat(FEAT_WEAPON_FOCUS_KAMA,oPC)+
        GetHasFeat(FEAT_WEAPON_FOCUS_TWO_BLADED_SWORD,oPC)+GetHasFeat(FEAT_WEAPON_FOCUS_LONG_SWORD,oPC)+GetHasFeat(FEAT_WEAPON_FOCUS_RAPIER,oPC);



  iWF += GetHasFeat(FEAT_WEAPON_FOCUS_KATANA,oPC)+GetHasFeat(FEAT_WEAPON_FOCUS_KUKRI,oPC)+GetHasFeat(FEAT_WEAPON_FOCUS_LIGHT_CROSSBOW,oPC)+
        GetHasFeat(FEAT_WEAPON_FOCUS_LIGHT_FLAIL,oPC)+GetHasFeat(FEAT_WEAPON_FOCUS_LIGHT_HAMMER,oPC)+GetHasFeat(FEAT_WEAPON_FOCUS_LIGHT_MACE,oPC)+
        GetHasFeat(FEAT_WEAPON_FOCUS_LONGBOW,oPC)+GetHasFeat(FEAT_WEAPON_FOCUS_MORNING_STAR,oPC)+
        GetHasFeat(FEAT_WEAPON_FOCUS_SCIMITAR,oPC)+GetHasFeat(FEAT_WEAPON_FOCUS_SCYTHE,oPC)+
        GetHasFeat(FEAT_WEAPON_FOCUS_SHORT_SWORD,oPC)+GetHasFeat(FEAT_WEAPON_FOCUS_SHORTBOW,oPC)+GetHasFeat(FEAT_WEAPON_FOCUS_SHURIKEN,oPC)+
        GetHasFeat(FEAT_WEAPON_FOCUS_SICKLE,oPC)+GetHasFeat(FEAT_WEAPON_FOCUS_SLING,oPC)+GetHasFeat(FEAT_WEAPON_FOCUS_SPEAR,oPC)+
        GetHasFeat(FEAT_WEAPON_FOCUS_STAFF,oPC)+GetHasFeat(FEAT_WEAPON_FOCUS_THROWING_AXE,oPC)+
        GetHasFeat(FEAT_WEAPON_FOCUS_WAR_HAMMER,oPC);//+GetHasFeat(FEAT_WEAPON_FOCUS_WHIP,oPC);


     SetLocalInt(oPC, "PRC_PrereqMAA", 1);

     if (iWF > 3)
     {
     SetLocalInt(oPC, "PRC_PrereqMAA", 0);
     }
     if (iWF>0)
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
     int iEOG = GetHasFeat(FEAT_WAR_DOMAIN_POWER,oPC)+GetHasFeat(FEAT_STRENGTH_DOMAIN_POWER,oPC)+GetHasFeat(FEAT_EVIL_DOMAIN_POWER,oPC);
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

void RedWizard(object oPC)
{

  SetLocalInt(oPC, "PRC_PrereqRedWiz", 1);

  int iFeat;
  int iFocus;

  iFocus =     GetHasFeat(FEAT_RW_TF_ABJ, oPC)+GetHasFeat(FEAT_RW_TF_CON, oPC)+GetHasFeat(FEAT_RW_TF_DIV, oPC)+
          GetHasFeat(FEAT_RW_TF_ENC, oPC)+GetHasFeat(FEAT_RW_TF_EVO, oPC)+GetHasFeat(FEAT_RW_TF_ILL, oPC)+
          GetHasFeat(FEAT_RW_TF_NEC, oPC)+GetHasFeat(FEAT_RW_TF_TRS, oPC);

  iFeat +=     GetHasFeat(FEAT_ARCANE_DEFENSE_ABJURATION, oPC) + GetHasFeat(FEAT_ARCANE_DEFENSE_CONJURATION, oPC) +
          GetHasFeat(FEAT_ARCANE_DEFENSE_DIVINATION, oPC) + GetHasFeat(FEAT_ARCANE_DEFENSE_ENCHANTMENT, oPC) +
          GetHasFeat(FEAT_ARCANE_DEFENSE_EVOCATION, oPC) + GetHasFeat(FEAT_ARCANE_DEFENSE_ILLUSION, oPC) +
          GetHasFeat(FEAT_ARCANE_DEFENSE_NECROMANCY, oPC) + GetHasFeat(FEAT_ARCANE_DEFENSE_TRANSMUTATION, oPC) +
          GetHasFeat(FEAT_BREW_POTION, oPC) + GetHasFeat(FEAT_CRAFT_WAND, oPC) + GetHasFeat(FEAT_EMPOWER_SPELL, oPC) +
          GetHasFeat(FEAT_COMBAT_CASTING, oPC) + GetHasFeat(FEAT_EXTEND_SPELL, oPC) + GetHasFeat(FEAT_FOCUSED_SPELL_PENETRATION_ABJURATION, oPC) +
          GetHasFeat(FEAT_FOCUSED_SPELL_PENETRATION_CONJURATION, oPC) + GetHasFeat(FEAT_FOCUSED_SPELL_PENETRATION_DIVINATION, oPC) +
          GetHasFeat(FEAT_FOCUSED_SPELL_PENETRATION_ENCHATMENT, oPC) + GetHasFeat(FEAT_FOCUSED_SPELL_PENETRATION_EVOCATION, oPC) +
          GetHasFeat(FEAT_FOCUSED_SPELL_PENETRATION_ILLUSION, oPC) + GetHasFeat(FEAT_FOCUSED_SPELL_PENETRATION_NECROMANCY, oPC) +
          GetHasFeat(FEAT_FOCUSED_SPELL_PENETRATION_TRANSMUTATION, oPC) + GetHasFeat(FEAT_GREATER_SPELL_FOCUS_ABJURATION, oPC) +
          GetHasFeat(FEAT_GREATER_SPELL_FOCUS_CONJURATION, oPC) + GetHasFeat(FEAT_GREATER_SPELL_FOCUS_DIVINIATION, oPC) +
          GetHasFeat(FEAT_GREATER_SPELL_FOCUS_ENCHANTMENT, oPC) + GetHasFeat(FEAT_GREATER_SPELL_FOCUS_EVOCATION, oPC) +
          GetHasFeat(FEAT_GREATER_SPELL_FOCUS_ILLUSION, oPC) + GetHasFeat(FEAT_GREATER_SPELL_FOCUS_NECROMANCY, oPC) +
          GetHasFeat(FEAT_GREATER_SPELL_FOCUS_TRANSMUTATION, oPC) + GetHasFeat(FEAT_GREATER_SPELL_PENETRATION, oPC) +
          GetHasFeat(FEAT_MAXIMIZE_SPELL, oPC) + GetHasFeat(FEAT_PRACTISED_SPELLCASTER_WIZARD, oPC) +
          GetHasFeat(FEAT_QUICKEN_SPELL, oPC) + GetHasFeat(FEAT_SCRIBE_SCROLL, oPC) +
          GetHasFeat(FEAT_SPELL_FOCUS_ABJURATION, oPC) + GetHasFeat(FEAT_SPELL_FOCUS_CONJURATION, oPC) +
          GetHasFeat(FEAT_SPELL_FOCUS_DIVINATION, oPC) + GetHasFeat(FEAT_SPELL_FOCUS_ENCHANTMENT, oPC) +
          GetHasFeat(FEAT_SPELL_FOCUS_EVOCATION, oPC) + GetHasFeat(FEAT_SPELL_FOCUS_ILLUSION, oPC) +
          GetHasFeat(FEAT_SPELL_FOCUS_NECROMANCY, oPC) + GetHasFeat(FEAT_SPELL_FOCUS_TRANSMUTATION, oPC) +
          GetHasFeat(FEAT_SPELL_PENETRATION, oPC) + GetHasFeat(FEAT_STILL_SPELL, oPC);


     if (iFeat > 2 && iFocus == 1)
     {
     SetLocalInt(oPC, "PRC_PrereqRedWiz", 0);
     }
}

void FH(object oPC)
{
        int iRanger = GetLevelByClass(CLASS_TYPE_RANGER, oPC);
        int iURanger = GetLevelByClass(CLASS_TYPE_ULTIMATE_RANGER, oPC);

        int iPrereq = GetLocalInt(oPC, "PRC_PrereqFH");

     if ( iRanger > 0 ||iURanger > 1 )
     {
          SetLocalInt(oPC, "PRC_PrereqFH", iPrereq-1);
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
                     GetHasFeat(FEAT_WAR_DOMAIN_POWER, oPC);

    if (iProperDomains >= 2)
    {
        SetLocalInt(oPC, "PRC_PrereqAlag", 0);
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
     }
     for (iCount = 1; iCount <= 30; iCount++)
     {
        sVariable = "PRC_SneakLevel" + IntToString(iCount);
        SetLocalInt(oPC, sVariable, 1);
     }

     // Find the spell levels.
    int i;
    int iCha = GetLocalInt(GetPCSkin(oPC), "PRC_trueCHA") - 10;
    int iWis = GetLocalInt(GetPCSkin(oPC), "PRC_trueWIS") - 10;
    int iInt = GetLocalInt(GetPCSkin(oPC), "PRC_trueINT") - 10;
    int nArcHighest;
    int nDivHighest;
    for(i=1;i<3;i++)
    {
        int nClass = PRCGetClassByPosition(i, oPC);
        if(GetIsDivineClass(nClass))
        { 
            int nLevel = PRCGetLevelByPosition(i, oPC);
            if (GetFirstDivineClass(oPC) == nClass) 
                nLevel += GetDivinePRCLevels(oPC);
            int nAbility = GetAbilityForClass(nClass, oPC);                       
                       
            for(i=1;i<=9;i++)
            {
                int nSlots = GetSlotCount(nLevel, i, nAbility, nClass);
                if(nSlots > 0)
                {
                    SetLocalInt(oPC, "PRC_AllSpell"+IntToString(i), 0);
                    SetLocalInt(oPC, "PRC_DivSpell"+IntToString(i), 0);
                    if(i > nDivHighest)
                        nDivHighest = i;
                }
            }
        }
        else if(GetIsArcaneClass(nClass))
        { 
            int nLevel = PRCGetLevelByPosition(i, oPC);
            if (GetFirstArcaneClass(oPC) == nClass) 
                nLevel += GetArcanePRCLevels(oPC);
            int nAbility = GetAbilityForClass(nClass, oPC);                       
                       
            for(i=1;i<=9;i++)
            {
                int nSlots = GetSlotCount(nLevel, i, nAbility, nClass);
                if(nSlots > 0)
                {
                    SetLocalInt(oPC, "PRC_AllSpell"+IntToString(i), 0);
                    SetLocalInt(oPC, "PRC_ArcSpell"+IntToString(i), 0);
                    if(i > nArcHighest)
                        nArcHighest = i;
                }
            }
        }        
    }

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
     BloodArcher(oPC);
     Alaghar(oPC);
     RangerURangerMutex(oPC);
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