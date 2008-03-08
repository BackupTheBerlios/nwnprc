//::///////////////////////////////////////////////
//:: JX Spellbook - Spells Memorized Data include
//:: jx_inc_spbk_data_spmem
//:://////////////////////////////////////////////
//:://////////////////////////////////////////////
//:: Created By: jallaix
//:: Created On: Nov 16, 2007
//:://////////////////////////////////////////////
//
// This include file provides functions to manage
// spells memorized-related data.
//
// It provides the following functions :
//
// * Resize the number of slots for a spell level
// * Resize lists of slots depending on spells/day
// * Add a spell known UI to a free slot
// * Remove a spell known UI from in a free slot
// * Get the spell in a slot
// * Get the number of slots for a spell level
// * Create a new empty set of spells memorized
// * Convert spells memorized into a string
// * Convert a string into spells memorized
//
//:://////////////////////////////////////////////

#include "jx_inc_array_fixed"
#include "jx_inc_array_delim"
#include "jx_inc_spbk_data_spday"
#include "jx_inc_spbk_data_spkwnui"


















//**************************************//
//                                      //
//              Interface               //
//                                      //
//**************************************//


// List of spells memorized (spell id, metamagic feat)
struct jx_spells_memorized
{
	string sSpellsLevel0;
	string sSpellsLevel1;
	string sSpellsLevel2;
	string sSpellsLevel3;
	string sSpellsLevel4;
	string sSpellsLevel5;
	string sSpellsLevel6;
	string sSpellsLevel7;
	string sSpellsLevel8;
	string sSpellsLevel9;
	string sSpellsLevel10;
	int iMaxSpellLevel;
};


// Resize the list of memorized spells for the UI
// - spellsMemorized List of memorized spells for the UI
// - iSpellLevel Spell level (from 0 to 10)
// - iNbSlots Number of slots to set for the level (from 1 to 12)
// * Returns the updated list of memorized spells for the UI
struct jx_spells_memorized JXSpellsMemorizedUIResize(struct jx_spells_memorized spellsMemorized, int iSpellLevel, int iNbSlots);

// Update a list of memorized spells to reflect a list of spells per day
// - spellsMemorized List of memorized spells for the UI
// - spellsDay List of spells per day
// * Returns the updated list of memorized spells for the UI
struct jx_spells_memorized JXSpellsMemorizedUIUpdateSize(struct jx_spells_memorized spellsMemorized, struct jx_spells_per_day spellsDay);

// Add a known spell to the list of memorized spells for the UI
// - spellsMemorized List of memorized spells for the UI
// - iSpellLevel Spell level (from 0 to 10)
// - spellKnown The spell known to add to the list
// - iSpellSlot The slot for the level where the spell must be added (from 1 to 12)
// * Returns the updated list of memorized spells for the UI
struct jx_spells_memorized JXSpellsMemorizedUIAddSpell(struct jx_spells_memorized spellsMemorized, int iSpellLevel, struct jx_spell_known_ui spellKnown, int iSpellSlot = -1);

// Remove a spell from the list of memorized spells for the UI
// - spellsMemorized List of memorized spells for the UI
// - iSpellLevel Spell level (from 0 to 10)
// - iSpellSlot The slot for the level where the spell must be removed (from 1 to 12)
// * Returns the updated list of memorized spells for the UI
struct jx_spells_memorized JXSpellsMemorizedUIRemoveSpell(struct jx_spells_memorized spellsMemorized, int iSpellLevel, int iSpellSlot);

// Get a spell from the list of memorized spells for the UI
// - spellsMemorized List of memorized spells for the UI
// - iSpellLevel Spell level (from 0 to 10)
// - iSpellSlot The slot for the level where the spell must be get (from 1 to 12)
// * Returns the known spell found
struct jx_spell_known_ui JXSpellsMemorizedUIGetSpell(struct jx_spells_memorized spellsMemorized, int iSpellLevel, int iSpellSlot);

// Get the number of slots for the spell level
// - spellsMemorized List of memorized spells for the UI
// - iSpellLevel Spell level (from 0 to 10)
// * Returns the number of slots for the spell level
int JXSpellsMemorizedUIGetNbSlots(struct jx_spells_memorized spellsMemorized, int iSpellLevel);

// Create a new empty set of spells memorized
// * Returns a new set of spells memorized
struct jx_spells_memorized JXSpellsMemorizedUICreateStruct();

