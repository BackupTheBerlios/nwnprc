//::///////////////////////////////////////////////
//:: JX Spellbook - Spell per Day Data include
//:: jx_inc_spbk_data_spday
//:://////////////////////////////////////////////
//:://////////////////////////////////////////////
//:: Created By: jallaix
//:: Created On: Dec 9, 2007
//:://////////////////////////////////////////////
//
// This include file provides functions to manage
// spells/day-related data.
//
// It provides the following functions :
//
// * Get the number of spells/day available for a spell level
// * Get the number of domain spells/day available for a spell level
// * Set the number of spells/day available for a spell level
// * Set the number of domain spells/day available for a spell level
// * Add a set of spells/day to another set of spells/day
// * Create a new empty set of spells/day
// * Convert a set of spells/day into a string
// * Convert a string into a set of spells/day
//
//:://////////////////////////////////////////////

#include "jx_inc_array_delim"


















//**************************************//
//                                      //
//              Interface               //
//                                      //
//**************************************//


// Structure that represents a list of number of spells per day
struct jx_spells_per_day
{
	int iSpellsPerDayLevel0;		// Number of spells of level 0
	int iSpellsDomainPerDayLevel0;	// Number of domain spells of level 0
	int iSpellsPerDayLevel1;		// Number of spells of level 1
	int iSpellsDomainPerDayLevel1;	// Number of domain spells of level 1
	int iSpellsPerDayLevel2;		// Number of spells of level 2
	int iSpellsDomainPerDayLevel2;	// Number of domain spells of level 2
	int iSpellsPerDayLevel3;		// Number of spells of level 3
	int iSpellsDomainPerDayLevel3;	// Number of domain spells of level 3
	int iSpellsPerDayLevel4;		// Number of spells of level 4
	int iSpellsDomainPerDayLevel4;	// Number of domain spells of level 4
	int iSpellsPerDayLevel5;		// Number of spells of level 5
	int iSpellsDomainPerDayLevel5;	// Number of domain spells of level 5
	int iSpellsPerDayLevel6;		// Number of spells of level 6
	int iSpellsDomainPerDayLevel6;	// Number of domain spells of level 6
	int iSpellsPerDayLevel7;		// Number of spells of level 7
	int iSpellsDomainPerDayLevel7;	// Number of domain spells of level 7
	int iSpellsPerDayLevel8;		// Number of spells of level 8
	int iSpellsDomainPerDayLevel8;	// Number of domain spells of level 8
	int iSpellsPerDayLevel9;		// Number of spells of level 9
	int iSpellsDomainPerDayLevel9;	// Number of domain spells of level 9
	int iSpellsPerDayLevel10;		// Number of epic spells
	int iMaxSpellLevel;				// Maximum spell level 
};



// Get the number of spells per day for a spell level
// - spellsPerDay List of number of spells per day
// - iSpellLevel Spell level from which to get the number of spells per day
// * Returns the number of spells per day for the spell level (-1 none, -2 infinite)
int JXSpellsDayGetNbSpells(struct jx_spells_per_day spellsPerDay, int iSpellLevel);

// Get the number of domain spells per day for a spell level
// - spellsPerDay List of number of spells per day
// - iSpellLevel Spell level from which to get the number of spells per day
// * Returns the number of domain spells per day for the spell level (-1 none, -2 infinite)
int JXSpellsDayGetNbSpellsDomain(struct jx_spells_per_day spellsPerDay, int iSpellLevel);

// Set the number of spells per day for a spell level
// - spellsPerDay List of number of spells per day
// - iSpellLevel Spell level from which to get the number of spells per day
// - iNbSpells Number of spells per day to set for the spell level (-1 none, -2 infinite)
// * Returns the updated list of number of spells per day
struct jx_spells_per_day JXSpellsDaySetNbSpells(struct jx_spells_per_day spellsPerDay, int iSpellLevel, int iNbSpells);

// Set the number of domain spells per day for a spell level
// - spellsPerDay List of number of spells per day
// - iSpellLevel Spell level from which to get the number of spells per day
// - iNbSpells Number of domain spells per day to set for the spell level (-1 none, -2 infinite)
// * Returns the updated list of number of domain spells per day
struct jx_spells_per_day JXSpellsDaySetNbSpellsDomain(struct jx_spells_per_day spellsPerDay, int iSpellLevel, int iNbSpells);

