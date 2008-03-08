//::///////////////////////////////////////////////
//:: JX Spellbook - Spells memorized GUI screen event: screen displayed
//:: gui_jx_spbk_spmem_open
//:://////////////////////////////////////////////
//:://////////////////////////////////////////////
//:: Created By: jallaix
//:: Created On: Nov 16, 2007
//:://////////////////////////////////////////////
//
// This script is fired when the memorized spells GUI screen is displayed.
// It simply updates the informations contained in this screen.
//
//:://////////////////////////////////////////////

#include "jx_inc_spbk_process_spmem"




void main()
{
	object oPC = OBJECT_SELF;

	JXUpdateGUISpellMemorized(oPC);
}