// Transform a list of memorized spells for the UI into a string
// - spellsMemorized List of memorized spells for the UI
// * Returns a list of memorized spells for the UI in a string form
string JXSpellsMemorizedUIToString(struct jx_spells_memorized spellsMemorized);

// Transform a list of memorized spells for the UI into a structure
// - spellsMemorized List of memorized spells for the UI
// * Returns a list of memorized spells for the UI in a structure form
struct jx_spells_memorized JXStringToSpellsMemorizedUI(string sSpellsMemorized);
















//**************************************//
//                                      //
//            Implementation            //
//                                      //
//**************************************//


const int JX_SPBK_DATA_MEMO_ELEMSIZE = 20;
const int JX_SPBK_MEMORIZED_MAXSPELLS = 12;


// Resize the list of memorized spells for the UI
// - spellsMemorized List of memorized spells for the UI
// - iSpellLevel Spell level (from 0 to 10)
// - iNbSlots Number of slots to set for the level (from 1 to 12)
// * Returns the updated list of memorized spells for the UI
struct jx_spells_memorized JXSpellsMemorizedUIResize(struct jx_spells_memorized spellsMemorized, int iSpellLevel, int iNbSlots)
{
	if (iSpellLevel > 10)
		return spellsMemorized;
	if (iSpellLevel < 0)
		return spellsMemorized;
	if (iNbSlots < 1)
		return spellsMemorized;
	if (iNbSlots > JX_SPBK_MEMORIZED_MAXSPELLS)
		return spellsMemorized;

	// Get the spell list for the specified spell level
	string sSpells;
	switch (iSpellLevel)
	{
		case 0: sSpells = spellsMemorized.sSpellsLevel0; break;
		case 1: sSpells = spellsMemorized.sSpellsLevel1; break;
		case 2: sSpells = spellsMemorized.sSpellsLevel2; break;
		case 3: sSpells = spellsMemorized.sSpellsLevel3; break;
		case 4: sSpells = spellsMemorized.sSpellsLevel4; break;
		case 5: sSpells = spellsMemorized.sSpellsLevel5; break;
		case 6: sSpells = spellsMemorized.sSpellsLevel6; break;
		case 7: sSpells = spellsMemorized.sSpellsLevel7; break;
		case 8: sSpells = spellsMemorized.sSpellsLevel8; break;
		case 9: sSpells = spellsMemorized.sSpellsLevel9; break;
		case 10: sSpells = spellsMemorized.sSpellsLevel10; break;
	}
	struct jx_array_fixed array = JXFixedArrayToStruct(sSpells);
	struct jx_array_delim arraySpell;

	// Get the number of spells for the specified spell level
	int iMaxSpellSlot = JXFixedArrayCountElements(array);

	// Case 1 : No resize
	if (iMaxSpellSlot == iNbSlots)
		return spellsMemorized;
	
	// Case 2 : Increase the number of slots
	if (iMaxSpellSlot < iNbSlots)
	{
		// Add empty slots to the current list of spells memorized
		int iLoopSlot;
		for (iLoopSlot = 1; iLoopSlot <= (iNbSlots - iMaxSpellSlot); iLoopSlot++)
		{
			arraySpell = JXDelimArrayCreate("_");
			arraySpell = JXDelimArrayAddElement(arraySpell, "-1");
			arraySpell = JXDelimArrayAddElement(arraySpell, "0");
			array = JXFixedArrayAddElement(array, JXDelimArrayToString(arraySpell));
		}
	}

	// Case 3 : Decrease the number of slots
	if (iMaxSpellSlot > iNbSlots)
	{
		// Remove slots from the current list of spells memorized
		int iLoopSlot;
		for (iLoopSlot = iMaxSpellSlot; iLoopSlot > iNbSlots; iLoopSlot--)
			array = JXFixedArrayRemoveElement(array, iLoopSlot);
	}

