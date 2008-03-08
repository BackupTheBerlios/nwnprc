//::///////////////////////////////////////////////
//:: JX Spellbook - Spells memorized GUI screen event: spell drop failed
//:: gui_jx_spbk_spmem_dropfailed
//:://////////////////////////////////////////////
//:://////////////////////////////////////////////
//:: Created By: jallaix
//:: Created On: Nov 16, 2007
//:://////////////////////////////////////////////
//
// This script is fired when a player drags a spell from the spells
// memorized GUI screen and drops it at an invalid location.
// It removes the spell dragged from the list of memorized spells
// then updates the screen.
//
//:://////////////////////////////////////////////

#include "jx_inc_spbk_process_spmem"




void main(string sDataString)
{
	object oPC = OBJECT_SELF;

	string sDataString = GetLocalString(oPC, JX_UI_MOUSESTARTDRAG);
	DeleteLocalString(oPC, JX_UI_MOUSESTARTDRAG);

	// Get the spell slot to free
	string sSlotInfo = GetSubString(sDataString, 14, 5);
	int iSpellLevel = StringToInt(JXStringSplit(sSlotInfo, "_", 0));
	int iSpellSlot = StringToInt(JXStringSplit(sSlotInfo, "_", 1));

	// Remove the spell from the list of memorized spells
	int iClass = GetLocalInt(oPC, JX_UI_SPELLS_KNOWN_CURRENTCLASS);
	JXRemoveSpellMemorized(oPC, iClass, iSpellLevel, iSpellSlot);

	// Remove the spell from the GUI button
	JXUpdateGUISpellMemorized(oPC);
}