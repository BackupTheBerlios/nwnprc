//::///////////////////////////////////////////////
//:: JX Spellbook - Spells Known Data include
//:: jx_inc_spbk_data_spkwn
//:://////////////////////////////////////////////
//:://////////////////////////////////////////////
//:: Created By: jallaix
//:: Created On: Dec 9, 2007
//:://////////////////////////////////////////////
//
// This include file provides functions to manage
// spells known-related data.
//
// It provides the following functions :
//
// * Get a spell known
// * Add a spell known
// * Remove a spell known
// * Add a list of spells known
// * Remove a list of spells known
// * Get the number of spells for a spell level
// * Get the slot for a spell
// * Create a new empty set of spells known
// * Convert a set of spells known into a string
// * Convert a string into a set of spells known
//
//:://////////////////////////////////////////////

#include "jx_inc_array_fixed"
#include "jx_inc_array_delim"

















//**************************************//
//                                      //
//              Interface               //
//                                      //
//**************************************//


// List of known spells
struct jx_spells_known
{
	string sSpellsKnownLevel0;
	string sSpellsKnownLevel1;
	string sSpellsKnownLevel2;
	string sSpellsKnownLevel3;
	string sSpellsKnownLevel4;
	string sSpellsKnownLevel5;
	string sSpellsKnownLevel6;
	string sSpellsKnownLevel7;
	string sSpellsKnownLevel8;
	string sSpellsKnownLevel9;
	string sSpellsKnownLevel10;
	int iMaxSpellLevel;
};


// Get a spell from a list of known spells
// - spellsKnown List of known spells
// - iSpellLevel Spell level (from 0 to 10)
// - iSpellSlot Slot of the spell to get (from 1 to 30)
// * Returns the desired spell
int JXSpellsKnownGetSpell(struct jx_spells_known spellsKnown, int iSpellLevel, int iSpellSlot);

// Add a spell to a list of known spells
// - spellsKnown List of known spells
// - iSpellLevel Spell level (from 0 to 10)
// - iSpellId SPELL_* constant
// * Returns the updated list of known spells
struct jx_spells_known JXSpellsKnownAddSpell(struct jx_spells_known spellsKnown, int iSpellLevel, int iSpellId);

// Remove a spell from a list of known spells
// - spellsKnown List of known spells
// - iSpellId SPELL_* constant
// - iSpellLevel Spell level from which the spell must be removed (for better performances)
// * Returns the updated list of known spells
struct jx_spells_known JXSpellsKnownRemoveSpell(struct jx_spells_known spellsKnown, int iSpellId, int iSpellLevel = -1);

// Add a spell list to a list of known spells
// - spellsKnown List of known spells
// - spellsToAdd List of spells to add
// * Returns the updated list of known spells
struct jx_spells_known JXSpellsKnownAddSpellList(struct jx_spells_known spellsKnown, struct jx_spells_known spellsToAdd);

// Remove a spell list from a list of known spells
// - spellsKnown List of known spells
// - spellsToRemove List of spells to remove
// - iSpellLevel Spell level from which the spells must be removed (for better performances)
// * Returns the updated list of known spells
struct jx_spells_known JXSpellsKnownRemoveSpellList(struct jx_spells_known spellsKnown, struct jx_spells_known spellsToRemove, int iSpellLevel = -1);

// Get the number of spells available in the list for the specified level
// - spellsKnown List of known spells
// - iSpellLevel Spell level
// * Return the number of spells available for the spell level
int JXSpellsKnownGetNbSpellsForLevel(struct jx_spells_known spellsKnown, int iSpellLevel);

// Determine if a list of known spells contains a specific spell
// - spellsKnown List of known spells
// - iSpellId SPELL_* constant
// - iSpellLevel Spell level from which the spell must be tested (for better performances)
// * Returns the spell slot if the specified spell is found in the list, else returns 0
int JXSpellsKnownContainsSpell(struct jx_spells_known spellsKnown, int iSpellId, int iSpellLevel = -1);

