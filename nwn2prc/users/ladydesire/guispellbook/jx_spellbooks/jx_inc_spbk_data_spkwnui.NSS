//::///////////////////////////////////////////////
//:: JX Spellbook - Data include
//:: jx_inc_spbk_data
//:://////////////////////////////////////////////
//:://////////////////////////////////////////////
//:: Created By: jallaix
//:: Created On: Nov 16, 2007
//:://////////////////////////////////////////////
//
// This include file provides functions to manage the
// spells known UI-related data.
//
// It provides the following functions :
//
// * Get a spell known UI
// * Set the metamagic feat for a spell list
// * Get the metamagic feat for a spell list
// * Add a spell known UI
// * Get the number of spell lists
// * Get the number of spells in a list
// * Create a new empty set of spells known UI
// * Convert lists of spells known UI into a string
// * Convert a string into lists of spells known UI
//
//:://////////////////////////////////////////////

#include "jx_inc_array_fixed"
#include "jx_inc_array_delim"
















//**************************************//
//                                      //
//              Interface               //
//                                      //
//**************************************//


// Spell known for the UI (spell id, metamagic feat)
struct jx_spell_known_ui
{
	int iSpellId;
	int iMetaMagicFeat;
};

// List of known spells for the UI (normal spells and modified by metamagic)
struct jx_spells_known_ui
{
	string sSpellsNormal;
	int iMetaMagicFeat1;
	string sSpellsMetaMagic1;
	int iMetaMagicFeat2;
	string sSpellsMetaMagic2;
	int iMetaMagicFeat3;
	string sSpellsMetaMagic3;
	int iMetaMagicFeat4;
	string sSpellsMetaMagic4;
	int iMetaMagicFeat5;
	string sSpellsMetaMagic5;
	int iMetaMagicFeat6;
	string sSpellsMetaMagic6;
	int iMetaMagicFeat7;
	string sSpellsMetaMagic7;
	int iMetaMagicFeat8;
	string sSpellsMetaMagic8;
	int iMetaMagicFeat9;
	string sSpellsMetaMagic9;
	int iMetaMagicFeat10;
	string sSpellsMetaMagic10;
	int iMaxSpellList;
};


// Get a spell from a list of known spells for the UI
// - spellsKnownUI List of known spells for the UI
// - iSpellList Spell list, from 0 (normal) to 10 (10th metamagic feat)
// - iSpellSlot Slot of the spell to get (from 1 to 30)
// * Returns the desired spell for the UI
struct jx_spell_known_ui JXSpellsKnownUIGetSpell(struct jx_spells_known_ui spellsKnownUI, int iSpellList, int iSpellSlot);

// Set the metamagic feat associated with a spell list from a spells known for the UI
// - spellsKnownUI List of known spells for the UI
// - iSpellList Spell list, from 1 (1st metamagic feat) to 10 (10th metamagic feat)
// - iMetaMagicFeat A combination of METAMAGIC_* constants
// * Returns the updated list of known spells for the UI
struct jx_spells_known_ui JXSpellsKnownUISetMetaMagicFeat(struct jx_spells_known_ui spellsKnownUI, int iSpellList, int iMetaMagicFeat);

// Get the metamagic feat associated with a spell list from a spells known for the UI
// - spellsKnownUI List of known spells for the UI
// - iSpellList Spell list, from 1 (1st metamagic feat) to 10 (10th metamagic feat)
// * Returns combination  of METAMAGIC_* constants
int JXSpellsKnownUIGetMetaMagicFeat(struct jx_spells_known_ui spellsKnownUI, int iSpellList);

// Add a spell to a list of known spells for the UI
// - spellsKnownUI List of known spells for the UI
// - iSpellList Spell list, from 0 (normal) to 10 (10th metamagic)
// - spellKnownUI Known spell for the UI to add
// * Returns the updated list of known spells for the UI
struct jx_spells_known_ui JXSpellsKnownUIAddSpell(struct jx_spells_known_ui spellsKnownUI, int iSpellList, struct jx_spell_known_ui spellKnownUI);

