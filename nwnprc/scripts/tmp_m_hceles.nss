//::///////////////////////////////////////////////
//:: Name           Half-Celestial template script
//:: FileName       tmp_m_hceles
//:: Copyright (c) 2001 Bioware Corp.
//:://////////////////////////////////////////////
/*
    Half-Celestial
    
    No matter the form, half-celestials are always comely and delightful to the senses, having golden skin,
    sparkling eyes, angelic wings, or some other sign of their higher nature.
    
    Creating A Half-Celestial
    
    "Half-celestial" is an inherited template that can be added to any living, corporeal creature with an 
    Intelligence score of 4 or higher and nonevil alignment (referred to hereafter as the base creature).
    
    A half-celestial uses all the base creature’s statistics and special abilities except as noted here.
    
    Size and Type
    
    The creature’s type changes to outsider. Do not recalculate the creature’s Hit Dice, base attack bonus, 
    or saves. Size is unchanged. Half-celestials are normally native outsiders.
    
    Speed
    
    A half-celestial has feathered wings and can fly at twice the base creature’s base land speed 
    (good maneuverability). If the base creature has a fly speed, use that instead.
    
    Armor Class
    
    Natural armor improves by +1 (this stacks with any natural armor bonus the base creature has).
    
    Special Attacks
    
    A half-celestial retains all the special attacks of the base creature and also gains the following special 
    abilities.
    
    Daylight (Su)
    
    Half-celestials can use a daylight effect (as the spell) at will.
    
    Smite Evil (Su)
    
    Once per day a half-celestial can make a normal melee attack to deal extra damage equal to its HD 
    (maximum of +20) against an evil foe.
    
    HD  Abilities
    1-2     Protection from evil 3/day, bless
    3-4     Aid, detect evil
    5-6     Cure serious wounds, neutralize poison
    7-8     Holy smite, remove disease
    9-10    Dispel evil
    11-12   Holy word
    13-14   Holy aura 3/day, hallow
    15-16   Mass charm monster
    17-18   Summon monster IX (celestials only)
    19-20   Resurrection
    
    Spell-Like Abilities
    
    A half-celestial with an Intelligence or Wisdom score of 8 or higher has two or more spell-like abilities, 
    depending on its Hit Dice, as indicated on the table below. The abilities are cumulative
    
    Unless otherwise noted, an ability is usable once per day. Caster level equals the creature’s HD, and the 
    save DC is Charisma-based.
    
    Special Qualities
    
    A half-celestial has all the special qualities of the base creature, plus the following special qualities.
    
        * Darkvision out to 60 feet.
        * Immunity to disease.
        * Resistance to acid 10, cold 10, and electricity 10.
        * Damage reduction: 5/magic (if HD 11 or less) or 10/magic (if HD 12 or more).
        * A half-celestial’s natural weapons are treated as magic weapons for the purpose of overcoming damage reduction.
        * Spell resistance equal to creature’s HD + 10 (maximum 35).
        * +4 racial bonus on Fortitude saves against poison.
    
    Abilities
    
    Increase from the base creature as follows: Str +4, Dex +2, Con +4, Int +2, Wis +4, Cha +4.
    
    Skills
    
    A half-celestial gains skill points as an outsider and has skill points equal to (8 + Int modifier) × (HD +3). 
    Do not include Hit Dice from class levels in this calculation—the half-celestial gains outsider skill points only for its racial Hit Dice, and gains the normal amount of skill points for its class levels. Treat skills from the base creature’s list as class skills, and other skills as cross-class.
    
    Challenge Rating
    
    HD 5 or less, as base creature +1; HD 6 to 10, as base creature +2; HD 11 or more, as base creature +3.
    
    Alignment
    
    Always good (any).
    
    Level Adjustment
    
    Same as base creature +4. 

*/
//:://////////////////////////////////////////////
//:: Created By: Primogenitor
//:: Created On: 18/04/06
//:://////////////////////////////////////////////

#include "prc_alterations"
#include "prc_inc_template"

