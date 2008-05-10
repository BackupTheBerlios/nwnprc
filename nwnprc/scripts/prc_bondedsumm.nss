

#include "prc_feat_const"
#include "prc_class_const"
#include "prc_spell_const"
#include "prc_ipfeat_const"
#include "prc_alterations"

void main()
{

    //Declare main variables.
    object oPC = OBJECT_SELF;
    object oSkin = GetPCSkin(oPC);

    int iType = GetHasFeat(FEAT_BONDED_AIR, oPC)   ? IP_CONST_DAMAGETYPE_ELECTRICAL  : 0 ;
    iType = GetHasFeat(FEAT_BONDED_EARTH, oPC) ? IP_CONST_DAMAGETYPE_ACID  : iType ;
    iType = GetHasFeat(FEAT_BONDED_FIRE, oPC)  ? IP_CONST_DAMAGETYPE_FIRE  : iType ;
    iType = GetHasFeat(FEAT_BONDED_WATER, oPC) ? IP_CONST_DAMAGETYPE_COLD  : iType ;


    int bResisEle = GetHasFeat(FEAT_RESISTANCE_ELE5, oPC)  ? IP_CONST_DAMAGERESIST_5 : 0;
    bResisEle = GetHasFeat(FEAT_RESISTANCE_ELE10, oPC) ? IP_CONST_DAMAGERESIST_10 : bResisEle;
    bResisEle = GetHasFeat(FEAT_RESISTANCE_ELE15, oPC) ? IP_CONST_DAMAGERESIST_15 : bResisEle;
    bResisEle = GetHasFeat(FEAT_RESISTANCE_ELE20, oPC) ? IP_CONST_DAMAGERESIST_20 : bResisEle;
    bResisEle = GetHasFeat(FEAT_IMMUNITY_ELEMENT, oPC) ? IP_CONST_DAMAGERESIST_500 : bResisEle;

    int bType =  GetHasFeat(FEAT_TYPE_ELEMENTAL, oPC)     ? 1: 0;

    if (bResisEle>0) 
        IPSafeAddItemProperty(oSkin, ItemPropertyDamageResistance(iType,bResisEle));
    if(GetHasFeat(FEAT_IMMUNITY_SNEAKATK, oPC))
        IPSafeAddItemProperty(oSkin, ItemPropertyImmunityMisc(IP_CONST_IMMUNITYMISC_BACKSTAB));
    if(GetHasFeat(FEAT_IMMUNITY_CRITIK, oPC))
        IPSafeAddItemProperty(oSkin, ItemPropertyImmunityMisc(IP_CONST_IMMUNITYMISC_CRITICAL_HITS));

    if(GetHasFeat(FEAT_TYPE_ELEMENTAL, oPC))
    {
        if (iType==IP_CONST_DAMAGETYPE_ELECTRICAL)
        {
            ActionCastSpellOnSelf(SPELL_SACREDSPEED);
            return;
        }
        
        if (iType==IP_CONST_DAMAGETYPE_FIRE)
            IPSafeAddItemProperty(oSkin, ItemPropertyDamageVulnerability(IP_CONST_DAMAGETYPE_COLD,IP_CONST_DAMAGEVULNERABILITY_50_PERCENT));
        else if (iType==IP_CONST_DAMAGETYPE_COLD)
            IPSafeAddItemProperty(oSkin, ItemPropertyDamageVulnerability(IP_CONST_DAMAGETYPE_FIRE,IP_CONST_DAMAGEVULNERABILITY_50_PERCENT));
    }
}
