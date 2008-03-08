#include "jx_inc_spbk_data"
#include "jx_inc_magic_info"
#include "jx_inc_magic_class"


/*// Get the number of spells per day for the assassin spellbook
// - iAssassinLevel Number of levels in the assassin class
// * Returns the number of spells per day
struct jx_spells_per_day JXGetSpellsPerDayForAssassin(int iAssassinLevel);

// Get the number of spells per day for the bard spellbook
// - iBardLevel Number of levels in the bard class
// * Returns the number of spells per day
struct jx_spells_per_day JXGetSpellsPerDayForBard(int iBardLevel);

// Get the number of spells per day for the blackguard spellbook
// - iBlackguardLevel Number of levels in the blackguard class
// * Returns the number of spells per day
struct jx_spells_per_day JXGetSpellsPerDayForBlackguard(int iBlackguardLevel);

// Get the number of spells per day for the cleric spellbook
// - iClericLevel Number of levels in the cleric class
// * Returns the number of spells per day
struct jx_spells_per_day JXGetSpellsPerDayForCleric(int iClericLevel);

// Get the number of spells per day for the druid spellbook
// - iDruidLevel Number of levels in the druid class
// * Returns the number of spells per day
struct jx_spells_per_day JXGetSpellsPerDayForDruid(int iDruidLevel);

// Get the number of spells per day for the paladin spellbook
// - iPaladinLevel Number of levels in the paladin class
// * Returns the number of spells per day
struct jx_spells_per_day JXGetSpellsPerDayForPaladin(int iPaladinLevel);

// Get the number of spells per day for the ranger spellbook
// - iRangerLevel Number of levels in the ranger class
// * Returns the number of spells per day
struct jx_spells_per_day JXGetSpellsPerDayForRanger(int iRangerLevel);

// Get the number of spells per day for the sorcerer spellbook
// - iSorcererLevel Number of levels in the sorcerer class
// * Returns the number of spells per day
struct jx_spells_per_day JXGetSpellsPerDayForSorcerer(int iSorcererLevel);

// Get the number of spells per day for the wizard spellbook
// - iWizardLevel Number of levels in the wizard class
// * Returns the number of spells per day
struct jx_spells_per_day JXGetSpellsPerDayForWizard(int iWizardLevel);*/

// Get the number of spells per day for the specified class and class level
// - iClass Spellcasting class with a limit of spells per day
// - iClassLevel Number of levels in the spellcasting class
// * Returns the number of spells per day
struct jx_spells_per_day JXGetSpellsPerDayForClass(int iClass, int iClassLevel);

// Get the number of bonus spell slots due to the caster's ability modifier
// - iAbilityModifier Spellcasting ability modifier 
// * Returns the number of bonus spell slots
struct jx_spells_per_day JXGetBonusSpellSlotsForAbilityModifier(int iAbilityModifier);

// Get the number of spells per day for the specified class of a PC
// - oPC Player character having spells per day
// - iClass Spellcasting class with a limit of spells per day
// - iSpellbookLevel Spellbook level to use (-1 to use the default for the PC)
// * Returns the number of spells per day
struct jx_spells_per_day JXGetSpellsPerDay(object oPC, int iClass, int iSpellbookLevel = -1);

// Get the maximum spell level available to a creature,
// depending on its spell ability score
// - oCreature Creature with spellcasting abilities
// - iClass Class for which the restriction is checked
int JXGetSpellLevelRestriction(object oCreature, int iClass);
















