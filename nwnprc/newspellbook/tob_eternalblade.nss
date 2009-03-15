/*
   ----------------
   Eternal Blade class script

   tob_eternalblade.nss
   ----------------

    10 MAR 09 by GC
*/ /** @file

    This file handles the following:

    - Addition of maneuvers upon gaining levels in
*/



#include "tob_inc_moveknwn"
#include "tob_inc_recovery"
//#include "prc_craft_inc"

#include "prc_alterations"
#include "prc_feat_const"
#include "prc_class_const"
#include "prc_spell_const"

//const int IP_CONST_FEAT_UNCANNY_DODGE2 = 389;





void ApplyLore(object oInitiator)
{
	object oSkin = GetPCSkin(oInitiator);
	int nSkill = GetSkillRank(SKILL_LORE, oInitiator, TRUE);
	int nBonus = GetLevelByClass(CLASS_TYPE_ETERNAL_BLADE, oInitiator);// + GetAbilityModifier(ABILITY_INTELLIGENCE, oInitiator)); caster gets this bonus normaly
	    nBonus = (nBonus - nSkill >= 1) ? (nBonus - nSkill) : 0; // if blade guide won't help lore score, return

	if(GetLocalInt(oSkin, "EternalKnowledge") != nBonus && nBonus >= 1)
	SetCompositeBonus(oSkin, "EternalKnowledge", nBonus, ITEM_PROPERTY_SKILL_BONUS,SKILL_LORE);
	if(DEBUG) DoDebug("nBonus lore: " + IntToString(nBonus));
}

void RemoveLore(object oInitiator)
{
	object oSkin = GetPCSkin(oInitiator);
	SetCompositeBonus(oSkin, "EternalKnowledge", 0, ITEM_PROPERTY_SKILL_BONUS,SKILL_LORE);
}

void ApplyUncannyDodge(object oInitiator)
{
	object oSkin = GetPCSkin(oInitiator);
	itemproperty ipUD;
	if(GetHasFeat(FEAT_UNCANNY_DODGE_1, oInitiator))
	{
		// if they have uncanny dodge already, give them version 2
		ipUD = PRCItemPropertyBonusFeat(IP_CONST_FEAT_UNCANNY_DODGE2);
		if(DEBUG) DoDebug("Adding Uncanny Doddge 2");
	}
	else
	{
		if(DEBUG) DoDebug("Adding Uncanny Doddge 1");
		ipUD = PRCItemPropertyBonusFeat(IP_CONST_FEAT_UNCANNY_DODGE1);
	}
	IPSafeAddItemProperty(oSkin, ipUD, 99999.0, X2_IP_ADDPROP_POLICY_KEEP_EXISTING, FALSE, FALSE);
}

void RemoveUncannyDodge(object oInitiator)
{
	object oSkin = GetPCSkin(oInitiator);
	if(GetHasFeat(FEAT_UNCANNY_DODGE_1, oInitiator))
	{
		if(DEBUG) DoDebug("Removing Uncanny Doddge 2");
		RemoveSpecificProperty(oSkin, ITEM_PROPERTY_BONUS_FEAT, IP_CONST_FEAT_UNCANNY_DODGE2, -1, -1, "", -1, DURATION_TYPE_TEMPORARY);
	}
	else
	{
		if(DEBUG) DoDebug("Removing Uncanny Doddge 1");
		RemoveSpecificProperty(oSkin, ITEM_PROPERTY_BONUS_FEAT, IP_CONST_FEAT_UNCANNY_DODGE1, -1, -1, "", -1, DURATION_TYPE_TEMPORARY);
	}
}

