//::///////////////////////////////////////////////
//:: JX Spellbook - Spell selection GUI screen event: recommand selection
//:: gui_jx_spbk_splvl_level
//:://////////////////////////////////////////////
//:://////////////////////////////////////////////
//:: Created By: jallaix
//:: Created On: Nov 17, 2007
//:://////////////////////////////////////////////
//
// This script is fired when a player hits the recommand buton
// to complete the spells selection automatically.
// It selects the chosen spells into a spellbook.
//
//:://////////////////////////////////////////////

#include "jx_inc_spbk_process_spsel"




// Private function - Find the first row for the specified spell level
int JXPrivateFindStartingSpell(string sSpellPackage2da, int iSpellLevel, int iClass, int iFirstRow = 0)
{
	int iStep = 20;
	int iRowA = iFirstRow;
	int iRowB = iRowA + iStep;

	while (iRowA != iRowB)
	{
		string sSpellIdA = Get2DAString(sSpellPackage2da, "SpellIndex", iRowA);
		string sSpellIdB = Get2DAString(sSpellPackage2da, "SpellIndex", iRowB);
		if (((sSpellIdB == "") && (iStep == 1))
		 || ((sSpellIdB != "") && (JXGetBaseSpellLevel(StringToInt(sSpellIdB), iClass) > iSpellLevel)))
		{
			iRowA = iRowB + 1;
			iRowB = iRowA + iStep;
		}
		else
		{
			if (iStep == 1)
			{
				if ((sSpellIdA == "")
				 || ((sSpellIdA != "") && (JXGetBaseSpellLevel(StringToInt(sSpellIdA), iClass) != iSpellLevel)))
					iRowA = iRowB;
				else
					iRowB = iRowA;
			}
			else
			{
				iStep = iStep / 2;
				iRowB = iRowA + iStep;
			}
		}
	}

	return iRowA;
}


