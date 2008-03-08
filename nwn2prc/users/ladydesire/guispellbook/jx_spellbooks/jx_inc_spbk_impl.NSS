#include "jx_inc_spbk_data"


// Get the complete list of spells available for the assassin
// - iSpellLevel Spell level to get the spells from (-1 for all levels)
// * Returns the list of spells available for the assassin
struct jx_spells_known JXGetSpellListForAssassin(int iSpellLevel = -1)
{
	struct jx_spells_known spellsList = JXSpellsKnownCreateStruct();

	// Level 1
	if ((iSpellLevel == 1) || (iSpellLevel == -1))
	{
		spellsList = JXSpellsKnownAddSpell(spellsList, 1, SPELL_SLEEP);
		spellsList = JXSpellsKnownAddSpell(spellsList, 1, SPELL_TRUE_STRIKE);
		spellsList = JXSpellsKnownAddSpell(spellsList, 1, SPELL_DARKNESS);
	}

	// Level 2
	if ((iSpellLevel == 2) || (iSpellLevel == -1))
	{
		spellsList = JXSpellsKnownAddSpell(spellsList, 2, SPELL_GHOSTLY_VISAGE);
		spellsList = JXSpellsKnownAddSpell(spellsList, 2, SPELL_CATS_GRACE);
		spellsList = JXSpellsKnownAddSpell(spellsList, 2, SPELL_FOXS_CUNNING);
		spellsList = JXSpellsKnownAddSpell(spellsList, 2, SPELL_INVISIBILITY);
	}
	
	// Level 3
	if ((iSpellLevel == 3) || (iSpellLevel == -1))
	{
		spellsList = JXSpellsKnownAddSpell(spellsList, 3, SPELL_DEEP_SLUMBER);
		spellsList = JXSpellsKnownAddSpell(spellsList, 3, SPELL_FALSE_LIFE);
		spellsList = JXSpellsKnownAddSpell(spellsList, 3, 322);	// SPELL_MAGIC_CIRCLE_AGAINST_ALIGNMENT
	}

	// Level 4
	if ((iSpellLevel == 4) || (iSpellLevel == -1))
	{
		spellsList = JXSpellsKnownAddSpell(spellsList, 4, SPELL_CLAIRAUDIENCE_AND_CLAIRVOYANCE);
		spellsList = JXSpellsKnownAddSpell(spellsList, 4, SPELL_FREEDOM_OF_MOVEMENT);
		spellsList = JXSpellsKnownAddSpell(spellsList, 4, SPELL_GREATER_INVISIBILITY);
		spellsList = JXSpellsKnownAddSpell(spellsList, 4, SPELL_POISON);
	}

	return spellsList;
}

// Get the complete list of spells available for the bard
// - iSpellLevel Spell level to get the spells from (-1 for all levels)
// * Returns the list of spells available for the bard
struct jx_spells_known JXGetSpellListForBard(int iSpellLevel = -1)
{
	struct jx_spells_known spellsList = JXSpellsKnownCreateStruct();

	// Level 0
	if ((iSpellLevel == 0) || (iSpellLevel == -1))
	{
		spellsList = JXSpellsKnownAddSpell(spellsList, 0, SPELL_CURE_MINOR_WOUNDS);
		spellsList = JXSpellsKnownAddSpell(spellsList, 0, SPELL_LIGHT);
		spellsList = JXSpellsKnownAddSpell(spellsList, 0, SPELL_RESISTANCE);
		spellsList = JXSpellsKnownAddSpell(spellsList, 0, SPELL_DAZE);
		spellsList = JXSpellsKnownAddSpell(spellsList, 0, SPELL_FLARE);
	}

	// Level 1
	if ((iSpellLevel == 1) || (iSpellLevel == -1))
	{
		spellsList = JXSpellsKnownAddSpell(spellsList, 1, SPELL_CURE_LIGHT_WOUNDS);
		spellsList = JXSpellsKnownAddSpell(spellsList, 1, SPELL_REMOVE_FEAR);
		spellsList = JXSpellsKnownAddSpell(spellsList, 1, SPELL_SUMMON_CREATURE_I);
		spellsList = JXSpellsKnownAddSpell(spellsList, 1, SPELL_LESSER_DISPEL);
		spellsList = JXSpellsKnownAddSpell(spellsList, 1, SPELL_CHARM_PERSON);
		spellsList = JXSpellsKnownAddSpell(spellsList, 1, SPELL_GREASE);
		spellsList = JXSpellsKnownAddSpell(spellsList, 1, SPELL_IDENTIFY);
		spellsList = JXSpellsKnownAddSpell(spellsList, 1, SPELL_SLEEP);
		spellsList = JXSpellsKnownAddSpell(spellsList, 1, SPELL_BALAGARNSIRONHORN);
		spellsList = JXSpellsKnownAddSpell(spellsList, 1, SPELL_AMPLIFY);
		spellsList = JXSpellsKnownAddSpell(spellsList, 1, SPELL_EXPEDITIOUS_RETREAT);
		spellsList = JXSpellsKnownAddSpell(spellsList, 1, SPELL_TASHAS_HIDEOUS_LAUGHTER);
		spellsList = JXSpellsKnownAddSpell(spellsList, 1, SPELL_JOYFUL_NOISE);
	}

	// Level 2
	if ((iSpellLevel == 2) || (iSpellLevel == -1))
	{
		spellsList = JXSpellsKnownAddSpell(spellsList, 2, SPELL_BULLS_STRENGTH);
		spellsList = JXSpellsKnownAddSpell(spellsList, 2, SPELL_CURE_MODERATE_WOUNDS);
		spellsList = JXSpellsKnownAddSpell(spellsList, 2, SPELL_DARKNESS);
		spellsList = JXSpellsKnownAddSpell(spellsList, 2, SPELL_HOLD_PERSON);
		spellsList = JXSpellsKnownAddSpell(spellsList, 2, SPELL_SILENCE);
		spellsList = JXSpellsKnownAddSpell(spellsList, 2, SPELL_SOUND_BURST);
		spellsList = JXSpellsKnownAddSpell(spellsList, 2, SPELL_SUMMON_CREATURE_II);
		spellsList = JXSpellsKnownAddSpell(spellsList, 2, SPELL_EAGLES_SPLENDOR);
		spellsList = JXSpellsKnownAddSpell(spellsList, 2, SPELL_OWLS_WISDOM);
		spellsList = JXSpellsKnownAddSpell(spellsList, 2, SPELL_FOXS_CUNNING);
		spellsList = JXSpellsKnownAddSpell(spellsList, 2, SPELL_BLINDNESS_AND_DEAFNESS);
		spellsList = JXSpellsKnownAddSpell(spellsList, 2, SPELL_CATS_GRACE);
		spellsList = JXSpellsKnownAddSpell(spellsList, 2, SPELL_INVISIBILITY);
		spellsList = JXSpellsKnownAddSpell(spellsList, 2, SPELL_GHOSTLY_VISAGE);
		spellsList = JXSpellsKnownAddSpell(spellsList, 2, SPELL_CLOUD_OF_BEWILDERMENT);
		spellsList = JXSpellsKnownAddSpell(spellsList, 2, SPELL_MIRROR_IMAGE);
		spellsList = JXSpellsKnownAddSpell(spellsList, 2, SPELL_SCARE);
		spellsList = JXSpellsKnownAddSpell(spellsList, 2, SPELL_HEROISM);
		spellsList = JXSpellsKnownAddSpell(spellsList, 2, SPELL_RAGE);
		spellsList = JXSpellsKnownAddSpell(spellsList, 2, SPELL_CURSE_OF_BLADES);
	}

	// Level 3
	if ((iSpellLevel == 3) || (iSpellLevel == -1))
	{
		spellsList = JXSpellsKnownAddSpell(spellsList, 3, SPELL_FIND_TRAPS);
		spellsList = JXSpellsKnownAddSpell(spellsList, 3, SPELL_CURE_SERIOUS_WOUNDS);
		spellsList = JXSpellsKnownAddSpell(spellsList, 3, SPELL_DISPEL_MAGIC);
		spellsList = JXSpellsKnownAddSpell(spellsList, 3, SPELL_REMOVE_CURSE);
		spellsList = JXSpellsKnownAddSpell(spellsList, 3, SPELL_SUMMON_CREATURE_III);
		spellsList = JXSpellsKnownAddSpell(spellsList, 3, SPELL_WEAPON_OF_IMPACT);
		spellsList = JXSpellsKnownAddSpell(spellsList, 3, SPELL_CHARM_MONSTER);
		spellsList = JXSpellsKnownAddSpell(spellsList, 3, SPELL_CLAIRAUDIENCE_AND_CLAIRVOYANCE);
		spellsList = JXSpellsKnownAddSpell(spellsList, 3, SPELL_FEAR);
		spellsList = JXSpellsKnownAddSpell(spellsList, 3, SPELL_HASTE);
		spellsList = JXSpellsKnownAddSpell(spellsList, 3, SPELL_INVISIBILITY_SPHERE);
		spellsList = JXSpellsKnownAddSpell(spellsList, 3, SPELL_SEE_INVISIBILITY);
		spellsList = JXSpellsKnownAddSpell(spellsList, 3, SPELL_SLOW);
		spellsList = JXSpellsKnownAddSpell(spellsList, 3, SPELL_DISPLACEMENT);
		spellsList = JXSpellsKnownAddSpell(spellsList, 3, SPELL_DEEP_SLUMBER);
		spellsList = JXSpellsKnownAddSpell(spellsList, 3, SPELL_CRUSHING_DESPAIR);
		spellsList = JXSpellsKnownAddSpell(spellsList, 3, SPELL_GREATER_CURSE_OF_BLADES);
	}

	// Level 4
	if ((iSpellLevel == 4) || (iSpellLevel == -1))
	{
		spellsList = JXSpellsKnownAddSpell(spellsList, 4, SPELL_CURE_CRITICAL_WOUNDS);
		spellsList = JXSpellsKnownAddSpell(spellsList, 4, SPELL_FREEDOM_OF_MOVEMENT);
		spellsList = JXSpellsKnownAddSpell(spellsList, 4, SPELL_NEUTRALIZE_POISON);
		spellsList = JXSpellsKnownAddSpell(spellsList, 4, SPELL_SUMMON_CREATURE_IV);
		spellsList = JXSpellsKnownAddSpell(spellsList, 4, SPELL_DOMINATE_PERSON);
		spellsList = JXSpellsKnownAddSpell(spellsList, 4, SPELL_HOLD_MONSTER);
		spellsList = JXSpellsKnownAddSpell(spellsList, 4, SPELL_GREATER_INVISIBILITY);
		spellsList = JXSpellsKnownAddSpell(spellsList, 4, 159);	// SPELL_SHADOW_CONJURATION
		spellsList = JXSpellsKnownAddSpell(spellsList, 4, SPELL_WAR_CRY);
		spellsList = JXSpellsKnownAddSpell(spellsList, 4, SPELL_LEGEND_LORE);
		spellsList = JXSpellsKnownAddSpell(spellsList, 4, SPELL_GREATER_RESISTANCE);
		spellsList = JXSpellsKnownAddSpell(spellsList, 4, SPELL_SHOUT);
	}

