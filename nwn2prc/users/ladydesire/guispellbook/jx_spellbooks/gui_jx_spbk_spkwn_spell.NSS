//::///////////////////////////////////////////////
//:: JX Spellbook - Spells known GUI screen event: choose spell
//:: gui_jx_spbk_spkwn_level
//:://////////////////////////////////////////////
//:://////////////////////////////////////////////
//:: Created By: jallaix
//:: Created On: Nov 14, 2007
//:://////////////////////////////////////////////
//
// This script is fired when a player chooses a spell.
// It adds the spell in the memorized spells GUI screen.
//
//:://////////////////////////////////////////////

#include "jx_inc_spbk_process_spkwn"
#include "jx_inc_spbk_process_spmem"




void main(string sDataString)
{
	object oPC = OBJECT_SELF;

	// Invalidate the drag & drop process
	DeleteLocalString(oPC, JX_UI_MOUSESTARTDRAG);

	// Get the current class and spell level
	int iCurrentClass = GetLocalInt(oPC, JX_UI_SPELLS_KNOWN_CURRENTCLASS);
	int iCurrentSpellLevel = GetLocalInt(oPC, JX_UI_SPELLS_KNOWN_CURRENTLEVEL);

	// Immediately return if the class doesn't memorize spells
	if (!JXClassGetMemorizesSpells(iCurrentClass))
		return;

	// Get the spell list and spell slot chosen by the player
	int iSpellList;
	int iSpellSlot;
	if (GetSubString(sDataString, 15, 6) == "NORMAL")
	{
		iSpellList = 0;
		iSpellSlot = StringToInt(GetSubString(sDataString, 22, 2));
	}
	else if (GetSubString(sDataString, 15, 4) == "META")
	{
		iSpellList = StringToInt(GetSubString(JXStringSplit(sDataString, "_", 3), 4, 2));
		iSpellSlot = StringToInt(JXStringSplit(sDataString, "_", 4));
	}
	else
		SendMessageToPC(oPC, "gui_jx_spbk_spkwn_spell : Invalid data string");

	// Get the spells known by the PC for the specified class
	struct jx_spells_known spellsKnown = JXRestoreSpellsKnown(oPC, iCurrentClass);
	// Find the list of spells known for the UI
	struct jx_spells_known_ui spellsKnownUI = JXSpellsKnownUIFromSpellsKnown(oPC, iCurrentClass, spellsKnown, iCurrentSpellLevel);

	// Add the chosen spell to the list of memorized spells
	struct jx_spell_known_ui spellKnownUI = JXSpellsKnownUIGetSpell(spellsKnownUI, iSpellList, iSpellSlot);
	JXAddSpellMemorized(oPC, iCurrentClass, spellKnownUI, iCurrentSpellLevel);
	DelayCommand(0.0, JXUpdateGUISpellMemorized(oPC));
}