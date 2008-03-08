//::///////////////////////////////////////////////
//:: JX Spellbook - Spells Ready Data include
//:: jx_inc_spbk_data_sprdy
//:://////////////////////////////////////////////
//:://////////////////////////////////////////////
//:: Created By: jallaix
//:: Created On: Nov 16, 2007
//:://////////////////////////////////////////////
//
// This include file provides functions to manage
// spells ready-related data.
//
// It provides the following functions :
//
// * Get a sub-list of spells ready for a metamagic feat
// * Get a spell ready
// * Add a spell known UI
// * Set a list of spells ready for a spell level
// * Remove a spell ready
// * Set a spell ready
// * Get the number of ready spells for a spell level
// * Set the number of spell uses global to a spell level
// * Get the number of spell uses global to a spell level
// * Find the spell level of a spell ready
// * Find the slot of a spell ready
// * Contains spell ?
// * Create a new empty set of spells ready
// * Convert spells ready into a string
// * Convert a string into spells ready
//
//:://////////////////////////////////////////////

#include "jx_inc_array_fixed"
#include "jx_inc_array_delim"
#include "jx_inc_spbk_data_spkwnui"


















//**************************************//
//                                      //
//              Interface               //
//                                      //
//**************************************//


// A spell ready to cast (spell id, metamagic feat, uses/day, master spell)
struct jx_spell_ready
{
	int iSpellId;
	int iMetaMagicFeat;
	int iNbUses;
	int bMaster;
};

// List of spells ready to cast (spell id, metamagic feat, uses/day)
struct jx_spells_ready
{
	string sSpellsLevel0;
	int iNbUsesLevel0;
	string sSpellsLevel1;
	int iNbUsesLevel1;
	string sSpellsLevel2;
	int iNbUsesLevel2;
	string sSpellsLevel3;
	int iNbUsesLevel3;
	string sSpellsLevel4;
	int iNbUsesLevel4;
	string sSpellsLevel5;
	int iNbUsesLevel5;
	string sSpellsLevel6;
	int iNbUsesLevel6;
	string sSpellsLevel7;
	int iNbUsesLevel7;
	string sSpellsLevel8;
	int iNbUsesLevel8;
	string sSpellsLevel9;
	int iNbUsesLevel9;
	string sSpellsLevel10;
	int iNbUsesLevel10;
	int iMaxSpellLevel;
	int bGlobalNbUses;
};


// Get a sub-list of spells ready to be cast based on a specific metamagic feat
// - spellsReady List of ready spells
// - iMetaMagic METAMAGIC_* constant
// * Returns the list of ready spells for the metamagic feat
struct jx_spells_ready JXSpellsReadyGetByMetamagic(struct jx_spells_ready spellsReady, int iMetaMagic);

// Get a spell from a list of ready spells
// - spellsReady List of ready spells
// - iSpellLevel Spell level (from 0 to 10)
// - iSpellSlot The slot for the level from where the spell must be get (from 1 to 30)
// * Returns the ready spell found
struct jx_spell_ready JXSpellsReadyGetSpell(struct jx_spells_ready spellsReady, int iSpellLevel, int iSpellSlot);

// Add a known spell for the UI to the list of ready spells
// - spellsReady List of ready spells
// - iSpellLevel Spell level (from 0 to 10)
// - spellKnown Known spell for the UI to add
// - bMaster Indicate if the spell has sub-spells
// - bAddOnly If true, don't try to merge the new spell with an existing spell (used to drastically improve performance)
// * Returns the updated list of ready spells
struct jx_spells_ready JXSpellsReadyAddSpell(struct jx_spells_ready spellsReady, int iSpellLevel, struct jx_spell_known_ui spellKnown, int bMaster = FALSE, int bAddOnly = FALSE);

// Set a list of ready spells for the specified spell level in another list of ready spells
// - spellsReady List of ready spells
// - iSpellLevel Spell level (from 0 to 10)
// - spellsReadyToSet List of ready spells that contains a list of spells to set for the level
// * Returns the updated list of ready spells
struct jx_spells_ready JXSpellsReadySetSpellsForLevel(struct jx_spells_ready spellsReady, int iSpellLevel, struct jx_spells_ready spellsReadyToSet);

// Remove a spell from a list of ready spells
// - spellsReady List of ready spells
// - iSpellLevel Spell level (from 0 to 10)
// - iSpellSlot The slot for the level where the spell must be get (from 1 to 30)
// * Returns the updated list of ready spells
struct jx_spells_ready JXSpellsReadyRemoveSpell(struct jx_spells_ready spellsReady, int iSpellLevel, int iSpellSlot);

// Set a spell in a list of ready spells
// - spellsReady List of ready spells
// - iSpellLevel Spell level (from 0 to 10)
// - iSpellSlot The slot for the level where the spell must be set (from 1 to 30)
// - spellReady The spell to set in the list
// * Returns the updated list of ready spells
struct jx_spells_ready JXSpellsReadySetSpell(struct jx_spells_ready spellsReady, int iSpellLevel, int iSpellSlot, struct jx_spell_ready spellReady);

// Get the number of ready spells for the specified spell level
// - spellsReady List of ready spells
// - iSpellLevel Spell level (from 0 to 10)
// * Returns the number of spells for the specified spell level
int JXSpellsReadyGetNbSpellsForLevel(struct jx_spells_ready spellsReady, int iSpellLevel);

// Set the number of spell uses global to the specified spell level
// - spellsReady List of ready spells
// - iSpellLevel Spell level (from 0 to 10)
// - iNbSpells Number of spells to set
// * Returns the updated list of ready spells
struct jx_spells_ready JXSpellsReadySetNbGlobalSpells(struct jx_spells_ready spellsReady, int iSpellLevel, int iNbSpells);

// Get the number of spell uses global to the specified spell level
// - spellsReady List of ready spells
// - iSpellLevel Spell level (from 0 to 10)
// * Returns a number of spell uses
int JXSpellsReadyGetNbGlobalSpells(struct jx_spells_ready spellsReady, int iSpellLevel);

// Determine if a list of ready spells contains a specific spell, and return its spell level in this case
// - spellsReady List of ready spells
// - iSpellId SPELL_* constant
// - iMetaMagicFeat METAMAGIC_* constant
// - iSpellLevel Spell level from which the spell must be tested (to improve performances)
// * Returns the spell level if the ready spell is found, else returns -1
int JXSpellsReadyFindSpellLevel(struct jx_spells_ready spellsReady, int iSpellId, int iMetaMagicFeat = METAMAGIC_ANY, int iSpellLevel = -1);

