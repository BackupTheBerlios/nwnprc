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

#include "inc_item_props" 
#include "prc_class_const" 
#include "prc_feat_const" 
#include "prc_spell_const"
#include "x2_inc_itemprop"
#include "prc_ip_srcost"

//Adds total elemental immunity for the majority of dragon types.
void ElImmune(object oPC ,object oSkin ,int bResisEle ,int iType) 
{ 
    DelayCommand(0.1, AddItemProperty(DURATION_TYPE_PERMANENT,ItemPropertyDamageImmunity(iType,bResisEle),oSkin)); 
} 

//Adds poison immunity for certain dragon types.
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
                GetHasFeat(FEAT_SHADOW_DRAGON, oPC)    ? IP_CONST_DAMAGETYPE_ELECTRICAL : 
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
    
    int nLevel = GetLevelByClass(CLASS_TYPE_DRAGON_DISCIPLE,oPC);
    
    int thickScale = GetHasFeat(DRACONIC_ARMOR_AUG_2,oPC) ? 2 :
                     GetHasFeat(DRACONIC_ARMOR_AUG_1,oPC) ? 1 :
                     -1;
 
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
    if (nLevel>19) SeeTrue(oPC,oSkin,nLevel);
}