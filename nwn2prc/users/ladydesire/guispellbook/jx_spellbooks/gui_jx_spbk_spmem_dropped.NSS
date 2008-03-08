//::///////////////////////////////////////////////
//:: JX Spellbook - Spells memorized GUI screen event: spell dropped
//:: gui_jx_spbk_spmem_dropped
//:://////////////////////////////////////////////
//:://////////////////////////////////////////////
//:: Created By: jallaix
//:: Created On: Nov 16, 2007
//:://////////////////////////////////////////////
//
// This script is fired when a player drags a spell from any GUI
// screen and drops it in a slot of the memorized spells GUI screen.
// If the spell is dragged from the spells known GUI screen,
// it is added to the memorized spells GUI screen.
// If the spell is dragged from the spells memorized GUI screen,
// it is swapped with the spell contained in the current spell slot.
// Finally the screen is updated.
//
//:://////////////////////////////////////////////

#include "jx_inc_spbk_process_spkwn"
#include "jx_inc_spbk_process_spmem"




void main(string sDataString)
{
	object oPC = OBJECT_SELF;

	// Get the information about the UI object dropped
	string sOrigin = GetLocalString(oPC, JX_UI_MOUSESTARTDRAG);
	if (sOrigin == "") return;

	// Get the spell slot to set the spell
	string sMemoSlotInfo = GetSubString(sDataString, 14, 5);
	int iMemoSpellLevel = StringToInt(JXStringSplit(sMemoSlotInfo, "_", 0));
	int iMemoSpellSlot = StringToInt(JXStringSplit(sMemoSlotInfo, "_", 1));

	// Invalidate the drag & drop process
	DeleteLocalString(oPC, JX_UI_MOUSESTARTDRAG);

	// The object dropped is a spell known
	if (GetStringLeft(sOrigin, 14) == "JX_SPELL_KNOWN")
	{
		// Get the current class
		int iClass = GetLocalInt(oPC, JX_UI_SPELLS_KNOWN_CURRENTCLASS);
		// Get the current spell level
		int iKnownSpellLevel = GetLocalInt(oPC, JX_UI_SPELLS_KNOWN_CURRENTLEVEL);

		// Impossible to memorize a spell in a slot reserved for a inferior spell level
		if (iKnownSpellLevel > iMemoSpellLevel)
			return;

		// Find the spell list and the spell slot from known spells
		int iKnownSpellList;
		int iKnownSpellSlot;
		if (GetSubString(sOrigin, 15, 6) == "NORMAL")
		{
			iKnownSpellList = 0;
			iKnownSpellSlot = StringToInt(GetSubString(sOrigin, 22, 2));
		}
		else if (GetSubString(sOrigin, 15, 4) == "META")
		{
			iKnownSpellList = StringToInt(GetSubString(JXStringSplit(sOrigin, "_", 3), 4, 2));
			iKnownSpellSlot = StringToInt(JXStringSplit(sOrigin, "_", 4));
		}
		else
			SendMessageToPC(oPC, "gui_jx_spbk_spmem_dropped : Invalid data string");

		// Get the list of known spells
		struct jx_spells_known_ui spellsKnownUI = JXStringToSpellsKnownUI(GetLocalString(oPC, JX_UI_SPELLS_KNOWN_CURRENTLIST));

		// Get the spell at the row from the list
		struct jx_spell_known_ui spellKnownUI = JXSpellsKnownUIGetSpell(spellsKnownUI, iKnownSpellList, iKnownSpellSlot);

		// Memorize the spell and update the GUI screen of memorized spells
		JXAddSpellMemorized(oPC, iClass, spellKnownUI, iMemoSpellLevel, iMemoSpellSlot);
		JXUpdateGUISpellMemorized(oPC);
	}

	// The object dropped is a spell memorized
	if (GetStringLeft(sOrigin, 13) == "JX_SPELL_MEMO")
	{
		// Get the current class
		int iClass = GetLocalInt(oPC, JX_UI_SPELLS_KNOWN_CURRENTCLASS);

		// Get the spell slot to get the spell from
		string sSlotInfoOrigin = GetSubString(sOrigin, 14, 5);
		int iSpellLevelOrigin = StringToInt(JXStringSplit(sSlotInfoOrigin, "_", 0));
		int iSpellSlotOrigin = StringToInt(JXStringSplit(sSlotInfoOrigin, "_", 1));

		struct jx_spells_memorized spellsMemorized = JXRestoreSpellsMemorized(oPC, iClass);
		struct jx_spell_known_ui spellKnownUI = JXSpellsMemorizedUIGetSpell(spellsMemorized, iSpellLevelOrigin, iSpellSlotOrigin);
		
		// Impossible to memorize a spell in a slot reserved for a inferior spell level
		if (JXGetBaseSpellLevel(spellKnownUI.iSpellId, iClass) > iMemoSpellLevel)
			return;

		// Move the spell to its new slot
		if (spellKnownUI.iSpellId != -1)
		{
			// Remove the spell that is moved
			JXRemoveSpellMemorized(oPC, iClass, iSpellLevelOrigin, iSpellSlotOrigin);
			// Add the moved spell at the old spell's slot
			JXAddSpellMemorized(oPC, iClass, spellKnownUI, iMemoSpellLevel, iMemoSpellSlot);
	
			// Move the spell between the GUI buttons
			JXUpdateGUISpellMemorized(oPC);
		}
	}
}