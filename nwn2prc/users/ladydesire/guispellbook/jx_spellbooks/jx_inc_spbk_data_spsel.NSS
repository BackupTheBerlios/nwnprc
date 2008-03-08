//::///////////////////////////////////////////////
//:: JX Spellbook - Spells Selected Data include
//:: jx_inc_spbk_data_spsel
//:://////////////////////////////////////////////
//:://////////////////////////////////////////////
//:: Created By: jallaix
//:: Created On: Dec 9, 2007
//:://////////////////////////////////////////////
//
// This include file provides functions to manage the
// spell selection-related data.
//
// It provides the following functions :
//
// * Set/get the number of spells to select
// * Set/get the number of spells selected
// * Set/get the number of spells to swap
// * Set/get the number of spells swapped
// * Create a new empty set of spells selection
// * Convert a set of spells selected into a string
// * Convert a string into a set of spells selected
//
//:://////////////////////////////////////////////

#include "jx_inc_array_fixed"


















//**************************************//
//                                      //
//              Interface               //
//                                      //
//**************************************//


// Number of spells to select on level up
struct jx_nb_spells_select
{
	int iNbSpellsGlobal;
	int iNbSpellsLeftGlobal;
	int iNbSpellsLevel0;
	int iNbSpellsLeftLevel0;
	int iNbSpellsSwapLevel0;
	int iNbSpellsSwapLeftLevel0;
	int iNbSpellsLevel1;
	int iNbSpellsLeftLevel1;
	int iNbSpellsSwapLevel1;
	int iNbSpellsSwapLeftLevel1;
	int iNbSpellsLevel2;
	int iNbSpellsLeftLevel2;
	int iNbSpellsSwapLevel2;
	int iNbSpellsSwapLeftLevel2;
	int iNbSpellsLevel3;
	int iNbSpellsLeftLevel3;
	int iNbSpellsSwapLevel3;
	int iNbSpellsSwapLeftLevel3;
	int iNbSpellsLevel4;
	int iNbSpellsLeftLevel4;
	int iNbSpellsSwapLevel4;
	int iNbSpellsSwapLeftLevel4;
	int iNbSpellsLevel5;
	int iNbSpellsLeftLevel5;
	int iNbSpellsSwapLevel5;
	int iNbSpellsSwapLeftLevel5;
	int iNbSpellsLevel6;
	int iNbSpellsLeftLevel6;
	int iNbSpellsSwapLevel6;
	int iNbSpellsSwapLeftLevel6;
	int iNbSpellsLevel7;
	int iNbSpellsLeftLevel7;
	int iNbSpellsSwapLevel7;
	int iNbSpellsSwapLeftLevel7;
	int iNbSpellsLevel8;
	int iNbSpellsLeftLevel8;
	int iNbSpellsSwapLevel8;
	int iNbSpellsSwapLeftLevel8;
	int iNbSpellsLevel9;
	int iNbSpellsLeftLevel9;
	int iNbSpellsSwapLevel9;
	int iNbSpellsSwapLeftLevel9;
};


// Set the number of spells to select for the specified spell level
// - nbSpellsSelect List of number of spells to select
// - iSpellLevel Spell level concerned (-1 for a number of spells global to all spell levels)
// - iNbSpells Number of spells to select
// * Returns the updated list of number of spells to select
struct jx_nb_spells_select JXNbSpellsSelectSetNbSpells(struct jx_nb_spells_select nbSpellsSelect, int iSpellLevel, int iNbSpells);

// Set the number of spells selected for the specified spell level
// - nbSpellsSelect List of number of spells left selected
// - iSpellLevel Spell level concerned (-1 for a number of spells global to all spell levels)
// - iNbSpells Number of spells left selected
// * Returns the updated list of number of spells left selected
struct jx_nb_spells_select JXNbSpellsSelectSetNbSpellsSelected(struct jx_nb_spells_select nbSpellsSelect, int iSpellLevel, int iNbSpells);

// Set the number of spells to swap for the specified spell level
// - nbSpellsSelect List of number of spells to swap
// - iSpellLevel Spell level concerned
// - iNbSpells Number of spells to swap
// * Returns the updated list of number of spells to swap
struct jx_nb_spells_select JXNbSpellsSelectSetNbSpellsSwap(struct jx_nb_spells_select nbSpellsSelect, int iSpellLevel, int iNbSpells);