/*// Get the number of spells per day for the assassin spellbook
// - iAssassinLevel Number of levels in the assassin class
// * Returns the number of spells per day
struct jx_spells_per_day JXGetSpellsPerDayForAssassin(int iAssassinLevel)
{
	string sSpells = "";

	struct jx_spells_per_day spellsPerDay;
	
	switch (iAssassinLevel)
	{
		case 1: sSpells = "1;-1,-1;0,-1"; break;
		case 2: sSpells = "1;-1,-1;1,-1"; break;
		case 3: sSpells = "2;-1,-1;2,-1;0,-1"; break;
		case 4: sSpells = "2;-1,-1;3,-1;1,-1"; break;
		case 5: sSpells = "3;-1,-1;3,-1;2,-1;0,-1"; break;
		case 6: sSpells = "3;-1,-1;3,-1;3,-1;1,-1"; break;
		case 7: sSpells = "4;-1,-1;3,-1;3,-1;2,-1;0,-1"; break;
		case 8: sSpells = "4;-1,-1;3,-1;3,-1;3,-1;1,-1"; break;
		case 9: sSpells = "4;-1,-1;3,-1;3,-1;3,-1;2,-1"; break;
		case 10: sSpells = "4;-1,-1;3,-1;3,-1;3,-1;3,-1"; break;
	}

	return JXStringToSpellsDay(sSpells);
}

// Get the number of spells per day for the bard spellbook
// - iBardLevel Number of levels in the bard class
// * Returns the number of spells per day
struct jx_spells_per_day JXGetSpellsPerDayForBard(int iBardLevel)
{
	string sSpells = "";

	switch (iBardLevel)
	{
		case 1: sSpells = "0;2,-1"; break;
		case 2: sSpells = "1;3,-1;0,-1"; break;
		case 3: sSpells = "1;3,-1;1,-1"; break;
		case 4: sSpells = "2;3,-1;2,-1;0,-1"; break;
		case 5: sSpells = "2;3,-1;3,-1;1,-1"; break;
		case 6: sSpells = "2;3,-1;3,-1;2,-1"; break;
		case 7: sSpells = "3;3,-1;3,-1;2,-1;0,-1"; break;
		case 8: sSpells = "3;3,-1;3,-1;3,-1;1,-1"; break;
		case 9: sSpells = "3;3,-1;3,-1;3,-1;2,-1"; break;
		case 10: sSpells = "4;3,-1;3,-1;3,-1;2,-1;0,-1"; break;
		case 11: sSpells = "4;3,-1;3,-1;3,-1;3,-1;1,-1"; break;
		case 12: sSpells = "4;3,-1;3,-1;3,-1;3,-1;2,-1"; break;
		case 13: sSpells = "5;3,-1;3,-1;3,-1;3,-1;2,-1;0,-1"; break;
		case 14: sSpells = "5;4,-1;3,-1;3,-1;3,-1;3,-1;1,-1"; break;
		case 15: sSpells = "5;4,-1;4,-1;3,-1;3,-1;3,-1;2,-1"; break;
		case 16: sSpells = "6;4,-1;4,-1;4,-1;3,-1;3,-1;2,-1;0,-1"; break;
		case 17: sSpells = "6;4,-1;4,-1;4,-1;4,-1;3,-1;3,-1;1,-1"; break;
		case 18: sSpells = "6;4,-1;4,-1;4,-1;4,-1;4,-1;3,-1;2,-1"; break;
		case 19: sSpells = "6;4,-1;4,-1;4,-1;4,-1;4,-1;4,-1;3,-1"; break;
		case 20: sSpells = "6;4,-1;4,-1;4,-1;4,-1;4,-1;4,-1;4,-1"; break;
	}

	return JXStringToSpellsDay(sSpells);
}

// Get the number of spells per day for the blackguard spellbook
// - iBlackguardLevel Number of levels in the blackguard class
// * Returns the number of spells per day
struct jx_spells_per_day JXGetSpellsPerDayForBlackguard(int iBlackguardLevel)
{
	string sSpells = "";

	switch (iBlackguardLevel)
	{
		case 1: sSpells = "1;-1,-1;0,-1"; break;
		case 2: sSpells = "1;-1,-1;1,-1"; break;
		case 3: sSpells = "2;-1,-1;1,-1;0,-1"; break;
		case 4: sSpells = "2;-1,-1;1,-1;1,-1"; break;
		case 5: sSpells = "3;-1,-1;1,-1;1,-1;0,-1"; break;
		case 6: sSpells = "3;-1,-1;1,-1;1,-1;1,-1"; break;
		case 7: sSpells = "4;-1,-1;2,-1;1,-1;1,-1;0,-1"; break;
		case 8: sSpells = "4;-1,-1;2,-1;1,-1;1,-1;1,-1"; break;
		case 9: sSpells = "4;-1,-1;2,-1;2,-1;1,-1;1,-1"; break;
		case 10: sSpells = "4;-1,-1;2,-1;2,-1;2,-1;1,-1"; break;
	}

	return JXStringToSpellsDay(sSpells);
}

// Get the number of spells per day for the cleric spellbook
// - iClericLevel Number of levels in the cleric class
// * Returns the number of spells per day
struct jx_spells_per_day JXGetSpellsPerDayForCleric(int iClericLevel)
{
	string sSpells = "";

	switch (iClericLevel)
	{
		case 1: sSpells = "1;3,-1;1,1"; break;
		case 2: sSpells = "1;4,-1;2,1"; break;
		case 3: sSpells = "2;4,-1;2,1;1,1"; break;
		case 4: sSpells = "2;5,-1;3,1;2,1"; break;
		case 5: sSpells = "3;5,-1;3,1;2,1;1,1"; break;
		case 6: sSpells = "3;5,-1;3,1;3,1;2,1"; break;
		case 7: sSpells = "4;6,-1;4,1;3,1;2,1;1,1"; break;
		case 8: sSpells = "4;6,-1;4,1;3,1;3,1;2,1"; break;
		case 9: sSpells = "5;6,-1;4,1;4,1;3,1;2,1;1,1"; break;
		case 10: sSpells = "5;6,-1;4,1;4,1;3,1;3,1;2,1"; break;
		case 11: sSpells = "6;6,-1;5,1;4,1;4,1;3,1;2,1;1,1"; break;
		case 12: sSpells = "6;6,-1;5,1;4,1;4,1;3,1;3,1;2,1"; break;
		case 13: sSpells = "7;6,-1;5,1;5,1;4,1;4,1;3,1;2,1;1,1"; break;
		case 14: sSpells = "7;6,-1;5,1;5,1;4,1;4,1;3,1;3,1;2,1"; break;
		case 15: sSpells = "8;6,-1;5,1;5,1;5,1;4,1;4,1;3,1;2,1;1,1"; break;
		case 16: sSpells = "8;6,-1;5,1;5,1;5,1;4,1;4,1;3,1;3,1;2,1"; break;
		case 17: sSpells = "9;6,-1;5,1;5,1;5,1;5,1;4,1;4,1;3,1;2,1;1,1"; break;
		case 18: sSpells = "9;6,-1;5,1;5,1;5,1;5,1;4,1;4,1;3,1;3,1;2,1"; break;
		case 19: sSpells = "9;6,-1;5,1;5,1;5,1;5,1;5,1;4,1;4,1;3,1;3,1"; break;
		case 20: sSpells = "9;6,-1;5,1;5,1;5,1;5,1;5,1;4,1;4,1;4,1;4,1"; break;
	}

	return JXStringToSpellsDay(sSpells);
}

// Get the number of spells per day for the druid spellbook
// - iDruidLevel Number of levels in the druid class
// * Returns the number of spells per day
struct jx_spells_per_day JXGetSpellsPerDayForDruid(int iDruidLevel)
{
	string sSpells = "";

	switch (iDruidLevel)
	{
		case 1: sSpells = "1;3,-1;1,-1"; break;
		case 2: sSpells = "1;4,-1;2,-1"; break;
		case 3: sSpells = "2;4,-1;2,-1;1,-1"; break;
		case 4: sSpells = "2;5,-1;3,-1;2,-1"; break;
		case 5: sSpells = "3;5,-1;3,-1;2,-1;1,-1"; break;
		case 6: sSpells = "3;5,-1;3,-1;3,-1;2,-1"; break;
		case 7: sSpells = "4;6,-1;4,-1;3,-1;2,-1;1,-1"; break;
		case 8: sSpells = "4;6,-1;4,-1;3,-1;3,-1;2,-1"; break;
		case 9: sSpells = "5;6,-1;4,-1;4,-1;3,-1;2,-1;1,-1"; break;
		case 10: sSpells = "5;6,-1;4,-1;4,-1;3,-1;3,-1;2,-1"; break;
		case 11: sSpells = "6;6,-1;5,-1;4,-1;4,-1;3,-1;2,-1;1,-1"; break;
		case 12: sSpells = "6;6,-1;5,-1;4,-1;4,-1;3,-1;3,-1;2,-1"; break;
		case 13: sSpells = "7;6,-1;5,-1;5,-1;4,-1;4,-1;3,-1;2,-1;1,-1"; break;
		case 14: sSpells = "7;6,-1;5,-1;5,-1;4,-1;4,-1;3,-1;3,-1;2,-1"; break;
		case 15: sSpells = "8;6,-1;5,-1;5,-1;5,-1;4,-1;4,-1;3,-1;2,-1;1,-1"; break;
		case 16: sSpells = "8;6,-1;5,-1;5,-1;5,-1;4,-1;4,-1;3,-1;3,-1;2,-1"; break;
		case 17: sSpells = "9;6,-1;5,-1;5,-1;5,-1;5,-1;4,-1;4,-1;3,-1;2,-1;1,-1"; break;
		case 18: sSpells = "9;6,-1;5,-1;5,-1;5,-1;5,-1;4,-1;4,-1;3,-1;3,-1;2,-1"; break;
		case 19: sSpells = "9;6,-1;5,-1;5,-1;5,-1;5,-1;5,-1;4,-1;4,-1;3,-1;3,-1"; break;
		case 20: sSpells = "9;6,-1;5,-1;5,-1;5,-1;5,-1;5,-1;4,-1;4,-1;4,-1;4,-1"; break;
	}

	return JXStringToSpellsDay(sSpells);
}

// Get the number of spells per day for the paladin spellbook
// - iPaladinLevel Number of levels in the paladin class
// * Returns the number of spells per day
struct jx_spells_per_day JXGetSpellsPerDayForPaladin(int iPaladinLevel)
{
	string sSpells = "";

	switch (iPaladinLevel)
	{
		case 1: sSpells = "-1"; break;
		case 2: sSpells = "-1"; break;
		case 3: sSpells = "-1"; break;
		case 4: sSpells = "1;-1,-1;0,-1"; break;
		case 5: sSpells = "1;-1,-1;0,-1"; break;
		case 6: sSpells = "1;-1,-1;1,-1"; break;
		case 7: sSpells = "1;-1,-1;1,-1"; break;
		case 8: sSpells = "2;-1,-1;1,-1;0,-1"; break;
		case 9: sSpells = "2;-1,-1;1,-1;0,-1"; break;
		case 10: sSpells = "2;-1,-1;1,-1;1,-1"; break;
		case 11: sSpells = "3;-1,-1;1,-1;1,-1;0,-1"; break;
		case 12: sSpells = "3;-1,-1;1,-1;1,-1;1,-1"; break;
		case 13: sSpells = "3;-1,-1;1,-1;1,-1;1,-1"; break;
		case 14: sSpells = "4;-1,-1;2,-1;1,-1;1,-1;0,-1"; break;
		case 15: sSpells = "4;-1,-1;2,-1;1,-1;1,-1;1,-1"; break;
		case 16: sSpells = "4;-1,-1;2,-1;2,-1;1,-1;1,-1"; break;
		case 17: sSpells = "4;-1,-1;2,-1;2,-1;2,-1;1,-1"; break;
		case 18: sSpells = "4;-1,-1;3,-1;2,-1;2,-1;1,-1"; break;
		case 19: sSpells = "4;-1,-1;3,-1;3,-1;3,-1;2,-1"; break;
		case 20: sSpells = "4;-1,-1;3,-1;3,-1;3,-1;3,-1"; break;
	}

	return JXStringToSpellsDay(sSpells);
}

// Get the number of spells per day for the ranger spellbook
// - iRangerLevel Number of levels in the ranger class
// * Returns the number of spells per day
struct jx_spells_per_day JXGetSpellsPerDayForRanger(int iRangerLevel)
{
	string sSpells = "";

	switch (iRangerLevel)
	{
		case 1: sSpells = "-1"; break;
		case 2: sSpells = "-1"; break;
		case 3: sSpells = "-1"; break;
		case 4: sSpells = "1;-1,-1;0,-1"; break;
		case 5: sSpells = "1;-1,-1;0,-1"; break;
		case 6: sSpells = "1;-1,-1;1,-1"; break;
		case 7: sSpells = "1;-1,-1;1,-1"; break;
		case 8: sSpells = "2;-1,-1;1,-1;0,-1"; break;
		case 9: sSpells = "2;-1,-1;1,-1;0,-1"; break;
		case 10: sSpells = "2;-1,-1;1,-1;1,-1"; break;
		case 11: sSpells = "3;-1,-1;1,-1;1,-1;0,-1"; break;
		case 12: sSpells = "3;-1,-1;1,-1;1,-1;1,-1"; break;
		case 13: sSpells = "3;-1,-1;1,-1;1,-1;1,-1"; break;
		case 14: sSpells = "4;-1,-1;2,-1;1,-1;1,-1;0,-1"; break;
		case 15: sSpells = "4;-1,-1;2,-1;1,-1;1,-1;1,-1"; break;
		case 16: sSpells = "4;-1,-1;2,-1;2,-1;1,-1;1,-1"; break;
		case 17: sSpells = "4;-1,-1;2,-1;2,-1;2,-1;1,-1"; break;
		case 18: sSpells = "4;-1,-1;3,-1;2,-1;2,-1;1,-1"; break;
		case 19: sSpells = "4;-1,-1;3,-1;3,-1;3,-1;2,-1"; break;
		case 20: sSpells = "4;-1,-1;3,-1;3,-1;3,-1;3,-1"; break;
	}

	return JXStringToSpellsDay(sSpells);
}

// Get the number of spells per day for the sorcerer spellbook
// - iSorcererLevel Number of levels in the sorcerer class
// * Returns the number of spells per day
struct jx_spells_per_day JXGetSpellsPerDayForSorcerer(int iSorcererLevel)
{
	string sSpells = "";

	switch (iSorcererLevel)
	{
		case 1: sSpells = "1;5,-1;3,-1"; break;
		case 2: sSpells = "1;6,-1;4,-1"; break;
		case 3: sSpells = "1;6,-1;5,-1"; break;
		case 4: sSpells = "2;6,-1;6,-1;3,-1"; break;
		case 5: sSpells = "2;6,-1;6,-1;4,-1"; break;
		case 6: sSpells = "3;6,-1;6,-1;5,-1;3,-1"; break;
		case 7: sSpells = "3;6,-1;6,-1;6,-1;4,-1"; break;
		case 8: sSpells = "4;6,-1;6,-1;6,-1;5,-1;3,-1"; break;
		case 9: sSpells = "4;6,-1;6,-1;6,-1;6,-1;4,-1"; break;
		case 10: sSpells = "5;6,-1;6,-1;6,-1;6,-1;5,-1;3,-1"; break;
		case 11: sSpells = "5;6,-1;6,-1;6,-1;6,-1;6,-1;4,-1"; break;
		case 12: sSpells = "6;6,-1;6,-1;6,-1;6,-1;6,-1;5,-1;3,-1"; break;
		case 13: sSpells = "6;6,-1;6,-1;6,-1;6,-1;6,-1;6,-1;4,-1"; break;
		case 14: sSpells = "7;6,-1;6,-1;6,-1;6,-1;6,-1;6,-1;5,-1;3,-1"; break;
		case 15: sSpells = "7;6,-1;6,-1;6,-1;6,-1;6,-1;6,-1;6,-1;4,-1"; break;
		case 16: sSpells = "8;6,-1;6,-1;6,-1;6,-1;6,-1;6,-1;6,-1;5,-1;3,-1"; break;
		case 17: sSpells = "8;6,-1;6,-1;6,-1;6,-1;6,-1;6,-1;6,-1;6,-1;4,-1"; break;
		case 18: sSpells = "9;6,-1;6,-1;6,-1;6,-1;6,-1;6,-1;6,-1;6,-1;5,-1;3,-1"; break;
		case 19: sSpells = "9;6,-1;6,-1;6,-1;6,-1;6,-1;6,-1;6,-1;6,-1;6,-1;4,-1"; break;
		case 20: sSpells = "9;6,-1;6,-1;6,-1;6,-1;6,-1;6,-1;6,-1;6,-1;6,-1;6,-1"; break;
	}

	return JXStringToSpellsDay(sSpells);
}

// Get the number of spells per day for the wizard spellbook
// - iWizardLevel Number of levels in the wizard class
// * Returns the number of spells per day
struct jx_spells_per_day JXGetSpellsPerDayForWizard(int iWizardLevel)
{
	string sSpells = "";

	switch (iWizardLevel)
	{
		case 1: sSpells = "0;3,-1"; break;
		case 2: sSpells = "1;4,-1;2,-1"; break;
		case 3: sSpells = "2;4,-1;2,-1;1,-1"; break;
		case 4: sSpells = "2;4,-1;3,-1;2,-1"; break;
		case 5: sSpells = "3;4,-1;3,-1;2,-1;1,-1"; break;
		case 6: sSpells = "3;4,-1;3,-1;3,-1;2,-1"; break;
		case 7: sSpells = "4;4,-1;4,-1;3,-1;2,-1;1,-1"; break;
		case 8: sSpells = "4;4,-1;4,-1;3,-1;3,-1;2,-1"; break;
		case 9: sSpells = "5;4,-1;4,-1;4,-1;3,-1;2,-1;1,-1"; break;
		case 10: sSpells = "5;4,-1;4,-1;4,-1;3,-1;3,-1;2,-1"; break;
		case 11: sSpells = "6;4,-1;4,-1;4,-1;4,-1;3,-1;2,-1;1,-1"; break;
		case 12: sSpells = "6;4,-1;4,-1;4,-1;4,-1;3,-1;3,-1;2,-1"; break;
		case 13: sSpells = "7;4,-1;4,-1;4,-1;4,-1;4,-1;3,-1;2,-1;1,-1"; break;
		case 14: sSpells = "7;4,-1;4,-1;4,-1;4,-1;4,-1;3,-1;3,-1;2,-1"; break;
		case 15: sSpells = "8;4,-1;4,-1;4,-1;4,-1;4,-1;4,-1;3,-1;2,-1;1,-1"; break;
		case 16: sSpells = "8;4,-1;4,-1;4,-1;4,-1;4,-1;4,-1;3,-1;3,-1;2,-1"; break;
		case 17: sSpells = "9;4,-1;4,-1;4,-1;4,-1;4,-1;4,-1;4,-1;3,-1;2,-1;1,-1"; break;
		case 18: sSpells = "9;4,-1;4,-1;4,-1;4,-1;4,-1;4,-1;4,-1;3,-1;3,-1;2,-1"; break;
		case 19: sSpells = "9;4,-1;4,-1;4,-1;4,-1;4,-1;4,-1;4,-1;4,-1;3,-1;3,-1"; break;
		case 20: sSpells = "9;4,-1;4,-1;4,-1;4,-1;4,-1;4,-1;4,-1;4,-1;4,-1;4,-1"; break;
	}

	return JXStringToSpellsDay(sSpells);
}

// Get the number of spells per day for the specified class and class level
// - iClass Spellcasting class with a limit of spells per day
// - iClassLevel Number of levels in the spellcasting class
// * Returns the number of spells per day
struct jx_spells_per_day JXGetSpellsPerDayForClass(int iClass, int iClassLevel)
{
	switch (iClass)
	{
		case CLASS_TYPE_ASSASSIN:
			return JXGetSpellsPerDayForAssassin(iClassLevel);
		case CLASS_TYPE_BARD:
			return JXGetSpellsPerDayForBard(iClassLevel);
		case CLASS_TYPE_BLACKGUARD:
			return JXGetSpellsPerDayForBlackguard(iClassLevel);
		case CLASS_TYPE_CLERIC:
			return JXGetSpellsPerDayForCleric(iClassLevel);
		case CLASS_TYPE_DRUID:
			return JXGetSpellsPerDayForDruid(iClassLevel);
		case CLASS_TYPE_PALADIN:
			return JXGetSpellsPerDayForPaladin(iClassLevel);
		case CLASS_TYPE_RANGER:
			return JXGetSpellsPerDayForRanger(iClassLevel);
		case CLASS_TYPE_SORCERER:
			return JXGetSpellsPerDayForSorcerer(iClassLevel);
		case CLASS_TYPE_WIZARD:
			return JXGetSpellsPerDayForWizard(iClassLevel);
	}

	struct jx_spells_per_day spellsInvalid;
	return spellsInvalid;
}*/

