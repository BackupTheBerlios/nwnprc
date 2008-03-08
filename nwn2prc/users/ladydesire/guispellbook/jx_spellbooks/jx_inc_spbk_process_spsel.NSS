//::///////////////////////////////////////////////
//:: JX Spellbook - Level Up include
//:: jx_inc_spbk_process_spsel
//:://////////////////////////////////////////////
//:://////////////////////////////////////////////
//:: Created By: jallaix
//:: Created On: Nov 14, 2007
//:://////////////////////////////////////////////
//
// This include file provides functions to manage the spells selection
// of a player's spellbook at character creation and level up.
//
//:://////////////////////////////////////////////

#include "jx_inc_spbk_process_spday"
#include "jx_inc_spbk_process_spkwn"
















//**************************************//
//                                      //
//              Interface               //
//                                      //
//**************************************//


// Restore the spellbook's level for a class of a PC
// - oPC Player character
// - iClass CLASS_TYPE_* constant associated with a spellbook
// * Returns the spellbook level found (0 if not defined)
int JXRestoreSpellbookLevel(object oPC, int iClass);

// Save the spellbook's level for a class of a PC
// - oPC Player character
// - iClass CLASS_TYPE_* constant associated with a spellbook
// - iSpellbookLevel Spellbook level
void JXSaveSpellbookLevel(object oPC, int iClass, int iSpellbookLevel);

// Update the spellbook of a PC to reflect his current spellbook level
// - oPC Player character
// - iClass CLASS_TYPE_* constant with a spellbook
void JXUpdateSpellbook(object oPC, int iClass);

// Check if spellbooks need to be updated for a PC, and update them, either
// by selecting spells through the GUI screen, either by automatically choosing them
// - oPC Player character
// - bGUIAlreadyDisplayed Indicate if the GUI screen is currently displayed
void JXCheckSpellbooksToUpdate(object oPC, int bGUIAlreadyDisplayed = FALSE);

// Find the number of spells to select for the specified spellbook level of a class
// - oPC Player character
// - iClass CLASS_TYPE_* constant associated with a spellbook
// - iSpellbookLevel Spellbook level
// * Returns the computed number of spells to select
struct jx_nb_spells_select JXComputeNbSpellsToSelect(object oPC, int iClass, int iSpellbookLevel);

// Add a spell to a player's selection in the GUI screen for spell selection at level up
// - oPC Player character
// - iSpellSlot Spell slot in the list of unknown spells
void JXAddSpellGUISpellLevelUp(object oPC, int iSpellSlot);

// Remove a spell from a player's selection in the GUI screen for spell selection at level up
// - oPC Player character
// - iSpellSlot Spell slot in the list of added spells
void JXRemoveSpellGUISpellLevelUp(object oPC, int iSpellSlot);

// Update the GUI screen for spell selection at level up to reflect the current data
// - oPC Player character for whom the screen has to be updated
void JXUpdateGUISpellLevelUp(object oPC);
















//**************************************//
//                                      //
//            Implementation            //
//                                      //
//**************************************//


// Restore the spellbook's level for a class of a PC
// - oPC Player character
// - iClass Class with a spellbook
// * Returns the spellbook level found (0 if not defined)
int JXRestoreSpellbookLevel(object oPC, int iClass)
{
	// Get the spellbook levels previously saved
	string sSpellbookLevels = GetLocalString(oPC, JX_SPELLS_BOOK_LEVELS);

	// No spellbook levels defined
	if (sSpellbookLevels == "")
		return 0;

	// Loop through the classes previously saved to find the specified class
	int iSpellbookLevelsCount = JXStringSplitCount(sSpellbookLevels, ";");
	int iLoopSpellbookLevel;
	for (iLoopSpellbookLevel = 1; iLoopSpellbookLevel <= iSpellbookLevelsCount; iLoopSpellbookLevel++)
	{
		string sSpellbookLevel = JXStringSplit(sSpellbookLevels, ";", iLoopSpellbookLevel - 1);
		int iCurrentClass = StringToInt(JXStringSplit(sSpellbookLevel, ",", 0));

		// Specified class found => return its associated spellbook level
		if (iCurrentClass == iClass)
			return StringToInt(JXStringSplit(sSpellbookLevel, ",", 1));
	}

	return 0;
}

// Save the spellbook's level for a class of a PC
// - oPC Player character
// - iClass Class with a spellbook
// - iSpellbookLevel Spellbook level
void JXSaveSpellbookLevel(object oPC, int iClass, int iSpellbookLevel)
{
	// Get the spellbook levels previously saved
	string sSpellbookLevels = GetLocalString(oPC, JX_SPELLS_BOOK_LEVELS);

	// Loop through the classes previously saved to find the specified class
	string sSpellbookLevelsNew = "";
	int bClassFound = FALSE;
	int iSpellbookLevelsCount;
	if (sSpellbookLevels == "")
		iSpellbookLevelsCount = 0;
	else
		iSpellbookLevelsCount = JXStringSplitCount(sSpellbookLevels, ";");
	int iLoopSpellbookLevel;
	for (iLoopSpellbookLevel = 1; iLoopSpellbookLevel <= iSpellbookLevelsCount; iLoopSpellbookLevel++)
	{
		string sSpellbookLevel = JXStringSplit(sSpellbookLevels, ";", iLoopSpellbookLevel - 1);
		int iCurrentClass = StringToInt(JXStringSplit(sSpellbookLevel, ",", 0));

		// Specified class found => update its associated spellbook level
		if (iCurrentClass == iClass)
		{
			sSpellbookLevelsNew += ";" + IntToString(iCurrentClass) + "," + IntToString(iSpellbookLevel);
			bClassFound = TRUE;
		}
		else
			sSpellbookLevelsNew += ";" + sSpellbookLevel;
	}

	// Add the current class if it was not found
	if (bClassFound == FALSE)
		sSpellbookLevelsNew += ";" + IntToString(iClass) + "," + IntToString(iSpellbookLevel);

	// Save the list of spellbook levels
	sSpellbookLevelsNew = GetStringRight(sSpellbookLevelsNew, GetStringLength(sSpellbookLevelsNew) - 1);
	SetLocalString(oPC, JX_SPELLS_BOOK_LEVELS, sSpellbookLevelsNew);
}

