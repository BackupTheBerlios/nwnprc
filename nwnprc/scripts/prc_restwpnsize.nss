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
                    SetCompositeDamageBonusT(oItem, "THFBonus", nTHFDmgBonus, IP_CONST_DAMAGETYPE_PHYSICAL);
                }
                    
                //if a 2-hander, then unequip shield/offhand weapon
                if(GetWeaponSize(oItem) == 1 + nSize)
        	    // Force unequip
                    AssignCommand(oPC, ActionUnequipItem(GetItemInSlot(INVENTORY_SLOT_LEFTHAND, oPC)));
        }
                
        if(oItem == GetItemInSlot(INVENTORY_SLOT_LEFTHAND, oPC) && !GetIsShield(oItem))
        {
        	//check to make sure it's not too large, or that mainhand weapon isn't a 2-hander
        	if(GetWeaponSize(oItem) > nSize || GetWeaponSize(GetItemInSlot(INVENTORY_SLOT_RIGHTHAND, oPC)) > nSize)
        	    // Force unequip
                    AssignCommand(oPC, ActionUnequipItem(oItem));
                    
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
            
        SetCompositeDamageBonusT(oItem, "THFBonus", 0, IP_CONST_DAMAGETYPE_PHYSICAL);

    }
}