void main()
{
	object oPC = OBJECT_SELF;

	// Get the current class
	int iCurrentClass = GetLocalInt(oPC, JX_UI_SPELLS_LEVEL_CURRENTCLASS);

	// Determine if the level up package is associated with the class to level up
	int iPackage = GetLevelUpPackage(oPC);
	int iClassPackage = StringToInt(Get2DAString("packages", "ClassID", iPackage));
	if (iClassPackage != iCurrentClass)
		return;

	// Get the 2da file name that contains the list of recommanded spells
	string sSpellPackage2da = Get2DAString("packages", "SpellPref2DA", iPackage);

	// Get the current spell selection
	struct jx_nb_spells_select nbSpellsSelect = JXStringToNbSpellsSelect(GetLocalString(oPC, JX_UI_SPELLS_LEVEL_CURRENTNBSPELLS));
	struct jx_spells_known selectedSpells = JXStringToSpellsKnown(GetLocalString(oPC, JX_UI_SPELLS_LEVEL_SELECTEDSPELLS));
	struct jx_spells_known deselectedSpells = JXStringToSpellsKnown(GetLocalString(oPC, JX_UI_SPELLS_LEVEL_DESELECTEDSPELLS));

	// Get the list of spells the PC already knowns
	struct jx_spells_known spellsKnownLearned = JXRestoreSpellsKnown(oPC, iCurrentClass);
	struct jx_spells_known spellsKnownAdded = JXSpellsKnownAddSpellList(spellsKnownLearned, selectedSpells);
	spellsKnownAdded = JXSpellsKnownRemoveSpellList(spellsKnownAdded, deselectedSpells);

	// Get the spellbook level for the current class
	int iSpellbookLevel = JXGetSpellbookLevel(oPC, iCurrentClass);
	int iSpellbookLevelRestored = JXRestoreSpellbookLevel(oPC, iCurrentClass);
	// Determine the spellbook level to use
	if (iSpellbookLevelRestored < iSpellbookLevel)
		iSpellbookLevel = iSpellbookLevelRestored + 1;
	// Get the spell progression table for the class
	string sSpellProgression = Get2DAString("classes", "SpellGainTable", iCurrentClass);
	// Find the maximum spell level available for the current class
	int iMaxSpellLevel = StringToInt(Get2DAString(sSpellProgression, "NumSpellLevels", iSpellbookLevel - 1)) - 1;

	int iLoopSpellPackage = 0;
	int iLoopSpellLevel;
	for (iLoopSpellLevel = iMaxSpellLevel; iLoopSpellLevel >= 0; iLoopSpellLevel--)
	{
		// Get the number of spells that haven't been selected yet
		int iNbSpellsToSelect = JXNbSpellsSelectGetNbSpells(nbSpellsSelect, -1);
		int iNbSpellsSelected;
		if (iNbSpellsToSelect > 0)
			iNbSpellsSelected = JXNbSpellsSelectGetNbSpellsSelected(nbSpellsSelect, -1);
		else
		{
			iNbSpellsToSelect = JXNbSpellsSelectGetNbSpells(nbSpellsSelect, iLoopSpellLevel);
			iNbSpellsSelected = JXNbSpellsSelectGetNbSpellsSelected(nbSpellsSelect, iLoopSpellLevel);
		}
		int iNbSpellsSelectable = iNbSpellsToSelect - iNbSpellsSelected;

		// Find the first row in the 2DA file for the current spell level
		if (iNbSpellsSelectable > 0)
			iLoopSpellPackage = JXPrivateFindStartingSpell(sSpellPackage2da, iLoopSpellLevel, iCurrentClass, iLoopSpellPackage);

		// Loop through the missing selectable slots to complete them
		while (iNbSpellsSelectable > 0)
		{
			string sSpellIdPackage = Get2DAString(sSpellPackage2da, "SpellIndex", iLoopSpellPackage);
			if (sSpellIdPackage != "")
			{
				int iSpellIdPackage = StringToInt(sSpellIdPackage);

				if (JXSpellsKnownContainsSpell(deselectedSpells, iSpellIdPackage, iLoopSpellLevel))
				{
					// Define the number of spells swapped
					int iNbSpellsSwapped = JXNbSpellsSelectGetNbSpellsSwapped(nbSpellsSelect, iLoopSpellLevel);
					nbSpellsSelect = JXNbSpellsSelectSetNbSpellsSwapped(nbSpellsSelect, iLoopSpellLevel, iNbSpellsSwapped - 1);
					// Remove the spell found from the list of deselected spells
					deselectedSpells = JXSpellsKnownRemoveSpell(deselectedSpells, iSpellIdPackage, iLoopSpellLevel);
				}
				else if (!JXSpellsKnownContainsSpell(spellsKnownAdded, iSpellIdPackage, iLoopSpellLevel))
				{
					// Number of spells to select global to all spell levels
					if (JXNbSpellsSelectGetNbSpells(nbSpellsSelect, -1) > 0)
					{
						int iNbSpellsGlobalSelected = JXNbSpellsSelectGetNbSpellsSelected(nbSpellsSelect, -1);
						nbSpellsSelect = JXNbSpellsSelectSetNbSpellsSelected(nbSpellsSelect, -1, iNbSpellsGlobalSelected + 1);
					}
					// Number of spells to select specific to each spell level
					else
					{
						int iNbSpellsLevelSelected = JXNbSpellsSelectGetNbSpellsSelected(nbSpellsSelect, iLoopSpellLevel);	
						nbSpellsSelect = JXNbSpellsSelectSetNbSpellsSelected(nbSpellsSelect, iLoopSpellLevel, iNbSpellsLevelSelected + 1);
					}

					// Add the spell found to the list of selected spells
					selectedSpells = JXSpellsKnownAddSpell(selectedSpells, iLoopSpellLevel, iSpellIdPackage);
				}
			}
			else
				break;

			iLoopSpellPackage++;

			// Get the number of spells that haven't been selected yet
			if (JXNbSpellsSelectGetNbSpells(nbSpellsSelect, -1) > 0)
				iNbSpellsSelected = JXNbSpellsSelectGetNbSpellsSelected(nbSpellsSelect, -1);
			else
				iNbSpellsSelected = JXNbSpellsSelectGetNbSpellsSelected(nbSpellsSelect, iLoopSpellLevel);
			iNbSpellsSelectable = iNbSpellsToSelect - iNbSpellsSelected;
		}
	}

	SetLocalString(oPC, JX_UI_SPELLS_LEVEL_CURRENTNBSPELLS, JXNbSpellsSelectToString(nbSpellsSelect));
	SetLocalString(oPC, JX_UI_SPELLS_LEVEL_SELECTEDSPELLS, JXSpellsKnownToString(selectedSpells));
	SetLocalString(oPC, JX_UI_SPELLS_LEVEL_DESELECTEDSPELLS, JXSpellsKnownToString(deselectedSpells));	

	DelayCommand(0.0, JXUpdateGUISpellLevelUp(oPC));
}