// Create a new empty set of spells known
// * Returns a new set of spells known
struct jx_spells_known JXSpellsKnownCreateStruct();

// Transform a list of known spells into a string
// - spellsKnown List of known spells
// * Returns a list of known spells in a string form
string JXSpellsKnownToString(struct jx_spells_known spellsKnown);

// Transform a list of known spells into a structure
// - sSpellsKnown List of known spells
// * Returns a list of known spells in a structure form
struct jx_spells_known JXStringToSpellsKnown(string sSpellsKnown);
















//**************************************//
//                                      //
//            Implementation            //
//                                      //
//**************************************//


const int JX_SPBK_DATA_KNOWN_ELEMSIZE = 5;
const int JX_SPBK_KNOWN_MAXSPELLS = 40;


// Get a spell from a list of known spells
// - spellsKnown List of known spells
// - iSpellLevel Spell level (from 0 to 10)
// - iSpellSlot Slot of the spell to get (from 1 to 30)
// * Returns the desired spell
int JXSpellsKnownGetSpell(struct jx_spells_known spellsKnown, int iSpellLevel, int iSpellSlot)
{
	if (iSpellLevel > spellsKnown.iMaxSpellLevel)
		return -1;
	if (iSpellLevel > 10)
		return -1;
	if (iSpellLevel < 0)
		return -1;
	if (iSpellSlot < 1)
		return -1;
	if (iSpellSlot > JX_SPBK_KNOWN_MAXSPELLS)
		return -1;

	// Get the spell list for the specified spell level
	string sSpells;
	switch (iSpellLevel)
	{
		case 0: sSpells = spellsKnown.sSpellsKnownLevel0; break;
		case 1: sSpells = spellsKnown.sSpellsKnownLevel1; break;
		case 2: sSpells = spellsKnown.sSpellsKnownLevel2; break;
		case 3: sSpells = spellsKnown.sSpellsKnownLevel3; break;
		case 4: sSpells = spellsKnown.sSpellsKnownLevel4; break;
		case 5: sSpells = spellsKnown.sSpellsKnownLevel5; break;
		case 6: sSpells = spellsKnown.sSpellsKnownLevel6; break;
		case 7: sSpells = spellsKnown.sSpellsKnownLevel7; break;
		case 8: sSpells = spellsKnown.sSpellsKnownLevel8; break;
		case 9: sSpells = spellsKnown.sSpellsKnownLevel9; break;
		case 10: sSpells = spellsKnown.sSpellsKnownLevel10; break;
	}
	struct jx_array_fixed array = JXFixedArrayToStruct(sSpells);

	// Get the number of spells for the specified spell level
	int iMaxSpellSlot = JXFixedArrayCountElements(array);
	if (iSpellSlot > iMaxSpellSlot)
		return -1;

	// Get the spell identifier for the specified slot
	return StringToInt(JXFixedArrayGetElement(array, iSpellSlot));
}

// Add a spell to a list of known spells
// - spellsKnown List of known spells
// - iSpellLevel Spell level (from 0 to 10)
// - iSpellId SPELL_* constant
// * Returns the updated list of known spells
struct jx_spells_known JXSpellsKnownAddSpell(struct jx_spells_known spellsKnown, int iSpellLevel, int iSpellId)
{
	struct jx_spells_known resultInvalid;
	resultInvalid.iMaxSpellLevel = -1;

	if (iSpellLevel > 10)
		return resultInvalid;
	if (iSpellLevel < 0)
		return resultInvalid;

	// Get the spell list for the specified spell level
	string sSpells;
	switch (iSpellLevel)
	{
		case 0: sSpells = spellsKnown.sSpellsKnownLevel0; break;
		case 1: sSpells = spellsKnown.sSpellsKnownLevel1; break;
		case 2: sSpells = spellsKnown.sSpellsKnownLevel2; break;
		case 3: sSpells = spellsKnown.sSpellsKnownLevel3; break;
		case 4: sSpells = spellsKnown.sSpellsKnownLevel4; break;
		case 5: sSpells = spellsKnown.sSpellsKnownLevel5; break;
		case 6: sSpells = spellsKnown.sSpellsKnownLevel6; break;
		case 7: sSpells = spellsKnown.sSpellsKnownLevel7; break;
		case 8: sSpells = spellsKnown.sSpellsKnownLevel8; break;
		case 9: sSpells = spellsKnown.sSpellsKnownLevel9; break;
		case 10: sSpells = spellsKnown.sSpellsKnownLevel10; break;
	}
	struct jx_array_fixed array = JXFixedArrayToStruct(sSpells);

