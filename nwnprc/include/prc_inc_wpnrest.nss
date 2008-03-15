//::///////////////////////////////////////////////
//:: Weapon Restriction System Include
//:: prc_inc_restwpn.nss
//::///////////////////////////////////////////////
/*
    Functions to support PnP Weapon Proficiency and
    weapon feat chain simulation
*/
//:://////////////////////////////////////////////
//:: Created By: Fox
//:: Created On: Feb 2, 2008
//:://////////////////////////////////////////////

#include "prc_inc_combat"
#include "prc_alterations"


/**
 * All of the following functions use the following parameters:
 *
 * @param oPC       The character weilding the weapon
 * @param oItem     The item in question.
 * @param nHand     The hand the weapon is wielded in.  In the form of 
 *                  ATTACK_BONUS_ONHAND or ATTACK_BONUS_OFFHAND.
 */
 
 //handles the feat chain for Elven Lightblades
void DoEquipLightblade(object oPC, object oItem, int nHand)
{
	if(DEBUG) DoDebug("Checking Lightblade feats");
	if(GetHasFeat(FEAT_WEAPON_FOCUS_SHORT_SWORD, oPC) || GetHasFeat(FEAT_WEAPON_FOCUS_RAPIER, oPC))
	{
	    SetCompositeAttackBonus(oPC, "LightbladeWF" + IntToString(nHand), 1, nHand);
	}
	if(GetHasFeat(FEAT_EPIC_WEAPON_FOCUS_SHORTSWORD, oPC) || GetHasFeat(FEAT_EPIC_WEAPON_FOCUS_RAPIER, oPC))
	    SetCompositeAttackBonus(oPC, "LightbladeEpicWF" + IntToString(nHand), 2, nHand);
	if(GetHasFeat(FEAT_WEAPON_SPECIALIZATION_SHORT_SWORD, oPC) || GetHasFeat(FEAT_WEAPON_SPECIALIZATION_RAPIER, oPC))
	    SetCompositeDamageBonusT(oItem, "LightbladeWS", 2);
	if(GetHasFeat(FEAT_EPIC_WEAPON_SPECIALIZATION_SHORTSWORD, oPC) || GetHasFeat(FEAT_EPIC_WEAPON_SPECIALIZATION_RAPIER, oPC))
	    SetCompositeDamageBonusT(oItem, "LightbladeEpicWS", 4);
	if(GetHasFeat(FEAT_IMPROVED_CRITICAL_SHORT_SWORD, oPC) || GetHasFeat(FEAT_IMPROVED_CRITICAL_RAPIER, oPC))
	    IPSafeAddItemProperty(oItem, ItemPropertyKeen(), 99999.0, X2_IP_ADDPROP_POLICY_KEEP_EXISTING, FALSE, FALSE);
}

//handles the feat chain for Elven Thinblades
void DoEquipThinblade(object oPC, object oItem, int nHand)
{
	if(GetHasFeat(FEAT_WEAPON_FOCUS_LONG_SWORD, oPC) || GetHasFeat(FEAT_WEAPON_FOCUS_RAPIER, oPC))
	    SetCompositeAttackBonus(oPC, "ThinbladeWF" + IntToString(nHand), 1, nHand);
	if(GetHasFeat(FEAT_EPIC_WEAPON_FOCUS_LONGSWORD, oPC) || GetHasFeat(FEAT_EPIC_WEAPON_FOCUS_RAPIER, oPC))
	    SetCompositeAttackBonus(oPC, "ThinbladeEpicWF" + IntToString(nHand), 2, nHand);
	if(GetHasFeat(FEAT_WEAPON_SPECIALIZATION_LONG_SWORD, oPC) || GetHasFeat(FEAT_WEAPON_SPECIALIZATION_RAPIER, oPC))
	    SetCompositeDamageBonusT(oItem, "ThinbladeWS", 2);
	if(GetHasFeat(FEAT_EPIC_WEAPON_SPECIALIZATION_LONGSWORD, oPC) || GetHasFeat(FEAT_EPIC_WEAPON_SPECIALIZATION_RAPIER, oPC))
	    SetCompositeDamageBonusT(oItem, "ThinbladeEpicWS", 4);
	if(GetHasFeat(FEAT_IMPROVED_CRITICAL_LONG_SWORD, oPC) || GetHasFeat(FEAT_IMPROVED_CRITICAL_RAPIER, oPC))
	    IPSafeAddItemProperty(oItem, ItemPropertyKeen(), 99999.0, X2_IP_ADDPROP_POLICY_KEEP_EXISTING, FALSE, FALSE);
}