// Determine if a list of ready spells contains a specific spell, and return its spell slot in this case
// - spellsReady List of ready spells
// - iSpellId SPELL_* constant
// - iMetaMagicFeat METAMAGIC_* constant
// - iSpellLevel Spell level from which the spell must be tested
// * Returns the spell slot if the ready spell is found, else returns -1
int JXSpellsReadyFindSpellSlot(struct jx_spells_ready spellsReady, int iSpellId, int iMetaMagicFeat = METAMAGIC_ANY, int iSpellLevel = -1);

// Determine if a list of ready spells contains a specific spell
// - spellsready List of ready spells
// - iSpellId SPELL_* constant
// - iMetaMagicFeat METAMAGIC_* constant
// - iSpellLevel Spell level from which the spell must be tested (for better performances)
// * Returns TRUE if is found in the list, else returns FALSE
int JXSpellsReadyContainsSpell(struct jx_spells_ready spellsReady, int iSpellId, int iMetaMagicFeat = METAMAGIC_ANY, int iSpellLevel = -1);

// Create a new empty set of spells ready
// * Returns a new set of spells ready
struct jx_spells_ready JXSpellsReadyCreateStruct();

// Transform a list of ready spells into a string
// - spellsReady List of ready spells
// * Returns a list of ready spells in a string form
string JXSpellsReadyToString(struct jx_spells_ready spellsReady);

// Transform a list of ready spells into a structure
// - sSpellsReady List of ready spells
// * Returns a list of ready spells in a structure form
struct jx_spells_ready JXStringToSpellsReady(string sSpellsReady);
















//**************************************//
//                                      //
//            Implementation            //
//                                      //
//**************************************//


const int JX_SPBK_DATA_READY_ELEMSIZE = 22;
const int JX_SPBK_READY_MAXSPELLS = 10;


// Get a sub-list of spells ready to be cast based on a specific metamagic feat
// - spellsReady List of ready spells
// - iMetaMagic METAMAGIC_* constant
// * Returns the list of ready spells for the metamagic feat
struct jx_spells_ready JXSpellsReadyGetByMetamagic(struct jx_spells_ready spellsReady, int iMetaMagic)
{
	struct jx_spells_ready spellsReadySubList;
	spellsReadySubList.bGlobalNbUses = spellsReady.bGlobalNbUses;

	// Define the maximum spell level
	spellsReadySubList.iMaxSpellLevel = spellsReady.iMaxSpellLevel;
	int iLoopSpellLevel;
	for (iLoopSpellLevel = 0; iLoopSpellLevel <= spellsReady.iMaxSpellLevel; iLoopSpellLevel++)
	{
		// Get the spell list for the current spell level
		string sSpells;
		switch (iLoopSpellLevel)
		{
			case 0: sSpells = spellsReady.sSpellsLevel0; break;
			case 1: sSpells = spellsReady.sSpellsLevel1; break;
			case 2: sSpells = spellsReady.sSpellsLevel2; break;
			case 3: sSpells = spellsReady.sSpellsLevel3; break;
			case 4: sSpells = spellsReady.sSpellsLevel4; break;
			case 5: sSpells = spellsReady.sSpellsLevel5; break;
			case 6: sSpells = spellsReady.sSpellsLevel6; break;
			case 7: sSpells = spellsReady.sSpellsLevel7; break;
			case 8: sSpells = spellsReady.sSpellsLevel8; break;
			case 9: sSpells = spellsReady.sSpellsLevel9; break;
			case 10: sSpells = spellsReady.sSpellsLevel10; break;
		}
		struct jx_array_fixed array = JXFixedArrayToStruct(sSpells);

		// Get the number of spells for the current spell level
		int iMaxSpellSlot = JXFixedArrayCountElements(array);

		// Loop through the spells to determine their metamagic feats
		struct jx_array_delim arraySpell;
		int iLoopSpellSlot = 1;
		while (iLoopSpellSlot <= iMaxSpellSlot)
		{
			// Get the metamagic information of the spell found
			arraySpell = JXDelimArrayToStruct(JXFixedArrayGetElement(array, iLoopSpellSlot));
			int iSpellMetaMagic = StringToInt(JXDelimArrayGetElement(arraySpell, 2));
			// Metamagic found => Add this spell to the result list
			if (iMetaMagic == 0)
			{
				if (iSpellMetaMagic == 0)
					iLoopSpellSlot++;
				else
				{
					array = JXFixedArrayRemoveElement(array, iLoopSpellSlot);
					iMaxSpellSlot--;
				}
			}
			else
			{
				if ((iSpellMetaMagic & iMetaMagic) == iMetaMagic)
					iLoopSpellSlot++;
				else
				{
					array = JXFixedArrayRemoveElement(array, iLoopSpellSlot);
					iMaxSpellSlot--;
				}
			}
		}

		// Update the list of ready spells
		sSpells = JXFixedArrayToString(array);
		switch (iLoopSpellLevel)
		{
			case 0: spellsReady.sSpellsLevel0 = sSpells; break;
			case 1: spellsReady.sSpellsLevel1 = sSpells; break;
			case 2: spellsReady.sSpellsLevel2 = sSpells; break;
			case 3: spellsReady.sSpellsLevel3 = sSpells; break;
			case 4: spellsReady.sSpellsLevel4 = sSpells; break;
			case 5: spellsReady.sSpellsLevel5 = sSpells; break;
			case 6: spellsReady.sSpellsLevel6 = sSpells; break;
			case 7: spellsReady.sSpellsLevel7 = sSpells; break;
			case 8: spellsReady.sSpellsLevel8 = sSpells; break;
			case 9: spellsReady.sSpellsLevel9 = sSpells; break;
			case 10: spellsReady.sSpellsLevel10 = sSpells; break;
		}

		// The number of uses/day may be global to the spell level
		if (spellsReady.bGlobalNbUses == TRUE)
		{
			switch (iLoopSpellLevel)
			{
				case 0: spellsReady.iNbUsesLevel0 = spellsReady.iNbUsesLevel0; break;
				case 1: spellsReady.iNbUsesLevel1 = spellsReady.iNbUsesLevel1; break;
				case 2: spellsReady.iNbUsesLevel2 = spellsReady.iNbUsesLevel2; break;
				case 3: spellsReady.iNbUsesLevel3 = spellsReady.iNbUsesLevel3; break;
				case 4: spellsReady.iNbUsesLevel4 = spellsReady.iNbUsesLevel4; break;
				case 5: spellsReady.iNbUsesLevel5 = spellsReady.iNbUsesLevel5; break;
				case 6: spellsReady.iNbUsesLevel6 = spellsReady.iNbUsesLevel6; break;
				case 7: spellsReady.iNbUsesLevel7 = spellsReady.iNbUsesLevel7; break;
				case 8: spellsReady.iNbUsesLevel8 = spellsReady.iNbUsesLevel8; break;
				case 9: spellsReady.iNbUsesLevel9 = spellsReady.iNbUsesLevel9; break;
				case 10: spellsReady.iNbUsesLevel10 = spellsReady.iNbUsesLevel10; break;
			}
		}
	}