// Add two lists of spells per day
// - spellsPerDay1 First list of spells per day
// - spellsPerDay2 Second list of spells per day
// * Returns the resulting list of spells per day
struct jx_spells_per_day JXSpellsDayAddSpellsDay(struct jx_spells_per_day spellsPerDay1, struct jx_spells_per_day spellsPerDay2);

// Create a new empty set of spells/day
// * Returns a new set of spells/day
struct jx_spells_per_day JXSpellsDayCreateStruct();

// Transform a number of spells per day list into a string
// - spellsPerDay List of number of spells per day
// * Returns a number of spells per day in a string form
string JXSpellsDayToString(struct jx_spells_per_day  spellsPerDay);

// Transform a number of spells par day list into a structure
// - sSpellsPerDay List of number of spells per day
// * Returns a number of spells per day in a structure form
struct jx_spells_per_day JXStringToSpellsDay(string sSpellsPerDay);

















//**************************************//
//                                      //
//            Implementation            //
//                                      //
//**************************************//



// Get the number of spells per day for a spell level
// - spellsPerDay List of number of spells per day
// - iSpellLevel Spell level from which to get the number of spells per day
// * Returns the number of spells per day for the spell level (-1 none, -2 infinite)
int JXSpellsDayGetNbSpells(struct jx_spells_per_day spellsPerDay, int iSpellLevel)
{
	if (iSpellLevel > spellsPerDay.iMaxSpellLevel)
		return -1;
	if (iSpellLevel > 10)
		return -1;
	if (iSpellLevel < 0)
		return -1;

	switch (iSpellLevel)
	{
		case 0: return spellsPerDay.iSpellsPerDayLevel0;
		case 1: return spellsPerDay.iSpellsPerDayLevel1;
		case 2: return spellsPerDay.iSpellsPerDayLevel2;
		case 3: return spellsPerDay.iSpellsPerDayLevel3;
		case 4: return spellsPerDay.iSpellsPerDayLevel4;
		case 5: return spellsPerDay.iSpellsPerDayLevel5;
		case 6: return spellsPerDay.iSpellsPerDayLevel6;
		case 7: return spellsPerDay.iSpellsPerDayLevel7;
		case 8: return spellsPerDay.iSpellsPerDayLevel8;
		case 9: return spellsPerDay.iSpellsPerDayLevel9;
		case 10: return spellsPerDay.iSpellsPerDayLevel10;
	}

	return -1;
}

// Get the number of domain spells per day for a spell level
// - spellsPerDay List of number of spells per day
// - iSpellLevel Spell level from which to get the number of spells per day
// * Returns the number of domain spells per day for the spell level (-1 none, -2 infinite)
int JXSpellsDayGetNbSpellsDomain(struct jx_spells_per_day spellsPerDay, int iSpellLevel)
{
	if (iSpellLevel > spellsPerDay.iMaxSpellLevel)
		return -1;
	if (iSpellLevel > 9)
		return -1;
	if (iSpellLevel < 0)
		return -1;

	switch (iSpellLevel)
	{
		case 0: return spellsPerDay.iSpellsDomainPerDayLevel0;
		case 1: return spellsPerDay.iSpellsDomainPerDayLevel1;
		case 2: return spellsPerDay.iSpellsDomainPerDayLevel2;
		case 3: return spellsPerDay.iSpellsDomainPerDayLevel3;
		case 4: return spellsPerDay.iSpellsDomainPerDayLevel4;
		case 5: return spellsPerDay.iSpellsDomainPerDayLevel5;
		case 6: return spellsPerDay.iSpellsDomainPerDayLevel6;
		case 7: return spellsPerDay.iSpellsDomainPerDayLevel7;
		case 8: return spellsPerDay.iSpellsDomainPerDayLevel8;
		case 9: return spellsPerDay.iSpellsDomainPerDayLevel9;
	}

	return -1;
}

// Set the number of spells per day for a spell level
// - spellsPerDay List of number of spells per day
// - iSpellLevel Spell level from which to get the number of spells per day
// - iNbSpells Number of spells per day to set for the spell level (-1 none, -2 infinite)
// * Returns the updated list of number of spells per day
struct jx_spells_per_day JXSpellsDaySetNbSpells(struct jx_spells_per_day spellsPerDay, int iSpellLevel, int iNbSpells)
{
	struct jx_spells_per_day spellsInvalid;
	if (iSpellLevel > 10)
		return spellsInvalid;
	if (iSpellLevel < 0)
		return spellsInvalid;