// Update the spellbook of a PC to reflect his current spellbook level
// - oPC Player character
// - iClass CLASS_TYPE_* constant with a spellbook
void JXUpdateSpellbook(object oPC, int iClass)
{
	// Get the restored and current spellbook levels
	int iSpellbookLevelRestored = JXRestoreSpellbookLevel(oPC, iClass);
	int iSpellbookLevel = JXGetSpellbookLevel(oPC, iClass);

	// Get the list of spells known by the PC
	struct jx_spells_known spellsKnown = JXRestoreSpellsKnown(oPC, iClass);

	// Update the wizard's spellbook if he doesn't know any level 0 spell
	if (iClass == CLASS_TYPE_WIZARD)
	{
		if (JXSpellsKnownGetNbSpellsForLevel(spellsKnown, 0) == -1)
		{
			// Get the list of spells level 0 in the wizard spell list
			struct jx_spells_known spellsLevel0 = JXGetSpellList(CLASS_TYPE_WIZARD, 0);
			// Add this list of spells to his spellbook
			spellsKnown = JXSpellsKnownAddSpellList(spellsKnown, spellsLevel0);
			// If the wizard doesn't know any level 0 spell, it means his spellbook level is 0
			iSpellbookLevel = 0;
		}
		else
			// The wizard's spellbook is updated using the GUI screen
			iSpellbookLevel = iSpellbookLevelRestored;
	}
	else
	{
		// Find the maximum spell levels for both spellbook values
		string sSpellProgression = Get2DAString("classes", "SpellGainTable", iClass);
		int iMaxSpellLevelRestored = StringToInt(Get2DAString(sSpellProgression, "NumSpellLevels", iSpellbookLevelRestored - 1)) - 1;
		int iMaxSpellLevel = StringToInt(Get2DAString(sSpellProgression, "NumSpellLevels", iSpellbookLevel - 1)) - 1;

		// Complete the spellbook with the missing spells
		struct jx_spells_known spellsKnownLevel;
		int iLoopSpellLevel;
		for (iLoopSpellLevel = iMaxSpellLevelRestored + 1; iLoopSpellLevel <= iMaxSpellLevel; iLoopSpellLevel++)
		{
			spellsKnownLevel = JXGetSpellList(iClass, iLoopSpellLevel);
			spellsKnown = JXSpellsKnownAddSpellList(spellsKnown, spellsKnownLevel);
		}
	}

	// Save the spellbook informations
	JXSaveSpellbookLevel(oPC, iClass, iSpellbookLevel);
	JXSaveSpellsKnown(oPC, iClass, spellsKnown);
}

// Check if spellbooks need to be updated for a PC, and update them,
// either by selecting spells through the GUI screen, either by automatically
// choosing them
// - oPC Player character
// - bGUIAlreadyDisplayed Indicate if the GUI screen is currently displayed
void JXCheckSpellbooksToUpdate(object oPC, int bGUIAlreadyDisplayed)
{
	// Loop through the class positions for the PC
	int iLoop;
	for (iLoop = 1; iLoop <= 4; iLoop++)
	{
		// Determine if the PC has a spellbook for the current class
		int iClass = GetClassByPosition(iLoop, oPC);
		if (JXGetHasSpellbook(oPC, iClass))
		{
			// Display the spell selection screen as the spell list for the current class
			// doesn't correspond to what the character should know
			int iSpellbookLevelRestored = JXRestoreSpellbookLevel(oPC, iClass);
			int iSpellbookLevel = JXGetSpellbookLevel(oPC, iClass);
			if (iSpellbookLevel > iSpellbookLevelRestored)
			{
				// Automatically update the spellbook if all spells are known for the class
				if (JXClassGetKnowsAllSpells(iClass))
					JXUpdateSpellbook(oPC, iClass);
				// Else show the spell selection GUI screen
				else
				{
					// Exception : the wizard knows all level 0 spells
					if (iClass == CLASS_TYPE_WIZARD)
						JXUpdateSpellbook(oPC, iClass);
					// Update or display the spell selection GUI screen
					SetLocalInt(oPC, JX_UI_SPELLS_LEVEL_CURRENTCLASS, iClass);
					if (bGUIAlreadyDisplayed)
						DelayCommand(0.0, ExecuteScript("gui_jx_spbk_splvl_open", oPC));
					else
						DelayCommand(0.0, DisplayGuiScreen(oPC, JX_SCREEN_SPELLS_LEVELUP, TRUE, JX_XML_SPELLS_LEVELUP));
					return;
				}
			}
		}
	}

	// Close the spell selection GUI screen
	CloseGUIScreen(oPC, JX_SCREEN_SPELLS_LEVELUP);
}

