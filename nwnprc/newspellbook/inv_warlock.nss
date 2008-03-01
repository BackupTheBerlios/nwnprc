//::///////////////////////////////////////////////
//:: Warlock
//:: inv_warlock.nss
//::///////////////////////////////////////////////
/*
    Handles the passive bonuses for Warlocks
*/
//:://////////////////////////////////////////////
//:: Created By: Fox
//:: Created On: Feb 29, 2008
//:://////////////////////////////////////////////


#include "prc_alterations"

void main()
{
	object oPC = OBJECT_SELF;
	object oSkin = GetPCSkin(oPC);
	
	int nClass = GetLevelByClass(CLASS_TYPE_WARLOCK, oPC);
		
	//Reduction
	int nRedAmt = (nClass + 1) / 4;
	effect eReduction = EffectDamageReduction(nRedAmt, DAMAGE_POWER_PLUS_THREE);
	    
	if(nClass > 2)
	   ApplyEffectToObject(DURATION_TYPE_PERMANENT, ExtraordinaryEffect(eReduction), oPC);
	   
	//Energy Ressitance
	int nResistAmt = nClass / 10 * IP_CONST_DAMAGERESIST_5;
	
	if(GetHasFeat(FEAT_WARLOCK_RESIST_ACID))
	{
    	itemproperty ipIP =ItemPropertyDamageResistance(IP_CONST_DAMAGETYPE_ACID, nResistAmt);
        IPSafeAddItemProperty(oSkin, ipIP, 0.0, X2_IP_ADDPROP_POLICY_REPLACE_EXISTING, FALSE, FALSE);
	}
	if(GetHasFeat(FEAT_WARLOCK_RESIST_COLD))
	{
    	itemproperty ipIP =ItemPropertyDamageResistance(IP_CONST_DAMAGETYPE_COLD, nResistAmt);
        IPSafeAddItemProperty(oSkin, ipIP, 0.0, X2_IP_ADDPROP_POLICY_REPLACE_EXISTING, FALSE, FALSE);
	}
	if(GetHasFeat(FEAT_WARLOCK_RESIST_ELEC))
	{
    	itemproperty ipIP =ItemPropertyDamageResistance(IP_CONST_DAMAGETYPE_ELECTRICAL, nResistAmt);
        IPSafeAddItemProperty(oSkin, ipIP, 0.0, X2_IP_ADDPROP_POLICY_REPLACE_EXISTING, FALSE, FALSE);
	}
	if(GetHasFeat(FEAT_WARLOCK_RESIST_FIRE))
	{
    	itemproperty ipIP =ItemPropertyDamageResistance(IP_CONST_DAMAGETYPE_FIRE, nResistAmt);
        IPSafeAddItemProperty(oSkin, ipIP, 0.0, X2_IP_ADDPROP_POLICY_REPLACE_EXISTING, FALSE, FALSE);
	}
	if(GetHasFeat(FEAT_WARLOCK_RESIST_SONIC))
	{
    	itemproperty ipIP =ItemPropertyDamageResistance(IP_CONST_DAMAGETYPE_SONIC, nResistAmt);
        IPSafeAddItemProperty(oSkin, ipIP, 0.0, X2_IP_ADDPROP_POLICY_REPLACE_EXISTING, FALSE, FALSE);
	}
}