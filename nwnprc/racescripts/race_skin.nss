
// Handle skin and other mods for races.
// This file is where various content users can customize races.

#include "prc_feat_const"
#include "inc_item_props"
#include "x2_inc_itemprop"

void main()
{
    object oSkin = GetPCSkin(OBJECT_SELF);

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
    if(GetHasFeat(FEAT_NONDETECTION))
    {
        itemproperty ipIP = ItemPropertySpellImmunitySpecific(SPELL_SEE_INVISIBILITY);
        IPSafeAddItemProperty(oSkin, ipIP, 0.0, X2_IP_ADDPROP_POLICY_REPLACE_EXISTING, FALSE, FALSE);
        ipIP = ItemPropertySpellImmunitySpecific(SPELL_TRUE_SEEING);
        IPSafeAddItemProperty(oSkin, ipIP, 0.0, X2_IP_ADDPROP_POLICY_REPLACE_EXISTING, FALSE, FALSE);
        ipIP = ItemPropertySpellImmunitySpecific(SPELL_DARKVISION);
        IPSafeAddItemProperty(oSkin, ipIP, 0.0, X2_IP_ADDPROP_POLICY_REPLACE_EXISTING, FALSE, FALSE);
    }

    //immunity to artificial posions
    //replaced with immunity to all poisins
    if(GetHasFeat(FEAT_IMM_APOI))
    {
        itemproperty ipIP =ItemPropertyImmunityMisc(IP_CONST_IMMUNITYMISC_POISON);
        IPSafeAddItemProperty(oSkin, ipIP, 0.0, X2_IP_ADDPROP_POLICY_REPLACE_EXISTING, FALSE, FALSE);
    }

    //natural armor 1-10
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

    //immunity to drown and mass drown
    if(GetHasFeat(FEAT_BREATHLESS))
    {
        itemproperty ipIP = ItemPropertySpellImmunitySpecific(SPELL_DROWN);
        IPSafeAddItemProperty(oSkin, ipIP, 0.0, X2_IP_ADDPROP_POLICY_REPLACE_EXISTING, FALSE, FALSE);
        ipIP = ItemPropertySpellImmunitySpecific(SPELL_MASS_DROWN  );
        IPSafeAddItemProperty(oSkin, ipIP, 0.0, X2_IP_ADDPROP_POLICY_REPLACE_EXISTING, FALSE, FALSE);
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
        SetCompositeBonus(oSkin, "RacialSize", 5, ITEM_PROPERTY_REGENERATION);
    }

    //fire resistance 5
    if(GetHasFeat(FEAT_RESIST_FIRE5))
    {
        itemproperty ipIP =ItemPropertyDamageResistance(IP_CONST_DAMAGETYPE_FIRE, IP_CONST_DAMAGERESIST_5);
        IPSafeAddItemProperty(oSkin, ipIP, 0.0, X2_IP_ADDPROP_POLICY_REPLACE_EXISTING, FALSE, FALSE);
    }

}