	// Get the number of spells for the specified spell level
	int iMaxSpellSlot = JXFixedArrayCountElements(array);
	if (iMaxSpellSlot == JX_SPBK_KNOWN_MAXSPELLS)
		return resultInvalid;

	// Add the spell to the current list
	array = JXFixedArrayAddElement(array, IntToString(iSpellId));

	// Update the structure
	sSpells = JXFixedArrayToString(array);
	switch (iSpellLevel)
	{
		case 0: spellsKnown.sSpellsKnownLevel0 = sSpells; break;
		case 1: spellsKnown.sSpellsKnownLevel1 = sSpells; break;
		case 2: spellsKnown.sSpellsKnownLevel2 = sSpells; break;
		case 3: spellsKnown.sSpellsKnownLevel3 = sSpells; break;
		case 4: spellsKnown.sSpellsKnownLevel4 = sSpells; break;
		case 5: spellsKnown.sSpellsKnownLevel5 = sSpells; break;
		case 6: spellsKnown.sSpellsKnownLevel6 = sSpells; break;
		case 7: spellsKnown.sSpellsKnownLevel7 = sSpells; break;
		case 8: spellsKnown.sSpellsKnownLevel8 = sSpells; break;
		case 9: spellsKnown.sSpellsKnownLevel9 = sSpells; break;
		case 10: spellsKnown.sSpellsKnownLevel10 = sSpells; break;
	}

	// Update the maximum spell level
	if (spellsKnown.iMaxSpellLevel < iSpellLevel)
		spellsKnown.iMaxSpellLevel = iSpellLevel;

	return spellsKnown;
}

// Remove a spell from a list of known spells
// - spellsKnown List of known spells
// - iSpellId SPELL_* constant
// - iSpellLevel Spell level from which the spell must be removed (for better performances)
// * Returns the updated list of known spells
struct jx_spells_known JXSpellsKnownRemoveSpell(struct jx_spells_known spellsKnown, int iSpellId, int iSpellLevel)
{
	int iMaxSpellLevel = spellsKnown.iMaxSpellLevel;
	int iLoopSpellLevel = 0;
	if (iSpellLevel != -1)
	{
		iLoopSpellLevel = iSpellLevel;
		iMaxSpellLevel = iSpellLevel;
	}