	// Level 5
	if ((iSpellLevel == 5) || (iSpellLevel == -1))
	{
		spellsList = JXSpellsKnownAddSpell(spellsList, 5, SPELL_MASS_CURE_LIGHT_WOUNDS);
		spellsList = JXSpellsKnownAddSpell(spellsList, 5, SPELL_SUMMON_CREATURE_V);
		spellsList = JXSpellsKnownAddSpell(spellsList, 5, SPELL_GREATER_DISPELLING);
		spellsList = JXSpellsKnownAddSpell(spellsList, 5, SPELL_MIND_FOG);
		spellsList = JXSpellsKnownAddSpell(spellsList, 5, SPELL_ETHEREAL_VISAGE);
		spellsList = JXSpellsKnownAddSpell(spellsList, 5, SPELL_GREATER_HEROISM);
		spellsList = JXSpellsKnownAddSpell(spellsList, 5, SPELL_SONG_OF_DISCORD);
		spellsList = JXSpellsKnownAddSpell(spellsList, 5, SPELL_CACOPHONIC_BURST);
	}

	// Level 6
	if ((iSpellLevel == 6) || (iSpellLevel == -1))
	{
		spellsList = JXSpellsKnownAddSpell(spellsList, 6, SPELL_SUMMON_CREATURE_VI);
		spellsList = JXSpellsKnownAddSpell(spellsList, 6, SPELL_ENERGY_IMMUNITY);
		spellsList = JXSpellsKnownAddSpell(spellsList, 6, SPELL_MASS_CURE_MODERATE_WOUNDS);
		spellsList = JXSpellsKnownAddSpell(spellsList, 6, SPELL_MASS_CHARM);
		spellsList = JXSpellsKnownAddSpell(spellsList, 6, SPELL_ICE_STORM);
		spellsList = JXSpellsKnownAddSpell(spellsList, 6, SPELL_DIRGE);
		spellsList = JXSpellsKnownAddSpell(spellsList, 6, SPELL_MASS_HOLD_PERSON);
		spellsList = JXSpellsKnownAddSpell(spellsList, 6, SPELL_SUPERIOR_RESISTANCE);
		spellsList = JXSpellsKnownAddSpell(spellsList, 6, SPELL_MASS_CAT_GRACE);
		spellsList = JXSpellsKnownAddSpell(spellsList, 6, SPELL_MASS_EAGLE_SPLENDOR);
		spellsList = JXSpellsKnownAddSpell(spellsList, 6, SPELL_MASS_FOX_CUNNING);
		spellsList = JXSpellsKnownAddSpell(spellsList, 6, SPELL_GREATER_SHOUT);
	}

	return spellsList;
}

// Get the complete list of spells available for the blackguard
// - iSpellLevel Spell level to get the spells from (-1 for all levels)
// * Returns the list of spells available for the blackguard
struct jx_spells_known JXGetSpellListForBlackguard(int iSpellLevel = -1)
{
	struct jx_spells_known spellsList = JXSpellsKnownCreateStruct();

	// Level 1
	if ((iSpellLevel == 1) || (iSpellLevel == -1))
	{
		spellsList = JXSpellsKnownAddSpell(spellsList, 1, SPELL_CAUSE_FEAR);
		spellsList = JXSpellsKnownAddSpell(spellsList, 1, SPELL_CURE_LIGHT_WOUNDS);
		spellsList = JXSpellsKnownAddSpell(spellsList, 1, SPELL_DOOM);
		spellsList = JXSpellsKnownAddSpell(spellsList, 1, SPELL_INFLICT_LIGHT_WOUNDS);
		spellsList = JXSpellsKnownAddSpell(spellsList, 1, SPELL_MAGIC_WEAPON);
		spellsList = JXSpellsKnownAddSpell(spellsList, 1, SPELL_SUMMON_CREATURE_I);
	}

	// Level 2
	if ((iSpellLevel == 2) || (iSpellLevel == -1))
	{
		spellsList = JXSpellsKnownAddSpell(spellsList, 2, SPELL_BULLS_STRENGTH);
		spellsList = JXSpellsKnownAddSpell(spellsList, 2, SPELL_CURE_MODERATE_WOUNDS);
		spellsList = JXSpellsKnownAddSpell(spellsList, 2, SPELL_DARKNESS);
		spellsList = JXSpellsKnownAddSpell(spellsList, 2, SPELL_DEATH_KNELL);
		spellsList = JXSpellsKnownAddSpell(spellsList, 2, SPELL_EAGLES_SPLENDOR);
		spellsList = JXSpellsKnownAddSpell(spellsList, 2, SPELL_INFLICT_MODERATE_WOUNDS);
		spellsList = JXSpellsKnownAddSpell(spellsList, 2, SPELL_SUMMON_CREATURE_II);
	}

	// Level 3
	if ((iSpellLevel == 3) || (iSpellLevel == -1))
	{
		spellsList = JXSpellsKnownAddSpell(spellsList, 3, SPELL_CONTAGION);
		spellsList = JXSpellsKnownAddSpell(spellsList, 3, SPELL_CURE_SERIOUS_WOUNDS);
		spellsList = JXSpellsKnownAddSpell(spellsList, 3, SPELL_INFLICT_SERIOUS_WOUNDS);
		spellsList = JXSpellsKnownAddSpell(spellsList, 3, SPELL_PROTECTION_FROM_ENERGY);
		spellsList = JXSpellsKnownAddSpell(spellsList, 3, SPELL_SUMMON_CREATURE_III);
	}

	// Level 4
	if ((iSpellLevel == 4) || (iSpellLevel == -1))
	{
		spellsList = JXSpellsKnownAddSpell(spellsList, 4, SPELL_CURE_CRITICAL_WOUNDS);
		spellsList = JXSpellsKnownAddSpell(spellsList, 4, SPELL_FREEDOM_OF_MOVEMENT);
		spellsList = JXSpellsKnownAddSpell(spellsList, 4, SPELL_INFLICT_CRITICAL_WOUNDS);
		spellsList = JXSpellsKnownAddSpell(spellsList, 4, SPELL_POISON);
		spellsList = JXSpellsKnownAddSpell(spellsList, 4, SPELL_SUMMON_CREATURE_IV);
	}

	return spellsList;
}

// Get the complete list of spells available for the cleric
// - iSpellLevel Spell level to get the spells from (-1 for all levels)
// * Returns the list of spells available for the cleric
struct jx_spells_known JXGetSpellListForCleric(int iSpellLevel = -1)
{
	struct jx_spells_known spellsList = JXSpellsKnownCreateStruct();

	// Level 0
	if ((iSpellLevel == 0) || (iSpellLevel == -1))
	{
		spellsList = JXSpellsKnownAddSpell(spellsList, 0, SPELL_CURE_MINOR_WOUNDS);
		spellsList = JXSpellsKnownAddSpell(spellsList, 0, SPELL_LIGHT);
		spellsList = JXSpellsKnownAddSpell(spellsList, 0, SPELL_RESISTANCE);
		spellsList = JXSpellsKnownAddSpell(spellsList, 0, SPELL_VIRTUE);
		spellsList = JXSpellsKnownAddSpell(spellsList, 0, SPELL_INFLICT_MINOR_WOUNDS);
	}

	// Level 1
	if ((iSpellLevel == 1) || (iSpellLevel == -1))
	{
		spellsList = JXSpellsKnownAddSpell(spellsList, 1, SPELL_BLESS);
		spellsList = JXSpellsKnownAddSpell(spellsList, 1, SPELL_CURE_LIGHT_WOUNDS);
		spellsList = JXSpellsKnownAddSpell(spellsList, 1, SPELL_DOOM);
		spellsList = JXSpellsKnownAddSpell(spellsList, 1, SPELL_ENDURE_ELEMENTS);
		spellsList = JXSpellsKnownAddSpell(spellsList, 1, SPELL_REMOVE_FEAR);
		spellsList = JXSpellsKnownAddSpell(spellsList, 1, SPELL_SANCTUARY);
		spellsList = JXSpellsKnownAddSpell(spellsList, 1, SPELL_CAUSE_FEAR);
		spellsList = JXSpellsKnownAddSpell(spellsList, 1, SPELL_SUMMON_CREATURE_I);
		spellsList = JXSpellsKnownAddSpell(spellsList, 1, 321);	// SPELL_PROTECTION_FROM_ALIGNMENT
		spellsList = JXSpellsKnownAddSpell(spellsList, 1, SPELL_DIVINE_FAVOR);
		spellsList = JXSpellsKnownAddSpell(spellsList, 1, SPELL_ENTROPIC_SHIELD);
		spellsList = JXSpellsKnownAddSpell(spellsList, 1, SPELL_INFLICT_LIGHT_WOUNDS);
		spellsList = JXSpellsKnownAddSpell(spellsList, 1, SPELL_BANE);
		spellsList = JXSpellsKnownAddSpell(spellsList, 1, SPELL_SHIELD_OF_FAITH);
		spellsList = JXSpellsKnownAddSpell(spellsList, 1, SPELL_MAGIC_WEAPON);
		spellsList = JXSpellsKnownAddSpell(spellsList, 1, SPELL_DETECT_UNDEAD);
		spellsList = JXSpellsKnownAddSpell(spellsList, 1, SPELL_LESSER_VIGOR);
	}

	// Level 2
	if ((iSpellLevel == 2) || (iSpellLevel == -1))
	{
		spellsList = JXSpellsKnownAddSpell(spellsList, 2, SPELL_AID);
		spellsList = JXSpellsKnownAddSpell(spellsList, 2, SPELL_BULLS_STRENGTH);
		spellsList = JXSpellsKnownAddSpell(spellsList, 2, SPELL_CURE_MODERATE_WOUNDS);
		spellsList = JXSpellsKnownAddSpell(spellsList, 2, SPELL_DARKNESS);
		spellsList = JXSpellsKnownAddSpell(spellsList, 2, SPELL_BEARS_ENDURANCE);
		spellsList = JXSpellsKnownAddSpell(spellsList, 2, SPELL_HOLD_PERSON);
		spellsList = JXSpellsKnownAddSpell(spellsList, 2, SPELL_LESSER_DISPEL);
		spellsList = JXSpellsKnownAddSpell(spellsList, 2, SPELL_LESSER_RESTORATION);
		spellsList = JXSpellsKnownAddSpell(spellsList, 2, SPELL_REMOVE_PARALYSIS);
		spellsList = JXSpellsKnownAddSpell(spellsList, 2, SPELL_RESIST_ENERGY);
		spellsList = JXSpellsKnownAddSpell(spellsList, 2, SPELL_SILENCE);
		spellsList = JXSpellsKnownAddSpell(spellsList, 2, SPELL_SOUND_BURST);
		spellsList = JXSpellsKnownAddSpell(spellsList, 2, SPELL_SUMMON_CREATURE_II);
		spellsList = JXSpellsKnownAddSpell(spellsList, 2, SPELL_EAGLES_SPLENDOR);
		spellsList = JXSpellsKnownAddSpell(spellsList, 2, SPELL_OWLS_WISDOM);
		spellsList = JXSpellsKnownAddSpell(spellsList, 2, SPELL_FOXS_CUNNING);
		spellsList = JXSpellsKnownAddSpell(spellsList, 2, SPELL_FIND_TRAPS);
		spellsList = JXSpellsKnownAddSpell(spellsList, 2, SPELL_INFLICT_MODERATE_WOUNDS);
		spellsList = JXSpellsKnownAddSpell(spellsList, 2, SPELL_DEATH_KNELL);
		spellsList = JXSpellsKnownAddSpell(spellsList, 2, SPELL_SHIELD_OTHER);
	}