// Set the number of spells swapped for the specified spell level
// - nbSpellsSelect List of number of spells swapped
// - iSpellLevel Spell level concerned
// - iNbSpells Number of spells swapped
// * Returns the updated list of number of spells left swapped
struct jx_nb_spells_select JXNbSpellsSelectSetNbSpellsSwapped(struct jx_nb_spells_select nbSpellsSelect, int iSpellLevel, int iNbSpells);

// Get the number of spells to select for the specified spell level
// - nbSpellsSelect List of number of spells to select
// - iSpellLevel Spell level concerned (-1 for a number of spells global to all spell levels)
// * Returns the number of spells to select
int JXNbSpellsSelectGetNbSpells(struct jx_nb_spells_select nbSpellsSelect, int iSpellLevel);

// Get the number of spells selected for the specified spell level
// - nbSpellsSelect List of number of spells left selected
// - iSpellLevel Spell level concerned (-1 for a number of spells global to all spell levels)
// * Returns the number of spells selected
int JXNbSpellsSelectGetNbSpellsSelected(struct jx_nb_spells_select nbSpellsSelect, int iSpellLevel);

// Get the number of spells to swap for the specified spell level
// - nbSpellsSelect List of number of spells to swap
// - iSpellLevel Spell level concerned
// * Returns the number of spells to swap
int JXNbSpellsSelectGetNbSpellsSwap(struct jx_nb_spells_select nbSpellsSelect, int iSpellLevel);

// Get the number of spells swapped for the specified spell level
// - nbSpellsSelect List of number of spells swapped
// - iSpellLevel Spell level concerned
// * Returns the number of spells swapped
int JXNbSpellsSelectGetNbSpellsSwapped(struct jx_nb_spells_select nbSpellsSelect, int iSpellLevel);

// Create a new empty set of spells selection
// * Returns a new set of spells selection
struct jx_nb_spells_select JXNbSpellsSelectCreateStruct();

// Transform a list of spells to select into a string
// - nbSpellsSelect List of spells to select
// * Returns a list of spells to select in a string form
string JXNbSpellsSelectToString(struct jx_nb_spells_select nbSpellsSelect);

// Transform a list of spells to select into a structure
// - sNbSpellsSelect List of spells to select
// * Returns a list of spells to select in a structure form
struct jx_nb_spells_select JXStringToNbSpellsSelect(string sNbSpellsSelect);
















//**************************************//
//                                      //
//            Implementation            //
//                                      //
//**************************************//



// Set the number of spells to select for the specified spell level
// - nbSpellsSelect List of number of spells to select
// - iSpellLevel Spell level concerned (-1 for a number of spells global to all spell levels)
// - iNbSpells Number of spells to select
// * Returns the updated list of number of spells to select
struct jx_nb_spells_select JXNbSpellsSelectSetNbSpells(struct jx_nb_spells_select nbSpellsSelect, int iSpellLevel, int iNbSpells)
{
	switch (iSpellLevel)
	{
		case -1: nbSpellsSelect.iNbSpellsGlobal = iNbSpells; break;
		case 0: nbSpellsSelect.iNbSpellsLevel0 = iNbSpells; break;
		case 1: nbSpellsSelect.iNbSpellsLevel1 = iNbSpells; break;
		case 2: nbSpellsSelect.iNbSpellsLevel2 = iNbSpells; break;
		case 3: nbSpellsSelect.iNbSpellsLevel3 = iNbSpells; break;
		case 4: nbSpellsSelect.iNbSpellsLevel4 = iNbSpells; break;
		case 5: nbSpellsSelect.iNbSpellsLevel5 = iNbSpells; break;
		case 6: nbSpellsSelect.iNbSpellsLevel6 = iNbSpells; break;
		case 7: nbSpellsSelect.iNbSpellsLevel7 = iNbSpells; break;
		case 8: nbSpellsSelect.iNbSpellsLevel8 = iNbSpells; break;
		case 9: nbSpellsSelect.iNbSpellsLevel9 = iNbSpells; break;
	}

	return nbSpellsSelect;
}