	// Update the list of memorized spells
	sSpells = JXFixedArrayToString(array);
	switch (iSpellLevel)
	{
		case 0: spellsMemorized.sSpellsLevel0 = sSpells; break;
		case 1: spellsMemorized.sSpellsLevel1 = sSpells; break;
		case 2: spellsMemorized.sSpellsLevel2 = sSpells; break;
		case 3: spellsMemorized.sSpellsLevel3 = sSpells; break;
		case 4: spellsMemorized.sSpellsLevel4 = sSpells; break;
		case 5: spellsMemorized.sSpellsLevel5 = sSpells; break;
		case 6: spellsMemorized.sSpellsLevel6 = sSpells; break;
		case 7: spellsMemorized.sSpellsLevel7 = sSpells; break;
		case 8: spellsMemorized.sSpellsLevel8 = sSpells; break;
		case 9: spellsMemorized.sSpellsLevel9 = sSpells; break;
		case 10: spellsMemorized.sSpellsLevel10 = sSpells; break;
	}

	// Set the new maximum spell level
	if (iSpellLevel > spellsMemorized.iMaxSpellLevel)
		spellsMemorized.iMaxSpellLevel = iSpellLevel;

	return spellsMemorized;
}

// Update a list of memorized spells to reflect a list of spells per day
// - spellsMemorized List of memorized spells for the UI
// - spellsDay List of spells per day
// * Returns the updated list of memorized spells for the UI
struct jx_spells_memorized JXSpellsMemorizedUIUpdateSize(struct jx_spells_memorized spellsMemorized, struct jx_spells_per_day spellsDay)
{
	int iLoopSpellLevel;
	for (iLoopSpellLevel = 0; iLoopSpellLevel <= 10; iLoopSpellLevel++)
	{
		int iNbSlots;
		switch (iLoopSpellLevel)
		{
			case 0: iNbSlots = spellsDay.iSpellsPerDayLevel0; break;
			case 1: iNbSlots = spellsDay.iSpellsPerDayLevel1; break;
			case 2: iNbSlots = spellsDay.iSpellsPerDayLevel2; break;
			case 3: iNbSlots = spellsDay.iSpellsPerDayLevel3; break;
			case 4: iNbSlots = spellsDay.iSpellsPerDayLevel4; break;
			case 5: iNbSlots = spellsDay.iSpellsPerDayLevel5; break;
			case 6: iNbSlots = spellsDay.iSpellsPerDayLevel6; break;
			case 7: iNbSlots = spellsDay.iSpellsPerDayLevel7; break;
			case 8: iNbSlots = spellsDay.iSpellsPerDayLevel8; break;
			case 9: iNbSlots = spellsDay.iSpellsPerDayLevel9; break;
			case 10: iNbSlots = spellsDay.iSpellsPerDayLevel10; break;
		}

		if (iNbSlots <= 0)
		{
			string sSpells = JXFixedArrayToString(JXFixedArrayCreate(JX_SPBK_DATA_MEMO_ELEMSIZE));
			switch (iLoopSpellLevel)
			{
				case 0: spellsMemorized.sSpellsLevel0 = sSpells; break;
				case 1: spellsMemorized.sSpellsLevel1 = sSpells; break;
				case 2: spellsMemorized.sSpellsLevel2 = sSpells; break;
				case 3: spellsMemorized.sSpellsLevel3 = sSpells; break;
				case 4: spellsMemorized.sSpellsLevel4 = sSpells; break;
				case 5: spellsMemorized.sSpellsLevel5 = sSpells; break;
				case 6: spellsMemorized.sSpellsLevel6 = sSpells; break;
				case 7: spellsMemorized.sSpellsLevel7 = sSpells; break;
				case 8: spellsMemorized.sSpellsLevel8 = sSpells; break;
				case 9: spellsMemorized.sSpellsLevel9 = sSpells; break;
				case 10: spellsMemorized.sSpellsLevel10 = sSpells; break;
			}
		}
		else
		{
			spellsMemorized = JXSpellsMemorizedUIResize(spellsMemorized, iLoopSpellLevel, iNbSlots);
			spellsMemorized.iMaxSpellLevel = iLoopSpellLevel;
		}
	}

	return spellsMemorized;
}

// Add a known spell to the list of memorized spells for the UI
// - spellsMemorized List of memorized spells for the UI
// - iSpellLevel Spell level (from 0 to 10)
// - spellKnown The spell known to add to the list
// - iSpellSlot The slot for the level where the spell must be added (from 1 to 12)
// * Returns the updated list of memorized spells for the UI
struct jx_spells_memorized JXSpellsMemorizedUIAddSpell(struct jx_spells_memorized spellsMemorized, int iSpellLevel, struct jx_spell_known_ui spellKnown, int iSpellSlot = -1)
{
	if (iSpellLevel > spellsMemorized.iMaxSpellLevel)
		return spellsMemorized;
	if (iSpellLevel > 10)
		return spellsMemorized;
	if (iSpellLevel < 0)
		return spellsMemorized;
	if ((iSpellSlot < 1) && (iSpellSlot != -1))
		return spellsMemorized;
	if (iSpellSlot > JX_SPBK_MEMORIZED_MAXSPELLS)
		return spellsMemorized;

