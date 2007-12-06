//::///////////////////////////////////////////////
//:: Dragonfire Strike
//:: prc_dragfire_atk.nss
//::///////////////////////////////////////////////
/*
    Handles converting the damage on Dragonfire Strike 
    and similar feats
*/
//:://////////////////////////////////////////////
//:: Created By: Fox
//:: Created On: Nov 23, 2007
//:://////////////////////////////////////////////

#include "prc_alterations"
#include "prc_inc_sneak"

struct DamReduction
{
	int nRedLevel;
	int nRedAmount;
};

struct DamageReducers
{
	int nStaticReductions;
	int nPercentReductions;
};

int GetIsShield(object oItem)
{
    int bReturn = FALSE;
    switch(GetBaseItemType(oItem))
    {
        case BASE_ITEM_LARGESHIELD:
        case BASE_ITEM_SMALLSHIELD:
        case BASE_ITEM_TOWERSHIELD:
        {
            bReturn = TRUE;
        }
        break;
    }
    return bReturn;
}

struct DamageReducers GetTotalReduction(object oPC, object oTarget, object oWeapon)
{
	int nDamageType = GetWeaponDamageType(oWeapon);
	//Note: DamageType is a bitwise number. 1 is B, 2 is P, 4 is S.
	//if(DEBUG) DoDebug("Damage Type: " + IntToString(nDamageType));
	int nAttackBonus = GetMonkEnhancement(oWeapon, oTarget, oPC);
	
	//handling for ammo
	if(oWeapon == GetItemInSlot(INVENTORY_SLOT_BOLTS, oPC)
	   || oWeapon == GetItemInSlot(INVENTORY_SLOT_BULLETS, oPC)
	   || oWeapon == GetItemInSlot(INVENTORY_SLOT_ARROWS, oPC))
	      nAttackBonus = GetWeaponAttackBonusItemProperty(GetItemInSlot(INVENTORY_SLOT_RIGHTHAND, oPC), oTarget);
	
	if(DEBUG) DoDebug("Weapon Atk Bonus: " + IntToString(nAttackBonus));
	
	struct DamReduction nBestDamageReduction;
	int nBestDamageResistance = 0;
	int nApplicableReduction;
	int nBestImmunutyLevel;
	struct DamReduction nCurrentReduction;
	nCurrentReduction.nRedLevel = DAMAGE_POWER_NORMAL;
	nCurrentReduction.nRedAmount = 0;
	nBestDamageReduction = nCurrentReduction;
	
	if(nAttackBonus < 1) nApplicableReduction = DAMAGE_POWER_NORMAL;
	else nApplicableReduction = IPGetDamageBonusConstantFromNumber(nAttackBonus);
	
	
	//loop through spell/power effects first
	effect eLoop=GetFirstEffect(oTarget);

	while (GetIsEffectValid(eLoop))
   	{
   		int nSpellID = GetEffectSpellId(eLoop);
   		
   		//Stoneskin
   		if( nSpellID == 172
   		   || nSpellID == 342
   		   || nSpellID == SPELL_FOM_DIVINE_SONG_STONESKIN
   		   || nSpellID == SPELL_URDINNIR_STONESKIN)
   		{
   		     nCurrentReduction.nRedLevel = DAMAGE_POWER_PLUS_FIVE;
   		     nCurrentReduction.nRedAmount = 10;    
   		}
   		//GreaterStoneskin
   		if( nSpellID == 74)
   		{
   		     nCurrentReduction.nRedLevel = DAMAGE_POWER_PLUS_FIVE;
   		     nCurrentReduction.nRedAmount = 20;
   		}
   		//Premonition
   		if( nSpellID == 134)
   		{
   		     nCurrentReduction.nRedLevel = DAMAGE_POWER_PLUS_FIVE;
   		     nCurrentReduction.nRedAmount = 30;
   		}
   		//Ghostly Visage
   		if( nSpellID == 351
   		   || nSpellID == 605
   		   || nSpellID == 120)
   		{
   		     nCurrentReduction.nRedLevel = DAMAGE_POWER_PLUS_ONE;
   		     nCurrentReduction.nRedAmount = 5;
   		}
   		//Ethereal Visage
   		if( nSpellID == 121)
   		{
   		     nCurrentReduction.nRedLevel = DAMAGE_POWER_PLUS_THREE;
   		     nCurrentReduction.nRedAmount = 20;
   		}
   		//Shadow Shield and Shadow Evade(best case)
   		if( nSpellID == 160
   		   || nSpellID == 477
   		   || nSpellID == SPELL_SHADOWSHIELD)
   		{
   		     nCurrentReduction.nRedLevel = DAMAGE_POWER_PLUS_THREE;
   		     nCurrentReduction.nRedAmount = 10;
   		}
   		//Iron Body
   		if( nSpellID == POWER_IRONBODY)
   		{
   		     nCurrentReduction.nRedLevel = DAMAGE_POWER_PLUS_FIVE;
   		     nCurrentReduction.nRedAmount = 15;
   		}
   		//Oak Body
   		if( nSpellID == POWER_OAKBODY && nDamageType == DAMAGE_TYPE_SLASHING)
   		{
   		     nBestDamageResistance = 10;
   		}
   		//Shadow Body
   		if( nSpellID == POWER_SHADOWBODY)
   		{
   		     nCurrentReduction.nRedLevel = DAMAGE_POWER_PLUS_ONE;
   		     nCurrentReduction.nRedAmount = 10;
   		}
   		
   		//if it applies and prevents more damage, replace
   		if(nCurrentReduction.nRedLevel > nApplicableReduction
   		   && nCurrentReduction.nRedAmount > nBestDamageReduction.nRedAmount)
   		       nBestDamageReduction = nCurrentReduction;
   		   
		        
   		eLoop=GetNextEffect(oTarget);
   	}
   	