// Set the number of spells selected for the specified spell level
// - nbSpellsSelect List of number of spells selected
// - iSpellLevel Spell level concerned (-1 for a number of spells global to all spell levels)
// - iNbSpells Number of spells selected
// * Returns the updated list of number of spells selected
struct jx_nb_spells_select JXNbSpellsSelectSetNbSpellsSelected(struct jx_nb_spells_select nbSpellsSelect, int iSpellLevel, int iNbSpells)
{
	switch (iSpellLevel)
	{
		case -1: nbSpellsSelect.iNbSpellsLeftGlobal = iNbSpells; break;
		case 0: nbSpellsSelect.iNbSpellsLeftLevel0 = iNbSpells; break;
		case 1: nbSpellsSelect.iNbSpellsLeftLevel1 = iNbSpells; break;
		case 2: nbSpellsSelect.iNbSpellsLeftLevel2 = iNbSpells; break;
		case 3: nbSpellsSelect.iNbSpellsLeftLevel3 = iNbSpells; break;
		case 4: nbSpellsSelect.iNbSpellsLeftLevel4 = iNbSpells; break;
		case 5: nbSpellsSelect.iNbSpellsLeftLevel5 = iNbSpells; break;
		case 6: nbSpellsSelect.iNbSpellsLeftLevel6 = iNbSpells; break;
		case 7: nbSpellsSelect.iNbSpellsLeftLevel7 = iNbSpells; break;
		case 8: nbSpellsSelect.iNbSpellsLeftLevel8 = iNbSpells; break;
		case 9: nbSpellsSelect.iNbSpellsLeftLevel9 = iNbSpells; break;
	}

	return nbSpellsSelect;
}

// Set the number of spells to swap for the specified spell level
// - nbSpellsSelect List of number of spells to swap
// - iSpellLevel Spell level concerned
// - iNbSpells Number of spells to swap
// * Returns the updated list of number of spells to swap
struct jx_nb_spells_select JXNbSpellsSelectSetNbSpellsSwap(struct jx_nb_spells_select nbSpellsSelect, int iSpellLevel, int iNbSpells)
{
	switch (iSpellLevel)
	{
		case 0: nbSpellsSelect.iNbSpellsSwapLevel0 = iNbSpells; break;
		case 1: nbSpellsSelect.iNbSpellsSwapLevel1 = iNbSpells; break;
		case 2: nbSpellsSelect.iNbSpellsSwapLevel2 = iNbSpells; break;
		case 3: nbSpellsSelect.iNbSpellsSwapLevel3 = iNbSpells; break;
		case 4: nbSpellsSelect.iNbSpellsSwapLevel4 = iNbSpells; break;
		case 5: nbSpellsSelect.iNbSpellsSwapLevel5 = iNbSpells; break;
		case 6: nbSpellsSelect.iNbSpellsSwapLevel6 = iNbSpells; break;
		case 7: nbSpellsSelect.iNbSpellsSwapLevel7 = iNbSpells; break;
		case 8: nbSpellsSelect.iNbSpellsSwapLevel8 = iNbSpells; break;
		case 9: nbSpellsSelect.iNbSpellsSwapLevel9 = iNbSpells; break;
	}

	return nbSpellsSelect;
}

// Set the number of spells swapped for the specified spell level
// - nbSpellsSelect List of number of spells swapped
// - iSpellLevel Spell level concerned
// - iNbSpells Number of spells left swapped
// * Returns the updated list of number of spells swapped
struct jx_nb_spells_select JXNbSpellsSelectSetNbSpellsSwapped(struct jx_nb_spells_select nbSpellsSelect, int iSpellLevel, int iNbSpells)
{
	switch (iSpellLevel)
	{
		case 0: nbSpellsSelect.iNbSpellsSwapLeftLevel0 = iNbSpells; break;
		case 1: nbSpellsSelect.iNbSpellsSwapLeftLevel1 = iNbSpells; break;
		case 2: nbSpellsSelect.iNbSpellsSwapLeftLevel2 = iNbSpells; break;
		case 3: nbSpellsSelect.iNbSpellsSwapLeftLevel3 = iNbSpells; break;
		case 4: nbSpellsSelect.iNbSpellsSwapLeftLevel4 = iNbSpells; break;
		case 5: nbSpellsSelect.iNbSpellsSwapLeftLevel5 = iNbSpells; break;
		case 6: nbSpellsSelect.iNbSpellsSwapLeftLevel6 = iNbSpells; break;
		case 7: nbSpellsSelect.iNbSpellsSwapLeftLevel7 = iNbSpells; break;
		case 8: nbSpellsSelect.iNbSpellsSwapLeftLevel8 = iNbSpells; break;
		case 9: nbSpellsSelect.iNbSpellsSwapLeftLevel9 = iNbSpells; break;
	}