	// Get the spell list for the specified spell level
	string sSpells;
	switch (iSpellLevel)
	{
		case 0: sSpells = spellsMemorized.sSpellsLevel0; break;
		case 1: sSpells = spellsMemorized.sSpellsLevel1; break;
		case 2: sSpells = spellsMemorized.sSpellsLevel2; break;
		case 3: sSpells = spellsMemorized.sSpellsLevel3; break;
		case 4: sSpells = spellsMemorized.sSpellsLevel4; break;
		case 5: sSpells = spellsMemorized.sSpellsLevel5; break;
		case 6: sSpells = spellsMemorized.sSpellsLevel6; break;
		case 7: sSpells = spellsMemorized.sSpellsLevel7; break;
		case 8: sSpells = spellsMemorized.sSpellsLevel8; break;
		case 9: sSpells = spellsMemorized.sSpellsLevel9; break;
		case 10: sSpells = spellsMemorized.sSpellsLevel10; break;
	}
	struct jx_array_fixed array = JXFixedArrayToStruct(sSpells);
	struct jx_array_delim arraySpell;

	// Get the number of spells for the specified spell level
	int iMaxSpellSlot = JXFixedArrayCountElements(array);
	if (iSpellSlot > iMaxSpellSlot)
		return spellsMemorized;

	// Find a free slot if none is specified
	if (iSpellSlot == -1)
	{
		int iLoopFreeSlot;
		for (iLoopFreeSlot = 1; iLoopFreeSlot <= iMaxSpellSlot; iLoopFreeSlot++)
		{
			arraySpell = JXDelimArrayToStruct(JXFixedArrayGetElement(array, iLoopFreeSlot));
			if (JXDelimArrayGetElement(arraySpell, 1) == "-1")
			{
				iSpellSlot = iLoopFreeSlot;
				break;
			}
		}
	}
	// No spell slot found
	if (iSpellSlot == -1)
		return spellsMemorized;

	// Define the spell known UI in the spell list
	arraySpell = JXDelimArrayCreate("_");
	arraySpell = JXDelimArrayAddElement(arraySpell, IntToString(spellKnown.iSpellId));
	arraySpell = JXDelimArrayAddElement(arraySpell, IntToString(spellKnown.iMetaMagicFeat));
	array = JXFixedArraySetElement(array, JXDelimArrayToString(arraySpell), iSpellSlot);

	// Update the list of memorized spells
	sSpells = JXFixedArrayToString(array);
	switch (iSpellLevel)
	{
		case 0: spellsMemorized.sSpellsLevel0 = sSpells; break;
		case 1: spellsMemorized.sSpellsLevel1 = sSpells; break;
		case 2: spellsMemorized.sSpellsLevel2 = sSpells; break;
		case 3: spellsMemorized.sSpellsLevel3 = sSpells; break;
		case 4: spellsMemorized.sSpellsLevel4 = sSpells; break;
		case 5: spellsMemorized.sSpellsLevel5 = sSpells; break;
		case 6: spellsMemorized.sSpellsLevel6 = sSpells; break;
		case 7: spellsMemorized.sSpellsLevel7 = sSpells; break;
		case 8: spellsMemorized.sSpellsLevel8 = sSpells; break;
		case 9: spellsMemorized.sSpellsLevel9 = sSpells; break;
		case 10: spellsMemorized.sSpellsLevel10 = sSpells; break;
	}

	return spellsMemorized;
}

// Remove a spell from the list of memorized spells for the UI
// - spellsMemorized List of memorized spells for the UI
// - iSpellLevel Spell level (from 0 to 10)
// - iSpellSlot The slot for the level where the spell must be removed (from 1 to 12)
// * Returns the updated list of memorized spells for the UI
struct jx_spells_memorized JXSpellsMemorizedUIRemoveSpell(struct jx_spells_memorized spellsMemorized, int iSpellLevel, int iSpellSlot)
{
	if (iSpellLevel > spellsMemorized.iMaxSpellLevel)
		return spellsMemorized;
	if (iSpellLevel > 10)
		return spellsMemorized;
	if (iSpellLevel < 0)
		return spellsMemorized;
	if (iSpellSlot < 1)
		return spellsMemorized;
	if (iSpellSlot > JX_SPBK_MEMORIZED_MAXSPELLS)
		return spellsMemorized;