   	//now loop through items
   	int nSlot;
   	object oItem;
   	itemproperty ipResist = ItemPropertyDamageResistance(nDamageType, IP_CONST_DAMAGERESIST_5);
   	int nSubType;

        for (nSlot=0; nSlot<NUM_INVENTORY_SLOTS; nSlot++)
        {
           oItem=GetItemInSlot(nSlot, oTarget);
           
           //check props if valid
           if(GetIsObjectValid(oItem))
           {
               /*if(GetItemHasItemProperty(oItem, ITEM_PROPERTY_DAMAGE_RESISTANCE) 
                  || GetItemHasItemProperty(oItem, ITEM_PROPERTY_DAMAGE_REDUCTION))
               {*/
           	      itemproperty ipLoop=GetFirstItemProperty(oItem);

                      //Loop for as long as the ipLoop variable is valid
                      while (GetIsItemPropertyValid(ipLoop))
                      {
                      	    //if(DEBUG) DoDebug("Item: " + GetName(oItem));
                      	    //if(DEBUG) DoDebug("Item Property: " + IntToString(GetItemPropertyType(ipLoop)));
                      	    //if(DEBUG) DoDebug("Item Property Subtype: " + IntToString(GetItemPropertySubType(ipLoop)));
                      	    if(GetItemPropertyType(ipLoop) == ITEM_PROPERTY_DAMAGE_RESISTANCE)
                      	    {   
                      	        nSubType = GetItemPropertySubType(ipLoop);
                      	        //convert IP Const numbers to the appropriate bitmask
                      	        if(nSubType == 0) nSubType = 1;
                      	        if(nSubType == 1) nSubType = 2;
                      	        if(nSubType == 2) nSubType = 4;
                      	        //See if Damage type is in the weapon's damage type bitmask
                      	        if((nSubType & nDamageType) == nSubType)
                                {
                                   int nResist = 5 * GetItemPropertyCostTableValue(ipLoop);
                            
                                   if(nResist > nBestDamageResistance) nBestDamageResistance = nResist;
                                }
                            }
                            
                            if(GetItemPropertyType(ipLoop) == ITEM_PROPERTY_DAMAGE_REDUCTION
                      	       && GetItemPropertySubType(ipLoop) > nApplicableReduction)
                            {
                            	int nReduce = GetItemPropertyCostTableValue(ipLoop) * 5;
                            	if (nReduce > nBestDamageReduction.nRedAmount)
                            	     nBestDamageReduction.nRedAmount = nReduce;
                            }
                            
                            if(GetItemPropertyType(ipLoop) == ITEM_PROPERTY_IMMUNITY_DAMAGE_TYPE)
                      	    {   
                      	        nSubType = GetItemPropertySubType(ipLoop);
                      	        if(nSubType == 0) nSubType = 1;
                      	        if(nSubType == 1) nSubType = 2;
                      	        if(nSubType == 2) nSubType = 4;
                      	        if((nSubType & nDamageType) == nSubType)
                                {
                            	    int nImmune = 0;
                                    if(GetItemPropertyCostTableValue(ipLoop) == 1)
                            	        nImmune = 5;
                            	    else if(GetItemPropertyCostTableValue(ipLoop) == 2)
                            	        nImmune = 10;
                              	    else if(GetItemPropertyCostTableValue(ipLoop) == 3)
                            	        nImmune = 25;
                            	    else if(GetItemPropertyCostTableValue(ipLoop) == 4)
                            	        nImmune = 50;
                            	    else if(GetItemPropertyCostTableValue(ipLoop) == 5)
                            	        nImmune = 75;
                            	    else if(GetItemPropertyCostTableValue(ipLoop) == 6)
                            	        nImmune = 90;
                            	    else if(GetItemPropertyCostTableValue(ipLoop) == 7)
                            	        nImmune = 100;

                                    if(nImmune > nBestImmunutyLevel) nBestImmunutyLevel = nImmune;
                                }
                            }

                            //Next itemproperty on the list...
                            ipLoop=GetNextItemProperty(oItem);
                      }

           	//}//end item prop check 
             
           }//end validity check
        }//end for
        if(DEBUG) DoDebug("Best Resistance: " + IntToString(nBestDamageResistance));
        if(DEBUG) DoDebug("Best Reduction: " + IntToString(nBestDamageReduction.nRedAmount));
        if(DEBUG) DoDebug("Best Percent Immune: " + IntToString(nBestImmunutyLevel));
   	
