//::///////////////////////////////////////////////
//:: JX Spellbook - Spell selection GUI screen event: remove spell
//:: gui_jx_spbk_splvl_removespell
//:://////////////////////////////////////////////
//:://////////////////////////////////////////////
//:: Created By: jallaix
//:: Created On: Nov 14, 2007
//:://////////////////////////////////////////////
//
// This script is fired when a player tries to remove
// a spell from its own selection of spells.
//
//:://////////////////////////////////////////////

#include "jx_inc_spbk_process_spsel"




void main(string sDataString)
{
	object oPC = OBJECT_SELF;

	// Get the slot of the spell to remove
	int iSpellSlot = StringToInt(GetSubString(sDataString, 22, 2));

	// Remove the selected spell from the player's selection
	JXRemoveSpellGUISpellLevelUp(oPC, iSpellSlot);

	// Update the level up GUI screen
	DelayCommand(0.0, JXUpdateGUISpellLevelUp(oPC));
}