void main()
{
	int nEvent = GetRunningEvent();
	if(DEBUG) DoDebug("tob_eternalblade running, event: " + IntToString(nEvent));

	// Get the PC. This is event-dependent
	object oInitiator = OBJECT_SELF;

	int nClass     = CLASS_TYPE_ETERNAL_BLADE;
	int nLevel     = GetLevelByClass(CLASS_TYPE_ETERNAL_BLADE, oInitiator);
	int nMoveTotal = GetKnownManeuversModifier(oInitiator, nClass, MANEUVER_TYPE_MANEUVER);
	int nStncTotal = GetKnownManeuversModifier(oInitiator, nClass, MANEUVER_TYPE_STANCE);
	int nRdyTotal  = GetReadiedManeuversModifier(oInitiator, nClass);

	// We aren't being called from any event, instead from EvalPRCFeats
	if(nEvent == FALSE)
	{

	// Hook in the events, needed for various abilities
	if(DEBUG) DoDebug("tob_eternalblade: Adding eventhooks");
	AddEventScript(oInitiator, EVENT_DAMAGED,     "tob_eternalblade", TRUE, FALSE);
        if(nLevel >=3)
        AddEventScript(oInitiator, EVENT_ONHEARTBEAT, "tob_eternalblade", TRUE, FALSE);

	// Allows gaining of maneuvers by prestige classes
	// It's not pretty, but it works
	if (nLevel >= 1 && !GetPersistantLocalInt(oInitiator, "ToBEternalBlade1"))
	{
		if(DEBUG) DoDebug("tob_eternalblade: Adding Maneuver 1");
		SetKnownManeuversModifier(oInitiator, GetFirstBladeMagicClass(oInitiator), ++nMoveTotal, MANEUVER_TYPE_MANEUVER);
		SetPersistantLocalInt(oInitiator, "ToBEternalBlade1", TRUE);
		SetPersistantLocalInt(oInitiator, "RestrictedDiscipline1", DISCIPLINE_DEVOTED_SPIRIT);
		SetPersistantLocalInt(oInitiator, "RestrictedDiscipline2", DISCIPLINE_DIAMOND_MIND);
		SetPersistantLocalInt(oInitiator, "RestrictedDiscipline3", DISCIPLINE_IRON_HEART);
		SetPersistantLocalInt(oInitiator, "RestrictedDiscipline4", DISCIPLINE_WHITE_RAVEN);
	}

	if (nLevel >= 3 &&!GetPersistantLocalInt(oInitiator, "ToBEternalBlade3"))
	{
		if(DEBUG) DoDebug("tob_eternalblade: Adding Maneuver 3");
		SetReadiedManeuversModifier(oInitiator, GetFirstBladeMagicClass(oInitiator), ++nRdyTotal);
		SetKnownManeuversModifier(oInitiator, GetFirstBladeMagicClass(oInitiator), ++nMoveTotal, MANEUVER_TYPE_MANEUVER);
		SetPersistantLocalInt(oInitiator, "ToBEternalBlade3", TRUE);
		SetPersistantLocalInt(oInitiator, "RestrictedDiscipline1", DISCIPLINE_DEVOTED_SPIRIT);
		SetPersistantLocalInt(oInitiator, "RestrictedDiscipline2", DISCIPLINE_DIAMOND_MIND);
		SetPersistantLocalInt(oInitiator, "RestrictedDiscipline3", DISCIPLINE_IRON_HEART);
		SetPersistantLocalInt(oInitiator, "RestrictedDiscipline4", DISCIPLINE_WHITE_RAVEN);
	}

	if (nLevel >= 5 && !GetPersistantLocalInt(oInitiator, "ToBEternalBlade5"))
	{
		if(DEBUG) DoDebug("tob_eternalblade: Adding Maneuver 5");
		SetKnownManeuversModifier(oInitiator, GetFirstBladeMagicClass(oInitiator), ++nStncTotal, MANEUVER_TYPE_STANCE);
		SetKnownManeuversModifier(oInitiator, GetFirstBladeMagicClass(oInitiator), ++nMoveTotal, MANEUVER_TYPE_MANEUVER);
		SetPersistantLocalInt(oInitiator, "ToBEternalBlade5", TRUE);
		SetPersistantLocalInt(oInitiator, "RestrictedDiscipline1", DISCIPLINE_DEVOTED_SPIRIT);
		SetPersistantLocalInt(oInitiator, "RestrictedDiscipline2", DISCIPLINE_DIAMOND_MIND);
		SetPersistantLocalInt(oInitiator, "RestrictedDiscipline3", DISCIPLINE_IRON_HEART);
		SetPersistantLocalInt(oInitiator, "RestrictedDiscipline4", DISCIPLINE_WHITE_RAVEN);
	}

	if (nLevel >= 6 && !GetPersistantLocalInt(oInitiator, "ToBEternalBlade6"))
	{
		if(DEBUG) DoDebug("tob_eternalblade: Adding Maneuver 6");
		SetReadiedManeuversModifier(oInitiator, GetFirstBladeMagicClass(oInitiator), ++nRdyTotal);
		SetPersistantLocalInt(oInitiator, "ToBEternalBlade6", TRUE);
	}

	if (nLevel >= 7 && !GetPersistantLocalInt(oInitiator, "ToBEternalBlade7"))
	{
		if(DEBUG) DoDebug("tob_eternalblade: Adding Maneuver 7");
		SetKnownManeuversModifier(oInitiator, GetFirstBladeMagicClass(oInitiator), ++nMoveTotal, MANEUVER_TYPE_MANEUVER);
		SetPersistantLocalInt(oInitiator, "ToBEternalBlade7", TRUE);
		SetPersistantLocalInt(oInitiator, "RestrictedDiscipline1", DISCIPLINE_DEVOTED_SPIRIT);
		SetPersistantLocalInt(oInitiator, "RestrictedDiscipline2", DISCIPLINE_DIAMOND_MIND);
		SetPersistantLocalInt(oInitiator, "RestrictedDiscipline3", DISCIPLINE_IRON_HEART);
		SetPersistantLocalInt(oInitiator, "RestrictedDiscipline4", DISCIPLINE_WHITE_RAVEN);
	}

	if (nLevel >= 9 && !GetPersistantLocalInt(oInitiator, "ToBEternalBlade9"))
	{
		if(DEBUG) DoDebug("tob_eternalblade: Adding Maneuver 9");
		SetReadiedManeuversModifier(oInitiator, GetFirstBladeMagicClass(oInitiator), ++nRdyTotal);
		SetKnownManeuversModifier(oInitiator, GetFirstBladeMagicClass(oInitiator), ++nMoveTotal, MANEUVER_TYPE_MANEUVER);
		SetPersistantLocalInt(oInitiator, "ToBEternalBlade9", TRUE);
		SetPersistantLocalInt(oInitiator, "RestrictedDiscipline1", DISCIPLINE_DEVOTED_SPIRIT);
		SetPersistantLocalInt(oInitiator, "RestrictedDiscipline2", DISCIPLINE_DIAMOND_MIND);
		SetPersistantLocalInt(oInitiator, "RestrictedDiscipline3", DISCIPLINE_IRON_HEART);
		SetPersistantLocalInt(oInitiator, "RestrictedDiscipline4", DISCIPLINE_WHITE_RAVEN);
	}

	// Hook to OnLevelDown to remove the maneuver slots granted here
	AddEventScript(oInitiator, EVENT_ONPLAYERLEVELDOWN, "tob_eternalblade", TRUE, FALSE);
	}
	else if(nEvent == EVENT_ONPLAYERLEVELDOWN)
	{
	// Has lost Maneuver, but the slot is still present
	if(GetPersistantLocalInt(oInitiator, "ToBEternalBlade1") && nLevel < 1)
	{
		DeletePersistantLocalInt(oInitiator, "ToBEternalBlade1");
		SetKnownManeuversModifier(oInitiator, GetFirstBladeMagicClass(oInitiator), --nMoveTotal, MANEUVER_TYPE_MANEUVER);
	}
	// Has lost Maneuver, but the slot is still present
	if(GetPersistantLocalInt(oInitiator, "ToBEternalBlade3") && nLevel < 3)
	{
		DeletePersistantLocalInt(oInitiator, "ToBEternalBlade3");
		SetReadiedManeuversModifier(oInitiator, GetFirstBladeMagicClass(oInitiator), --nRdyTotal);
		SetKnownManeuversModifier(oInitiator, GetFirstBladeMagicClass(oInitiator), --nMoveTotal, MANEUVER_TYPE_MANEUVER);
	}
	// Has lost Maneuver, but the slot is still present
	if(GetPersistantLocalInt(oInitiator, "ToBEternalBlade5") && nLevel < 5)
	{
		DeletePersistantLocalInt(oInitiator, "ToBEternalBlade5");
		SetKnownManeuversModifier(oInitiator, GetFirstBladeMagicClass(oInitiator), --nStncTotal, MANEUVER_TYPE_STANCE);
		SetKnownManeuversModifier(oInitiator, GetFirstBladeMagicClass(oInitiator), --nMoveTotal, MANEUVER_TYPE_MANEUVER);
	}
	// Has lost Maneuver, but the slot is still present
	if(GetPersistantLocalInt(oInitiator, "ToBEternalBlade6") && nLevel < 6)
	{
		DeletePersistantLocalInt(oInitiator, "ToBEternalBlade6");
		SetReadiedManeuversModifier(oInitiator, GetFirstBladeMagicClass(oInitiator), --nRdyTotal);
	}
	// Has lost Maneuver, but the slot is still present
	if(GetPersistantLocalInt(oInitiator, "ToBEternalBlade7") && nLevel < 7)
	{
		DeletePersistantLocalInt(oInitiator, "ToBEternalBlade7");
		SetKnownManeuversModifier(oInitiator, GetFirstBladeMagicClass(oInitiator), --nMoveTotal, MANEUVER_TYPE_MANEUVER);
	}
	// Has lost Maneuver, but the slot is still present
	if(GetPersistantLocalInt(oInitiator, "ToBEternalBlade9") && nLevel < 9)
	{
		DeletePersistantLocalInt(oInitiator, "ToBEternalBlade9");
		SetKnownManeuversModifier(oInitiator, GetFirstBladeMagicClass(oInitiator), --nMoveTotal, MANEUVER_TYPE_MANEUVER);
		SetReadiedManeuversModifier(oInitiator, GetFirstBladeMagicClass(oInitiator), --nRdyTotal);
	}

	// Remove eventhook if the character no longer has levels in Jade Phoenix
	if(nLevel == 0)
		RemoveEventScript(oInitiator, EVENT_ONPLAYERLEVELDOWN, "tob_eternalblade", TRUE, FALSE);
	if(nLevel <= 2)
		RemoveEventScript(oInitiator, EVENT_ONHEARTBEAT, "tob_eternalblade", TRUE, FALSE);
	}
	else if(nEvent == EVENT_DAMAGED)
	{
		//://////////////////////////////////////
		//: Blade Guide death/resurrection
		/*
		    Adds/removed passive boni from the
		    Eternal Blade's blade guide presence

		    The way granting abilities is handled,
		    this can be run through EVENT_DAMAGED alone
		*/
		//://////////////////////////////////////
		if(DEBUG) DoDebug("etbl EVENT_DAMAGED: running");
		object oAttacker = GetLastDamager();
		int nDamageTaken = GetTotalDamageDealt();
		int nHitPoints   = GetMaxHitPoints(oInitiator);

		// since player can have armor, dr, various immunities, etc., apply reasonable damage multiplyer for blage guide
		// nDamageTaken = mod * nDamageTaken;

		// Blade guide alive, but no HP int.
		// This would be the first hit after he respawns or the player rests or after load
		if(!GetLocalInt(oInitiator, "ETBL_BladeGuideDead") && !GetLocalInt(oInitiator, "ETBL_BladeGuideHP"))
		{
			SetLocalInt(oInitiator, "ETBL_BladeGuideHP", nHitPoints);
		}

		// Damage taken and blade guide alive
		if(nDamageTaken > 0 && !GetLocalInt(oInitiator, "ETBL_BladeGuideDead"))
		{
			int nCurrent = GetLocalInt(oInitiator, "ETBL_BladeGuideHP");

			// blade guide is killed
			if(nCurrent - nDamageTaken <= 0)
			{
				effect eGuide  = EffectVisualEffect(VFX_DUR_IOUNSTONE_BLUE);

				// mark blade guide dead and remove stored HP
				// checked for class abilities
				SetLocalInt(oInitiator, "ETBL_BladeGuideDead", TRUE);
				DeleteLocalInt(oInitiator, "ETBL_BladeGuideHP");

				// let the player know he died :(
				FloatingTextStringOnCreature("*Blade Guide destroyed*", oInitiator, FALSE);

				// remove blade guide vfx
				RemoveEffect(oInitiator, eGuide);

				// remove bonuses blade guide provides
				RemoveLore(oInitiator);
				RemoveUncannyDodge(oInitiator);

				// blade guide comes back in 1d6 rounds, yay!
				// remove dead marker, let player know he's back, reapply visual
				float fDur     = RoundsToSeconds(d6(1));

				DelayCommand(fDur, DeleteLocalInt(oInitiator, "ETBL_BladeGuideDead"));
				DelayCommand(fDur, FloatingTextStringOnCreature("*Blade Guide returned*", oInitiator, FALSE));
				DelayCommand(fDur, SPApplyEffectToObject(DURATION_TYPE_PERMANENT, eGuide, oInitiator));
			}
			else
				SetLocalInt(oInitiator, "ETBL_BladeGuideHP", (nCurrent - nDamageTaken));
			if(DEBUG) DoDebug("blade guide hp: "+ IntToString((nCurrent - nDamageTaken)));
		}
		// if blade guide is dead at the moment, do nothing
	}
	else if(nEvent == EVENT_ONHEARTBEAT)
	{
		if(DEBUG) DoDebug("ETBL OnHeartbeat running");
		// If the blade guide is alive, add passsive abilities
		if(!GetLocalInt(oInitiator, "ETBL_BladeGuideDead"))
		{
			if(nLevel >= 3) ApplyUncannyDodge(oInitiator);
			if(nLevel >= 4) ApplyLore(oInitiator);
		}
		else
		{// Else remove them
			RemoveUncannyDodge(oInitiator);
			RemoveLore(oInitiator);
		}
	}
}