	// Level 3
	if ((iSpellLevel == 3) || (iSpellLevel == -1))
	{
		spellsList = JXSpellsKnownAddSpell(spellsList, 3, SPELL_ANIMATE_DEAD);
		spellsList = JXSpellsKnownAddSpell(spellsList, 3, SPELL_BESTOW_CURSE);
		spellsList = JXSpellsKnownAddSpell(spellsList, 3, SPELL_BLINDNESS_AND_DEAFNESS);
		spellsList = JXSpellsKnownAddSpell(spellsList, 3, SPELL_CONTAGION);
		spellsList = JXSpellsKnownAddSpell(spellsList, 3, SPELL_CURE_SERIOUS_WOUNDS);
		spellsList = JXSpellsKnownAddSpell(spellsList, 3, SPELL_DISPEL_MAGIC);
		spellsList = JXSpellsKnownAddSpell(spellsList, 3, SPELL_INVISIBILITY_PURGE);
		spellsList = JXSpellsKnownAddSpell(spellsList, 3, SPELL_PRAYER);
		spellsList = JXSpellsKnownAddSpell(spellsList, 3, SPELL_PROTECTION_FROM_ENERGY);
		spellsList = JXSpellsKnownAddSpell(spellsList, 3, SPELL_REMOVE_BLINDNESS_AND_DEAFNESS);
		spellsList = JXSpellsKnownAddSpell(spellsList, 3, SPELL_REMOVE_CURSE);
		spellsList = JXSpellsKnownAddSpell(spellsList, 3, SPELL_REMOVE_DISEASE);
		spellsList = JXSpellsKnownAddSpell(spellsList, 3, SPELL_SEARING_LIGHT);
		spellsList = JXSpellsKnownAddSpell(spellsList, 3, SPELL_SUMMON_CREATURE_III);
		spellsList = JXSpellsKnownAddSpell(spellsList, 3, 322);	// SPELL_MAGIC_CIRCLE_AGAINST_ALIGNMENT
		spellsList = JXSpellsKnownAddSpell(spellsList, 3, SPELL_INFLICT_SERIOUS_WOUNDS);
		spellsList = JXSpellsKnownAddSpell(spellsList, 3, SPELL_MAGIC_VESTMENT);
		spellsList = JXSpellsKnownAddSpell(spellsList, 3, SPELL_GLYPH_OF_WARDING);
		spellsList = JXSpellsKnownAddSpell(spellsList, 3, SPELL_BLINDSIGHT);
		spellsList = JXSpellsKnownAddSpell(spellsList, 3, SPELL_WEAPON_OF_IMPACT);
		spellsList = JXSpellsKnownAddSpell(spellsList, 3, SPELL_VIGOR);
		spellsList = JXSpellsKnownAddSpell(spellsList, 3, SPELL_MASS_LESSER_VIGOR);
		spellsList = JXSpellsKnownAddSpell(spellsList, 3, SPELL_VISAGE_OF_THE_DEITY);
		spellsList = JXSpellsKnownAddSpell(spellsList, 3, 1052);	// Mass Aid
	}

	// Level 4
	if ((iSpellLevel == 4) || (iSpellLevel == -1))
	{
		spellsList = JXSpellsKnownAddSpell(spellsList, 4, SPELL_CURE_CRITICAL_WOUNDS);
		spellsList = JXSpellsKnownAddSpell(spellsList, 4, SPELL_DEATH_WARD);
		spellsList = JXSpellsKnownAddSpell(spellsList, 4, SPELL_DISMISSAL);
		spellsList = JXSpellsKnownAddSpell(spellsList, 4, SPELL_DIVINE_POWER);
		spellsList = JXSpellsKnownAddSpell(spellsList, 4, SPELL_FREEDOM_OF_MOVEMENT);
		spellsList = JXSpellsKnownAddSpell(spellsList, 4, SPELL_HAMMER_OF_THE_GODS);
		spellsList = JXSpellsKnownAddSpell(spellsList, 4, SPELL_NEUTRALIZE_POISON);
		spellsList = JXSpellsKnownAddSpell(spellsList, 4, SPELL_POISON);
		spellsList = JXSpellsKnownAddSpell(spellsList, 4, SPELL_RESTORATION);
		spellsList = JXSpellsKnownAddSpell(spellsList, 4, SPELL_SUMMON_CREATURE_IV);
		spellsList = JXSpellsKnownAddSpell(spellsList, 4, SPELL_INFLICT_CRITICAL_WOUNDS);
		spellsList = JXSpellsKnownAddSpell(spellsList, 4, SPELL_GREATER_MAGIC_WEAPON);
		spellsList = JXSpellsKnownAddSpell(spellsList, 4, SPELL_ASSAY_RESISTANCE);
		spellsList = JXSpellsKnownAddSpell(spellsList, 4, SPELL_LEAST_SPELL_MANTLE);
		spellsList = JXSpellsKnownAddSpell(spellsList, 4, SPELL_HYPOTHERMIA);
		spellsList = JXSpellsKnownAddSpell(spellsList, 4, 1054);	// Recitation
	}

	// Level 5
	if ((iSpellLevel == 5) || (iSpellLevel == -1))
	{
		spellsList = JXSpellsKnownAddSpell(spellsList, 5, SPELL_MASS_INFLICT_LIGHT_WOUNDS);
		spellsList = JXSpellsKnownAddSpell(spellsList, 5, SPELL_FLAME_STRIKE);
		spellsList = JXSpellsKnownAddSpell(spellsList, 5, SPELL_MASS_CURE_LIGHT_WOUNDS);
		spellsList = JXSpellsKnownAddSpell(spellsList, 5, SPELL_LESSER_SPELL_MANTLE);
		spellsList = JXSpellsKnownAddSpell(spellsList, 5, SPELL_RAISE_DEAD);
		spellsList = JXSpellsKnownAddSpell(spellsList, 5, SPELL_SLAY_LIVING);
		spellsList = JXSpellsKnownAddSpell(spellsList, 5, SPELL_SPELL_RESISTANCE);
		spellsList = JXSpellsKnownAddSpell(spellsList, 5, SPELL_SUMMON_CREATURE_V);
		spellsList = JXSpellsKnownAddSpell(spellsList, 5, SPELL_TRUE_SEEING);
		spellsList = JXSpellsKnownAddSpell(spellsList, 5, SPELL_BATTLETIDE);
		spellsList = JXSpellsKnownAddSpell(spellsList, 5, SPELL_RIGHTEOUS_MIGHT);
		spellsList = JXSpellsKnownAddSpell(spellsList, 5, SPELL_MASS_CONTAGION);
		spellsList = JXSpellsKnownAddSpell(spellsList, 5, SPELL_WALL_DISPEL_MAGIC);
	}

	// Level 6
	if ((iSpellLevel == 6) || (iSpellLevel == -1))
	{
		spellsList = JXSpellsKnownAddSpell(spellsList, 6, SPELL_BLADE_BARRIER);
		spellsList = JXSpellsKnownAddSpell(spellsList, 6, SPELL_CONTROL_UNDEAD);
		spellsList = JXSpellsKnownAddSpell(spellsList, 6, SPELL_CREATE_UNDEAD);
		spellsList = JXSpellsKnownAddSpell(spellsList, 6, SPELL_GREATER_DISPELLING);
		spellsList = JXSpellsKnownAddSpell(spellsList, 6, SPELL_HARM);
		spellsList = JXSpellsKnownAddSpell(spellsList, 6, SPELL_HEAL);
		spellsList = JXSpellsKnownAddSpell(spellsList, 6, SPELL_SUMMON_CREATURE_VI);
		spellsList = JXSpellsKnownAddSpell(spellsList, 6, SPELL_BANISHMENT);
		spellsList = JXSpellsKnownAddSpell(spellsList, 6, SPELL_PLANAR_ALLY);
		spellsList = JXSpellsKnownAddSpell(spellsList, 6, SPELL_UNDEATH_TO_DEATH);
		spellsList = JXSpellsKnownAddSpell(spellsList, 6, SPELL_STONE_BODY);
		spellsList = JXSpellsKnownAddSpell(spellsList, 6, SPELL_ENERGY_IMMUNITY);
		spellsList = JXSpellsKnownAddSpell(spellsList, 6, SPELL_MASS_CURE_MODERATE_WOUNDS);
		spellsList = JXSpellsKnownAddSpell(spellsList, 6, SPELL_MASS_INFLICT_MODERATE_WOUNDS);
		spellsList = JXSpellsKnownAddSpell(spellsList, 6, SPELL_VIGOROUS_CYCLE);
		spellsList = JXSpellsKnownAddSpell(spellsList, 6, SPELL_MASS_BEAR_ENDURANCE);
		spellsList = JXSpellsKnownAddSpell(spellsList, 6, SPELL_MASS_BULL_STRENGTH);
		spellsList = JXSpellsKnownAddSpell(spellsList, 6, SPELL_MASS_OWL_WISDOM);
	}

	// Level 7
	if ((iSpellLevel == 7) || (iSpellLevel == -1))
	{
		spellsList = JXSpellsKnownAddSpell(spellsList, 7, SPELL_GREATER_RESTORATION);
		spellsList = JXSpellsKnownAddSpell(spellsList, 7, SPELL_RESURRECTION);
		spellsList = JXSpellsKnownAddSpell(spellsList, 7, SPELL_SPELL_MANTLE);
		spellsList = JXSpellsKnownAddSpell(spellsList, 7, SPELL_SUMMON_CREATURE_VII);
		spellsList = JXSpellsKnownAddSpell(spellsList, 7, SPELL_WORD_OF_FAITH);
		spellsList = JXSpellsKnownAddSpell(spellsList, 7, SPELL_DESTRUCTION);
		spellsList = JXSpellsKnownAddSpell(spellsList, 7, SPELL_REGENERATE);
		spellsList = JXSpellsKnownAddSpell(spellsList, 7, 724);	// Ethereal Jaunt
		spellsList = JXSpellsKnownAddSpell(spellsList, 7, SPELL_MASS_CURE_SERIOUS_WOUNDS);
		spellsList = JXSpellsKnownAddSpell(spellsList, 7, SPELL_MASS_INFLICT_SERIOUS_WOUNDS);
	}

	// Level 8
	if ((iSpellLevel == 8) || (iSpellLevel == -1))
	{
		spellsList = JXSpellsKnownAddSpell(spellsList, 8, SPELL_CREATE_GREATER_UNDEAD);
		spellsList = JXSpellsKnownAddSpell(spellsList, 8, SPELL_FIRE_STORM);
		spellsList = JXSpellsKnownAddSpell(spellsList, 8, SPELL_HOLY_AURA);
		spellsList = JXSpellsKnownAddSpell(spellsList, 8, SPELL_SUMMON_CREATURE_VIII);
		spellsList = JXSpellsKnownAddSpell(spellsList, 8, SPELL_SUNBEAM);
		spellsList = JXSpellsKnownAddSpell(spellsList, 8, SPELL_UNHOLY_AURA);
		spellsList = JXSpellsKnownAddSpell(spellsList, 8, 323);	// SPELL_AURA_VERSUS_ALIGNMENT
		spellsList = JXSpellsKnownAddSpell(spellsList, 8, SPELL_EARTHQUAKE);
		spellsList = JXSpellsKnownAddSpell(spellsList, 8, SPELL_MASS_CURE_CRITICAL_WOUNDS);
		spellsList = JXSpellsKnownAddSpell(spellsList, 8, SPELL_MASS_INFLICT_CRITICAL_WOUNDS);
		spellsList = JXSpellsKnownAddSpell(spellsList, 8, SPELL_MASS_DEATH_WARD);
		spellsList = JXSpellsKnownAddSpell(spellsList, 8, SPELL_GREATER_WALL_DISPEL_MAGIC);
	}