	if (spellsPerDay.iMaxSpellLevel < iSpellLevel)
		spellsPerDay.iMaxSpellLevel = iSpellLevel;

	switch (iSpellLevel)
	{
		case 0: spellsPerDay.iSpellsPerDayLevel0 = iNbSpells; break;
		case 1: spellsPerDay.iSpellsPerDayLevel1 = iNbSpells; break;
		case 2: spellsPerDay.iSpellsPerDayLevel2 = iNbSpells; break;
		case 3: spellsPerDay.iSpellsPerDayLevel3 = iNbSpells; break;
		case 4: spellsPerDay.iSpellsPerDayLevel4 = iNbSpells; break;
		case 5: spellsPerDay.iSpellsPerDayLevel5 = iNbSpells; break;
		case 6: spellsPerDay.iSpellsPerDayLevel6 = iNbSpells; break;
		case 7: spellsPerDay.iSpellsPerDayLevel7 = iNbSpells; break;
		case 8: spellsPerDay.iSpellsPerDayLevel8 = iNbSpells; break;
		case 9: spellsPerDay.iSpellsPerDayLevel9 = iNbSpells; break;
		case 10: spellsPerDay.iSpellsPerDayLevel10 = iNbSpells; break;
	}

	return spellsPerDay;
}

// Set the number of domain spells per day for a spell level
// - spellsPerDay List of number of spells per day
// - iSpellLevel Spell level from which to get the number of spells per day
// - iNbSpells Number of domain spells per day to set for the spell level (-1 none, -2 infinite)
// * Returns the updated list of number of domain spells per day
struct jx_spells_per_day JXSpellsDaySetNbSpellsDomain(struct jx_spells_per_day spellsPerDay, int iSpellLevel, int iNbSpells)
{
	struct jx_spells_per_day spellsInvalid;
	if (iSpellLevel > 9)
		return spellsInvalid;
	if (iSpellLevel < 0)
		return spellsInvalid;

	if (spellsPerDay.iMaxSpellLevel < iSpellLevel)
		spellsPerDay.iMaxSpellLevel = iSpellLevel;

	switch (iSpellLevel)
	{
		case 0: spellsPerDay.iSpellsDomainPerDayLevel0 = iNbSpells; break;
		case 1: spellsPerDay.iSpellsDomainPerDayLevel1 = iNbSpells; break;
		case 2: spellsPerDay.iSpellsDomainPerDayLevel2 = iNbSpells; break;
		case 3: spellsPerDay.iSpellsDomainPerDayLevel3 = iNbSpells; break;
		case 4: spellsPerDay.iSpellsDomainPerDayLevel4 = iNbSpells; break;
		case 5: spellsPerDay.iSpellsDomainPerDayLevel5 = iNbSpells; break;
		case 6: spellsPerDay.iSpellsDomainPerDayLevel6 = iNbSpells; break;
		case 7: spellsPerDay.iSpellsDomainPerDayLevel7 = iNbSpells; break;
		case 8: spellsPerDay.iSpellsDomainPerDayLevel8 = iNbSpells; break;
		case 9: spellsPerDay.iSpellsDomainPerDayLevel9 = iNbSpells; break;
	}

	return spellsPerDay;
}

// Add two lists of spells per day
// - spellsDay1 First list of spells per day
// - spellsDay2 Second list of spells per day
// * Returns the resulting list of spells per day
struct jx_spells_per_day JXSpellsDayAddSpellsDay(struct jx_spells_per_day spellsDay1, struct jx_spells_per_day spellsDay2)
{
	struct jx_spells_per_day spellsDays;