// Get the number of spell lists in a list of spells known for the UI
// - spellsKnownUI List of known spells for the UI
// * Returns the number of spell lists
int JXSpellsKnownUIGetNbSpellLists(struct jx_spells_known_ui spellsKnownUI);

// Get the number of spells available in the list of known spells for the UI
// - spellsKnownUI List of known spells for the UI
// - iSpellList Spell list, from 0 (normal) to 10 (10th metamagic)
// * Returns the number of spells for the specified list
int JXSpellsKnownUIGetNbSpellsForList(struct jx_spells_known_ui spellsKnownUI, int iSpellList);

// Create a new empty set of spells known UI
// * Returns a new set of spells known UI
struct jx_spells_known_ui JXSpellsKnownUICreateStruct();

// Transform a list of known spells for the UI into a string
// - spellsKnownUI List of known spells for the UI
// * Returns a list of known spells for the UI in a string form
string JXSpellsKnownUIToString(struct jx_spells_known_ui spellsKnownUI);

// Transform a list of known spells for the UI into a structure
// - sSpellsKnownUI List of known spells for the UI
// * Returns a list of known spells for the UI in a structure form
struct jx_spells_known_ui JXStringToSpellsKnownUI(string sSpellsKnownUI);
















//**************************************//
//                                      //
//            Implementation            //
//                                      //
//**************************************//


const int JX_SPBK_DATA_KNOWNUI_ELEMSIZE = 20;
const int JX_SPBK_KNOWN_UI_MAXSPELLS = 40;


// Get a spell from a list of known spells for the UI
// - spellsKnownUI List of known spells for the UI
// - iSpellList Spell list, from 0 (normal) to 10 (10th metamagic feat)
// - iSpellSlot Slot of the spell to get (from 1 to 30)
// * Returns the desired spell for the UI
struct jx_spell_known_ui JXSpellsKnownUIGetSpell(struct jx_spells_known_ui spellsKnownUI, int iSpellList, int iSpellSlot)
{
	struct jx_spell_known_ui spellKnownUI;
	spellKnownUI.iSpellId = -1;

	if (iSpellList > spellsKnownUI.iMaxSpellList)
		return spellKnownUI;
	if (iSpellList > 10)
		return spellKnownUI;
	if (iSpellList < 0)
		return spellKnownUI;
	if (iSpellSlot < 1)
		return spellKnownUI;
	if (iSpellSlot > JX_SPBK_KNOWN_UI_MAXSPELLS)
		return spellKnownUI;

	// Get the spell list and the metamagic feat for the specified spell list
	int iMetaMagicFeat;
	string sSpells;
	switch (iSpellList)
	{
		case 0:
			iMetaMagicFeat = 0;
			sSpells = spellsKnownUI.sSpellsNormal;
			break;
		case 1:
			iMetaMagicFeat = spellsKnownUI.iMetaMagicFeat1;
			sSpells = spellsKnownUI.sSpellsMetaMagic1;
			break;
		case 2:
			iMetaMagicFeat = spellsKnownUI.iMetaMagicFeat2;
			sSpells = spellsKnownUI.sSpellsMetaMagic2;
			break;
		case 3:
			iMetaMagicFeat = spellsKnownUI.iMetaMagicFeat3;
			sSpells = spellsKnownUI.sSpellsMetaMagic3;
			break;
		case 4:
			iMetaMagicFeat = spellsKnownUI.iMetaMagicFeat4;
			sSpells = spellsKnownUI.sSpellsMetaMagic4;
			break;
		case 5:
			iMetaMagicFeat = spellsKnownUI.iMetaMagicFeat5;
			sSpells = spellsKnownUI.sSpellsMetaMagic5;
			break;
		case 6:
			iMetaMagicFeat = spellsKnownUI.iMetaMagicFeat6;
			sSpells = spellsKnownUI.sSpellsMetaMagic6;
			break;
		case 7:
			iMetaMagicFeat = spellsKnownUI.iMetaMagicFeat7;
			sSpells = spellsKnownUI.sSpellsMetaMagic7;
			break;
		case 8:
			iMetaMagicFeat = spellsKnownUI.iMetaMagicFeat8;
			sSpells = spellsKnownUI.sSpellsMetaMagic8;
			break;
		case 9:
			iMetaMagicFeat = spellsKnownUI.iMetaMagicFeat9;
			sSpells = spellsKnownUI.sSpellsMetaMagic9;
			break;
		case 10:
			iMetaMagicFeat = spellsKnownUI.iMetaMagicFeat10;
			sSpells = spellsKnownUI.sSpellsMetaMagic10;
			break;
	}
	struct jx_array_fixed array = JXFixedArrayToStruct(sSpells);

