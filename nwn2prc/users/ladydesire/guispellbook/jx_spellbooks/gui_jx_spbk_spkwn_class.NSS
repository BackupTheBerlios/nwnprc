//::///////////////////////////////////////////////
//:: JX Spellbook - Spells known GUI screen event: choose class
//:: gui_jx_spbk_spkwn_class
//:://////////////////////////////////////////////
//:://////////////////////////////////////////////
//:: Created By: jallaix
//:: Created On: Nov 14, 2007
//:://////////////////////////////////////////////
//
// This script is fired when a player chooses a class.
// It checks if the current spell level is possible for the class,
// then update the spell list.
// Finally it opens the screen of memorized spells if necessary.
//
//:://////////////////////////////////////////////

#include "jx_inc_spbk_process_spkwn"




void main(string sClass)
{
	object oPC = OBJECT_SELF;

	// Get the current class
	int iCurrentClass = GetLocalInt(oPC, JX_UI_SPELLS_KNOWN_CURRENTCLASS);

	// Save the new class if available
	if (sClass != "")
	{
		iCurrentClass = StringToInt(GetSubString(sClass, 6, 2));
		SetLocalInt(oPC, JX_UI_SPELLS_KNOWN_CURRENTCLASS, iCurrentClass);
	}

	// Invalidate the current spell level if not available for this class
	JXCheckSpellLevelAvailability(oPC);

	// Update the GUI screen
	JXUpdateGUISpellKnown(oPC);

	// Check if the current spellbook needs its spells to be memorized
	JXCheckSpellbookToMemorize(oPC);
}