	// Level 9
	if ((iSpellLevel == 9) || (iSpellLevel == -1))
	{
		spellsList = JXSpellsKnownAddSpell(spellsList, 9, SPELL_ENERGY_DRAIN);
		spellsList = JXSpellsKnownAddSpell(spellsList, 9, SPELL_GATE);
		spellsList = JXSpellsKnownAddSpell(spellsList, 9, SPELL_IMPLOSION);
		spellsList = JXSpellsKnownAddSpell(spellsList, 9, SPELL_MASS_HEAL);
		spellsList = JXSpellsKnownAddSpell(spellsList, 9, SPELL_STORM_OF_VENGEANCE);
		spellsList = JXSpellsKnownAddSpell(spellsList, 9, SPELL_SUMMON_CREATURE_IX);
		spellsList = JXSpellsKnownAddSpell(spellsList, 9, SPELL_ETHEREALNESS);
		spellsList = JXSpellsKnownAddSpell(spellsList, 9, SPELL_UNDEATHS_ETERNAL_FOE);
		spellsList = JXSpellsKnownAddSpell(spellsList, 9, SPELL_GREATER_VISAGE_OF_THE_DEITY);
	}

	return spellsList;
}

// Get the complete list of spells available for the druid
// - iSpellLevel Spell level to get the spells from (-1 for all levels)
// * Returns the list of spells available for the druid
struct jx_spells_known JXGetSpellListForDruid(int iSpellLevel = -1)
{
	struct jx_spells_known spellsList = JXSpellsKnownCreateStruct();

	// Level 0
	if ((iSpellLevel == 0) || (iSpellLevel == -1))
	{
		spellsList = JXSpellsKnownAddSpell(spellsList, 0, SPELL_CURE_MINOR_WOUNDS);
		spellsList = JXSpellsKnownAddSpell(spellsList, 0, SPELL_LIGHT);
		spellsList = JXSpellsKnownAddSpell(spellsList, 0, SPELL_RESISTANCE);
		spellsList = JXSpellsKnownAddSpell(spellsList, 0, SPELL_VIRTUE);
		spellsList = JXSpellsKnownAddSpell(spellsList, 0, SPELL_FLARE);
	}

	// Level 1
	if ((iSpellLevel == 1) || (iSpellLevel == -1))
	{
		spellsList = JXSpellsKnownAddSpell(spellsList, 1, SPELL_CURE_LIGHT_WOUNDS);
		spellsList = JXSpellsKnownAddSpell(spellsList, 1, SPELL_ENDURE_ELEMENTS);
		spellsList = JXSpellsKnownAddSpell(spellsList, 1, SPELL_ENTANGLE);
		spellsList = JXSpellsKnownAddSpell(spellsList, 1, SPELL_SLEEP);
		spellsList = JXSpellsKnownAddSpell(spellsList, 1, SPELL_SUMMON_CREATURE_I);
		spellsList = JXSpellsKnownAddSpell(spellsList, 1, SPELL_CAMOFLAGE);
		spellsList = JXSpellsKnownAddSpell(spellsList, 1, SPELL_MAGIC_FANG);
		spellsList = JXSpellsKnownAddSpell(spellsList, 1, SPELL_LOW_LIGHT_VISION);
		spellsList = JXSpellsKnownAddSpell(spellsList, 1, SPELL_FOUNDATION_OF_STONE);
	}

	// Level 2
	if ((iSpellLevel == 2) || (iSpellLevel == -1))
	{
		spellsList = JXSpellsKnownAddSpell(spellsList, 2, SPELL_BARKSKIN);
		spellsList = JXSpellsKnownAddSpell(spellsList, 2, SPELL_BULLS_STRENGTH);
		spellsList = JXSpellsKnownAddSpell(spellsList, 2, SPELL_CATS_GRACE);
		spellsList = JXSpellsKnownAddSpell(spellsList, 2, SPELL_BEARS_ENDURANCE);
		spellsList = JXSpellsKnownAddSpell(spellsList, 2, SPELL_GUST_OF_WIND);
		spellsList = JXSpellsKnownAddSpell(spellsList, 2, SPELL_HOLD_ANIMAL);
		spellsList = JXSpellsKnownAddSpell(spellsList, 2, SPELL_LESSER_DISPEL);
		spellsList = JXSpellsKnownAddSpell(spellsList, 2, SPELL_LESSER_RESTORATION);
		spellsList = JXSpellsKnownAddSpell(spellsList, 2, SPELL_RESIST_ENERGY);
		spellsList = JXSpellsKnownAddSpell(spellsList, 2, SPELL_SUMMON_CREATURE_II);
		spellsList = JXSpellsKnownAddSpell(spellsList, 2, SPELL_OWLS_WISDOM);
		spellsList = JXSpellsKnownAddSpell(spellsList, 2, SPELL_MASS_CAMOFLAGE);
		spellsList = JXSpellsKnownAddSpell(spellsList, 2, SPELL_FLAME_WEAPON);
		spellsList = JXSpellsKnownAddSpell(spellsList, 2, SPELL_BODY_OF_THE_SUN);
		spellsList = JXSpellsKnownAddSpell(spellsList, 2, SPELL_CREEPING_COLD);
	}

	// Level 3
	if ((iSpellLevel == 3) || (iSpellLevel == -1))
	{
		spellsList = JXSpellsKnownAddSpell(spellsList, 3, SPELL_CALL_LIGHTNING);
		spellsList = JXSpellsKnownAddSpell(spellsList, 3, SPELL_CONTAGION);
		spellsList = JXSpellsKnownAddSpell(spellsList, 3, SPELL_CURE_MODERATE_WOUNDS);
		spellsList = JXSpellsKnownAddSpell(spellsList, 3, SPELL_DOMINATE_ANIMAL);
		spellsList = JXSpellsKnownAddSpell(spellsList, 3, SPELL_NEUTRALIZE_POISON);
		spellsList = JXSpellsKnownAddSpell(spellsList, 3, SPELL_POISON);
		spellsList = JXSpellsKnownAddSpell(spellsList, 3, SPELL_PROTECTION_FROM_ENERGY);
		spellsList = JXSpellsKnownAddSpell(spellsList, 3, SPELL_REMOVE_DISEASE);
		spellsList = JXSpellsKnownAddSpell(spellsList, 3, SPELL_SUMMON_CREATURE_III);
		spellsList = JXSpellsKnownAddSpell(spellsList, 3, SPELL_QUILLFIRE);
		spellsList = JXSpellsKnownAddSpell(spellsList, 3, SPELL_GREATER_MAGIC_FANG);
		spellsList = JXSpellsKnownAddSpell(spellsList, 3, SPELL_SPIKE_GROWTH);
		spellsList = JXSpellsKnownAddSpell(spellsList, 3, SPELL_INFESTATION_OF_MAGGOTS);
		spellsList = JXSpellsKnownAddSpell(spellsList, 3, SPELL_VINE_MINE);
		spellsList = JXSpellsKnownAddSpell(spellsList, 3, SPELL_BLINDSIGHT);
		spellsList = JXSpellsKnownAddSpell(spellsList, 3, SPELL_SPIDERSKIN);
		spellsList = JXSpellsKnownAddSpell(spellsList, 3, SPELL_JAGGED_TOOTH);
	}

	// Level 4
	if ((iSpellLevel == 4) || (iSpellLevel == -1))
	{
		spellsList = JXSpellsKnownAddSpell(spellsList, 4, SPELL_CURE_SERIOUS_WOUNDS);
		spellsList = JXSpellsKnownAddSpell(spellsList, 4, SPELL_DISPEL_MAGIC);
		spellsList = JXSpellsKnownAddSpell(spellsList, 4, SPELL_FLAME_STRIKE);
		spellsList = JXSpellsKnownAddSpell(spellsList, 4, SPELL_FREEDOM_OF_MOVEMENT);
		spellsList = JXSpellsKnownAddSpell(spellsList, 4, SPELL_HOLD_MONSTER);
		spellsList = JXSpellsKnownAddSpell(spellsList, 4, SPELL_STONESKIN);
		spellsList = JXSpellsKnownAddSpell(spellsList, 4, SPELL_SUMMON_CREATURE_IV);
		spellsList = JXSpellsKnownAddSpell(spellsList, 4, SPELL_ICE_STORM);
		spellsList = JXSpellsKnownAddSpell(spellsList, 4, SPELL_MOON_BOLT);
		spellsList = JXSpellsKnownAddSpell(spellsList, 4, SPELL_GREATER_CREEPING_COLD);
	}

	// Level 5
	if ((iSpellLevel == 5) || (iSpellLevel == -1))
	{
		spellsList = JXSpellsKnownAddSpell(spellsList, 5, SPELL_CURE_CRITICAL_WOUNDS);
		spellsList = JXSpellsKnownAddSpell(spellsList, 5, SPELL_DEATH_WARD);
		spellsList = JXSpellsKnownAddSpell(spellsList, 5, SPELL_RESTORATION);
		spellsList = JXSpellsKnownAddSpell(spellsList, 5, SPELL_SLAY_LIVING);
		spellsList = JXSpellsKnownAddSpell(spellsList, 5, SPELL_RESISTANCE);
		spellsList = JXSpellsKnownAddSpell(spellsList, 5, SPELL_SUMMON_CREATURE_V);
		spellsList = JXSpellsKnownAddSpell(spellsList, 5, SPELL_WALL_OF_FIRE);
		spellsList = JXSpellsKnownAddSpell(spellsList, 5, SPELL_AWAKEN);
		spellsList = JXSpellsKnownAddSpell(spellsList, 5, 438);	// Owl's Insight
		spellsList = JXSpellsKnownAddSpell(spellsList, 5, SPELL_INFERNO);
		spellsList = JXSpellsKnownAddSpell(spellsList, 5, SPELL_REJUVENATION_COCOON);
		spellsList = JXSpellsKnownAddSpell(spellsList, 5, SPELL_CALL_LIGHTNING_STORM);
		spellsList = JXSpellsKnownAddSpell(spellsList, 5, SPELL_HEAL_ANIMAL_COMPANION);
	}

	// Level 6
	if ((iSpellLevel == 6) || (iSpellLevel == -1))
	{
		spellsList = JXSpellsKnownAddSpell(spellsList, 6, SPELL_GREATER_DISPELLING);
		spellsList = JXSpellsKnownAddSpell(spellsList, 6, SPELL_GREATER_STONESKIN);
		spellsList = JXSpellsKnownAddSpell(spellsList, 6, SPELL_MASS_CURE_LIGHT_WOUNDS);
		spellsList = JXSpellsKnownAddSpell(spellsList, 6, SPELL_SUMMON_CREATURE_VI);
		spellsList = JXSpellsKnownAddSpell(spellsList, 6, SPELL_REGENERATE);
		spellsList = JXSpellsKnownAddSpell(spellsList, 6, SPELL_DROWN);
		spellsList = JXSpellsKnownAddSpell(spellsList, 6, SPELL_CRUMBLE);
		spellsList = JXSpellsKnownAddSpell(spellsList, 6, SPELL_STONEHOLD);
		spellsList = JXSpellsKnownAddSpell(spellsList, 6, SPELL_ENERGY_IMMUNITY);
		spellsList = JXSpellsKnownAddSpell(spellsList, 6, SPELL_TORTOISE_SHELL);
		spellsList = JXSpellsKnownAddSpell(spellsList, 6, 1058);	// Extract Water Elemental
	}