	return nbSpellsSelect;
}

// Get the number of spells to select for the specified spell level
// - nbSpellsSelect List of number of spells to select
// - iSpellLevel Spell level concerned (-1 for a number of spells global to all spell levels)
// * Returns the number of spells to select
int JXNbSpellsSelectGetNbSpells(struct jx_nb_spells_select nbSpellsSelect, int iSpellLevel)
{
	switch (iSpellLevel)
	{
		case -1: return nbSpellsSelect.iNbSpellsGlobal;
		case 0: return nbSpellsSelect.iNbSpellsLevel0;
		case 1: return nbSpellsSelect.iNbSpellsLevel1;
		case 2: return nbSpellsSelect.iNbSpellsLevel2;
		case 3: return nbSpellsSelect.iNbSpellsLevel3;
		case 4: return nbSpellsSelect.iNbSpellsLevel4;
		case 5: return nbSpellsSelect.iNbSpellsLevel5;
		case 6: return nbSpellsSelect.iNbSpellsLevel6;
		case 7: return nbSpellsSelect.iNbSpellsLevel7;
		case 8: return nbSpellsSelect.iNbSpellsLevel8;
		case 9: return nbSpellsSelect.iNbSpellsLevel9;
	}

	return 0;
}

// Get the number of spells selected for the specified spell level
// - nbSpellsSelect List of number of spells selected
// - iSpellLevel Spell level concerned (-1 for a number of spells global to all spell levels)
// * Returns the number of spells selected
int JXNbSpellsSelectGetNbSpellsSelected(struct jx_nb_spells_select nbSpellsSelect, int iSpellLevel)
{
	switch (iSpellLevel)
	{
		case -1: return nbSpellsSelect.iNbSpellsLeftGlobal;
		case 0: return nbSpellsSelect.iNbSpellsLeftLevel0;
		case 1: return nbSpellsSelect.iNbSpellsLeftLevel1;
		case 2: return nbSpellsSelect.iNbSpellsLeftLevel2;
		case 3: return nbSpellsSelect.iNbSpellsLeftLevel3;
		case 4: return nbSpellsSelect.iNbSpellsLeftLevel4;
		case 5: return nbSpellsSelect.iNbSpellsLeftLevel5;
		case 6: return nbSpellsSelect.iNbSpellsLeftLevel6;
		case 7: return nbSpellsSelect.iNbSpellsLeftLevel7;
		case 8: return nbSpellsSelect.iNbSpellsLeftLevel8;
		case 9: return nbSpellsSelect.iNbSpellsLeftLevel9;
	}

	return 0;
}

// Get the number of spells to swap for the specified spell level
// - nbSpellsSelect List of number of spells to swap
// - iSpellLevel Spell level concerned
// * Returns the number of spells to swap
int JXNbSpellsSelectGetNbSpellsSwap(struct jx_nb_spells_select nbSpellsSelect, int iSpellLevel)
{
	switch (iSpellLevel)
	{
		case 0: return nbSpellsSelect.iNbSpellsSwapLevel0;
		case 1: return nbSpellsSelect.iNbSpellsSwapLevel1;
		case 2: return nbSpellsSelect.iNbSpellsSwapLevel2;
		case 3: return nbSpellsSelect.iNbSpellsSwapLevel3;
		case 4: return nbSpellsSelect.iNbSpellsSwapLevel4;
		case 5: return nbSpellsSelect.iNbSpellsSwapLevel5;
		case 6: return nbSpellsSelect.iNbSpellsSwapLevel6;
		case 7: return nbSpellsSelect.iNbSpellsSwapLevel7;
		case 8: return nbSpellsSelect.iNbSpellsSwapLevel8;
		case 9: return nbSpellsSelect.iNbSpellsSwapLevel9;
	}

	return 0;
}

