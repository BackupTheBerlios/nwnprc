#include "prc_alterations"
#include "prc_feat_const"
#include "prc_ipfeat_const"
#include "x2_inc_itemprop"

const int PHENOTYPE_KENSAI      = 5;
const int PHENOTYPE_ASSASSIN    = 6;
const int PHENOTYPE_BARBARIAN   = 7;
const int PHENOTYPE_FENCING     = 8;

void main()
{
    object oPC = OBJECT_SELF;
    object oSkin = GetPCSkin(oPC);
    if(!GetHasFeat(FEAT_ACP_FEAT, oPC)
        && GetPRCSwitch(PRC_ACP_MANUAL))
    {    
        IPSafeAddItemProperty(oSkin, ItemPropertyBonusFeat(IP_CONST_ACP_FEAT),
            0.0);    
        return;
    }    
    else if((GetPRCSwitch(PRC_ACP_AUTOMATIC) && GetIsPC(oPC))
        ||(GetPRCSwitch(PRC_ACP_NPC_AUTOMATIC) && !GetIsPC(oPC)))
    {
        
    }
}