	// Level 7
	if ((iSpellLevel == 7) || (iSpellLevel == -1))
	{
		spellsList = JXSpellsKnownAddSpell(spellsList, 7, SPELL_FIRE_STORM);
		spellsList = JXSpellsKnownAddSpell(spellsList, 7, SPELL_HARM);
		spellsList = JXSpellsKnownAddSpell(spellsList, 7, SPELL_HEAL);
		spellsList = JXSpellsKnownAddSpell(spellsList, 7, SPELL_SUMMON_CREATURE_VII);
		spellsList = JXSpellsKnownAddSpell(spellsList, 7, SPELL_SUNBEAM);
		spellsList = JXSpellsKnownAddSpell(spellsList, 7, SPELL_TRUE_SEEING);
		spellsList = JXSpellsKnownAddSpell(spellsList, 7, SPELL_CREEPING_DOOM);
		spellsList = JXSpellsKnownAddSpell(spellsList, 7, SPELL_AURA_OF_VITALITY);
		spellsList = JXSpellsKnownAddSpell(spellsList, 7, SPELL_MASS_CURE_MODERATE_WOUNDS);
		spellsList = JXSpellsKnownAddSpell(spellsList, 7, SPELL_SWAMP_LUNG);
	}

	// Level 8
	if ((iSpellLevel == 8) || (iSpellLevel == -1))
	{
		spellsList = JXSpellsKnownAddSpell(spellsList, 8, SPELL_FINGER_OF_DEATH);
		spellsList = JXSpellsKnownAddSpell(spellsList, 8, SPELL_PREMONITION);
		spellsList = JXSpellsKnownAddSpell(spellsList, 8, SPELL_SUMMON_CREATURE_VIII);
		spellsList = JXSpellsKnownAddSpell(spellsList, 8, SPELL_BOMBARDMENT);
		spellsList = JXSpellsKnownAddSpell(spellsList, 8, SPELL_EARTHQUAKE);
		spellsList = JXSpellsKnownAddSpell(spellsList, 8, SPELL_SUNBURST);
		spellsList = JXSpellsKnownAddSpell(spellsList, 8, SPELL_MASS_CURE_SERIOUS_WOUNDS);
		spellsList = JXSpellsKnownAddSpell(spellsList, 8, SPELL_STORM_AVATAR);
	}

	// Level 9
	if ((iSpellLevel == 9) || (iSpellLevel == -1))
	{
		spellsList = JXSpellsKnownAddSpell(spellsList, 9, SPELL_ELEMENTAL_SWARM);
		spellsList = JXSpellsKnownAddSpell(spellsList, 9, SPELL_SHAPECHANGE);
		spellsList = JXSpellsKnownAddSpell(spellsList, 9, SPELL_STORM_OF_VENGEANCE);
		spellsList = JXSpellsKnownAddSpell(spellsList, 9, SPELL_SUMMON_CREATURE_IX);
		spellsList = JXSpellsKnownAddSpell(spellsList, 9, SPELL_MASS_CURE_CRITICAL_WOUNDS);
		spellsList = JXSpellsKnownAddSpell(spellsList, 9, SPELL_NATURE_AVATAR);
		spellsList = JXSpellsKnownAddSpell(spellsList, 9, SPELL_MASS_DROWN);
		spellsList = JXSpellsKnownAddSpell(spellsList, 9, SPELL_GLACIAL_WRATH);
	}

	return spellsList;
}

// Get the complete list of spells available for the paladin
// - iSpellLevel Spell level to get the spells from (-1 for all levels)
// * Returns the list of spells available for the paladin
struct jx_spells_known JXGetSpellListForPaladin(int iSpellLevel = -1)
{
	struct jx_spells_known spellsList = JXSpellsKnownCreateStruct();

	// Level 1
	if ((iSpellLevel == 1) || (iSpellLevel == -1))
	{
		spellsList = JXSpellsKnownAddSpell(spellsList, 1, SPELL_RESISTANCE);
		spellsList = JXSpellsKnownAddSpell(spellsList, 1, SPELL_VIRTUE);
		spellsList = JXSpellsKnownAddSpell(spellsList, 1, SPELL_CURE_LIGHT_WOUNDS);
		spellsList = JXSpellsKnownAddSpell(spellsList, 1, SPELL_ENDURE_ELEMENTS);
		spellsList = JXSpellsKnownAddSpell(spellsList, 1, SPELL_LESSER_RESTORATION);
		spellsList = JXSpellsKnownAddSpell(spellsList, 1, SPELL_BLESS);
		spellsList = JXSpellsKnownAddSpell(spellsList, 1, 321);	// SPELL_PROTECTION_FROM_ALIGNMENT
		spellsList = JXSpellsKnownAddSpell(spellsList, 1, SPELL_DIVINE_FAVOR);
		spellsList = JXSpellsKnownAddSpell(spellsList, 1, SPELL_BLESS_WEAPON);
		spellsList = JXSpellsKnownAddSpell(spellsList, 1, SPELL_MAGIC_WEAPON);
		spellsList = JXSpellsKnownAddSpell(spellsList, 1, SPELL_DETECT_UNDEAD);
		spellsList = JXSpellsKnownAddSpell(spellsList, 1, 1053);	// Lionheart
	}

	// Level 2
	if ((iSpellLevel == 2) || (iSpellLevel == -1))
	{
		spellsList = JXSpellsKnownAddSpell(spellsList, 2, SPELL_BULLS_STRENGTH);
		spellsList = JXSpellsKnownAddSpell(spellsList, 2, SPELL_RESIST_ENERGY);
		spellsList = JXSpellsKnownAddSpell(spellsList, 2, SPELL_OWLS_WISDOM);
		spellsList = JXSpellsKnownAddSpell(spellsList, 2, SPELL_AID);
		spellsList = JXSpellsKnownAddSpell(spellsList, 2, SPELL_REMOVE_PARALYSIS);
		spellsList = JXSpellsKnownAddSpell(spellsList, 2, SPELL_EAGLES_SPLENDOR);
		spellsList = JXSpellsKnownAddSpell(spellsList, 2, SPELL_AURAOFGLORY);
		spellsList = JXSpellsKnownAddSpell(spellsList, 2, SPELL_SHIELD_OTHER);
	}

	// Level 3
	if ((iSpellLevel == 3) || (iSpellLevel == -1))
	{
		spellsList = JXSpellsKnownAddSpell(spellsList, 3, SPELL_CURE_MODERATE_WOUNDS);
		spellsList = JXSpellsKnownAddSpell(spellsList, 3, SPELL_DISPEL_MAGIC);
		spellsList = JXSpellsKnownAddSpell(spellsList, 3, SPELL_PRAYER);
		spellsList = JXSpellsKnownAddSpell(spellsList, 3, SPELL_REMOVE_BLINDNESS_AND_DEAFNESS);
		spellsList = JXSpellsKnownAddSpell(spellsList, 3, SPELL_REMOVE_CURSE);
		spellsList = JXSpellsKnownAddSpell(spellsList, 3, 322);	// SPELL_MAGIC_CIRCLE_AGAINST_ALIGNMENT
		spellsList = JXSpellsKnownAddSpell(spellsList, 3, SPELL_GREATER_MAGIC_WEAPON);
	}

	// Level 4
	if ((iSpellLevel == 4) || (iSpellLevel == -1))
	{
		spellsList = JXSpellsKnownAddSpell(spellsList, 4, SPELL_NEUTRALIZE_POISON);
		spellsList = JXSpellsKnownAddSpell(spellsList, 4, SPELL_CURE_SERIOUS_WOUNDS);
		spellsList = JXSpellsKnownAddSpell(spellsList, 4, SPELL_FREEDOM_OF_MOVEMENT);
		spellsList = JXSpellsKnownAddSpell(spellsList, 4, SPELL_DEATH_WARD);
		spellsList = JXSpellsKnownAddSpell(spellsList, 4, SPELL_RESTORATION);
		spellsList = JXSpellsKnownAddSpell(spellsList, 4, SPELL_HOLY_SWORD);
	}

	return spellsList;
}

// Get the complete list of spells available for the ranger
// - iSpellLevel Spell level to get the spells from (-1 for all levels)
// * Returns the list of spells available for the ranger
struct jx_spells_known JXGetSpellListForRanger(int iSpellLevel = -1)
{
	struct jx_spells_known spellsList = JXSpellsKnownCreateStruct();

	// Level 1
	if ((iSpellLevel == 1) || (iSpellLevel == -1))
	{
		spellsList = JXSpellsKnownAddSpell(spellsList, 1, SPELL_CURE_LIGHT_WOUNDS);
		spellsList = JXSpellsKnownAddSpell(spellsList, 1, SPELL_RESIST_ENERGY);
		spellsList = JXSpellsKnownAddSpell(spellsList, 1, SPELL_ENTANGLE);
		spellsList = JXSpellsKnownAddSpell(spellsList, 1, SPELL_SUMMON_CREATURE_I);
		spellsList = JXSpellsKnownAddSpell(spellsList, 1, SPELL_CAMOFLAGE);
		spellsList = JXSpellsKnownAddSpell(spellsList, 1, SPELL_MAGIC_FANG);
		spellsList = JXSpellsKnownAddSpell(spellsList, 1, SPELL_CURE_LIGHT_WOUNDS);
		spellsList = JXSpellsKnownAddSpell(spellsList, 1, SPELL_LOW_LIGHT_VISION);
	}

	// Level 2
	if ((iSpellLevel == 2) || (iSpellLevel == -1))
	{
		spellsList = JXSpellsKnownAddSpell(spellsList, 2, SPELL_OWLS_WISDOM);
		spellsList = JXSpellsKnownAddSpell(spellsList, 2, SPELL_SLEEP);
		spellsList = JXSpellsKnownAddSpell(spellsList, 2, SPELL_BARKSKIN);
		spellsList = JXSpellsKnownAddSpell(spellsList, 2, SPELL_CATS_GRACE);
		spellsList = JXSpellsKnownAddSpell(spellsList, 2, SPELL_BEARS_ENDURANCE);
		spellsList = JXSpellsKnownAddSpell(spellsList, 2, SPELL_HOLD_ANIMAL);
		spellsList = JXSpellsKnownAddSpell(spellsList, 2, SPELL_SUMMON_CREATURE_II);
		spellsList = JXSpellsKnownAddSpell(spellsList, 2, SPELL_MASS_CAMOFLAGE);
		spellsList = JXSpellsKnownAddSpell(spellsList, 2, SPELL_PROTECTION_FROM_ENERGY);
		spellsList = JXSpellsKnownAddSpell(spellsList, 2, SPELL_SPIKE_GROWTH);
		spellsList = JXSpellsKnownAddSpell(spellsList, 2, SPELL_JAGGED_TOOTH);
		spellsList = JXSpellsKnownAddSpell(spellsList, 2, SPELL_CURSE_OF_BLADES);
	}

	// Level 3
	if ((iSpellLevel == 3) || (iSpellLevel == -1))
	{
		spellsList = JXSpellsKnownAddSpell(spellsList, 3, SPELL_AID);
		spellsList = JXSpellsKnownAddSpell(spellsList, 3, SPELL_CURE_MODERATE_WOUNDS);
		spellsList = JXSpellsKnownAddSpell(spellsList, 3, SPELL_NEUTRALIZE_POISON);
		spellsList = JXSpellsKnownAddSpell(spellsList, 3, SPELL_REMOVE_DISEASE);
		spellsList = JXSpellsKnownAddSpell(spellsList, 3, SPELL_SUMMON_CREATURE_III);
		spellsList = JXSpellsKnownAddSpell(spellsList, 3, SPELL_GREATER_MAGIC_FANG);
		spellsList = JXSpellsKnownAddSpell(spellsList, 3, SPELL_INVISIBILITY_PURGE);
		spellsList = JXSpellsKnownAddSpell(spellsList, 3, SPELL_HEAL_ANIMAL_COMPANION);
		spellsList = JXSpellsKnownAddSpell(spellsList, 3, SPELL_GREATER_CURSE_OF_BLADES);
	}