//handles the feat chain for Elven Courtblades
void DoEquipCourtblade(object oPC, object oItem, int nHand)
{
	if(GetHasFeat(FEAT_WEAPON_FOCUS_GREAT_SWORD, oPC))
	    SetCompositeAttackBonus(oPC, "CourtbladeWF" + IntToString(nHand), 1, nHand);
	if(GetHasFeat(FEAT_EPIC_WEAPON_FOCUS_GREATSWORD, oPC))
	    SetCompositeAttackBonus(oPC, "CourtbladeEpicWF" + IntToString(nHand), 2, nHand);
	if(GetHasFeat(FEAT_WEAPON_SPECIALIZATION_GREAT_SWORD, oPC))
	    SetCompositeDamageBonusT(oItem, "CourtbladeWS", 2);
	if(GetHasFeat(FEAT_EPIC_WEAPON_SPECIALIZATION_GREATSWORD, oPC))
	    SetCompositeDamageBonusT(oItem, "CourtbladeEpicWS", 4);
	if(GetHasFeat(FEAT_IMPROVED_CRITICAL_GREAT_SWORD, oPC))
	    IPSafeAddItemProperty(oItem, ItemPropertyKeen(), 99999.0, X2_IP_ADDPROP_POLICY_KEEP_EXISTING, FALSE, FALSE);
}

//handles the Aptitude weapon feat chain
void DoEquipAptitude(object oPC, object oItem, int nHand)
{
	if(GetHasFeat(FEAT_WEAPON_FOCUS_APTITUDE, oPC) && !GetFeatOfWeaponType(GetBaseItemType(oItem), FEAT_TYPE_FOCUS))
	    SetCompositeAttackBonus(oPC, "AptitudeWF" + IntToString(nHand), 1, nHand);
	if(GetHasFeat(FEAT_EPIC_WEAPON_FOCUS_APTITUDE, oPC) && !GetFeatOfWeaponType(GetBaseItemType(oItem), FEAT_TYPE_EPIC_FOCUS))
	    SetCompositeAttackBonus(oPC, "AptitudeEpicWF" + IntToString(nHand), 2, nHand);
	if(GetHasFeat(FEAT_WEAPON_SPECIALIZATION_APTITUDE, oPC) && !GetFeatOfWeaponType(GetBaseItemType(oItem), FEAT_TYPE_SPECIALIZATION))
	    SetCompositeDamageBonusT(oItem, "AptitudeWS", 2);
	if(GetHasFeat(FEAT_EPIC_WEAPON_SPECIALIZATION_APTITUDE, oPC) && !GetFeatOfWeaponType(GetBaseItemType(oItem), FEAT_TYPE_EPIC_SPECIALIZATION))
	    SetCompositeDamageBonusT(oItem, "AptitudeEpicWS", 4);
	if(GetHasFeat(FEAT_IMPROVED_CRITICAL_APTITUDE, oPC) && !GetFeatOfWeaponType(GetBaseItemType(oItem), FEAT_TYPE_IMPROVED_CRITICAL))
	    IPSafeAddItemProperty(oItem, ItemPropertyKeen(), 99999.0, X2_IP_ADDPROP_POLICY_KEEP_EXISTING, FALSE, FALSE);
}