	// Get the number of spells for the specified spell list
	int iMaxSpellSlot = JXFixedArrayCountElements(array);
	if (iSpellSlot > iMaxSpellSlot)
		return spellKnownUI;

	// Get the spell for the spell slot
	string sSpell = JXFixedArrayGetElement(array, iSpellSlot);
	struct jx_array_delim arraySpell = JXDelimArrayToStruct(sSpell);

	spellKnownUI.iSpellId = StringToInt(JXDelimArrayGetElement(arraySpell, 1));
	spellKnownUI.iMetaMagicFeat = StringToInt(JXDelimArrayGetElement(arraySpell, 2));

	return spellKnownUI;
}

// Set the metamagic feat associated with a spell list from a spells known for the UI
// - spellsKnownUI List of known spells for the UI
// - iSpellList Spell list, from 1 (1st metamagic feat) to 10 (10th metamagic feat)
// - iMetaMagicFeat A combination of METAMAGIC_* constants
// * Returns the updated list of known spells for the UI
struct jx_spells_known_ui JXSpellsKnownUISetMetaMagicFeat(struct jx_spells_known_ui spellsKnownUI, int iSpellList, int iMetaMagicFeat)
{
	if (iSpellList > 10)
		return spellsKnownUI;
	if (iSpellList < 1)
		return spellsKnownUI;

	// Define the new maximum spell list
	if (iSpellList > spellsKnownUI.iMaxSpellList)
		spellsKnownUI.iMaxSpellList = iSpellList;

	// Update the the metamagic attribute of the spell list
	switch (iSpellList)
	{
		case 1: spellsKnownUI.iMetaMagicFeat1 = iMetaMagicFeat; break;
		case 2: spellsKnownUI.iMetaMagicFeat2 = iMetaMagicFeat; break;
		case 3: spellsKnownUI.iMetaMagicFeat3 = iMetaMagicFeat; break;
		case 4: spellsKnownUI.iMetaMagicFeat4 = iMetaMagicFeat; break;
		case 5: spellsKnownUI.iMetaMagicFeat5 = iMetaMagicFeat; break;
		case 6: spellsKnownUI.iMetaMagicFeat6 = iMetaMagicFeat; break;
		case 7: spellsKnownUI.iMetaMagicFeat7 = iMetaMagicFeat; break;
		case 8: spellsKnownUI.iMetaMagicFeat8 = iMetaMagicFeat; break;
		case 9: spellsKnownUI.iMetaMagicFeat9 = iMetaMagicFeat; break;
		case 10: spellsKnownUI.iMetaMagicFeat10 = iMetaMagicFeat; break;
	}

	return spellsKnownUI;
}