	// Level 4
	if ((iSpellLevel == 4) || (iSpellLevel == -1))
	{
		spellsList = JXSpellsKnownAddSpell(spellsList, 4, SPELL_CURE_SERIOUS_WOUNDS);
		spellsList = JXSpellsKnownAddSpell(spellsList, 4, SPELL_FREEDOM_OF_MOVEMENT);
		spellsList = JXSpellsKnownAddSpell(spellsList, 4, SPELL_SUMMON_CREATURE_IV);
		spellsList = JXSpellsKnownAddSpell(spellsList, 4, SPELL_POLYMORPH_SELF);
	}

	return spellsList;
}

// Get the complete list of spells available for the warlock
// - iSpellLevel Spell level to get the spells from (-1 for all levels)
// * Returns the list of spells available for the warlock
struct jx_spells_known JXGetSpellListForWarlock(int iSpellLevel = -1)
{
	struct jx_spells_known spellsList = JXSpellsKnownCreateStruct();

	// Level 1
	if ((iSpellLevel == 1) || (iSpellLevel == -1))
	{
		spellsList = JXSpellsKnownAddSpell(spellsList, 1, SPELL_I_BEGUILING_INFLUENCE);
		spellsList = JXSpellsKnownAddSpell(spellsList, 1, SPELL_I_DARK_ONES_OWN_LUCK);
		spellsList = JXSpellsKnownAddSpell(spellsList, 1, SPELL_I_DARKNESS);
		spellsList = JXSpellsKnownAddSpell(spellsList, 1, SPELL_I_DEVILS_SIGHT);
		spellsList = JXSpellsKnownAddSpell(spellsList, 1, SPELL_I_DRAINING_BLAST);
		spellsList = JXSpellsKnownAddSpell(spellsList, 1, SPELL_I_ELDRITCH_SPEAR);
		spellsList = JXSpellsKnownAddSpell(spellsList, 1, SPELL_I_ENTROPIC_WARDING);
		spellsList = JXSpellsKnownAddSpell(spellsList, 1, SPELL_I_FRIGHTFUL_BLAST);
		spellsList = JXSpellsKnownAddSpell(spellsList, 1, SPELL_I_HIDEOUS_BLOW);
		spellsList = JXSpellsKnownAddSpell(spellsList, 1, SPELL_I_LEAPS_AND_BOUNDS);
		spellsList = JXSpellsKnownAddSpell(spellsList, 1, SPELL_I_SEE_THE_UNSEEN);
		spellsList = JXSpellsKnownAddSpell(spellsList, 1, 1059);	// Otherworldly Whispers
	}

	// Level 2
	if ((iSpellLevel == 2) || (iSpellLevel == -1))
	{
		spellsList = JXSpellsKnownAddSpell(spellsList, 2, SPELL_I_BESHADOWED_BLAST);
		spellsList = JXSpellsKnownAddSpell(spellsList, 2, SPELL_I_BRIMSTONE_BLAST);
		spellsList = JXSpellsKnownAddSpell(spellsList, 2, SPELL_I_CHARM);
		spellsList = JXSpellsKnownAddSpell(spellsList, 2, SPELL_I_CURSE_OF_DESPAIR);
		spellsList = JXSpellsKnownAddSpell(spellsList, 2, SPELL_I_THE_DEAD_WALK);
		spellsList = JXSpellsKnownAddSpell(spellsList, 2, SPELL_I_ELDRITCH_CHAIN);
		spellsList = JXSpellsKnownAddSpell(spellsList, 2, SPELL_I_FLEE_THE_SCENE);
		spellsList = JXSpellsKnownAddSpell(spellsList, 2, SPELL_I_HELLRIME_BLAST);
		spellsList = JXSpellsKnownAddSpell(spellsList, 2, SPELL_I_VORACIOUS_DISPELLING);
		spellsList = JXSpellsKnownAddSpell(spellsList, 2, SPELL_I_WALK_UNSEEN);
		spellsList = JXSpellsKnownAddSpell(spellsList, 2, 160);	// Dread Seizure
	}

	// Level 3
	if ((iSpellLevel == 3) || (iSpellLevel == -1))
	{
		spellsList = JXSpellsKnownAddSpell(spellsList, 3, SPELL_I_BEWITCHING_BLAST);
		spellsList = JXSpellsKnownAddSpell(spellsList, 3, SPELL_I_CHILLING_TENTACLES);
		spellsList = JXSpellsKnownAddSpell(spellsList, 3, SPELL_I_DEVOUR_MAGIC);
		spellsList = JXSpellsKnownAddSpell(spellsList, 3, SPELL_I_ELDRITCH_CONE);
		spellsList = JXSpellsKnownAddSpell(spellsList, 3, SPELL_I_NOXIOUS_BLAST);
		spellsList = JXSpellsKnownAddSpell(spellsList, 3, SPELL_I_TENACIOUS_PLAGUE);
		spellsList = JXSpellsKnownAddSpell(spellsList, 3, SPELL_I_VITRIOLIC_BLAST);
		spellsList = JXSpellsKnownAddSpell(spellsList, 3, SPELL_I_WALL_OF_PERILOUS_FLAME);
		spellsList = JXSpellsKnownAddSpell(spellsList, 3, 1130);	// Hindering Blast
	}

	// Level 4
	if ((iSpellLevel == 4) || (iSpellLevel == -1))
	{
		spellsList = JXSpellsKnownAddSpell(spellsList, 4, SPELL_I_DARK_FORESIGHT);
		spellsList = JXSpellsKnownAddSpell(spellsList, 4, SPELL_I_ELDRITCH_DOOM);
		spellsList = JXSpellsKnownAddSpell(spellsList, 4, SPELL_I_RETRIBUTIVE_INVISIBILITY);
		spellsList = JXSpellsKnownAddSpell(spellsList, 4, SPELL_I_UTTERDARK_BLAST);
		spellsList = JXSpellsKnownAddSpell(spellsList, 4, SPELL_I_WORD_OF_CHANGING);
		spellsList = JXSpellsKnownAddSpell(spellsList, 4, 1131);	// Binding Blast
	}

	return spellsList;
}

// Get the complete list of spells available for the wizard
// - iSpellLevel Spell level to get the spells from (-1 for all levels)
// * Returns the list of spells available for the wizard
struct jx_spells_known JXGetSpellListForWizard(int iSpellLevel = -1)
{
	struct jx_spells_known spellsList = JXSpellsKnownCreateStruct();

	// Level 0
	if ((iSpellLevel == 0) || (iSpellLevel == -1))
	{
		spellsList = JXSpellsKnownAddSpell(spellsList, 0, SPELL_DAZE);
		spellsList = JXSpellsKnownAddSpell(spellsList, 0, SPELL_LIGHT);
		spellsList = JXSpellsKnownAddSpell(spellsList, 0, SPELL_RAY_OF_FROST);
		spellsList = JXSpellsKnownAddSpell(spellsList, 0, SPELL_RESISTANCE);
		spellsList = JXSpellsKnownAddSpell(spellsList, 0, SPELL_FLARE);
		spellsList = JXSpellsKnownAddSpell(spellsList, 0, SPELL_ACID_SPLASH);
		spellsList = JXSpellsKnownAddSpell(spellsList, 0, SPELL_TOUCH_OF_FATIGUE);
	}

	// Level 1
	if ((iSpellLevel == 1) || (iSpellLevel == -1))
	{
		spellsList = JXSpellsKnownAddSpell(spellsList, 1, SPELL_BURNING_HANDS);
		spellsList = JXSpellsKnownAddSpell(spellsList, 1, SPELL_CHARM_PERSON);
		spellsList = JXSpellsKnownAddSpell(spellsList, 1, SPELL_COLOR_SPRAY);
		spellsList = JXSpellsKnownAddSpell(spellsList, 1, SPELL_ENDURE_ELEMENTS);
		spellsList = JXSpellsKnownAddSpell(spellsList, 1, SPELL_GREASE);
		spellsList = JXSpellsKnownAddSpell(spellsList, 1, SPELL_IDENTIFY);
		spellsList = JXSpellsKnownAddSpell(spellsList, 1, SPELL_MAGE_ARMOR);
		spellsList = JXSpellsKnownAddSpell(spellsList, 1, SPELL_MAGIC_MISSILE);
		spellsList = JXSpellsKnownAddSpell(spellsList, 1, SPELL_RAY_OF_ENFEEBLEMENT);
		spellsList = JXSpellsKnownAddSpell(spellsList, 1, SPELL_CAUSE_FEAR);
		spellsList = JXSpellsKnownAddSpell(spellsList, 1, SPELL_SLEEP);
		spellsList = JXSpellsKnownAddSpell(spellsList, 1, SPELL_SUMMON_CREATURE_I);
		spellsList = JXSpellsKnownAddSpell(spellsList, 1, 321);	// SPELL_PROTECTION_FROM_ALIGNMENT
		spellsList = JXSpellsKnownAddSpell(spellsList, 1, SPELL_TRUE_STRIKE);
		spellsList = JXSpellsKnownAddSpell(spellsList, 1, SPELL_SHIELD);
		spellsList = JXSpellsKnownAddSpell(spellsList, 1, SPELL_EXPEDITIOUS_RETREAT);
		spellsList = JXSpellsKnownAddSpell(spellsList, 1, SPELL_MAGIC_WEAPON);
		spellsList = JXSpellsKnownAddSpell(spellsList, 1, SPELL_DETECT_UNDEAD);
		spellsList = JXSpellsKnownAddSpell(spellsList, 1, SPELL_ENLARGE_PERSON);
		spellsList = JXSpellsKnownAddSpell(spellsList, 1, SPELL_SHOCKING_GRASP);
		spellsList = JXSpellsKnownAddSpell(spellsList, 1, SPELL_LOW_LIGHT_VISION);
	}