// Get the number of spells swapped for the specified spell level
// - nbSpellsSelect List of number of spells swapped
// - iSpellLevel Spell level concerned
// * Returns the number of spells swapped
int JXNbSpellsSelectGetNbSpellsSwapped(struct jx_nb_spells_select nbSpellsSelect, int iSpellLevel)
{
	switch (iSpellLevel)
	{
		case 0: return nbSpellsSelect.iNbSpellsSwapLeftLevel0;
		case 1: return nbSpellsSelect.iNbSpellsSwapLeftLevel1;
		case 2: return nbSpellsSelect.iNbSpellsSwapLeftLevel2;
		case 3: return nbSpellsSelect.iNbSpellsSwapLeftLevel3;
		case 4: return nbSpellsSelect.iNbSpellsSwapLeftLevel4;
		case 5: return nbSpellsSelect.iNbSpellsSwapLeftLevel5;
		case 6: return nbSpellsSelect.iNbSpellsSwapLeftLevel6;
		case 7: return nbSpellsSelect.iNbSpellsSwapLeftLevel7;
		case 8: return nbSpellsSelect.iNbSpellsSwapLeftLevel8;
		case 9: return nbSpellsSelect.iNbSpellsSwapLeftLevel9;
	}

	return 0;
}

// Create a new empty set of spells selection
// * Returns a new set of spells selection
struct jx_nb_spells_select JXNbSpellsSelectCreateStruct()
{
	struct jx_nb_spells_select nbSpellsSelect;

	// Number of spells for global use
	nbSpellsSelect.iNbSpellsGlobal = -1;
	nbSpellsSelect.iNbSpellsLeftGlobal = -1;
	// Number of spells for level 0
	nbSpellsSelect.iNbSpellsLevel0 = -1;
	nbSpellsSelect.iNbSpellsLeftLevel0 = -1;
	nbSpellsSelect.iNbSpellsSwapLevel0 = -1;
	nbSpellsSelect.iNbSpellsSwapLeftLevel0 = -1;
	// Number of spells for level 1
	nbSpellsSelect.iNbSpellsLevel1 = -1;
	nbSpellsSelect.iNbSpellsLeftLevel1 = -1;
	nbSpellsSelect.iNbSpellsSwapLevel1 = -1;
	nbSpellsSelect.iNbSpellsSwapLeftLevel1 = -1;
	// Number of spells for level 2
	nbSpellsSelect.iNbSpellsLevel2 = -1;
	nbSpellsSelect.iNbSpellsLeftLevel2 = -1;
	nbSpellsSelect.iNbSpellsSwapLevel2 = -1;
	nbSpellsSelect.iNbSpellsSwapLeftLevel2 = -1;
	// Number of spells for level 3
	nbSpellsSelect.iNbSpellsLevel3 = -1;
	nbSpellsSelect.iNbSpellsLeftLevel3 = -1;
	nbSpellsSelect.iNbSpellsSwapLevel3 = -1;
	nbSpellsSelect.iNbSpellsSwapLeftLevel3 = -1;
	// Number of spells for level 4
	nbSpellsSelect.iNbSpellsLevel4 = -1;
	nbSpellsSelect.iNbSpellsLeftLevel4 = -1;
	nbSpellsSelect.iNbSpellsSwapLevel4 = -1;
	nbSpellsSelect.iNbSpellsSwapLeftLevel4 = -1;
	// Number of spells for level 5
	nbSpellsSelect.iNbSpellsLevel5 = -1;
	nbSpellsSelect.iNbSpellsLeftLevel5 = -1;
	nbSpellsSelect.iNbSpellsSwapLevel5 = -1;
	nbSpellsSelect.iNbSpellsSwapLeftLevel5 = -1;
	// Number of spells for level 6
	nbSpellsSelect.iNbSpellsLevel6 = -1;
	nbSpellsSelect.iNbSpellsLeftLevel6 = -1;
	nbSpellsSelect.iNbSpellsSwapLevel6 = -1;
	nbSpellsSelect.iNbSpellsSwapLeftLevel6 = -1;
	// Number of spells for level 7
	nbSpellsSelect.iNbSpellsLevel7 = -1;
	nbSpellsSelect.iNbSpellsLeftLevel7 = -1;
	nbSpellsSelect.iNbSpellsSwapLevel7 = -1;
	nbSpellsSelect.iNbSpellsSwapLeftLevel7 = -1;
	// Number of spells for level 8
	nbSpellsSelect.iNbSpellsLevel8 = -1;
	nbSpellsSelect.iNbSpellsLeftLevel8 = -1;
	nbSpellsSelect.iNbSpellsSwapLevel8 = -1;
	nbSpellsSelect.iNbSpellsSwapLeftLevel8 = -1;
	// Number of spells for level 9
	nbSpellsSelect.iNbSpellsLevel9 = -1;
	nbSpellsSelect.iNbSpellsLeftLevel9 = -1;
	nbSpellsSelect.iNbSpellsSwapLevel9 = -1;
	nbSpellsSelect.iNbSpellsSwapLeftLevel9 = -1;