// Get the metamagic feat associated with a spell list from a spells known for the UI
// - spellsKnownUI List of known spells for the UI
// - iSpellList Spell list, from 1 (1st metamagic feat) to 10 (10th metamagic feat)
// * Returns combination  of METAMAGIC_* constants
int JXSpellsKnownUIGetMetaMagicFeat(struct jx_spells_known_ui spellsKnownUI, int iSpellList)
{
	if (iSpellList > 10)
		return 0;
	if (iSpellList > spellsKnownUI.iMaxSpellList)
		return 0;
	if (iSpellList < 1)
		return 0;

	// Get the the metamagic attribute of the spell list
	int iMetaMagicFeat = 0;
	switch (iSpellList)
	{
		case 1: iMetaMagicFeat = spellsKnownUI.iMetaMagicFeat1; break;
		case 2: iMetaMagicFeat = spellsKnownUI.iMetaMagicFeat2; break;
		case 3: iMetaMagicFeat = spellsKnownUI.iMetaMagicFeat3; break;
		case 4: iMetaMagicFeat = spellsKnownUI.iMetaMagicFeat4; break;
		case 5: iMetaMagicFeat = spellsKnownUI.iMetaMagicFeat5; break;
		case 6: iMetaMagicFeat = spellsKnownUI.iMetaMagicFeat6; break;
		case 7: iMetaMagicFeat = spellsKnownUI.iMetaMagicFeat7; break;
		case 8: iMetaMagicFeat = spellsKnownUI.iMetaMagicFeat8; break;
		case 9: iMetaMagicFeat = spellsKnownUI.iMetaMagicFeat9; break;
		case 10: iMetaMagicFeat = spellsKnownUI.iMetaMagicFeat10; break;
	}

	return iMetaMagicFeat;
}

// Add a spell to a list of known spells for the UI
// - spellsKnownUI List of known spells for the UI
// - iSpellList Spell list, from 0 (normal) to 10 (10th metamagic)
// - spellKnownUI Known spell for the UI to add
// * Returns the updated list of known spells for the UI
struct jx_spells_known_ui JXSpellsKnownUIAddSpell(struct jx_spells_known_ui spellsKnownUI, int iSpellList, struct jx_spell_known_ui spellKnownUI)
{
	if (iSpellList > 10)
		return spellsKnownUI;
	if (iSpellList < 0)
		return spellsKnownUI;

	// Define the new maximum spell list
	if (iSpellList > spellsKnownUI.iMaxSpellList)
		spellsKnownUI.iMaxSpellList = iSpellList;

	// Get the spell list for the specified spell list
	string sSpells;
	switch (iSpellList)
	{
		case 0: sSpells = spellsKnownUI.sSpellsNormal; break;
		case 1: sSpells = spellsKnownUI.sSpellsMetaMagic1; break;
		case 2: sSpells = spellsKnownUI.sSpellsMetaMagic2; break;
		case 3: sSpells = spellsKnownUI.sSpellsMetaMagic3; break;
		case 4: sSpells = spellsKnownUI.sSpellsMetaMagic4; break;
		case 5: sSpells = spellsKnownUI.sSpellsMetaMagic5; break;
		case 6: sSpells = spellsKnownUI.sSpellsMetaMagic6; break;
		case 7: sSpells = spellsKnownUI.sSpellsMetaMagic7; break;
		case 8: sSpells = spellsKnownUI.sSpellsMetaMagic8; break;
		case 9: sSpells = spellsKnownUI.sSpellsMetaMagic9; break;
		case 10: sSpells = spellsKnownUI.sSpellsMetaMagic10; break;
	}
	struct jx_array_fixed array = JXFixedArrayToStruct(sSpells);

	// Get the number of spells for the specified spell list
	int iMaxSpellSlot = JXFixedArrayCountElements(array);
	if (iMaxSpellSlot == JX_SPBK_KNOWN_UI_MAXSPELLS)
		return spellsKnownUI;

	// Add the spell to the current list
	struct jx_array_delim arraySpell = JXDelimArrayCreate("_");
	arraySpell = JXDelimArrayAddElement(arraySpell, IntToString(spellKnownUI.iSpellId));
	arraySpell = JXDelimArrayAddElement(arraySpell, IntToString(spellKnownUI.iMetaMagicFeat));
	array = JXFixedArrayAddElement(array, JXDelimArrayToString(arraySpell));

