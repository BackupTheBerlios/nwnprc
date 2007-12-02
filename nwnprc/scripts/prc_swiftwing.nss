//::///////////////////////////////////////////////
//:: Swift Wing
//:: prc_swiftwing.nss
//::///////////////////////////////////////////////
/*
    Handles the passive bonuses for Swift Wings
*/
//:://////////////////////////////////////////////
//:: Created By: Fox
//:: Created On: Nov 21, 2007
//:://////////////////////////////////////////////


#include "prc_alterations"

void main()
{
	object oPC = OBJECT_SELF;
	object oSkin = GetPCSkin(oPC);
	
	//Energy Resistance/Immunity
	//Acid
        if(GetHasFeat(FEAT_DRAGON_AFFINITY_BK, oPC)
           || GetHasFeat(FEAT_DRAGON_AFFINITY_CP, oPC)
           || GetHasFeat(FEAT_DRAGON_AFFINITY_GR, oPC))
        {
            if(GetLevelByClass(CLASS_TYPE_SWIFT_WING, oPC) > 3)
                IPSafeAddItemProperty(oSkin, 
	          ItemPropertyDamageResistance(IP_CONST_DAMAGETYPE_ACID, IP_CONST_DAMAGERESIST_20), 
	          0.0f, X2_IP_ADDPROP_POLICY_KEEP_EXISTING);
            if(GetLevelByClass(CLASS_TYPE_SWIFT_WING, oPC) > 8)
                IPSafeAddItemProperty(oSkin, 
	          ItemPropertyDamageImmunity(IP_CONST_DAMAGETYPE_ACID, IP_CONST_DAMAGEIMMUNITY_100_PERCENT), 
	          0.0f, X2_IP_ADDPROP_POLICY_KEEP_EXISTING);
        }
             
        //Cold
        else if(GetHasFeat(FEAT_DRAGON_AFFINITY_CR, oPC)
           || GetHasFeat(FEAT_DRAGON_AFFINITY_SR, oPC)
           || GetHasFeat(FEAT_DRAGON_AFFINITY_TP, oPC)
           || GetHasFeat(FEAT_DRAGON_AFFINITY_WH, oPC))
        {
            if(GetLevelByClass(CLASS_TYPE_SWIFT_WING, oPC) > 3)
                IPSafeAddItemProperty(oSkin, 
	          ItemPropertyDamageResistance(IP_CONST_DAMAGETYPE_COLD, IP_CONST_DAMAGERESIST_20), 
	          0.0f, X2_IP_ADDPROP_POLICY_KEEP_EXISTING);
            if(GetLevelByClass(CLASS_TYPE_SWIFT_WING, oPC) > 8)
                IPSafeAddItemProperty(oSkin, 
	          ItemPropertyDamageImmunity(IP_CONST_DAMAGETYPE_COLD, IP_CONST_DAMAGEIMMUNITY_100_PERCENT), 
	          0.0f, X2_IP_ADDPROP_POLICY_KEEP_EXISTING);
        }
        //Electric
        else if(GetHasFeat(FEAT_DRAGON_AFFINITY_BL, oPC)
           || GetHasFeat(FEAT_DRAGON_AFFINITY_BZ, oPC)
           || GetHasFeat(FEAT_DRAGON_AFFINITY_SA, oPC))
        {
            if(GetLevelByClass(CLASS_TYPE_SWIFT_WING, oPC) > 3)
                IPSafeAddItemProperty(oSkin, 
	          ItemPropertyDamageResistance(IP_CONST_DAMAGETYPE_ELECTRICAL, IP_CONST_DAMAGERESIST_20), 
	          0.0f, X2_IP_ADDPROP_POLICY_KEEP_EXISTING);
            if(GetLevelByClass(CLASS_TYPE_SWIFT_WING, oPC) > 8)
                IPSafeAddItemProperty(oSkin, 
	          ItemPropertyDamageImmunity(IP_CONST_DAMAGETYPE_ELECTRICAL, IP_CONST_DAMAGEIMMUNITY_100_PERCENT), 
	          0.0f, X2_IP_ADDPROP_POLICY_KEEP_EXISTING);
        }
        //Fire
        else if(GetHasFeat(FEAT_DRAGON_AFFINITY_BS, oPC)
           || GetHasFeat(FEAT_DRAGON_AFFINITY_GD, oPC)
           || GetHasFeat(FEAT_DRAGON_AFFINITY_RD, oPC)
           || GetHasFeat(FEAT_DRAGON_AFFINITY_AM, oPC))
        {
            if(GetLevelByClass(CLASS_TYPE_SWIFT_WING, oPC) > 3)
                IPSafeAddItemProperty(oSkin, 
	          ItemPropertyDamageResistance(IP_CONST_DAMAGETYPE_FIRE, IP_CONST_DAMAGERESIST_20), 
	          0.0f, X2_IP_ADDPROP_POLICY_KEEP_EXISTING);
            if(GetLevelByClass(CLASS_TYPE_SWIFT_WING, oPC) > 8)
                IPSafeAddItemProperty(oSkin, 
	          ItemPropertyDamageImmunity(IP_CONST_DAMAGETYPE_FIRE, IP_CONST_DAMAGEIMMUNITY_100_PERCENT), 
	          0.0f, X2_IP_ADDPROP_POLICY_KEEP_EXISTING);
        }
        //Sonic
        else if(GetHasFeat(FEAT_DRAGON_AFFINITY_EM, oPC))
        {
            if(GetLevelByClass(CLASS_TYPE_SWIFT_WING, oPC) > 3)
                IPSafeAddItemProperty(oSkin, 
	          ItemPropertyDamageResistance(IP_CONST_DAMAGETYPE_SONIC, IP_CONST_DAMAGERESIST_20), 
	          0.0f, X2_IP_ADDPROP_POLICY_KEEP_EXISTING);
            if(GetLevelByClass(CLASS_TYPE_SWIFT_WING, oPC) > 8)
                IPSafeAddItemProperty(oSkin, 
	          ItemPropertyDamageImmunity(IP_CONST_DAMAGETYPE_SONIC, IP_CONST_DAMAGEIMMUNITY_100_PERCENT), 
	          0.0f, X2_IP_ADDPROP_POLICY_KEEP_EXISTING);
        }
	
	//Damage Reduction 5/+1 at level 7
	if(GetLevelByClass(CLASS_TYPE_SWIFT_WING, oPC) > 6)
	     IPSafeAddItemProperty(oSkin, 
	          ItemPropertyDamageReduction(IP_CONST_DAMAGEREDUCTION_1, IP_CONST_DAMAGESOAK_5_HP), 
	          0.0f, X2_IP_ADDPROP_POLICY_KEEP_EXISTING);
	
	//Draconic Surge bonuses
	if(GetHasFeat(FEAT_DRACONIC_SURGE_STR, oPC))
        {
             SetCompositeBonus(oSkin, "DrSge_STR", 1, ITEM_PROPERTY_ABILITY_BONUS, IP_CONST_ABILITY_STR);
        }
        if(GetHasFeat(FEAT_DRACONIC_SURGE_DEX, oPC))
        {
             SetCompositeBonus(oSkin, "DrSge_DEX", 1, ITEM_PROPERTY_ABILITY_BONUS, IP_CONST_ABILITY_DEX);
        }
        if(GetHasFeat(FEAT_DRACONIC_SURGE_CON, oPC))
        {
             SetCompositeBonus(oSkin, "DrSge_CON", 1, ITEM_PROPERTY_ABILITY_BONUS, IP_CONST_ABILITY_CON);
        }
        if(GetHasFeat(FEAT_DRACONIC_SURGE_INT, oPC))
        {
             SetCompositeBonus(oSkin, "DrSge_INT", 1, ITEM_PROPERTY_ABILITY_BONUS, IP_CONST_ABILITY_INT);
        }
        if(GetHasFeat(FEAT_DRACONIC_SURGE_WIS, oPC))
        {
             SetCompositeBonus(oSkin, "DrSge_WIS", 1, ITEM_PROPERTY_ABILITY_BONUS, IP_CONST_ABILITY_WIS);
        }
        if(GetHasFeat(FEAT_DRACONIC_SURGE_CHA, oPC))
        {
             SetCompositeBonus(oSkin, "DrSge_CHA", 1, ITEM_PROPERTY_ABILITY_BONUS, IP_CONST_ABILITY_CHA);
        }
        
}