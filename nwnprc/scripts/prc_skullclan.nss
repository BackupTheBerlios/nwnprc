//::///////////////////////////////////////////////
//:: Skullclan Hunter
//:: prc_skullclan.nss
//:://////////////////////////////////////////////
//:: Check to see which Skullclan Hunter feats a creature
//:: has and apply the appropriate bonuses.
//:://////////////////////////////////////////////
//:: Created By: Stratovarius.  
//:: Created On: July 12, 2006
//:://////////////////////////////////////////////

// To-Do: Use +20 / -20 Item prop vs undead on weapon

#include "prc_alterations"

// * Applies the Skullclan Hunters's immunities on the object's skin.
// * iType = IP_CONST_IMMUNITYMISC_*
// * sFlag = Flag to check whether the property has already been added
void SkullClanImmunity(object oPC, object oSkin, int iType, string sFlag)
{
    if(GetLocalInt(oSkin, sFlag) == TRUE) return;

    AddItemProperty(DURATION_TYPE_PERMANENT, ItemPropertyImmunityMisc(iType), oSkin);
    SetLocalInt(oSkin, sFlag, TRUE);
}

void SkullClanAbilityDrain(object oPC, object oSkin, string sFlag)
{
	if(GetLocalInt(oSkin, sFlag) == TRUE) return;
	
	effect eAbil = EffectImmunity(IMMUNITY_TYPE_ABILITY_DECREASE);
	eAbil = SupernaturalEffect(eAbil);
	ApplyEffectToObject(DURATION_TYPE_PERMANENT, eAbil, oPC);
	SetLocalInt(oSkin, sFlag, TRUE);	
}	

void SkullClanProtectionEvil(object oPC, object oSkin, string sFlag)
{
	if(GetLocalInt(oSkin, sFlag) == TRUE) return;

	effect eAC = VersusAlignmentEffect(EffectACIncrease(2, AC_DEFLECTION_BONUS), ALIGNMENT_ALL, ALIGNMENT_EVIL);
	effect eSave = VersusAlignmentEffect(EffectSavingThrowIncrease(SAVING_THROW_ALL, 2), ALIGNMENT_ALL, ALIGNMENT_EVIL);
	effect eImmune = VersusAlignmentEffect(EffectImmunity(IMMUNITY_TYPE_MIND_SPELLS), ALIGNMENT_ALL, ALIGNMENT_EVIL);

	effect eLink = EffectLinkEffects(eImmune, eSave);
	eLink = EffectLinkEffects(eLink, eAC);
	eLink = SupernaturalEffect(eLink);
	ApplyEffectToObject(DURATION_TYPE_PERMANENT, eLink, oPC);
	SetLocalInt(oSkin, sFlag, TRUE);	
}

// This is supposed to pierce all DR on undead only
void SkullClanSwordLight(object oPC, object oSkin, string sFlag)
{
	if(GetLocalInt(oSkin, sFlag) == TRUE) return;
	
	object oItem = GetItemInSlot(INVENTORY_SLOT_RIGHTHAND, oPC);
	// Because there is no negative item property for attack vs race, we need to use a permanent effect.
	IPSafeAddItemProperty(oItem, ItemPropertyAttackBonusVsRace(RACIAL_TYPE_UNDEAD, 20), 99999.0, X2_IP_ADDPROP_POLICY_KEEP_EXISTING, FALSE, FALSE);
	effect eAB = VersusRacialTypeEffect(EffectAttackDecrease(20), RACIAL_TYPE_UNDEAD);
	eAB = SupernaturalEffect(eAB);
	ApplyEffectToObject(DURATION_TYPE_PERMANENT, eAB, oPC);	
	SetLocalInt(oSkin, sFlag, TRUE);	
}