// Private function - Get the ability modifier from the base ability score
int JXPrivateGetBaseAbilityModifier(int iAbilityType, object oCreature)
{
	int iAbilityScore = GetAbilityScore(oCreature, iAbilityType, TRUE);
	int iAbilityModifier = (iAbilityScore - 10) / 2;
	return iAbilityModifier;
}

// Find the number of spells to select for the specified spellbook level of a class
// - oPC Player character
// - iClass CLASS_TYPE_* constant associated with a spellbook
// - iSpellbookLevel Spellbook level
// * Returns the computed number of spells to select
struct jx_nb_spells_select JXComputeNbSpellsToSelect(object oPC, int iClass, int iSpellbookLevel)
{
	struct jx_nb_spells_select nbSpellsSelect;

	// Get the complete list of spells available for the class
	struct jx_spells_known spellsKnownComplete = JXGetSpellList(iClass);
	// Get the list of spells known by the PC
	struct jx_spells_known spellsKnownLearned = JXRestoreSpellsKnown(oPC, iClass);

	// Special case : wizard
	if (iClass == CLASS_TYPE_WIZARD)
	{
		// Spell selection for wizard level 1
		if (iSpellbookLevel == 1)
		{
			// Determine the number of spells to learn
			int iNbSpellsSelectGlobal = 3 + JXPrivateGetBaseAbilityModifier(ABILITY_INTELLIGENCE, oPC);
			nbSpellsSelect = JXNbSpellsSelectSetNbSpells(nbSpellsSelect, -1, iNbSpellsSelectGlobal);
		}
		else
			nbSpellsSelect = JXNbSpellsSelectSetNbSpells(nbSpellsSelect, -1, 2);
	}
	// Standard case : all classes except wizard
	else
	{
		// Determine the number of spells to select
		string sSpellsKnownTable = Get2DAString("classes", "SpellKnownTable", iClass);
		int iNbSpellsSelectLevel = StringToInt(Get2DAString(sSpellsKnownTable, "SpellLevel0", iSpellbookLevel - 1)) -
							  	   StringToInt(Get2DAString(sSpellsKnownTable, "SpellLevel0", iSpellbookLevel - 2));
		nbSpellsSelect = JXNbSpellsSelectSetNbSpells(nbSpellsSelect, 0, iNbSpellsSelectLevel);
		iNbSpellsSelectLevel = StringToInt(Get2DAString(sSpellsKnownTable, "SpellLevel1", iSpellbookLevel - 1)) -
							   StringToInt(Get2DAString(sSpellsKnownTable, "SpellLevel1", iSpellbookLevel - 2));
		nbSpellsSelect = JXNbSpellsSelectSetNbSpells(nbSpellsSelect, 1, iNbSpellsSelectLevel);
		iNbSpellsSelectLevel = StringToInt(Get2DAString(sSpellsKnownTable, "SpellLevel2", iSpellbookLevel - 1)) -
							   StringToInt(Get2DAString(sSpellsKnownTable, "SpellLevel2", iSpellbookLevel - 2));
		nbSpellsSelect = JXNbSpellsSelectSetNbSpells(nbSpellsSelect, 2, iNbSpellsSelectLevel);
		iNbSpellsSelectLevel = StringToInt(Get2DAString(sSpellsKnownTable, "SpellLevel3", iSpellbookLevel - 1)) -
							   StringToInt(Get2DAString(sSpellsKnownTable, "SpellLevel3", iSpellbookLevel - 2));
		nbSpellsSelect = JXNbSpellsSelectSetNbSpells(nbSpellsSelect, 3, iNbSpellsSelectLevel);
		iNbSpellsSelectLevel = StringToInt(Get2DAString(sSpellsKnownTable, "SpellLevel4", iSpellbookLevel - 1)) -
							   StringToInt(Get2DAString(sSpellsKnownTable, "SpellLevel4", iSpellbookLevel - 2));
		nbSpellsSelect = JXNbSpellsSelectSetNbSpells(nbSpellsSelect, 4, iNbSpellsSelectLevel);
		iNbSpellsSelectLevel = StringToInt(Get2DAString(sSpellsKnownTable, "SpellLevel5", iSpellbookLevel - 1)) -
							   StringToInt(Get2DAString(sSpellsKnownTable, "SpellLevel5", iSpellbookLevel - 2));
		nbSpellsSelect = JXNbSpellsSelectSetNbSpells(nbSpellsSelect, 5, iNbSpellsSelectLevel);
		iNbSpellsSelectLevel = StringToInt(Get2DAString(sSpellsKnownTable, "SpellLevel6", iSpellbookLevel - 1)) -
							   StringToInt(Get2DAString(sSpellsKnownTable, "SpellLevel6", iSpellbookLevel - 2));
		nbSpellsSelect = JXNbSpellsSelectSetNbSpells(nbSpellsSelect, 6, iNbSpellsSelectLevel);
		iNbSpellsSelectLevel = StringToInt(Get2DAString(sSpellsKnownTable, "SpellLevel7", iSpellbookLevel - 1)) -
							   StringToInt(Get2DAString(sSpellsKnownTable, "SpellLevel7", iSpellbookLevel - 2));
		nbSpellsSelect = JXNbSpellsSelectSetNbSpells(nbSpellsSelect, 7, iNbSpellsSelectLevel);
		iNbSpellsSelectLevel = StringToInt(Get2DAString(sSpellsKnownTable, "SpellLevel8", iSpellbookLevel - 1)) -
							   StringToInt(Get2DAString(sSpellsKnownTable, "SpellLevel8", iSpellbookLevel - 2));
		nbSpellsSelect = JXNbSpellsSelectSetNbSpells(nbSpellsSelect, 8, iNbSpellsSelectLevel);
		iNbSpellsSelectLevel = StringToInt(Get2DAString(sSpellsKnownTable, "SpellLevel9", iSpellbookLevel - 1)) -
							   StringToInt(Get2DAString(sSpellsKnownTable, "SpellLevel9", iSpellbookLevel - 2));
		nbSpellsSelect = JXNbSpellsSelectSetNbSpells(nbSpellsSelect, 9, iNbSpellsSelectLevel);

		// Determine the number of spells to swap
		string sSpellSwapMinLvl = Get2DAString("classes", "SpellSwapMinLvl", iClass);
		if (sSpellSwapMinLvl != "")
		{
			// Find if a spell swap must occur for the spellbook level
			int iSpellSwapMinLvl = StringToInt(sSpellSwapMinLvl);
			int iSpellSwapLvlInterval = StringToInt(Get2DAString("classes", "SpellSwapLvlInterval", iClass));
			int iSpellSwapLvl = iSpellSwapMinLvl;
			while (iSpellSwapLvl < iSpellbookLevel)
				iSpellSwapLvl += iSpellSwapLvlInterval;
			if (iSpellSwapLvl == iSpellbookLevel)
			{
				// Determine the spell level for which a spell can be swapped
				string sSpellsGainTable = Get2DAString("classes", "SpellGainTable", iClass);
				int iBestSpellLevel = StringToInt(Get2DAString(sSpellsGainTable, "NumSpellLevels", iSpellbookLevel - 1)) - 1;
				int iSpellSwapLvlDiff = StringToInt(Get2DAString("classes", "SpellSwapLvlDiff", iClass));
				nbSpellsSelect = JXNbSpellsSelectSetNbSpellsSwap(nbSpellsSelect, iBestSpellLevel - iSpellSwapLvlDiff, 1);
			}
		}
	}