// Get the number of spells per day for the specified class and caster level
// - iClass Spellcasting class with a limit of spells per day
// - iClassCasterLevel Caster level for the class
// * Returns the number of spells per day
struct jx_spells_per_day JXGetSpellsPerDayForClass(int iClass, int iClassCasterLevel)
{
	struct jx_spells_per_day spellsDay = JXSpellsDayCreateStruct();

	// Get the 2da file that has spells/day for the specified class
	string sSpellsDay2DA = Get2DAString("classes", "SpellGainTable", iClass);
	// Determine if a class has domains
	int bHasDomains = JXClassGetHasDomains(iClass);

	// Loop through all spell levels
	int iNbSpellLevels = StringToInt(Get2DAString(sSpellsDay2DA, "NumSpellLevels", iClassCasterLevel - 1));
	int iLoopSpellLevel;
	for (iLoopSpellLevel = 0; iLoopSpellLevel < iNbSpellLevels; iLoopSpellLevel++)
	{
		// Get the number of spells/day for the current spell level
		string sNbSpells = Get2DAString(sSpellsDay2DA, "SpellLevel" + IntToString(iLoopSpellLevel), iClassCasterLevel - 1);

		// No spells/day found
		if (sNbSpells == "")
			spellsDay = JXSpellsDaySetNbSpells(spellsDay, iLoopSpellLevel, -1);
		else
		{
			int iNbSpellsDay = StringToInt(sNbSpells);

			// Infinite spells/day found
			if (iNbSpellsDay == 240)
				spellsDay = JXSpellsDaySetNbSpells(spellsDay, iLoopSpellLevel, -2);
			// Spells/day found
			else
				spellsDay = JXSpellsDaySetNbSpells(spellsDay, iLoopSpellLevel, StringToInt(sNbSpells));
			// Define the domain spell slot
			if (bHasDomains)
				spellsDay = JXSpellsDaySetNbSpellsDomain(spellsDay, iLoopSpellLevel, 1);
			else
				spellsDay = JXSpellsDaySetNbSpellsDomain(spellsDay, iLoopSpellLevel, -1);
		}
	}