	// Get the spell list for the specified spell level
	string sSpells;
	switch (iSpellLevel)
	{
		case 0: sSpells = spellsMemorized.sSpellsLevel0; break;
		case 1: sSpells = spellsMemorized.sSpellsLevel1; break;
		case 2: sSpells = spellsMemorized.sSpellsLevel2; break;
		case 3: sSpells = spellsMemorized.sSpellsLevel3; break;
		case 4: sSpells = spellsMemorized.sSpellsLevel4; break;
		case 5: sSpells = spellsMemorized.sSpellsLevel5; break;
		case 6: sSpells = spellsMemorized.sSpellsLevel6; break;
		case 7: sSpells = spellsMemorized.sSpellsLevel7; break;
		case 8: sSpells = spellsMemorized.sSpellsLevel8; break;
		case 9: sSpells = spellsMemorized.sSpellsLevel9; break;
		case 10: sSpells = spellsMemorized.sSpellsLevel10; break;
	}
	struct jx_array_fixed array = JXFixedArrayToStruct(sSpells);

	// Get the number of spells for the specified spell level
	int iMaxSpellSlot = JXFixedArrayCountElements(array);
	if (iSpellSlot > iMaxSpellSlot)
		return spellsMemorized;

	// Remove the spell known UI from the spell list
	struct jx_array_delim arraySpell = JXDelimArrayCreate("_");
	arraySpell = JXDelimArrayAddElement(arraySpell, "-1");
	arraySpell = JXDelimArrayAddElement(arraySpell, "0");
	array = JXFixedArraySetElement(array, JXDelimArrayToString(arraySpell), iSpellSlot);

	// Update the list of memorized spells
	sSpells = JXFixedArrayToString(array);
	switch (iSpellLevel)
	{
		case 0: spellsMemorized.sSpellsLevel0 = sSpells; break;
		case 1: spellsMemorized.sSpellsLevel1 = sSpells; break;
		case 2: spellsMemorized.sSpellsLevel2 = sSpells; break;
		case 3: spellsMemorized.sSpellsLevel3 = sSpells; break;
		case 4: spellsMemorized.sSpellsLevel4 = sSpells; break;
		case 5: spellsMemorized.sSpellsLevel5 = sSpells; break;
		case 6: spellsMemorized.sSpellsLevel6 = sSpells; break;
		case 7: spellsMemorized.sSpellsLevel7 = sSpells; break;
		case 8: spellsMemorized.sSpellsLevel8 = sSpells; break;
		case 9: spellsMemorized.sSpellsLevel9 = sSpells; break;
		case 10: spellsMemorized.sSpellsLevel10 = sSpells; break;
	}

	return spellsMemorized;
}

// Get a spell from the list of memorized spells for the UI
// - spellsMemorized List of memorized spells for the UI
// - iSpellLevel Spell level (from 0 to 10)
// - iSpellSlot The slot for the level where the spell must be get (from 1 to 12)
// * Returns the known spell found
struct jx_spell_known_ui JXSpellsMemorizedUIGetSpell(struct jx_spells_memorized spellsMemorized, int iSpellLevel, int iSpellSlot)
{
	struct jx_spell_known_ui spellKnown;
	spellKnown.iSpellId = -1;

	if (iSpellLevel > spellsMemorized.iMaxSpellLevel)
		return spellKnown;
	if (iSpellLevel > 10)
		return spellKnown;
	if (iSpellLevel < 0)
		return spellKnown;
	if (iSpellSlot < 1)
		return spellKnown;
	if (iSpellSlot > JX_SPBK_MEMORIZED_MAXSPELLS)
		return spellKnown;