	int iLoopLevel;
	for (iLoopLevel = 0; iLoopLevel <= 9; iLoopLevel++)
	{
		int iNbSpells1;
		int iNbSpellsDomain1;
		int iNbSpells2;
		int iNbSpellsDomain2;
		switch (iLoopLevel)
		{
			case 0:
				iNbSpells1 = spellsDay1.iSpellsPerDayLevel0;
				iNbSpellsDomain1 = spellsDay1.iSpellsDomainPerDayLevel0;
				iNbSpells2 = spellsDay2.iSpellsPerDayLevel0;
				iNbSpellsDomain2 = spellsDay2.iSpellsDomainPerDayLevel0;
				if ((iNbSpells1 != -1) && (iNbSpells2 != -1))
					iNbSpells1 += iNbSpells2;
				if ((iNbSpellsDomain1 != -1) && (iNbSpellsDomain2 != -1))
					iNbSpellsDomain1 += iNbSpellsDomain2;
				spellsDays.iSpellsPerDayLevel0 = iNbSpells1;
				spellsDays.iSpellsDomainPerDayLevel0 = iNbSpellsDomain1;
				break;
			case 1:
				iNbSpells1 = spellsDay1.iSpellsPerDayLevel1;
				iNbSpellsDomain1 = spellsDay1.iSpellsDomainPerDayLevel1;
				iNbSpells2 = spellsDay2.iSpellsPerDayLevel1;
				iNbSpellsDomain2 = spellsDay2.iSpellsDomainPerDayLevel1;
				if ((iNbSpells1 != -1) && (iNbSpells2 != -1))
					iNbSpells1 += iNbSpells2;
				if ((iNbSpellsDomain1 != -1) && (iNbSpellsDomain2 != -1))
					iNbSpellsDomain1 += iNbSpellsDomain2;
				spellsDays.iSpellsPerDayLevel1 = iNbSpells1;
				spellsDays.iSpellsDomainPerDayLevel1 = iNbSpellsDomain1;
				break;
			case 2:
				iNbSpells1 = spellsDay1.iSpellsPerDayLevel2;
				iNbSpellsDomain1 = spellsDay1.iSpellsDomainPerDayLevel2;
				iNbSpells2 = spellsDay2.iSpellsPerDayLevel2;
				iNbSpellsDomain2 = spellsDay2.iSpellsDomainPerDayLevel2;
				if ((iNbSpells1 != -1) && (iNbSpells2 != -1))
					iNbSpells1 += iNbSpells2;
				if ((iNbSpellsDomain1 != -1) && (iNbSpellsDomain2 != -1))
					iNbSpellsDomain1 += iNbSpellsDomain2;
				spellsDays.iSpellsPerDayLevel2 = iNbSpells1;
				spellsDays.iSpellsDomainPerDayLevel2 = iNbSpellsDomain1;
				break;
			case 3:
				iNbSpells1 = spellsDay1.iSpellsPerDayLevel3;
				iNbSpellsDomain1 = spellsDay1.iSpellsDomainPerDayLevel3;
				iNbSpells2 = spellsDay2.iSpellsPerDayLevel3;
				iNbSpellsDomain2 = spellsDay2.iSpellsDomainPerDayLevel3;
				if ((iNbSpells1 != -1) && (iNbSpells2 != -1))
					iNbSpells1 += iNbSpells2;
				if ((iNbSpellsDomain1 != -1) && (iNbSpellsDomain2 != -1))
					iNbSpellsDomain1 += iNbSpellsDomain2;
				spellsDays.iSpellsPerDayLevel3 = iNbSpells1;
				spellsDays.iSpellsDomainPerDayLevel3 = iNbSpellsDomain1;
				break;
			case 4:
				iNbSpells1 = spellsDay1.iSpellsPerDayLevel4;
				iNbSpellsDomain1 = spellsDay1.iSpellsDomainPerDayLevel4;
				iNbSpells2 = spellsDay2.iSpellsPerDayLevel4;
				iNbSpellsDomain2 = spellsDay2.iSpellsDomainPerDayLevel4;
				if ((iNbSpells1 != -1) && (iNbSpells2 != -1))
					iNbSpells1 += iNbSpells2;
				if ((iNbSpellsDomain1 != -1) && (iNbSpellsDomain2 != -1))
					iNbSpellsDomain1 += iNbSpellsDomain2;
				spellsDays.iSpellsPerDayLevel4 = iNbSpells1;
				spellsDays.iSpellsDomainPerDayLevel4 = iNbSpellsDomain1;
				break;
			case 5:
				iNbSpells1 = spellsDay1.iSpellsPerDayLevel5;
				iNbSpellsDomain1 = spellsDay1.iSpellsDomainPerDayLevel5;
				iNbSpells2 = spellsDay2.iSpellsPerDayLevel5;
				iNbSpellsDomain2 = spellsDay2.iSpellsDomainPerDayLevel5;
				if ((iNbSpells1 != -1) && (iNbSpells2 != -1))
					iNbSpells1 += iNbSpells2;
				if ((iNbSpellsDomain1 != -1) && (iNbSpellsDomain2 != -1))
					iNbSpellsDomain1 += iNbSpellsDomain2;
				spellsDays.iSpellsPerDayLevel5 = iNbSpells1;
				spellsDays.iSpellsDomainPerDayLevel5 = iNbSpellsDomain1;
				break;
			case 6:
				iNbSpells1 = spellsDay1.iSpellsPerDayLevel6;
				iNbSpellsDomain1 = spellsDay1.iSpellsDomainPerDayLevel6;
				iNbSpells2 = spellsDay2.iSpellsPerDayLevel6;
				iNbSpellsDomain2 = spellsDay2.iSpellsDomainPerDayLevel6;
				if ((iNbSpells1 != -1) && (iNbSpells2 != -1))
					iNbSpells1 += iNbSpells2;
				if ((iNbSpellsDomain1 != -1) && (iNbSpellsDomain2 != -1))
					iNbSpellsDomain1 += iNbSpellsDomain2;
				spellsDays.iSpellsPerDayLevel6 = iNbSpells1;
				spellsDays.iSpellsDomainPerDayLevel6 = iNbSpellsDomain1;
				break;
			case 7:
				iNbSpells1 = spellsDay1.iSpellsPerDayLevel7;
				iNbSpellsDomain1 = spellsDay1.iSpellsDomainPerDayLevel7;
				iNbSpells2 = spellsDay2.iSpellsPerDayLevel7;
				iNbSpellsDomain2 = spellsDay2.iSpellsDomainPerDayLevel7;
				if ((iNbSpells1 != -1) && (iNbSpells2 != -1))
					iNbSpells1 += iNbSpells2;
				if ((iNbSpellsDomain1 != -1) && (iNbSpellsDomain2 != -1))
					iNbSpellsDomain1 += iNbSpellsDomain2;
				spellsDays.iSpellsPerDayLevel7 = iNbSpells1;
				spellsDays.iSpellsDomainPerDayLevel7 = iNbSpellsDomain1;
				break;
			case 8:
				iNbSpells1 = spellsDay1.iSpellsPerDayLevel8;
				iNbSpellsDomain1 = spellsDay1.iSpellsDomainPerDayLevel8;
				iNbSpells2 = spellsDay2.iSpellsPerDayLevel8;
				iNbSpellsDomain2 = spellsDay2.iSpellsDomainPerDayLevel8;
				if ((iNbSpells1 != -1) && (iNbSpells2 != -1))
					iNbSpells1 += iNbSpells2;
				if ((iNbSpellsDomain1 != -1) && (iNbSpellsDomain2 != -1))
					iNbSpellsDomain1 += iNbSpellsDomain2;
				spellsDays.iSpellsPerDayLevel8 = iNbSpells1;
				spellsDays.iSpellsDomainPerDayLevel8 = iNbSpellsDomain1;
				break;
			case 9:
				iNbSpells1 = spellsDay1.iSpellsPerDayLevel9;
				iNbSpellsDomain1 = spellsDay1.iSpellsDomainPerDayLevel9;
				iNbSpells2 = spellsDay2.iSpellsPerDayLevel9;
				iNbSpellsDomain2 = spellsDay2.iSpellsDomainPerDayLevel9;
				if ((iNbSpells1 != -1) && (iNbSpells2 != -1))
					iNbSpells1 += iNbSpells2;
				if ((iNbSpellsDomain1 != -1) && (iNbSpellsDomain2 != -1))
					iNbSpellsDomain1 += iNbSpellsDomain2;
				spellsDays.iSpellsPerDayLevel9 = iNbSpells1;
				spellsDays.iSpellsDomainPerDayLevel9 = iNbSpellsDomain1;
				break;
		}
	}