	// Level 2
	if ((iSpellLevel == 2) || (iSpellLevel == -1))
	{
		spellsList = JXSpellsKnownAddSpell(spellsList, 2, SPELL_BLINDNESS_AND_DEAFNESS);
		spellsList = JXSpellsKnownAddSpell(spellsList, 2, SPELL_BULLS_STRENGTH);
		spellsList = JXSpellsKnownAddSpell(spellsList, 2, SPELL_CATS_GRACE);
		spellsList = JXSpellsKnownAddSpell(spellsList, 2, SPELL_DARKNESS);
		spellsList = JXSpellsKnownAddSpell(spellsList, 2, SPELL_BEARS_ENDURANCE);
		spellsList = JXSpellsKnownAddSpell(spellsList, 2, SPELL_GHOUL_TOUCH);
		spellsList = JXSpellsKnownAddSpell(spellsList, 2, SPELL_GUST_OF_WIND);
		spellsList = JXSpellsKnownAddSpell(spellsList, 2, SPELL_INVISIBILITY);
		spellsList = JXSpellsKnownAddSpell(spellsList, 2, SPELL_KNOCK);
		spellsList = JXSpellsKnownAddSpell(spellsList, 2, SPELL_LESSER_DISPEL);
		spellsList = JXSpellsKnownAddSpell(spellsList, 2, SPELL_MELFS_ACID_ARROW);
		spellsList = JXSpellsKnownAddSpell(spellsList, 2, SPELL_GHOSTLY_VISAGE);
		spellsList = JXSpellsKnownAddSpell(spellsList, 2, SPELL_RESIST_ENERGY);
		spellsList = JXSpellsKnownAddSpell(spellsList, 2, SPELL_SEE_INVISIBILITY);
		spellsList = JXSpellsKnownAddSpell(spellsList, 2, SPELL_SUMMON_CREATURE_II);
		spellsList = JXSpellsKnownAddSpell(spellsList, 2, SPELL_WEB);
		spellsList = JXSpellsKnownAddSpell(spellsList, 2, SPELL_EAGLES_SPLENDOR);
		spellsList = JXSpellsKnownAddSpell(spellsList, 2, SPELL_OWLS_WISDOM);
		spellsList = JXSpellsKnownAddSpell(spellsList, 2, SPELL_FOXS_CUNNING);
		spellsList = JXSpellsKnownAddSpell(spellsList, 2, SPELL_BALAGARNSIRONHORN);
		spellsList = JXSpellsKnownAddSpell(spellsList, 2, SPELL_TASHAS_HIDEOUS_LAUGHTER);
		spellsList = JXSpellsKnownAddSpell(spellsList, 2, SPELL_COMBUST);
		spellsList = JXSpellsKnownAddSpell(spellsList, 2, SPELL_DEATH_ARMOR);
		spellsList = JXSpellsKnownAddSpell(spellsList, 2, SPELL_GEDLEES_ELECTRIC_LOOP);
		spellsList = JXSpellsKnownAddSpell(spellsList, 2, SPELL_CLOUD_OF_BEWILDERMENT);
		spellsList = JXSpellsKnownAddSpell(spellsList, 2, SPELL_BLINDSIGHT);
		spellsList = JXSpellsKnownAddSpell(spellsList, 2, SPELL_FALSE_LIFE);
		spellsList = JXSpellsKnownAddSpell(spellsList, 2, SPELL_FIREBURST);
		spellsList = JXSpellsKnownAddSpell(spellsList, 2, SPELL_MIRROR_IMAGE);
		spellsList = JXSpellsKnownAddSpell(spellsList, 2, SPELL_PROTECTION_FROM_ARROWS);
		spellsList = JXSpellsKnownAddSpell(spellsList, 2, SPELL_SCARE);
		spellsList = JXSpellsKnownAddSpell(spellsList, 2, SPELL_CURSE_OF_BLADES);
		spellsList = JXSpellsKnownAddSpell(spellsList, 2, 1051);	// Touch of Idiocy
		spellsList = JXSpellsKnownAddSpell(spellsList, 2, 1055);	// Scorching Ray
	}

	// Level 3
	if ((iSpellLevel == 3) || (iSpellLevel == -1))
	{
		spellsList = JXSpellsKnownAddSpell(spellsList, 3, SPELL_CLAIRAUDIENCE_AND_CLAIRVOYANCE);
		spellsList = JXSpellsKnownAddSpell(spellsList, 3, SPELL_DISPEL_MAGIC);
		spellsList = JXSpellsKnownAddSpell(spellsList, 3, SPELL_FIREBALL);
		spellsList = JXSpellsKnownAddSpell(spellsList, 3, SPELL_FLAME_ARROW);
		spellsList = JXSpellsKnownAddSpell(spellsList, 3, SPELL_HASTE);
		spellsList = JXSpellsKnownAddSpell(spellsList, 3, SPELL_HOLD_PERSON);
		spellsList = JXSpellsKnownAddSpell(spellsList, 3, SPELL_INVISIBILITY_SPHERE);
		spellsList = JXSpellsKnownAddSpell(spellsList, 3, SPELL_LIGHTNING_BOLT);
		spellsList = JXSpellsKnownAddSpell(spellsList, 3, SPELL_PROTECTION_FROM_ENERGY);
		spellsList = JXSpellsKnownAddSpell(spellsList, 3, SPELL_SLOW);
		spellsList = JXSpellsKnownAddSpell(spellsList, 3, SPELL_STINKING_CLOUD);
		spellsList = JXSpellsKnownAddSpell(spellsList, 3, SPELL_SUMMON_CREATURE_III);
		spellsList = JXSpellsKnownAddSpell(spellsList, 3, SPELL_VAMPIRIC_TOUCH);
		spellsList = JXSpellsKnownAddSpell(spellsList, 3, 322);	// Magic Circle vs Alignment
		spellsList = JXSpellsKnownAddSpell(spellsList, 3, SPELL_DISPLACEMENT);
		spellsList = JXSpellsKnownAddSpell(spellsList, 3, SPELL_MESTILS_ACID_BREATH);
		spellsList = JXSpellsKnownAddSpell(spellsList, 3, SPELL_SCINTILLATING_SPHERE);
		spellsList = JXSpellsKnownAddSpell(spellsList, 3, SPELL_KEEN_EDGE);
		spellsList = JXSpellsKnownAddSpell(spellsList, 3, SPELL_GREATER_MAGIC_WEAPON);
		spellsList = JXSpellsKnownAddSpell(spellsList, 3, SPELL_DEEP_SLUMBER);
		spellsList = JXSpellsKnownAddSpell(spellsList, 3, SPELL_HEROISM);
		spellsList = JXSpellsKnownAddSpell(spellsList, 3, SPELL_IMPROVED_MAGE_ARMOR);
		spellsList = JXSpellsKnownAddSpell(spellsList, 3, SPELL_RAGE);
		spellsList = JXSpellsKnownAddSpell(spellsList, 3, SPELL_SPIDERSKIN);
		spellsList = JXSpellsKnownAddSpell(spellsList, 3, SPELL_WEAPON_OF_IMPACT);
		spellsList = JXSpellsKnownAddSpell(spellsList, 3, 1009);	// Power Word, Weaken
		spellsList = JXSpellsKnownAddSpell(spellsList, 3, 1010);	// Power Word, Maladroit
		spellsList = JXSpellsKnownAddSpell(spellsList, 3, SPELL_GREATER_CURSE_OF_BLADES);
	}

	// Level 4
	if ((iSpellLevel == 4) || (iSpellLevel == -1))
	{
		spellsList = JXSpellsKnownAddSpell(spellsList, 4, SPELL_ANIMATE_DEAD);
		spellsList = JXSpellsKnownAddSpell(spellsList, 4, SPELL_BESTOW_CURSE);
		spellsList = JXSpellsKnownAddSpell(spellsList, 4, SPELL_CHARM_MONSTER);
		spellsList = JXSpellsKnownAddSpell(spellsList, 4, SPELL_CONFUSION);
		spellsList = JXSpellsKnownAddSpell(spellsList, 4, SPELL_CONTAGION);
		spellsList = JXSpellsKnownAddSpell(spellsList, 4, SPELL_ELEMENTAL_SHIELD);
		spellsList = JXSpellsKnownAddSpell(spellsList, 4, SPELL_ENERVATION);
		spellsList = JXSpellsKnownAddSpell(spellsList, 4, SPELL_GREATER_INVISIBILITY);
		spellsList = JXSpellsKnownAddSpell(spellsList, 4, SPELL_LESSER_SPELL_BREACH);
		spellsList = JXSpellsKnownAddSpell(spellsList, 4, SPELL_LESSER_GLOBE_OF_INVULNERABILITY);
		spellsList = JXSpellsKnownAddSpell(spellsList, 4, SPELL_PHANTASMAL_KILLER);
		spellsList = JXSpellsKnownAddSpell(spellsList, 4, SPELL_POLYMORPH_SELF);
		spellsList = JXSpellsKnownAddSpell(spellsList, 4, SPELL_REMOVE_CURSE);
		spellsList = JXSpellsKnownAddSpell(spellsList, 4, 159);	// SPELL_SHADOW_CONJURATION
		spellsList = JXSpellsKnownAddSpell(spellsList, 4, SPELL_STONESKIN);
		spellsList = JXSpellsKnownAddSpell(spellsList, 4, SPELL_SUMMON_CREATURE_IV);
		spellsList = JXSpellsKnownAddSpell(spellsList, 4, SPELL_WALL_OF_FIRE);
		spellsList = JXSpellsKnownAddSpell(spellsList, 4, SPELL_ICE_STORM);
		spellsList = JXSpellsKnownAddSpell(spellsList, 4, SPELL_EVARDS_BLACK_TENTACLES);
		spellsList = JXSpellsKnownAddSpell(spellsList, 4, SPELL_ISAACS_LESSER_MISSILE_STORM);
		spellsList = JXSpellsKnownAddSpell(spellsList, 4, SPELL_ASSAY_RESISTANCE);
		spellsList = JXSpellsKnownAddSpell(spellsList, 4, SPELL_CRUSHING_DESPAIR);
		spellsList = JXSpellsKnownAddSpell(spellsList, 4, SPELL_LEAST_SPELL_MANTLE);
		spellsList = JXSpellsKnownAddSpell(spellsList, 4, SPELL_GREATER_RESISTANCE);
		spellsList = JXSpellsKnownAddSpell(spellsList, 4, SPELL_SHOUT);
	}

	// Level 5
	if ((iSpellLevel == 5) || (iSpellLevel == -1))
	{
		spellsList = JXSpellsKnownAddSpell(spellsList, 5, SPELL_CLOUDKILL);
		spellsList = JXSpellsKnownAddSpell(spellsList, 5, SPELL_CONE_OF_COLD);
		spellsList = JXSpellsKnownAddSpell(spellsList, 5, SPELL_DISMISSAL);
		spellsList = JXSpellsKnownAddSpell(spellsList, 5, SPELL_DOMINATE_PERSON);
		spellsList = JXSpellsKnownAddSpell(spellsList, 5, SPELL_FEEBLEMIND);
		spellsList = JXSpellsKnownAddSpell(spellsList, 5, SPELL_HOLD_MONSTER);
		spellsList = JXSpellsKnownAddSpell(spellsList, 5, SPELL_LESSER_MIND_BLANK);
		spellsList = JXSpellsKnownAddSpell(spellsList, 5, SPELL_LESSER_PLANAR_BINDING);
		spellsList = JXSpellsKnownAddSpell(spellsList, 5, SPELL_LESSER_SPELL_MANTLE);
		spellsList = JXSpellsKnownAddSpell(spellsList, 5, SPELL_MIND_FOG);
		spellsList = JXSpellsKnownAddSpell(spellsList, 5, SPELL_SUMMON_CREATURE_V);
		spellsList = JXSpellsKnownAddSpell(spellsList, 5, SPELL_FIREBRAND);
		spellsList = JXSpellsKnownAddSpell(spellsList, 5, SPELL_BIGBYS_INTERPOSING_HAND);
		spellsList = JXSpellsKnownAddSpell(spellsList, 5, SPELL_GREATER_FIREBURST);
		spellsList = JXSpellsKnownAddSpell(spellsList, 5, SPELL_SHROUD_OF_FLAME);
		spellsList = JXSpellsKnownAddSpell(spellsList, 5, SPELL_VITRIOLIC_SPHERE);
		spellsList = JXSpellsKnownAddSpell(spellsList, 5, SPELL_CACOPHONIC_BURST);
		spellsList = JXSpellsKnownAddSpell(spellsList, 5, SPELL_WALL_DISPEL_MAGIC);
		spellsList = JXSpellsKnownAddSpell(spellsList, 5, SPELL_POWER_WORD_DISABLE);
		spellsList = JXSpellsKnownAddSpell(spellsList, 5, 1133);	// Glass Doppelganger
	}

