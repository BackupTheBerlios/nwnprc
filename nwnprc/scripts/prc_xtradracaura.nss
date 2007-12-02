
#include "prc_alterations"

void main()
{
	
     object oPC = OBJECT_SELF;
     object oSkin = GetPCSkin(oPC);
     int bDragonblooded = FALSE;
     
     if(GetRacialType(oPC) == RACIAL_TYPE_KOBOLD)  bDragonblooded = TRUE;
     if(GetHasFeat(FEAT_DRAGONTOUCHED, oPC))  bDragonblooded = TRUE;
     if(GetHasFeat(FEAT_DRACONIC_DEVOTEE, oPC))  bDragonblooded = TRUE;
     if(GetLevelByClass(CLASS_TYPE_DRAGON_DISCIPLE, oPC) > 9)  bDragonblooded = TRUE;

     //Draconic Heritage qualifies for dragonblood
     if((GetHasFeat(FEAT_DRACONIC_HERITAGE_BK, oPC))
          || (GetHasFeat(FEAT_DRACONIC_HERITAGE_BL, oPC))
          || (GetHasFeat(FEAT_DRACONIC_HERITAGE_GR, oPC))
          || (GetHasFeat(FEAT_DRACONIC_HERITAGE_RD, oPC))
          || (GetHasFeat(FEAT_DRACONIC_HERITAGE_WH, oPC))
          || (GetHasFeat(FEAT_DRACONIC_HERITAGE_AM, oPC))
          || (GetHasFeat(FEAT_DRACONIC_HERITAGE_CR, oPC))
          || (GetHasFeat(FEAT_DRACONIC_HERITAGE_EM, oPC))
          || (GetHasFeat(FEAT_DRACONIC_HERITAGE_SA, oPC))
          || (GetHasFeat(FEAT_DRACONIC_HERITAGE_TP, oPC))
          || (GetHasFeat(FEAT_DRACONIC_HERITAGE_BS, oPC))
          || (GetHasFeat(FEAT_DRACONIC_HERITAGE_BZ, oPC))
          || (GetHasFeat(FEAT_DRACONIC_HERITAGE_CP, oPC))
          || (GetHasFeat(FEAT_DRACONIC_HERITAGE_GD, oPC))
          || (GetHasFeat(FEAT_DRACONIC_HERITAGE_SR, oPC))
         ) 
        {
            bDragonblooded = TRUE;
        }
        
        
     if(!bDragonblooded)
     {
          IPSafeAddItemProperty(oSkin, ItemPropertyBonusFeat(IP_CONST_FEAT_BONUS_AURA_1), 0.0f, X2_IP_ADDPROP_POLICY_KEEP_EXISTING, FALSE, FALSE);
     }
     else
     {
     	if(GetHitDice(oPC) > 19)
     	    IPSafeAddItemProperty(oSkin, ItemPropertyBonusFeat(IP_CONST_FEAT_BONUS_AURA_4), 0.0f, X2_IP_ADDPROP_POLICY_KEEP_EXISTING, FALSE, FALSE);
     	else if(GetHitDice(oPC) > 13)
     	    IPSafeAddItemProperty(oSkin, ItemPropertyBonusFeat(IP_CONST_FEAT_BONUS_AURA_3), 0.0f, X2_IP_ADDPROP_POLICY_KEEP_EXISTING, FALSE, FALSE);
     	else if(GetHitDice(oPC) > 6)
     	    IPSafeAddItemProperty(oSkin, ItemPropertyBonusFeat(IP_CONST_FEAT_BONUS_AURA_2), 0.0f, X2_IP_ADDPROP_POLICY_KEEP_EXISTING, FALSE, FALSE);
     	else
     	    IPSafeAddItemProperty(oSkin, ItemPropertyBonusFeat(IP_CONST_FEAT_BONUS_AURA_1), 0.0f, X2_IP_ADDPROP_POLICY_KEEP_EXISTING, FALSE, FALSE);
     	
     	
     }

}