
#include "prc_alterations"

void main()
{
	
     object oPC = OBJECT_SELF;
     object oSkin = GetPCSkin(oPC);
     
     if(GetHasFeat(FEAT_DRAGONSHAMAN_AURA_POWER, oPC))
     {
          IPSafeAddItemProperty(oSkin, ItemPropertyBonusFeat(IP_CONST_FEAT_2ND_AURA_POWER), 0.0f, X2_IP_ADDPROP_POLICY_KEEP_EXISTING, FALSE, FALSE);
     }
     
     if(GetHasFeat(FEAT_DRAGONSHAMAN_AURA_SENSES, oPC) 
        || GetHasFeat(FEAT_MARSHAL_AURA_SENSES, oPC) 
        || GetHasFeat(FEAT_BONUS_AURA_SENSES, oPC))
     {
          IPSafeAddItemProperty(oSkin, ItemPropertyBonusFeat(IP_CONST_FEAT_2ND_AURA_SENSES), 0.0f, X2_IP_ADDPROP_POLICY_KEEP_EXISTING, FALSE, FALSE);
     }
     
     if(GetHasFeat(FEAT_DRAGONSHAMAN_AURA_PRESENCE, oPC) 
        || GetHasFeat(FEAT_MARSHAL_AURA_PRESENCE, oPC) 
        || GetHasFeat(FEAT_BONUS_AURA_PRESENCE, oPC))
     {
          IPSafeAddItemProperty(oSkin, ItemPropertyBonusFeat(IP_CONST_FEAT_2ND_AURA_PRESENCE), 0.0f, X2_IP_ADDPROP_POLICY_KEEP_EXISTING, FALSE, FALSE);
     }
     
     if(GetHasFeat(FEAT_DRAGONSHAMAN_AURA_RESISTANCE, oPC))
     {
          IPSafeAddItemProperty(oSkin, ItemPropertyBonusFeat(IP_CONST_FEAT_2ND_AURA_RESISTANCE), 0.0f, X2_IP_ADDPROP_POLICY_KEEP_EXISTING, FALSE, FALSE);
     }
     
     if(GetHasFeat(FEAT_DRAGONSHAMAN_AURA_ENERGYSHLD, oPC))
     {
          IPSafeAddItemProperty(oSkin, ItemPropertyBonusFeat(IP_CONST_FEAT_2ND_AURA_ENERGYSHLD), 0.0f, X2_IP_ADDPROP_POLICY_KEEP_EXISTING, FALSE, FALSE);
     }
     
     if(GetHasFeat(FEAT_DRAGONSHAMAN_AURA_VIGOR, oPC))
     {
          IPSafeAddItemProperty(oSkin, ItemPropertyBonusFeat(IP_CONST_FEAT_2ND_AURA_VIGOR), 0.0f, X2_IP_ADDPROP_POLICY_KEEP_EXISTING, FALSE, FALSE);
     }
     
     if(GetHasFeat(FEAT_DRAGONSHAMAN_AURA_TOUGHNESS, oPC) 
        || GetHasFeat(FEAT_MARSHAL_AURA_TOUGHNESS, oPC) 
        || GetHasFeat(FEAT_BONUS_AURA_TOUGHNESS, oPC))
     {
          IPSafeAddItemProperty(oSkin, ItemPropertyBonusFeat(IP_CONST_FEAT_2ND_AURA_TOUGHNESS), 0.0f, X2_IP_ADDPROP_POLICY_KEEP_EXISTING, FALSE, FALSE);
     }
     
     if(GetHasFeat(FEAT_DRAGONSHAMAN_AURA_INSIGHT, oPC) 
        || GetHasFeat(FEAT_MARSHAL_AURA_INSIGHT, oPC) 
        || GetHasFeat(FEAT_BONUS_AURA_INSIGHT, oPC))
     {
          IPSafeAddItemProperty(oSkin, ItemPropertyBonusFeat(IP_CONST_FEAT_2ND_AURA_INSIGHT), 0.0f, X2_IP_ADDPROP_POLICY_KEEP_EXISTING, FALSE, FALSE);
     }
     
     if(GetHasFeat(FEAT_DRAGONSHAMAN_AURA_RESOLVE, oPC) 
        || GetHasFeat(FEAT_MARSHAL_AURA_RESOLVE, oPC)
        || GetHasFeat(FEAT_BONUS_AURA_RESOLVE, oPC))
     {
          IPSafeAddItemProperty(oSkin, ItemPropertyBonusFeat(IP_CONST_FEAT_2ND_AURA_RESOLVE), 0.0f, X2_IP_ADDPROP_POLICY_KEEP_EXISTING, FALSE, FALSE);
     }
     
     if(GetHasFeat(FEAT_DRAGONSHAMAN_AURA_STAMINA, oPC) 
        || GetHasFeat(FEAT_MARSHAL_AURA_STAMINA, oPC) 
        || GetHasFeat(FEAT_BONUS_AURA_STAMINA, oPC))
     {
          IPSafeAddItemProperty(oSkin, ItemPropertyBonusFeat(IP_CONST_FEAT_2ND_AURA_STAMINA), 0.0f, X2_IP_ADDPROP_POLICY_KEEP_EXISTING, FALSE, FALSE);
     }
     
     if(GetHasFeat(FEAT_DRAGONSHAMAN_AURA_SWIFTNESS, oPC) 
        || GetHasFeat(FEAT_MARSHAL_AURA_SWIFTNESS, oPC)
        || GetHasFeat(FEAT_BONUS_AURA_SWIFTNESS, oPC))
     {
          IPSafeAddItemProperty(oSkin, ItemPropertyBonusFeat(IP_CONST_FEAT_2ND_AURA_SWIFTNESS), 0.0f, X2_IP_ADDPROP_POLICY_KEEP_EXISTING, FALSE, FALSE);
     }
     
     if(GetHasFeat(FEAT_MARSHAL_AURA_RESISTACID, oPC)
        || GetHasFeat(FEAT_BONUS_AURA_RESISTACID, oPC))
     {
          IPSafeAddItemProperty(oSkin, ItemPropertyBonusFeat(IP_CONST_FEAT_2ND_AURA_RESISTACID), 0.0f, X2_IP_ADDPROP_POLICY_KEEP_EXISTING, FALSE, FALSE);
     }
     if(GetHasFeat(FEAT_MARSHAL_AURA_RESISTCOLD, oPC)
        || GetHasFeat(FEAT_BONUS_AURA_RESISTCOLD, oPC))
     {
          IPSafeAddItemProperty(oSkin, ItemPropertyBonusFeat(IP_CONST_FEAT_2ND_AURA_RESISTCOLD), 0.0f, X2_IP_ADDPROP_POLICY_KEEP_EXISTING, FALSE, FALSE);
     }
     if(GetHasFeat(FEAT_MARSHAL_AURA_RESISTELEC, oPC)
        || GetHasFeat(FEAT_BONUS_AURA_RESISTELEC, oPC))
     {
          IPSafeAddItemProperty(oSkin, ItemPropertyBonusFeat(IP_CONST_FEAT_2ND_AURA_RESISTELEC), 0.0f, X2_IP_ADDPROP_POLICY_KEEP_EXISTING, FALSE, FALSE);
     }
     if(GetHasFeat(FEAT_MARSHAL_AURA_RESISTFIRE, oPC)
        || GetHasFeat(FEAT_BONUS_AURA_RESISTFIRE, oPC))
     {
          IPSafeAddItemProperty(oSkin, ItemPropertyBonusFeat(IP_CONST_FEAT_2ND_AURA_RESISTFIRE), 0.0f, X2_IP_ADDPROP_POLICY_KEEP_EXISTING, FALSE, FALSE);
     }

     if(GetHasFeat(FEAT_DRAGONSHAMAN_AURA_MAGICPOWER, oPC) 
        || GetHasFeat(FEAT_MARSHAL_AURA_MAGICPOWER, oPC) 
        || GetHasFeat(FEAT_BONUS_AURA_MAGICPOWER, oPC))
     {
          IPSafeAddItemProperty(oSkin, ItemPropertyBonusFeat(IP_CONST_FEAT_2ND_AURA_MAGICPOWER), 0.0f, X2_IP_ADDPROP_POLICY_KEEP_EXISTING, FALSE, FALSE);
     }
     
     if(GetHasFeat(FEAT_MARSHAL_AURA_ENERGYACID, oPC)
        || GetHasFeat(FEAT_BONUS_AURA_ENERGYACID, oPC))
     {
          IPSafeAddItemProperty(oSkin, ItemPropertyBonusFeat(IP_CONST_FEAT_2ND_AURA_ENERGYACID), 0.0f, X2_IP_ADDPROP_POLICY_KEEP_EXISTING, FALSE, FALSE);
     }
     if(GetHasFeat(FEAT_MARSHAL_AURA_ENERGYCOLD, oPC)
        || GetHasFeat(FEAT_BONUS_AURA_ENERGYCOLD, oPC))
     {
          IPSafeAddItemProperty(oSkin, ItemPropertyBonusFeat(IP_CONST_FEAT_2ND_AURA_ENERGYCOLD), 0.0f, X2_IP_ADDPROP_POLICY_KEEP_EXISTING, FALSE, FALSE);
     }
     if(GetHasFeat(FEAT_MARSHAL_AURA_ENERGYELEC, oPC)
        || GetHasFeat(FEAT_BONUS_AURA_ENERGYELEC, oPC))
     {
          IPSafeAddItemProperty(oSkin, ItemPropertyBonusFeat(IP_CONST_FEAT_2ND_AURA_ENERGYELEC), 0.0f, X2_IP_ADDPROP_POLICY_KEEP_EXISTING, FALSE, FALSE);
     }
     if(GetHasFeat(FEAT_MARSHAL_AURA_ENERGYFIRE, oPC)
        || GetHasFeat(FEAT_BONUS_AURA_ENERGYFIRE, oPC))
     {
          IPSafeAddItemProperty(oSkin, ItemPropertyBonusFeat(IP_CONST_FEAT_2ND_AURA_ENERGYFIRE), 0.0f, X2_IP_ADDPROP_POLICY_KEEP_EXISTING, FALSE, FALSE);
     }
     
     if(GetHasFeat(FEAT_DRAGONSHAMAN_AURA_ENERGY, oPC))
     {
          IPSafeAddItemProperty(oSkin, ItemPropertyBonusFeat(IP_CONST_FEAT_2ND_AURA_ENERGY), 0.0f, X2_IP_ADDPROP_POLICY_KEEP_EXISTING, FALSE, FALSE);
     }
}