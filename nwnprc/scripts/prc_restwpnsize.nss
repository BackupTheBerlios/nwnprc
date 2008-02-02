//::///////////////////////////////////////////////
//:: Restrict Weapon Size
//:: prc_restwpnsize.nss
//::///////////////////////////////////////////////
/*
    Handles size restrictions on weapon-wielding
*/
//:://////////////////////////////////////////////
//:: Created By: Fox
//:: Created On: Jan 31, 2008
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

//clears any bonuses used to simulate feat chains on unequip
void DoElfbladeUnequip(object oPC, object oItem, int nHand)
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
	           || GetHasFeat(FEAT_MINDBLADE, oPC))
	          bProficient = TRUE; break;
	    
	    case BASE_ITEM_LONGSWORD:
	        if(GetHasFeat(FEAT_WEAPON_PROFICIENCY_MARTIAL, oPC)
	           || GetHasFeat(FEAT_MINDBLADE, oPC)
	           || GetHasFeat(FEAT_WEAPON_PROFICIENCY_ELF, oPC))
	          bProficient = TRUE; break;
	    
	    case BASE_ITEM_BATTLEAXE:
	        if(GetHasFeat(FEAT_WEAPON_PROFICIENCY_MARTIAL, oPC))
	          bProficient = TRUE; break;
	    
	    case BASE_ITEM_BASTARDSWORD:
	        if(GetHasFeat(FEAT_WEAPON_PROFICIENCY_EXOTIC, oPC)
	           || GetHasFeat(FEAT_MINDBLADE, oPC))
	          bProficient = TRUE; break;
	    
	    case BASE_ITEM_LIGHTFLAIL:
	        if(GetHasFeat(FEAT_WEAPON_PROFICIENCY_MARTIAL, oPC))
	          bProficient = TRUE; break;
	    
	    case BASE_ITEM_WARHAMMER:
	        if(GetHasFeat(FEAT_WEAPON_PROFICIENCY_MARTIAL, oPC))
	          bProficient = TRUE; break;
	    
	    case BASE_ITEM_LONGBOW:
	        if(GetHasFeat(FEAT_WEAPON_PROFICIENCY_MARTIAL, oPC)
	           || GetHasFeat(FEAT_WEAPON_PROFICIENCY_ELF, oPC))
	          bProficient = TRUE; break;
	    
	    case BASE_ITEM_LIGHTMACE:
	        if(GetHasFeat(FEAT_WEAPON_PROFICIENCY_SIMPLE, oPC)
	           || GetHasFeat(FEAT_WEAPON_PROFICIENCY_ROGUE, oPC))
	          bProficient = TRUE; break;
	    
	    case BASE_ITEM_HALBERD:
	        if(GetHasFeat(FEAT_WEAPON_PROFICIENCY_MARTIAL, oPC))
	          bProficient = TRUE; break;
	    
	    case BASE_ITEM_SHORTBOW:
	        if(GetHasFeat(FEAT_WEAPON_PROFICIENCY_MARTIAL, oPC)
	           || GetHasFeat(FEAT_WEAPON_PROFICIENCY_ROGUE, oPC)
	           || GetHasFeat(FEAT_WEAPON_PROFICIENCY_ELF, oPC))
	          bProficient = TRUE; break;
	    
	    case BASE_ITEM_TWOBLADEDSWORD:
	        if(GetHasFeat(FEAT_WEAPON_PROFICIENCY_EXOTIC, oPC))
	          bProficient = TRUE; break;
	    
	    case BASE_ITEM_GREATSWORD:
	        if(GetHasFeat(FEAT_WEAPON_PROFICIENCY_MARTIAL, oPC))
	          bProficient = TRUE; break;
	    
	    case BASE_ITEM_GREATAXE:
	        if(GetHasFeat(FEAT_WEAPON_PROFICIENCY_MARTIAL, oPC))
	          bProficient = TRUE;  break;
	    
	    case BASE_ITEM_DART:
	        if(GetHasFeat(FEAT_WEAPON_PROFICIENCY_SIMPLE, oPC)
	           || GetHasFeat(FEAT_WEAPON_PROFICIENCY_ROGUE, oPC)
	           || GetHasFeat(FEAT_WEAPON_PROFICIENCY_DRUID, oPC))
	          bProficient = TRUE; break;
	    
	    case BASE_ITEM_DIREMACE:
	        if(GetHasFeat(FEAT_WEAPON_PROFICIENCY_EXOTIC, oPC))
	          bProficient = TRUE; break;
	    
	    case BASE_ITEM_DOUBLEAXE:
	        if(GetHasFeat(FEAT_WEAPON_PROFICIENCY_EXOTIC, oPC))
	          bProficient = TRUE; break;
	    
	    case BASE_ITEM_HEAVYFLAIL:
	        if(GetHasFeat(FEAT_WEAPON_PROFICIENCY_MARTIAL, oPC))
	          bProficient = TRUE; break;
	    
	    case BASE_ITEM_LIGHTHAMMER:
	        if(GetHasFeat(FEAT_WEAPON_PROFICIENCY_MARTIAL, oPC))
	          bProficient = TRUE; break;
	    
	    case BASE_ITEM_HANDAXE:
	        if(GetHasFeat(FEAT_WEAPON_PROFICIENCY_MARTIAL, oPC)
	           || GetHasFeat(FEAT_WEAPON_PROFICIENCY_ROGUE, oPC)
	           || GetHasFeat(FEAT_WEAPON_PROFICIENCY_MONK, oPC))
	          bProficient = TRUE; break;
	    
	    case BASE_ITEM_KAMA:
	        if(GetHasFeat(FEAT_WEAPON_PROFICIENCY_EXOTIC, oPC)
	           || GetHasFeat(FEAT_WEAPON_PROFICIENCY_MONK, oPC))
	          bProficient = TRUE; break;
	    
	    case BASE_ITEM_KATANA:
	        if(GetHasFeat(FEAT_WEAPON_PROFICIENCY_EXOTIC, oPC))
	          bProficient = TRUE; break;
	    
	    case BASE_ITEM_KUKRI:
	        if(GetHasFeat(FEAT_WEAPON_PROFICIENCY_EXOTIC, oPC))
	          bProficient = TRUE; break;
	    
	    case BASE_ITEM_MORNINGSTAR:
	        if(GetHasFeat(FEAT_WEAPON_PROFICIENCY_SIMPLE, oPC)
	           || GetHasFeat(FEAT_WEAPON_PROFICIENCY_ROGUE, oPC))
	          bProficient = TRUE; break;
	    
	    case BASE_ITEM_RAPIER:
	        if(GetHasFeat(FEAT_WEAPON_PROFICIENCY_MARTIAL, oPC)
	           || GetHasFeat(FEAT_WEAPON_PROFICIENCY_ROGUE, oPC)
	           || GetHasFeat(FEAT_WEAPON_PROFICIENCY_ELF, oPC))
	          bProficient = TRUE; break;
	    
	    case BASE_ITEM_SCIMITAR:
	        if(GetHasFeat(FEAT_WEAPON_PROFICIENCY_MARTIAL, oPC)
	           || GetHasFeat(FEAT_WEAPON_PROFICIENCY_DRUID, oPC))
	          bProficient = TRUE; break;
	    
	    case BASE_ITEM_SCYTHE:
	        if(GetHasFeat(FEAT_WEAPON_PROFICIENCY_EXOTIC, oPC))
	          bProficient = TRUE; break;
	    
	    case BASE_ITEM_SHORTSPEAR:
	        if(GetHasFeat(FEAT_WEAPON_PROFICIENCY_SIMPLE, oPC)
	           || GetHasFeat(FEAT_WEAPON_PROFICIENCY_DRUID, oPC))
	          bProficient = TRUE; break;
	    
	    case BASE_ITEM_SHURIKEN:
	        if(GetHasFeat(FEAT_WEAPON_PROFICIENCY_EXOTIC, oPC)
	           || GetHasFeat(FEAT_WEAPON_PROFICIENCY_MONK, oPC))
	          bProficient = TRUE; break;
	    
	    case BASE_ITEM_SICKLE:
	        if(GetHasFeat(FEAT_WEAPON_PROFICIENCY_SIMPLE, oPC)
	           || GetHasFeat(FEAT_WEAPON_PROFICIENCY_DRUID, oPC))
	          bProficient = TRUE; break;
	    
	    case BASE_ITEM_SLING:
	        if(GetHasFeat(FEAT_WEAPON_PROFICIENCY_SIMPLE, oPC)
	           || GetHasFeat(FEAT_WEAPON_PROFICIENCY_ROGUE, oPC)
	           || GetHasFeat(FEAT_WEAPON_PROFICIENCY_MONK, oPC)
	           || GetHasFeat(FEAT_WEAPON_PROFICIENCY_DRUID, oPC))
	          bProficient = TRUE; break;
	    
	    case BASE_ITEM_THROWINGAXE:
	        if(GetHasFeat(FEAT_WEAPON_PROFICIENCY_MARTIAL, oPC)
	           || GetHasFeat(FEAT_MINDBLADE, oPC))
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
	           || GetHasFeat(FEAT_WEAPON_PROFICIENCY_DRUID, oPC))
	          bProficient = TRUE; break;
	    
	    //special case: counts as martial for dwarves
	    case BASE_ITEM_DWARVENWARAXE:
	        if(GetHasFeat(FEAT_WEAPON_PROFICIENCY_EXOTIC, oPC)
	           || (GetHasFeat(FEAT_WEAPON_PROFICIENCY_MARTIAL, oPC) && GetHasFeat(FEAT_DWARVEN, oPC)))
	          bProficient = TRUE; break;
	    
	    case BASE_ITEM_WHIP:
	        if(GetHasFeat(FEAT_WEAPON_PROFICIENCY_EXOTIC, oPC)
	           || GetHasFeat(FEAT_PYRO_FIRE_LASH, oPC))
	          bProficient = TRUE; break;
	    
	    case BASE_ITEM_ELF_LIGHTBLADE:
	        if(GetHasFeat(FEAT_WEAPON_PROFICIENCY_EXOTIC, oPC))
	          bProficient = TRUE; break;
	    
	    case BASE_ITEM_ELF_THINBLADE:
	        if(GetHasFeat(FEAT_WEAPON_PROFICIENCY_EXOTIC, oPC))
	          bProficient = TRUE; break;
	    
	    case BASE_ITEM_ELF_COURTBLADE:
	        if(GetHasFeat(FEAT_WEAPON_PROFICIENCY_EXOTIC, oPC))
	          bProficient = TRUE; break;
	          
	    case BASE_ITEM_DAGGER:
	    case BASE_ITEM_LIGHTCROSSBOW:
	    case BASE_ITEM_HEAVYCROSSBOW:
	    case BASE_ITEM_CLUB:
	    case BASE_ITEM_QUARTERSTAFF:
	         bProficient = TRUE; break;
	    	
	}
	
	if(!bProficient) SetCompositeAttackBonus(oPC, "Unproficient" + IntToString(nHand), -4, nHand);
}