	// Loop through the spell levels to find the spell to remove
	for (; iLoopSpellLevel <= iMaxSpellLevel; iLoopSpellLevel++)
	{
		// Get the spell list for the current spell level
		string sSpells;
		switch (iLoopSpellLevel)
		{
			case 0: sSpells = spellsKnown.sSpellsKnownLevel0; break;
			case 1: sSpells = spellsKnown.sSpellsKnownLevel1; break;
			case 2: sSpells = spellsKnown.sSpellsKnownLevel2; break;
			case 3: sSpells = spellsKnown.sSpellsKnownLevel3; break;
			case 4: sSpells = spellsKnown.sSpellsKnownLevel4; break;
			case 5: sSpells = spellsKnown.sSpellsKnownLevel5; break;
			case 6: sSpells = spellsKnown.sSpellsKnownLevel6; break;
			case 7: sSpells = spellsKnown.sSpellsKnownLevel7; break;
			case 8: sSpells = spellsKnown.sSpellsKnownLevel8; break;
			case 9: sSpells = spellsKnown.sSpellsKnownLevel9; break;
			case 10: sSpells = spellsKnown.sSpellsKnownLevel10; break;
		}
		struct jx_array_fixed array = JXFixedArrayToStruct(sSpells);

		// Find the slot for the spell to remove
		int iSpellSlot = JXFixedArrayFindElement(array, IntToString(iSpellId));
		if (iSpellSlot != -1)
		{
			// Remove the spell from the current list
			array = JXFixedArrayRemoveElement(array, iSpellSlot);

			// Update the structure
			sSpells = JXFixedArrayToString(array);
			switch (iLoopSpellLevel)
			{
				case 0: spellsKnown.sSpellsKnownLevel0 = sSpells; break;
				case 1: spellsKnown.sSpellsKnownLevel1 = sSpells; break;
				case 2: spellsKnown.sSpellsKnownLevel2 = sSpells; break;
				case 3: spellsKnown.sSpellsKnownLevel3 = sSpells; break;
				case 4: spellsKnown.sSpellsKnownLevel4 = sSpells; break;
				case 5: spellsKnown.sSpellsKnownLevel5 = sSpells; break;
				case 6: spellsKnown.sSpellsKnownLevel6 = sSpells; break;
				case 7: spellsKnown.sSpellsKnownLevel7 = sSpells; break;
				case 8: spellsKnown.sSpellsKnownLevel8 = sSpells; break;
				case 9: spellsKnown.sSpellsKnownLevel9 = sSpells; break;
				case 10: spellsKnown.sSpellsKnownLevel10 = sSpells; break;
			}
			break;
		}
	}

	return spellsKnown;
}

// Add a spell list to a list of known spells
// - spellsKnown List of known spells
// - spellsToAdd List of spells to add
// * Returns the updated list of known spells
struct jx_spells_known JXSpellsKnownAddSpellList(struct jx_spells_known spellsKnown, struct jx_spells_known spellsToAdd)
{
	struct jx_spells_known resultInvalid;
	resultInvalid.iMaxSpellLevel = -1;

	// Define the new maximum spell level
	if (spellsKnown.iMaxSpellLevel < spellsToAdd.iMaxSpellLevel)
		spellsKnown.iMaxSpellLevel = spellsToAdd.iMaxSpellLevel;

	int iLoopSpellLevel;
	for (iLoopSpellLevel = 0; iLoopSpellLevel <= spellsKnown.iMaxSpellLevel; iLoopSpellLevel++)
	{
		// Get the spell list for the specified spell level
		string sSpells;
		switch (iLoopSpellLevel)
		{
			case 0: sSpells = spellsKnown.sSpellsKnownLevel0; break;
			case 1: sSpells = spellsKnown.sSpellsKnownLevel1; break;
			case 2: sSpells = spellsKnown.sSpellsKnownLevel2; break;
			case 3: sSpells = spellsKnown.sSpellsKnownLevel3; break;
			case 4: sSpells = spellsKnown.sSpellsKnownLevel4; break;
			case 5: sSpells = spellsKnown.sSpellsKnownLevel5; break;
			case 6: sSpells = spellsKnown.sSpellsKnownLevel6; break;
			case 7: sSpells = spellsKnown.sSpellsKnownLevel7; break;
			case 8: sSpells = spellsKnown.sSpellsKnownLevel8; break;
			case 9: sSpells = spellsKnown.sSpellsKnownLevel9; break;
			case 10: sSpells = spellsKnown.sSpellsKnownLevel10; break;
		}
		struct jx_array_fixed array = JXFixedArrayToStruct(sSpells);

		// Find the list of spells to add
		string sSpellsToAdd;
		switch (iLoopSpellLevel)
		{
			case 0: sSpellsToAdd = spellsToAdd.sSpellsKnownLevel0; break;
			case 1: sSpellsToAdd = spellsToAdd.sSpellsKnownLevel1; break;
			case 2: sSpellsToAdd = spellsToAdd.sSpellsKnownLevel2; break;
			case 3: sSpellsToAdd = spellsToAdd.sSpellsKnownLevel3; break;
			case 4: sSpellsToAdd = spellsToAdd.sSpellsKnownLevel4; break;
			case 5: sSpellsToAdd = spellsToAdd.sSpellsKnownLevel5; break;
			case 6: sSpellsToAdd = spellsToAdd.sSpellsKnownLevel6; break;
			case 7: sSpellsToAdd = spellsToAdd.sSpellsKnownLevel7; break;
			case 8: sSpellsToAdd = spellsToAdd.sSpellsKnownLevel8; break;
			case 9: sSpellsToAdd = spellsToAdd.sSpellsKnownLevel9; break;
			case 10: sSpellsToAdd = spellsToAdd.sSpellsKnownLevel10; break;
		}
		struct jx_array_fixed arrayToAdd = JXFixedArrayToStruct(sSpellsToAdd);

		// Add the second array to the first one
		array = JXFixedArrayAddArray(array, arrayToAdd);

		// Update the structure
		sSpells = JXFixedArrayToString(array);
		switch (iLoopSpellLevel)
		{
			case 0: spellsKnown.sSpellsKnownLevel0 = sSpells; break;
			case 1: spellsKnown.sSpellsKnownLevel1 = sSpells; break;
			case 2: spellsKnown.sSpellsKnownLevel2 = sSpells; break;
			case 3: spellsKnown.sSpellsKnownLevel3 = sSpells; break;
			case 4: spellsKnown.sSpellsKnownLevel4 = sSpells; break;
			case 5: spellsKnown.sSpellsKnownLevel5 = sSpells; break;
			case 6: spellsKnown.sSpellsKnownLevel6 = sSpells; break;
			case 7: spellsKnown.sSpellsKnownLevel7 = sSpells; break;
			case 8: spellsKnown.sSpellsKnownLevel8 = sSpells; break;
			case 9: spellsKnown.sSpellsKnownLevel9 = sSpells; break;
			case 10: spellsKnown.sSpellsKnownLevel10 = sSpells; break;
		}
	}

