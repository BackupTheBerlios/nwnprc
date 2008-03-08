//::///////////////////////////////////////////////
//:: JX Spellbook - Sub-Spells Data include
//:: jx_inc_spbk_data
//:://////////////////////////////////////////////
//:://////////////////////////////////////////////
//:: Created By: jallaix
//:: Created On: Dec 9, 2007
//:://////////////////////////////////////////////
//
// This include file provides functions to manage
// sub-spells-related data.
//
// It provides the following functions :
//
// * Associate sub-spells with a master spell
// * Get a master spell
// * Get a sub-spell
// * Create a new empty set of sub-spells
// * Convert sub-spells into a string
// * Convert a string into sub-spells
//
//:://////////////////////////////////////////////

#include "jx_inc_array_delim"
#include "jx_inc_spbk_data_sprdy"


















//**************************************//
//                                      //
//              Interface               //
//                                      //
//**************************************//


// Sub-spells for the UI associated with a master spell
struct jx_subspells_ui
{
	int iMasterSpellId;
	int iMetaMagicFeat;
	int iNbUses;
	int iSubSpellId1;
	int iSubSpellId2;
	int iSubSpellId3;
	int iSubSpellId4;
	int iSubSpellId5;
};


// Get the list of sub-spells for the UI associated with a master spell
// - masterSpell Master spell
// * Returns a list of sub-spells for the UI
struct jx_subspells_ui JXSubSpellsUIGetSubSpells(struct jx_spell_ready masterSpell, int iSubSpellId1, int iSubSpellId2, int iSubSpellId3, int iSubSpellId4, int iSubSpellId5);

// Get the master spell in a list of sub-spells for the UI
// - subSpellsUI List of sub-spells for the UI
// * Returns the master spell found
struct jx_spell_ready JXSubSpellsUIGetMasterSpell(struct jx_subspells_ui subSpellsUI);

// Get a sub-spell in a list of sub-spells for the UI
// - subSpellsUI List of sub-spells for the UI
// - iSubSpellIndex Index of the sub-spell to get in the list (from 1 to 5)
// * Returns the sub-spell found
struct jx_spell_ready JXSubSpellsUIGetSubSpell(struct jx_subspells_ui subSpellsUI, int iSubSpellIndex);

// Create a new empty set of sub-spells
// * Returns a new set of sub-spells
struct jx_subspells_ui JXSubSpellsUICreateStruct();

// Transform a list of sub-spells for the UI into a string
// - subSpellsUI List of sub-spells for the UI
// * Returns a list of sub-spells for the UI in string form
string JXSubSpellsUIToString(struct jx_subspells_ui subSpellsUI);

// Transform a list of sub-spells for the UI into a structure
// - sSubSpells List of sub-spells
// * Returns a list of sub-spells for the UI in structure form
struct jx_subspells_ui JXStringToSubSpellsUI(string sSubSpells);

















//**************************************//
//                                      //
//            Implementation            //
//                                      //
//**************************************//



// Get the list of sub-spells for the UI associated with a master spell
// - masterSpell Master spell
// * Returns a list of sub-spells for the UI
struct jx_subspells_ui JXSubSpellsUIGetSubSpells(struct jx_spell_ready masterSpell, int iSubSpellId1, int iSubSpellId2, int iSubSpellId3, int iSubSpellId4, int iSubSpellId5)
{
	struct jx_subspells_ui subSpellsUI;

	subSpellsUI.iMasterSpellId = masterSpell.iSpellId;
	subSpellsUI.iMetaMagicFeat = masterSpell.iMetaMagicFeat;
	subSpellsUI.iNbUses = masterSpell.iNbUses;
	subSpellsUI.iSubSpellId1 = iSubSpellId1;
	subSpellsUI.iSubSpellId2 = iSubSpellId2;
	subSpellsUI.iSubSpellId3 = iSubSpellId3;
	subSpellsUI.iSubSpellId4 = iSubSpellId4;
	subSpellsUI.iSubSpellId5 = iSubSpellId5;

	return subSpellsUI;
}

// Get the master spell in a list of sub-spells for the UI
// - subSpellsUI List of sub-spells for the UI
// * Returns the master spell found
struct jx_spell_ready JXSubSpellsUIGetMasterSpell(struct jx_subspells_ui subSpellsUI)
{
	struct jx_spell_ready masterSpell;

	masterSpell.iSpellId = subSpellsUI.iMasterSpellId;
	masterSpell.iMetaMagicFeat = subSpellsUI.iMetaMagicFeat;
	masterSpell.iNbUses = subSpellsUI.iNbUses;
	masterSpell.bMaster = TRUE;

	return masterSpell;
}

// Get a sub-spell in a list of sub-spells for the UI
// - subSpellsUI List of sub-spells for the UI
// - iSubSpellIndex Index of the sub-spell to get in the list (from 1 to 5)
// * Returns the sub-spell found
struct jx_spell_ready JXSubSpellsUIGetSubSpell(struct jx_subspells_ui subSpellsUI, int iSubSpellIndex)
{
	struct jx_spell_ready subSpell;