	// Fill the unusable spell slots
	for (iLoopSpellLevel = iNbSpellLevels; iLoopSpellLevel <= 9; iLoopSpellLevel++)
	{
		spellsDay = JXSpellsDaySetNbSpells(spellsDay, iLoopSpellLevel, -1);
		spellsDay = JXSpellsDaySetNbSpellsDomain(spellsDay, iLoopSpellLevel, -1);
	}

	return spellsDay;
}

// Get the number of bonus spell slots due to the caster's ability modifier
// - iAbilityModifier Spellcasting ability modifier 
// * Returns the number of bonus spell slots
struct jx_spells_per_day JXGetBonusSpellSlotsForAbilityModifier(int iAbilityModifier)
{
	string sSpellsDay;

	switch (iAbilityModifier)
	{
		case 0: sSpellsDay = "0"; break;
		case 1: sSpellsDay = "1;-1,-1;1,-1"; break;
		case 2: sSpellsDay = "2;-1,-1;1,-1;1,-1"; break;
		case 3: sSpellsDay = "3;-1,-1;1,-1;1,-1;1,-1"; break;
		case 4: sSpellsDay = "4;-1,-1;1,-1;1,-1;1,-1;1,-1"; break;
		case 5: sSpellsDay = "5;-1,-1;2,-1;1,-1;1,-1;1,-1;1,-1"; break;
		case 6: sSpellsDay = "6;-1,-1;2,-1;2,-1;1,-1;1,-1;1,-1;1,-1"; break;
		case 7: sSpellsDay = "7;-1,-1;2,-1;2,-1;2,-1;1,-1;1,-1;1,-1;1,-1"; break;
		case 8: sSpellsDay = "8;-1,-1;2,-1;2,-1;2,-1;2,-1;1,-1;1,-1;1,-1;1,-1"; break;
		case 9: sSpellsDay = "9;-1,-1;3,-1;2,-1;2,-1;2,-1;2,-1;1,-1;1,-1;1,-1;1,-1"; break;
		case 10: sSpellsDay = "9;-1,-1;3,-1;3,-1;2,-1;2,-1;2,-1;2,-1;1,-1;1,-1;1,-1"; break;
		case 11: sSpellsDay = "9;-1,-1;3,-1;3,-1;3,-1;2,-1;2,-1;2,-1;2,-1;1,-1;1,-1"; break;
		case 12: sSpellsDay = "9;-1,-1;3,-1;3,-1;3,-1;3,-1;2,-1;2,-1;2,-1;2,-1;1,-1"; break;
		case 13: sSpellsDay = "9;-1,-1;4,-1;3,-1;3,-1;3,-1;3,-1;2,-1;2,-1;2,-1;2,-1"; break;
		case 14: sSpellsDay = "9;-1,-1;4,-1;4,-1;3,-1;3,-1;3,-1;3,-1;2,-1;2,-1;2,-1"; break;
		case 15: sSpellsDay = "9;-1,-1;4,-1;4,-1;4,-1;3,-1;3,-1;3,-1;3,-1;2,-1;2,-1"; break;
		case 16: sSpellsDay = "9;-1,-1;4,-1;4,-1;4,-1;4,-1;3,-1;3,-1;3,-1;3,-1;2,-1"; break;
		case 17: sSpellsDay = "9;-1,-1;5,-1;4,-1;4,-1;4,-1;4,-1;3,-1;3,-1;3,-1;3,-1"; break;
		case 18: sSpellsDay = "9;-1,-1;5,-1;5,-1;4,-1;4,-1;4,-1;4,-1;3,-1;3,-1;3,-1"; break;
		case 19: sSpellsDay = "9;-1,-1;5,-1;5,-1;5,-1;4,-1;4,-1;4,-1;4,-1;3,-1;3,-1"; break;
		case 20: sSpellsDay = "9;-1,-1;5,-1;5,-1;5,-1;5,-1;4,-1;4,-1;4,-1;4,-1;3,-1"; break;
	}