	// The maximum spell level is the maximum spell level of the first spell list
	spellsDays.iMaxSpellLevel = spellsDay1.iMaxSpellLevel;

	return spellsDays;
}

// Create a new empty set of spells/day
// * Returns a new set of spells/day
struct jx_spells_per_day JXSpellsDayCreateStruct()
{
	struct jx_spells_per_day spellsPerDay;

	// Maximum spell level
	spellsPerDay.iMaxSpellLevel = -1;
	// Spells/day level 0
	spellsPerDay.iSpellsPerDayLevel0 = -1;
	spellsPerDay.iSpellsDomainPerDayLevel0 = -1;
	// Spells/day level 1
	spellsPerDay.iSpellsPerDayLevel0 = -1;
	spellsPerDay.iSpellsDomainPerDayLevel0 = -1;
	// Spells/day level 2
	spellsPerDay.iSpellsPerDayLevel0 = -1;
	spellsPerDay.iSpellsDomainPerDayLevel0 = -1;
	// Spells/day level 3
	spellsPerDay.iSpellsPerDayLevel0 = -1;
	spellsPerDay.iSpellsDomainPerDayLevel0 = -1;
	// Spells/day level 4
	spellsPerDay.iSpellsPerDayLevel0 = -1;
	spellsPerDay.iSpellsDomainPerDayLevel0 = -1;
	// Spells/day level 5
	spellsPerDay.iSpellsPerDayLevel0 = -1;
	spellsPerDay.iSpellsDomainPerDayLevel0 = -1;
	// Spells/day level 6
	spellsPerDay.iSpellsPerDayLevel0 = -1;
	spellsPerDay.iSpellsDomainPerDayLevel0 = -1;
	// Spells/day level 7
	spellsPerDay.iSpellsPerDayLevel0 = -1;
	spellsPerDay.iSpellsDomainPerDayLevel0 = -1;
	// Spells/day level 8
	spellsPerDay.iSpellsPerDayLevel0 = -1;
	spellsPerDay.iSpellsDomainPerDayLevel0 = -1;
	// Spells/day level 9
	spellsPerDay.iSpellsPerDayLevel0 = -1;
	spellsPerDay.iSpellsDomainPerDayLevel0 = -1;
	// Spells/day level 10
	spellsPerDay.iSpellsPerDayLevel0 = -1;