	return spellsKnown;
}

// Remove a spell list from a list of known spells
// - spellsKnown List of known spells
// - spellsToRemove List of spells to remove
// - iSpellLevel Spell level from which the spells must be removed (for better performances)
// * Returns the updated list of known spells
struct jx_spells_known JXSpellsKnownRemoveSpellList(struct jx_spells_known spellsKnown, struct jx_spells_known spellsToRemove, int iSpellLevel)
{
	int iMaxSpellLevel = spellsToRemove.iMaxSpellLevel;
	int iLoopSpellLevel = 0;
	if (iSpellLevel != -1)
	{
		iLoopSpellLevel = iSpellLevel;
		iMaxSpellLevel = iSpellLevel;
	}

	// Loop through the spell levels to find the spells to remove
	for (; iLoopSpellLevel <= iMaxSpellLevel; iLoopSpellLevel++)
	{
		// Get the spell list to remove for the current spell level
		string sSpellsRemove;
		switch (iLoopSpellLevel)
		{
			case 0: sSpellsRemove = spellsToRemove.sSpellsKnownLevel0; break;
			case 1: sSpellsRemove = spellsToRemove.sSpellsKnownLevel1; break;
			case 2: sSpellsRemove = spellsToRemove.sSpellsKnownLevel2; break;
			case 3: sSpellsRemove = spellsToRemove.sSpellsKnownLevel3; break;
			case 4: sSpellsRemove = spellsToRemove.sSpellsKnownLevel4; break;
			case 5: sSpellsRemove = spellsToRemove.sSpellsKnownLevel5; break;
			case 6: sSpellsRemove = spellsToRemove.sSpellsKnownLevel6; break;
			case 7: sSpellsRemove = spellsToRemove.sSpellsKnownLevel7; break;
			case 8: sSpellsRemove = spellsToRemove.sSpellsKnownLevel8; break;
			case 9: sSpellsRemove = spellsToRemove.sSpellsKnownLevel9; break;
			case 10: sSpellsRemove = spellsToRemove.sSpellsKnownLevel10; break;
		}
		// Try the next spell level as there is no spell to remove for the current one
		if (sSpellsRemove == "")
			continue;
		struct jx_array_fixed arrayToRemove = JXFixedArrayToStruct(sSpellsRemove);

		// Get the spell list for the current spell level
		string sSpells;
		switch (iLoopSpellLevel)
		{
			case 0: sSpells = spellsKnown.sSpellsKnownLevel0; break;
			case 1: sSpells = spellsKnown.sSpellsKnownLevel1; break;
			case 2: sSpells = spellsKnown.sSpellsKnownLevel2; break;
			case 3: sSpells = spellsKnown.sSpellsKnownLevel3; break;
			case 4: sSpells = spellsKnown.sSpellsKnownLevel4; break;
			case 5: sSpells = spellsKnown.sSpellsKnownLevel5; break;
			case 6: sSpells = spellsKnown.sSpellsKnownLevel6; break;
			case 7: sSpells = spellsKnown.sSpellsKnownLevel7; break;
			case 8: sSpells = spellsKnown.sSpellsKnownLevel8; break;
			case 9: sSpells = spellsKnown.sSpellsKnownLevel9; break;
			case 10: sSpells = spellsKnown.sSpellsKnownLevel10; break;
		}
		// Try the next spell level as there is no spell available for the current one
		if (sSpells == "")
			continue;
		struct jx_array_fixed array = JXFixedArrayToStruct(sSpells);

		// Remove a spell list from another one
		array = JXFixedArrayRemoveArray(array, arrayToRemove);

		// Update the structure
		sSpells = JXFixedArrayToString(array);
		switch (iLoopSpellLevel)
		{
			case 0: spellsKnown.sSpellsKnownLevel0 = sSpells; break;
			case 1: spellsKnown.sSpellsKnownLevel1 = sSpells; break;
			case 2: spellsKnown.sSpellsKnownLevel2 = sSpells; break;
			case 3: spellsKnown.sSpellsKnownLevel3 = sSpells; break;
			case 4: spellsKnown.sSpellsKnownLevel4 = sSpells; break;
			case 5: spellsKnown.sSpellsKnownLevel5 = sSpells; break;
			case 6: spellsKnown.sSpellsKnownLevel6 = sSpells; break;
			case 7: spellsKnown.sSpellsKnownLevel7 = sSpells; break;
			case 8: spellsKnown.sSpellsKnownLevel8 = sSpells; break;
			case 9: spellsKnown.sSpellsKnownLevel9 = sSpells; break;
			case 10: spellsKnown.sSpellsKnownLevel10 = sSpells; break;
		}
	}