	// Get the spell list for the specified spell level
	string sSpells;
	switch (iSpellLevel)
	{
		case 0: sSpells = spellsMemorized.sSpellsLevel0; break;
		case 1: sSpells = spellsMemorized.sSpellsLevel1; break;
		case 2: sSpells = spellsMemorized.sSpellsLevel2; break;
		case 3: sSpells = spellsMemorized.sSpellsLevel3; break;
		case 4: sSpells = spellsMemorized.sSpellsLevel4; break;
		case 5: sSpells = spellsMemorized.sSpellsLevel5; break;
		case 6: sSpells = spellsMemorized.sSpellsLevel6; break;
		case 7: sSpells = spellsMemorized.sSpellsLevel7; break;
		case 8: sSpells = spellsMemorized.sSpellsLevel8; break;
		case 9: sSpells = spellsMemorized.sSpellsLevel9; break;
		case 10: sSpells = spellsMemorized.sSpellsLevel10; break;
	}
	struct jx_array_fixed array = JXFixedArrayToStruct(sSpells);

	// Get the number of spells for the specified spell level
	int iMaxSpellSlot = JXFixedArrayCountElements(array);
	if (iSpellSlot > iMaxSpellSlot)
		return spellKnown;

	// Find the spell in the list
	struct jx_array_delim arraySpell = JXDelimArrayToStruct(JXFixedArrayGetElement(array, iSpellSlot));
	spellKnown.iSpellId = StringToInt(JXDelimArrayGetElement(arraySpell, 1));
	spellKnown.iMetaMagicFeat = StringToInt(JXDelimArrayGetElement(arraySpell, 2));

	return spellKnown;
}

// Get the number of slots for the spell level
// - spellsMemorized List of memorized spells for the UI
// - iSpellLevel Spell level (from 0 to 10)
// * Returns the number of slots for the spell level
int JXSpellsMemorizedUIGetNbSlots(struct jx_spells_memorized spellsMemorized, int iSpellLevel)
{
	if (iSpellLevel > spellsMemorized.iMaxSpellLevel)
		return -1;
	if (iSpellLevel > 10)
		return -1;

	// Get the spell list for the specified spell level
	string sSpells;
	switch (iSpellLevel)
	{
		case 0: sSpells = spellsMemorized.sSpellsLevel0; break;
		case 1: sSpells = spellsMemorized.sSpellsLevel1; break;
		case 2: sSpells = spellsMemorized.sSpellsLevel2; break;
		case 3: sSpells = spellsMemorized.sSpellsLevel3; break;
		case 4: sSpells = spellsMemorized.sSpellsLevel4; break;
		case 5: sSpells = spellsMemorized.sSpellsLevel5; break;
		case 6: sSpells = spellsMemorized.sSpellsLevel6; break;
		case 7: sSpells = spellsMemorized.sSpellsLevel7; break;
		case 8: sSpells = spellsMemorized.sSpellsLevel8; break;
		case 9: sSpells = spellsMemorized.sSpellsLevel9; break;
		case 10: sSpells = spellsMemorized.sSpellsLevel10; break;
	}
	struct jx_array_fixed array = JXFixedArrayToStruct(sSpells);

	// Return the number of spells for the specified spell level
	return JXFixedArrayCountElements(array);
}

// Create a new empty set of spells memorized
// * Returns a new set of spells memorized
struct jx_spells_memorized JXSpellsMemorizedUICreateStruct()
{
	struct jx_spells_memorized spellsMemorized;

	// Maximum spell level
	spellsMemorized.iMaxSpellLevel = -1;
	// Spells memorized level 0
	spellsMemorized.sSpellsLevel0 = JXFixedArrayToString(JXFixedArrayCreate(JX_SPBK_DATA_MEMO_ELEMSIZE));
	// Spells memorized level 1
	spellsMemorized.sSpellsLevel1 = spellsMemorized.sSpellsLevel0;
	// Spells memorized level 2
	spellsMemorized.sSpellsLevel2 = spellsMemorized.sSpellsLevel0;
	// Spells memorized level 3
	spellsMemorized.sSpellsLevel3 = spellsMemorized.sSpellsLevel0;
	// Spells memorized level 4
	spellsMemorized.sSpellsLevel4 = spellsMemorized.sSpellsLevel0;
	// Spells memorized level 5
	spellsMemorized.sSpellsLevel5 = spellsMemorized.sSpellsLevel0;
	// Spells memorized level 6
	spellsMemorized.sSpellsLevel6 = spellsMemorized.sSpellsLevel0;
	// Spells memorized level 7
	spellsMemorized.sSpellsLevel7 = spellsMemorized.sSpellsLevel0;
	// Spells memorized level 8
	spellsMemorized.sSpellsLevel8 = spellsMemorized.sSpellsLevel0;
	// Spells memorized level 9
	spellsMemorized.sSpellsLevel9 = spellsMemorized.sSpellsLevel0;
	// Spells memorized level 10
	spellsMemorized.sSpellsLevel10 = spellsMemorized.sSpellsLevel0;