	return spellsReady;
}

// Get a spell from a list of ready spells
// - spellsReady List of ready spells
// - iSpellLevel Spell level (from 0 to 10)
// - iSpellSlot The slot for the level from where the spell must be get (from 1 to 30)
// * Returns the ready spell found
struct jx_spell_ready JXSpellsReadyGetSpell(struct jx_spells_ready spellsReady, int iSpellLevel, int iSpellSlot)
{
	struct jx_spell_ready spellReady;
	spellReady.iSpellId = -1;

	if (iSpellLevel > spellsReady.iMaxSpellLevel)
		return spellReady;
	if (iSpellLevel > 10)
		return spellReady;
	if (iSpellLevel < 0)
		return spellReady;
	if (iSpellSlot < 1)
		return spellReady;
	if (iSpellSlot > JX_SPBK_KNOWN_UI_MAXSPELLS)
		return spellReady;

	// Get the spell list for the specified spell level
	string sSpells;
	switch (iSpellLevel)
	{
		case 0: sSpells = spellsReady.sSpellsLevel0; break;
		case 1: sSpells = spellsReady.sSpellsLevel1; break;
		case 2: sSpells = spellsReady.sSpellsLevel2; break;
		case 3: sSpells = spellsReady.sSpellsLevel3; break;
		case 4: sSpells = spellsReady.sSpellsLevel4; break;
		case 5: sSpells = spellsReady.sSpellsLevel5; break;
		case 6: sSpells = spellsReady.sSpellsLevel6; break;
		case 7: sSpells = spellsReady.sSpellsLevel7; break;
		case 8: sSpells = spellsReady.sSpellsLevel8; break;
		case 9: sSpells = spellsReady.sSpellsLevel9; break;
		case 10: sSpells = spellsReady.sSpellsLevel10; break;
	}
	struct jx_array_fixed array = JXFixedArrayToStruct(sSpells);

	// Get the number of spells for the specified spell level
	int iMaxSpellSlot = JXFixedArrayCountElements(array);
	if (iSpellSlot > iMaxSpellSlot)
		return spellReady;

	// Get informations for the spell found
	struct jx_array_delim arraySpell = JXDelimArrayToStruct(JXFixedArrayGetElement(array, iSpellSlot));
	spellReady.iSpellId = StringToInt(JXDelimArrayGetElement(arraySpell, 1));
	spellReady.iMetaMagicFeat = StringToInt(JXDelimArrayGetElement(arraySpell, 2));
	spellReady.iNbUses = StringToInt(JXDelimArrayGetElement(arraySpell, 3));
	spellReady.bMaster = StringToInt(JXDelimArrayGetElement(arraySpell, 4));

	// The number of uses/day may be global to the spell level
	if (spellsReady.bGlobalNbUses == TRUE)
	{
		int iNbUsesLevel = 0;
		switch (iSpellLevel)
		{
			case 0: iNbUsesLevel = spellsReady.iNbUsesLevel0; break;
			case 1: iNbUsesLevel = spellsReady.iNbUsesLevel1; break;
			case 2: iNbUsesLevel = spellsReady.iNbUsesLevel2; break;
			case 3: iNbUsesLevel = spellsReady.iNbUsesLevel3; break;
			case 4: iNbUsesLevel = spellsReady.iNbUsesLevel4; break;
			case 5: iNbUsesLevel = spellsReady.iNbUsesLevel5; break;
			case 6: iNbUsesLevel = spellsReady.iNbUsesLevel6; break;
			case 7: iNbUsesLevel = spellsReady.iNbUsesLevel7; break;
			case 8: iNbUsesLevel = spellsReady.iNbUsesLevel8; break;
			case 9: iNbUsesLevel = spellsReady.iNbUsesLevel9; break;
			case 10: iNbUsesLevel = spellsReady.iNbUsesLevel10; break;
		}
		spellReady.iNbUses = iNbUsesLevel;
	}

	return spellReady;
}

// Add a known spell for the UI to the list of ready spells
// - spellsReady List of ready spells
// - iSpellLevel Spell level (from 0 to 10)
// - spellKnown Known spell for the UI to add
// - bMaster Indicate if the spell has sub-spells
// - bAddOnly If true, don't try to merge the new spell with an existing spell (used to drastically improve performance)
// * Returns the updated list of ready spells
struct jx_spells_ready JXSpellsReadyAddSpell(struct jx_spells_ready spellsReady, int iSpellLevel, struct jx_spell_known_ui spellKnown, int bMaster, int bAddOnly)
{
	// Get the spell list for the specified spell level
	string sSpells;
	switch (iSpellLevel)
	{
		case 0: sSpells = spellsReady.sSpellsLevel0; break;
		case 1: sSpells = spellsReady.sSpellsLevel1; break;
		case 2: sSpells = spellsReady.sSpellsLevel2; break;
		case 3: sSpells = spellsReady.sSpellsLevel3; break;
		case 4: sSpells = spellsReady.sSpellsLevel4; break;
		case 5: sSpells = spellsReady.sSpellsLevel5; break;
		case 6: sSpells = spellsReady.sSpellsLevel6; break;
		case 7: sSpells = spellsReady.sSpellsLevel7; break;
		case 8: sSpells = spellsReady.sSpellsLevel8; break;
		case 9: sSpells = spellsReady.sSpellsLevel9; break;
		case 10: sSpells = spellsReady.sSpellsLevel10; break;
	}
	struct jx_array_fixed array = JXFixedArrayToStruct(sSpells);

	// Get the number of spells for the specified spell level
	int iMaxSpellSlot = JXFixedArrayCountElements(array);

	struct jx_array_delim arraySpell;
	int iSpellId, iMetaMagicFeat, iNbUses;
	int bSlotFound = FALSE;