	// Compute the maximum number of spells to select depending on the spells available
	int iLoopSpellLevel;
	for (iLoopSpellLevel = 0; iLoopSpellLevel <= 9; iLoopSpellLevel++)
	{
		int iNbSpellsSelect = JXNbSpellsSelectGetNbSpells(nbSpellsSelect, iLoopSpellLevel);

		int iNbSpellsComplete = JXSpellsKnownGetNbSpellsForLevel(spellsKnownComplete, iLoopSpellLevel);
		int iNbSpellsLearned = JXSpellsKnownGetNbSpellsForLevel(spellsKnownLearned, iLoopSpellLevel);
		int iNbSpellsAvailable = iNbSpellsComplete - iNbSpellsLearned;

		if (iNbSpellsAvailable < iNbSpellsSelect)
			nbSpellsSelect = JXNbSpellsSelectSetNbSpells(nbSpellsSelect, iLoopSpellLevel, iNbSpellsAvailable);
	}

	return nbSpellsSelect;
}

// Add a spell to a player's selection in the GUI screen for spell selection at level up
// - oPC Player character
// - iSpellSlot Spell slot in the list of unknown spells
void JXAddSpellGUISpellLevelUp(object oPC, int iSpellSlot)
{
	// Get the selected class and spell level
	int iCurrentClass = GetLocalInt(oPC, JX_UI_SPELLS_LEVEL_CURRENTCLASS);
	int iCurrentSpellLevel = GetLocalInt(oPC, JX_UI_SPELLS_LEVEL_CURRENTLEVEL);
	// Get the current spell selection
	struct jx_nb_spells_select nbSpellsSelect = JXStringToNbSpellsSelect(GetLocalString(oPC, JX_UI_SPELLS_LEVEL_CURRENTNBSPELLS));
	struct jx_spells_known selectedSpells = JXStringToSpellsKnown(GetLocalString(oPC, JX_UI_SPELLS_LEVEL_SELECTEDSPELLS));
	struct jx_spells_known deselectedSpells = JXStringToSpellsKnown(GetLocalString(oPC, JX_UI_SPELLS_LEVEL_DESELECTEDSPELLS));

	// Get the list of spells that the PC has selected
	struct jx_spells_known spellsKnownLearned = JXRestoreSpellsKnown(oPC, iCurrentClass);
	struct jx_spells_known spellsKnownAdded = JXSpellsKnownAddSpellList(spellsKnownLearned, selectedSpells);
	spellsKnownAdded = JXSpellsKnownRemoveSpellList(spellsKnownAdded, deselectedSpells, iCurrentSpellLevel);

	// Get the complete list of spells available for the class, except those the PC has selected
	struct jx_spells_known spellsKnownAvailable = JXGetSpellList(iCurrentClass, iCurrentSpellLevel);
	spellsKnownAvailable = JXSpellsKnownRemoveSpellList(spellsKnownAvailable, spellsKnownAdded, iCurrentSpellLevel);

	// Get the spell chosen from the list of available spells
	int iSpellId = JXSpellsKnownGetSpell(spellsKnownAvailable, iCurrentSpellLevel, iSpellSlot);

	int iNbSpellsSwapped = JXNbSpellsSelectGetNbSpellsSwapped(nbSpellsSelect, iCurrentSpellLevel);
	if (JXSpellsKnownContainsSpell(deselectedSpells, iSpellId, iCurrentSpellLevel))
	{
		// Determine if it's possible to remove the spell
		int iNbSpellsToSwap = JXNbSpellsSelectGetNbSpellsSwap(nbSpellsSelect, iCurrentSpellLevel);
		if (iNbSpellsSwapped == 0)
			return;

		// Define the number of spells swapped
		nbSpellsSelect = JXNbSpellsSelectSetNbSpellsSwapped(nbSpellsSelect, iCurrentSpellLevel, iNbSpellsSwapped - 1);
		SetLocalString(oPC, JX_UI_SPELLS_LEVEL_CURRENTNBSPELLS, JXNbSpellsSelectToString(nbSpellsSelect));

		// Remove the spell found from the list of deselected spells
		deselectedSpells = JXSpellsKnownRemoveSpell(deselectedSpells, iSpellId, iCurrentSpellLevel);
		SetLocalString(oPC, JX_UI_SPELLS_LEVEL_DESELECTEDSPELLS, JXSpellsKnownToString(deselectedSpells));	
	}
	else
	{
		// Number of spells to select global to all spell levels
		int iNbSpellsToSelect = JXNbSpellsSelectGetNbSpells(nbSpellsSelect, -1);
		int iNbSpellsSelected;
		if (iNbSpellsToSelect > 0)
		{
			// Determine if it's possible to add the spell
			iNbSpellsSelected = JXNbSpellsSelectGetNbSpellsSelected(nbSpellsSelect, -1);
			if (iNbSpellsSelected == iNbSpellsToSelect)
				return;

			// Define the number of spells selected
			nbSpellsSelect = JXNbSpellsSelectSetNbSpellsSelected(nbSpellsSelect, -1, iNbSpellsSelected + 1);
		}
		// Number of spells to select specific to each spell level
		else
		{
			// Determine if it's possible to add the spell
			iNbSpellsToSelect = JXNbSpellsSelectGetNbSpells(nbSpellsSelect, iCurrentSpellLevel);
			iNbSpellsSelected = JXNbSpellsSelectGetNbSpellsSelected(nbSpellsSelect, iCurrentSpellLevel);
			if (iNbSpellsSelected == (iNbSpellsToSelect + iNbSpellsSwapped))
				return;
	
			// Define the number of spells selected
			nbSpellsSelect = JXNbSpellsSelectSetNbSpellsSelected(nbSpellsSelect, iCurrentSpellLevel, iNbSpellsSelected + 1);
		}
		SetLocalString(oPC, JX_UI_SPELLS_LEVEL_CURRENTNBSPELLS, JXNbSpellsSelectToString(nbSpellsSelect));

		// Add the spell found to the list of selected spells
		selectedSpells = JXSpellsKnownAddSpell(selectedSpells, iCurrentSpellLevel, iSpellId);
		SetLocalString(oPC, JX_UI_SPELLS_LEVEL_SELECTEDSPELLS, JXSpellsKnownToString(selectedSpells));
	}
}