	return spellsMemorized;
}

// Transform a list of memorized spells for the UI into a string
// - spellsMemorized List of memorized spells for the UI
// * Returns a list of memorized spells for the UI in a string form
string JXSpellsMemorizedUIToString(struct jx_spells_memorized spellsMemorized)
{
	struct jx_array_delim array = JXDelimArrayCreate(";");
	// Maximum spell level
	array = JXDelimArrayAddElement(array, IntToString(spellsMemorized.iMaxSpellLevel));
	// Spells memorized level 0
	array = JXDelimArrayAddElement(array, spellsMemorized.sSpellsLevel0);
	// Spells memorized level 1
	array = JXDelimArrayAddElement(array, spellsMemorized.sSpellsLevel1);
	// Spells memorized level 2
	array = JXDelimArrayAddElement(array, spellsMemorized.sSpellsLevel2);
	// Spells memorized level 3
	array = JXDelimArrayAddElement(array, spellsMemorized.sSpellsLevel3);
	// Spells memorized level 4
	array = JXDelimArrayAddElement(array, spellsMemorized.sSpellsLevel4);
	// Spells memorized level 5
	array = JXDelimArrayAddElement(array, spellsMemorized.sSpellsLevel5);
	// Spells memorized level 6
	array = JXDelimArrayAddElement(array, spellsMemorized.sSpellsLevel6);
	// Spells memorized level 7
	array = JXDelimArrayAddElement(array, spellsMemorized.sSpellsLevel7);
	// Spells memorized level 8
	array = JXDelimArrayAddElement(array, spellsMemorized.sSpellsLevel8);
	// Spells memorized level 9
	array = JXDelimArrayAddElement(array, spellsMemorized.sSpellsLevel9);
	// Spells memorized level 10
	array = JXDelimArrayAddElement(array, spellsMemorized.sSpellsLevel10);

	return JXDelimArrayToString(array);
}

// Transform a list of memorized spells for the UI into a structure
// - spellsMemorized List of memorized spells for the UI
// * Returns a list of memorized spells for the UI in a structure form
struct jx_spells_memorized JXStringToSpellsMemorizedUI(string sSpellsMemorized)
{
	if (sSpellsMemorized == "")
		return JXSpellsMemorizedUICreateStruct();

	struct jx_array_delim array = JXDelimArrayToStruct(sSpellsMemorized);

	struct jx_spells_memorized spellsMemorized;
	// Maximum spell level
	spellsMemorized.iMaxSpellLevel = StringToInt(JXDelimArrayGetElement(array, 1));
	// Spells memorized level 0
	spellsMemorized.sSpellsLevel0 = JXDelimArrayGetElement(array, 2);
	// Spells memorized level 1
	spellsMemorized.sSpellsLevel1 = JXDelimArrayGetElement(array, 3);
	// Spells memorized level 2
	spellsMemorized.sSpellsLevel2 = JXDelimArrayGetElement(array, 4);
	// Spells memorized level 3
	spellsMemorized.sSpellsLevel3 = JXDelimArrayGetElement(array, 5);
	// Spells memorized level 4
	spellsMemorized.sSpellsLevel4 = JXDelimArrayGetElement(array, 6);
	// Spells memorized level 5
	spellsMemorized.sSpellsLevel5 = JXDelimArrayGetElement(array, 7);
	// Spells memorized level 6
	spellsMemorized.sSpellsLevel6 = JXDelimArrayGetElement(array, 8);
	// Spells memorized level 7
	spellsMemorized.sSpellsLevel7 = JXDelimArrayGetElement(array, 9);
	// Spells memorized level 8
	spellsMemorized.sSpellsLevel8 = JXDelimArrayGetElement(array, 10);
	// Spells memorized level 9
	spellsMemorized.sSpellsLevel9 = JXDelimArrayGetElement(array, 11);
	// Spells memorized level 10
	spellsMemorized.sSpellsLevel10 = JXDelimArrayGetElement(array, 12);

	return spellsMemorized;
}