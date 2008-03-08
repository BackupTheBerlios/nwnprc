//::///////////////////////////////////////////////
//:: JX Spellbook - Spell selection GUI screen event: commit selection
//:: gui_jx_spbk_splvl_level
//:://////////////////////////////////////////////
//:://////////////////////////////////////////////
//:: Created By: jallaix
//:: Created On: Nov 14, 2007
//:://////////////////////////////////////////////
//
// This script is fired when a player has finished a spell selection and commits.
// It saves the choosen spells into his spellbook.
//
//:://////////////////////////////////////////////

#include "jx_inc_spbk_process_spsel"
#include "jx_inc_spbk_process_spmem"




void main()
{
	object oPC = OBJECT_SELF;

	// Get the selected class and the selected spells
	int iCurrentClass = GetLocalInt(oPC, JX_UI_SPELLS_LEVEL_CURRENTCLASS);
	struct jx_spells_known selectedSpells = JXStringToSpellsKnown(GetLocalString(oPC, JX_UI_SPELLS_LEVEL_SELECTEDSPELLS));

	// Get the list of spells that the PC already knowns
	struct jx_spells_known spellsKnownLearned = JXRestoreSpellsKnown(oPC, iCurrentClass);
	// Add the list of selected spells to the list the PC already knowns
	spellsKnownLearned = JXSpellsKnownAddSpellList(spellsKnownLearned, selectedSpells);
	// Save the updated list and update the spells known GUI screen
	JXSaveSpellsKnown(oPC, iCurrentClass, spellsKnownLearned);
	DelayCommand(0.0, JXUpdateGUISpellKnown(oPC));

	// Save the updated spellbook level
	int iSpellbookLevel = JXRestoreSpellbookLevel(oPC, iCurrentClass);
	iSpellbookLevel++;
	JXSaveSpellbookLevel(oPC, iCurrentClass, iSpellbookLevel);

	// Update the list of memorized spells and update the spells memorized GUI screen
	struct jx_spells_memorized spellsMemorized = JXRestoreSpellsMemorized(oPC, iCurrentClass);
	struct jx_spells_per_day spellsDay = JXGetSpellsPerDay(oPC, iCurrentClass, iSpellbookLevel);
	spellsMemorized = JXSpellsMemorizedUIUpdateSize(spellsMemorized, spellsDay);
	JXSaveSpellsMemorized(oPC, iCurrentClass, spellsMemorized);
	DelayCommand(0.0, JXUpdateGUISpellMemorized(oPC));

	// Clear the local variables
	DeleteLocalInt(oPC, JX_UI_SPELLS_LEVEL_CURRENTCLASS);
//	DeleteLocalInt(oPC, JX_UI_SPELLS_LEVEL_CURRENTLEVEL);
	DeleteLocalString(oPC, JX_UI_SPELLS_LEVEL_CURRENTNBSPELLS);
	DeleteLocalString(oPC, JX_UI_SPELLS_LEVEL_SELECTEDSPELLS);

	// Update the spellbooks for the PC if necessary
	JXCheckSpellbooksToUpdate(oPC, TRUE);
}