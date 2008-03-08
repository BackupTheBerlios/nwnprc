//::///////////////////////////////////////////////
//:: JX Spellbook - Level up GUI screen event: select spell level
//:: gui_jx_spbk_splvl_level
//:://////////////////////////////////////////////
//:://////////////////////////////////////////////
//:: Created By: jallaix
//:: Created On: Nov 14, 2007
//:://////////////////////////////////////////////
//
// This script is fired when a player choose a spell level in the GUI screen.
// It updates the screen to reflect the informations that depend on this spell level.
//
//:://////////////////////////////////////////////

#include "jx_inc_spbk_process_spsel"



void main(string sSpellLevel)
{
	object oPC = OBJECT_SELF;

	// Save the current spell level
	int iSpellLevel = StringToInt(GetSubString(sSpellLevel, 6, 2));
	SetLocalInt(oPC, JX_UI_SPELLS_LEVEL_CURRENTLEVEL, iSpellLevel);

	// Display the list of known spells
	JXUpdateGUISpellLevelUp(oPC);
}