	return spellsKnown;
}

// Get the number of spells available in the list for the specified level
// - spellsKnown List of known spells
// - iSpellLevel Spell level
// * Return the number of spells available for the spell level
int JXSpellsKnownGetNbSpellsForLevel(struct jx_spells_known spellsKnown, int iSpellLevel)
{
	if (iSpellLevel > spellsKnown.iMaxSpellLevel)
		return -1;
	if (iSpellLevel > 10)
		return -1;
	if (iSpellLevel < 0)
		return -1;

	// Get the spell list for the specified spell level
	string sSpells;
	switch (iSpellLevel)
	{
		case 0: sSpells = spellsKnown.sSpellsKnownLevel0; break;
		case 1: sSpells = spellsKnown.sSpellsKnownLevel1; break;
		case 2: sSpells = spellsKnown.sSpellsKnownLevel2; break;
		case 3: sSpells = spellsKnown.sSpellsKnownLevel3; break;
		case 4: sSpells = spellsKnown.sSpellsKnownLevel4; break;
		case 5: sSpells = spellsKnown.sSpellsKnownLevel5; break;
		case 6: sSpells = spellsKnown.sSpellsKnownLevel6; break;
		case 7: sSpells = spellsKnown.sSpellsKnownLevel7; break;
		case 8: sSpells = spellsKnown.sSpellsKnownLevel8; break;
		case 9: sSpells = spellsKnown.sSpellsKnownLevel9; break;
		case 10: sSpells = spellsKnown.sSpellsKnownLevel10; break;
	}
	if (sSpells == "")
		return 0;

	struct jx_array_fixed array = JXFixedArrayToStruct(sSpells);

	// Return the number of spells for the specified spell level
	return JXFixedArrayCountElements(array);
}