	return JXStringToSpellsDay(sSpellsDay);
}

// Get the number of extra spell slots from the caster's feats
// - oPC Player character having spells per day
// - iClass Spellcasting class with a limit of spells per day
// - iSpellsPerDayLevel Level used to get spells per day
// * Returns the number of bonus spell slots
struct jx_spells_per_day JXGetExtraSpellSlotsFromFeats(object oPC, int iClass, int iSpellsPerDayLevel)
{
	string sSpellsDay = "9;-1,-1;-1,-1;-1,-1;-1,-1;-1,-1;-1,-1;-1,-1;-1,-1;-1,-1;-1,-1";
	struct jx_spells_per_day spellsDay = JXStringToSpellsDay(sSpellsDay);

	// Determine if a class has extra spell slots
	string sFeatExtraSlots = Get2DAString("classes", "FEATExtraSlot", iClass);
	if (sFeatExtraSlots == "") return spellsDay;
	int iFeatExtraSlots = StringToInt(sFeatExtraSlots);

	// Get the 2da file that has spells/day for the specified class
	string sSpellsDay2DA = Get2DAString("classes", "SpellGainTable", iClass);
	int iNbSpellLevels = StringToInt(Get2DAString(sSpellsDay2DA, "NumSpellLevels", iSpellsPerDayLevel - 1));

