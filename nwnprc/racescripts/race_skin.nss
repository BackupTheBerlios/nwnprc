
// Handle skin and other mods for races.
// This file is where various content users can customize races.

#include "prc_alterations"
#include "prc_ipfeat_const"
#include "inc_dynconv"

void main()
{
    object oPC = OBJECT_SELF;
    object oSkin = GetPCSkin(oPC);

    //immunity to cold
    if(GetHasFeat(FEAT_IMM_COLD))
    {
        itemproperty ipIP =ItemPropertyDamageImmunity(IP_CONST_DAMAGETYPE_COLD,IP_CONST_DAMAGEIMMUNITY_100_PERCENT);
        IPSafeAddItemProperty(oSkin, ipIP, 0.0, X2_IP_ADDPROP_POLICY_REPLACE_EXISTING, FALSE, FALSE);
    }

    //immunity to acid
    if(GetHasFeat(FEAT_IMMUNE_ACID))
    {
        itemproperty ipIP =ItemPropertyDamageImmunity(IP_CONST_DAMAGETYPE_ACID,IP_CONST_DAMAGEIMMUNITY_100_PERCENT);
        IPSafeAddItemProperty(oSkin, ipIP, 0.0, X2_IP_ADDPROP_POLICY_REPLACE_EXISTING, FALSE, FALSE);
    }

    //immunity to electricity
    if(GetHasFeat(FEAT_IMMUNE_ELECTRICITY))
    {
        itemproperty ipIP =ItemPropertyDamageImmunity(IP_CONST_DAMAGETYPE_ELECTRICAL,IP_CONST_DAMAGEIMMUNITY_100_PERCENT);
        IPSafeAddItemProperty(oSkin, ipIP, 0.0, X2_IP_ADDPROP_POLICY_REPLACE_EXISTING, FALSE, FALSE);
    }

    //immunity to phantasms
    //only immunity to wierd and phatasmal killer
    if(GetHasFeat(FEAT_IMM_PHANT))
    {
        itemproperty ipIP = ItemPropertySpellImmunitySpecific(SPELL_WEIRD);
        IPSafeAddItemProperty(oSkin, ipIP, 0.0, X2_IP_ADDPROP_POLICY_REPLACE_EXISTING, FALSE, FALSE);
        ipIP = ItemPropertySpellImmunitySpecific(SPELL_PHANTASMAL_KILLER);
        IPSafeAddItemProperty(oSkin, ipIP, 0.0, X2_IP_ADDPROP_POLICY_REPLACE_EXISTING, FALSE, FALSE);
    }

    //immunity to detection. NEEDS TESTING!!!
//tested and doesnt work (means you cant cast these on yourself)
//removed untill a solution is found
    if(GetHasFeat(FEAT_NONDETECTION))
    {
/*
        itemproperty ipIP = ItemPropertySpellImmunitySpecific(SPELL_SEE_INVISIBILITY);
        IPSafeAddItemProperty(oSkin, ipIP, 0.0, X2_IP_ADDPROP_POLICY_REPLACE_EXISTING, FALSE, FALSE);
        ipIP = ItemPropertySpellImmunitySpecific(SPELL_TRUE_SEEING);
        IPSafeAddItemProperty(oSkin, ipIP, 0.0, X2_IP_ADDPROP_POLICY_REPLACE_EXISTING, FALSE, FALSE);
        ipIP = ItemPropertySpellImmunitySpecific(SPELL_DARKVISION);
        IPSafeAddItemProperty(oSkin, ipIP, 0.0, X2_IP_ADDPROP_POLICY_REPLACE_EXISTING, FALSE, FALSE);
*/
    }

    //immunity to artificial poisons
    //replaced with immunity to all poisons
    if(GetHasFeat(FEAT_IMM_APOI))
    {
        itemproperty ipIP =ItemPropertyImmunityMisc(IP_CONST_IMMUNITYMISC_POISON);
        IPSafeAddItemProperty(oSkin, ipIP, 0.0, X2_IP_ADDPROP_POLICY_REPLACE_EXISTING, FALSE, FALSE);
    }

    //immunity to disease
    if(GetHasFeat(FEAT_IMMUNE_DISEASE))
    {
        itemproperty ipIP =ItemPropertyImmunityMisc(IP_CONST_IMMUNITYMISC_DISEASE);
        IPSafeAddItemProperty(oSkin, ipIP, 0.0, X2_IP_ADDPROP_POLICY_REPLACE_EXISTING, FALSE, FALSE);
    }

    //improved fortification - immunity to critical hits
    if(GetHasFeat(FEAT_IMPROVED_FORTIFICATION))
    {
        itemproperty ipIP =ItemPropertyImmunityMisc(IP_CONST_IMMUNITYMISC_CRITICAL_HITS);
        IPSafeAddItemProperty(oSkin, ipIP, 0.0, X2_IP_ADDPROP_POLICY_REPLACE_EXISTING, FALSE, FALSE);
    }
    
    //Plant racial type immunities - sleep, paralysis, poison, mind-affecting, criticals
    if(GetHasFeat(FEAT_PLANT_IMM))
    {
    	effect eSleepImmune = ExtraordinaryEffect(EffectImmunity(IMMUNITY_TYPE_SLEEP));
    	AssignCommand(oPC, ApplyEffectToObject(DURATION_TYPE_PERMANENT, eSleepImmune, oPC));
    	
        itemproperty ipIP =ItemPropertyImmunityMisc(IP_CONST_IMMUNITYMISC_PARALYSIS);
        IPSafeAddItemProperty(oSkin, ipIP, 0.0, X2_IP_ADDPROP_POLICY_REPLACE_EXISTING, FALSE, FALSE);
        
        ipIP =ItemPropertyImmunityMisc(IP_CONST_IMMUNITYMISC_POISON);
        IPSafeAddItemProperty(oSkin, ipIP, 0.0, X2_IP_ADDPROP_POLICY_REPLACE_EXISTING, FALSE, FALSE);
        
        ipIP =ItemPropertyImmunityMisc(IP_CONST_IMMUNITYMISC_MINDSPELLS);
        IPSafeAddItemProperty(oSkin, ipIP, 0.0, X2_IP_ADDPROP_POLICY_REPLACE_EXISTING, FALSE, FALSE);
        
        ipIP =ItemPropertyImmunityMisc(IP_CONST_IMMUNITYMISC_CRITICAL_HITS);
        IPSafeAddItemProperty(oSkin, ipIP, 0.0, X2_IP_ADDPROP_POLICY_REPLACE_EXISTING, FALSE, FALSE);
    }
    
    //Living Construct type immunities - sleep, paralysis, poison, disease, energy drain
    if(GetHasFeat(FEAT_LIVING_CONSTRUCT))
    {
    	effect eSleepImmune = ExtraordinaryEffect(EffectImmunity(IMMUNITY_TYPE_SLEEP));
    	AssignCommand(oPC, ApplyEffectToObject(DURATION_TYPE_PERMANENT, eSleepImmune, oPC));
    	
        itemproperty ipIP =ItemPropertyImmunityMisc(IP_CONST_IMMUNITYMISC_PARALYSIS);
        IPSafeAddItemProperty(oSkin, ipIP, 0.0, X2_IP_ADDPROP_POLICY_REPLACE_EXISTING, FALSE, FALSE);
        
        ipIP =ItemPropertyImmunityMisc(IP_CONST_IMMUNITYMISC_POISON);
        IPSafeAddItemProperty(oSkin, ipIP, 0.0, X2_IP_ADDPROP_POLICY_REPLACE_EXISTING, FALSE, FALSE);
        
        ipIP =ItemPropertyImmunityMisc(IP_CONST_IMMUNITYMISC_DISEASE);
        IPSafeAddItemProperty(oSkin, ipIP, 0.0, X2_IP_ADDPROP_POLICY_REPLACE_EXISTING, FALSE, FALSE);
        
        ipIP =ItemPropertyImmunityMisc(IP_CONST_IMMUNITYMISC_LEVEL_ABIL_DRAIN);
        IPSafeAddItemProperty(oSkin, ipIP, 0.0, X2_IP_ADDPROP_POLICY_REPLACE_EXISTING, FALSE, FALSE);
    }
    
    //natural armor 1-10
    // Note: This bonus will be Dodge bonus no matter what IP_CONST you specify.
    if(GetHasFeat(FEAT_NATARM_1))
        SetCompositeBonus(oSkin, "RacialNaturalArmor", 1, ITEM_PROPERTY_AC_BONUS);
    else if(GetHasFeat(FEAT_NATARM_2))
        SetCompositeBonus(oSkin, "RacialNaturalArmor", 2, ITEM_PROPERTY_AC_BONUS);
    else if(GetHasFeat(FEAT_NATARM_3))
        SetCompositeBonus(oSkin, "RacialNaturalArmor", 3, ITEM_PROPERTY_AC_BONUS);
    else if(GetHasFeat(FEAT_NATARM_4))
        SetCompositeBonus(oSkin, "RacialNaturalArmor", 4, ITEM_PROPERTY_AC_BONUS);
    else if(GetHasFeat(FEAT_NATARM_5))
        SetCompositeBonus(oSkin, "RacialNaturalArmor", 5, ITEM_PROPERTY_AC_BONUS);
    else if(GetHasFeat(FEAT_NATARM_6))
        SetCompositeBonus(oSkin, "RacialNaturalArmor", 6, ITEM_PROPERTY_AC_BONUS);
    else if(GetHasFeat(FEAT_NATARM_7))
        SetCompositeBonus(oSkin, "RacialNaturalArmor", 7, ITEM_PROPERTY_AC_BONUS);
    else if(GetHasFeat(FEAT_NATARM_8))
        SetCompositeBonus(oSkin, "RacialNaturalArmor", 8, ITEM_PROPERTY_AC_BONUS);
    else if(GetHasFeat(FEAT_NATARM_9))
        SetCompositeBonus(oSkin, "RacialNaturalArmor", 9, ITEM_PROPERTY_AC_BONUS);
    else if(GetHasFeat(FEAT_NATARM_10))
        SetCompositeBonus(oSkin, "RacialNaturalArmor",10, ITEM_PROPERTY_AC_BONUS);
    else if(GetHasFeat(FEAT_NATARM_11))
        SetCompositeBonus(oSkin, "RacialNaturalArmor",11, ITEM_PROPERTY_AC_BONUS);
    else if(GetHasFeat(FEAT_NATARM_12))
        SetCompositeBonus(oSkin, "RacialNaturalArmor",12, ITEM_PROPERTY_AC_BONUS);
    else if(GetHasFeat(FEAT_NATARM_13))
        SetCompositeBonus(oSkin, "RacialNaturalArmor",13, ITEM_PROPERTY_AC_BONUS);
    else if(GetHasFeat(FEAT_NATARM_14))
        SetCompositeBonus(oSkin, "RacialNaturalArmor",14, ITEM_PROPERTY_AC_BONUS);
    else if(GetHasFeat(FEAT_NATARM_15))
        SetCompositeBonus(oSkin, "RacialNaturalArmor",15, ITEM_PROPERTY_AC_BONUS);
    else if(GetHasFeat(FEAT_NATARM_16))
        SetCompositeBonus(oSkin, "RacialNaturalArmor",16, ITEM_PROPERTY_AC_BONUS);
    else if(GetHasFeat(FEAT_NATARM_17))
        SetCompositeBonus(oSkin, "RacialNaturalArmor",17, ITEM_PROPERTY_AC_BONUS);
    else if(GetHasFeat(FEAT_NATARM_18))
        SetCompositeBonus(oSkin, "RacialNaturalArmor",18, ITEM_PROPERTY_AC_BONUS);
    else if(GetHasFeat(FEAT_NATARM_19))
        SetCompositeBonus(oSkin, "RacialNaturalArmor",19, ITEM_PROPERTY_AC_BONUS);
    else if(GetHasFeat(FEAT_NATARM_20))
        SetCompositeBonus(oSkin, "RacialNaturalArmor",20, ITEM_PROPERTY_AC_BONUS);
    else if(GetHasFeat(FEAT_NATARM_21))
        SetCompositeBonus(oSkin, "RacialNaturalArmor",21, ITEM_PROPERTY_AC_BONUS);
    else if(GetHasFeat(FEAT_NATARM_22))
        SetCompositeBonus(oSkin, "RacialNaturalArmor",22, ITEM_PROPERTY_AC_BONUS);

    //immunity to breathing-targetted spells
    if(GetHasFeat(FEAT_BREATHLESS))
    {
        itemproperty ipIP = ItemPropertySpellImmunitySpecific(SPELL_DROWN);
        IPSafeAddItemProperty(oSkin, ipIP, 0.0, X2_IP_ADDPROP_POLICY_REPLACE_EXISTING, FALSE, FALSE);
        ipIP = ItemPropertySpellImmunitySpecific(SPELL_MASS_DROWN  );
        IPSafeAddItemProperty(oSkin, ipIP, 0.0, X2_IP_ADDPROP_POLICY_REPLACE_EXISTING, FALSE, FALSE);
        ipIP = ItemPropertySpellImmunitySpecific(SPELL_CLOUDKILL  );
        IPSafeAddItemProperty(oSkin, ipIP, 0.0, X2_IP_ADDPROP_POLICY_REPLACE_EXISTING, FALSE, FALSE);
        ipIP = ItemPropertySpellImmunitySpecific(SPELL_ACID_FOG  );
        IPSafeAddItemProperty(oSkin, ipIP, 0.0, X2_IP_ADDPROP_POLICY_REPLACE_EXISTING, FALSE, FALSE);
        ipIP = ItemPropertySpellImmunitySpecific(SPELL_STINKING_CLOUD  );
        IPSafeAddItemProperty(oSkin, ipIP, 0.0, X2_IP_ADDPROP_POLICY_REPLACE_EXISTING, FALSE, FALSE);
    }

    //immunity to charm
    if(GetHasFeat(FEAT_IMMUNE_CHARM))
    {
        itemproperty ipIP = ItemPropertySpellImmunitySpecific(SPELL_CHARM_PERSON);
        IPSafeAddItemProperty(oSkin, ipIP, 0.0, X2_IP_ADDPROP_POLICY_REPLACE_EXISTING, FALSE, FALSE);
    }

    //immunity to confusion
    if(GetHasFeat(FEAT_IMMUNE_CONFUSION))
    {
        itemproperty ipIP = ItemPropertySpellImmunitySpecific(SPELL_CONFUSION);
        IPSafeAddItemProperty(oSkin, ipIP, 0.0, X2_IP_ADDPROP_POLICY_REPLACE_EXISTING, FALSE, FALSE);
    }

    //immunity to drowning
    //water gensasi and aquatic elves can breath water
    if(GetHasFeat(FEAT_WATER_BREATHING))
    {
        itemproperty ipIP = ItemPropertySpellImmunitySpecific(SPELL_DROWN);
        IPSafeAddItemProperty(oSkin, ipIP, 0.0, X2_IP_ADDPROP_POLICY_REPLACE_EXISTING, FALSE, FALSE);
        ipIP = ItemPropertySpellImmunitySpecific(SPELL_MASS_DROWN  );
        IPSafeAddItemProperty(oSkin, ipIP, 0.0, X2_IP_ADDPROP_POLICY_REPLACE_EXISTING, FALSE, FALSE);
    }

    //Azer Heat Damage +1 (armed and unarmed)
    if (GetHasFeat(FEAT_AZER_HEAT, oPC))
    {
         if (GetLocalInt(oPC, "ONEQUIP") == 1)
         {
             object oItem = GetItemLastUnequipped();
             SetCompositeDamageBonusT(oItem, "AzerFlameDamage", 0, IP_CONST_DAMAGETYPE_FIRE);
         }
         else
         {
             ExecuteScript("race_azer_flame", oPC);
         }
    }
/* Bioware reads size based on appearance    
    //-1AC, -1 ATT, -4hide
    if(GetHasFeat(FEAT_LARGE))
    {
        SetCompositeBonus(oSkin, "RacialSize_AC", 1, ITEM_PROPERTY_DECREASED_AC);
        SetCompositeBonus(oSkin, "RacialSize_Attack", 1, ITEM_PROPERTY_DECREASED_ATTACK_MODIFIER);
        SetCompositeBonus(oSkin, "RacialSize_SkillHide", 4, ITEM_PROPERTY_DECREASED_SKILL_MODIFIER, SKILL_HIDE);
    }

    //-2AC, -2 ATT, -8hide
    else if(GetHasFeat(FEAT_HUGE))
    {
        SetCompositeBonus(oSkin, "RacialSize_AC", 2, ITEM_PROPERTY_DECREASED_AC);
        SetCompositeBonus(oSkin, "RacialSize_Attack", 2, ITEM_PROPERTY_DECREASED_ATTACK_MODIFIER);
        SetCompositeBonus(oSkin, "RacialSize_SkillHide", 8, ITEM_PROPERTY_DECREASED_SKILL_MODIFIER, SKILL_HIDE);
    }

    //+2AC, +2 ATT, +8hide
    else if(GetHasFeat(FEAT_TINY))
    {
        SetCompositeBonus(oSkin, "RacialSize_AC", 2, ITEM_PROPERTY_AC_BONUS);
        SetCompositeBonus(oSkin, "RacialSize_Attack", 2, ITEM_PROPERTY_ATTACK_BONUS);
        SetCompositeBonus(oSkin, "RacialSize_SkillHide", 8, ITEM_PROPERTY_SKILL_BONUS, SKILL_HIDE);
    }
*/
    //regeneration 5PH/round
    if(GetHasFeat(FEAT_REGEN5))
    {
        SetCompositeBonus(oSkin, "RacialRegeneration_5", 5, ITEM_PROPERTY_REGENERATION);
    }

    //regeneration 2PH/round
    if(GetHasFeat(FEAT_REGEN2))
    {
        SetCompositeBonus(oSkin, "RacialRegeneration_2", 2, ITEM_PROPERTY_REGENERATION);
    }

    //fire resistance 5
    if(GetHasFeat(FEAT_RESIST_FIRE5))
    {
        itemproperty ipIP =ItemPropertyDamageResistance(IP_CONST_DAMAGETYPE_FIRE, IP_CONST_DAMAGERESIST_5);
        IPSafeAddItemProperty(oSkin, ipIP, 0.0, X2_IP_ADDPROP_POLICY_REPLACE_EXISTING, FALSE, FALSE);
    }

    // Very Heroic, +2 to all saving throws
    if(GetHasFeat(FEAT_VERYHEROIC))
    {
        SetCompositeBonus(oSkin, "VeryHeroic", 2, ITEM_PROPERTY_SAVING_THROW_BONUS, SAVING_THROW_ALL);
    }

    // Skill Affinity, +2 to jump
    if(GetHasFeat(FEAT_SA_JUMP))
    {
        SetCompositeBonus(oSkin, "SA_Jump", 2, ITEM_PROPERTY_SKILL_BONUS, 28);
    }

    // Skill Affinity, +2 to bluff
    if(GetHasFeat(FEAT_SA_BLUFF))
    {
        SetCompositeBonus(oSkin, "SA_Bluff", 2, ITEM_PROPERTY_SKILL_BONUS, SKILL_BLUFF);
    }

    // Skill Affinity, +2 to intimidate
    if(GetHasFeat(FEAT_SA_INTIMIDATE))
    {
        SetCompositeBonus(oSkin, "SA_Intimidate", 2, ITEM_PROPERTY_SKILL_BONUS, SKILL_INTIMIDATE);
    }

    // Skill Affinity, +2 to balance
    if(GetHasFeat(FEAT_SA_BALANCE))
    {
        SetCompositeBonus(oSkin, "SA_Balance", 2, ITEM_PROPERTY_SKILL_BONUS, SKILL_BALANCE);
    }

    // Skill Affinity, +2 to heal
    if(GetHasFeat(FEAT_SA_HEAL))
    {
        SetCompositeBonus(oSkin, "SA_Heal", 2, ITEM_PROPERTY_SKILL_BONUS, SKILL_HEAL);
    }

    // Skill Affinity, +4 to jump
    if(GetHasFeat(FEAT_SA_JUMP_4))
    {
        SetCompositeBonus(oSkin, "SA_Jump_4", 4, ITEM_PROPERTY_SKILL_BONUS, 28);
    }

    // Leap, +5 to Jump
    if(GetHasFeat(FEAT_LEAP))
    {
        SetCompositeBonus(oSkin, "Leap", 5, ITEM_PROPERTY_SKILL_BONUS, 28);
    }

    // Thri-Kreen Leap
    if(GetHasFeat(FEAT_THRIKREEN_LEAP))
    {
        SetCompositeBonus(oSkin, "TKLeap", 30, ITEM_PROPERTY_SKILL_BONUS, 28);
    }

    // Skill Affinity, +4 to spot
    if(GetHasFeat(FEAT_SA_SPOT_4))
    {
        SetCompositeBonus(oSkin, "SA_Spot_4", 4, ITEM_PROPERTY_SKILL_BONUS, SKILL_SPOT);
    }

    // Skill Affinity, +4 to spot
    if(GetHasFeat(FEAT_KEEN_SIGHT))
    {
        SetCompositeBonus(oSkin, "Keen_Sight", 4, ITEM_PROPERTY_SKILL_BONUS, SKILL_SPOT);
    }

    // Bird's Eye, +6 to spot
    if(GetHasFeat(FEAT_BIRDSEYE))
    {
        SetCompositeBonus(oSkin, "Birdseye", 6, ITEM_PROPERTY_SKILL_BONUS, SKILL_SPOT);
    }

    // Skill Affinity, +4 to listen
    if(GetHasFeat(FEAT_SA_LISTEN_4))
    {
        SetCompositeBonus(oSkin, "SA_Listen_4", 4, ITEM_PROPERTY_SKILL_BONUS, SKILL_LISTEN);
    }

    // Skill Affinity, +4 to search
    if(GetHasFeat(FEAT_SA_SEARCH_4))
    {
        SetCompositeBonus(oSkin, "SA_Search_4", 4, ITEM_PROPERTY_SKILL_BONUS, SKILL_SEARCH);
    }

    // Skill Affinity, +4 to perform
    if(GetHasFeat(FEAT_SA_PERFORM_4))
    {
        SetCompositeBonus(oSkin, "SA_Perform_4", 4, ITEM_PROPERTY_SKILL_BONUS, SKILL_PERFORM);
    }

    // Skill Affinity, +2 to perform
    if(GetHasFeat(FEAT_SA_PERFORM))
    {
        SetCompositeBonus(oSkin, "SA_Perform", 2, ITEM_PROPERTY_SKILL_BONUS, SKILL_PERFORM);
    }

    // Skill Affinity, +2 to open locks
    if(GetHasFeat(FEAT_SA_OPEN))
    {
        SetCompositeBonus(oSkin, "SA_Open_Lock", 2, ITEM_PROPERTY_SKILL_BONUS, SKILL_OPEN_LOCK);
    }

    // Skill Affinity, +2 to sleight of hand/Pickpocket
    if(GetHasFeat(FEAT_SA_PICKPOCKET))
    {
        SetCompositeBonus(oSkin, "SA_Pickpocket", 2, ITEM_PROPERTY_SKILL_BONUS, SKILL_PICK_POCKET);
    }


   // Minotaur bonuses due to scent
    if(GetHasFeat(FEAT_MINOT_SCENT))
    {
        SetCompositeBonus(oSkin, "Minot_Scent_Spot", 4, ITEM_PROPERTY_SKILL_BONUS, SKILL_SPOT);
        SetCompositeBonus(oSkin, "Minot_Scent_Search", 4, ITEM_PROPERTY_SKILL_BONUS, SKILL_SEARCH);
        SetCompositeBonus(oSkin, "Minot_Scent_Listen", 4, ITEM_PROPERTY_SKILL_BONUS, SKILL_LISTEN);
    }

   // Kender Bonuses
    if(GetHasFeat(FEAT_KENDERBLUFF))
    {
        SetCompositeBonus(oSkin, "Kender_Bonus_Bluff", 4, ITEM_PROPERTY_SKILL_BONUS, SKILL_BLUFF);
        SetCompositeBonus(oSkin, "Kender_Bonus_Taunt", 4, ITEM_PROPERTY_SKILL_BONUS, SKILL_TAUNT);
    }

    // -4 to concentration
    if(GetHasFeat(FEAT_LACKOFFOCUS))
    {
        SetCompositeBonus(oSkin, "LackofFocus", 4, ITEM_PROPERTY_DECREASED_SKILL_MODIFIER, SKILL_CONCENTRATION);
    }

   // Gully Dwarf Liabilities
    if(GetHasFeat(FEAT_COWARDPITY))
    {
        SetCompositeBonus(oSkin, "Gully_Trait_Persuade", 4, ITEM_PROPERTY_SKILL_BONUS, SKILL_PERSUADE);
        SetCompositeBonus(oSkin, "Gully_Trait_Fear", 4, ITEM_PROPERTY_DECREASED_SAVING_THROWS_SPECIFIC, SPELL_FEAR);
    }
   
    // Skill Affinity, +2 to move silently
    if(GetHasFeat(FEAT_SA_MOVE))
    {
        SetCompositeBonus(oSkin, "SA_Move", 2, ITEM_PROPERTY_SKILL_BONUS, SKILL_MOVE_SILENTLY);
    }
   
    // Skill Affinity, +4 to move silently
    if(GetHasFeat(FEAT_SA_MOVE4))
    {
        SetCompositeBonus(oSkin, "SA_Move_4", 4, ITEM_PROPERTY_SKILL_BONUS, SKILL_MOVE_SILENTLY);
    }

    // Skill Affinity, +2 to craft armor
    if(GetHasFeat(FEAT_SA_CRFTARM))
    {
        SetCompositeBonus(oSkin, "SA_Craft_Armor", 2, ITEM_PROPERTY_SKILL_BONUS, SKILL_CRAFT_ARMOR);
    }
 
    // Skill Affinity, +2 to craft weapon
    if(GetHasFeat(FEAT_SA_CRFTWEAP))
    {
        SetCompositeBonus(oSkin, "SA_Craft_Weapon", 2, ITEM_PROPERTY_SKILL_BONUS, SKILL_CRAFT_WEAPON);
    }
 
    // Skill Affinity, +2 to craft trap
    if(GetHasFeat(FEAT_SA_CRFTTRAP))
    {
        SetCompositeBonus(oSkin, "SA_Craft_Trap", 2, ITEM_PROPERTY_SKILL_BONUS, SKILL_CRAFT_TRAP);
    }

    // Skill Affinity, +2 to hide
    if(GetHasFeat(FEAT_SA_HIDE))
    {
        SetCompositeBonus(oSkin, "SA_Hide", 2, ITEM_PROPERTY_SKILL_BONUS, SKILL_HIDE);
    }

    // Skill Affinity, +4 to hide
    // for forest gnomes since they get +4 or +8 in the woods.
    //also for Volodni, which only get hide bonuses in the forest
    if(GetHasFeat(FEAT_SA_HIDEF))
    {
        SetCompositeBonus(oSkin, "SA_Hide_Forest", 4, ITEM_PROPERTY_SKILL_BONUS, SKILL_HIDE);
    }

    // Skill Affinity, +4 to hide
    // for forest gnomes since they get +4 or +8 in the woods.
    if(GetHasFeat(FEAT_SA_HIDE4))
    {
        SetCompositeBonus(oSkin, "SA_Hide_4", 4, ITEM_PROPERTY_SKILL_BONUS, SKILL_HIDE);
    }

    // Skill Affinity, +2 to appraise
    // dwarves and deep halfings get racial +2 to appraise checks.
    if(GetHasFeat(FEAT_SA_APPRAISE))
    {
        SetCompositeBonus(oSkin, "SA_Appraise", 2, ITEM_PROPERTY_SKILL_BONUS, SKILL_APPRAISE);
    }

    // Skill Affinity, +6 to animal empathy
    if(GetHasFeat(FEAT_SA_ANIMAL_EMP_6))
    {
        SetCompositeBonus(oSkin, "SA_AnimalEmpathy_6", 6, ITEM_PROPERTY_SKILL_BONUS, SKILL_ANIMAL_EMPATHY);
    }

    // Skill Affinity, +2 to animal empathy
    if(GetHasFeat(FEAT_SA_ANIMAL_EMP))
    {
        SetCompositeBonus(oSkin, "SA_AnimalEmpathy_2", 2, ITEM_PROPERTY_SKILL_BONUS, SKILL_ANIMAL_EMPATHY);
    }

    // Skill Affinity, +2 to persuade
    if(GetHasFeat(FEAT_SA_PERSUADE))
    {
        SetCompositeBonus(oSkin, "SA_Persuade", 2, ITEM_PROPERTY_SKILL_BONUS, SKILL_PERSUADE);
    }

    // Skill Affinity, +2 to sense motive
    if(GetHasFeat(FEAT_SA_SENSE_MOTIVE))
    {
        SetCompositeBonus(oSkin, "SA_SenseMotive", 2, ITEM_PROPERTY_SKILL_BONUS, SKILL_SENSE_MOTIVE);
    }

    // Skill Affinity, +2 to tumble
    if(GetHasFeat(FEAT_SA_TUMBLE))
    {
        SetCompositeBonus(oSkin, "SA_Tumble", 2, ITEM_PROPERTY_SKILL_BONUS, SKILL_TUMBLE);
    }

    // Partial Skill Affinity, +1 to persuade
    if(GetHasFeat(FEAT_PSA_PERSUADE))
    {
        SetCompositeBonus(oSkin, "PSA_Persuade", 1, ITEM_PROPERTY_SKILL_BONUS, SKILL_PERSUADE);
    }

    // PSA to Lore and Spellcraft
    if(GetHasFeat(FEAT_PSA_LORESPELL))
    {
        SetCompositeBonus(oSkin, "PSA_Lorespell_Lore", 1, ITEM_PROPERTY_SKILL_BONUS, SKILL_LORE);
        SetCompositeBonus(oSkin, "PSA_Lorespell_Spell", 1, ITEM_PROPERTY_SKILL_BONUS, SKILL_SPELLCRAFT);
    }
    
    //+2 to save vs mind-affecting
    if(GetHasFeat(FEAT_BONUS_MIND_2))
    {
        itemproperty ipIP =ItemPropertyBonusSavingThrowVsX(IP_CONST_SAVEVS_MINDAFFECTING, 2);
        IPSafeAddItemProperty(oSkin, ipIP, 0.0, X2_IP_ADDPROP_POLICY_REPLACE_EXISTING, FALSE, FALSE);
    }
    
    
    //damage reduction 5/+1
    if(GetHasFeat(FEAT_DAM_RED5))
    {
        itemproperty ipIP =ItemPropertyDamageReduction(IP_CONST_DAMAGEREDUCTION_1, IP_CONST_DAMAGESOAK_5_HP);
        IPSafeAddItemProperty(oSkin, ipIP, 0.0, X2_IP_ADDPROP_POLICY_REPLACE_EXISTING, FALSE, FALSE);
    }

    //damage reduction 10/+1
    if(GetHasFeat(FEAT_DAM_RED10))
    {
        itemproperty ipIP =ItemPropertyDamageReduction(IP_CONST_DAMAGEREDUCTION_1, IP_CONST_DAMAGESOAK_10_HP);
        IPSafeAddItemProperty(oSkin, ipIP, 0.0, X2_IP_ADDPROP_POLICY_REPLACE_EXISTING, FALSE, FALSE);
    }

    //damage reduction 15/+1
    if(GetHasFeat(FEAT_DAM_RED15))
    {
        itemproperty ipIP =ItemPropertyDamageReduction(IP_CONST_DAMAGEREDUCTION_1, IP_CONST_DAMAGESOAK_15_HP);
        IPSafeAddItemProperty(oSkin, ipIP, 0.0, X2_IP_ADDPROP_POLICY_REPLACE_EXISTING, FALSE, FALSE);
    }

    //damage vulnerability cold 50%
    if(GetHasFeat(FEAT_VULN_COLD))
    {
        itemproperty ipIP = ItemPropertyDamageVulnerability(DAMAGE_TYPE_COLD, IP_CONST_DAMAGEVULNERABILITY_50_PERCENT);
        IPSafeAddItemProperty(oSkin, ipIP, 0.0, X2_IP_ADDPROP_POLICY_REPLACE_EXISTING, FALSE, FALSE);
    }

    //damage vulnerability fire 50%
    if(GetHasFeat(FEAT_VULN_FIRE))
    {
        itemproperty ipIP = ItemPropertyDamageVulnerability(DAMAGE_TYPE_FIRE, IP_CONST_DAMAGEVULNERABILITY_50_PERCENT);
        IPSafeAddItemProperty(oSkin, ipIP, 0.0, X2_IP_ADDPROP_POLICY_REPLACE_EXISTING, FALSE, FALSE);
    }
 
    //damage immunity 50% Piercing
    if(GetHasFeat(FEAT_PARTIAL_PIERCE_IMMUNE))
    {
        itemproperty ipIP = ItemPropertyDamageVulnerability(DAMAGE_TYPE_PIERCING, IP_CONST_DAMAGEVULNERABILITY_50_PERCENT);
        IPSafeAddItemProperty(oSkin, ipIP, 0.0, X2_IP_ADDPROP_POLICY_REPLACE_EXISTING, FALSE, FALSE);
    }

    //Svirfneblin dodge bonus (+4)
    if(GetHasFeat(FEAT_SVIRFNEBLIN_DODGE))
    {
        SetCompositeBonus(oSkin, "Svirf_Dodge", 4, ITEM_PROPERTY_AC_BONUS);
    }
    
    //Tinker Gnome guilds
    if(GetHasFeat(FEAT_LIFEPATH) && !(GetHasFeat(FEAT_CRAFTGUILD) || GetHasFeat(FEAT_TECHGUILD) || GetHasFeat(FEAT_SAGEGUILD)))
        StartDynamicConversation("race_lifepthconv", oPC, DYNCONV_EXIT_NOT_ALLOWED, FALSE, TRUE, oPC);
    
    if(GetHasFeat(FEAT_CRAFTGUILD))
    {
        SetCompositeBonus(oSkin, "SA_Craft_GuildA", 2, ITEM_PROPERTY_SKILL_BONUS, SKILL_CRAFT_ARMOR);
        SetCompositeBonus(oSkin, "SA_Craft_GuildW", 2, ITEM_PROPERTY_SKILL_BONUS, SKILL_CRAFT_WEAPON);
        SetCompositeBonus(oSkin, "SA_Craft_GuildT", 2, ITEM_PROPERTY_SKILL_BONUS, SKILL_CRAFT_TRAP);
    }
    if(GetHasFeat(FEAT_TECHGUILD))
    {
        SetCompositeBonus(oSkin, "SA_Tech_GuildA", 1, ITEM_PROPERTY_SKILL_BONUS, SKILL_CRAFT_ARMOR);
        SetCompositeBonus(oSkin, "SA_Tech_GuildW", 1, ITEM_PROPERTY_SKILL_BONUS, SKILL_CRAFT_WEAPON);
        SetCompositeBonus(oSkin, "SA_Tech_GuildT", 1, ITEM_PROPERTY_SKILL_BONUS, SKILL_CRAFT_TRAP);
        SetCompositeBonus(oSkin, "SA_Tech_GuildL", 1, ITEM_PROPERTY_SKILL_BONUS, SKILL_LORE);
    }
    if(GetHasFeat(FEAT_SAGEGUILD))
    {
        SetCompositeBonus(oSkin, "SA_Sage_Guild", 2, ITEM_PROPERTY_SKILL_BONUS, SKILL_LORE);
    }
    
    //"cheat" ac boosts to Warforged armor so it stacks properly
    if(GetHasFeat(FEAT_COMPOSITE_PLATING) &&
       !(GetHasFeat(FEAT_MITHRIL_PLATING) || GetHasFeat(FEAT_ADAMANTINE_PLATING) 
         || GetHasFeat(FEAT_IRONWOOD_PLATING) || GetHasFeat(FEAT_UNARMORED_BODY)))
        SetCompositeBonus(oSkin, "CompositePlating", 2, ITEM_PROPERTY_AC_BONUS);
    if(GetHasFeat(FEAT_MITHRIL_PLATING))
        SetCompositeBonus(oSkin, "MithrilPlating", 3, ITEM_PROPERTY_AC_BONUS);
    

    //Subdual to elements
    //implemented as resist 1/- for heat and cold
    if(GetHasFeat(FEAT_SUBDUAL))
    {
        itemproperty ipIP =ItemPropertyDamageResistance(IP_CONST_DAMAGETYPE_FIRE, IP_CONST_DAMAGERESIST_1);
        IPSafeAddItemProperty(oSkin, ipIP, 0.0, X2_IP_ADDPROP_POLICY_REPLACE_EXISTING, FALSE, FALSE);
        ipIP =ItemPropertyDamageResistance(IP_CONST_DAMAGETYPE_COLD, IP_CONST_DAMAGERESIST_1);
        IPSafeAddItemProperty(oSkin, ipIP, 0.0, X2_IP_ADDPROP_POLICY_REPLACE_EXISTING, FALSE, FALSE);
    }


    ///Buommans vow of silence
    if(GetHasFeat(FEAT_VOWOFSILENCE))
    {
        int nHasSilence = FALSE;
        effect eTest = GetFirstEffect(oPC);
        while(GetIsEffectValid(eTest) && !nHasSilence)
        {
            if(GetEffectType(eTest) == EFFECT_TYPE_SILENCE
                && GetEffectDurationType(eTest) == DURATION_TYPE_PERMANENT
                && GetEffectCreator(eTest) == oPC
                && GetEffectSubType(eTest) == SUBTYPE_SUPERNATURAL)
            {
                nHasSilence == TRUE;
            }
            eTest = GetNextEffect(oPC);
        }
        if(!nHasSilence)
        {
            effect eSilence = EffectSilence();
            eSilence = SupernaturalEffect(eSilence);
            AssignCommand(oPC, ApplyEffectToObject(DURATION_TYPE_PERMANENT, eSilence, oPC));
        }
    }
    
    //Wemic
    // Skill Bonus, +8 to jump
    if(GetHasFeat(FEAT_WEMIC_JUMP_8))
    {
        SetCompositeBonus(oSkin, "WEMIC_JUMP_8", 8, ITEM_PROPERTY_SKILL_BONUS, 28);
    } 
    
    // Metal hide - Bladeling armor restriction
    if(GetHasFeat(FEAT_METAL_HIDE))
    {
        ExecuteScript("race_bldlngrstct", oPC);
    } 
    
    //Warforged armor restrictions
    if(GetRacialType(oPC) == RACIAL_TYPE_WARFORGED)
    {
        ExecuteScript("race_warforged", oPC);
    }
    
    //natural weapons
    //replace with a feat check
    int nRace = GetRacialType(oPC);
    if(nRace==RACIAL_TYPE_MINOTAUR || nRace==RACIAL_TYPE_KRYNN_MINOTAUR)
    {
        string sResRef = "prc_mino_gore_";
        int nSize = PRCGetCreatureSize(oPC);
        sResRef += GetAffixForSize(nSize);
        AddNaturalSecondaryWeapon(oPC, sResRef);
    }
    else if(nRace==RACIAL_TYPE_TROLL)
    {
        string sResRef = "prc_troll_bite_";
        int nSize = PRCGetCreatureSize(oPC);
        sResRef += GetAffixForSize(nSize);
        AddNaturalSecondaryWeapon(oPC, sResRef);
        //primary weapon
        sResRef = "prc_claw_1d6l_";
        sResRef += GetAffixForSize(nSize);
        AddNaturalPrimaryWeapon(oPC, sResRef, 2);
    }
    else if(nRace==RACIAL_TYPE_RAKSHASA)
    {
        string sResRef = "prc_raks_bite_";
        int nSize = PRCGetCreatureSize(oPC);
        sResRef += GetAffixForSize(nSize);
        AddNaturalSecondaryWeapon(oPC, sResRef);
        //primary weapon
        sResRef = "prc_claw_1d6l_";
        sResRef += GetAffixForSize(nSize);
        AddNaturalPrimaryWeapon(oPC, sResRef, 2);
    }
    else if(nRace==RACIAL_TYPE_LIZARDFOLK)
    {
        string sResRef = "prc_lizf_bite_";
        int nSize = PRCGetCreatureSize(oPC);
        sResRef += GetAffixForSize(nSize);
        AddNaturalSecondaryWeapon(oPC, sResRef);
        //primary weapon
        sResRef = "prc_claw_1d6m_";
        sResRef += GetAffixForSize(nSize);
        AddNaturalPrimaryWeapon(oPC, sResRef, 2);
    }
    else if(nRace==RACIAL_TYPE_TANARUKK)
    {
        string sResRef = "prc_tana_bite_";
        int nSize = PRCGetCreatureSize(oPC);
        sResRef += GetAffixForSize(nSize);
        AddNaturalSecondaryWeapon(oPC, sResRef);
    }
    else if(nRace==RACIAL_TYPE_WEMIC)
    {
        string sResRef = "prc_claw_1d6l_";
        int nSize = PRCGetCreatureSize(oPC);
        sResRef += GetAffixForSize(nSize);
        AddNaturalPrimaryWeapon(oPC, sResRef, 2);
    }
    else if(nRace==RACIAL_TYPE_ILLITHID)
    {
        string sResRef = "prc_ill_tent_";
        int nSize = PRCGetCreatureSize(oPC);
        sResRef += GetAffixForSize(nSize);
        AddNaturalPrimaryWeapon(oPC, sResRef, 4);
    }
    else if(nRace==RACIAL_TYPE_CENTAUR)
    {
        string sResRef = "prc_cent_hoof_";
        int nSize = PRCGetCreatureSize(oPC);
        sResRef += GetAffixForSize(nSize);
        AddNaturalPrimaryWeapon(oPC, sResRef, 2);
    }
    else if(nRace==RACIAL_TYPE_ASABI)
    {
        string sResRef = "prc_lizf_bite_";
        int nSize = PRCGetCreatureSize(oPC);
        sResRef += GetAffixForSize(nSize);
        AddNaturalSecondaryWeapon(oPC, sResRef);
    }
    else if(nRace==RACIAL_TYPE_DRAGONKIN)
    {
        //primary weapon
        string sResRef = "prc_claw_1d6l_";
        int nSize = PRCGetCreatureSize(oPC);
        sResRef += GetAffixForSize(nSize);
        AddNaturalPrimaryWeapon(oPC, sResRef, 2);
    }
    else if(nRace==RACIAL_TYPE_KHAASTA)
    {
        string sResRef = "prc_lizf_bite_";
        int nSize = PRCGetCreatureSize(oPC);
        sResRef += GetAffixForSize(nSize);
        AddNaturalSecondaryWeapon(oPC, sResRef);
    }
    else if(nRace==RACIAL_TYPE_NEZUMI)
    {
        string sResRef = "prc_lizf_bite_";
        int nSize = PRCGetCreatureSize(oPC);
        sResRef += GetAffixForSize(nSize);
        AddNaturalSecondaryWeapon(oPC, sResRef);
        //primary weapon
        sResRef = "prc_claw_1d6l_";
        sResRef += GetAffixForSize(nSize);
        AddNaturalPrimaryWeapon(oPC, sResRef, 2);
    }
    else if(nRace==RACIAL_TYPE_POISON_DUSK)
    {
        string sResRef = "prc_lizf_bite_";
        int nSize = PRCGetCreatureSize(oPC);
        sResRef += GetAffixForSize(nSize);
        AddNaturalSecondaryWeapon(oPC, sResRef);
        //primary weapon
        sResRef = "prc_claw_1d6l_";
        sResRef += GetAffixForSize(nSize);
        AddNaturalPrimaryWeapon(oPC, sResRef, 2);
    }
    else if(nRace==RACIAL_TYPE_HOUND_ARCHON)
    {
        string sResRef = "prc_hdarc_bite_";
        int nSize = PRCGetCreatureSize(oPC);
        sResRef += GetAffixForSize(nSize);
        AddNaturalSecondaryWeapon(oPC, sResRef);
        //primary weapon
        sResRef = "prc_hdarc_slam_";
        sResRef += GetAffixForSize(nSize);
        AddNaturalPrimaryWeapon(oPC, sResRef, 1);
    }
    else if(nRace==RACIAL_TYPE_BLADELING)
    {
        int nSize = PRCGetCreatureSize(oPC);
        //primary weapon
        string sResRef = "prc_claw_1d6m_";
        sResRef += GetAffixForSize(nSize);
        AddNaturalPrimaryWeapon(oPC, sResRef, 2);
    }
    else if(nRace==RACIAL_TYPE_DRIDER)
    {
        int nSize = PRCGetCreatureSize(oPC);
        //secondary weapon
        string sResRef = "prc_drid_bite_";
        sResRef += GetAffixForSize(nSize);
        AddNaturalSecondaryWeapon(oPC, sResRef);
    }
    else if(nRace==RACIAL_TYPE_BOZAK)
    {
        string sResRef = "prc_raks_bite_";
        int nSize = PRCGetCreatureSize(oPC);
        sResRef += GetAffixForSize(nSize);
        AddNaturalSecondaryWeapon(oPC, sResRef);
        //primary weapon
        sResRef = "prc_claw_1d6l_";
        sResRef += GetAffixForSize(nSize);
        AddNaturalPrimaryWeapon(oPC, sResRef, 2);
    }
    else if(nRace==RACIAL_TYPE_BAAZ)
    {
        string sResRef = "prc_lizf_bite_";
        int nSize = PRCGetCreatureSize(oPC);
        sResRef += GetAffixForSize(nSize);
        AddNaturalSecondaryWeapon(oPC, sResRef);
        //primary weapon
        sResRef = "prc_claw_1d6l_";
        sResRef += GetAffixForSize(nSize);
        AddNaturalPrimaryWeapon(oPC, sResRef, 2);
    }
    else if(nRace==RACIAL_TYPE_KAPAK)
    {
        string sResRef = "prc_lizf_bite_";
        int nSize = PRCGetCreatureSize(oPC);
        sResRef += GetAffixForSize(nSize);
        AddNaturalSecondaryWeapon(oPC, sResRef);
    }
    else if(nRace==RACIAL_TYPE_WARFORGED)
    {
        string sResRef;
        int nSize = PRCGetCreatureSize(oPC);
        //primary weapon
        sResRef = "prc_warf_slam_";
        sResRef += GetAffixForSize(nSize);
        AddNaturalPrimaryWeapon(oPC, sResRef, 1);
    }
    
    //Draconian on-death effects
    if(nRace == RACIAL_TYPE_BOZAK || nRace == RACIAL_TYPE_BAAZ || nRace == RACIAL_TYPE_KAPAK)
    {
    	SetCreatureWingType(CREATURE_WING_TYPE_DRAGON, oPC);
        ExecuteScript("race_deaththroes", oPC);
    }
}