// Determine if a list of known spells contains a specific spell
// - spellsKnown List of known spells
// - iSpellId SPELL_* constant
// - iSpellLevel Spell level from which the spell must be tested (for better performances)
// * Returns the spell slot if the specified spell is found in the list, else returns 0
int JXSpellsKnownContainsSpell(struct jx_spells_known spellsKnown, int iSpellId, int iSpellLevel)
{
	int iMaxSpellLevel = spellsKnown.iMaxSpellLevel;
	int iLoopSpellLevel = 0;
	if (iSpellLevel != -1)
	{
		iLoopSpellLevel = iSpellLevel;
		iMaxSpellLevel = iSpellLevel;
	}

	for (; iLoopSpellLevel <= iMaxSpellLevel; iLoopSpellLevel++)
	{
		// Get the spell list for the current spell level
		string sSpells;
		switch (iLoopSpellLevel)
		{
			case 0: sSpells = spellsKnown.sSpellsKnownLevel0; break;
			case 1: sSpells = spellsKnown.sSpellsKnownLevel1; break;
			case 2: sSpells = spellsKnown.sSpellsKnownLevel2; break;
			case 3: sSpells = spellsKnown.sSpellsKnownLevel3; break;
			case 4: sSpells = spellsKnown.sSpellsKnownLevel4; break;
			case 5: sSpells = spellsKnown.sSpellsKnownLevel5; break;
			case 6: sSpells = spellsKnown.sSpellsKnownLevel6; break;
			case 7: sSpells = spellsKnown.sSpellsKnownLevel7; break;
			case 8: sSpells = spellsKnown.sSpellsKnownLevel8; break;
			case 9: sSpells = spellsKnown.sSpellsKnownLevel9; break;
			case 10: sSpells = spellsKnown.sSpellsKnownLevel10; break;
		}
		struct jx_array_fixed array = JXFixedArrayToStruct(sSpells);

		// Search the spell in the current list
		int iSpellSlot = JXFixedArrayFindElement(array, IntToString(iSpellId));
		if (iSpellSlot > 0)
			return iSpellSlot;
		
	}

	return 0;
}

// Create a new empty set of spells known
// * Returns a new set of spells known
struct jx_spells_known JXSpellsKnownCreateStruct()
{
	struct jx_spells_known spellsKnown;

	// Maximum spell level
	spellsKnown.iMaxSpellLevel = -1;
	// Spells known level 0
	spellsKnown.sSpellsKnownLevel0 = JXFixedArrayToString(JXFixedArrayCreate(JX_SPBK_DATA_KNOWN_ELEMSIZE));
	// Spells known level 1
	spellsKnown.sSpellsKnownLevel1 = spellsKnown.sSpellsKnownLevel0;
	// Spells known level 2
	spellsKnown.sSpellsKnownLevel2 = spellsKnown.sSpellsKnownLevel0;
	// Spells known level 3
	spellsKnown.sSpellsKnownLevel3 = spellsKnown.sSpellsKnownLevel0;
	// Spells known level 4
	spellsKnown.sSpellsKnownLevel4 = spellsKnown.sSpellsKnownLevel0;
	// Spells known level 5
	spellsKnown.sSpellsKnownLevel5 = spellsKnown.sSpellsKnownLevel0;
	// Spells known level 6
	spellsKnown.sSpellsKnownLevel6 = spellsKnown.sSpellsKnownLevel0;
	// Spells known level 7
	spellsKnown.sSpellsKnownLevel7 = spellsKnown.sSpellsKnownLevel0;
	// Spells known level 8
	spellsKnown.sSpellsKnownLevel8 = spellsKnown.sSpellsKnownLevel0;
	// Spells known level 9
	spellsKnown.sSpellsKnownLevel9 = spellsKnown.sSpellsKnownLevel0;
	// Spells known level 10
	spellsKnown.sSpellsKnownLevel10 = spellsKnown.sSpellsKnownLevel0;

