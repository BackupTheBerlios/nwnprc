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

#include "prc_alterations"
#include "prc_class_const"
#include "prc_feat_const"
#include "prc_spell_const"
#include "prc_ip_srcost"

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

void DoWing(object oPC, int nWingType)
{
    //wing invalid, use current
    if(nWingType == -1) return;
    //no CEP2, no extra wing models
    if(!GetPRCSwitch(CEP_IN_USE)) return;
    SetCreatureTailType(nWingType, oPC);
    //override any stored default appearance
    SetPersistantLocalInt(oPC,    "AppearanceStoredWing", nWingType);    
}

void DoTail(object oPC, int nTailType)
{
    //tail invalid, use current
    if(nTailType == -1) return;
    //no CEP2, no extra tail models
    if(!GetPRCSwitch(CEP_IN_USE)) return;
    SetCreatureTailType(nTailType, oPC);
    //override any stored default appearance
    SetPersistantLocalInt(oPC,    "AppearanceStoredTail", nTailType);
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
    
    int nWingType = GetHasFeat(FEAT_BLACK_DRAGON, oPC)     ? 34 :
                    GetHasFeat(FEAT_BLUE_DRAGON, oPC)      ? 35 :
                    GetHasFeat(FEAT_BRASS_DRAGON, oPC)     ? 36 :
                    GetHasFeat(FEAT_BRONZE_DRAGON, oPC)    ? 37 :
                    GetHasFeat(FEAT_COPPER_DRAGON, oPC)    ? 38 :
                    GetHasFeat(FEAT_GOLD_DRAGON, oPC)      ? 39 :
                    GetHasFeat(FEAT_GREEN_DRAGON, oPC)     ? 40 :
                    GetHasFeat(FEAT_SILVER_DRAGON, oPC)    ? 41 :
                    GetHasFeat(FEAT_WHITE_DRAGON, oPC)     ? 42 :
                    GetHasFeat(FEAT_RED_DRAGON, oPC)       ? 4 :
                    GetHasFeat(FEAT_SHADOW_DRAGON, oPC)    ? 50 :
                    //GetHasFeat(FEAT_PRISMATIC_DRAGON, oPC) ? 52 :
                    -1;
    //dragon disciple lichs get draco-lich wings at lich 4
    if(GetLevelByClass(CLASS_TYPE_LICH, oPC) >= 4) nWingType = 51;
    
    int nTailType = GetHasFeat(FEAT_BLACK_DRAGON, oPC)     ? 47 :
                    GetHasFeat(FEAT_BLUE_DRAGON, oPC)      ? 48 :
                    GetHasFeat(FEAT_BRASS_DRAGON, oPC)     ? 52 :
                    GetHasFeat(FEAT_BRONZE_DRAGON, oPC)    ? 53 :
                    GetHasFeat(FEAT_COPPER_DRAGON, oPC)    ? 54 :
                    GetHasFeat(FEAT_GOLD_DRAGON, oPC)      ? 55 :
                    GetHasFeat(FEAT_GREEN_DRAGON, oPC)     ? 1 :
                    GetHasFeat(FEAT_SILVER_DRAGON, oPC)    ? 56 :
                    GetHasFeat(FEAT_WHITE_DRAGON, oPC)     ? 49 :
                    GetHasFeat(FEAT_RED_DRAGON, oPC)       ? 4 :
                    GetHasFeat(FEAT_SHADOW_DRAGON, oPC)    ? 47 : //re-use black cos no shadow
                    //GetHasFeat(FEAT_PRISMATIC_DRAGON, oPC) ? 50 :
                    -1;
    //dragon disciple lichs get bony tail at lich 4
    if(GetLevelByClass(CLASS_TYPE_LICH, oPC) >= 4) nTailType = 51;
    
    int nLevel = GetLevelByClass(CLASS_TYPE_DRAGON_DISCIPLE,oPC);
    
    //natural weapons
    //bite at level 2
    //2 claws at level 2
    //2 wing slam at level 12
    //tail slam at level 17
    if(nLevel >= 2)
    {
        
        string sSizeRef;
        int nSize = PRCGetCreatureSize(oPC);
        switch(nSize)
        {
            case CREATURE_SIZE_FINE:        sSizeRef += "f"; break;
            case CREATURE_SIZE_DIMINUTIVE:  sSizeRef += "d"; break;
            case CREATURE_SIZE_SMALL:       sSizeRef += "s"; break;
            case CREATURE_SIZE_MEDIUM:      sSizeRef += "m"; break;
            case CREATURE_SIZE_LARGE:       sSizeRef += "l"; break;
            case CREATURE_SIZE_HUGE:        sSizeRef += "h"; break;
            case CREATURE_SIZE_GARGANTUAN:  sSizeRef += "g"; break;
            case CREATURE_SIZE_COLOSSAL:    sSizeRef += "c"; break;
            default:                        sSizeRef += "m"; break;
        }
        if(nLevel >=2)
        {
            string sResRef = "prc_rdd_bite_"+sSizeRef;
            AddNaturalSecondaryWeapon(oPC, sResRef); 
            //claw here
        }
        if(nLevel >=12)
        {
            string sResRef = "prc_rdd_wing_"+sSizeRef;
            if(nSize >= CREATURE_SIZE_MEDIUM)
                AddNaturalSecondaryWeapon(oPC, sResRef, 2);             
        }
        if(nLevel >=17)
        {
            string sResRef = "prc_rdd_tail_"+sSizeRef;
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
    if (nLevel>17) DoTail(oPC, nTailType);
    if (nLevel>9)  DoWing(oPC, nWingType);
    if (nLevel>19) SeeTrue(oPC,oSkin,nLevel);
}