	// Update the structure
	sSpells = JXFixedArrayToString(array);
	switch (iSpellList)
	{
		case 0: spellsKnownUI.sSpellsNormal = sSpells; break;
		case 1: spellsKnownUI.sSpellsMetaMagic1 = sSpells; break;
		case 2: spellsKnownUI.sSpellsMetaMagic2 = sSpells; break;
		case 3: spellsKnownUI.sSpellsMetaMagic3 = sSpells; break;
		case 4: spellsKnownUI.sSpellsMetaMagic4 = sSpells; break;
		case 5: spellsKnownUI.sSpellsMetaMagic5 = sSpells; break;
		case 6: spellsKnownUI.sSpellsMetaMagic6 = sSpells; break;
		case 7: spellsKnownUI.sSpellsMetaMagic7 = sSpells; break;
		case 8: spellsKnownUI.sSpellsMetaMagic8 = sSpells; break;
		case 9: spellsKnownUI.sSpellsMetaMagic9 = sSpells; break;
		case 10: spellsKnownUI.sSpellsMetaMagic10 = sSpells; break;
	}

	return spellsKnownUI;
}

// Get the number of spell lists in a list of spells known for the UI
// - spellsKnownUI List of known spells for the UI
// * Returns the number of spell lists
int JXSpellsKnownUIGetNbSpellLists(struct jx_spells_known_ui spellsKnownUI)
{
	return spellsKnownUI.iMaxSpellList;
}

// Get the number of spells available in the list of known spells for the UI
// - spellsKnownUI List of known spells for the UI
// - iSpellList Spell list, from 0 (normal) to 10 (10th metamagic)
// * Returns the number of spells for the specified list
int JXSpellsKnownUIGetNbSpellsForList(struct jx_spells_known_ui spellsKnownUI, int iSpellList)
{
	if (iSpellList > spellsKnownUI.iMaxSpellList)
		return 0;
	if (iSpellList > 10)
		return 0;
	if (iSpellList < 0)
		return 0;

	// Get the spell list for the specified spell list
	string sSpells;
	switch (iSpellList)
	{
		case 0: sSpells = spellsKnownUI.sSpellsNormal; break;
		case 1: sSpells = spellsKnownUI.sSpellsMetaMagic1; break;
		case 2: sSpells = spellsKnownUI.sSpellsMetaMagic2; break;
		case 3: sSpells = spellsKnownUI.sSpellsMetaMagic3; break;
		case 4: sSpells = spellsKnownUI.sSpellsMetaMagic4; break;
		case 5: sSpells = spellsKnownUI.sSpellsMetaMagic5; break;
		case 6: sSpells = spellsKnownUI.sSpellsMetaMagic6; break;
		case 7: sSpells = spellsKnownUI.sSpellsMetaMagic7; break;
		case 8: sSpells = spellsKnownUI.sSpellsMetaMagic8; break;
		case 9: sSpells = spellsKnownUI.sSpellsMetaMagic9; break;
		case 10: sSpells = spellsKnownUI.sSpellsMetaMagic10; break;
	}
	struct jx_array_fixed array = JXFixedArrayToStruct(sSpells);

	// Get the number of spells for the specified spell level
	return JXFixedArrayCountElements(array);
}

// Create a new empty set of spells known UI
// * Returns a new set of spells known UI
struct jx_spells_known_ui JXSpellsKnownUICreateStruct()
{
	struct jx_spells_known_ui spellsKnownUI;