	// Loop through the slots to determine if the spell already exists
	if (!bAddOnly)
	{
		int iLoopSlot;
		for (iLoopSlot = 1; iLoopSlot <= iMaxSpellSlot; iLoopSlot++)
		{
			// Get informations about the current spell
			arraySpell = JXDelimArrayToStruct(JXFixedArrayGetElement(array, iLoopSlot));
			iSpellId = StringToInt(JXDelimArrayGetElement(arraySpell, 1));
			iMetaMagicFeat = StringToInt(JXDelimArrayGetElement(arraySpell, 2));
	
			// Increase the uses/day of the spell if it is found in the list
			if ((spellKnown.iSpellId == iSpellId)
			 && (spellKnown.iMetaMagicFeat == iMetaMagicFeat))
			{
				bSlotFound = TRUE;
				iNbUses = (spellsReady.bGlobalNbUses == TRUE) ? 1 : StringToInt(JXDelimArrayGetElement(arraySpell, 3)) + 1;
				arraySpell = JXDelimArraySetElement(arraySpell, IntToString(iNbUses), 3);
				arraySpell = JXDelimArraySetElement(arraySpell, IntToString(bMaster), 4);
				array = JXFixedArraySetElement(array, JXDelimArrayToString(arraySpell), iLoopSlot);
				break;
			}
		}
	}

	// Add the new spell if it does not already exist
	if (bSlotFound == FALSE)
	{
		arraySpell = JXDelimArrayCreate("_");
		arraySpell = JXDelimArrayAddElement(arraySpell, IntToString(spellKnown.iSpellId));
		arraySpell = JXDelimArrayAddElement(arraySpell, IntToString(spellKnown.iMetaMagicFeat));
		arraySpell = JXDelimArrayAddElement(arraySpell, "1");
		arraySpell = JXDelimArrayAddElement(arraySpell, IntToString(bMaster));
		array = JXFixedArrayAddElement(array, JXDelimArrayToString(arraySpell));
	}

	// Update the list of spells for the specified spell level;
	sSpells = JXFixedArrayToString(array);
	switch (iSpellLevel)
	{
		case 0: spellsReady.sSpellsLevel0 = sSpells; break;
		case 1: spellsReady.sSpellsLevel1 = sSpells; break;
		case 2: spellsReady.sSpellsLevel2 = sSpells; break;
		case 3: spellsReady.sSpellsLevel3 = sSpells; break;
		case 4: spellsReady.sSpellsLevel4 = sSpells; break;
		case 5: spellsReady.sSpellsLevel5 = sSpells; break;
		case 6: spellsReady.sSpellsLevel6 = sSpells; break;
		case 7: spellsReady.sSpellsLevel7 = sSpells; break;
		case 8: spellsReady.sSpellsLevel8 = sSpells; break;
		case 9: spellsReady.sSpellsLevel9 = sSpells; break;
		case 10: spellsReady.sSpellsLevel10 = sSpells; break;
	}

	// Update the maximum spell level
	if (iSpellLevel > spellsReady.iMaxSpellLevel)
		spellsReady.iMaxSpellLevel = iSpellLevel;

	return spellsReady;
}

// Set a list of ready spells for the specified spell level in another list of ready spells
// - spellsReady List of ready spells
// - iSpellLevel Spell level (from 0 to 10)
// - spellsReadyToSet List of ready spells that contains a list of spells to set for the level
// * Returns the updated list of ready spells
struct jx_spells_ready JXSpellsReadySetSpellsForLevel(struct jx_spells_ready spellsReady, int iSpellLevel, struct jx_spells_ready spellsReadyToSet)
{
	// Get the spell list for the specified spell level
	string sSpells;
	switch (iSpellLevel)
	{
		case 0: sSpells = spellsReadyToSet.sSpellsLevel0; break;
		case 1: sSpells = spellsReadyToSet.sSpellsLevel1; break;
		case 2: sSpells = spellsReadyToSet.sSpellsLevel2; break;
		case 3: sSpells = spellsReadyToSet.sSpellsLevel3; break;
		case 4: sSpells = spellsReadyToSet.sSpellsLevel4; break;
		case 5: sSpells = spellsReadyToSet.sSpellsLevel5; break;
		case 6: sSpells = spellsReadyToSet.sSpellsLevel6; break;
		case 7: sSpells = spellsReadyToSet.sSpellsLevel7; break;
		case 8: sSpells = spellsReadyToSet.sSpellsLevel8; break;
		case 9: sSpells = spellsReadyToSet.sSpellsLevel9; break;
		case 10: sSpells = spellsReadyToSet.sSpellsLevel10; break;
	}
	struct jx_array_fixed array = JXFixedArrayToStruct(sSpells);

	// Get the number of spells for the specified spell level
	int iMaxSpellSlot = JXFixedArrayCountElements(array);
	if (iMaxSpellSlot > 0)
	{
		// Update the list of spells for the specified spell level;
		switch (iSpellLevel)
		{
			case 0: spellsReady.sSpellsLevel0 = sSpells; break;
			case 1: spellsReady.sSpellsLevel1 = sSpells; break;
			case 2: spellsReady.sSpellsLevel2 = sSpells; break;
			case 3: spellsReady.sSpellsLevel3 = sSpells; break;
			case 4: spellsReady.sSpellsLevel4 = sSpells; break;
			case 5: spellsReady.sSpellsLevel5 = sSpells; break;
			case 6: spellsReady.sSpellsLevel6 = sSpells; break;
			case 7: spellsReady.sSpellsLevel7 = sSpells; break;
			case 8: spellsReady.sSpellsLevel8 = sSpells; break;
			case 9: spellsReady.sSpellsLevel9 = sSpells; break;
			case 10: spellsReady.sSpellsLevel10 = sSpells; break;
		}
	
		// Update the maximum spell level
		if (iSpellLevel > spellsReady.iMaxSpellLevel)
			spellsReady.iMaxSpellLevel = iSpellLevel;
	}

	return spellsReady;
}

// Remove a spell from a list of ready spells
// - spellsReady List of ready spells
// - iSpellLevel Spell level (from 0 to 10)
// - iSpellSlot The slot for the level where the spell must be get (from 1 to 30)
// * Returns the updated list of ready spells
struct jx_spells_ready JXSpellsReadyRemoveSpell(struct jx_spells_ready spellsReady, int iSpellLevel, int iSpellSlot)
{
	if (iSpellLevel > spellsReady.iMaxSpellLevel)
		return spellsReady;
	if (iSpellLevel > 10)
		return spellsReady;
	if (iSpellLevel < 0)
		return spellsReady;
	if (iSpellSlot < 1)
		return spellsReady;
	if (iSpellSlot > JX_SPBK_KNOWN_UI_MAXSPELLS)
		return spellsReady;

