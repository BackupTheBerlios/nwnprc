
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

    //immunity to artificial posions
    //replaced with immunity to all poisins
    if(GetHasFeat(FEAT_IMM_APOI))
    {
        itemproperty ipIP =ItemPropertyImmunityMisc(IP_CONST_IMMUNITYMISC_POISON);
        IPSafeAddItemProperty(oSkin, ipIP, 0.0, X2_IP_ADDPROP_POLICY_REPLACE_EXISTING, FALSE, FALSE);
    }

    //natural armor 1-10
    // Note: This bonus will be Dodge bonus no matter what IP_CONST you specify.
    if(GetHasFeat(FEAT_NATARM_1))
        SetCompositeBonus(oSkin, "RacialNaturalArmor", 1, ITEM_PROPERTY_AC_BONUS, IP_CONST_ACMODIFIERTYPE_NATURAL);
    else if(GetHasFeat(FEAT_NATARM_2))
        SetCompositeBonus(oSkin, "RacialNaturalArmor", 2, ITEM_PROPERTY_AC_BONUS, IP_CONST_ACMODIFIERTYPE_NATURAL);
    else if(GetHasFeat(FEAT_NATARM_3))
        SetCompositeBonus(oSkin, "RacialNaturalArmor", 3, ITEM_PROPERTY_AC_BONUS, IP_CONST_ACMODIFIERTYPE_NATURAL);
    else if(GetHasFeat(FEAT_NATARM_4))
        SetCompositeBonus(oSkin, "RacialNaturalArmor", 4, ITEM_PROPERTY_AC_BONUS, IP_CONST_ACMODIFIERTYPE_NATURAL);
    else if(GetHasFeat(FEAT_NATARM_5))
        SetCompositeBonus(oSkin, "RacialNaturalArmor", 5, ITEM_PROPERTY_AC_BONUS, IP_CONST_ACMODIFIERTYPE_NATURAL);
    else if(GetHasFeat(FEAT_NATARM_6))
        SetCompositeBonus(oSkin, "RacialNaturalArmor", 6, ITEM_PROPERTY_AC_BONUS, IP_CONST_ACMODIFIERTYPE_NATURAL);
    else if(GetHasFeat(FEAT_NATARM_7))
        SetCompositeBonus(oSkin, "RacialNaturalArmor", 7, ITEM_PROPERTY_AC_BONUS, IP_CONST_ACMODIFIERTYPE_NATURAL);
    else if(GetHasFeat(FEAT_NATARM_8))
        SetCompositeBonus(oSkin, "RacialNaturalArmor", 8, ITEM_PROPERTY_AC_BONUS, IP_CONST_ACMODIFIERTYPE_NATURAL);
    else if(GetHasFeat(FEAT_NATARM_9))
        SetCompositeBonus(oSkin, "RacialNaturalArmor", 9, ITEM_PROPERTY_AC_BONUS, IP_CONST_ACMODIFIERTYPE_NATURAL);
    else if(GetHasFeat(FEAT_NATARM_10))
        SetCompositeBonus(oSkin, "RacialNaturalArmor",10, ITEM_PROPERTY_AC_BONUS, IP_CONST_ACMODIFIERTYPE_NATURAL);

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
             SetCompositeDamageBonusT(oItem, "AzerFlameDamage", 1, IP_CONST_DAMAGETYPE_FIRE);
             oItem = GetItemInSlot(INVENTORY_SLOT_LEFTHAND, oPC);
             
             // check to make sure the weapon is not a shield or torch
             SetCompositeDamageBonusT(oItem, "AzerFlameDamage", 1, IP_CONST_DAMAGETYPE_FIRE); 
         }
    }
    
    //-1AC, -4hide
    if(GetHasFeat(FEAT_LARGE))
    {
        SetCompositeBonus(oSkin, "RacialSize", 1, ITEM_PROPERTY_DECREASED_AC);
        SetCompositeBonus(oSkin, "RacialSize", 4, ITEM_PROPERTY_DECREASED_SKILL_MODIFIER, SKILL_HIDE);
    }

    //regeneration 5PH/round
    if(GetHasFeat(FEAT_REGEN5))
    {
        SetCompositeBonus(oSkin, "RacialRegeneration", 5, ITEM_PROPERTY_REGENERATION);
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
}