void main()
{
    int nEvent = GetRunningEvent();
    if(DEBUG) DoDebug("prc_restwpnsize running, event: " + IntToString(nEvent));

    // Init the PC.
    object oPC;
    
    //needed to properly get creature size on the events
    switch(nEvent)
    {
        case EVENT_ONPLAYEREQUIPITEM:   oPC = GetItemLastEquippedBy();   break;
        case EVENT_ONPLAYERUNEQUIPITEM: oPC = GetItemLastUnequippedBy(); break;

        default:
            oPC = OBJECT_SELF;
    }
    
    object oItem;
    
    // We aren't being called from any event, instead from EvalPRCFeats
    if(nEvent == FALSE)
    {
        // Hook in the events
        if(DEBUG) DoDebug("prc_restwpnsize: Adding eventhooks");
        AddEventScript(oPC, EVENT_ONPLAYEREQUIPITEM,   "prc_restwpnsize", TRUE, FALSE);
        AddEventScript(oPC, EVENT_ONPLAYERUNEQUIPITEM, "prc_restwpnsize", TRUE, FALSE);
    }
    
    //initialize variables
    int nRealSize = PRCGetCreatureSize(oPC);  //size for Finesse/TWF
    int nSize = nRealSize;                    //size for equipment restrictions
    int nDexMod = GetAbilityModifier(ABILITY_DEXTERITY, oPC);
    int nStrMod = GetAbilityModifier(ABILITY_STRENGTH, oPC);
    int nUnfinesse = nDexMod - nStrMod;
    int nTHFDmgBonus = nStrMod / 2;
      
    //Powerful Build bonus
    if(GetHasFeat(FEAT_RACE_POWERFUL_BUILD, oPC))
        nSize++;

	
    else if(nEvent == EVENT_ONPLAYEREQUIPITEM)
    {
        oItem = GetItemLastEquipped();
        if(DEBUG) DoDebug("prc_restwpnsize - OnEquip");
        if(DEBUG) DoDebug("prc_restwpnsize - Weapon size: " + IntToString(GetWeaponSize(oItem)));
        if(DEBUG) DoDebug("prc_restwpnsize - Character Size: " + IntToString(nSize));
        
        if(oItem == GetItemInSlot(INVENTORY_SLOT_RIGHTHAND, oPC))
        {
        	//check to make sure it's not too large
        	if(GetWeaponSize(oItem) > 1 + nSize)
        	    // Force unequip
                    AssignCommand(oPC, ActionUnequipItem(oItem));
                    
                //check for proficiency
                DoProficiencyCheck(oPC, oItem, ATTACK_BONUS_ONHAND);
                    
                //simulate Weapon Finesse for Elven *blades    
                if((GetBaseItemType(oItem) == BASE_ITEM_ELF_LIGHTBLADE || GetBaseItemType(oItem) == BASE_ITEM_ELF_THINBLADE 
                        || GetBaseItemType(oItem) == BASE_ITEM_ELF_COURTBLADE) && GetHasFeat(FEAT_WEAPON_FINESSE, oPC) && nUnfinesse > 0)
                {
                    SetCompositeAttackBonus(oPC, "ElfFinesseRH", nUnfinesse, ATTACK_BONUS_ONHAND);
                }
                //Two-hand damage bonus
                if(GetWeaponSize(oItem) == nSize + 1 || (GetWeaponSize(oItem) == nRealSize + 1 && GetItemInSlot(INVENTORY_SLOT_LEFTHAND, oPC) == OBJECT_INVALID))
                {
                    if(DEBUG) DoDebug("Applying THF damage bonus");
                    SetCompositeDamageBonusT(oItem, "THFBonus", nTHFDmgBonus);
                }
                    
                //if a 2-hander, then unequip shield/offhand weapon
                if(GetWeaponSize(oItem) == 1 + nSize)
        	    // Force unequip
                    AssignCommand(oPC, ActionUnequipItem(GetItemInSlot(INVENTORY_SLOT_LEFTHAND, oPC)));
                  
                //Handle feat bonuses for Lightblade, thinblade, and courtblade
                if(GetBaseItemType(oItem) == BASE_ITEM_ELF_LIGHTBLADE)
                    DoEquipLightblade(oPC, oItem, ATTACK_BONUS_ONHAND);
                if(GetBaseItemType(oItem) == BASE_ITEM_ELF_THINBLADE)
                    DoEquipThinblade(oPC, oItem, ATTACK_BONUS_ONHAND);
                if(GetBaseItemType(oItem) == BASE_ITEM_ELF_COURTBLADE)
                    DoEquipCourtblade(oPC, oItem, ATTACK_BONUS_ONHAND);
        }
                
        if(oItem == GetItemInSlot(INVENTORY_SLOT_LEFTHAND, oPC) && !GetIsShield(oItem))
        {
        	//check to make sure it's not too large, or that mainhand weapon isn't a 2-hander
        	if(GetWeaponSize(oItem) > nSize || GetWeaponSize(GetItemInSlot(INVENTORY_SLOT_RIGHTHAND, oPC)) > nSize)
        	    // Force unequip
                    AssignCommand(oPC, ActionUnequipItem(oItem));
                    
                //check for proficiency
                DoProficiencyCheck(oPC, oItem, ATTACK_BONUS_OFFHAND);
                
                //Simulate Elven *blade finesse
                if((GetBaseItemType(oItem) == BASE_ITEM_ELF_LIGHTBLADE || GetBaseItemType(oItem) == BASE_ITEM_ELF_THINBLADE) 
                        && GetHasFeat(FEAT_WEAPON_FINESSE, oPC) && nUnfinesse > 0)
                {
                    SetCompositeAttackBonus(oPC, "ElfFinesseLH", nUnfinesse, ATTACK_BONUS_OFFHAND);
                }
                
                //apply TWF penalty if a one-handed, not light weapon - -4/-4 etc isntead of -2/-2
                if(GetWeaponSize(oItem) == nRealSize)
        	    // Assign penalty
                    SetCompositeAttackBonus(oPC, "OTWFPenalty", -2);
                    
                //Handle feat bonuses for Lightblade, thinblade, and courtblade
                if(GetBaseItemType(oItem) == BASE_ITEM_ELF_LIGHTBLADE)
                    DoEquipLightblade(oPC, oItem, ATTACK_BONUS_OFFHAND);
                if(GetBaseItemType(oItem) == BASE_ITEM_ELF_THINBLADE)
                    DoEquipThinblade(oPC, oItem, ATTACK_BONUS_OFFHAND);
                if(GetBaseItemType(oItem) == BASE_ITEM_ELF_COURTBLADE)
                    DoEquipCourtblade(oPC, oItem, ATTACK_BONUS_OFFHAND);
                                    
        }
    }
    
    else if(nEvent == EVENT_ONPLAYERUNEQUIPITEM)
    {
        oItem = GetItemLastUnequipped();
        if(DEBUG) DoDebug("prc_restwpnsize - OnUnEquip");
        
        // remove any TWF penalties
        //if weapon was a not light, and there's still something equipped in the main hand(meaning that an offhand item was de-equipped)
        if(GetWeaponSize(oItem) == nRealSize && GetItemInSlot(INVENTORY_SLOT_RIGHTHAND, oPC) != OBJECT_INVALID)
        {
            //remove any effects added
            SetCompositeAttackBonus(oPC, "OTWFPenalty", 0);
        }
        //remove any simulated finesse
        if(GetHasFeat(FEAT_WEAPON_FINESSE, oPC) && GetIsWeapon(oItem))
        {
            //if left hand unequipped, clear 
            //if right hand unequipped, left hand weapon goes to right hand, so should still be cleared
            SetCompositeAttackBonus(oPC, "ElfFinesseLH", 0, ATTACK_BONUS_OFFHAND);
            //if right hand weapon unequipped
            if(GetItemInSlot(INVENTORY_SLOT_RIGHTHAND, oPC) == oItem)
                SetCompositeAttackBonus(oPC, "ElfFinesseRH", 0, ATTACK_BONUS_ONHAND);
        }
            
        //remove any two-handed weapon bonus
        SetCompositeDamageBonusT(oItem, "THFBonus", 0);
        
        //clean elven thinblade-simulated bonuses
        DoElfbladeUnequip(oPC, oItem, ATTACK_BONUS_OFFHAND);
        if(GetItemInSlot(INVENTORY_SLOT_RIGHTHAND, oPC) == oItem)
                DoElfbladeUnequip(oPC, oItem, ATTACK_BONUS_ONHAND);
                
        //clean any nonproficient penalties
        SetCompositeAttackBonus(oPC, "Unproficient" + IntToString(ATTACK_BONUS_OFFHAND), 0, ATTACK_BONUS_OFFHAND);
        if(GetItemInSlot(INVENTORY_SLOT_RIGHTHAND, oPC) == oItem)
                SetCompositeAttackBonus(oPC, "Unproficient" + IntToString(ATTACK_BONUS_ONHAND), 0, ATTACK_BONUS_ONHAND);

    }
}