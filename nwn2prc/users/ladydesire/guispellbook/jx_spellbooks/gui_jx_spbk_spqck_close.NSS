//::///////////////////////////////////////////////
//:: JX Spellbook - Spells ready GUI screen event: screen hidden
//:: gui_jx_spbk_spqck_close
//:://////////////////////////////////////////////
//:://////////////////////////////////////////////
//:: Created By: jallaix
//:: Created On: Nov 16, 2007
//:://////////////////////////////////////////////
//
// This script is fired when the quick spells GUI screen is hidden.
// It simply clean the temporary variables used in this screen.
//
//:://////////////////////////////////////////////

#include "jx_inc_spbk_process_sprdy"




void main()
{
	object oPC = OBJECT_SELF;

	// Delete the temporary local variable used in this screen
	DeleteLocalString(oPC, JX_UI_SPELLS_SBSPL_CURRENTLIST);
}