	if ((iSubSpellIndex < 1) || (iSubSpellIndex > 5))
		return subSpell;

	switch (iSubSpellIndex)
	{
		case 1: subSpell.iSpellId = subSpellsUI.iSubSpellId1; break;
		case 2: subSpell.iSpellId = subSpellsUI.iSubSpellId2; break;
		case 3: subSpell.iSpellId = subSpellsUI.iSubSpellId3; break;
		case 4: subSpell.iSpellId = subSpellsUI.iSubSpellId4; break;
		case 5: subSpell.iSpellId = subSpellsUI.iSubSpellId5; break;
	}
	subSpell.iMetaMagicFeat = subSpellsUI.iMetaMagicFeat;
	subSpell.iNbUses = subSpellsUI.iNbUses;
	subSpell.bMaster = FALSE;

	return subSpell;
}

// Create a new empty set of sub-spells
// * Returns a new set of sub-spells
struct jx_subspells_ui JXSubSpellsUICreateStruct()
{
	struct jx_subspells_ui subSpellsUI;

	// Master spell
	subSpellsUI.iMasterSpellId = -1;
	// MetaMagic feat
	subSpellsUI.iMetaMagicFeat = -1;
	// Number of uses
	subSpellsUI.iNbUses = -1;
	// Sub-spell 1
	subSpellsUI.iSubSpellId1 = -1;
	// Sub-spell 2
	subSpellsUI.iSubSpellId2 = -1;
	// Sub-spell 3
	subSpellsUI.iSubSpellId3 = -1;
	// Sub-spell 4
	subSpellsUI.iSubSpellId4 = -1;
	// Sub-spell 5
	subSpellsUI.iSubSpellId5 = -1;

	return subSpellsUI;
}

// Transform a list of sub-spells for the UI into a string
// - subSpellsUI List of sub-spells for the UI
// * Returns a list of sub-spells for the UI in string form
string JXSubSpellsUIToString(struct jx_subspells_ui subSpellsUI)
{
	struct jx_array_delim array = JXDelimArrayCreate(";");
	// Master spell
	array = JXDelimArrayAddElement(array, IntToString(subSpellsUI.iMasterSpellId));
	// MetaMagic feat
	array = JXDelimArrayAddElement(array, IntToString(subSpellsUI.iMetaMagicFeat));
	// Number of uses
	array = JXDelimArrayAddElement(array, IntToString(subSpellsUI.iNbUses));
	// Sub-spell 1
	array = JXDelimArrayAddElement(array, IntToString(subSpellsUI.iSubSpellId1));
	// Sub-spell 2
	array = JXDelimArrayAddElement(array, IntToString(subSpellsUI.iSubSpellId2));
	// Sub-spell 3
	array = JXDelimArrayAddElement(array, IntToString(subSpellsUI.iSubSpellId3));
	// Sub-spell 4
	array = JXDelimArrayAddElement(array, IntToString(subSpellsUI.iSubSpellId4));
	// Sub-spell 5
	array = JXDelimArrayAddElement(array, IntToString(subSpellsUI.iSubSpellId5));

	return JXDelimArrayToString(array);
}

// Transform a list of sub-spells for the UI into a structure
// - sSubSpells List of sub-spells
// * Returns a list of sub-spells for the UI in structure form
struct jx_subspells_ui JXStringToSubSpellsUI(string sSubSpells)
{
	if (sSubSpells == "")
		return JXSubSpellsUICreateStruct();

	struct jx_array_delim array = JXDelimArrayToStruct(sSubSpells);

	struct jx_subspells_ui subSpellsUI;
	// Master spell
	subSpellsUI.iMasterSpellId = StringToInt(JXDelimArrayGetElement(array, 1));
	// MetaMagic feat
	subSpellsUI.iMetaMagicFeat = StringToInt(JXDelimArrayGetElement(array, 2));
	// Number of uses
	subSpellsUI.iNbUses = StringToInt(JXDelimArrayGetElement(array, 3));
	// Sub-spell 1
	subSpellsUI.iSubSpellId1 = StringToInt(JXDelimArrayGetElement(array, 4));
	// Sub-spell 2
	subSpellsUI.iSubSpellId2 = StringToInt(JXDelimArrayGetElement(array, 5));
	// Sub-spell 3
	subSpellsUI.iSubSpellId3 = StringToInt(JXDelimArrayGetElement(array, 6));
	// Sub-spell 4
	subSpellsUI.iSubSpellId4 = StringToInt(JXDelimArrayGetElement(array, 7));
	// Sub-spell 5
	subSpellsUI.iSubSpellId5 = StringToInt(JXDelimArrayGetElement(array, 8));

	return subSpellsUI;
}