//clears any bonuses used to simulate feat chains on unequip
void DoWeaponFeatUnequip(object oPC, object oItem, int nHand)
{
	if(GetBaseItemType(oItem) == BASE_ITEM_ELF_LIGHTBLADE)
	{
	    if(DEBUG) DoDebug("Clearing Lightblade variables.");
	    SetCompositeAttackBonus(oPC, "LightbladeWF" + IntToString(nHand), 0, nHand);
	    SetCompositeAttackBonus(oPC, "LightbladeEpicWF" + IntToString(nHand), 0, nHand);
	    SetCompositeDamageBonusT(oItem, "LightbladeWS", 0);
	    SetCompositeDamageBonusT(oItem, "LightbladeEpicWS", 0);
	}
	if(GetBaseItemType(oItem) == BASE_ITEM_ELF_THINBLADE)
	{
	    SetCompositeAttackBonus(oPC, "ThinbladeWF" + IntToString(nHand), 0, nHand);
	    SetCompositeAttackBonus(oPC, "ThinbladeEpicWF" + IntToString(nHand), 0, nHand);
	    SetCompositeDamageBonusT(oItem, "ThinbladeWS", 0);
	    SetCompositeDamageBonusT(oItem, "ThinbladeEpicWS", 0);
	}
	if(GetBaseItemType(oItem) == BASE_ITEM_ELF_COURTBLADE)
	{
	    SetCompositeAttackBonus(oPC, "CourtbladeWF" + IntToString(nHand), 0, nHand);
	    SetCompositeAttackBonus(oPC, "CourtbladeEpicWF" + IntToString(nHand), 0, nHand);
	    SetCompositeDamageBonusT(oItem, "CourtbladeWS", 0);
	    SetCompositeDamageBonusT(oItem, "CourtbladeEpicWS", 0);
	}
	RemoveSpecificProperty(oItem, ITEM_PROPERTY_KEEN, -1, -1, 1, "", -1, DURATION_TYPE_TEMPORARY);
	
	//Weapon Aptitude for ToB
	if(GetBaseItemType(oItem) == GetLocalInt(oPC, "AptitudeWpnType"))
	{
	    SetCompositeAttackBonus(oPC, "AptitudeWF" + IntToString(nHand), 0, nHand);
	    SetCompositeAttackBonus(oPC, "AptitudeEpicWF" + IntToString(nHand), 0, nHand);
	    SetCompositeDamageBonusT(oItem, "AptitudeWS", 0);
	    SetCompositeDamageBonusT(oItem, "AptitudeEpicWS", 0);
	}
}

int IsWeaponMartial(int nBaseItemType, object oPC)
{
    switch(nBaseItemType)
	{ 
	    case BASE_ITEM_SHORTSWORD:
	    case BASE_ITEM_LONGSWORD:
	    case BASE_ITEM_BATTLEAXE:
	    case BASE_ITEM_LIGHTFLAIL:
	    case BASE_ITEM_WARHAMMER:
	    case BASE_ITEM_LONGBOW:
	    case BASE_ITEM_HALBERD:
	    case BASE_ITEM_SHORTBOW:
	    case BASE_ITEM_GREATSWORD:
	    case BASE_ITEM_GREATAXE:
	    case BASE_ITEM_HEAVYFLAIL:
	    case BASE_ITEM_LIGHTHAMMER:
	    case BASE_ITEM_HANDAXE:
	    case BASE_ITEM_RAPIER:
	    case BASE_ITEM_SCIMITAR:
	    case BASE_ITEM_THROWINGAXE:
	         return TRUE;
	         
	    //special case: counts as martial for dwarves
	    case BASE_ITEM_DWARVENWARAXE:
	        if(GetHasFeat(FEAT_DWARVEN, oPC))
	          return TRUE;
	    
	    default:
	         return FALSE;
	    	
	}
	
	return FALSE;
}

