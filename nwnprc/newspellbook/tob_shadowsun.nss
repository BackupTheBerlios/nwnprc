/*
   ----------------
   Shadow Sun Ninja class script

   tob_shadowsun.nss
   ----------------

    18 MAR 09 by GC
*/ /** @file
*/

#include "tob_inc_moveknwn"
#include "tob_inc_recovery"
#include "prc_alterations"

void main()
{

	object oInitiator = OBJECT_SELF;
	int nClass        = CLASS_TYPE_SHADOW_SUN_NINJA;
	int nLevel        = GetLevelByClass(nClass, oInitiator);
	int nMoveTotal    = GetKnownManeuversModifier(oInitiator, nClass, MANEUVER_TYPE_MANEUVER);
	int nStncTotal    = GetKnownManeuversModifier(oInitiator, nClass, MANEUVER_TYPE_STANCE);
	int nRdyTotal     = GetReadiedManeuversModifier(oInitiator, nClass);
	int nEvent        = GetRunningEvent();

	if(DEBUG) DoDebug("tob_shadowsun running, event: " + IntToString(nEvent));

	// We aren't being called from any event, instead from EvalPRCFeats
	if(nEvent == FALSE)
	{
		// Allows gaining of maneuvers by prestige classes
		// It's not pretty, but it works
		if (nLevel >= 1 && !GetPersistantLocalInt(oInitiator, "ToBShadowSunNinja1"))
		{
			if(DEBUG) DoDebug("tob_shadowsun: Adding Maneuver 1");
			SetKnownManeuversModifier(oInitiator, GetFirstBladeMagicClass(oInitiator), ++nMoveTotal, MANEUVER_TYPE_MANEUVER);
			SetPersistantLocalInt(oInitiator, "ToBShadowSunNinja1", TRUE);
			SetPersistantLocalInt(oInitiator, "RestrictedDiscipline1", DISCIPLINE_DEVOTED_SPIRIT);
			SetPersistantLocalInt(oInitiator, "RestrictedDiscipline2", DISCIPLINE_DIAMOND_MIND);
			SetPersistantLocalInt(oInitiator, "RestrictedDiscipline3", DISCIPLINE_IRON_HEART);
			SetPersistantLocalInt(oInitiator, "RestrictedDiscipline4", DISCIPLINE_WHITE_RAVEN);
		}

		if (nLevel >= 3 &&!GetPersistantLocalInt(oInitiator, "ToBShadowSunNinja3"))
		{
			if(DEBUG) DoDebug("tob_shadowsun: Adding Maneuver 3");
			SetKnownManeuversModifier(oInitiator, GetFirstBladeMagicClass(oInitiator), ++nMoveTotal, MANEUVER_TYPE_MANEUVER);
			SetPersistantLocalInt(oInitiator, "ToBShadowSunNinja3", TRUE);
			SetPersistantLocalInt(oInitiator, "RestrictedDiscipline1", DISCIPLINE_DEVOTED_SPIRIT);
			SetPersistantLocalInt(oInitiator, "RestrictedDiscipline2", DISCIPLINE_DIAMOND_MIND);
			SetPersistantLocalInt(oInitiator, "RestrictedDiscipline3", DISCIPLINE_IRON_HEART);
			SetPersistantLocalInt(oInitiator, "RestrictedDiscipline4", DISCIPLINE_WHITE_RAVEN);
		}

		if (nLevel >= 5 && !GetPersistantLocalInt(oInitiator, "ToBShadowSunNinja5"))
		{
			if(DEBUG) DoDebug("tob_shadowsun: Adding Maneuver 5");
			SetKnownManeuversModifier(oInitiator, GetFirstBladeMagicClass(oInitiator), ++nStncTotal, MANEUVER_TYPE_STANCE);
			SetReadiedManeuversModifier(oInitiator, GetFirstBladeMagicClass(oInitiator), ++nRdyTotal);
			SetPersistantLocalInt(oInitiator, "ToBShadowSunNinja5", TRUE);
			SetPersistantLocalInt(oInitiator, "RestrictedDiscipline1", DISCIPLINE_DEVOTED_SPIRIT);
			SetPersistantLocalInt(oInitiator, "RestrictedDiscipline2", DISCIPLINE_DIAMOND_MIND);
			SetPersistantLocalInt(oInitiator, "RestrictedDiscipline3", DISCIPLINE_IRON_HEART);
			SetPersistantLocalInt(oInitiator, "RestrictedDiscipline4", DISCIPLINE_WHITE_RAVEN);
		}
		if (nLevel >= 6 && !GetPersistantLocalInt(oInitiator, "ToBShadowSunNinja6"))
		{
			if(DEBUG) DoDebug("tob_shadowsun: Adding Maneuver 6");
			SetKnownManeuversModifier(oInitiator, GetFirstBladeMagicClass(oInitiator), ++nMoveTotal, MANEUVER_TYPE_MANEUVER);
			SetPersistantLocalInt(oInitiator, "ToBShadowSunNinja6", TRUE);
		}
		if (nLevel >= 9 && !GetPersistantLocalInt(oInitiator, "ToBShadowSunNinja9"))
		{
			if(DEBUG) DoDebug("tob_shadowsun: Adding Maneuver 9");
			SetKnownManeuversModifier(oInitiator, GetFirstBladeMagicClass(oInitiator), ++nMoveTotal, MANEUVER_TYPE_MANEUVER);
			SetPersistantLocalInt(oInitiator, "ToBShadowSunNinja9", TRUE);
			SetPersistantLocalInt(oInitiator, "RestrictedDiscipline1", DISCIPLINE_DEVOTED_SPIRIT);
			SetPersistantLocalInt(oInitiator, "RestrictedDiscipline2", DISCIPLINE_DIAMOND_MIND);
			SetPersistantLocalInt(oInitiator, "RestrictedDiscipline3", DISCIPLINE_IRON_HEART);
			SetPersistantLocalInt(oInitiator, "RestrictedDiscipline4", DISCIPLINE_WHITE_RAVEN);
		}
		if (nLevel >= 10 && !GetPersistantLocalInt(oInitiator, "ToBShadowSunNinja10"))
		{
			if(DEBUG) DoDebug("tob_shadowsun: Adding Maneuver 10");
			SetReadiedManeuversModifier(oInitiator, GetFirstBladeMagicClass(oInitiator), ++nRdyTotal);
			SetPersistantLocalInt(oInitiator, "ToBShadowSunNinja10", TRUE);
		}
		// Hook to OnLevelDown to remove the maneuver slots granted here
		AddEventScript(oInitiator, EVENT_ONPLAYERLEVELDOWN, "tob_shadowsun", TRUE, FALSE);
	}
	else if(nEvent == EVENT_ONPLAYERLEVELDOWN)
	{
		// Has lost Maneuver, but the slot is still present
		if(GetPersistantLocalInt(oInitiator, "ToBShadowSunNinja1") && nLevel < 1)
		{
			DeletePersistantLocalInt(oInitiator, "ToBShadowSunNinja1");
			SetKnownManeuversModifier(oInitiator, GetFirstBladeMagicClass(oInitiator), --nMoveTotal, MANEUVER_TYPE_MANEUVER);
		}
		// Has lost Maneuver, but the slot is still present
		if(GetPersistantLocalInt(oInitiator, "ToBShadowSunNinja3") && nLevel < 3)
		{
			DeletePersistantLocalInt(oInitiator, "ToBShadowSunNinja3");
			SetKnownManeuversModifier(oInitiator, GetFirstBladeMagicClass(oInitiator), --nMoveTotal, MANEUVER_TYPE_MANEUVER);
		}
		// Has lost Maneuver, but the slot is still present
		if(GetPersistantLocalInt(oInitiator, "ToBShadowSunNinja5") && nLevel < 5)
		{
			DeletePersistantLocalInt(oInitiator, "ToBShadowSunNinja5");
			SetReadiedManeuversModifier(oInitiator, GetFirstBladeMagicClass(oInitiator), --nRdyTotal);
			SetKnownManeuversModifier(oInitiator, GetFirstBladeMagicClass(oInitiator), --nStncTotal, MANEUVER_TYPE_STANCE);
		}
		// Has lost Maneuver, but the slot is still present
		if(GetPersistantLocalInt(oInitiator, "ToBShadowSunNinja6") && nLevel < 6)
		{
			DeletePersistantLocalInt(oInitiator, "ToBShadowSunNinja6");
			SetKnownManeuversModifier(oInitiator, GetFirstBladeMagicClass(oInitiator), --nMoveTotal, MANEUVER_TYPE_MANEUVER);
		}
		// Has lost Maneuver, but the slot is still present
		if(GetPersistantLocalInt(oInitiator, "ToBShadowSunNinja9") && nLevel < 9)
		{
			DeletePersistantLocalInt(oInitiator, "ToBShadowSunNinja9");
			SetKnownManeuversModifier(oInitiator, GetFirstBladeMagicClass(oInitiator), --nMoveTotal, MANEUVER_TYPE_MANEUVER);
		}
		// Has lost Maneuver, but the slot is still present
		if(GetPersistantLocalInt(oInitiator, "ToBShadowSunNinja7") && nLevel < 10)
		{
			DeletePersistantLocalInt(oInitiator, "ToBShadowSunNinja10");
			SetReadiedManeuversModifier(oInitiator, GetFirstBladeMagicClass(oInitiator), --nRdyTotal);
		}

		// Remove eventhook if the character no longer has levels in Eernal Blade
		if(nLevel == 0)
			RemoveEventScript(oInitiator, EVENT_ONPLAYERLEVELDOWN, "tob_shadowsun", TRUE, FALSE);
	}
}