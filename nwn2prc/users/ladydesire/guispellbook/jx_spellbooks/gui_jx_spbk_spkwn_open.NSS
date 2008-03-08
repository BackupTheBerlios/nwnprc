//::///////////////////////////////////////////////
//:: JX Spellbook - Spells known GUI screen event: screen displayed
//:: gui_jx_spbk_spkwn_open
//:://////////////////////////////////////////////
//:://////////////////////////////////////////////
//:: Created By: jallaix
//:: Created On: Nov 14, 2007
//:://////////////////////////////////////////////
//
// This script is fired when the spells known GUI screen is displayed.
// It updates the spell list, then opens the screen of memorized spells if necessary.
//
//:://////////////////////////////////////////////

#include "jx_inc_spbk_process_spkwn"




void main()
{
	object oPC = OBJECT_SELF;

	// Update the GUI screen
	JXUpdateGUISpellKnown(oPC);

	// Check if the current spellbook needs its spells to be memorized
	JXCheckSpellbookToMemorize(oPC);
}