//::///////////////////////////////////////////////
//:: JX Spellbook - Spell selection GUI screen event: screen displayed
//:: gui_jx_spbk_splvl_level
//:://////////////////////////////////////////////
//:://////////////////////////////////////////////
//:: Created By: jallaix
//:: Created On: Nov 14, 2007
//:://////////////////////////////////////////////
//
// This script is fired when the spell selection GUI screen is displayed.
// It compute the number of spells to select and update the screen informations.
//
//:://////////////////////////////////////////////

#include "jx_inc_spbk_process_spsel"




void main()
{
	object oPC = OBJECT_SELF;

	// Get the class for which the spell selection is done
	int iCurrentClass = GetLocalInt(oPC, JX_UI_SPELLS_LEVEL_CURRENTCLASS);

	// Get the spellbook level for the current class
	int iSpellbookLevel = JXGetSpellbookLevel(oPC, iCurrentClass);
	int iSpellbookLevelRestored = JXRestoreSpellbookLevel(oPC, iCurrentClass);

	// Determine the spellbook level to use
	if (iSpellbookLevelRestored < iSpellbookLevel)
		iSpellbookLevel = iSpellbookLevelRestored + 1;
	// Immediately close the spell selection screen if the spellbook is up-to-date
	else
	{
		CloseGUIScreen(oPC, JX_SCREEN_SPELLS_LEVELUP);
		return;
	}

	// Compute the number of spells to select
	struct jx_nb_spells_select nbSpellsSelect = JXComputeNbSpellsToSelect(oPC, iCurrentClass, iSpellbookLevel);

	// Save the number of spells to be learned
	SetLocalString(oPC, JX_UI_SPELLS_LEVEL_CURRENTNBSPELLS, JXNbSpellsSelectToString(nbSpellsSelect));

	// Update the level up GUI screen
	SetLocalInt(oPC, JX_UI_SPELLS_LEVEL_CURRENTSPELL, -1);
	DelayCommand(0.0, JXUpdateGUISpellLevelUp(oPC));
}