//::///////////////////////////////////////////////
//:: JX Spellbook - Spells replenishment
//:: jx_spbk_replenish
//:://////////////////////////////////////////////
//:://////////////////////////////////////////////
//:: Created By: jallaix
//:: Created On: Nov 16, 2007
//:://////////////////////////////////////////////
//
// This script is fired by the JXReplenishSpellSlots() function.
// It manages the replenishment process and the replenishment
// of memorized spells.
//
//:://////////////////////////////////////////////

#include "jx_inc_spbk_process_sprdy"




void main()
{
	object oPC = OBJECT_SELF;

	// Determine if the spell slots for the next spell level have to be replenished, so stop
	// if the PC cancelled the resting process (if this script is called in a resting process !)
	float fFrequency = GetLocalFloat(oPC, JX_REPLENISH_FREQUENCY);
	if (!GetIsResting(oPC) && (fFrequency != 0.0))
	{
		DeleteLocalInt(oPC, JX_REPLENISH_SPELL_LEVEL);
		DeleteLocalInt(oPC, JX_REPLENISH_CLASS_POSITION);
		DeleteLocalString(oPC, JX_REPLENISH_SPELL_LIST);
		DeleteLocalFloat(oPC, JX_REPLENISH_FREQUENCY);
		return;
	}

	// Find the current class position (0 the first time the script is run)
	int iClassPosition = GetLocalInt(oPC, JX_REPLENISH_CLASS_POSITION);
	if (iClassPosition == 0)
	{
		iClassPosition = 1;
		SetLocalInt(oPC, JX_REPLENISH_CLASS_POSITION, 1);
	}

	// Get the current spell level to ready
	int iSpellLevel = GetLocalInt(oPC, JX_REPLENISH_SPELL_LEVEL);
	// Get the class for the current position
	int iClass = GetClassByPosition(iClassPosition, oPC);
	// No class is found for the current position
	if (iClass == CLASS_TYPE_INVALID)
	{
		// The last spell level is attained, so the replenishment is ready
		if (iSpellLevel == 9)
		{
			DeleteLocalInt(oPC, JX_REPLENISH_SPELL_LEVEL);
			DeleteLocalInt(oPC, JX_REPLENISH_CLASS_POSITION);
			DeleteLocalString(oPC, JX_REPLENISH_SPELL_LIST);
			DeleteLocalFloat(oPC, JX_REPLENISH_FREQUENCY);
			// Update the quick spells GUI screen
			JXUpdateGUISpellQuick(oPC);
			return;
		}
		// Start the replenishment for the next spell level
		else
		{
			SetLocalInt(oPC, JX_REPLENISH_SPELL_LEVEL, iSpellLevel + 1);
			SetLocalInt(oPC, JX_REPLENISH_CLASS_POSITION, 1);
			// Update the quick spells GUI screen
			JXUpdateGUISpellQuick(oPC);
			// Decrease the delay for the last spell level, else it occurs after the player has rested
			if ((fFrequency > 0.0) && ((iSpellLevel + 1) == 9))
			{
				DelayCommand(fFrequency - 0.1, ExecuteScript("jx_spbk_replenish", oPC));
			}
			else
				DelayCommand(fFrequency, ExecuteScript("jx_spbk_replenish", oPC));
			return;
		}
	}

	// The current class doesn't have any spellbook, so try with the next class
	if (!JXGetHasSpellbook(oPC, iClass))
	{
		SetLocalInt(oPC, JX_REPLENISH_CLASS_POSITION, iClassPosition + 1);
		DelayCommand(0.0, ExecuteScript("jx_spbk_replenish", oPC));
		return;
	}

	// The process of replenishment is not the same the spells are memorized or not
	if (JXClassGetMemorizesSpells(iClass))
	{
		// Get the spells memorized by the PC for the current class
		struct jx_spells_memorized spellsMemorized = JXRestoreSpellsMemorized(oPC, iClass);
		// Get the spells ready by the PC for the current spell level
		struct jx_spells_ready spellsReadyToSet = JXSpellsReadyFromSpellsMemorizedUI(spellsMemorized, iSpellLevel);

		// Update the list of ready spells for the current class
		struct jx_spells_ready spellsReady = JXRestoreSpellsReady(oPC, iClass);
		spellsReady = JXSpellsReadySetSpellsForLevel(spellsReady, iSpellLevel, spellsReadyToSet);
		JXSaveSpellsReady(oPC, iClass, spellsReady);

		// Continue the replenishment for the next class
		SetLocalInt(oPC, JX_REPLENISH_CLASS_POSITION, iClassPosition + 1);
		DelayCommand(0.0, ExecuteScript("jx_spbk_replenish", oPC));
	}
	else
	{
		// Get the spells known by the PC for the current class
		struct jx_spells_known spellsKnown = JXRestoreSpellsKnown(oPC, iClass);
		// Get the spells known for the UI by the PC for the current spell level (with metamagic)
		struct jx_spells_known_ui spellsKnownUI = JXSpellsKnownUIFromSpellsKnown(oPC, iClass, spellsKnown, iSpellLevel);

		// Save the list of spells known for the UI
		SetLocalString(oPC, JX_REPLENISH_SPELL_LIST, JXSpellsKnownUIToString(spellsKnownUI));
	
		// Call the script that will transform the current list of spells known for the UI into a list of ready spells
		DelayCommand(0.0, ExecuteScript("jx_spbk_replenish_kwn", oPC));
	}
}