	return spellsPerDay;
}

// Transform a number of spells per day list into a string
// - spellsPerDay List of number of spells per day
// * Returns a number of spells per day in a string form
string JXSpellsDayToString(struct jx_spells_per_day spellsPerDay)
{
	struct jx_array_delim array = JXDelimArrayCreate(";");
	// Maximum spell level
	array = JXDelimArrayAddElement(array, IntToString(spellsPerDay.iMaxSpellLevel));
	// Spells/day level 0
	array = JXDelimArrayAddElement(array, IntToString(spellsPerDay.iSpellsPerDayLevel0));
	array = JXDelimArrayAddElement(array, IntToString(spellsPerDay.iSpellsDomainPerDayLevel0));
	// Spells/day level 1
	array = JXDelimArrayAddElement(array, IntToString(spellsPerDay.iSpellsPerDayLevel1));
	array = JXDelimArrayAddElement(array, IntToString(spellsPerDay.iSpellsDomainPerDayLevel1));
	// Spells/day level 2
	array = JXDelimArrayAddElement(array, IntToString(spellsPerDay.iSpellsPerDayLevel2));
	array = JXDelimArrayAddElement(array, IntToString(spellsPerDay.iSpellsDomainPerDayLevel2));
	// Spells/day level 3
	array = JXDelimArrayAddElement(array, IntToString(spellsPerDay.iSpellsPerDayLevel3));
	array = JXDelimArrayAddElement(array, IntToString(spellsPerDay.iSpellsDomainPerDayLevel3));
	// Spells/day level 4
	array = JXDelimArrayAddElement(array, IntToString(spellsPerDay.iSpellsPerDayLevel4));
	array = JXDelimArrayAddElement(array, IntToString(spellsPerDay.iSpellsDomainPerDayLevel4));
	// Spells/day level 5
	array = JXDelimArrayAddElement(array, IntToString(spellsPerDay.iSpellsPerDayLevel5));
	array = JXDelimArrayAddElement(array, IntToString(spellsPerDay.iSpellsDomainPerDayLevel5));
	// Spells/day level 6
	array = JXDelimArrayAddElement(array, IntToString(spellsPerDay.iSpellsPerDayLevel6));
	array = JXDelimArrayAddElement(array, IntToString(spellsPerDay.iSpellsDomainPerDayLevel6));
	// Spells/day level 7
	array = JXDelimArrayAddElement(array, IntToString(spellsPerDay.iSpellsPerDayLevel7));
	array = JXDelimArrayAddElement(array, IntToString(spellsPerDay.iSpellsDomainPerDayLevel7));
	// Spells/day level 8
	array = JXDelimArrayAddElement(array, IntToString(spellsPerDay.iSpellsPerDayLevel8));
	array = JXDelimArrayAddElement(array, IntToString(spellsPerDay.iSpellsDomainPerDayLevel8));
	// Spells/day level 9
	array = JXDelimArrayAddElement(array, IntToString(spellsPerDay.iSpellsPerDayLevel9));
	array = JXDelimArrayAddElement(array, IntToString(spellsPerDay.iSpellsDomainPerDayLevel9));
	// Spells/day level 10
	array = JXDelimArrayAddElement(array, IntToString(spellsPerDay.iSpellsPerDayLevel10));

	return JXDelimArrayToString(array);
}

