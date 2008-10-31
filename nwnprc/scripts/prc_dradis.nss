//::///////////////////////////////////////////////
//:: Dragon Disciple Immunities
//:: prc_dradis.nss
//::///////////////////////////////////////////////
/*
    Applies a variety of immunities to the multiple dragon disciple types.
*/
//:://////////////////////////////////////////////
//:: Created By: Silver
//:: Created On: Apr 27, 2005
//:://////////////////////////////////////////////

#include "prc_inc_natweap"
#include "prc_ip_srcost"
#include "pnp_shft_poly"
#include "prc_compan_inc"

//Adds total elemental immunity for the majority of dragon types.
void ElImmune(object oPC ,object oSkin ,int bResisEle ,int iType)
{
    DelayCommand(0.1, AddItemProperty(DURATION_TYPE_PERMANENT,ItemPropertyDamageImmunity(iType,bResisEle),oSkin));
}

//Adds poison immunity for certain dragon types.
//also adds immunity to level drain for shadow dragons.
void PoisImmu(object oPC ,object oSkin ,int bResisEle ,int pImmune)
{
    DelayCommand(0.1, AddItemProperty(DURATION_TYPE_PERMANENT,ItemPropertyImmunityMisc(pImmune),oSkin));
}

//Adds disease immunity for certain dragon types.
void DisImmu(object oPC ,object oSkin ,int bResisEle ,int dImmune)
{
    DelayCommand(0.1, AddItemProperty(DURATION_TYPE_PERMANENT,ItemPropertyImmunityMisc(dImmune),oSkin));
}

//Adds specific spell immunities for certain dragon types.
void SpellImmu(object oPC ,object oSkin ,int bResisEle ,int iSpell)
{
    DelayCommand(0.1, AddItemProperty(DURATION_TYPE_PERMANENT,ItemPropertySpellImmunitySpecific(iSpell),oSkin));
}

//Adds more spell immunities for certain dragon types.
void SpellImmu2(object oPC ,object oSkin ,int bResisEle ,int iSpel2)
{
    DelayCommand(0.1, AddItemProperty(DURATION_TYPE_PERMANENT,ItemPropertySpellImmunitySpecific(iSpel2),oSkin));
}

//Adds resistance 10 to cold and fire damage.
void SmallResist(object oPC ,object oSkin ,int bResisEle ,int sResis)
{
    DelayCommand(0.1, AddItemProperty(DURATION_TYPE_PERMANENT,ItemPropertyDamageResistance(IP_CONST_DAMAGETYPE_FIRE,sResis),oSkin));
    DelayCommand(0.1, AddItemProperty(DURATION_TYPE_PERMANENT,ItemPropertyDamageResistance(IP_CONST_DAMAGETYPE_COLD,sResis),oSkin));
}

//Adds immunity 50% to sonic and fire damage.
void LargeResist(object oPC ,object oSkin ,int bResisEle ,int lResis)
{
    DelayCommand(0.1, AddItemProperty(DURATION_TYPE_PERMANENT,ItemPropertyDamageImmunity(IP_CONST_DAMAGETYPE_FIRE,lResis),oSkin));
    DelayCommand(0.1, AddItemProperty(DURATION_TYPE_PERMANENT,ItemPropertyDamageImmunity(IP_CONST_DAMAGETYPE_SONIC,lResis),oSkin));
}

//Adds Spell Resistance of 20+Level to all Dragon Disciples at level 18.
void SpellResis(object oPC ,object oSkin ,int nLevel)
{
    int nSR = 20+nLevel;
    nSR = GetSRByValue(nSR);
    DelayCommand(0.1, AddItemProperty(DURATION_TYPE_PERMANENT,ItemPropertyBonusSpellResistance(nSR),oSkin));
}

