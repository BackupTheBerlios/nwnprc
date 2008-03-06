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

// Armour and Shield combined, up to Medium/Large shield.
void ReducedASF(object oCreature)
{
	object oArmor = GetItemInSlot(INVENTORY_SLOT_CHEST, oCreature);
	object oShield = GetItemInSlot(INVENTORY_SLOT_LEFTHAND, oCreature);
	object oSkin = GetPCSkin(oCreature);
	int nAC = GetBaseAC(oArmor);
	int nClass = GetLevelByClass(CLASS_TYPE_WARLOCK, oCreature);
	int iBonus = GetLocalInt(oSkin, "WarlockArmourCasting");
	int nASF = -1;
	itemproperty ip;
	
	// First thing is to remove old ASF (in case armor is changed.)
	if (iBonus != -1)
		RemoveSpecificProperty(oSkin, ITEM_PROPERTY_ARCANE_SPELL_FAILURE, -1, iBonus, 1, "WarlockArmourCasting");
	
	// As long as they meet the requirements, just give em max ASF reduction
	// I know it could cause problems if they have increased ASF, but thats unlikely
	if (3 >= nAC && GetBaseItemType(oShield) != BASE_ITEM_TOWERSHIELD && GetBaseItemType(oShield) != BASE_ITEM_LARGESHIELD && nClass >= 1)
		nASF = IP_CONST_ARCANE_SPELL_FAILURE_MINUS_25_PERCENT;			

	// Apply the ASF to the skin.
	ip = ItemPropertyArcaneSpellFailure(nASF); 
	
	AddItemProperty(DURATION_TYPE_PERMANENT, ip, oSkin);
	SetLocalInt(oSkin, "WarlockArmourCasting", nASF);
}  

void main()
{
	object oPC = OBJECT_SELF;
	object oSkin = GetPCSkin(oPC);
	
	if (GetIsPC(oPC)) ReducedASF(oPC);
	
	int nClass = GetLevelByClass(CLASS_TYPE_WARLOCK, oPC);
		
	//Reduction
	int nRedAmt = (nClass + 1) / 4;
	effect eReduction = EffectDamageReduction(nRedAmt, DAMAGE_POWER_PLUS_THREE);
	    
	if(nClass > 2)
	   ApplyEffectToObject(DURATION_TYPE_PERMANENT, ExtraordinaryEffect(eReduction), oPC);
	   
	//Energy Resistance
	int nResistAmt = nClass >= 20 ? 10 : 5;
	
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