
// Handle skin and other mods for races.
// This file is where various content users can customize races.

#include "prc_feat_const"
#include "prc_spell_const"
#include "inc_item_props"
#include "x2_inc_itemprop"

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
             object oItem = GetPCItemLastUnequipped();
             SetCompositeDamageBonusT(oItem, "AzerFlameDamage", 0, IP_CONST_DAMAGETYPE_FIRE);
         }
         else
         {
             object oItem = GetItemInSlot(INVENTORY_SLOT_RIGHTHAND, oPC);
             if (!GetIsObjectValid(oItem))
             {
                 oItem = GetItemInSlot(INVENTORY_SLOT_ARMS, oPC);
                 SetCompositeDamageBonusT(oItem, "AzerFlameDamage", 1, IP_CONST_DAMAGETYPE_FIRE);
             }
             else
             {
                 SetCompositeDamageBonusT(oItem, "AzerFlameDamage", 1, IP_CONST_DAMAGETYPE_FIRE);

                 oItem = GetItemInSlot(INVENTORY_SLOT_LEFTHAND, oPC);
                 // check to make sure the weapon is not a shield or torch
                 if (GetBaseItemType(oItem) != BASE_ITEM_SMALLSHIELD && GetBaseItemType(oItem) != BASE_ITEM_LARGESHIELD &&
                     GetBaseItemType(oItem) != BASE_ITEM_TOWERSHIELD && GetBaseItemType(oItem) != BASE_ITEM_TORCH &&
                     GetIsObjectValid(oItem))
                         SetCompositeDamageBonusT(oItem, "AzerFlameDamage", 1, IP_CONST_DAMAGETYPE_FIRE);
             }
         }
    }
    
    //-1AC, -1 ATT, -4hide
    if(GetHasFeat(FEAT_LARGE))
    {
        SetCompositeBonus(oSkin, "RacialSize", 1, ITEM_PROPERTY_DECREASED_AC);
        SetCompositeBonus(oSkin, "RacialSize", 1, ITEM_PROPERTY_DECREASED_ATTACK_MODIFIER);
        SetCompositeBonus(oSkin, "RacialSize", 4, ITEM_PROPERTY_DECREASED_SKILL_MODIFIER, SKILL_HIDE);
    }

    //-2AC, -2 ATT, -8hide
    if(GetHasFeat(FEAT_HUGE))
    {
        SetCompositeBonus(oSkin, "RacialSize", 2, ITEM_PROPERTY_DECREASED_AC);
        SetCompositeBonus(oSkin, "RacialSize", 2, ITEM_PROPERTY_DECREASED_ATTACK_MODIFIER);
        SetCompositeBonus(oSkin, "RacialSize", 8, ITEM_PROPERTY_DECREASED_SKILL_MODIFIER, SKILL_HIDE);
    }

    //+2AC, +2 ATT, +8hide
    if(GetHasFeat(FEAT_TINY))
    {
        SetCompositeBonus(oSkin, "RacialSize", 2, ITEM_PROPERTY_AC_BONUS);
        SetCompositeBonus(oSkin, "RacialSize", 2, ITEM_PROPERTY_ATTACK_BONUS);
        SetCompositeBonus(oSkin, "RacialSize", 8, ITEM_PROPERTY_SKILL_BONUS, SKILL_HIDE);
    }

    //regeneration 5PH/round
    if(GetHasFeat(FEAT_REGEN5))
    {
        SetCompositeBonus(oSkin, "RacialRegeneration", 5, ITEM_PROPERTY_REGENERATION);
    }

    //regeneration 2PH/round
    if(GetHasFeat(FEAT_REGEN2))
    {
        SetCompositeBonus(oSkin, "RacialRegeneration", 2, ITEM_PROPERTY_REGENERATION);
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
        SetCompositeBonus(oSkin, "SA_Open_Locks", 2, ITEM_PROPERTY_SKILL_BONUS, SKILL_OPEN_LOCKS);
    }

   // Minotaur bonuses due to scent
    if(GetHasFeat(FEAT_MINOT_SCENT))
    {
        SetCompositeBonus(oSkin, "Minot_Scent", 4, ITEM_PROPERTY_SKILL_BONUS, SKILL_SPOT);
        SetCompositeBonus(oSkin, "Minot_Scent", 4, ITEM_PROPERTY_SKILL_BONUS, SKILL_SEARCH);
        SetCompositeBonus(oSkin, "Minot_Scent", 4, ITEM_PROPERTY_SKILL_BONUS, SKILL_LISTEN);
    }

   // Kender Bonuses
    if(GetHasFeat(FEAT_KENDERBLUFF))
    {
        SetCompositeBonus(oSkin, "Kender_Bonus", 4, ITEM_PROPERTY_SKILL_BONUS, SKILL_BLUFF);
        SetCompositeBonus(oSkin, "Kender_Bonus", 4, ITEM_PROPERTY_SKILL_BONUS, SKILL_TAUNT);
    }

    // -4 to concentration
    if(GetHasFeat(FEAT_LACKOFFOCUS))
    {
        SetCompositeBonus(oSkin, "LackofFocus", 4, ITEM_PROPERTY_DECREASED_SKILL_MODIFIER, SKILL_CONCENTRATION);
    }

   // Gully Dwarf Liabilities
    if(GetHasFeat(FEAT_COWARDPITY))
    {
        SetCompositeBonus(oSkin, "Gully_Trait", 4, ITEM_PROPERTY_SKILL_BONUS, SKILL_PERSUADE);
        SetCompositeBonus(oSkin, "Gully_Trait", 4, ITEM_PROPERTY_DECREASED_SAVING_THROWS_SPECIFIC, SPELL_FEAR);
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

    // Skill Affinity, +2 to hide
    if(GetHasFeat(FEAT_SA_HIDE))
    {
        SetCompositeBonus(oSkin, "SA_Hide", 2, ITEM_PROPERTY_SKILL_BONUS, SKILL_HIDE);
    }

    // Skill Affinity, +4 to hide
    // for forest gnomes since they get +4 or +8 in the woods.
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

    // Chameleon Skin, +5 to hide
    if(GetHasFeat(FEAT_CHAMELEON))
    {
        SetCompositeBonus(oSkin, "Chameleon", 5, ITEM_PROPERTY_SKILL_BONUS, SKILL_HIDE);
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
        SetCompositeBonus(oSkin, "SA_AnimalEmpathy", 6, ITEM_PROPERTY_SKILL_BONUS, SKILL_ANIMAL_EMPATHY);
    }

    // Skill Affinity, +2 to animal empathy
    if(GetHasFeat(FEAT_SA_ANIMAL_EMP))
    {
        SetCompositeBonus(oSkin, "SA_AnimalEmpathy_6", 2, ITEM_PROPERTY_SKILL_BONUS, SKILL_ANIMAL_EMPATHY);
    }

    // Partial Skill Affinity, +1 to persuade
    if(GetHasFeat(FEAT_PSA_PERSUADE))
    {
        SetCompositeBonus(oSkin, "PSA_Persuade", 1, ITEM_PROPERTY_SKILL_BONUS, SKILL_ANIMAL_EMPATHY);
    }

    // PSA to Lore and Spellcraft
    if(GetHasFeat(FEAT_PSA_LORESPELL))
    {
        SetCompositeBonus(oSkin, "PSA_Lorespell", 1, ITEM_PROPERTY_SKILL_BONUS, SKILL_LORE);
        SetCompositeBonus(oSkin, "PSA_Lorespell", 1, ITEM_PROPERTY_SKILL_BONUS, SKILL_SPELLCRAFT);
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
 
    //Svirfneblin dodge bonus (+4)
    if(GetHasFeat(FEAT_SVIRFNEBLIN_DODGE))
    {
        SetCompositeBonus(oSkin, "Svirf_Dodge", 4, ITEM_PROPERTY_AC_BONUS);
    }
}