// Remove a spell from a player's selection in the GUI screen for spell selection at level up
// - oPC Player character
// - iSpellSlot Spell slot in the list of added spells
void JXRemoveSpellGUISpellLevelUp(object oPC, int iSpellSlot)
{
	// Get the selected class and spell level
	int iCurrentClass = GetLocalInt(oPC, JX_UI_SPELLS_LEVEL_CURRENTCLASS);
	int iCurrentSpellLevel = GetLocalInt(oPC, JX_UI_SPELLS_LEVEL_CURRENTLEVEL);
	// Get the current spell selection
	struct jx_nb_spells_select nbSpellsSelect = JXStringToNbSpellsSelect(GetLocalString(oPC, JX_UI_SPELLS_LEVEL_CURRENTNBSPELLS));
	struct jx_spells_known selectedSpells = JXStringToSpellsKnown(GetLocalString(oPC, JX_UI_SPELLS_LEVEL_SELECTEDSPELLS));
	struct jx_spells_known deselectedSpells = JXStringToSpellsKnown(GetLocalString(oPC, JX_UI_SPELLS_LEVEL_DESELECTEDSPELLS));

	// Get the list of spells that the PC has selected
	struct jx_spells_known spellsKnownLearned = JXRestoreSpellsKnown(oPC, iCurrentClass);
	struct jx_spells_known spellsKnownAdded = JXSpellsKnownAddSpellList(spellsKnownLearned, selectedSpells);
	spellsKnownAdded = JXSpellsKnownRemoveSpellList(spellsKnownAdded, deselectedSpells, iCurrentSpellLevel);

	// Get the spell chosen from the list of added spells
	int iSpellId = JXSpellsKnownGetSpell(spellsKnownAdded, iCurrentSpellLevel, iSpellSlot);

	if (JXSpellsKnownContainsSpell(selectedSpells, iSpellId, iCurrentSpellLevel))
	{
		// Number of spells to select global to all spell levels
		int iNbSpellsToSelect = JXNbSpellsSelectGetNbSpells(nbSpellsSelect, -1);
		int iNbSpellsSelected;
		if (iNbSpellsToSelect > 0)
		{
			// Determine if it's possible to remove the spell
			iNbSpellsSelected = JXNbSpellsSelectGetNbSpellsSelected(nbSpellsSelect, -1);
			if (iNbSpellsSelected == 0)
				return;
	
			// Define the number of spells selected
			nbSpellsSelect = JXNbSpellsSelectSetNbSpellsSelected(nbSpellsSelect, -1, iNbSpellsSelected - 1);
		}
		// Number of spells to select specific to each spell level
		else
		{
			// Determine if it's possible to remove the spell
			iNbSpellsToSelect = JXNbSpellsSelectGetNbSpells(nbSpellsSelect, iCurrentSpellLevel);
			iNbSpellsSelected = JXNbSpellsSelectGetNbSpellsSelected(nbSpellsSelect, iCurrentSpellLevel);
			if (iNbSpellsSelected == 0)
				return;
	
			// Define the number of spells selected
			nbSpellsSelect = JXNbSpellsSelectSetNbSpellsSelected(nbSpellsSelect, iCurrentSpellLevel, iNbSpellsSelected - 1);
		}
		SetLocalString(oPC, JX_UI_SPELLS_LEVEL_CURRENTNBSPELLS, JXNbSpellsSelectToString(nbSpellsSelect));

		// Remove the spell found from the list of selected spells
		selectedSpells = JXSpellsKnownRemoveSpell(selectedSpells, iSpellId, iCurrentSpellLevel);
		SetLocalString(oPC, JX_UI_SPELLS_LEVEL_SELECTEDSPELLS, JXSpellsKnownToString(selectedSpells));	
	}
	else
	{
		// Determine if it's possible to remove the spell
		int iNbSpellsToSwap = JXNbSpellsSelectGetNbSpellsSwap(nbSpellsSelect, iCurrentSpellLevel);
		int iNbSpellsSwapped = JXNbSpellsSelectGetNbSpellsSwapped(nbSpellsSelect, iCurrentSpellLevel);
		if (iNbSpellsToSwap == iNbSpellsSwapped)
			return;

		// Define the number of spells swapped
		nbSpellsSelect = JXNbSpellsSelectSetNbSpellsSwapped(nbSpellsSelect, iCurrentSpellLevel, iNbSpellsSwapped + 1);
		SetLocalString(oPC, JX_UI_SPELLS_LEVEL_CURRENTNBSPELLS, JXNbSpellsSelectToString(nbSpellsSelect));

		// Add the spell found to the list of deselected spells
		deselectedSpells = JXSpellsKnownAddSpell(deselectedSpells, iCurrentSpellLevel, iSpellId);
		SetLocalString(oPC, JX_UI_SPELLS_LEVEL_DESELECTEDSPELLS, JXSpellsKnownToString(deselectedSpells));	
	}
}