//Adds True Seeing to all Dragon Disciples at level 20.
void SeeTrue(object oPC ,object oSkin ,int nLevel)
{
    if(GetPRCSwitch(PRC_PNP_TRUESEEING))
    {
        effect eSight = EffectSeeInvisible();
        int nSpot = GetPRCSwitch(PRC_PNP_TRUESEEING_SPOT_BONUS);
        if(nSpot == 0)
            nSpot = 15;
        effect eSpot = EffectSkillIncrease(SKILL_SPOT, nSpot);
        effect eUltra = EffectUltravision();
        eSight = EffectLinkEffects(eSight, eSpot);
        eSight = EffectLinkEffects(eSight, eUltra);
        eSight = SupernaturalEffect(eSight);
        ApplyEffectToObject(DURATION_TYPE_PERMANENT, eSight, oPC);
    }
    else
        DelayCommand(0.1, AddItemProperty(DURATION_TYPE_PERMANENT,ItemPropertyTrueSeeing(),oSkin));
}

void main()
{

    //Declare main variables.
    object oPC = OBJECT_SELF;
    object oSkin = GetPCSkin(oPC);

    //Elemental Immunities for various dragon types.
    int iType = GetHasFeat(FEAT_BLACK_DRAGON, oPC)     ? IP_CONST_DAMAGETYPE_ACID :
                GetHasFeat(FEAT_BROWN_DRAGON, oPC)     ? IP_CONST_DAMAGETYPE_ACID :
                GetHasFeat(FEAT_COPPER_DRAGON, oPC)    ? IP_CONST_DAMAGETYPE_ACID :
                GetHasFeat(FEAT_GREEN_DRAGON, oPC)     ? IP_CONST_DAMAGETYPE_ACID :
                GetHasFeat(FEAT_BRASS_DRAGON, oPC)     ? IP_CONST_DAMAGETYPE_FIRE :
                GetHasFeat(FEAT_GOLD_DRAGON, oPC)      ? IP_CONST_DAMAGETYPE_FIRE :
                GetHasFeat(FEAT_RED_DRAGON, oPC)       ? IP_CONST_DAMAGETYPE_FIRE :
                GetHasFeat(FEAT_LUNG_WANG_DRAGON, oPC) ? IP_CONST_DAMAGETYPE_FIRE :
                GetHasFeat(FEAT_BATTLE_DRAGON, oPC)    ? IP_CONST_DAMAGETYPE_SONIC :
                GetHasFeat(FEAT_EMERALD_DRAGON, oPC)   ? IP_CONST_DAMAGETYPE_SONIC :
                GetHasFeat(FEAT_HOWLING_DRAGON, oPC)   ? IP_CONST_DAMAGETYPE_SONIC :
                GetHasFeat(FEAT_BLUE_DRAGON, oPC)      ? IP_CONST_DAMAGETYPE_ELECTRICAL :
                GetHasFeat(FEAT_BRONZE_DRAGON, oPC)    ? IP_CONST_DAMAGETYPE_ELECTRICAL :
                GetHasFeat(FEAT_OCEANUS_DRAGON, oPC)   ? IP_CONST_DAMAGETYPE_ELECTRICAL :
                GetHasFeat(FEAT_SAPPHIRE_DRAGON, oPC)  ? IP_CONST_DAMAGETYPE_ELECTRICAL :
                GetHasFeat(FEAT_SONG_DRAGON, oPC)      ? IP_CONST_DAMAGETYPE_ELECTRICAL :
                GetHasFeat(FEAT_SHEN_LUNG_DRAGON, oPC) ? IP_CONST_DAMAGETYPE_ELECTRICAL :
                GetHasFeat(FEAT_CRYSTAL_DRAGON, oPC)   ? IP_CONST_DAMAGETYPE_COLD :
                GetHasFeat(FEAT_TOPAZ_DRAGON, oPC)     ? IP_CONST_DAMAGETYPE_COLD :
                GetHasFeat(FEAT_SILVER_DRAGON, oPC)    ? IP_CONST_DAMAGETYPE_COLD :
                GetHasFeat(FEAT_WHITE_DRAGON, oPC)     ? IP_CONST_DAMAGETYPE_COLD :
                -1; // If none match, make the itemproperty invalid

    int lResis = GetHasFeat(FEAT_PYROCLASTIC_DRAGON, oPC) ? IP_CONST_DAMAGEIMMUNITY_50_PERCENT :
                -1; // If none match, make the itemproperty invalid

    //Random Immunities for various Dragon types.
    int pImmune = GetHasFeat(FEAT_AMETHYST_DRAGON, oPC)   ? IP_CONST_IMMUNITYMISC_POISON :
                  GetHasFeat(FEAT_SONG_DRAGON, oPC)       ? IP_CONST_IMMUNITYMISC_POISON :
                  GetHasFeat(FEAT_STYX_DRAGON, oPC)       ? IP_CONST_IMMUNITYMISC_POISON :
                  GetHasFeat(FEAT_SHEN_LUNG_DRAGON, oPC)  ? IP_CONST_IMMUNITYMISC_POISON :
                  GetHasFeat(FEAT_SHADOW_DRAGON, oPC)     ? IP_CONST_IMMUNITYMISC_LEVEL_ABIL_DRAIN :
                   -1; // If none match, make the itemproperty invalid

    int dImmune = GetHasFeat(FEAT_STYX_DRAGON, oPC)       ? IP_CONST_IMMUNITYMISC_DISEASE :
                   -1; // If none match, make the itemproperty invalid

    int iSpell = GetHasFeat(FEAT_DEEP_DRAGON, oPC)        ? IP_CONST_IMMUNITYSPELL_CHARM_PERSON_OR_ANIMAL :
                 GetHasFeat(FEAT_CHAOS_DRAGON, oPC)       ? IP_CONST_IMMUNITYSPELL_CONFUSION :
                 GetHasFeat(FEAT_TIEN_LUNG_DRAGON, oPC)   ? SPELL_DROWN :
                 GetHasFeat(FEAT_LUNG_WANG_DRAGON, oPC)   ? SPELL_DROWN :
                 GetHasFeat(FEAT_CHIANG_LUNG_DRAGON, oPC) ? SPELL_DROWN :
                 GetHasFeat(FEAT_PAN_LUNG_DRAGON, oPC)    ? SPELL_DROWN :
                 GetHasFeat(FEAT_SHEN_LUNG_DRAGON, oPC)   ? SPELL_DROWN :
                 GetHasFeat(FEAT_TUN_MI_LUNG_DRAGON, oPC) ? SPELL_DROWN :
                 GetHasFeat(FEAT_YU_LUNG_DRAGON, oPC)     ? SPELL_DROWN :
                  -1; // If none match, make the itemproperty invalid

    int iSpel2 = GetHasFeat(FEAT_TIEN_LUNG_DRAGON, oPC)   ? SPELL_MASS_DROWN :
                 GetHasFeat(FEAT_LUNG_WANG_DRAGON, oPC)   ? SPELL_MASS_DROWN :
                 GetHasFeat(FEAT_CHIANG_LUNG_DRAGON, oPC) ? SPELL_MASS_DROWN :
                 GetHasFeat(FEAT_PAN_LUNG_DRAGON, oPC)    ? SPELL_MASS_DROWN :
                 GetHasFeat(FEAT_SHEN_LUNG_DRAGON, oPC)   ? SPELL_MASS_DROWN :
                 GetHasFeat(FEAT_TUN_MI_LUNG_DRAGON, oPC) ? SPELL_MASS_DROWN :
                 GetHasFeat(FEAT_YU_LUNG_DRAGON, oPC)     ? SPELL_MASS_DROWN :
                  -1; // If none match, make the itemproperty invalid

    int sResis = GetHasFeat(FEAT_DEEP_DRAGON, oPC)        ? IP_CONST_DAMAGERESIST_10 :
                  -1; // If none match, make the itemproperty invalid

    int sCale1 = GetHasFeat(FAST_HEALING_1,oPC);
    int sCale2 = GetHasFeat(FAST_HEALING_2,oPC);
     
    int nWingType = CREATURE_WING_TYPE_DRAGON;
    int nTailType = CREATURE_TAIL_TYPE_LIZARD;
    if(GetPRCSwitch(MARKER_PRC_COMPANION))
    {
        nWingType = GetHasFeat(FEAT_BLACK_DRAGON, oPC)     ? PRC_COMP_WING_TYPE_DRAGON_BLACK :
                    GetHasFeat(FEAT_BLUE_DRAGON, oPC)      ? PRC_COMP_WING_TYPE_DRAGON_BLUE :
                    GetHasFeat(FEAT_BRASS_DRAGON, oPC)     ? PRC_COMP_WING_TYPE_DRAGON_BRASS :
                    GetHasFeat(FEAT_BRONZE_DRAGON, oPC)    ? PRC_COMP_WING_TYPE_DRAGON_BRONZE :
                    GetHasFeat(FEAT_COPPER_DRAGON, oPC)    ? PRC_COMP_WING_TYPE_DRAGON_COPPER :
                    GetHasFeat(FEAT_GOLD_DRAGON, oPC)      ? PRC_COMP_WING_TYPE_DRAGON_GOLD :
                    GetHasFeat(FEAT_GREEN_DRAGON, oPC)     ? PRC_COMP_WING_TYPE_DRAGON_GREEN :
                    GetHasFeat(FEAT_SILVER_DRAGON, oPC)    ? PRC_COMP_WING_TYPE_DRAGON_SILVER :
                    GetHasFeat(FEAT_WHITE_DRAGON, oPC)     ? PRC_COMP_WING_TYPE_DRAGON_WHITE :
                    GetHasFeat(FEAT_RED_DRAGON, oPC)       ? CREATURE_WING_TYPE_DRAGON :
                    GetHasFeat(FEAT_SHADOW_DRAGON, oPC)    ? PRC_COMP_WING_TYPE_DRAGON_SHADOW :
                    //GetHasFeat(FEAT_PRISMATIC_DRAGON, oPC) ? PRC_COMP_WING_TYPE_DRAGON_PRISMATIC :
                    CREATURE_WING_TYPE_NONE;
        //dragon disciple lichs get draco-lich wings at lich 4
        if(GetLevelByClass(CLASS_TYPE_LICH, oPC) >= 4) 
            nWingType = PRC_COMP_WING_TYPE_DRAGON_DRACOLICH;
            
                
        nTailType = GetHasFeat(FEAT_BLACK_DRAGON, oPC)     ? PRC_COMP_TAIL_TYPE_LIZARD_BLACK :
                    GetHasFeat(FEAT_BLUE_DRAGON, oPC)      ? PRC_COMP_TAIL_TYPE_LIZARD_BLUE :
                    GetHasFeat(FEAT_BRASS_DRAGON, oPC)     ? PRC_COMP_TAIL_TYPE_LIZARD_BRASS :
                    GetHasFeat(FEAT_BRONZE_DRAGON, oPC)    ? PRC_COMP_TAIL_TYPE_LIZARD_BRONZE :
                    GetHasFeat(FEAT_COPPER_DRAGON, oPC)    ? PRC_COMP_TAIL_TYPE_LIZARD_COPPER :
                    GetHasFeat(FEAT_GOLD_DRAGON, oPC)      ? PRC_COMP_TAIL_TYPE_LIZARD_GOLD :
                    GetHasFeat(FEAT_GREEN_DRAGON, oPC)     ? CREATURE_TAIL_TYPE_LIZARD :
                    GetHasFeat(FEAT_SILVER_DRAGON, oPC)    ? PRC_COMP_TAIL_TYPE_LIZARD_SILVER :
                    GetHasFeat(FEAT_WHITE_DRAGON, oPC)     ? PRC_COMP_TAIL_TYPE_LIZARD_WHITE :
                    GetHasFeat(FEAT_RED_DRAGON, oPC)       ? PRC_COMP_TAIL_TYPE_LIZARD_RED :
                    GetHasFeat(FEAT_SHADOW_DRAGON, oPC)    ? PRC_COMP_TAIL_TYPE_LIZARD_SHADOW : 
                    //GetHasFeat(FEAT_PRISMATIC_DRAGON, oPC) ? PRC_COMP_TAIL_TYPE_LIZARD_PRISMATIC :
                    CREATURE_TAIL_TYPE_NONE;
        //dragon disciple lichs get bony tail at lich 4
        if(GetLevelByClass(CLASS_TYPE_LICH, oPC) >= 4) 
            nTailType = CREATURE_TAIL_TYPE_BONE;
    }                
    
    int nLevel = GetLevelByClass(CLASS_TYPE_DRAGON_DISCIPLE,oPC);
    
    //natural weapons
    //bite at level 2
    //2 claws at level 2
    //2 wing slam at level 12
    //tail slam at level 17
    if(nLevel >= 2)
    {
        int nSize = PRCGetCreatureSize(oPC);
        if(GetHasFeat(DRACONIC_BITE, oPC))
        {
            string sResRef = "prc_rdd_bite_";
            sResRef += GetAffixForSize(nSize);
            AddNaturalSecondaryWeapon(oPC, sResRef); 
            //claw here
            sResRef = "prc_claw_1d6l_";
            sResRef += GetAffixForSize(nSize);
            AddNaturalPrimaryWeapon(oPC, sResRef, 2);
        }
        if(GetHasFeat(DRACONIC_WINGSLAMS, oPC))
        {
            string sResRef = "prc_rdd_wing_";
            sResRef += GetAffixForSize(nSize);
            if(nSize >= CREATURE_SIZE_MEDIUM)
                AddNaturalSecondaryWeapon(oPC, sResRef, 2);             
        }
        if(GetHasFeat(DRACONIC_TAILSLAP, oPC))
        {
            string sResRef = "prc_rdd_tail_";
            sResRef += GetAffixForSize(nSize);
            if(nSize >= CREATURE_SIZE_LARGE)
                AddNaturalSecondaryWeapon(oPC, sResRef);             
        }
    }
    

    int thickScale = -1;
    if(GetHasFeat(DRACONIC_ARMOR_AUG_2,oPC))
        thickScale = 2;
    else if(GetHasFeat(DRACONIC_ARMOR_AUG_1,oPC))
        thickScale = 1;

    SetCompositeBonus(oSkin, "ScaleThicken", thickScale, ITEM_PROPERTY_AC_BONUS);

    int bResisEle = GetHasFeat(FEAT_DRACONIC_IMMUNITY, oPC) ? IP_CONST_DAMAGEIMMUNITY_100_PERCENT : 0;

    if (bResisEle>0) ElImmune(oPC,oSkin,bResisEle,iType);
    if (bResisEle>0) PoisImmu(oPC,oSkin,bResisEle,pImmune);
    if (bResisEle>0) DisImmu(oPC,oSkin,bResisEle,dImmune);
    if (bResisEle>0) SpellImmu(oPC,oSkin,bResisEle,iSpell);
    if (bResisEle>0) SpellImmu2(oPC,oSkin,bResisEle,iSpel2);
    if (bResisEle>0) SmallResist(oPC,oSkin,bResisEle,sResis);
    if (bResisEle>0) LargeResist(oPC,oSkin,bResisEle,lResis);
    if (nLevel>17) SpellResis(oPC,oSkin,nLevel);
    if (nLevel>17 && GetPersistantLocalInt(oPC, "DragonDiscipleTailApplied"))
    {
        SetPersistantLocalInt(oPC, "DragonDiscipleTailApplied", TRUE);
        DoTail(oPC, nTailType);
    }
    if (nLevel>9 && GetPersistantLocalInt(oPC, "DragonDiscipleWingsApplied"))
    {
        SetPersistantLocalInt(oPC, "DragonDiscipleWingsApplied", TRUE);
        DoWings(oPC, nWingType);
    }
    if (nLevel>19) SeeTrue(oPC,oSkin,nLevel);
}