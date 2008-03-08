//::///////////////////////////////////////////////
//:: JX Spellbook - Spells known replenishment
//:: jx_spbk_replenish_kwn
//:://////////////////////////////////////////////
//:://////////////////////////////////////////////
//:: Created By: jallaix
//:: Created On: Nov 16, 2007
//:://////////////////////////////////////////////
//
// This script is fired by the "jx_spbk_replenish" script.
// It manages the replenishment of known spells.
//
//:://////////////////////////////////////////////

#include "jx_inc_spbk_process_spsel"
#include "jx_inc_spbk_process_sprdy"




void main()
{
	object oPC = OBJECT_SELF;

	// Get the current class
	int iClassPosition = GetLocalInt(oPC, JX_REPLENISH_CLASS_POSITION);
	int iClass = GetClassByPosition(iClassPosition, oPC);
	// Get the current spell level
	int iSpellLevel = GetLocalInt(oPC, JX_REPLENISH_SPELL_LEVEL);
	// Get the current list of spells known for the UI
	struct jx_spells_known_ui spellsKnownUI = JXStringToSpellsKnownUI(GetLocalString(oPC, JX_REPLENISH_SPELL_LIST));
	// Get the current list of ready spells
	struct jx_spells_ready spellsReady = JXRestoreSpellsReady(oPC, iClass);
	struct jx_spell_known_ui spellKnownUI;

	// Loop through the lists of spells known for the UI (normal, metamagic1, metamagic2, ...)
	int iNbSpellList = JXSpellsKnownUIGetNbSpellLists(spellsKnownUI);
	int iLoopSpellList;
	for (iLoopSpellList = 0; iLoopSpellList <= iNbSpellList; iLoopSpellList++)
	{
		// Loop through the spells defined in the current list
		int iNbSpellSlot = JXSpellsKnownUIGetNbSpellsForList(spellsKnownUI, iLoopSpellList);
		int iLoopSpellSlot;
		for (iLoopSpellSlot = 1; iLoopSpellSlot <= iNbSpellSlot; iLoopSpellSlot++)
		{
			// Add the spell found in the list of spells ready to be cast
			spellKnownUI = JXSpellsKnownUIGetSpell(spellsKnownUI, iLoopSpellList, iLoopSpellSlot);
			int bSpellMaster = (Get2DAString("spells", "SubRadSpell1", spellKnownUI.iSpellId) == "") ? FALSE : TRUE;
			spellsReady = JXSpellsReadyAddSpell(spellsReady, iSpellLevel, spellKnownUI, bSpellMaster, TRUE);
		}
	}

	// Define the number of spells for the current spell level
	int iSpellbookLevel = JXRestoreSpellbookLevel(oPC, iClass);
	struct jx_spells_per_day spellsDay = JXGetSpellsPerDay(oPC, iClass, iSpellbookLevel);
	int iNbSpells = JXSpellsDayGetNbSpells(spellsDay, iSpellLevel);
	spellsReady = JXSpellsReadySetNbGlobalSpells(spellsReady, iSpellLevel, iNbSpells);

	// Save the list of ready spells
	JXSaveSpellsReady(oPC, iClass, spellsReady);

	// Continue the replenishment for the next class
	SetLocalInt(oPC, JX_REPLENISH_CLASS_POSITION, iClassPosition + 1);
	DelayCommand(0.0, ExecuteScript("jx_spbk_replenish", oPC));
}