void main()
{
    object oPC = OBJECT_SELF;
    object oSkin = GetPCSkin(oPC);
    int nHD = GetHitDice(oPC);
    itemproperty ipIP;
    
    //wings
    DoWings(oPC, CREATURE_WING_TYPE_ANGEL);
    //naturalAC
    SetCompositeBonus(oSkin, "Template_hceles_natAC", 1, ITEM_PROPERTY_AC_BONUS); 
    //darkvision
    ipIP = ItemPropertyDarkvision();
    IPSafeAddItemProperty(oSkin, ipIP, 0.0);
    //immunity to disease
    ipIP = ItemPropertyImmunityMisc(IP_CONST_IMMUNITYMISC_DISEASE);
    IPSafeAddItemProperty(oSkin, ipIP, 0.0);
    //resistance to acid 10 cold 10 elec 10
    ipIP = ItemPropertyDamageResistance(IP_CONST_DAMAGETYPE_COLD, IP_CONST_DAMAGERESIST_10);
    IPSafeAddItemProperty(oSkin, ipIP, 0.0);
    ipIP = ItemPropertyDamageResistance(IP_CONST_DAMAGETYPE_ACID, IP_CONST_DAMAGERESIST_10);
    IPSafeAddItemProperty(oSkin, ipIP, 0.0);
    ipIP = ItemPropertyDamageResistance(IP_CONST_DAMAGETYPE_ELECTRICAL, IP_CONST_DAMAGERESIST_10);
    IPSafeAddItemProperty(oSkin, ipIP, 0.0);
    //damage reduction 5/+1 or 10/+1
    if(nHD <= 11)
    {
        ipIP = ItemPropertyDamageReduction(IP_CONST_DAMAGEREDUCTION_1, IP_CONST_DAMAGESOAK_5_HP);
        IPSafeAddItemProperty(oSkin, ipIP, 0.0);
    }
    else if(nHD >= 12)
    {
        ipIP = ItemPropertyDamageReduction(IP_CONST_DAMAGEREDUCTION_1, IP_CONST_DAMAGESOAK_10_HP);
        IPSafeAddItemProperty(oSkin, ipIP, 0.0);
    }
    //SR
    int nSR = nHD+10;
    if(nSR > 35)
        nSR = 35;
    ipIP = ItemPropertyBonusSpellResistance(GetSRByValue(nSR));
    IPSafeAddItemProperty(oSkin, ipIP, 0.0);
    //+4 vs poison
    SetCompositeBonus(oSkin, "Template_hceles_poison", 4, ITEM_PROPERTY_SAVING_THROW_BONUS_SPECIFIC, IP_CONST_SAVEVS_POISON); 
    //ability mods
    SetCompositeBonus(oSkin, "Template_hceles_str", 4, ITEM_PROPERTY_ABILITY_BONUS, IP_CONST_ABILITY_STR); 
    SetCompositeBonus(oSkin, "Template_hceles_dex", 2, ITEM_PROPERTY_ABILITY_BONUS, IP_CONST_ABILITY_DEX); 
    SetCompositeBonus(oSkin, "Template_hceles_con", 4, ITEM_PROPERTY_ABILITY_BONUS, IP_CONST_ABILITY_CON); 
    SetCompositeBonus(oSkin, "Template_hceles_int", 2, ITEM_PROPERTY_ABILITY_BONUS, IP_CONST_ABILITY_INT); 
    SetCompositeBonus(oSkin, "Template_hceles_wis", 4, ITEM_PROPERTY_ABILITY_BONUS, IP_CONST_ABILITY_WIS); 
    SetCompositeBonus(oSkin, "Template_hceles_cha", 4, ITEM_PROPERTY_ABILITY_BONUS, IP_CONST_ABILITY_CHA); 
    if(!GetHasFeat(FEAT_TEMPLATE_HALF_CELESTIAL_SMITE_EVIL))
    {
    //smite evil
        ipIP = PRCItemPropertyBonusFeat(IP_CONST_FEAT_TEMPLATE_HALF_CELESTIAL_SMITE_EVIL);
        IPSafeAddItemProperty(oSkin, ipIP, 0.0); 
    }
    if(!GetHasFeat(FEAT_TEMPLATE_HALF_CELESTIAL_MARKER))
    {
    //marker feat
        ipIP = PRCItemPropertyBonusFeat(IP_CONST_FEAT_TEMPLATE_HALF_CELESTIAL_MARKER);
        IPSafeAddItemProperty(oSkin, ipIP, 0.0); 
    }    
    //daylight
//TO BE ADDED
    //SLAs
    if(GetAbilityScore(oPC,ABILITY_WISDOM, TRUE) >= 8 
        || GetAbilityScore(oPC, ABILITY_INTELLIGENCE, TRUE) >= 8)
    {   
        //protection from evil 3/day
        if(!GetHasFeat(FEAT_TEMPLATE_HALF_CELESTIAL_PROTECTION))
        {
            ipIP = PRCItemPropertyBonusFeat(IP_CONST_FEAT_TEMPLATE_HALF_CELESTIAL_PROTECTION);
            IPSafeAddItemProperty(oSkin, ipIP, 0.0); 
        }    
        //bless 1/day
        if(!GetHasFeat(FEAT_TEMPLATE_HALF_CELESTIAL_BLESS))
        {
            ipIP = PRCItemPropertyBonusFeat(IP_CONST_FEAT_TEMPLATE_HALF_CELESTIAL_BLESS);
            IPSafeAddItemProperty(oSkin, ipIP, 0.0); 
        }
        if(nHD >= 3)
        {
            //aid 1/day
            if(!GetHasFeat(FEAT_TEMPLATE_HALF_CELESTIAL_AID))
            {
                ipIP = PRCItemPropertyBonusFeat(IP_CONST_FEAT_TEMPLATE_HALF_CELESTIAL_AID);
                IPSafeAddItemProperty(oSkin, ipIP, 0.0); 
            }
            //detect evil 1/day
            if(!GetHasFeat(FEAT_TEMPLATE_HALF_CELESTIAL_DETECT))
            {
                ipIP = PRCItemPropertyBonusFeat(IP_CONST_FEAT_TEMPLATE_HALF_CELESTIAL_DETECT);
                IPSafeAddItemProperty(oSkin, ipIP, 0.0); 
            }    
        }   
        if(nHD >= 5)
        {
            //cure serious wounds 1/day
            if(!GetHasFeat(FEAT_TEMPLATE_HALF_CELESTIAL_CURE_SERIOUS))
            {
                ipIP = PRCItemPropertyBonusFeat(IP_CONST_FEAT_TEMPLATE_HALF_CELESTIAL_CURE_SERIOUS);
                IPSafeAddItemProperty(oSkin, ipIP, 0.0); 
            }    
            //neutralize poison 1/day
            if(!GetHasFeat(FEAT_TEMPLATE_HALF_CELESTIAL_NEUTRALIZE_POISON))
            {
                ipIP = PRCItemPropertyBonusFeat(IP_CONST_FEAT_TEMPLATE_HALF_CELESTIAL_NEUTRALIZE_POISON);
                IPSafeAddItemProperty(oSkin, ipIP, 0.0); 
            }
        }   
        if(nHD >= 7)
        {
            //holy smite 1/day
//TO BE ADDED
            //remove disease 1/day
            if(!GetHasFeat(FEAT_TEMPLATE_HALF_CELESTIAL_REMOVE_DISEASE))
            {
                ipIP = PRCItemPropertyBonusFeat(IP_CONST_FEAT_TEMPLATE_HALF_CELESTIAL_REMOVE_DISEASE);
                IPSafeAddItemProperty(oSkin, ipIP, 0.0); 
            }
        }   
        if(nHD >= 9)
        {
            //dispel evil 1/day
//TO BE ADDED
        }   
        if(nHD >= 11)
        {
            //holy word 1/day
            if(!GetHasFeat(FEAT_TEMPLATE_HALF_CELESTIAL_HOLY_WORD))
            {
                ipIP = PRCItemPropertyBonusFeat(IP_CONST_FEAT_TEMPLATE_HALF_CELESTIAL_HOLY_WORD);
                IPSafeAddItemProperty(oSkin, ipIP, 0.0); 
            }
        }   
        if(nHD >= 13)
        {
            //holy aura 3.day
//TO BE ADDED
            //hallow 1/day
//TO BE ADDED
        }   
        if(nHD >= 15)
        {
            //mass charm monster 1/day
            if(!GetHasFeat(FEAT_TEMPLATE_HALF_CELESTIAL_MASS_CHARM))
            {
                ipIP = PRCItemPropertyBonusFeat(IP_CONST_FEAT_TEMPLATE_HALF_CELESTIAL_MASS_CHARM);
                IPSafeAddItemProperty(oSkin, ipIP, 0.0); 
            }    
        }   
        if(nHD >= 17)
        {
            //summon monster IX 1/day
            if(!GetHasFeat(FEAT_TEMPLATE_HALF_CELESTIAL_SUMMON_IX))
            {
                ipIP = PRCItemPropertyBonusFeat(IP_CONST_FEAT_TEMPLATE_HALF_CELESTIAL_SUMMON_IX);
                IPSafeAddItemProperty(oSkin, ipIP, 0.0); 
            }    
        }   
        if(nHD >= 19)
        {
            //resurrection
            if(!GetHasFeat(FEAT_TEMPLATE_HALF_CELESTIAL_RESURRECTION))
            {
                ipIP = PRCItemPropertyBonusFeat(IP_CONST_FEAT_TEMPLATE_HALF_CELESTIAL_RESURRECTION);
                IPSafeAddItemProperty(oSkin, ipIP, 0.0); 
            }
        }   
    }    
}