	// Get the spell list for the specified spell level
	string sSpells;
	switch (iSpellLevel)
	{
		case 0: sSpells = spellsReady.sSpellsLevel0; break;
		case 1: sSpells = spellsReady.sSpellsLevel1; break;
		case 2: sSpells = spellsReady.sSpellsLevel2; break;
		case 3: sSpells = spellsReady.sSpellsLevel3; break;
		case 4: sSpells = spellsReady.sSpellsLevel4; break;
		case 5: sSpells = spellsReady.sSpellsLevel5; break;
		case 6: sSpells = spellsReady.sSpellsLevel6; break;
		case 7: sSpells = spellsReady.sSpellsLevel7; break;
		case 8: sSpells = spellsReady.sSpellsLevel8; break;
		case 9: sSpells = spellsReady.sSpellsLevel9; break;
		case 10: sSpells = spellsReady.sSpellsLevel10; break;
	}
	struct jx_array_fixed array = JXFixedArrayToStruct(sSpells);

	// Get the number of spells for the specified spell level
	int iMaxSpellSlot = JXFixedArrayCountElements(array);
	if (iSpellSlot > iMaxSpellSlot)
		return spellsReady;

	// Remove the spell ready from the current list
	array = JXFixedArrayRemoveElement(array, iSpellSlot);

	// Update the list of spells for the specified spell level;
	sSpells = JXFixedArrayToString(array);
	switch (iSpellLevel)
	{
		case 0: spellsReady.sSpellsLevel0 = sSpells; break;
		case 1: spellsReady.sSpellsLevel1 = sSpells; break;
		case 2: spellsReady.sSpellsLevel2 = sSpells; break;
		case 3: spellsReady.sSpellsLevel3 = sSpells; break;
		case 4: spellsReady.sSpellsLevel4 = sSpells; break;
		case 5: spellsReady.sSpellsLevel5 = sSpells; break;
		case 6: spellsReady.sSpellsLevel6 = sSpells; break;
		case 7: spellsReady.sSpellsLevel7 = sSpells; break;
		case 8: spellsReady.sSpellsLevel8 = sSpells; break;
		case 9: spellsReady.sSpellsLevel9 = sSpells; break;
		case 10: spellsReady.sSpellsLevel10 = sSpells; break;
	}

	return spellsReady;
}

// Set a spell in a list of ready spells
// - spellsReady List of ready spells
// - iSpellLevel Spell level (from 0 to 10)
// - iSpellSlot The slot for the level where the spell must be set (from 1 to 30)
// - spellReady The spell to set in the list
// * Returns the updated list of ready spells
struct jx_spells_ready JXSpellsReadySetSpell(struct jx_spells_ready spellsReady, int iSpellLevel, int iSpellSlot, struct jx_spell_ready spellReady)
{
	if (iSpellLevel > spellsReady.iMaxSpellLevel)
		return spellsReady;
	if (iSpellLevel > 10)
		return spellsReady;
	if (iSpellLevel < 0)
		return spellsReady;
	if (iSpellSlot < 1)
		return spellsReady;
	if (iSpellSlot > JX_SPBK_KNOWN_UI_MAXSPELLS)
		return spellsReady;

	// Get the spell list for the specified spell level
	string sSpells;
	switch (iSpellLevel)
	{
		case 0: sSpells = spellsReady.sSpellsLevel0; break;
		case 1: sSpells = spellsReady.sSpellsLevel1; break;
		case 2: sSpells = spellsReady.sSpellsLevel2; break;
		case 3: sSpells = spellsReady.sSpellsLevel3; break;
		case 4: sSpells = spellsReady.sSpellsLevel4; break;
		case 5: sSpells = spellsReady.sSpellsLevel5; break;
		case 6: sSpells = spellsReady.sSpellsLevel6; break;
		case 7: sSpells = spellsReady.sSpellsLevel7; break;
		case 8: sSpells = spellsReady.sSpellsLevel8; break;
		case 9: sSpells = spellsReady.sSpellsLevel9; break;
		case 10: sSpells = spellsReady.sSpellsLevel10; break;
	}
	struct jx_array_fixed array = JXFixedArrayToStruct(sSpells);

	// Get the number of spells for the specified spell level
	int iMaxSpellSlot = JXFixedArrayCountElements(array);
	if (iSpellSlot > iMaxSpellSlot)
		return spellsReady;

	// Set the spell at the specified slot
	struct jx_array_delim arraySpell = JXDelimArrayCreate("_");
	arraySpell = JXDelimArrayAddElement(arraySpell, IntToString(spellReady.iSpellId));
	arraySpell = JXDelimArrayAddElement(arraySpell, IntToString(spellReady.iMetaMagicFeat));
	arraySpell = JXDelimArrayAddElement(arraySpell, IntToString((spellsReady.bGlobalNbUses == TRUE) ? 1 : spellReady.iNbUses));
	arraySpell = JXDelimArrayAddElement(arraySpell, IntToString(spellReady.bMaster));
	array = JXFixedArraySetElement(array, JXDelimArrayToString(arraySpell), iSpellSlot);

	// Update the list of spells for the specified spell level;
	sSpells = JXFixedArrayToString(array);
	switch (iSpellLevel)
	{
		case 0: spellsReady.sSpellsLevel0 = sSpells; break;
		case 1: spellsReady.sSpellsLevel1 = sSpells; break;
		case 2: spellsReady.sSpellsLevel2 = sSpells; break;
		case 3: spellsReady.sSpellsLevel3 = sSpells; break;
		case 4: spellsReady.sSpellsLevel4 = sSpells; break;
		case 5: spellsReady.sSpellsLevel5 = sSpells; break;
		case 6: spellsReady.sSpellsLevel6 = sSpells; break;
		case 7: spellsReady.sSpellsLevel7 = sSpells; break;
		case 8: spellsReady.sSpellsLevel8 = sSpells; break;
		case 9: spellsReady.sSpellsLevel9 = sSpells; break;
		case 10: spellsReady.sSpellsLevel10 = sSpells; break;
	}

	return spellsReady;
}