	// Loop through all spell levels
	int iLoopSpellLevel;
	for (iLoopSpellLevel = 0; iLoopSpellLevel < iNbSpellLevels; iLoopSpellLevel++)
	{
		if (GetHasFeat(iFeatExtraSlots + iLoopSpellLevel, oPC))
			spellsDay = JXSpellsDaySetNbSpells(spellsDay, iLoopSpellLevel, 1);
	}

	return spellsDay;
}

// Get the number of extra spell slots from the caster's items
// - oPC Player character having spells per day
// - iClass Spellcasting class with a limit of spells per day
// * Returns the number of bonus spell slots
struct jx_spells_per_day JXGetExtraSpellSlotsFromItem(object oPC, int iClass)
{
	string sSpellsDay = "9;-1,-1;-1,-1;-1,-1;-1,-1;-1,-1;-1,-1;-1,-1;-1,-1;-1,-1;-1,-1";
	struct jx_spells_per_day spellsDay = JXStringToSpellsDay(sSpellsDay);

	// Loop through all items equipped by the PC
	object oLoopItem;
	int iLoopItem;
	for (iLoopItem = 0; iLoopItem < 14; iLoopItem++)
	{
		oLoopItem = GetItemInSlot(iLoopItem, oPC);
		if (GetIsObjectValid(oLoopItem))
		{
			// Loop through all item properties on the item
			itemproperty ipLoop = GetFirstItemProperty(oLoopItem);
			while (GetIsItemPropertyValid(ipLoop))
			{
				// Extra spell slot found for the class
				if ((GetItemPropertyType(ipLoop) == ITEM_PROPERTY_BONUS_SPELL_SLOT_OF_LEVEL_N)
				 && (GetItemPropertySubType(ipLoop) == iClass))
				{
					int iSpellLevel = GetItemPropertyCostTableValue(ipLoop);
					spellsDay = JXSpellsDaySetNbSpells(spellsDay, iSpellLevel, 1);
				}
				ipLoop = GetNextItemProperty(oLoopItem);
			}
		}
	}