//checks to see if the PC can wield the weapon.  If not, applies a -4 penalty.
void DoProficiencyCheck(object oPC, object oItem, int nHand)
{
	int bProficient = FALSE;
	
	if(!GetIsWeapon(oItem)) bProficient = TRUE;
	
	switch(GetBaseItemType(oItem))
	{ 
	    case BASE_ITEM_SHORTSWORD:
	        if(GetHasFeat(FEAT_WEAPON_PROFICIENCY_MARTIAL, oPC)
	           || GetHasFeat(FEAT_WEAPON_PROFICIENCY_ROGUE, oPC)
	           || GetHasFeat(FEAT_MINDBLADE, oPC)
	           || GetHasFeat(FEAT_WEAPON_PROFICIENCY_SHORTSWORD, oPC))
	          bProficient = TRUE; break;
	    
	    case BASE_ITEM_LONGSWORD:
	        if(GetHasFeat(FEAT_WEAPON_PROFICIENCY_MARTIAL, oPC)
	           || GetHasFeat(FEAT_MINDBLADE, oPC)
	           || GetHasFeat(FEAT_WEAPON_PROFICIENCY_ELF, oPC)
	           || GetHasFeat(FEAT_WEAPON_PROFICIENCY_LONGSWORD, oPC))
	          bProficient = TRUE; break;
	    
	    case BASE_ITEM_BATTLEAXE:
	        if(GetHasFeat(FEAT_WEAPON_PROFICIENCY_MARTIAL, oPC)
	           || GetHasFeat(FEAT_WEAPON_PROFICIENCY_BATTLEAXE, oPC))
	          bProficient = TRUE; break;
	    
	    case BASE_ITEM_BASTARDSWORD:
	        if(GetHasFeat(FEAT_WEAPON_PROFICIENCY_EXOTIC, oPC)
	           || GetHasFeat(FEAT_MINDBLADE, oPC)
	           || GetHasFeat(FEAT_WEAPON_PROFICIENCY_BASTARD_SWORD, oPC))
	          bProficient = TRUE; break;
	    
	    case BASE_ITEM_LIGHTFLAIL:
	        if(GetHasFeat(FEAT_WEAPON_PROFICIENCY_MARTIAL, oPC)
	           || GetHasFeat(FEAT_WEAPON_PROFICIENCY_LIGHT_FLAIL, oPC))
	          bProficient = TRUE; break;
	    
	    case BASE_ITEM_WARHAMMER:
	        if(GetHasFeat(FEAT_WEAPON_PROFICIENCY_MARTIAL, oPC)
	           || GetHasFeat(FEAT_WEAPON_PROFICIENCY_WARHAMMER, oPC))
	          bProficient = TRUE; break;
	    
	    case BASE_ITEM_LONGBOW:
	        if(GetHasFeat(FEAT_WEAPON_PROFICIENCY_MARTIAL, oPC)
	           || GetHasFeat(FEAT_WEAPON_PROFICIENCY_ELF, oPC)
	           || GetHasFeat(FEAT_WEAPON_PROFICIENCY_LONGBOW, oPC))
	          bProficient = TRUE; break;
	    
	    case BASE_ITEM_LIGHTMACE:
	        if(GetHasFeat(FEAT_WEAPON_PROFICIENCY_SIMPLE, oPC)
	           || GetHasFeat(FEAT_WEAPON_PROFICIENCY_ROGUE, oPC)
	           || GetHasFeat(FEAT_WEAPON_PROFICIENCY_LIGHT_MACE, oPC))
	          bProficient = TRUE; break;
	    
	    case BASE_ITEM_HALBERD:
	        if(GetHasFeat(FEAT_WEAPON_PROFICIENCY_MARTIAL, oPC)
	           || GetHasFeat(FEAT_WEAPON_PROFICIENCY_HALBERD, oPC))
	          bProficient = TRUE; break;
	    
	    case BASE_ITEM_SHORTBOW:
	        if(GetHasFeat(FEAT_WEAPON_PROFICIENCY_MARTIAL, oPC)
	           || GetHasFeat(FEAT_WEAPON_PROFICIENCY_ROGUE, oPC)
	           || GetHasFeat(FEAT_WEAPON_PROFICIENCY_ELF, oPC)
	           || GetHasFeat(FEAT_WEAPON_PROFICIENCY_SHORTBOW, oPC))
	          bProficient = TRUE; break;
	    
	    case BASE_ITEM_TWOBLADEDSWORD:
	        if(GetHasFeat(FEAT_WEAPON_PROFICIENCY_EXOTIC, oPC)
	           || GetHasFeat(FEAT_WEAPON_PROFICIENCY_TWO_BLADED_SWORD, oPC))
	          bProficient = TRUE; break;
	    
	    case BASE_ITEM_GREATSWORD:
	        if(GetHasFeat(FEAT_WEAPON_PROFICIENCY_MARTIAL, oPC)
	           || GetHasFeat(FEAT_WEAPON_PROFICIENCY_GREATSWORD, oPC))
	          bProficient = TRUE; break;
	    
	    case BASE_ITEM_GREATAXE:
	        if(GetHasFeat(FEAT_WEAPON_PROFICIENCY_MARTIAL, oPC)
	           || GetHasFeat(FEAT_WEAPON_PROFICIENCY_GREATAXE, oPC))
	          bProficient = TRUE;  break;
	    
	    case BASE_ITEM_DART:
	        if(GetHasFeat(FEAT_WEAPON_PROFICIENCY_SIMPLE, oPC)
	           || GetHasFeat(FEAT_WEAPON_PROFICIENCY_ROGUE, oPC)
	           || GetHasFeat(FEAT_WEAPON_PROFICIENCY_DRUID, oPC)
	           || GetHasFeat(FEAT_WEAPON_PROFICIENCY_DART, oPC))
	          bProficient = TRUE; break;
	    
	    case BASE_ITEM_DIREMACE:
	        if(GetHasFeat(FEAT_WEAPON_PROFICIENCY_EXOTIC, oPC)
	           || GetHasFeat(FEAT_WEAPON_PROFICIENCY_DIRE_MACE, oPC))
	          bProficient = TRUE; break;
	    
	    case BASE_ITEM_DOUBLEAXE:
	        if(GetHasFeat(FEAT_WEAPON_PROFICIENCY_EXOTIC, oPC)
	           || GetHasFeat(FEAT_WEAPON_PROFICIENCY_DOUBLE_AXE, oPC))
	          bProficient = TRUE; break;
	    
	    case BASE_ITEM_HEAVYFLAIL:
	        if(GetHasFeat(FEAT_WEAPON_PROFICIENCY_MARTIAL, oPC)
	           || GetHasFeat(FEAT_WEAPON_PROFICIENCY_HEAVY_FLAIL, oPC))
	          bProficient = TRUE; break;
	    
	    case BASE_ITEM_LIGHTHAMMER:
	        if(GetHasFeat(FEAT_WEAPON_PROFICIENCY_MARTIAL, oPC)
	           || GetHasFeat(FEAT_WEAPON_PROFICIENCY_LIGHT_HAMMER, oPC))
	          bProficient = TRUE; break;
	    
	    case BASE_ITEM_HANDAXE:
	        if(GetHasFeat(FEAT_WEAPON_PROFICIENCY_MARTIAL, oPC)
	           || GetHasFeat(FEAT_WEAPON_PROFICIENCY_ROGUE, oPC)
	           || GetHasFeat(FEAT_WEAPON_PROFICIENCY_MONK, oPC)
	           || GetHasFeat(FEAT_WEAPON_PROFICIENCY_HANDAXE, oPC))
	          bProficient = TRUE; break;
	    
	    case BASE_ITEM_KAMA:
	        if(GetHasFeat(FEAT_WEAPON_PROFICIENCY_EXOTIC, oPC)
	           || GetHasFeat(FEAT_WEAPON_PROFICIENCY_MONK, oPC)
	           || GetHasFeat(FEAT_WEAPON_PROFICIENCY_KAMA, oPC))
	          bProficient = TRUE; break;
	    
	    case BASE_ITEM_KATANA:
	        if(GetHasFeat(FEAT_WEAPON_PROFICIENCY_EXOTIC, oPC)
	           || GetHasFeat(FEAT_WEAPON_PROFICIENCY_KATANA, oPC))
	          bProficient = TRUE; break;
	    
	    case BASE_ITEM_KUKRI:
	        if(GetHasFeat(FEAT_WEAPON_PROFICIENCY_EXOTIC, oPC)
	           || GetHasFeat(FEAT_WEAPON_PROFICIENCY_KUKRI, oPC))
	          bProficient = TRUE; break;
	    
	    case BASE_ITEM_MORNINGSTAR:
	        if(GetHasFeat(FEAT_WEAPON_PROFICIENCY_SIMPLE, oPC)
	           || GetHasFeat(FEAT_WEAPON_PROFICIENCY_ROGUE, oPC)
	           || GetHasFeat(FEAT_WEAPON_PROFICIENCY_MORNINGSTAR, oPC))
	          bProficient = TRUE; break;
	    
	    case BASE_ITEM_RAPIER:
	        if(GetHasFeat(FEAT_WEAPON_PROFICIENCY_MARTIAL, oPC)
	           || GetHasFeat(FEAT_WEAPON_PROFICIENCY_ROGUE, oPC)
	           || GetHasFeat(FEAT_WEAPON_PROFICIENCY_ELF, oPC)
	           || GetHasFeat(FEAT_WEAPON_PROFICIENCY_RAPIER, oPC))
	          bProficient = TRUE; break;
	    
	    case BASE_ITEM_SCIMITAR:
	        if(GetHasFeat(FEAT_WEAPON_PROFICIENCY_MARTIAL, oPC)
	           || GetHasFeat(FEAT_WEAPON_PROFICIENCY_DRUID, oPC)
	           || GetHasFeat(FEAT_WEAPON_PROFICIENCY_SCIMITAR, oPC))
	          bProficient = TRUE; break;
	    
	    case BASE_ITEM_SCYTHE:
	        if(GetHasFeat(FEAT_WEAPON_PROFICIENCY_EXOTIC, oPC)
	           || GetHasFeat(FEAT_WEAPON_PROFICIENCY_SCYTHE, oPC))
	          bProficient = TRUE; break;
	    
	    case BASE_ITEM_SHORTSPEAR:
	        if(GetHasFeat(FEAT_WEAPON_PROFICIENCY_SIMPLE, oPC)
	           || GetHasFeat(FEAT_WEAPON_PROFICIENCY_DRUID, oPC)
	           || GetHasFeat(FEAT_WEAPON_PROFICIENCY_SHORTSPEAR, oPC))
	          bProficient = TRUE; break;
	    
	    case BASE_ITEM_SHURIKEN:
	        if(GetHasFeat(FEAT_WEAPON_PROFICIENCY_EXOTIC, oPC)
	           || GetHasFeat(FEAT_WEAPON_PROFICIENCY_MONK, oPC)
	           || GetHasFeat(FEAT_WEAPON_PROFICIENCY_SHURIKEN, oPC))
	          bProficient = TRUE; break;
	    
	    case BASE_ITEM_SICKLE:
	        if(GetHasFeat(FEAT_WEAPON_PROFICIENCY_SIMPLE, oPC)
	           || GetHasFeat(FEAT_WEAPON_PROFICIENCY_DRUID, oPC)
	           || GetHasFeat(FEAT_WEAPON_PROFICIENCY_SICKLE, oPC))
	          bProficient = TRUE; break;
	    
	    case BASE_ITEM_SLING:
	        if(GetHasFeat(FEAT_WEAPON_PROFICIENCY_SIMPLE, oPC)
	           || GetHasFeat(FEAT_WEAPON_PROFICIENCY_ROGUE, oPC)
	           || GetHasFeat(FEAT_WEAPON_PROFICIENCY_MONK, oPC)
	           || GetHasFeat(FEAT_WEAPON_PROFICIENCY_DRUID, oPC)
	           || GetHasFeat(FEAT_WEAPON_PROFICIENCY_SLING, oPC))
	          bProficient = TRUE; break;
	    
	    case BASE_ITEM_THROWINGAXE:
	        if(GetHasFeat(FEAT_WEAPON_PROFICIENCY_MARTIAL, oPC)
	           || GetHasFeat(FEAT_MINDBLADE, oPC)
	           || GetHasFeat(FEAT_WEAPON_PROFICIENCY_THROWING_AXE, oPC))
	          bProficient = TRUE; break;
	    
	    case BASE_ITEM_CSLASHWEAPON:
	        if(GetHasFeat(FEAT_WEAPON_PROFICIENCY_CREATURE, oPC))
	          bProficient = TRUE; break;
	    
	    case BASE_ITEM_CPIERCWEAPON:
	        if(GetHasFeat(FEAT_WEAPON_PROFICIENCY_CREATURE, oPC))
	          bProficient = TRUE; break;
	    
	    case BASE_ITEM_CBLUDGWEAPON:
	        if(GetHasFeat(FEAT_WEAPON_PROFICIENCY_CREATURE, oPC))
	          bProficient = TRUE; break;
	    
	    case BASE_ITEM_CSLSHPRCWEAP:
	        if(GetHasFeat(FEAT_WEAPON_PROFICIENCY_CREATURE, oPC))
	          bProficient = TRUE; break;
	    
	    case BASE_ITEM_TRIDENT:
	        if(GetHasFeat(FEAT_WEAPON_PROFICIENCY_SIMPLE, oPC)
	           || GetHasFeat(FEAT_WEAPON_PROFICIENCY_DRUID, oPC)
	           || GetHasFeat(FEAT_WEAPON_PROFICIENCY_TRIDENT, oPC))
	          bProficient = TRUE; break;
	    
	    //special case: counts as martial for dwarves
	    case BASE_ITEM_DWARVENWARAXE:
	        if(GetHasFeat(FEAT_WEAPON_PROFICIENCY_EXOTIC, oPC)
	           || (GetHasFeat(FEAT_WEAPON_PROFICIENCY_MARTIAL, oPC) && GetHasFeat(FEAT_DWARVEN, oPC))
	           || GetHasFeat(FEAT_WEAPON_PROFICIENCY_DWARVEN_WARAXE, oPC))
	          bProficient = TRUE; break;
	    
	    case BASE_ITEM_WHIP:
	        if(GetHasFeat(FEAT_WEAPON_PROFICIENCY_EXOTIC, oPC)
	           || GetHasFeat(FEAT_PYRO_FIRE_LASH, oPC)
	           || GetHasFeat(FEAT_WEAPON_PROFICIENCY_WHIP, oPC))
	          bProficient = TRUE; break;
	    
	    case BASE_ITEM_ELF_LIGHTBLADE:
	        if(GetHasFeat(FEAT_WEAPON_PROFICIENCY_EXOTIC, oPC)
	           || GetHasFeat(FEAT_WEAPON_PROFICIENCY_ELVEN_LIGHTBLADE, oPC))
	          bProficient = TRUE; break;
	    
	    case BASE_ITEM_ELF_THINBLADE:
	        if(GetHasFeat(FEAT_WEAPON_PROFICIENCY_EXOTIC, oPC)
	           || GetHasFeat(FEAT_WEAPON_PROFICIENCY_ELVEN_THINBLADE, oPC))
	          bProficient = TRUE; break;
	    
	    case BASE_ITEM_ELF_COURTBLADE:
	        if(GetHasFeat(FEAT_WEAPON_PROFICIENCY_EXOTIC, oPC)
	           || GetHasFeat(FEAT_WEAPON_PROFICIENCY_ELVEN_COURTBLADE, oPC))
	          bProficient = TRUE; break;
	          
	    case BASE_ITEM_DAGGER:
	    case BASE_ITEM_LIGHTCROSSBOW:
	    case BASE_ITEM_HEAVYCROSSBOW:
	    case BASE_ITEM_CLUB:
	    case BASE_ITEM_QUARTERSTAFF:
	         bProficient = TRUE; break;
	         
	    default:
	         bProficient = TRUE; break;
	    	
	}
	
	if(GetPersistantLocalInt(oPC, "FavouredSoulDietyWeapon") == GetBaseItemType(oItem))
	    bProficient = TRUE;
	
	if(!bProficient) SetCompositeAttackBonus(oPC, "Unproficient" + IntToString(nHand), -4, nHand);
}