// Get the number of ready spells for the specified spell level
// - spellsReady List of ready spells
// - iSpellLevel Spell level (from 0 to 10)
// * Returns the number of spells for the specified spell level
int JXSpellsReadyGetNbSpellsForLevel(struct jx_spells_ready spellsReady, int iSpellLevel)
{
	if (iSpellLevel > spellsReady.iMaxSpellLevel)
		return 0;
	if (iSpellLevel > 10)
		return 0;
	if (iSpellLevel < 0)
		return 0;

	// Get the spell list for the specified spell level
	string sSpells;
	switch (iSpellLevel)
	{
		case 0: sSpells = spellsReady.sSpellsLevel0; break;
		case 1: sSpells = spellsReady.sSpellsLevel1; break;
		case 2: sSpells = spellsReady.sSpellsLevel2; break;
		case 3: sSpells = spellsReady.sSpellsLevel3; break;
		case 4: sSpells = spellsReady.sSpellsLevel4; break;
		case 5: sSpells = spellsReady.sSpellsLevel5; break;
		case 6: sSpells = spellsReady.sSpellsLevel6; break;
		case 7: sSpells = spellsReady.sSpellsLevel7; break;
		case 8: sSpells = spellsReady.sSpellsLevel8; break;
		case 9: sSpells = spellsReady.sSpellsLevel9; break;
		case 10: sSpells = spellsReady.sSpellsLevel10; break;
	}
	struct jx_array_fixed array = JXFixedArrayToStruct(sSpells);

	return JXFixedArrayCountElements(array);
}

// Set the number of spell uses global to the specified spell level
// - spellsReady List of ready spells
// - iSpellLevel Spell level (from 0 to 10)
// - iNbSpells Number of spells to set
// * Returns the updated list of ready spells
struct jx_spells_ready JXSpellsReadySetNbGlobalSpells(struct jx_spells_ready spellsReady, int iSpellLevel, int iNbSpells)
{
	// Set the number of spells as global each spell level
	spellsReady.bGlobalNbUses = TRUE;

	// Set the number of spell uses for the specified spell level
	switch (iSpellLevel)
	{
		case 0: spellsReady.iNbUsesLevel0 = iNbSpells; break;
		case 1: spellsReady.iNbUsesLevel1 = iNbSpells; break;
		case 2: spellsReady.iNbUsesLevel2 = iNbSpells; break;
		case 3: spellsReady.iNbUsesLevel3 = iNbSpells; break;
		case 4: spellsReady.iNbUsesLevel4 = iNbSpells; break;
		case 5: spellsReady.iNbUsesLevel5 = iNbSpells; break;
		case 6: spellsReady.iNbUsesLevel6 = iNbSpells; break;
		case 7: spellsReady.iNbUsesLevel7 = iNbSpells; break;
		case 8: spellsReady.iNbUsesLevel8 = iNbSpells; break;
		case 9: spellsReady.iNbUsesLevel9 = iNbSpells; break;
		case 10: spellsReady.iNbUsesLevel10 = iNbSpells; break;
	}

	return spellsReady;
}

// Get the number of spell uses global to the specified spell level
// - spellsReady List of ready spells
// - iSpellLevel Spell level (from 0 to 10)
// * Returns a number of spell uses
int JXSpellsReadyGetNbGlobalSpells(struct jx_spells_ready spellsReady, int iSpellLevel)
{
	if (spellsReady.bGlobalNbUses == FALSE)
		return -1;

	// Get the number of spell uses for the specified spell level
	int iNbSpells;
	switch (iSpellLevel)
	{
		case 0: iNbSpells = spellsReady.iNbUsesLevel0; break;
		case 1: iNbSpells = spellsReady.iNbUsesLevel1; break;
		case 2: iNbSpells = spellsReady.iNbUsesLevel2; break;
		case 3: iNbSpells = spellsReady.iNbUsesLevel3; break;
		case 4: iNbSpells = spellsReady.iNbUsesLevel4; break;
		case 5: iNbSpells = spellsReady.iNbUsesLevel5; break;
		case 6: iNbSpells = spellsReady.iNbUsesLevel6; break;
		case 7: iNbSpells = spellsReady.iNbUsesLevel7; break;
		case 8: iNbSpells = spellsReady.iNbUsesLevel8; break;
		case 9: iNbSpells = spellsReady.iNbUsesLevel9; break;
		case 10: iNbSpells = spellsReady.iNbUsesLevel10; break;
	}

	return iNbSpells;
}

// Determine if a list of ready spells contains a specific spell, and return its spell level in this case
// - spellsReady List of ready spells
// - iSpellId SPELL_* constant
// - iMetaMagicFeat METAMAGIC_* constant
// - iSpellLevel Spell level from which the spell must be tested (to improve performances)
// * Returns the spell level if the ready spell is found, else returns -1
int JXSpellsReadyFindSpellLevel(struct jx_spells_ready spellsReady, int iSpellId, int iMetaMagicFeat, int iSpellLevel)
{
	if (iSpellLevel > spellsReady.iMaxSpellLevel)
		return -1;
	if (iSpellLevel > 10)
		return -1;
	if (iSpellLevel < -1)
		return -1;

	// Find the spell levels that have to be checked
	int iLoopSpellLevel = 0;
	int iMaxSpellLevel = spellsReady.iMaxSpellLevel;
	if (iSpellLevel != -1)
	{
		iLoopSpellLevel = iSpellLevel;
		iMaxSpellLevel = iSpellLevel;
	}

	// Define the sub-string to search
	string sSpellReady = "4 _" + IntToString(iSpellId) + "_";
	if (iMetaMagicFeat != METAMAGIC_ANY)
		sSpellReady += IntToString(iMetaMagicFeat) + "_";

	// Loop through the spell levels to find the specified spell
	for (; iLoopSpellLevel <= iMaxSpellLevel; iLoopSpellLevel++)
	{
		// Get the spell list for the current spell level
		string sSpells;
		switch (iLoopSpellLevel)
		{
			case 0: sSpells = spellsReady.sSpellsLevel0; break;
			case 1: sSpells = spellsReady.sSpellsLevel1; break;
			case 2: sSpells = spellsReady.sSpellsLevel2; break;
			case 3: sSpells = spellsReady.sSpellsLevel3; break;
			case 4: sSpells = spellsReady.sSpellsLevel4; break;
			case 5: sSpells = spellsReady.sSpellsLevel5; break;
			case 6: sSpells = spellsReady.sSpellsLevel6; break;
			case 7: sSpells = spellsReady.sSpellsLevel7; break;
			case 8: sSpells = spellsReady.sSpellsLevel8; break;
			case 9: sSpells = spellsReady.sSpellsLevel9; break;
			case 10: sSpells = spellsReady.sSpellsLevel10; break;
		}

		// Check the availability of the ready spell
		if (FindSubString(sSpells, sSpellReady) > -1)
			return iLoopSpellLevel;
	}

	return -1;
}