	return spellsDay;
}

// Private function
int JXPrivateGetImprovedSpellsPerDay(object oCreature, int iBaseClass)
{
	int iCasterLevel = 0;

	// Loop through all classes to find prestige classes that could improve the base class' caster level
	int iLoopPrC;
	int iLoopPrCLevel;
	int iLoopClassPosition;
	for (iLoopClassPosition = 1; iLoopClassPosition <= 4; iLoopClassPosition++)
	{
		// Get the current class and its caster level
		iLoopPrC = GetClassByPosition(iLoopClassPosition, oCreature);
		iLoopPrCLevel = GetLevelByPosition(iLoopClassPosition, oCreature);

		// Determine if the current class improves the specified base class
		string sBonusCasterFeat2DA = Get2DAString("classes", "BonusCasterFeatByClassMap", iLoopPrC);
		if (sBonusCasterFeat2DA != "")
		{
			// Get the feature that determines if the prestige class improves the base class
			int iFeatMainClass = StringToInt(Get2DAString(sBonusCasterFeat2DA, "SpellcasterFeat", iBaseClass));
			// Test if the prestige class improves the base class for the creature
			if ((iFeatMainClass > 0) && (GetHasFeat(iFeatMainClass, oCreature)))
			{
				string sBonusSpellcasterLevel2DA = Get2DAString("classes", "BonusSpellcasterLevelTable", iLoopPrC);
				// Loop through all spell level to get the class' caster level
				int iLoopLevel;
				for (iLoopLevel = 1; iLoopLevel <= iLoopPrCLevel; iLoopLevel++)
					iCasterLevel += StringToInt(Get2DAString(sBonusSpellcasterLevel2DA, "GrantsBonusSpellcasterLevel", iLoopLevel));
			}
		}
	}

	return iCasterLevel;
}