	// Maximum spell list
	spellsKnownUI.iMaxSpellList = 0;
	// Spells known UI list normal
	spellsKnownUI.sSpellsNormal = JXFixedArrayToString(JXFixedArrayCreate(JX_SPBK_DATA_KNOWNUI_ELEMSIZE));
	// Spells known UI list metamagic 1
	spellsKnownUI.iMetaMagicFeat1 = -1;
	spellsKnownUI.sSpellsMetaMagic1 = spellsKnownUI.sSpellsNormal;
	// Spells known UI list metamagic 2
	spellsKnownUI.iMetaMagicFeat2 = -1;
	spellsKnownUI.sSpellsMetaMagic2 = spellsKnownUI.sSpellsNormal;
	// Spells known UI list metamagic 3
	spellsKnownUI.iMetaMagicFeat3 = -1;
	spellsKnownUI.sSpellsMetaMagic3 = spellsKnownUI.sSpellsNormal;
	// Spells known UI list metamagic 4
	spellsKnownUI.iMetaMagicFeat4 = -1;
	spellsKnownUI.sSpellsMetaMagic4 = spellsKnownUI.sSpellsNormal;
	// Spells known UI list metamagic 5
	spellsKnownUI.iMetaMagicFeat5 = -1;
	spellsKnownUI.sSpellsMetaMagic5 = spellsKnownUI.sSpellsNormal;
	// Spells known UI list metamagic 6
	spellsKnownUI.iMetaMagicFeat6 = -1;
	spellsKnownUI.sSpellsMetaMagic6 = spellsKnownUI.sSpellsNormal;
	// Spells known UI list metamagic 7
	spellsKnownUI.iMetaMagicFeat7 = -1;
	spellsKnownUI.sSpellsMetaMagic7 = spellsKnownUI.sSpellsNormal;
	// Spells known UI list metamagic 8
	spellsKnownUI.iMetaMagicFeat8 = -1;
	spellsKnownUI.sSpellsMetaMagic8 = spellsKnownUI.sSpellsNormal;
	// Spells known UI list metamagic 9
	spellsKnownUI.iMetaMagicFeat9 = -1;
	spellsKnownUI.sSpellsMetaMagic9 = spellsKnownUI.sSpellsNormal;
	// Spells known UI list metamagic 10
	spellsKnownUI.iMetaMagicFeat10 = -1;
	spellsKnownUI.sSpellsMetaMagic10 = spellsKnownUI.sSpellsNormal;

	return spellsKnownUI;
}

// Transform a list of known spells for the UI into a string
// - spellsKnownUI List of known spells for the UI
// * Returns a list of known spells for the UI in a string form
string JXSpellsKnownUIToString(struct jx_spells_known_ui spellsKnownUI)
{
	struct jx_array_delim array = JXDelimArrayCreate(";");
	// Maximum spell list
	array = JXDelimArrayAddElement(array, IntToString(spellsKnownUI.iMaxSpellList));
	// Spells known UI list normal
	array = JXDelimArrayAddElement(array, spellsKnownUI.sSpellsNormal);
	// Spells known UI list metamagic 1
	array = JXDelimArrayAddElement(array, IntToString(spellsKnownUI.iMetaMagicFeat1));
	array = JXDelimArrayAddElement(array, spellsKnownUI.sSpellsMetaMagic1);
	// Spells known UI list metamagic 2
	array = JXDelimArrayAddElement(array, IntToString(spellsKnownUI.iMetaMagicFeat2));
	array = JXDelimArrayAddElement(array, spellsKnownUI.sSpellsMetaMagic2);
	// Spells known UI list metamagic 3
	array = JXDelimArrayAddElement(array, IntToString(spellsKnownUI.iMetaMagicFeat3));
	array = JXDelimArrayAddElement(array, spellsKnownUI.sSpellsMetaMagic3);
	// Spells known UI list metamagic 4
	array = JXDelimArrayAddElement(array, IntToString(spellsKnownUI.iMetaMagicFeat4));
	array = JXDelimArrayAddElement(array, spellsKnownUI.sSpellsMetaMagic4);
	// Spells known UI list metamagic 5
	array = JXDelimArrayAddElement(array, IntToString(spellsKnownUI.iMetaMagicFeat5));
	array = JXDelimArrayAddElement(array, spellsKnownUI.sSpellsMetaMagic5);
	// Spells known UI list metamagic 6
	array = JXDelimArrayAddElement(array, IntToString(spellsKnownUI.iMetaMagicFeat6));
	array = JXDelimArrayAddElement(array, spellsKnownUI.sSpellsMetaMagic6);
	// Spells known UI list metamagic 7
	array = JXDelimArrayAddElement(array, IntToString(spellsKnownUI.iMetaMagicFeat7));
	array = JXDelimArrayAddElement(array, spellsKnownUI.sSpellsMetaMagic7);
	// Spells known UI list metamagic 8
	array = JXDelimArrayAddElement(array, IntToString(spellsKnownUI.iMetaMagicFeat8));
	array = JXDelimArrayAddElement(array, spellsKnownUI.sSpellsMetaMagic8);
	// Spells known UI list metamagic 9
	array = JXDelimArrayAddElement(array, IntToString(spellsKnownUI.iMetaMagicFeat9));
	array = JXDelimArrayAddElement(array, spellsKnownUI.sSpellsMetaMagic9);
	// Spells known UI list metamagic 10
	array = JXDelimArrayAddElement(array, IntToString(spellsKnownUI.iMetaMagicFeat10));
	array = JXDelimArrayAddElement(array, spellsKnownUI.sSpellsMetaMagic10);

	return JXDelimArrayToString(array);
}