	return nbSpellsSelect;
}

// Transform a list of spells to select into a string
// - nbSpellsSelect List of spells to select
// * Returns a list of spells to select in a string form
string JXNbSpellsSelectToString(struct jx_nb_spells_select nbSpellsSelect)
{
	struct jx_array_fixed array = JXFixedArrayCreate(2);
	// Number of spells for global use
	array = JXFixedArrayAddElement(array, IntToString(nbSpellsSelect.iNbSpellsGlobal));
	array = JXFixedArrayAddElement(array, IntToString(nbSpellsSelect.iNbSpellsLeftGlobal));
	// Number of spells for level 0
	array = JXFixedArrayAddElement(array, IntToString(nbSpellsSelect.iNbSpellsLevel0));
	array = JXFixedArrayAddElement(array, IntToString(nbSpellsSelect.iNbSpellsLeftLevel0));
	array = JXFixedArrayAddElement(array, IntToString(nbSpellsSelect.iNbSpellsSwapLevel0));
	array = JXFixedArrayAddElement(array, IntToString(nbSpellsSelect.iNbSpellsSwapLeftLevel0));
	// Number of spells for level 1
	array = JXFixedArrayAddElement(array, IntToString(nbSpellsSelect.iNbSpellsLevel1));
	array = JXFixedArrayAddElement(array, IntToString(nbSpellsSelect.iNbSpellsLeftLevel1));
	array = JXFixedArrayAddElement(array, IntToString(nbSpellsSelect.iNbSpellsSwapLevel1));
	array = JXFixedArrayAddElement(array, IntToString(nbSpellsSelect.iNbSpellsSwapLeftLevel1));
	// Number of spells for level 2
	array = JXFixedArrayAddElement(array, IntToString(nbSpellsSelect.iNbSpellsLevel2));
	array = JXFixedArrayAddElement(array, IntToString(nbSpellsSelect.iNbSpellsLeftLevel2));
	array = JXFixedArrayAddElement(array, IntToString(nbSpellsSelect.iNbSpellsSwapLevel2));
	array = JXFixedArrayAddElement(array, IntToString(nbSpellsSelect.iNbSpellsSwapLeftLevel2));
	// Number of spells for level 3
	array = JXFixedArrayAddElement(array, IntToString(nbSpellsSelect.iNbSpellsLevel3));
	array = JXFixedArrayAddElement(array, IntToString(nbSpellsSelect.iNbSpellsLeftLevel3));
	array = JXFixedArrayAddElement(array, IntToString(nbSpellsSelect.iNbSpellsSwapLevel3));
	array = JXFixedArrayAddElement(array, IntToString(nbSpellsSelect.iNbSpellsSwapLeftLevel3));
	// Number of spells for level 4
	array = JXFixedArrayAddElement(array, IntToString(nbSpellsSelect.iNbSpellsLevel4));
	array = JXFixedArrayAddElement(array, IntToString(nbSpellsSelect.iNbSpellsLeftLevel4));
	array = JXFixedArrayAddElement(array, IntToString(nbSpellsSelect.iNbSpellsSwapLevel4));
	array = JXFixedArrayAddElement(array, IntToString(nbSpellsSelect.iNbSpellsSwapLeftLevel4));
	// Number of spells for level 5
	array = JXFixedArrayAddElement(array, IntToString(nbSpellsSelect.iNbSpellsLevel5));
	array = JXFixedArrayAddElement(array, IntToString(nbSpellsSelect.iNbSpellsLeftLevel5));
	array = JXFixedArrayAddElement(array, IntToString(nbSpellsSelect.iNbSpellsSwapLevel5));
	array = JXFixedArrayAddElement(array, IntToString(nbSpellsSelect.iNbSpellsSwapLeftLevel5));
	// Number of spells for level 6
	array = JXFixedArrayAddElement(array, IntToString(nbSpellsSelect.iNbSpellsLevel6));
	array = JXFixedArrayAddElement(array, IntToString(nbSpellsSelect.iNbSpellsLeftLevel6));
	array = JXFixedArrayAddElement(array, IntToString(nbSpellsSelect.iNbSpellsSwapLevel6));
	array = JXFixedArrayAddElement(array, IntToString(nbSpellsSelect.iNbSpellsSwapLeftLevel6));
	// Number of spells for level 7
	array = JXFixedArrayAddElement(array, IntToString(nbSpellsSelect.iNbSpellsLevel7));
	array = JXFixedArrayAddElement(array, IntToString(nbSpellsSelect.iNbSpellsLeftLevel7));
	array = JXFixedArrayAddElement(array, IntToString(nbSpellsSelect.iNbSpellsSwapLevel7));
	array = JXFixedArrayAddElement(array, IntToString(nbSpellsSelect.iNbSpellsSwapLeftLevel7));
	// Number of spells for level 8
	array = JXFixedArrayAddElement(array, IntToString(nbSpellsSelect.iNbSpellsLevel8));
	array = JXFixedArrayAddElement(array, IntToString(nbSpellsSelect.iNbSpellsLeftLevel8));
	array = JXFixedArrayAddElement(array, IntToString(nbSpellsSelect.iNbSpellsSwapLevel8));
	array = JXFixedArrayAddElement(array, IntToString(nbSpellsSelect.iNbSpellsSwapLeftLevel8));
	// Number of spells for level 9
	array = JXFixedArrayAddElement(array, IntToString(nbSpellsSelect.iNbSpellsLevel9));
	array = JXFixedArrayAddElement(array, IntToString(nbSpellsSelect.iNbSpellsLeftLevel9));
	array = JXFixedArrayAddElement(array, IntToString(nbSpellsSelect.iNbSpellsSwapLevel9));
	array = JXFixedArrayAddElement(array, IntToString(nbSpellsSelect.iNbSpellsSwapLeftLevel9));

	return JXFixedArrayToString(array);
}