void DoWeaponEquip(object oPC, object oItem, int nHand)
{
    if(GetIsDM(oPC)) return;
	
    //initialize variables
    int nRealSize = PRCGetCreatureSize(oPC);  //size for Finesse/TWF
    int nSize = nRealSize;                    //size for equipment restrictions
    int nDexMod = GetAbilityModifier(ABILITY_DEXTERITY, oPC);
    int nStrMod = GetAbilityModifier(ABILITY_STRENGTH, oPC);
    int nElfFinesse = nDexMod - nStrMod;
    int nTHFDmgBonus = nStrMod / 2;
      
    //Powerful Build bonus
    if(GetHasFeat(FEAT_RACE_POWERFUL_BUILD, oPC))
        nSize++;
        
    //check to make sure it's not too large, or that you're not trying to TWF with 2-handers
    if((GetWeaponSize(oItem) > 1 + nSize && nHand == ATTACK_BONUS_ONHAND)
       || ((GetWeaponSize(oItem) > nSize || GetWeaponSize(GetItemInSlot(INVENTORY_SLOT_RIGHTHAND, oPC)) > nSize) && nHand == ATTACK_BONUS_OFFHAND)
       )
        // Force unequip
        AssignCommand(oPC, ActionUnequipItem(oItem));
                   
    //check for proficiency
    DoProficiencyCheck(oPC, oItem, nHand);
                
    //simulate Weapon Finesse for Elven *blades    
    if((GetBaseItemType(oItem) == BASE_ITEM_ELF_LIGHTBLADE || GetBaseItemType(oItem) == BASE_ITEM_ELF_THINBLADE 
       || GetBaseItemType(oItem) == BASE_ITEM_ELF_COURTBLADE) && GetHasFeat(FEAT_WEAPON_FINESSE, oPC) && nElfFinesse > 0)
    {
    	if(nHand == ATTACK_BONUS_ONHAND)
            SetCompositeAttackBonus(oPC, "ElfFinesseRH", nElfFinesse, nHand);
    	else if(nHand == ATTACK_BONUS_OFFHAND)
            SetCompositeAttackBonus(oPC, "ElfFinesseLH", nElfFinesse, nHand);
    }
    //Two-hand damage bonus
    if(GetWeaponSize(oItem) == nSize + 1 || (GetWeaponSize(oItem) == nRealSize + 1 && GetItemInSlot(INVENTORY_SLOT_LEFTHAND, oPC) == OBJECT_INVALID))
    {
        if(DEBUG) DoDebug("Applying THF damage bonus");
        SetCompositeDamageBonusT(oItem, "THFBonus", nTHFDmgBonus);
    }
                
    //if a 2-hander, then unequip shield/offhand weapon
    if(GetWeaponSize(oItem) == 1 + nSize && nHand == ATTACK_BONUS_ONHAND)
        // Force unequip
        AssignCommand(oPC, ActionUnequipItem(GetItemInSlot(INVENTORY_SLOT_LEFTHAND, oPC)));
           
                
    //apply TWF penalty if a one-handed, not light weapon in offhand - -4/-4 etc isntead of -2/-2
    if(GetWeaponSize(oItem) == nRealSize && nHand == ATTACK_BONUS_OFFHAND)
        // Assign penalty
        SetCompositeAttackBonus(oPC, "OTWFPenalty", -2);
           
           
    //Check for Weapon Aptitude
    if(GetBaseItemType(oItem) == GetLocalInt(oPC, "AptitudeWpnType"))
        DoEquipAptitude(oPC, oItem, nHand);
    //Handle feat bonuses for Lightblade, thinblade, and courtblade
    //using else if so they don't overlap.
    else if(GetBaseItemType(oItem) == BASE_ITEM_ELF_LIGHTBLADE)
        DoEquipLightblade(oPC, oItem, nHand);
    else if(GetBaseItemType(oItem) == BASE_ITEM_ELF_THINBLADE)
        DoEquipThinblade(oPC, oItem, nHand);
    else if(GetBaseItemType(oItem) == BASE_ITEM_ELF_COURTBLADE)
        DoEquipCourtblade(oPC, oItem, nHand);
}