   	struct DamageReducers drOverallReduced;
   	drOverallReduced.nStaticReductions = nBestDamageResistance + nBestDamageReduction.nRedAmount;
   	drOverallReduced.nPercentReductions = nBestImmunutyLevel;
   	
   	return drOverallReduced;
}
	


void DoDragonfireSneak(object oPC, object oTarget, object oWeapon)
{
	if(DEBUG) DoDebug("Performing Strike");
	int nType = GetDragonfireDamageType(oPC);
	int nDice = GetTotalSneakAttackDice(oPC);
	int nSneakDamage = GetSneakAttackDamage(nDice);
	int nDamage = nSneakDamage;
	
	struct DamageReducers drTotalReduced= GetTotalReduction(oPC, oTarget, oWeapon);
	nDamage = nDamage * (100 - drTotalReduced.nPercentReductions) / 100;
	nDamage -= drTotalReduced.nStaticReductions;
	if(nDamage < 0 ) nDamage = 0;
	effect eHealed = EffectHeal(nDamage);
	
	if(GetHasFeat(FEAT_IMP_DRAGONFIRE_STRIKE, oPC) && GetLocalInt(oPC, "DragonFireOn"))
            nSneakDamage += nDice;

        effect eSneakDamage = EffectDamage(nSneakDamage, nType);
        effect eStrike = EffectLinkEffects(eSneakDamage, eHealed);
        SPApplyEffectToObject(DURATION_TYPE_INSTANT, eStrike, oTarget);
        
}