// Transform a list of spells to select into a structure
// - sNbSpellsSelect List of spells to select
// * Returns a list of spells to select in a structure form
struct jx_nb_spells_select JXStringToNbSpellsSelect(string sNbSpellsSelect)
{
	if (sNbSpellsSelect == "")
		return JXNbSpellsSelectCreateStruct();

	struct jx_array_fixed array = JXFixedArrayToStruct(sNbSpellsSelect);

	struct jx_nb_spells_select nbSpellsSelect;
	// Number of spells for global use
	nbSpellsSelect.iNbSpellsGlobal = StringToInt(JXFixedArrayGetElement(array, 1));
	nbSpellsSelect.iNbSpellsLeftGlobal = StringToInt(JXFixedArrayGetElement(array, 2));
	// Number of spells for level 0
	nbSpellsSelect.iNbSpellsLevel0 = StringToInt(JXFixedArrayGetElement(array, 3));
	nbSpellsSelect.iNbSpellsLeftLevel0 = StringToInt(JXFixedArrayGetElement(array, 4));
	nbSpellsSelect.iNbSpellsSwapLevel0 = StringToInt(JXFixedArrayGetElement(array, 5));
	nbSpellsSelect.iNbSpellsSwapLeftLevel0 = StringToInt(JXFixedArrayGetElement(array, 6));
	// Number of spells for level 1
	nbSpellsSelect.iNbSpellsLevel1 = StringToInt(JXFixedArrayGetElement(array, 7));
	nbSpellsSelect.iNbSpellsLeftLevel1 = StringToInt(JXFixedArrayGetElement(array, 8));
	nbSpellsSelect.iNbSpellsSwapLevel1 = StringToInt(JXFixedArrayGetElement(array, 9));
	nbSpellsSelect.iNbSpellsSwapLeftLevel1 = StringToInt(JXFixedArrayGetElement(array, 10));
	// Number of spells for level 2
	nbSpellsSelect.iNbSpellsLevel2 = StringToInt(JXFixedArrayGetElement(array, 11));
	nbSpellsSelect.iNbSpellsLeftLevel2 = StringToInt(JXFixedArrayGetElement(array, 12));
	nbSpellsSelect.iNbSpellsSwapLevel2 = StringToInt(JXFixedArrayGetElement(array, 13));
	nbSpellsSelect.iNbSpellsSwapLeftLevel2 = StringToInt(JXFixedArrayGetElement(array, 14));
	// Number of spells for level 3
	nbSpellsSelect.iNbSpellsLevel3 = StringToInt(JXFixedArrayGetElement(array, 15));
	nbSpellsSelect.iNbSpellsLeftLevel3 = StringToInt(JXFixedArrayGetElement(array, 16));
	nbSpellsSelect.iNbSpellsSwapLevel3 = StringToInt(JXFixedArrayGetElement(array, 17));
	nbSpellsSelect.iNbSpellsSwapLeftLevel3 = StringToInt(JXFixedArrayGetElement(array, 18));
	// Number of spells for level 4
	nbSpellsSelect.iNbSpellsLevel4 = StringToInt(JXFixedArrayGetElement(array, 19));
	nbSpellsSelect.iNbSpellsLeftLevel4 = StringToInt(JXFixedArrayGetElement(array, 20));
	nbSpellsSelect.iNbSpellsSwapLevel4 = StringToInt(JXFixedArrayGetElement(array, 21));
	nbSpellsSelect.iNbSpellsSwapLeftLevel4 = StringToInt(JXFixedArrayGetElement(array, 22));
	// Number of spells for level 5
	nbSpellsSelect.iNbSpellsLevel5 = StringToInt(JXFixedArrayGetElement(array, 23));
	nbSpellsSelect.iNbSpellsLeftLevel5 = StringToInt(JXFixedArrayGetElement(array, 24));
	nbSpellsSelect.iNbSpellsSwapLevel5 = StringToInt(JXFixedArrayGetElement(array, 25));
	nbSpellsSelect.iNbSpellsSwapLeftLevel5 = StringToInt(JXFixedArrayGetElement(array, 26));
	// Number of spells for level 6
	nbSpellsSelect.iNbSpellsLevel6 = StringToInt(JXFixedArrayGetElement(array, 27));
	nbSpellsSelect.iNbSpellsLeftLevel6 = StringToInt(JXFixedArrayGetElement(array, 28));
	nbSpellsSelect.iNbSpellsSwapLevel6 = StringToInt(JXFixedArrayGetElement(array, 29));
	nbSpellsSelect.iNbSpellsSwapLeftLevel6 = StringToInt(JXFixedArrayGetElement(array, 30));
	// Number of spells for level 7
	nbSpellsSelect.iNbSpellsLevel7 = StringToInt(JXFixedArrayGetElement(array, 31));
	nbSpellsSelect.iNbSpellsLeftLevel7 = StringToInt(JXFixedArrayGetElement(array, 32));
	nbSpellsSelect.iNbSpellsSwapLevel7 = StringToInt(JXFixedArrayGetElement(array, 33));
	nbSpellsSelect.iNbSpellsSwapLeftLevel7 = StringToInt(JXFixedArrayGetElement(array, 34));
	// Number of spells for level 8
	nbSpellsSelect.iNbSpellsLevel8 = StringToInt(JXFixedArrayGetElement(array, 35));
	nbSpellsSelect.iNbSpellsLeftLevel8 = StringToInt(JXFixedArrayGetElement(array, 36));
	nbSpellsSelect.iNbSpellsSwapLevel8 = StringToInt(JXFixedArrayGetElement(array, 37));
	nbSpellsSelect.iNbSpellsSwapLeftLevel8 = StringToInt(JXFixedArrayGetElement(array, 38));
	// Number of spells for level 9
	nbSpellsSelect.iNbSpellsLevel9 = StringToInt(JXFixedArrayGetElement(array, 39));
	nbSpellsSelect.iNbSpellsLeftLevel9 = StringToInt(JXFixedArrayGetElement(array, 40));
	nbSpellsSelect.iNbSpellsSwapLevel9 = StringToInt(JXFixedArrayGetElement(array, 41));
	nbSpellsSelect.iNbSpellsSwapLeftLevel9 = StringToInt(JXFixedArrayGetElement(array, 42));

	return nbSpellsSelect;
}