// Determine if a list of ready spells contains a specific spell, and return its spell slot in this case
// - spellsReady List of ready spells
// - spellReady Ready spell to search
// - iSpellLevel Spell level from which the spell must be tested
// * Returns the spell slot if the ready spell is found, else returns -1
int JXSpellsReadyFindSpellSlot(struct jx_spells_ready spellsReady, int iSpellId, int iMetaMagicFeat, int iSpellLevel)
{
	if (iSpellLevel > spellsReady.iMaxSpellLevel)
		return -1;
	if (iSpellLevel > 10)
		return -1;
	if (iSpellLevel < -1)
		return -1;

	if (iSpellLevel == -1)
		iSpellLevel = JXSpellsReadyFindSpellLevel(spellsReady, iSpellId, iMetaMagicFeat);
	if (iSpellLevel == -1)
		return -1;

	// Define the sub-string to search
	string sSpellReady = "4 _" + IntToString(iSpellId) + "_";
	if (iMetaMagicFeat != METAMAGIC_ANY)
		sSpellReady += IntToString(iMetaMagicFeat) + "_";

	// Get the spell list for the current spell level
	string sSpells;
	switch (iSpellLevel)
	{
		case 0: sSpells = spellsReady.sSpellsLevel0; break;
		case 1: sSpells = spellsReady.sSpellsLevel1; break;
		case 2: sSpells = spellsReady.sSpellsLevel2; break;
		case 3: sSpells = spellsReady.sSpellsLevel3; break;
		case 4: sSpells = spellsReady.sSpellsLevel4; break;
		case 5: sSpells = spellsReady.sSpellsLevel5; break;
		case 6: sSpells = spellsReady.sSpellsLevel6; break;
		case 7: sSpells = spellsReady.sSpellsLevel7; break;
		case 8: sSpells = spellsReady.sSpellsLevel8; break;
		case 9: sSpells = spellsReady.sSpellsLevel9; break;
		case 10: sSpells = spellsReady.sSpellsLevel10; break;
	}
	struct jx_array_fixed array = JXFixedArrayToStruct(sSpells);

	return JXFixedArrayFindElement(array, sSpellReady, TRUE);
}

// Determine if a list of ready spells contains a specific spell
// - spellsready List of ready spells
// - iSpellId SPELL_* constant
// - iMetaMagicFeat METAMAGIC_* constant
// - iSpellLevel Spell level from which the spell must be tested (for better performances)
// * Returns TRUE if is found in the list, else returns FALSE
int JXSpellsReadyContainsSpell(struct jx_spells_ready spellsReady, int iSpellId, int iMetaMagicFeat, int iSpellLevel)
{
	// Define the sub-string to search
	string sSpellReady = "4 _" + IntToString(iSpellId) + "_";
	if (iMetaMagicFeat != METAMAGIC_ANY)
		sSpellReady += IntToString(iMetaMagicFeat) + "_";

	string sSpells;
	if (iSpellLevel > -1)
	{
		switch (iSpellLevel)
		{
			case 0: sSpells = spellsReady.sSpellsLevel0; break;
			case 1: sSpells = spellsReady.sSpellsLevel1; break;
			case 2: sSpells = spellsReady.sSpellsLevel2; break;
			case 3: sSpells = spellsReady.sSpellsLevel3; break;
			case 4: sSpells = spellsReady.sSpellsLevel4; break;
			case 5: sSpells = spellsReady.sSpellsLevel5; break;
			case 6: sSpells = spellsReady.sSpellsLevel6; break;
			case 7: sSpells = spellsReady.sSpellsLevel7; break;
			case 8: sSpells = spellsReady.sSpellsLevel8; break;
			case 9: sSpells = spellsReady.sSpellsLevel9; break;
			case 10: sSpells = spellsReady.sSpellsLevel10; break;
		}
	}
	else
		sSpells = spellsReady.sSpellsLevel0 +
				  spellsReady.sSpellsLevel1 +
				  spellsReady.sSpellsLevel2 +
				  spellsReady.sSpellsLevel3 +
				  spellsReady.sSpellsLevel4 +
				  spellsReady.sSpellsLevel5 +
				  spellsReady.sSpellsLevel6 +
				  spellsReady.sSpellsLevel7 +
				  spellsReady.sSpellsLevel8 +
				  spellsReady.sSpellsLevel9 +
				  spellsReady.sSpellsLevel10;

	// Check the availability of the ready spell
	if (FindSubString(sSpells, sSpellReady) > -1)
		return TRUE;
	else
		return FALSE;
}

// Create a new empty set of spells ready
// * Returns a new set of spells ready
struct jx_spells_ready JXSpellsReadyCreateStruct()
{
	struct jx_spells_ready spellsReady;

	// Maximum spell level
	spellsReady.iMaxSpellLevel = -1;
	// Uses/day global to the spell levels
	spellsReady.bGlobalNbUses = 0;
	// Spells ready level 0
	spellsReady.iNbUsesLevel0 = -1;
	spellsReady.sSpellsLevel0 = JXFixedArrayToString(JXFixedArrayCreate(JX_SPBK_DATA_READY_ELEMSIZE));
	// Spells ready level 1
	spellsReady.iNbUsesLevel1 = -1;
	spellsReady.sSpellsLevel1 = spellsReady.sSpellsLevel0;
	// Spells ready level 2
	spellsReady.iNbUsesLevel2 = -1;
	spellsReady.sSpellsLevel2 = spellsReady.sSpellsLevel0;
	// Spells ready level 3
	spellsReady.iNbUsesLevel3 = -1;
	spellsReady.sSpellsLevel3 = spellsReady.sSpellsLevel0;
	// Spells ready level 4
	spellsReady.iNbUsesLevel4 = -1;
	spellsReady.sSpellsLevel4 = spellsReady.sSpellsLevel0;
	// Spells ready level 5
	spellsReady.iNbUsesLevel5 = -1;
	spellsReady.sSpellsLevel5 = spellsReady.sSpellsLevel0;
	// Spells ready level 6
	spellsReady.iNbUsesLevel6 = -1;
	spellsReady.sSpellsLevel6 = spellsReady.sSpellsLevel0;
	// Spells ready level 7
	spellsReady.iNbUsesLevel7 = -1;
	spellsReady.sSpellsLevel7 = spellsReady.sSpellsLevel0;
	// Spells ready level 8
	spellsReady.iNbUsesLevel8 = -1;
	spellsReady.sSpellsLevel8 = spellsReady.sSpellsLevel0;
	// Spells ready level 9
	spellsReady.iNbUsesLevel9 = -1;
	spellsReady.sSpellsLevel9 = spellsReady.sSpellsLevel0;
	// Spells ready level 10
	spellsReady.iNbUsesLevel10 = -1;
	spellsReady.sSpellsLevel10 = spellsReady.sSpellsLevel0;

