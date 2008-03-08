//::///////////////////////////////////////////////
//:: JX Spellbook - Spell selection GUI screen event: add spell
//:: gui_jx_spbk_splvl_addspell
//:://////////////////////////////////////////////
//:://////////////////////////////////////////////
//:: Created By: jallaix
//:: Created On: Nov 14, 2007
//:://////////////////////////////////////////////
//
// This script is fired when a player tries to add a spell
// in its own selection of spells.
//
//:://////////////////////////////////////////////

#include "jx_inc_spbk_process_spsel"




void main(string sDataString)
{
	object oPC = OBJECT_SELF;

	// Get the slot of the spell to add
	int iSpellSlot = StringToInt(GetSubString(sDataString, 22, 2));

	// Add the selected spell to the player's selection
	JXAddSpellGUISpellLevelUp(oPC, iSpellSlot);

	// Update the level up GUI screen
	DelayCommand(0.0, JXUpdateGUISpellLevelUp(oPC));
}