int JXGetSpellbookLevel(object oPC, int iClass)
{
	int iSpellsPerDayLevel = GetLevelByClass(iClass, oPC);
	iSpellsPerDayLevel += JXPrivateGetImprovedSpellsPerDay(oPC, iClass);
	
	return iSpellsPerDayLevel;
}

// Get the number of spells per day for the specified class of a PC
// - oPC Player character having spells per day
// - iClass Spellcasting class with a limit of spells per day
// - iSpellbookLevel Spellbook level to use (-1 to use the default for the PC)
// * Returns the number of spells per day
struct jx_spells_per_day JXGetSpellsPerDay(object oPC, int iClass, int iSpellbookLevel)
{
	// Get the number of spells per day for the specified class of the PC
	if (iSpellbookLevel == -1)
		iSpellbookLevel = JXGetSpellbookLevel(oPC, iClass);
	struct jx_spells_per_day spellsDayClass = JXGetSpellsPerDayForClass(iClass, iSpellbookLevel);

	// Get the number of bonus spells per day due to the ability modifier
	int iAbility = JXClassGetCasterAbility(iClass);
	int iAbilityModifier = GetAbilityModifier(iAbility, oPC);
	struct jx_spells_per_day spellsDayAbility = JXGetBonusSpellSlotsForAbilityModifier(iAbilityModifier);

	// Add extra spells slots from feats
	struct jx_spells_per_day spellsDayFeat = JXGetExtraSpellSlotsFromFeats(oPC, iClass, iSpellbookLevel);

	// Add extra spells slots from items
	struct jx_spells_per_day spellsDayItem = JXGetExtraSpellSlotsFromItem(oPC, iClass);

	// Compute the total number of spell slots per day
	struct jx_spells_per_day spellsDay = JXSpellsDayAddSpellsDay(spellsDayClass, spellsDayAbility);
	spellsDay = JXSpellsDayAddSpellsDay(spellsDay, spellsDayFeat);
	spellsDay = JXSpellsDayAddSpellsDay(spellsDay, spellsDayItem);

	return spellsDay;
}

int JXClassGetHasSpellbook(int iClass, int iSpellbookLevel)
{
	if (iClass == CLASS_TYPE_INVALID)
		return FALSE;

	// Verify that spells per day exist for the class
	string sSpellProgression = Get2DAString("classes", "SpellGainTable", iClass);
	if (sSpellProgression == "")
		return FALSE;

	// Determine best the spell level for the class level
	int iMaxSpellLevel = StringToInt(Get2DAString(sSpellProgression, "NumSpellLevels", iSpellbookLevel - 1));

	// Spells at least of level 1 available, so a spellbook is defined
	if (iMaxSpellLevel > 0)
		return TRUE;

	// Spells of level 0 available, so a spellbook is defined
	if (Get2DAString(sSpellProgression, "SpellLevel0", iSpellbookLevel - 1) != "")
		return TRUE;

	return FALSE;
}

int JXGetHasSpellbook(object oCreature, int iClass)
{
	// Get the spellbook level of the creature
	int iSpellbookLevel = JXGetSpellbookLevel(oCreature, iClass);

	return JXClassGetHasSpellbook(iClass, iSpellbookLevel);
}

// Get the maximum spell level available to a creature,
// depending on its spell ability score
// - oCreature Creature with spellcasting abilities
// - iClass Class for which the restriction is checked
int JXGetSpellLevelRestriction(object oCreature, int iClass)
{
	// The warlock hasn't any restriction due to a low charisma score,
	// so set his maximum spell level to the maximum spell level available for a warlock
	if (iClass == CLASS_TYPE_WARLOCK)
		return 4;

	// Other cases
	int iAbilityType = JXClassGetCasterAbility(iClass);
	int iAbilityScore = GetAbilityScore(oCreature, iAbilityType, TRUE);

	return iAbilityScore - 10;
}