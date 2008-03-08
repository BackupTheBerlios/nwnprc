//::///////////////////////////////////////////////
//:: JX Spellbook - Spells ready GUI screen event: screen displayed
//:: gui_jx_spbk_spqck_open
//:://////////////////////////////////////////////
//:://////////////////////////////////////////////
//:: Created By: jallaix
//:: Created On: Nov 16, 2007
//:://////////////////////////////////////////////
//
// This script is fired when the quick spells GUI screen is displayed.
// It simply updates the informations contained in this screen.
//
//:://////////////////////////////////////////////

#include "jx_inc_spbk_process_sprdy"




void main()
{
	object oPC = OBJECT_SELF;

	// Update the quick spells GUI screen
	JXUpdateGUISpellQuick(oPC);
}