void main()
{
    //Declare main variables.
    object oPC = OBJECT_SELF;
    object oSkin = GetPCSkin(oPC);
    object oItem, oAmmo;
    int nClass = GetLevelByClass(CLASS_TYPE_SKULLCLAN_HUNTER, oPC);
    int nEvent = GetRunningEvent();
    
    if(DEBUG) DoDebug("prc_skullclan running, event: " + IntToString(nEvent));

    //Apply bonuses accordingly
    if(nClass >= 3) SkullClanImmunity(oPC, oSkin, IP_CONST_IMMUNITYMISC_FEAR, "SkullClanFear");
    if(nClass >= 4) SkullClanImmunity(oPC, oSkin, IP_CONST_IMMUNITYMISC_DISEASE,  "SkullClanDisease");
    if(nClass >= 4) SkullClanProtectionEvil(oPC, oSkin, "SkullClanProtectionEvil");
    if(nClass >= 5) SkullClanSwordLight(oPC, oSkin, "SkullClanSwordLight");
    if(nClass >= 7) SkullClanImmunity(oPC, oSkin, IP_CONST_IMMUNITYMISC_PARALYSIS,  "SkullClanParalysis");
    if(nClass >= 8 && nClass < 10) SkullClanAbilityDrain(oPC, oSkin, "SkullClanAbilityDrain");
    //if(nClass >= 8) SkullClanImmunity(oPC, oSkin, IP_CONST_IMMUNITYMISC_LEVEL_ABIL_DRAIN,  "SkullClanAbilityDrain");
    //Bioware doesn't have ability and level drain seperately. Damn them.
    if(nClass >= 10) SkullClanImmunity(oPC, oSkin, IP_CONST_IMMUNITYMISC_LEVEL_ABIL_DRAIN, "SkullClanLevelDrain");  
    
    // We aren't being called from any event, instead from EvalPRCFeats, so set up the eventhooks
    // Don't start doing this until the Skullclan Hunter is level 2
    if(nEvent == FALSE && nClass >= 2)
    {
        oPC = OBJECT_SELF;
        if(DEBUG) DoDebug("prc_skullclan: Adding eventhooks");

        AddEventScript(oPC, EVENT_ONPLAYEREQUIPITEM,   "prc_skullclan", TRUE, FALSE);
        AddEventScript(oPC, EVENT_ONPLAYERUNEQUIPITEM, "prc_skullclan", TRUE, FALSE);
    }
    // We're being called from the OnHit eventhook, so deal the damage
    else if(nEvent == EVENT_ITEM_ONHIT)
    {
        oItem          = GetSpellCastItem();
        object oTarget = PRCGetSpellTargetObject();
        if(DEBUG) DoDebug("prc_skullclan: OnHit:\n"
                        + "oPC = " + DebugObject2Str(oPC) + "\n"
                        + "oItem = " + DebugObject2Str(oItem) + "\n"
                        + "oTarget = " + DebugObject2Str(oTarget) + "\n"
                          );

        // Only applies to weapons
        if(IPGetIsMeleeWeapon(oItem) || GetWeaponRanged(oItem))
        {
        	// Has to be able to sneak attack
        	// The target must be undead as well
        	if (MyPRCGetRacialType(oTarget) == RACIAL_TYPE_UNDEAD && GetCanSneakAttack(oTarget, oPC))
        	{
        		// Get the total damage it can do
        		int nDam = GetSneakAttackDamage(GetTotalSneakAttackDice(oPC));
        		effect eDam = EffectDamage(nDam, DAMAGE_TYPE_POSITIVE);
        		ApplyEffectToObject(DURATION_TYPE_INSTANT, eDam, oTarget);
        	}
        }// end if - Item is a melee weapon and Two-Weapon Rend hasn't already been used up for the round
    }// end if - Running OnHit event        
    // We are called from the OnPlayerEquipItem eventhook. Add OnHitCast: Unique Power to oPC's weapon
    else if(nEvent == EVENT_ONPLAYEREQUIPITEM)
    {
        oPC   = GetItemLastEquippedBy();
        oItem = GetItemLastEquipped();
        if(DEBUG) DoDebug("prc_skullclan - OnEquip");

        // Only applies to weapons
        if(IPGetIsMeleeWeapon(oItem) || GetWeaponRanged(oItem))
        {
            // Add eventhook to the item
            AddEventScript(oItem, EVENT_ITEM_ONHIT, "prc_skullclan", TRUE, FALSE);

            // Add the OnHitCastSpell: Unique needed to trigger the event
            // Makes sure to get ammo if its a ranged weapon
            IPSafeAddItemProperty(oItem, ItemPropertyOnHitCastSpell(IP_CONST_ONHIT_CASTSPELL_ONHIT_UNIQUEPOWER, 1), 99999.0, X2_IP_ADDPROP_POLICY_KEEP_EXISTING, FALSE, FALSE);
            
            oAmmo = GetItemInSlot(INVENTORY_SLOT_BOLTS, oPC);
            IPSafeAddItemProperty(oItem, ItemPropertyOnHitCastSpell(IP_CONST_ONHIT_CASTSPELL_ONHIT_UNIQUEPOWER, 1), 99999.0, X2_IP_ADDPROP_POLICY_KEEP_EXISTING, FALSE, FALSE);

            oAmmo = GetItemInSlot(INVENTORY_SLOT_BULLETS, oPC);
            IPSafeAddItemProperty(oItem, ItemPropertyOnHitCastSpell(IP_CONST_ONHIT_CASTSPELL_ONHIT_UNIQUEPOWER, 1), 99999.0, X2_IP_ADDPROP_POLICY_KEEP_EXISTING, FALSE, FALSE);

            oAmmo = GetItemInSlot(INVENTORY_SLOT_ARROWS, oPC);            
            IPSafeAddItemProperty(oItem, ItemPropertyOnHitCastSpell(IP_CONST_ONHIT_CASTSPELL_ONHIT_UNIQUEPOWER, 1), 99999.0, X2_IP_ADDPROP_POLICY_KEEP_EXISTING, FALSE, FALSE);
        }
    }
    // We are called from the OnPlayerUnEquipItem eventhook. Remove OnHitCast: Unique Power from oPC's weapon
    else if(nEvent == EVENT_ONPLAYERUNEQUIPITEM)
    {
        oPC   = GetItemLastUnequippedBy();
        oItem = GetItemLastUnequipped();
        if(DEBUG) DoDebug("prc_skullclan - OnUnEquip");

        // Only applies to weapons
        if(IPGetIsMeleeWeapon(oItem) || GetWeaponRanged(oItem))
        {
            // Add eventhook to the item
            RemoveEventScript(oItem, EVENT_ITEM_ONHIT, "prc_skullclan", TRUE, FALSE);

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
}
