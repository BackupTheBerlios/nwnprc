//::///////////////////////////////////////////////
//:: JX Spellbook - Refresh the view for spells ready
//:: jx_spbk_refresh_sprdy
//:://////////////////////////////////////////////
//:://////////////////////////////////////////////
//:: Created By: jallaix
//:: Created On: Dec 13, 2007
//:://////////////////////////////////////////////
//
// This script is fired by the JXUpdateGUISpellQuick() function.
// It displays the spells ready to be cast.
// This script is necessary to avoid TMI errors in JXUpdateGUISpellQuick().
//
//:://////////////////////////////////////////////

#include "jx_inc_spbk_process_sprdy"




void main()
{
	object oPC = OBJECT_SELF;

	// Get the list of spells ready to display
	struct jx_spells_ready spellsReady = JXStringToSpellsReady(GetLocalString(oPC, "JX_SPELLS_READY_DISPLAY"));

	// Loop through the spell levels to determine the spells to be displayed
	int iSpellLevelPositionUI = 0;
	int iLoopSpellLevel;
	for (iLoopSpellLevel = 0; iLoopSpellLevel <= spellsReady.iMaxSpellLevel; iLoopSpellLevel++)
	{
SendMessageToPC(oPC, "iLoopSpellLevel"+IntToString(iLoopSpellLevel));
		struct jx_spell_ready spellReady;
		string sSpellIcon;
		int iSpellName;

		// Get the number of spells ready to be cast for the current spell level
		int iNbSpellSlots = JXSpellsReadyGetNbSpellsForLevel(spellsReady, iLoopSpellLevel);

		// Search spells for the next spell level because no spells are ready for the current spell level
		if (iNbSpellSlots == 0)
			continue;

		// Show the collapsable for the current spell level as some spells are ready
		SetGUIObjectHidden(oPC, JX_SCREEN_SPELLS_QUICK, "clpSpellLevel" + IntToString(iSpellLevelPositionUI), FALSE);
		SetGUIObjectText(oPC, JX_SCREEN_SPELLS_QUICK, "btnSpellLevel" + IntToString(iSpellLevelPositionUI), -1, IntToString(iLoopSpellLevel));

		// Display the spells ready to be cast
		int iLoopSpellSlot;
		for (iLoopSpellSlot = 1; iLoopSpellSlot <= iNbSpellSlots; iLoopSpellSlot++)
		{
SendMessageToPC(oPC, "iLoopSpellSlot="+IntToString(iLoopSpellSlot));
			// Find the spell to display
			spellReady = JXSpellsReadyGetSpell(spellsReady, iLoopSpellLevel, iLoopSpellSlot);

			// Get the spell's icon
			sSpellIcon = Get2DAString("spells", "IconResRef", spellReady.iSpellId);
			// Get the spell's name strref
			iSpellName = StringToInt(Get2DAString("spells", "Name", spellReady.iSpellId));

			// The spell is not a master spell => Prepare an "action" button
			if (spellReady.bMaster == FALSE)
			{
				// Hide the "master spell" button
				SetGUIObjectHidden(oPC, JX_SCREEN_SPELLS_QUICK, "btnRadialSL" + IntToString(iSpellLevelPositionUI) +
								   "SP" + IntToString(iLoopSpellSlot), TRUE);

				// Get the spell properties
				int iTargetType = JXPrivateHexStringToInt(Get2DAString("spells", "TargetType", spellReady.iSpellId));
				int iSpellTarget = StringToInt(Get2DAString("spells", "TargetingUI", spellReady.iSpellId));
				if ((iSpellTarget == 3) || (iSpellTarget == 4) || (iSpellTarget == 5) || (iSpellTarget == 12) || (iSpellTarget == 16))
					iSpellTarget = 0;	// As cone and bolt target UI crash the game, assume a simple one
				int iHostile = StringToInt(Get2DAString("spells", "HostileSetting", spellReady.iSpellId));
				int iName = StringToInt(Get2DAString("spells", "Name", spellReady.iSpellId));

				// Show the "classic spell" button for the spell target and hide the others
				int iLoopTarget;
				for (iLoopTarget = 0; iLoopTarget < 20; iLoopTarget++)
				{
					int bHideButton = TRUE;
					if (iLoopTarget == iSpellTarget)
						bHideButton = FALSE;
					SetGUIObjectHidden(oPC, JX_SCREEN_SPELLS_QUICK, "btnSL" + IntToString(iSpellLevelPositionUI) +
									   "SP" + IntToString(iLoopSpellSlot) + "TG" + IntToString(iLoopTarget), bHideButton);
				}
				// Add the spell on the GUI buttons
				SetGUITexture(oPC, JX_SCREEN_SPELLS_QUICK, "btnSL" + IntToString(iSpellLevelPositionUI) +
							  "SP" + IntToString(iLoopSpellSlot) + "TG" + IntToString(iSpellTarget), sSpellIcon + ".tga");
				// Define the number of spells used for the day
				SetGUIObjectText(oPC, JX_SCREEN_SPELLS_QUICK, "btnSL" + IntToString(iSpellLevelPositionUI) +
								 "SP" + IntToString(iLoopSpellSlot) + "TG" + IntToString(iSpellTarget),
								 -1, "       " + IntToString(spellReady.iNbUses) + " ");
				// Disable the button if there are no uses left for the current spell
				if (spellReady.iNbUses == 0)
					SetGUIObjectDisabled(oPC, JX_SCREEN_SPELLS_QUICK, "btnSL" + IntToString(iSpellLevelPositionUI) +
										 "SP" + IntToString(iLoopSpellSlot) + "TG" + IntToString(iSpellTarget), TRUE);
				else
					SetGUIObjectDisabled(oPC, JX_SCREEN_SPELLS_QUICK, "btnSL" + IntToString(iSpellLevelPositionUI) +
										 "SP" + IntToString(iLoopSpellSlot) + "TG" + IntToString(iSpellTarget), FALSE);

				// Define the spell properties for the button
				string sTargetType = "";
				if (iTargetType & 1) sTargetType += "self,";
				if (iTargetType & 2) sTargetType += "creature,";
				if (iTargetType & 4) sTargetType += "ground,";
				if (iTargetType & 8) sTargetType += "item,";
				if (iTargetType & 16) sTargetType += "door,";
				if (iTargetType & 32) sTargetType += "placeable,";
				if (iTargetType & 64) sTargetType += "trigger,";
				sTargetType = GetStringLeft(sTargetType, GetStringLength(sTargetType) - 1);
				string sHostile = (iHostile == 1) ? "true" : "false";

				// Set the spell properties for the button
				int iVariableValue = 10 + iSpellLevelPositionUI * 60 + (iLoopSpellSlot - 1) * 3;
				SetLocalGUIVariable(oPC, JX_SCREEN_SPELLS_QUICK, iVariableValue, sTargetType);
				SetLocalGUIVariable(oPC, JX_SCREEN_SPELLS_QUICK, iVariableValue + 1, sHostile);
				SetLocalGUIVariable(oPC, JX_SCREEN_SPELLS_QUICK, iVariableValue + 2, GetStringByStrRef(iName));
			}
			// The spell is a master spell => Prepare a "radial" button
			else
			{
					// Hide the "classic spell" buttons
					int iLoopTarget;
					for (iLoopTarget = 0; iLoopTarget < 20; iLoopTarget++)
					{
						SetGUIObjectHidden(oPC, JX_SCREEN_SPELLS_QUICK, "btnSL" + IntToString(iSpellLevelPositionUI) +
										   "SP" + IntToString(iLoopSpellSlot) +
										   "TG" + IntToString(iLoopTarget), TRUE);
					}
					// Show the "master spell" button
					SetGUIObjectHidden(oPC, JX_SCREEN_SPELLS_QUICK, "btnRadialSL" + IntToString(iSpellLevelPositionUI) +
									   "SP" + IntToString(iLoopSpellSlot), FALSE);

					// Add the spell on the GUI buttons
					SetGUITexture(oPC, JX_SCREEN_SPELLS_QUICK, "btnRadialSL" + IntToString(iSpellLevelPositionUI) +
								  "SP" + IntToString(iLoopSpellSlot), sSpellIcon + ".tga");
					// Define the number of spells used for the day
					SetGUIObjectText(oPC, JX_SCREEN_SPELLS_QUICK, "btnRadialSL" + IntToString(iSpellLevelPositionUI) +
									 "SP" + IntToString(iLoopSpellSlot), -1,
									 "       " + IntToString(spellReady.iNbUses) + " ");
					// Disable the button if there are no uses left for the current spell
					if (spellReady.iNbUses == 0)
						SetGUIObjectDisabled(oPC, JX_SCREEN_SPELLS_QUICK, "btnRadialSL" + IntToString(iSpellLevelPositionUI) +
											 "SP" + IntToString(iLoopSpellSlot), TRUE);
					else
						SetGUIObjectDisabled(oPC, JX_SCREEN_SPELLS_QUICK, "btnRadialSL" + IntToString(iSpellLevelPositionUI) +
											 "SP" + IntToString(iLoopSpellSlot), FALSE);

					// Set the spell properties for the button
					int iName = StringToInt(Get2DAString("spells", "Name", spellReady.iSpellId));
					int iVariableValue = 10 + iSpellLevelPositionUI * 60 + (iLoopSpellSlot - 1) * 3;
					SetLocalGUIVariable(oPC, JX_SCREEN_SPELLS_QUICK, iVariableValue + 2, GetStringByStrRef(iName));
			}
		}

		// Hide the buttons not used for the spell level
		for (iLoopSpellSlot = iNbSpellSlots + 1; iLoopSpellSlot <= JX_SPBK_READY_MAXSPELLS; iLoopSpellSlot++)
		{
SendMessageToPC(oPC, "iLoopSpellSlot hide="+IntToString(iLoopSpellSlot));
			int iLoopTarget;
			for (iLoopTarget = 0; iLoopTarget < 20; iLoopTarget++)
			{
				SetGUIObjectHidden(oPC, JX_SCREEN_SPELLS_QUICK, "btnSL" + IntToString(iSpellLevelPositionUI) +
								   "SP" + IntToString(iLoopSpellSlot) +
								   "TG" + IntToString(iLoopTarget), TRUE);
			}
			SetGUIObjectHidden(oPC, JX_SCREEN_SPELLS_QUICK, "btnRadialSL" + IntToString(iSpellLevelPositionUI) +
							   "SP" + IntToString(iLoopSpellSlot), TRUE);
		}

		iSpellLevelPositionUI++;
	}
	// Hide the collapsable for the levels that don't have ready spells
	for (iLoopSpellLevel = iSpellLevelPositionUI; iLoopSpellLevel <= 10; iLoopSpellLevel++)
		SetGUIObjectHidden(oPC, JX_SCREEN_SPELLS_QUICK, "clpSpellLevel" + IntToString(iLoopSpellLevel), TRUE);
SendMessageToPC(oPC, "fin");
}