	return spellsKnown;
}

// Transform a list of known spells into a string
// - spellsKnown List of known spells
// * Returns a list of known spells in a string form
string JXSpellsKnownToString(struct jx_spells_known spellsKnown)
{
	struct jx_array_delim array = JXDelimArrayCreate(";");
	// Maximum spell level
	array = JXDelimArrayAddElement(array, IntToString(spellsKnown.iMaxSpellLevel));
	// Spells known level 0
	array = JXDelimArrayAddElement(array, spellsKnown.sSpellsKnownLevel0);
	// Spells known level 1
	array = JXDelimArrayAddElement(array, spellsKnown.sSpellsKnownLevel1);
	// Spells known level 2
	array = JXDelimArrayAddElement(array, spellsKnown.sSpellsKnownLevel2);
	// Spells known level 3
	array = JXDelimArrayAddElement(array, spellsKnown.sSpellsKnownLevel3);
	// Spells known level 4
	array = JXDelimArrayAddElement(array, spellsKnown.sSpellsKnownLevel4);
	// Spells known level 5
	array = JXDelimArrayAddElement(array, spellsKnown.sSpellsKnownLevel5);
	// Spells known level 6
	array = JXDelimArrayAddElement(array, spellsKnown.sSpellsKnownLevel6);
	// Spells known level 7
	array = JXDelimArrayAddElement(array, spellsKnown.sSpellsKnownLevel7);
	// Spells known level 8
	array = JXDelimArrayAddElement(array, spellsKnown.sSpellsKnownLevel8);
	// Spells known level 9
	array = JXDelimArrayAddElement(array, spellsKnown.sSpellsKnownLevel9);
	// Spells known level 10
	array = JXDelimArrayAddElement(array, spellsKnown.sSpellsKnownLevel10);

	return JXDelimArrayToString(array);
}

// Transform a list of known spells into a structure
// - sSpellsKnown List of known spells
// * Returns a list of known spells in a structure form
struct jx_spells_known JXStringToSpellsKnown(string sSpellsKnown)
{
	if (sSpellsKnown == "")
		return JXSpellsKnownCreateStruct();

	struct jx_array_delim array = JXDelimArrayToStruct(sSpellsKnown);

	struct jx_spells_known spellsKnown;
	// Maximum spell level
	spellsKnown.iMaxSpellLevel = StringToInt(JXDelimArrayGetElement(array, 1));
	// Spells known level 0
	spellsKnown.sSpellsKnownLevel0 = JXDelimArrayGetElement(array, 2);
	// Spells known level 1
	spellsKnown.sSpellsKnownLevel1 = JXDelimArrayGetElement(array, 3);
	// Spells known level 2
	spellsKnown.sSpellsKnownLevel2 = JXDelimArrayGetElement(array, 4);
	// Spells known level 3
	spellsKnown.sSpellsKnownLevel3 = JXDelimArrayGetElement(array, 5);
	// Spells known level 4
	spellsKnown.sSpellsKnownLevel4 = JXDelimArrayGetElement(array, 6);
	// Spells known level 5
	spellsKnown.sSpellsKnownLevel5 = JXDelimArrayGetElement(array, 7);
	// Spells known level 6
	spellsKnown.sSpellsKnownLevel6 = JXDelimArrayGetElement(array, 8);
	// Spells known level 7
	spellsKnown.sSpellsKnownLevel7 = JXDelimArrayGetElement(array, 9);
	// Spells known level 8
	spellsKnown.sSpellsKnownLevel8 = JXDelimArrayGetElement(array, 10);
	// Spells known level 9
	spellsKnown.sSpellsKnownLevel9 = JXDelimArrayGetElement(array, 11);
	// Spells known level 10
	spellsKnown.sSpellsKnownLevel10 = JXDelimArrayGetElement(array, 12);

	return spellsKnown;
}