	return spellsReady;
}

// Transform a list of ready spells into a string
// - spellsReady List of ready spells
// * Returns a list of ready spells in a string form
string JXSpellsReadyToString(struct jx_spells_ready spellsReady)
{
	struct jx_array_delim array = JXDelimArrayCreate(";");
	// Maximum spell level
	array = JXDelimArrayAddElement(array, IntToString(spellsReady.iMaxSpellLevel));
	// Uses/day global to the spell levels
	array = JXDelimArrayAddElement(array, IntToString(spellsReady.bGlobalNbUses));
	// Spells ready level 0
	array = JXDelimArrayAddElement(array, IntToString(spellsReady.iNbUsesLevel0));
	array = JXDelimArrayAddElement(array, spellsReady.sSpellsLevel0);
	// Spells ready level 1
	array = JXDelimArrayAddElement(array, IntToString(spellsReady.iNbUsesLevel1));
	array = JXDelimArrayAddElement(array, spellsReady.sSpellsLevel1);
	// Spells ready level 2
	array = JXDelimArrayAddElement(array, IntToString(spellsReady.iNbUsesLevel2));
	array = JXDelimArrayAddElement(array, spellsReady.sSpellsLevel2);
	// Spells ready level 3
	array = JXDelimArrayAddElement(array, IntToString(spellsReady.iNbUsesLevel3));
	array = JXDelimArrayAddElement(array, spellsReady.sSpellsLevel3);
	// Spells ready level 4
	array = JXDelimArrayAddElement(array, IntToString(spellsReady.iNbUsesLevel4));
	array = JXDelimArrayAddElement(array, spellsReady.sSpellsLevel4);
	// Spells ready level 5
	array = JXDelimArrayAddElement(array, IntToString(spellsReady.iNbUsesLevel5));
	array = JXDelimArrayAddElement(array, spellsReady.sSpellsLevel5);
	// Spells ready level 6
	array = JXDelimArrayAddElement(array, IntToString(spellsReady.iNbUsesLevel6));
	array = JXDelimArrayAddElement(array, spellsReady.sSpellsLevel6);
	// Spells ready level 7
	array = JXDelimArrayAddElement(array, IntToString(spellsReady.iNbUsesLevel7));
	array = JXDelimArrayAddElement(array, spellsReady.sSpellsLevel7);
	// Spells ready level 8
	array = JXDelimArrayAddElement(array, IntToString(spellsReady.iNbUsesLevel8));
	array = JXDelimArrayAddElement(array, spellsReady.sSpellsLevel8);
	// Spells ready level 9
	array = JXDelimArrayAddElement(array, IntToString(spellsReady.iNbUsesLevel9));
	array = JXDelimArrayAddElement(array, spellsReady.sSpellsLevel9);
	// Spells ready level 10
	array = JXDelimArrayAddElement(array, IntToString(spellsReady.iNbUsesLevel10));
	array = JXDelimArrayAddElement(array, spellsReady.sSpellsLevel10);

	return JXDelimArrayToString(array);
}

// Transform a list of ready spells into a structure
// - sSpellsReady List of ready spells
// * Returns a list of ready spells in a structure form
struct jx_spells_ready JXStringToSpellsReady(string sSpellsReady)
{
	if (sSpellsReady == "")
		return JXSpellsReadyCreateStruct();

	struct jx_array_delim array = JXDelimArrayToStruct(sSpellsReady);

	struct jx_spells_ready spellsReady;
	// Maximum spell level
	spellsReady.iMaxSpellLevel = StringToInt(JXDelimArrayGetElement(array, 1));
	// Uses/day global to the spell levels
	spellsReady.bGlobalNbUses = StringToInt(JXDelimArrayGetElement(array, 2));
	// Spells ready level 0
	spellsReady.iNbUsesLevel0 = StringToInt(JXDelimArrayGetElement(array, 3));
	spellsReady.sSpellsLevel0 = JXDelimArrayGetElement(array, 4);
	// Spells ready level 1
	spellsReady.iNbUsesLevel1 = StringToInt(JXDelimArrayGetElement(array, 5));
	spellsReady.sSpellsLevel1 = JXDelimArrayGetElement(array, 6);
	// Spells ready level 2
	spellsReady.iNbUsesLevel2 = StringToInt(JXDelimArrayGetElement(array, 7));
	spellsReady.sSpellsLevel2 = JXDelimArrayGetElement(array, 8);
	// Spells ready level 3
	spellsReady.iNbUsesLevel3 = StringToInt(JXDelimArrayGetElement(array, 9));
	spellsReady.sSpellsLevel3 = JXDelimArrayGetElement(array, 10);
	// Spells ready level 4
	spellsReady.iNbUsesLevel4 = StringToInt(JXDelimArrayGetElement(array, 11));
	spellsReady.sSpellsLevel4 = JXDelimArrayGetElement(array, 12);
	// Spells ready level 5
	spellsReady.iNbUsesLevel5 = StringToInt(JXDelimArrayGetElement(array, 13));
	spellsReady.sSpellsLevel5 = JXDelimArrayGetElement(array, 14);
	// Spells ready level 6
	spellsReady.iNbUsesLevel6 = StringToInt(JXDelimArrayGetElement(array, 15));
	spellsReady.sSpellsLevel6 = JXDelimArrayGetElement(array, 16);
	// Spells ready level 7
	spellsReady.iNbUsesLevel7 = StringToInt(JXDelimArrayGetElement(array, 17));
	spellsReady.sSpellsLevel7 = JXDelimArrayGetElement(array, 18);
	// Spells ready level 8
	spellsReady.iNbUsesLevel8 = StringToInt(JXDelimArrayGetElement(array, 19));
	spellsReady.sSpellsLevel8 = JXDelimArrayGetElement(array, 20);
	// Spells ready level 9
	spellsReady.iNbUsesLevel9 = StringToInt(JXDelimArrayGetElement(array, 21));
	spellsReady.sSpellsLevel9 = JXDelimArrayGetElement(array, 22);
	// Spells ready level 10
	spellsReady.iNbUsesLevel10 = StringToInt(JXDelimArrayGetElement(array, 23));
	spellsReady.sSpellsLevel10 = JXDelimArrayGetElement(array, 24);

	return spellsReady;
}