void main()
{
    int nEvent = GetRunningEvent();
    if(DEBUG) DoDebug("prc_dragfire_atk running, event: " + IntToString(nEvent));

    // Get the PC. This is event-dependent
    object oPC;
    switch(nEvent)
    {
        case EVENT_ITEM_ONHIT:          oPC = OBJECT_SELF;               break;
        case EVENT_ONPLAYEREQUIPITEM:   oPC = GetItemLastEquippedBy();   break;
        case EVENT_ONPLAYERUNEQUIPITEM: oPC = GetItemLastUnequippedBy(); break;

        default:
            oPC = OBJECT_SELF;
    }

    object oItem;
    object oAmmo;
    
    // We aren't being called from any event, instead from EvalPRCFeats
    if(nEvent == FALSE)
    {
        // Hook in the events
        if(DEBUG) DoDebug("prc_dragfire_atk: Adding eventhooks");
        AddEventScript(oPC, EVENT_ONPLAYEREQUIPITEM,   "prc_dragfire_atk", TRUE, FALSE);
        AddEventScript(oPC, EVENT_ONPLAYERUNEQUIPITEM, "prc_dragfire_atk", TRUE, FALSE);
    }
	
    else if(nEvent == EVENT_ONPLAYEREQUIPITEM)
    {
        oPC   = GetItemLastEquippedBy();
        oItem = GetItemLastEquipped();
        if(DEBUG) DoDebug("prc_dragfire_atk - OnEquip");

        // Only applies to weapons - Note: IPGetIsMeleeWeapon is bugged and returns true on items it should not
        if(oItem == GetItemInSlot(INVENTORY_SLOT_RIGHTHAND, oPC) || 
           (oItem == GetItemInSlot(INVENTORY_SLOT_LEFTHAND, oPC) && !GetIsShield(oItem)) ||
           GetWeaponRanged(oItem))
        {
            // Add eventhook to the item
            AddEventScript(oItem, EVENT_ITEM_ONHIT, "prc_dragfire_atk", TRUE, FALSE);

            // Add the OnHitCastSpell: Unique needed to trigger the event
            // Makes sure to get ammo if its a ranged weapon
            IPSafeAddItemProperty(oItem, ItemPropertyOnHitCastSpell(IP_CONST_ONHIT_CASTSPELL_ONHIT_UNIQUEPOWER, 1), 99999.0, X2_IP_ADDPROP_POLICY_KEEP_EXISTING, FALSE, FALSE);

            oAmmo = GetItemInSlot(INVENTORY_SLOT_BOLTS, oPC);
            IPSafeAddItemProperty(oAmmo, ItemPropertyOnHitCastSpell(IP_CONST_ONHIT_CASTSPELL_ONHIT_UNIQUEPOWER, 1), 99999.0, X2_IP_ADDPROP_POLICY_KEEP_EXISTING, FALSE, FALSE);

            oAmmo = GetItemInSlot(INVENTORY_SLOT_BULLETS, oPC);
            IPSafeAddItemProperty(oAmmo, ItemPropertyOnHitCastSpell(IP_CONST_ONHIT_CASTSPELL_ONHIT_UNIQUEPOWER, 1), 99999.0, X2_IP_ADDPROP_POLICY_KEEP_EXISTING, FALSE, FALSE);

            oAmmo = GetItemInSlot(INVENTORY_SLOT_ARROWS, oPC);
            IPSafeAddItemProperty(oAmmo, ItemPropertyOnHitCastSpell(IP_CONST_ONHIT_CASTSPELL_ONHIT_UNIQUEPOWER, 1), 99999.0, X2_IP_ADDPROP_POLICY_KEEP_EXISTING, FALSE, FALSE);
        }
    }
    
    // We are called from the OnPlayerUnEquipItem eventhook. Remove OnHitCast: Unique Power from oPC's weapon
    else if(nEvent == EVENT_ONPLAYERUNEQUIPITEM)
    {
        oPC   = GetItemLastUnequippedBy();
        oItem = GetItemLastUnequipped();
        if(DEBUG) DoDebug("prc_dragfire_atk - OnUnEquip");

        // Only applies to weapons - Note: if statement still returns true for armor/shield? o.O
        if(IPGetIsMeleeWeapon(oItem) || GetWeaponRanged(oItem))
        {
            // Add eventhook to the item
            RemoveEventScript(oItem, EVENT_ITEM_ONHIT, "prc_dragfire_atk", TRUE, FALSE);

            // Remove the temporary OnHitCastSpell: Unique
            // Makes sure to get ammo if its a ranged weapon
            RemoveSpecificProperty(oItem, ITEM_PROPERTY_ONHITCASTSPELL, IP_CONST_ONHIT_CASTSPELL_ONHIT_UNIQUEPOWER, 0, 1, "", 1, DURATION_TYPE_TEMPORARY);

            oAmmo = GetItemInSlot(INVENTORY_SLOT_BOLTS, oPC);
            RemoveSpecificProperty(oAmmo, ITEM_PROPERTY_ONHITCASTSPELL, IP_CONST_ONHIT_CASTSPELL_ONHIT_UNIQUEPOWER, 0, 1, "", 1, DURATION_TYPE_TEMPORARY);

            oAmmo = GetItemInSlot(INVENTORY_SLOT_BULLETS, oPC);
            RemoveSpecificProperty(oAmmo, ITEM_PROPERTY_ONHITCASTSPELL, IP_CONST_ONHIT_CASTSPELL_ONHIT_UNIQUEPOWER, 0, 1, "", 1, DURATION_TYPE_TEMPORARY);

            oAmmo = GetItemInSlot(INVENTORY_SLOT_ARROWS, oPC);
            RemoveSpecificProperty(oAmmo, ITEM_PROPERTY_ONHITCASTSPELL, IP_CONST_ONHIT_CASTSPELL_ONHIT_UNIQUEPOWER, 0, 1, "", 1, DURATION_TYPE_TEMPORARY);
        }
    }
    else if(nEvent == EVENT_ITEM_ONHIT)
    {
        //get the thing hit
        object oTarget  = PRCGetSpellTargetObject();
        oItem           = GetSpellCastItem();
        
        if(!(IPGetIsMeleeWeapon(oItem) || GetWeaponRanged(oItem))) //Note: if statement still returns false for armor/shield? o.O
            return;
        
        if(DEBUG) DoDebug("Weapon Used: " + GetName(oItem));
        
        if(DEBUG) DoDebug("CanSneakAttack: " + IntToString(GetCanSneakAttack(oTarget, oPC)));
        if(DEBUG) DoDebug("Dice: " + IntToString(GetTotalSneakAttackDice(oPC)));
        //check to see if both Sneak Attack and DFS apply, and if so, strike
        if(GetCanSneakAttack(oTarget, oPC) 
          && (GetTotalSneakAttackDice(oPC) > 0)
          && GetLocalInt(oPC, "DragonFireOn"))
            DoDragonfireSneak(oPC, oTarget, oItem);
    }
        
}