	// Level 6
	if ((iSpellLevel == 6) || (iSpellLevel == -1))
	{
		spellsList = JXSpellsKnownAddSpell(spellsList, 6, SPELL_ACID_FOG);
		spellsList = JXSpellsKnownAddSpell(spellsList, 6, SPELL_CHAIN_LIGHTNING);
		spellsList = JXSpellsKnownAddSpell(spellsList, 6, SPELL_CIRCLE_OF_DEATH);
		spellsList = JXSpellsKnownAddSpell(spellsList, 6, SPELL_CREATE_UNDEAD);
		spellsList = JXSpellsKnownAddSpell(spellsList, 6, SPELL_GLOBE_OF_INVULNERABILITY);
		spellsList = JXSpellsKnownAddSpell(spellsList, 6, SPELL_GREATER_DISPELLING);
		spellsList = JXSpellsKnownAddSpell(spellsList, 6, SPELL_GREATER_SPELL_BREACH);
		spellsList = JXSpellsKnownAddSpell(spellsList, 6, SPELL_GREATER_STONESKIN);
		spellsList = JXSpellsKnownAddSpell(spellsList, 6, SPELL_ETHEREAL_VISAGE);
		spellsList = JXSpellsKnownAddSpell(spellsList, 6, SPELL_PLANAR_BINDING);
		spellsList = JXSpellsKnownAddSpell(spellsList, 6, SPELL_SUMMON_CREATURE_VI);
		spellsList = JXSpellsKnownAddSpell(spellsList, 6, SPELL_TENSERS_TRANSFORMATION);
		spellsList = JXSpellsKnownAddSpell(spellsList, 6, SPELL_TRUE_SEEING);
		spellsList = JXSpellsKnownAddSpell(spellsList, 6, SPELL_LEGEND_LORE);
		spellsList = JXSpellsKnownAddSpell(spellsList, 6, SPELL_ISAACS_GREATER_MISSILE_STORM);
		spellsList = JXSpellsKnownAddSpell(spellsList, 6, SPELL_BIGBYS_FORCEFUL_HAND);
		spellsList = JXSpellsKnownAddSpell(spellsList, 6, SPELL_FLESH_TO_STONE);
		spellsList = JXSpellsKnownAddSpell(spellsList, 6, SPELL_STONE_TO_FLESH);
		spellsList = JXSpellsKnownAddSpell(spellsList, 6, SPELL_UNDEATH_TO_DEATH);
		spellsList = JXSpellsKnownAddSpell(spellsList, 6, SPELL_DISINTEGRATE);
		spellsList = JXSpellsKnownAddSpell(spellsList, 6, SPELL_GREATER_HEROISM);
		spellsList = JXSpellsKnownAddSpell(spellsList, 6, SPELL_STONE_BODY);
		spellsList = JXSpellsKnownAddSpell(spellsList, 6, SPELL_SUPERIOR_RESISTANCE);
		spellsList = JXSpellsKnownAddSpell(spellsList, 6, SPELL_MASS_CONTAGION);
		spellsList = JXSpellsKnownAddSpell(spellsList, 6, SPELL_MASS_BEAR_ENDURANCE);
		spellsList = JXSpellsKnownAddSpell(spellsList, 6, SPELL_MASS_BULL_STRENGTH);
		spellsList = JXSpellsKnownAddSpell(spellsList, 6, SPELL_MASS_OWL_WISDOM);
		spellsList = JXSpellsKnownAddSpell(spellsList, 6, SPELL_MASS_CAT_GRACE);
		spellsList = JXSpellsKnownAddSpell(spellsList, 6, SPELL_MASS_EAGLE_SPLENDOR);
		spellsList = JXSpellsKnownAddSpell(spellsList, 6, SPELL_MASS_FOX_CUNNING);
		spellsList = JXSpellsKnownAddSpell(spellsList, 6, 1058);	// Extract Water Elemental
	}

	// Level 7
	if ((iSpellLevel == 7) || (iSpellLevel == -1))
	{
		spellsList = JXSpellsKnownAddSpell(spellsList, 7, SPELL_CONTROL_UNDEAD);
		spellsList = JXSpellsKnownAddSpell(spellsList, 7, SPELL_DELAYED_BLAST_FIREBALL);
		spellsList = JXSpellsKnownAddSpell(spellsList, 7, SPELL_FINGER_OF_DEATH);
		spellsList = JXSpellsKnownAddSpell(spellsList, 7, 71);	// SPELL_GREATER_SHADOW_CONJURATION
		spellsList = JXSpellsKnownAddSpell(spellsList, 7, SPELL_MORDENKAINENS_SWORD);
		spellsList = JXSpellsKnownAddSpell(spellsList, 7, SPELL_PRISMATIC_SPRAY);
		spellsList = JXSpellsKnownAddSpell(spellsList, 7, SPELL_SHADOW_SHIELD);
		spellsList = JXSpellsKnownAddSpell(spellsList, 7, SPELL_SPELL_MANTLE);
		spellsList = JXSpellsKnownAddSpell(spellsList, 7, SPELL_SUMMON_CREATURE_VII);
		spellsList = JXSpellsKnownAddSpell(spellsList, 7, SPELL_BANISHMENT);
		spellsList = JXSpellsKnownAddSpell(spellsList, 7, SPELL_BIGBYS_GRASPING_HAND);
		spellsList = JXSpellsKnownAddSpell(spellsList, 7, 724);	// Ethereal Jaunt
		spellsList = JXSpellsKnownAddSpell(spellsList, 7, SPELL_ENERGY_IMMUNITY);
		spellsList = JXSpellsKnownAddSpell(spellsList, 7, SPELL_MASS_HOLD_PERSON);
		spellsList = JXSpellsKnownAddSpell(spellsList, 7, 1011);	// Power Word, Blind
		spellsList = JXSpellsKnownAddSpell(spellsList, 7, SPELL_AVASCULATE);
		spellsList = JXSpellsKnownAddSpell(spellsList, 7, SPELL_HISS_OF_SLEEP);
		spellsList = JXSpellsKnownAddSpell(spellsList, 7, 1129);	// Solipsism
	}

	// Level 8
	if ((iSpellLevel == 8) || (iSpellLevel == -1))
	{
		spellsList = JXSpellsKnownAddSpell(spellsList, 8, SPELL_CREATE_GREATER_UNDEAD);
		spellsList = JXSpellsKnownAddSpell(spellsList, 8, SPELL_GREATER_PLANAR_BINDING);
		spellsList = JXSpellsKnownAddSpell(spellsList, 8, SPELL_INCENDIARY_CLOUD);
		spellsList = JXSpellsKnownAddSpell(spellsList, 8, SPELL_MASS_BLINDNESS_AND_DEAFNESS);
		spellsList = JXSpellsKnownAddSpell(spellsList, 8, SPELL_MASS_CHARM);
		spellsList = JXSpellsKnownAddSpell(spellsList, 8, SPELL_MIND_BLANK);
		spellsList = JXSpellsKnownAddSpell(spellsList, 8, SPELL_POWER_WORD_STUN);
		spellsList = JXSpellsKnownAddSpell(spellsList, 8, SPELL_PREMONITION);
		spellsList = JXSpellsKnownAddSpell(spellsList, 8, SPELL_PROTECTION_FROM_SPELLS);
		spellsList = JXSpellsKnownAddSpell(spellsList, 8, SPELL_SUMMON_CREATURE_VIII);
		spellsList = JXSpellsKnownAddSpell(spellsList, 8, SPELL_HORRID_WILTING);
		spellsList = JXSpellsKnownAddSpell(spellsList, 8, SPELL_SUNBURST);
		spellsList = JXSpellsKnownAddSpell(spellsList, 8, SPELL_BIGBYS_CLENCHED_FIST);
		spellsList = JXSpellsKnownAddSpell(spellsList, 8, SPELL_BLACKSTAFF);
		spellsList = JXSpellsKnownAddSpell(spellsList, 8, SPELL_IRON_BODY);
		spellsList = JXSpellsKnownAddSpell(spellsList, 8, SPELL_POLAR_RAY);
		spellsList = JXSpellsKnownAddSpell(spellsList, 8, 1012);	// Power Word, Petrify
		spellsList = JXSpellsKnownAddSpell(spellsList, 8, SPELL_GREATER_WALL_DISPEL_MAGIC);
		spellsList = JXSpellsKnownAddSpell(spellsList, 8, SPELL_GREATER_SHOUT);
	}

	// Level 9
	if ((iSpellLevel == 9) || (iSpellLevel == -1))
	{
		spellsList = JXSpellsKnownAddSpell(spellsList, 9, SPELL_DOMINATE_MONSTER);
		spellsList = JXSpellsKnownAddSpell(spellsList, 9, SPELL_ENERGY_DRAIN);
		spellsList = JXSpellsKnownAddSpell(spellsList, 9, SPELL_GATE);
		spellsList = JXSpellsKnownAddSpell(spellsList, 9, SPELL_GREATER_SPELL_MANTLE);
		spellsList = JXSpellsKnownAddSpell(spellsList, 9, SPELL_METEOR_SWARM);
		spellsList = JXSpellsKnownAddSpell(spellsList, 9, SPELL_MORDENKAINENS_DISJUNCTION);
		spellsList = JXSpellsKnownAddSpell(spellsList, 9, SPELL_POWER_WORD_KILL);
		spellsList = JXSpellsKnownAddSpell(spellsList, 9, 158);	// SPELL_SHADE
		spellsList = JXSpellsKnownAddSpell(spellsList, 9, SPELL_SHAPECHANGE);
		spellsList = JXSpellsKnownAddSpell(spellsList, 9, SPELL_SUMMON_CREATURE_IX);
		spellsList = JXSpellsKnownAddSpell(spellsList, 9, SPELL_WAIL_OF_THE_BANSHEE);
		spellsList = JXSpellsKnownAddSpell(spellsList, 9, SPELL_WEIRD);
		spellsList = JXSpellsKnownAddSpell(spellsList, 9, SPELL_ETHEREALNESS);
		spellsList = JXSpellsKnownAddSpell(spellsList, 9, SPELL_BIGBYS_CRUSHING_HAND);
		spellsList = JXSpellsKnownAddSpell(spellsList, 9, SPELL_MASS_HOLD_MONSTER);
		spellsList = JXSpellsKnownAddSpell(spellsList, 9, SPELL_GLACIAL_WRATH);
		spellsList = JXSpellsKnownAddSpell(spellsList, 9, 1132);	// Shadow Simulacrum
	}

	return spellsList;
}

// Get the spell list for the specified class
// - iClass CLASS_TYPE_* constant
// - iSpellLevel Spell level to get the spells from the spells from (-1 for all levels)
// * Returns the spell list found
struct jx_spells_known JXImplGetSpellList(int iClass, int iSpellLevel = -1)
{
	switch (iClass)
	{
		case CLASS_TYPE_ASSASSIN:
			return JXGetSpellListForAssassin(iSpellLevel);
			break;
		case CLASS_TYPE_BARD:
			return JXGetSpellListForBard();
			break;
		case CLASS_TYPE_BLACKGUARD:
			return JXGetSpellListForBlackguard(iSpellLevel);
			break;
		case CLASS_TYPE_CLERIC:
		case CLASS_TYPE_FAVORED_SOUL:
			return JXGetSpellListForCleric(iSpellLevel);
			break;
		case CLASS_TYPE_DRUID:
		case CLASS_TYPE_SPIRIT_SHAMAN:
			return JXGetSpellListForDruid(iSpellLevel);
			break;
		case CLASS_TYPE_PALADIN:
			return JXGetSpellListForPaladin(iSpellLevel);
			break;
		case CLASS_TYPE_RANGER:
			return JXGetSpellListForRanger(iSpellLevel);
			break;
		case CLASS_TYPE_SORCERER:
		case CLASS_TYPE_WIZARD:
			return JXGetSpellListForWizard(iSpellLevel);
			break;
		case CLASS_TYPE_WARLOCK:
			return JXGetSpellListForWarlock(iSpellLevel);
			break;
	}

	struct jx_spells_known spellsListEmpty;
	return spellsListEmpty;
}