// Private function - Determine if there are spells left to be selected
int JXPrivateAreSpellsSelected(struct jx_nb_spells_select nbSpellsSelect)
{
	int iNbSpellsToSelect;
	int iNbSpellsSelected;

	int iLoopNbSpells;
	for (iLoopNbSpells = -1; iLoopNbSpells <= 9; iLoopNbSpells++)
	{
		iNbSpellsToSelect = JXNbSpellsSelectGetNbSpells(nbSpellsSelect, iLoopNbSpells);
		iNbSpellsSelected = JXNbSpellsSelectGetNbSpellsSelected(nbSpellsSelect, iLoopNbSpells);
		if (iNbSpellsSelected < iNbSpellsToSelect)
			return FALSE;
	}

	return TRUE;
}

// Update the GUI screen for spell selection at level up to reflect the current data
// - oPC Player character for whom the screen has to be updated
void JXUpdateGUISpellLevelUp(object oPC)
{
	// Get the selected class, spell level, and spell to display
	int iCurrentClass = GetLocalInt(oPC, JX_UI_SPELLS_LEVEL_CURRENTCLASS);
	int iCurrentSpellLevel = GetLocalInt(oPC, JX_UI_SPELLS_LEVEL_CURRENTLEVEL);
	int iCurrentSpell = GetLocalInt(oPC, JX_UI_SPELLS_LEVEL_CURRENTSPELL);
	// Get the current spell selection
	struct jx_nb_spells_select nbSpellsSelect = JXStringToNbSpellsSelect(GetLocalString(oPC, JX_UI_SPELLS_LEVEL_CURRENTNBSPELLS));
	struct jx_spells_known selectedSpells = JXStringToSpellsKnown(GetLocalString(oPC, JX_UI_SPELLS_LEVEL_SELECTEDSPELLS));
	struct jx_spells_known deselectedSpells = JXStringToSpellsKnown(GetLocalString(oPC, JX_UI_SPELLS_LEVEL_DESELECTEDSPELLS));


	/************************************************************/
	/* Display the spell levels available for the current class */
	/***********************************************************/

	// Get the spellbook level for the current class
	int iSpellbookLevel = JXGetSpellbookLevel(oPC, iCurrentClass);
	int iSpellbookLevelRestored = JXRestoreSpellbookLevel(oPC, iCurrentClass);
	// Determine the spellbook level to use
	if (iSpellbookLevelRestored < iSpellbookLevel)
		iSpellbookLevel = iSpellbookLevelRestored + 1;

	// Get the spell progression table for the class
	string sSpellProgression = Get2DAString("classes", "SpellGainTable", iCurrentClass);

	// Display the available spell levels
	int iMaxSpellLevel = StringToInt(Get2DAString(sSpellProgression, "NumSpellLevels", iSpellbookLevel - 1));
	int iLoopSpellLevel;
	for (iLoopSpellLevel = 0; iLoopSpellLevel <= iMaxSpellLevel; iLoopSpellLevel++)
	{
		string sNbSpells = Get2DAString(sSpellProgression, "SpellLevel" + IntToString(iLoopSpellLevel), iSpellbookLevel - 1);
		if (sNbSpells == "")
			SetGUIObjectDisabled(oPC, JX_SCREEN_SPELLS_LEVELUP, "btnSpellLevel" + IntToString(iLoopSpellLevel), TRUE);
		else
			SetGUIObjectDisabled(oPC, JX_SCREEN_SPELLS_LEVELUP, "btnSpellLevel" + IntToString(iLoopSpellLevel), FALSE);
	}
	// Disable the spell levels after the max spell level for the PC
	for (iLoopSpellLevel = iMaxSpellLevel + 1; iLoopSpellLevel <= 9; iLoopSpellLevel++)
		SetGUIObjectDisabled(oPC, JX_SCREEN_SPELLS_LEVELUP, "btnSpellLevel" + IntToString(iLoopSpellLevel), TRUE);


	/***********************************************************/
	/* Display the spells that can be learned by the character */
	/***********************************************************/

	// Get the list of spells the PC already knowns
	struct jx_spells_known spellsKnownLearned = JXRestoreSpellsKnown(oPC, iCurrentClass);
	struct jx_spells_known spellsKnownAdded = JXSpellsKnownAddSpellList(spellsKnownLearned, selectedSpells);
	spellsKnownAdded = JXSpellsKnownRemoveSpellList(spellsKnownAdded, deselectedSpells, iCurrentSpellLevel);

	// Get the complete list of spells available for the class, except those the PC has selected
	struct jx_spells_known spellsKnownAvailable = JXGetSpellList(iCurrentClass, iCurrentSpellLevel);
	spellsKnownAvailable = JXSpellsKnownRemoveSpellList(spellsKnownAvailable, spellsKnownAdded, iCurrentSpellLevel);

	// Display the list of spells available
	int iNbSpellsAvailable = JXSpellsKnownGetNbSpellsForLevel(spellsKnownAvailable, iCurrentSpellLevel);
	int iLoopSpellSlot;
	for (iLoopSpellSlot = 1; iLoopSpellSlot <= iNbSpellsAvailable; iLoopSpellSlot++)
	{
		// Get the current spell to display
		int iSpellId = JXSpellsKnownGetSpell(spellsKnownAvailable, iCurrentSpellLevel, iLoopSpellSlot);

		// Make the controls for the current spell visible
		SetGUIObjectHidden(oPC, JX_SCREEN_SPELLS_LEVELUP, "panSpellAvail" + IntToString(iLoopSpellSlot), FALSE);
		// Unselect the spell associated with the spell slot if it's not the current spell
		if (iSpellId != iCurrentSpell)
		{
			SetGUIObjectDisabled(oPC, JX_SCREEN_SPELLS_LEVELUP, "panSpellAvail" + IntToString(iLoopSpellSlot), TRUE);
			SetGUIObjectDisabled(oPC, JX_SCREEN_SPELLS_LEVELUP, "panSpellAvail" + IntToString(iLoopSpellSlot), FALSE);
		}

		// Set the icon for the current spell
		string sSpellIcon = Get2DAString("spells", "IconResRef", iSpellId) + ".tga";
		SetGUITexture(oPC, JX_SCREEN_SPELLS_LEVELUP, "btnSpellAvailImage" + IntToString(iLoopSpellSlot), sSpellIcon);
		// Set the name for the current spell
		int iSpellName = StringToInt(Get2DAString("spells", "Name", iSpellId));
		SetGUIObjectText(oPC, JX_SCREEN_SPELLS_LEVELUP, "btnSpellAvailText" + IntToString(iLoopSpellSlot), iSpellName, "");
	}
	// Hide unavailable spell slots
	for (iLoopSpellSlot = iNbSpellsAvailable + 1; iLoopSpellSlot <= JX_SPBK_KNOWN_MAXSPELLS; iLoopSpellSlot++)
		SetGUIObjectHidden(oPC, JX_SCREEN_SPELLS_LEVELUP, "panSpellAvail" + IntToString(iLoopSpellSlot), TRUE);


	/************************************************/
	/* Display the spells selected by the character */
	/************************************************/

	int iNbSpellsToSwap = JXNbSpellsSelectGetNbSpellsSwap(nbSpellsSelect, iCurrentSpellLevel);
	int iNbSpellsSwapped = JXNbSpellsSelectGetNbSpellsSwapped(nbSpellsSelect, iCurrentSpellLevel);

	// Display the list of spells added
	int iNbSpellsAdded = JXSpellsKnownGetNbSpellsForLevel(spellsKnownAdded, iCurrentSpellLevel);
	for (iLoopSpellSlot = 1; iLoopSpellSlot <= iNbSpellsAdded; iLoopSpellSlot++)
	{
		// Get the current spell to display
		int iSpellId = JXSpellsKnownGetSpell(spellsKnownAdded, iCurrentSpellLevel, iLoopSpellSlot);

		// Make the controls for the current spell visible
		SetGUIObjectHidden(oPC, JX_SCREEN_SPELLS_LEVELUP, "panSpellAdded" + IntToString(iLoopSpellSlot), FALSE);
		// Unselect the spell associated with the spell slot if it's not the current spell
		if (iSpellId != iCurrentSpell)
		{
			SetGUIObjectDisabled(oPC, JX_SCREEN_SPELLS_LEVELUP, "panSpellAdded" + IntToString(iLoopSpellSlot), TRUE);
			SetGUIObjectDisabled(oPC, JX_SCREEN_SPELLS_LEVELUP, "panSpellAdded" + IntToString(iLoopSpellSlot), FALSE);
		}

		// Disable the action button if the spell can't be removed
		if (JXSpellsKnownContainsSpell(selectedSpells, iSpellId, iCurrentSpellLevel))
			SetGUIObjectDisabled(oPC, JX_SCREEN_SPELLS_LEVELUP, "btnSpellAddedAction" + IntToString(iLoopSpellSlot), FALSE);
		else
		{
			if (iNbSpellsSwapped < iNbSpellsToSwap)
				SetGUIObjectDisabled(oPC, JX_SCREEN_SPELLS_LEVELUP, "btnSpellAddedAction" + IntToString(iLoopSpellSlot), FALSE);
			else
				SetGUIObjectDisabled(oPC, JX_SCREEN_SPELLS_LEVELUP, "btnSpellAddedAction" + IntToString(iLoopSpellSlot), TRUE);
		}

		// Set the icon for the current spell
		string sSpellIcon = Get2DAString("spells", "IconResRef", iSpellId) + ".tga";
		SetGUITexture(oPC, JX_SCREEN_SPELLS_LEVELUP, "btnSpellAddedImage" + IntToString(iLoopSpellSlot), sSpellIcon);
		// Set the name for the current spell
		int iSpellName = StringToInt(Get2DAString("spells", "Name", iSpellId));
		SetGUIObjectText(oPC, JX_SCREEN_SPELLS_LEVELUP, "btnSpellAddedText" + IntToString(iLoopSpellSlot), iSpellName, "");
	}
	// Hide unavailable spell slots
	for (iLoopSpellSlot = iNbSpellsAdded + 1; iLoopSpellSlot <= JX_SPBK_KNOWN_MAXSPELLS; iLoopSpellSlot++)
		SetGUIObjectHidden(oPC, JX_SCREEN_SPELLS_LEVELUP, "panSpellAdded" + IntToString(iLoopSpellSlot), TRUE);


	/*****************************************************************/
	/* Display the number of spells left for the current spell level */
	/*****************************************************************/

	// Get the number of spells the PC has to learn yet for the current spell level
	int iNbSpellsTotal;
	int iNbSpellsSelected;

	// Number of spells to learn is global to all spell levels
	iNbSpellsTotal = JXNbSpellsSelectGetNbSpells(nbSpellsSelect, -1);
	if (iNbSpellsTotal > 0)
		iNbSpellsSelected = JXNbSpellsSelectGetNbSpellsSelected(nbSpellsSelect, -1);
	// Number of spells to learn is specific to each spell level
	else
	{
		iNbSpellsTotal = JXNbSpellsSelectGetNbSpells(nbSpellsSelect, iCurrentSpellLevel);
		iNbSpellsSelected = JXNbSpellsSelectGetNbSpellsSelected(nbSpellsSelect, iCurrentSpellLevel);
	}

	// Compute the number of spells left to be selected
	int iNbSpellsLeft = iNbSpellsTotal - iNbSpellsSelected + iNbSpellsSwapped;

	// Display the number of spells left
	SetGUIObjectText(oPC, JX_SCREEN_SPELLS_LEVELUP, "txtSpellsLeft", -1, IntToString(iNbSpellsLeft));

	// Determine the state of the confirmation button
	int bSpellsSelected = JXPrivateAreSpellsSelected(nbSpellsSelect);
	if (bSpellsSelected)
		SetGUIObjectDisabled(oPC, JX_SCREEN_SPELLS_LEVELUP, "btnConfirm", FALSE);
	else
		SetGUIObjectDisabled(oPC, JX_SCREEN_SPELLS_LEVELUP, "btnConfirm", TRUE);


	/*********************************************************************/
	/* Display the number of description of the spell currently selected */
	/*********************************************************************/

	if (iCurrentSpell == -1)
	{
		// Empty the spell information fields
		SetGUITexture(oPC, JX_SCREEN_SPELLS_LEVELUP, "icoSpell", "b_empty.tga");
		SetGUIObjectText(oPC, JX_SCREEN_SPELLS_LEVELUP, "txtSpellTitle", -1, "");
		SetGUIObjectText(oPC, JX_SCREEN_SPELLS_LEVELUP, "txtSpellDescription", -1, "");
	}
	else
	{
		// Display the current spell's icon
		string sSpellIcon = Get2DAString("spells", "IconResRef", iCurrentSpell) + ".tga";
		SetGUITexture(oPC, JX_SCREEN_SPELLS_LEVELUP, "icoSpell", sSpellIcon);
		// Display the current spell's title
		int iSpellName = StringToInt(Get2DAString("spells", "Name", iCurrentSpell));
		SetGUIObjectText(oPC, JX_SCREEN_SPELLS_LEVELUP, "txtSpellTitle", iSpellName, "");
		// Display the current spell's description
		int iSpellDescription = StringToInt(Get2DAString("spells", "SpellDesc", iCurrentSpell));
		SetGUIObjectText(oPC, JX_SCREEN_SPELLS_LEVELUP, "txtSpellDescription", iSpellDescription, "");
	}
}