// Transform a number of spells par day list into a structure
// - sSpellsPerDay List of number of spells per day
// * Returns a number of spells per day in a structure form
struct jx_spells_per_day JXStringToSpellsDay(string sSpellsPerDay)
{
	// Create a new set of spells/day if the string is empty
	if (sSpellsPerDay == "")
		return JXSpellsDayCreateStruct();

	struct jx_array_delim array = JXDelimArrayToStruct(sSpellsPerDay);

	struct jx_spells_per_day spellsPerDay;
	// Maximum spell level
	spellsPerDay.iMaxSpellLevel = StringToInt(JXDelimArrayGetElement(array, 1));
	// Spells/day level 0
	spellsPerDay.iSpellsPerDayLevel0 = StringToInt(JXDelimArrayGetElement(array, 2));
	spellsPerDay.iSpellsDomainPerDayLevel0 = StringToInt(JXDelimArrayGetElement(array, 3));
	// Spells/day level 1
	spellsPerDay.iSpellsPerDayLevel0 = StringToInt(JXDelimArrayGetElement(array, 4));
	spellsPerDay.iSpellsDomainPerDayLevel0 = StringToInt(JXDelimArrayGetElement(array, 5));
	// Spells/day level 2
	spellsPerDay.iSpellsPerDayLevel0 = StringToInt(JXDelimArrayGetElement(array, 6));
	spellsPerDay.iSpellsDomainPerDayLevel0 = StringToInt(JXDelimArrayGetElement(array, 7));
	// Spells/day level 3
	spellsPerDay.iSpellsPerDayLevel0 = StringToInt(JXDelimArrayGetElement(array, 8));
	spellsPerDay.iSpellsDomainPerDayLevel0 = StringToInt(JXDelimArrayGetElement(array, 9));
	// Spells/day level 4
	spellsPerDay.iSpellsPerDayLevel0 = StringToInt(JXDelimArrayGetElement(array, 10));
	spellsPerDay.iSpellsDomainPerDayLevel0 = StringToInt(JXDelimArrayGetElement(array, 11));
	// Spells/day level 5
	spellsPerDay.iSpellsPerDayLevel0 = StringToInt(JXDelimArrayGetElement(array, 12));
	spellsPerDay.iSpellsDomainPerDayLevel0 = StringToInt(JXDelimArrayGetElement(array, 13));
	// Spells/day level 6
	spellsPerDay.iSpellsPerDayLevel0 = StringToInt(JXDelimArrayGetElement(array, 14));
	spellsPerDay.iSpellsDomainPerDayLevel0 = StringToInt(JXDelimArrayGetElement(array, 15));
	// Spells/day level 7
	spellsPerDay.iSpellsPerDayLevel0 = StringToInt(JXDelimArrayGetElement(array, 16));
	spellsPerDay.iSpellsDomainPerDayLevel0 = StringToInt(JXDelimArrayGetElement(array, 17));
	// Spells/day level 8
	spellsPerDay.iSpellsPerDayLevel0 = StringToInt(JXDelimArrayGetElement(array, 18));
	spellsPerDay.iSpellsDomainPerDayLevel0 = StringToInt(JXDelimArrayGetElement(array, 19));
	// Spells/day level 9
	spellsPerDay.iSpellsPerDayLevel0 = StringToInt(JXDelimArrayGetElement(array, 20));
	spellsPerDay.iSpellsDomainPerDayLevel0 = StringToInt(JXDelimArrayGetElement(array, 21));
	// Spells/day level 10
	spellsPerDay.iSpellsPerDayLevel0 = StringToInt(JXDelimArrayGetElement(array, 22));

	return spellsPerDay;
}