// Transform a list of known spells for the UI into a structure
// - sSpellsKnownUI List of known spells for the UI
// * Returns a list of known spells for the UI in a structure form
struct jx_spells_known_ui JXStringToSpellsKnownUI(string sSpellsKnownUI)
{
	if (sSpellsKnownUI == "")
		return JXSpellsKnownUICreateStruct();

	struct jx_array_delim array = JXDelimArrayToStruct(sSpellsKnownUI);

	struct jx_spells_known_ui spellsKnownUI;
	// Maximum spell list
	spellsKnownUI.iMaxSpellList = StringToInt(JXDelimArrayGetElement(array, 1));
	// Spells known UI list normal
	spellsKnownUI.sSpellsNormal = JXDelimArrayGetElement(array, 2);
	// Spells known UI list metamagic 1
	spellsKnownUI.iMetaMagicFeat1 = StringToInt(JXDelimArrayGetElement(array, 3));
	spellsKnownUI.sSpellsMetaMagic1 = JXDelimArrayGetElement(array, 4);
	// Spells known UI list metamagic 2
	spellsKnownUI.iMetaMagicFeat2 = StringToInt(JXDelimArrayGetElement(array, 5));
	spellsKnownUI.sSpellsMetaMagic2 = JXDelimArrayGetElement(array, 6);
	// Spells known UI list metamagic 3
	spellsKnownUI.iMetaMagicFeat3 = StringToInt(JXDelimArrayGetElement(array, 7));
	spellsKnownUI.sSpellsMetaMagic3 = JXDelimArrayGetElement(array, 8);
	// Spells known UI list metamagic 4
	spellsKnownUI.iMetaMagicFeat4 = StringToInt(JXDelimArrayGetElement(array, 9));
	spellsKnownUI.sSpellsMetaMagic4 = JXDelimArrayGetElement(array, 10);
	// Spells known UI list metamagic 5
	spellsKnownUI.iMetaMagicFeat5 = StringToInt(JXDelimArrayGetElement(array, 11));
	spellsKnownUI.sSpellsMetaMagic5 = JXDelimArrayGetElement(array, 12);
	// Spells known UI list metamagic 6
	spellsKnownUI.iMetaMagicFeat6 = StringToInt(JXDelimArrayGetElement(array, 13));
	spellsKnownUI.sSpellsMetaMagic6 = JXDelimArrayGetElement(array, 14);
	// Spells known UI list metamagic 7
	spellsKnownUI.iMetaMagicFeat7 = StringToInt(JXDelimArrayGetElement(array, 15));
	spellsKnownUI.sSpellsMetaMagic7 = JXDelimArrayGetElement(array, 16);
	// Spells known UI list metamagic 8
	spellsKnownUI.iMetaMagicFeat8 = StringToInt(JXDelimArrayGetElement(array, 17));
	spellsKnownUI.sSpellsMetaMagic8 = JXDelimArrayGetElement(array, 18);
	// Spells known UI list metamagic 9
	spellsKnownUI.iMetaMagicFeat9 = StringToInt(JXDelimArrayGetElement(array, 19));
	spellsKnownUI.sSpellsMetaMagic9 = JXDelimArrayGetElement(array, 20);
	// Spells known UI list metamagic 10
	spellsKnownUI.iMetaMagicFeat10 = StringToInt(JXDelimArrayGetElement(array, 21));
	spellsKnownUI.sSpellsMetaMagic10 = JXDelimArrayGetElement(array, 22);

	return spellsKnownUI;
}