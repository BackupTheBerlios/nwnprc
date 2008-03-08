// Get the level of a spell for the assassin class
// - iSpellId SPELL_* constant
// * Returns the level of the spell or -1 if a assassin can't cast the spell
int JXGetSpellLevelForAssassin(int iSpellId)
{
	switch (iSpellId)
	{
		// Level 1
		case SPELL_SLEEP:								// Enchantment (Compulsion) [Mind-Affecting]
		case SPELL_TRUE_STRIKE:							// Divination		
		case SPELL_DARKNESS:							// Evocation [Darkness]
			return 1;

		// Level 2
		case SPELL_GHOSTLY_VISAGE:						// Illusion, not D&D
		case SPELL_CATS_GRACE:							// Transmutation
		case SPELL_FOXS_CUNNING:						// Transmutation
		case SPELL_INVISIBILITY:						// Illusion (Glamer)
			return 2;

		// Level 3
		case SPELL_DEEP_SLUMBER:						// Enchantment (Compulsion) [Mind-Affecting]
		case SPELL_FALSE_LIFE:							// Necromancy
		case 322://SPELL_MAGIC_CIRCLE_AGAINST_ALIGNMENT:								// vérifier
		case SPELL_MAGIC_CIRCLE_AGAINST_CHAOS:			// Abjuration [Lawful]			// vérifier
		case SPELL_MAGIC_CIRCLE_AGAINST_EVIL:			// Abjuration [Good]			// vérifier
		case SPELL_MAGIC_CIRCLE_AGAINST_GOOD:			// Abjuration [Evil]			// vérifier
		case SPELL_MAGIC_CIRCLE_AGAINST_LAW:			// Abjuration [Chaotic]			// vérifier
			return 3;

		// Level 4
		case SPELL_CLAIRAUDIENCE_AND_CLAIRVOYANCE:		// Divination (Scrying)
		case SPELL_FREEDOM_OF_MOVEMENT:					// Abjuration
		case SPELL_GREATER_INVISIBILITY:				// Illusion (Glamer)
		case SPELL_POISON:								// Necromancy
			return 4;
	}

	return -1;
}

// Get the level of a spell for the bard class
// - iSpellId SPELL_* constant
// * Returns the level of the spell or -1 if a bard can't cast the spell
int JXGetSpellLevelForBard(int iSpellId)
{
	switch (iSpellId)
	{
		// Level 0
		case SPELL_CURE_MINOR_WOUNDS:					// Conjuration (Healing)
		case SPELL_LIGHT:								// Evocation [Light]
		case SPELL_RESISTANCE:							// Abjuration
		case SPELL_DAZE:								// Enchantment (Compulsion) [Mind-Affecting]
		case SPELL_FLARE:								// Evocation [Light]
			return 0;

		// Level 1
		case SPELL_CURE_LIGHT_WOUNDS:					// Conjuration (Healing)
		case SPELL_REMOVE_FEAR:							// Abjuration
		case SPELL_SUMMON_CREATURE_I:					// Conjuration (Summoning) [Air/Chaos/Earth/Evil/Fire/Good/Law/Water]
		case SPELL_LESSER_DISPEL:						// Abjuration, not D&D
		case SPELL_CHARM_PERSON:						// Enchantment (Charm) [Mind-Affecting]
		case SPELL_GREASE:								// Conjuration (Creation)
		case SPELL_IDENTIFY:							// Divination
		case SPELL_SLEEP:								// Enchantment (Compulsion) [Mind-Affecting]
		case SPELL_BALAGARNSIRONHORN:					// Transmutation [Sonic], ref. Magic of Faerûn
		case SPELL_AMPLIFY:								// Transmutation [Sonic], ref. Magic of Faerûn
		case SPELL_EXPEDITIOUS_RETREAT:					// Transmutation
		case SPELL_TASHAS_HIDEOUS_LAUGHTER:				// Enchantment (Compulsion) [Mind-Affecting]
		case SPELL_JOYFUL_NOISE:						// Abjuration, ref. Complete Adventurer
			return 1;

		// Level 2
		case SPELL_BULLS_STRENGTH:						// Transmutation
		case SPELL_CURE_MODERATE_WOUNDS:				// Conjuration (Healing)
		case SPELL_DARKNESS:							// Evocation [Darkness]
		case SPELL_HOLD_PERSON:							// Enchantment (Compulsion) [Mind-Affecting]
		case SPELL_SILENCE:								// Illusion (Glamer)
		case SPELL_SOUND_BURST:							// Evocation [Sonic]
		case SPELL_SUMMON_CREATURE_II:					// Conjuration (Summoning) [Air/Chaos/Earth/Evil/Fire/Good/Law/Water]
		case SPELL_EAGLES_SPLENDOR:						// Transmutation
		case SPELL_OWLS_WISDOM:							// Transmutation
		case SPELL_FOXS_CUNNING:						// Transmutation
		case SPELL_BLINDNESS_AND_DEAFNESS:				// Necromancy
		case SPELL_CATS_GRACE:							// Transmutation
		case SPELL_INVISIBILITY:						// Illusion (Glamer)
		case SPELL_GHOSTLY_VISAGE:						// Illusion, not D&D
		case SPELL_CLOUD_OF_BEWILDERMENT:				// Evocation, ref. Magic of Faerûn & PGtF
		case SPELL_MIRROR_IMAGE:						// Illusion (Figment)
		case SPELL_SCARE:								// Necromancy [Fear, Mind-Affecting]
		case SPELL_HEROISM:								// Enchantment (Compulsion) [Mind-Affecting]
		case SPELL_RAGE:								// Enchantment (Compulsion) [Mind-Affecting]
			return 2;

		// Level 3
		case SPELL_FIND_TRAPS:							// Divination
		case SPELL_CURE_SERIOUS_WOUNDS:					// Conjuration (Healing)
		case SPELL_DISPEL_MAGIC:						// Abjuration
		case SPELL_REMOVE_CURSE:						// Abjuration
		case SPELL_SUMMON_CREATURE_III:					// Conjuration (Summoning) [Air/Chaos/Earth/Evil/Fire/Good/Law/Water]
		case SPELL_WEAPON_OF_IMPACT:					// Transmutation, ref. Magic of Faerûn
		case SPELL_CHARM_MONSTER:						// Enchantment (Charm) [Mind-Affecting]
		case SPELL_CLAIRAUDIENCE_AND_CLAIRVOYANCE:		// Divination (Scrying)
		case SPELL_FEAR:								// Necromancy [Fear, Mind-Affecting]
		case SPELL_HASTE:								// Transmutation
		case SPELL_INVISIBILITY_SPHERE:					// Illusion (Glamer)
		case SPELL_SEE_INVISIBILITY:					// Divination
		case SPELL_SLOW:								// Transmutation
		case SPELL_DISPLACEMENT:						// Illusion (Glamer)
		case SPELL_DEEP_SLUMBER:						// Enchantment (Compulsion) [Mind-Affecting]
		case SPELL_CRUSHING_DESPAIR:					// Enchantment (Compulsion) [Mind-Affecting]
			return 3;

		// Level 4
		case SPELL_CURE_CRITICAL_WOUNDS:				// Conjuration (Healing)
		case SPELL_FREEDOM_OF_MOVEMENT:					// Abjuration
		case SPELL_NEUTRALIZE_POISON:					// Conjuration (Healing)
		case SPELL_SUMMON_CREATURE_IV:					// Conjuration (Summoning) [Air/Chaos/Earth/Evil/Fire/Good/Law/Water]
		case SPELL_DOMINATE_PERSON:						// Enchantment (Compulsion) [Mind-Affecting]
		case SPELL_HOLD_MONSTER:						// Enchantment (Compulsion) [Mind-Affecting]
		case SPELL_GREATER_INVISIBILITY:				// Illusion (Glamer)
		case 159: //SPELL_SHADOW_CONJURATION:			// Illusion (Shadow)
		case SPELL_SHADOW_CONJURATION_SUMMON_SHADOW:	// Illusion (Shadow)
		case SPELL_SHADOW_CONJURATION_DARKNESS:			// Illusion (Shadow)
		case SPELL_SHADOW_CONJURATION_INIVSIBILITY:		// Illusion (Shadow)
		case SPELL_SHADOW_CONJURATION_MAGE_ARMOR:		// Illusion (Shadow)
		case SPELL_SHADOW_CONJURATION_MAGIC_MISSILE:	// Illusion (Shadow)
		case SPELL_WAR_CRY:								// Enchantment (Compulsion) [Sonic, Mind-Affecting], ref. Magic of Faerûn
		case SPELL_LEGEND_LORE:							// Divination
			return 4;

		// Level 5
		case SPELL_MASS_CURE_LIGHT_WOUNDS:				// Conjuration (Healing)
		case SPELL_SUMMON_CREATURE_V:					// Conjuration (Summoning) [Air/Chaos/Earth/Evil/Fire/Good/Law/Water]
		case SPELL_GREATER_DISPELLING:					// Abjuration
		case SPELL_MIND_FOG:							// Enchantment (Compulsion) [Mind-Affecting],
		case SPELL_ETHEREAL_VISAGE:						// Illusion, not D&D
		case SPELL_GREATER_HEROISM:						// Enchantment (Compulsion) [Mind-Affecting]
		case SPELL_SONG_OF_DISCORD:						// Enchantment (Compulsion) [Mind-Affecting, Sonic]
			return 5;

		// Level 6
		case SPELL_SUMMON_CREATURE_VI:					// Conjuration (Summoning) [Air/Chaos/Earth/Evil/Fire/Good/Law/Water]
		case SPELL_ENERGY_IMMUNITY:						// Abjuration, ref. Complete Arcane
		case SPELL_MASS_CURE_MODERATE_WOUNDS:			// Conjuration (Healing)
		case SPELL_ENERGY_IMMUNITY_ACID:				// Abjuration, ref. Complete Arcane
		case SPELL_ENERGY_IMMUNITY_COLD:				// Abjuration, ref. Complete Arcane
		case SPELL_ENERGY_IMMUNITY_ELECTRICAL:			// Abjuration, ref. Complete Arcane
		case SPELL_ENERGY_IMMUNITY_FIRE:				// Abjuration, ref. Complete Arcane
		case SPELL_ENERGY_IMMUNITY_SONIC:				// Abjuration, ref. Complete Arcane
		case SPELL_MASS_CHARM:							// Enchantment (Charm) [Mind-Affecting]
		case SPELL_ICE_STORM:							// Evocation [Cold]
		case SPELL_DIRGE:								// Evocation [Sonic], ref. Magic of Faerûn
		case SPELL_MASS_HOLD_PERSON:					// Enchantment (Compulsion) [Mind-Affecting]
			return 6;
	}

	return -1;
}

// Get the level of a spell for the blackguard class
// - iSpellId SPELL_* constant
// * Returns the level of the spell or -1 if a blackguard can't cast the spell
int JXGetSpellLevelForBlackguard(int iSpellId)
{
	switch (iSpellId)
	{
		// Level 1
		case SPELL_CAUSE_FEAR:							// Necromancy [Fear, Mind-Affecting]
		case SPELL_CURE_LIGHT_WOUNDS:					// Conjuration (Healing)
		case SPELL_DOOM:								// Necromancy [Fear, Mind-Affecting]
		case SPELL_INFLICT_LIGHT_WOUNDS:				// Necromancy
		case SPELL_MAGIC_WEAPON:						// Transmutation
		case SPELL_SUMMON_CREATURE_I:					// Conjuration (Summoning) [Air/Chaos/Earth/Evil/Fire/Good/Law/Water]
			return 1;

		// Level 2
		case SPELL_BULLS_STRENGTH:						// Transmutation
		case SPELL_CURE_MODERATE_WOUNDS:				// Conjuration (Healing)
		case SPELL_DARKNESS:							// Evocation [Darkness]
		case SPELL_DEATH_KNELL:							// Necromancy [Death, Evil]
		case SPELL_EAGLES_SPLENDOR:						// Transmutation
		case SPELL_INFLICT_MODERATE_WOUNDS:				// Necromancy
		case SPELL_SUMMON_CREATURE_II:					// Conjuration (Summoning) [Air/Chaos/Earth/Evil/Fire/Good/Law/Water]
			return 2;

		// Level 3
		case SPELL_CONTAGION:							// Necromancy [Evil]
		case SPELL_CURE_SERIOUS_WOUNDS:					// Conjuration (Healing)
		case SPELL_INFLICT_SERIOUS_WOUNDS:				// Necromancy
		case SPELL_PROTECTION_FROM_ENERGY:				// Abjuration
		case SPELL_SUMMON_CREATURE_III:					// Conjuration (Summoning) [Air/Chaos/Earth/Evil/Fire/Good/Law/Water]
			return 3;

		// Level 4
		case SPELL_CURE_CRITICAL_WOUNDS:				// Conjuration (Healing)
		case SPELL_FREEDOM_OF_MOVEMENT:					// Abjuration
		case SPELL_INFLICT_CRITICAL_WOUNDS:				// Necromancy
		case SPELL_POISON:								// Necromancy
		case SPELL_SUMMON_CREATURE_IV:					// Conjuration (Summoning) [Air/Chaos/Earth/Evil/Fire/Good/Law/Water]
			return 4;
	}

	return -1;
}

// Get the level of a spell for the cleric class
// - iSpellId SPELL_* constant
// * Returns the level of the spell or -1 if a cleric can't cast the spell
int JXGetSpellLevelForCleric(int iSpellId)
{
	switch (iSpellId)
	{
		// Level 0
		case SPELL_CURE_MINOR_WOUNDS:					// Conjuration (Healing)
		case SPELL_LIGHT:								// Evocation [Light]
		case SPELL_RESISTANCE:							// Abjuration
		case SPELL_VIRTUE:								// Transmutation
		case SPELL_INFLICT_MINOR_WOUNDS:				// Necromancy
			return 0;

		// Level 1
		case SPELL_BLESS:								// Enchantment (Compulsion) [Mind-Affecting]
		case SPELL_CURE_LIGHT_WOUNDS:					// Conjuration (Healing)
		case SPELL_DOOM:								// Necromancy [Fear, Mind-Affecting]
		case SPELL_ENDURE_ELEMENTS:						// Abjuration
		case SPELL_PROTECTION_FROM_CHAOS:				// Abjuration [Lawful]												// vérifier
		case SPELL_PROTECTION_FROM_EVIL:				// Abjuration [Good]													// vérifier
		case SPELL_PROTECTION_FROM_GOOD:				// Abjuration [Evil]													// vérifier
		case SPELL_PROTECTION_FROM_LAW:					// Abjuration [Chaotic]												// vérifier
		case SPELL_REMOVE_FEAR:							// Abjuration
		case SPELL_SANCTUARY:							// Abjuration
		case SPELL_CAUSE_FEAR:							// Necromancy [Fear, Mind-Affecting]
		case SPELL_SUMMON_CREATURE_I:					// Conjuration (Summoning) [Air/Chaos/Earth/Evil/Fire/Good/Law/Water]
		case 321:// SPELL_PROTECTION_FROM_ALIGNMENT: // vérifier
		case SPELL_DIVINE_FAVOR:						// Evocation
		case SPELL_ENTROPIC_SHIELD:						// Abjuration
		case SPELL_INFLICT_LIGHT_WOUNDS:				// Necromancy
		case SPELL_BANE:								// Enchantment (Compulsion) [Fear, Mind-Affecting]
		case SPELL_SHIELD_OF_FAITH:						// Abjuration
		case SPELL_MAGIC_WEAPON:						// Transmutation
		case SPELL_DETECT_UNDEAD:						// Divination
			return 1;

		// Level 2
		case SPELL_AID:									// Enchantment (Compulsion) [Mind-Affecting]
		case SPELL_BULLS_STRENGTH:						// Transmutation
		case SPELL_CURE_MODERATE_WOUNDS:				// Conjuration (Healing)
		case SPELL_DARKNESS:							// Evocation [Darkness]
		case SPELL_BEARS_ENDURANCE:						// Transmutation
		case SPELL_HOLD_PERSON:							// Enchantment (Compulsion) [Mind-Affecting]
		case SPELL_LESSER_DISPEL:						// Abjuration, not D&D
		case SPELL_LESSER_RESTORATION:					// Conjuration (Healing)
		case SPELL_REMOVE_PARALYSIS:					// Conjuration (Healing)
		case SPELL_RESIST_ENERGY:						// Abjuration
		case SPELL_SILENCE:								// Illusion (Glamer)
		case SPELL_SOUND_BURST:							// Evocation [Sonic]
		case SPELL_SUMMON_CREATURE_II:					// Conjuration (Summoning) [Air/Chaos/Earth/Evil/Fire/Good/Law/Water]
		case SPELL_EAGLES_SPLENDOR:						// Transmutation
		case SPELL_OWLS_WISDOM:							// Transmutation
		case SPELL_FOXS_CUNNING:						// Transmutation
		case SPELL_FIND_TRAPS:							// Divination
		case SPELL_INFLICT_MODERATE_WOUNDS:				// Necromancy
		case SPELL_DEATH_KNELL:							// Necromancy [Death, Evil]
		case SPELL_SHIELD_OTHER:						// Abjuration
			return 2;

		// Level 3
		case SPELL_ANIMATE_DEAD:						// Necromancy [Evil]
		case SPELL_BESTOW_CURSE:						// Transmutation
		case SPELL_BLINDNESS_AND_DEAFNESS:				// Necromancy
		case SPELL_CONTAGION:							// Necromancy [Evil]
		case SPELL_CURE_SERIOUS_WOUNDS:					// Conjuration (Healing)
		case SPELL_DISPEL_MAGIC:						// Abjuration
		case SPELL_INVISIBILITY_PURGE:					// Evocation
		case SPELL_PRAYER:								// Enchantment (Compulsion) [Mind-Affecting]
		case SPELL_PROTECTION_FROM_ENERGY:				// Abjuration
		case SPELL_REMOVE_BLINDNESS_AND_DEAFNESS:		// Conjuration (Healing)
		case SPELL_REMOVE_CURSE:						// Abjuration
		case SPELL_REMOVE_DISEASE:						// Conjuration (Healing)
		case SPELL_SEARING_LIGHT:						// Evocation
		case SPELL_SUMMON_CREATURE_III:					// Conjuration (Summoning) [Air/Chaos/Earth/Evil/Fire/Good/Law/Water]
		case 322://SPELL_MAGIC_CIRCLE_AGAINST_ALIGNMENT:								// vérifier
		case SPELL_MAGIC_CIRCLE_AGAINST_CHAOS:			// Abjuration [Lawful]			// vérifier
		case SPELL_MAGIC_CIRCLE_AGAINST_EVIL:			// Abjuration [Good]			// vérifier
		case SPELL_MAGIC_CIRCLE_AGAINST_GOOD:			// Abjuration [Evil]			// vérifier
		case SPELL_MAGIC_CIRCLE_AGAINST_LAW:			// Abjuration [Chaotic]			// vérifier
		case SPELL_INFLICT_SERIOUS_WOUNDS:				// Necromancy
		case SPELL_MAGIC_VESTMENT:						// Transmutation
		case SPELL_GLYPH_OF_WARDING:					// Abjuration, ref. Magic of Faerûn
		case 764: // Glyph of Warding triggered, see above
		case SPELL_BLINDSIGHT:							// Transmutation, ref. Magic of Faerûn & PGtF
		case SPELL_WEAPON_OF_IMPACT:					// Transmutation, ref. Magic of Faerûn
			return 3;

		// Level 4
		case SPELL_CURE_CRITICAL_WOUNDS:				// Conjuration (Healing)
		case SPELL_DEATH_WARD:							// Necromancy
		case SPELL_DISMISSAL:							// Abjuration
		case SPELL_DIVINE_POWER:						// Evocation
		case SPELL_FREEDOM_OF_MOVEMENT:					// Abjuration
		case SPELL_HAMMER_OF_THE_GODS:					// Evocation, not D&D
		case SPELL_NEUTRALIZE_POISON:					// Conjuration (Healing)
		case SPELL_POISON:								// Necromancy
		case SPELL_RESTORATION:							// Conjuration (Healing)
		case SPELL_SUMMON_CREATURE_IV:					// Conjuration (Summoning) [Air/Chaos/Earth/Evil/Fire/Good/Law/Water]
		case SPELL_INFLICT_CRITICAL_WOUNDS:				// Necromancy
		case SPELL_GREATER_MAGIC_WEAPON:				// Transmutation
		case SPELL_ASSAY_RESISTANCE:					// Divination, ref. Complete Arcane
		case SPELL_LEAST_SPELL_MANTLE:					// Abjuration, not D&D
			return 4;

		// Level 5
		case SPELL_MASS_INFLICT_LIGHT_WOUNDS:			// Necromancy
		case SPELL_FLAME_STRIKE:						// Evocation [Fire]
		case SPELL_MASS_CURE_LIGHT_WOUNDS:				// Conjuration (Healing)
		case SPELL_LESSER_SPELL_MANTLE:					// Abjuration, not D&D
		case SPELL_RAISE_DEAD:							// Conjuration (Healing)
		case SPELL_SLAY_LIVING:							// Necromancy [Death]
		case SPELL_SPELL_RESISTANCE:					// Abjuration
		case SPELL_SUMMON_CREATURE_V:					// Conjuration (Summoning) [Air/Chaos/Earth/Evil/Fire/Good/Law/Water]
		case SPELL_TRUE_SEEING:							// Divination
		case SPELL_BATTLETIDE:							// Transmutation, ref. Magic of Faerûn & PgtF
		case SPELL_RIGHTEOUS_MIGHT:						// Transmutation
			return 5;

		// Level 6
		case SPELL_BLADE_BARRIER:						// Evocation [Force]
		case SPELL_CONTROL_UNDEAD:						// Necromancy
		case SPELL_CREATE_UNDEAD:						// Necromancy [Evil]
		case SPELL_GREATER_DISPELLING:					// Abjuration
		case SPELL_HARM:								// Necromancy
		case SPELL_HEAL:								// Conjuration (Healing)
		case SPELL_SUMMON_CREATURE_VI:					// Conjuration (Summoning) [Air/Chaos/Earth/Evil/Fire/Good/Law/Water]
		case SPELL_BANISHMENT:							// Abjuration
		case SPELL_PLANAR_ALLY:							// Conjuration (Calling) [Air/Chaos/Earth/Evil/Fire/Good/Law/Water]
		case SPELL_UNDEATH_TO_DEATH:					// Necromancy, ref. Magic of Faerûn
		case SPELL_STONE_BODY:							// Transmutation, ref. PGtF
		case SPELL_ENERGY_IMMUNITY:						// Abjuration, ref. Complete Arcane
		case SPELL_MASS_CURE_MODERATE_WOUNDS:			// Conjuration (Healing)
		case SPELL_MASS_INFLICT_MODERATE_WOUNDS:		// Necromancy
		case SPELL_ENERGY_IMMUNITY_ACID:				// Abjuration, ref. Complete Arcane
		case SPELL_ENERGY_IMMUNITY_COLD:				// Abjuration, ref. Complete Arcane
		case SPELL_ENERGY_IMMUNITY_ELECTRICAL:			// Abjuration, ref. Complete Arcane
		case SPELL_ENERGY_IMMUNITY_FIRE:				// Abjuration, ref. Complete Arcane
		case SPELL_ENERGY_IMMUNITY_SONIC:				// Abjuration, ref. Complete Arcane
		case SPELL_BLADE_BARRIER_WALL:					// Evocation [Force]
		case SPELL_BLADE_BARRIER_SELF:					// Evocation [Force]
			return 6;

		// Level 7
		case SPELL_GREATER_RESTORATION:					// Conjuration (Healing)
		case SPELL_RESURRECTION:						// Conjuration (Healing)
		case SPELL_SPELL_MANTLE:						// Abjuration (Mystra), ref. Magic of Faerûn
		case SPELL_SUMMON_CREATURE_VII:					// Conjuration (Summoning) [Air/Chaos/Earth/Evil/Fire/Good/Law/Water]
		case SPELL_WORD_OF_FAITH:						// Evocation, not D&D
		case SPELL_DESTRUCTION:							// Necromancy [Death]
		case SPELL_REGENERATE:							// Conjuration (Healing)
		case 724:// Ethereal Jaunt						// Transmutation
		case SPELL_MASS_CURE_SERIOUS_WOUNDS:			// Conjuration (Healing)
		case SPELL_MASS_INFLICT_SERIOUS_WOUNDS:			// Necromancy
			return 7;

		// Level 8
		case SPELL_CREATE_GREATER_UNDEAD:				// Necromancy [Evil]
		case SPELL_FIRE_STORM:							// Evocation [Fire]
		case SPELL_HOLY_AURA:							// Abjuration [Good]
		case SPELL_SUMMON_CREATURE_VIII:				// Conjuration (Summoning) [Air/Chaos/Earth/Evil/Fire/Good/Law/Water]
		case SPELL_SUNBEAM:								// Evocation [Light]
		case SPELL_UNHOLY_AURA:							// Abjuration [Evil]
		case 323://SPELL_AURA_VERSUS_ALIGNMENT:			// Abjuration, not D&D		// vérifier
		case SPELL_EARTHQUAKE:							// Evocation [Earth]
		case SPELL_MASS_CURE_CRITICAL_WOUNDS:			// Conjuration (Healing)
		case SPELL_MASS_INFLICT_CRITICAL_WOUNDS:		// Necromancy
			return 8;

		// Level 9
		case SPELL_ENERGY_DRAIN:						// Necromancy
		case SPELL_GATE:								// Conjuration (Creation or Calling)
		case SPELL_IMPLOSION:							// Evocation
		case SPELL_MASS_HEAL:							// Conjuration (Healing)
		case SPELL_STORM_OF_VENGEANCE:					// Conjuration (Summoning)
		case SPELL_SUMMON_CREATURE_IX:					// Conjuration (Summoning) [Air/Chaos/Earth/Evil/Fire/Good/Law/Water]
		case SPELL_ETHEREALNESS:						// Transmutation
		case SPELL_UNDEATHS_ETERNAL_FOE:				// Abjuration [Good], ref. Magic of Faerûn & PGtF
			return 9;
	}

	return -1;
}

// Get the level of a spell for the druid class
// - iSpellId SPELL_* constant
// * Returns the level of the spell or -1 if a druid can't cast the spell
int JXGetSpellLevelForDruid(int iSpellId)
{
	switch (iSpellId)
	{
		// Level 0
		case SPELL_CURE_MINOR_WOUNDS:					// Conjuration (Healing)
		case SPELL_LIGHT:								// Evocation [Light]
		case SPELL_RESISTANCE:							// Abjuration
		case SPELL_VIRTUE:								// Transmutation
		case SPELL_FLARE:								// Evocation [Light]
			return 0;

		// Level 1
		case SPELL_CURE_LIGHT_WOUNDS:					// Conjuration (Healing)
		case SPELL_ENDURE_ELEMENTS:						// Abjuration
		case SPELL_ENTANGLE:							// Transmutation
		case SPELL_SLEEP:								// Enchantment (Compulsion) [Mind-Affecting]
		case SPELL_SUMMON_CREATURE_I:					// Conjuration (Summoning) [Air/Chaos/Earth/Evil/Fire/Good/Law/Water]
		case SPELL_CAMOFLAGE:							// Transmutation, ref. Magic of Faerûn
		case SPELL_MAGIC_FANG:							// Transmutation
		case SPELL_LOW_LIGHT_VISION:					// Transmutation, ref. Magic of Faerûn
		case SPELL_FOUNDATION_OF_STONE:					// Transmutation [Earth], ref. Spell Compendium
			return 1;

		// Level 2
		case SPELL_BARKSKIN:							// Transmutation
		case SPELL_BULLS_STRENGTH:						// Transmutation
		case SPELL_CATS_GRACE:							// Transmutation
		case SPELL_BEARS_ENDURANCE:						// Transmutation
		case SPELL_GUST_OF_WIND:						// Evocation [Air]
		case SPELL_HOLD_ANIMAL:							// Enchantment (Compulsion) [Mind-Affecting]
		case SPELL_LESSER_DISPEL:						// Abjuration, not D&D
		case SPELL_LESSER_RESTORATION:					// Conjuration (Healing)
		case SPELL_RESIST_ENERGY:						// Abjuration
		case SPELL_SUMMON_CREATURE_II:					// Conjuration (Summoning) [Air/Chaos/Earth/Evil/Fire/Good/Law/Water]
		case SPELL_OWLS_WISDOM:							// Transmutation
		case SPELL_MASS_CAMOFLAGE:						// Transmutation, ref. Magic of Faerûn
		case SPELL_FLAME_WEAPON:						// Evocation [Fire], ref. Magic of Faerûn (Flame Dagger)
		case SPELL_BODY_OF_THE_SUN:						// Transmutation [Fire], ref. Complete Divine
			return 2;

		// Level 3
		case SPELL_CALL_LIGHTNING:						// Evocation [Electricity]
		case SPELL_CONTAGION:							// Necromancy [Evil]
		case SPELL_CURE_MODERATE_WOUNDS:				// Conjuration (Healing)
		case SPELL_DOMINATE_ANIMAL:						// Enchantment (Compulsion) [Mind-Affecting]
		case SPELL_NEUTRALIZE_POISON:					// Conjuration (Healing)
		case SPELL_POISON:								// Necromancy
		case SPELL_PROTECTION_FROM_ENERGY:				// Abjuration
		case SPELL_REMOVE_DISEASE:						// Conjuration (Healing)
		case SPELL_SUMMON_CREATURE_III:					// Conjuration (Summoning) [Air/Chaos/Earth/Evil/Fire/Good/Law/Water]
		case SPELL_QUILLFIRE:							// Transmutation, ref. Magic of Faerûn
		case SPELL_GREATER_MAGIC_FANG:					// Transmutation
		case SPELL_SPIKE_GROWTH:						// Transmutation
		case SPELL_INFESTATION_OF_MAGGOTS:				// Necromancy, ref. Magic of Faerûn
		case SPELL_VINE_MINE:							// Conjuration (Creation), ref. Magic of Faerûn
		case SPELL_VINE_MINE_ENTANGLE:					// Conjuration (Creation), ref. Magic of Faerûn
		case SPELL_VINE_MINE_HAMPER_MOVEMENT:			// Conjuration (Creation), ref. Magic of Faerûn
		case SPELL_VINE_MINE_CAMOUFLAGE:				// Conjuration (Creation), ref. Magic of Faerûn
		case SPELL_BLINDSIGHT:							// Transmutation, ref. Magic of Faerûn & PGtF
		case SPELL_SPIDERSKIN:							// Transmutation, ref. Underdark
		case SPELL_JAGGED_TOOTH:						// Transmutation, ref. Savage Species
			return 3;

		// Level 4
		case SPELL_CURE_SERIOUS_WOUNDS:					// Conjuration (Healing)
		case SPELL_DISPEL_MAGIC:						// Abjuration
		case SPELL_FLAME_STRIKE:						// Evocation [Fire]
		case SPELL_FREEDOM_OF_MOVEMENT:					// Abjuration
		case SPELL_HOLD_MONSTER:						// Enchantment (Compulsion) [Mind-Affecting]
		case SPELL_STONESKIN:							// Abjuration
		case SPELL_SUMMON_CREATURE_IV:					// Conjuration (Summoning) [Air/Chaos/Earth/Evil/Fire/Good/Law/Water]
		case SPELL_ICE_STORM:							// Evocation [Cold]
		case SPELL_MOON_BOLT:							// Evocation, ref. Spell Compendium
			return 4;

		// Level 5
		case SPELL_CURE_CRITICAL_WOUNDS:				// Conjuration (Healing)
		case SPELL_DEATH_WARD:							// Necromancy
		case SPELL_RESTORATION:							// Conjuration (Healing)
		case SPELL_SLAY_LIVING:							// Necromancy [Death]
		case SPELL_SPELL_RESISTANCE:					// Abjuration
		case SPELL_SUMMON_CREATURE_V:					// Conjuration (Summoning) [Air/Chaos/Earth/Evil/Fire/Good/Law/Water]
		case SPELL_WALL_OF_FIRE:						// Evocation [Fire]
		case SPELL_AWAKEN:								// Transmutation
		case 438:// Owl's Insight						// Transmutation, ref. Magic of Faerûn
		case SPELL_INFERNO:								// Transmutation [Fire], ref. Magic of Faerûn & PGtF
		case SPELL_REJUVENATION_COCOON:					// Conjuration (Healing), ref. Complete Divine
			return 5;

		// Level 6
		case SPELL_GREATER_DISPELLING:					// Abjuration
		case SPELL_GREATER_STONESKIN:					// Abjuration, not D&D
		case SPELL_MASS_CURE_LIGHT_WOUNDS:				// Conjuration (Healing)
		case SPELL_SUMMON_CREATURE_VI:					// Conjuration (Summoning) [Air/Chaos/Earth/Evil/Fire/Good/Law/Water]
		case SPELL_REGENERATE:							// Conjuration (Healing)
		case SPELL_DROWN:								// Conjuration (Creation) [Water], ref. Magic of Faerûn
		case SPELL_CRUMBLE:								// Transmutation, ref. Magic of Faerûn
		case SPELL_STONEHOLD:							// Conjuration (Creation) [Earth]
		case SPELL_ENERGY_IMMUNITY:						// Abjuration, ref. Complete Arcane
		case SPELL_ENERGY_IMMUNITY_ACID:				// Abjuration, ref. Complete Arcane
		case SPELL_ENERGY_IMMUNITY_COLD:				// Abjuration, ref. Complete Arcane
		case SPELL_ENERGY_IMMUNITY_ELECTRICAL:			// Abjuration, ref. Complete Arcane
		case SPELL_ENERGY_IMMUNITY_FIRE:				// Abjuration, ref. Complete Arcane
		case SPELL_ENERGY_IMMUNITY_SONIC:				// Abjuration, ref. Complete Arcane
		case SPELL_TORTOISE_SHELL:						// Transmutation, ref. Complete Divine (other version at level 3)
			return 6;

		// Level 7
		case SPELL_FIRE_STORM:							// Evocation [Fire]
		case SPELL_HARM:								// Necromancy
		case SPELL_HEAL:								// Conjuration (Healing)
		case SPELL_SUMMON_CREATURE_VII:					// Conjuration (Summoning) [Air/Chaos/Earth/Evil/Fire/Good/Law/Water]
		case SPELL_SUNBEAM:								// Evocation [Light]
		case SPELL_TRUE_SEEING:							// Divination
		case SPELL_CREEPING_DOOM:						// Conjuration (Summoning)
		case SPELL_AURA_OF_VITALITY:					// Transmutation, ref. Magic of Faerûn
		case SPELL_MASS_CURE_MODERATE_WOUNDS:			// Conjuration (Healing)		
		case SPELL_SWAMP_LUNG:							// Conjuration (Creation), ref. Spell Compendium
			return 7;

		// Level 8
		case SPELL_FINGER_OF_DEATH:						// Necromancy [Death]
		case SPELL_PREMONITION:							// Divination, not D&D
		case SPELL_SUMMON_CREATURE_VIII:				// Conjuration (Summoning) [Air/Chaos/Earth/Evil/Fire/Good/Law/Water]
		case SPELL_BOMBARDMENT:							// Conjuration (Creation), ref. Magic of Faerûn & PGtF
		case SPELL_EARTHQUAKE:							// Evocation [Earth]
		case SPELL_SUNBURST:							// Evocation [Light]
		case SPELL_MASS_CURE_SERIOUS_WOUNDS:			// Conjuration (Healing)
		case SPELL_STORM_AVATAR:						// Transmutation, not D&D
			return 8;

		// Level 9
		case SPELL_ELEMENTAL_SWARM:						// Conjuration (Summoning) [Air/Earth/Fire/Water]
		case SPELL_SHAPECHANGE:							// Transmutation
		case SPELL_STORM_OF_VENGEANCE:					// Conjuration (Summoning)
		case SPELL_SUMMON_CREATURE_IX:					// Conjuration (Summoning) [Air/Chaos/Earth/Evil/Fire/Good/Law/Water]
		case 392:// Shapechange in Frost Giant			// Transmutation
		case 393:// Shapechange in Fire Giant			// Transmutation
		case 394:// Shapechange in Horned Devil			// Transmutation
		case 395:// Shapechange in Nightwalker			// Transmutation
		case 396:// Shapechange in Iron Golem			// Transmutation
		case SPELL_MASS_CURE_CRITICAL_WOUNDS:			// Conjuration (Healing)
		case SPELL_NATURE_AVATAR:						// Evocation, ref. Masters of the Wild
			return 9;
	}

	return -1;
}

// Get the level of a spell for the paladin class
// - iSpellId SPELL_* constant
// * Returns the level of the spell or -1 if a paladin can't cast the spell
int JXGetSpellLevelForPaladin(int iSpellId)
{
	switch (iSpellId)
	{
		// Level 1
		case SPELL_RESISTANCE:							// Abjuration
		case SPELL_VIRTUE:								// Transmutation
		case SPELL_CURE_LIGHT_WOUNDS:					// Conjuration (Healing)
		case SPELL_ENDURE_ELEMENTS:						// Abjuration
		case SPELL_LESSER_RESTORATION:					// Conjuration (Healing)
		case SPELL_BLESS:								// Enchantment (Compulsion) [Mind-Affecting]
		case SPELL_PROTECTION_FROM_CHAOS:				// Abjuration [Lawful]												// vérifier
		case SPELL_PROTECTION_FROM_EVIL:				// Abjuration [Good]													// vérifier
		case SPELL_PROTECTION_FROM_GOOD:				// Abjuration [Evil]													// vérifier
		case SPELL_PROTECTION_FROM_LAW:					// Abjuration [Chaotic]												// vérifier
		case 321:// SPELL_PROTECTION_FROM_ALIGNMENT: // vérifier
		case SPELL_DIVINE_FAVOR:						// Evocation
		case SPELL_BLESS_WEAPON:						// Transmutation
		case SPELL_MAGIC_WEAPON:						// Transmutation
		case SPELL_DETECT_UNDEAD:						// Divination
			return 1;

		// Level 2
		case SPELL_BULLS_STRENGTH:						// Transmutation
		case SPELL_RESIST_ENERGY:						// Abjuration
		case SPELL_OWLS_WISDOM:							// Transmutation
		case SPELL_AID:									// Enchantment (Compulsion) [Mind-Affecting]
		case SPELL_REMOVE_PARALYSIS:					// Conjuration (Healing)
		case SPELL_EAGLES_SPLENDOR:						// Transmutation
		case SPELL_AURAOFGLORY:							// Transmutation, ref. Magic of Faerûn
		case SPELL_SHIELD_OTHER:						// Abjuration
			return 2;

		// Level 3
		case SPELL_CURE_MODERATE_WOUNDS:				// Conjuration (Healing)
		case SPELL_DISPEL_MAGIC:						// Abjuration
		case SPELL_PRAYER:								// Enchantment (Compulsion) [Mind-Affecting]
		case SPELL_REMOVE_BLINDNESS_AND_DEAFNESS:		// Conjuration (Healing)
		case SPELL_REMOVE_CURSE:						// Abjuration
		case 322://SPELL_MAGIC_CIRCLE_AGAINST_ALIGNMENT:								// vérifier
		case SPELL_MAGIC_CIRCLE_AGAINST_CHAOS:			// Abjuration [Lawful]			// vérifier
		case SPELL_MAGIC_CIRCLE_AGAINST_EVIL:			// Abjuration [Good]			// vérifier
		case SPELL_MAGIC_CIRCLE_AGAINST_GOOD:			// Abjuration [Evil]			// vérifier
		case SPELL_MAGIC_CIRCLE_AGAINST_LAW:			// Abjuration [Chaotic]			// vérifier
		case SPELL_GREATER_MAGIC_WEAPON:				// Transmutation
			return 3;

		// Level 4
		case SPELL_NEUTRALIZE_POISON:					// Conjuration (Healing)
		case SPELL_CURE_SERIOUS_WOUNDS:					// Conjuration (Healing)
		case SPELL_FREEDOM_OF_MOVEMENT:					// Abjuration
		case SPELL_DEATH_WARD:							// Necromancy
		case SPELL_RESTORATION:							// Conjuration (Healing)
		case SPELL_HOLY_SWORD:							// Evocation [Good]
			return 4;
	}

	return -1;
}

// Get the level of a spell for the ranger class
// - iSpellId SPELL_* constant
// * Returns the level of the spell or -1 if a ranger can't cast the spell
int JXGetSpellLevelForRanger(int iSpellId)
{
	switch (iSpellId)
	{
		// Level 1
		case SPELL_CURE_LIGHT_WOUNDS:					// Conjuration (Healing)
		case SPELL_RESIST_ENERGY:						// Abjuration
		case SPELL_ENTANGLE:							// Transmutation
		case SPELL_SUMMON_CREATURE_I:					// Conjuration (Summoning) [Air/Chaos/Earth/Evil/Fire/Good/Law/Water]
		case SPELL_CAMOFLAGE:							// Transmutation, ref. Magic of Faerûn
		case SPELL_MAGIC_FANG:							// Transmutation
		case SPELL_LOW_LIGHT_VISION:					// Transmutation, ref. Magic of Faerûn
			return 1;

		// Level 2
		case SPELL_OWLS_WISDOM:							// Transmutation
		case SPELL_SLEEP:								// Enchantment (Compulsion) [Mind-Affecting]
		case SPELL_BARKSKIN:							// Transmutation
		case SPELL_CATS_GRACE:							// Transmutation
		case SPELL_BEARS_ENDURANCE:						// Transmutation
		case SPELL_HOLD_ANIMAL:							// Enchantment (Compulsion) [Mind-Affecting]
		case SPELL_SUMMON_CREATURE_II:					// Conjuration (Summoning) [Air/Chaos/Earth/Evil/Fire/Good/Law/Water]
		case SPELL_MASS_CAMOFLAGE:						// Transmutation, ref. Magic of Faerûn
		case SPELL_PROTECTION_FROM_ENERGY:				// Abjuration
		case SPELL_SPIKE_GROWTH:						// Transmutation
		case SPELL_JAGGED_TOOTH:						// Transmutation, ref. Savage Species
			return 2;

		// Level 3
		case SPELL_AID:									// Enchantment (Compulsion) [Mind-Affecting]
		case SPELL_CURE_MODERATE_WOUNDS:				// Conjuration (Healing)
		case SPELL_NEUTRALIZE_POISON:					// Conjuration (Healing)
		case SPELL_REMOVE_DISEASE:						// Conjuration (Healing)
		case SPELL_SUMMON_CREATURE_III:					// Conjuration (Summoning) [Air/Chaos/Earth/Evil/Fire/Good/Law/Water]
		case SPELL_GREATER_MAGIC_FANG:					// Transmutation
		case SPELL_INVISIBILITY_PURGE:					// Evocation
			return 3;

		// Level 4
		case SPELL_CURE_SERIOUS_WOUNDS:					// Conjuration (Healing)
		case SPELL_FREEDOM_OF_MOVEMENT:					// Abjuration
		case SPELL_SUMMON_CREATURE_IV:					// Conjuration (Summoning) [Air/Chaos/Earth/Evil/Fire/Good/Law/Water]
		case SPELL_POLYMORPH_SELF:						// Transmutation                           // vérifier
		case 387:// Polymorph in Sword Spider			// Transmutation
		case 388:// Polymorph in Troll					// Transmutation
		case 389:// Polymorph in Humber Hulk			// Transmutation
		case 390:// Polymorph in Gargoyle				// Transmutation
		case 391:// Polymorph in Mindflayer				// Transmutation
			return 4;
	}

	return -1;
}

// Get the level of a spell for the warlock class
// - iSpellId SPELL_* constant
// * Returns the level of the spell or -1 if a warlock can't cast the spell
int JXGetSpellLevelForWarlock(int iSpellId)
{
	switch (iSpellId)
	{
		// Level 1
		case SPELL_I_BEGUILING_INFLUENCE:
		case SPELL_I_DARK_ONES_OWN_LUCK:
		case SPELL_I_DARKNESS:
		case SPELL_I_DEVILS_SIGHT:
		case SPELL_I_DRAINING_BLAST:
		case SPELL_I_ELDRITCH_SPEAR:
		case SPELL_I_ENTROPIC_WARDING:
		case SPELL_I_FRIGHTFUL_BLAST:
		case SPELL_I_HIDEOUS_BLOW:
		case 931: // Hideous Blow Impact
		case SPELL_I_LEAPS_AND_BOUNDS:
		case SPELL_I_SEE_THE_UNSEEN:
			return 1;

		// Level 2
		case SPELL_I_BESHADOWED_BLAST:
		case SPELL_I_BRIMSTONE_BLAST:
		case SPELL_I_CHARM:
		case SPELL_I_CURSE_OF_DESPAIR:
		case SPELL_I_THE_DEAD_WALK:
		case SPELL_I_ELDRITCH_CHAIN:
		case SPELL_I_FLEE_THE_SCENE:
		case SPELL_I_HELLRIME_BLAST:
		case SPELL_I_VORACIOUS_DISPELLING:
		case SPELL_I_WALK_UNSEEN:
			return 2;

		// Level 3
		case SPELL_I_BEWITCHING_BLAST:
		case SPELL_I_CHILLING_TENTACLES:
		case SPELL_I_DEVOUR_MAGIC:
		case SPELL_I_ELDRITCH_CONE:
		case SPELL_I_NOXIOUS_BLAST:
		case SPELL_I_TENACIOUS_PLAGUE:
		case SPELL_I_VITRIOLIC_BLAST:
		case SPELL_I_WALL_OF_PERILOUS_FLAME:
			return 3;

		// Level 4
		case SPELL_I_DARK_FORESIGHT:
		case SPELL_I_ELDRITCH_DOOM:
		case SPELL_I_RETRIBUTIVE_INVISIBILITY:
		case SPELL_I_UTTERDARK_BLAST:
		case SPELL_I_WORD_OF_CHANGING:
			return 4;
	}

	return -1;
}

// Get the level of a spell for the wizard class
// - iSpellId SPELL_* constant
// * Returns the level of the spell or -1 if a wizard can't cast the spell
int JXGetSpellLevelForWizard(int iSpellId)
{
	switch (iSpellId)
	{
		// Level 0
		case SPELL_DAZE:								// Enchantment (Compulsion) [Mind-Affecting]
		case SPELL_LIGHT:								// Evocation [Light]
		case SPELL_RAY_OF_FROST:						// Evocation [Cold]
		case SPELL_RESISTANCE:							// Abjuration
		case SPELL_FLARE:								// Evocation [Light]
		case SPELL_ACID_SPLASH:							// Conjuration (Creation) [Acid]
			return 0;

		// Level 1
		case SPELL_BURNING_HANDS:						// Evocation [Fire]
		case SPELL_CHARM_PERSON:						// Enchantment (Charm) [Mind-Affecting]
		case SPELL_COLOR_SPRAY:							// Illusion (Pattern) [Mind-Affecting]
		case SPELL_ENDURE_ELEMENTS:						// Abjuration
		case SPELL_GREASE:								// Conjuration (Creation)
		case SPELL_IDENTIFY:							// Divination
		case SPELL_MAGE_ARMOR:							// Conjuration (Creation) [Force]
		case SPELL_MAGIC_MISSILE:						// Evocation [Force]
		case SPELL_PROTECTION_FROM_CHAOS:				// Abjuration [Lawful]												// vérifier
		case SPELL_PROTECTION_FROM_EVIL:				// Abjuration [Good]													// vérifier
		case SPELL_PROTECTION_FROM_GOOD:				// Abjuration [Evil]													// vérifier
		case SPELL_PROTECTION_FROM_LAW:					// Abjuration [Chaotic]												// vérifier
		case SPELL_RAY_OF_ENFEEBLEMENT:					// Necromancy
		case SPELL_CAUSE_FEAR:							// Necromancy [Fear, Mind-Affecting]
		case SPELL_SLEEP:								// Enchantment (Compulsion) [Mind-Affecting]
		case SPELL_SUMMON_CREATURE_I:					// Conjuration (Summoning) [Air/Chaos/Earth/Evil/Fire/Good/Law/Water]
		case 321:// SPELL_PROTECTION_FROM_ALIGNMENT:	// Abjuration                         // vérifier
		case SPELL_TRUE_STRIKE:							// Divination
		case SPELL_SHIELD:								// Abjuration [Force]
		case SPELL_EXPEDITIOUS_RETREAT:					// Transmutation
		case SPELL_MAGIC_WEAPON:						// Transmutation
		case SPELL_DETECT_UNDEAD:						// Divination
		case SPELL_ENLARGE_PERSON:						// Transmutation
		case SPELL_SHOCKING_GRASP:						// Evocation [Electricity]
		case SPELL_LOW_LIGHT_VISION:					// Transmutation, ref. Magic of Faerûn
			return 1;

		// Level 2
		case SPELL_BLINDNESS_AND_DEAFNESS:				// Necromancy
		case SPELL_BULLS_STRENGTH:						// Transmutation
		case SPELL_CATS_GRACE:							// Transmutation
		case SPELL_DARKNESS:							// Evocation [Darkness]
		case SPELL_BEARS_ENDURANCE:						// Transmutation
		case SPELL_GHOUL_TOUCH:							// Necromancy
		case SPELL_GUST_OF_WIND:						// Evocation [Air]
		case SPELL_INVISIBILITY:						// Illusion (Glamer)
		case SPELL_KNOCK:								// Transmutation
		case SPELL_LESSER_DISPEL:						// Abjuration, not D&D
		case SPELL_MELFS_ACID_ARROW:					// Conjuration (Creation) [Acid]
		case SPELL_GHOSTLY_VISAGE:						// Illusion, not D&D
		case SPELL_RESIST_ENERGY:						// Abjuration
		case SPELL_SEE_INVISIBILITY:					// Divination
		case SPELL_SUMMON_CREATURE_II:					// Conjuration (Summoning) [Air/Chaos/Earth/Evil/Fire/Good/Law/Water]
		case SPELL_WEB:									// Conjuration (Creation)
		case SPELL_EAGLES_SPLENDOR:						// Transmutation
		case SPELL_OWLS_WISDOM:							// Transmutation
		case SPELL_FOXS_CUNNING:						// Transmutation
		case SPELL_BALAGARNSIRONHORN:					// Transmutation [Sonic], ref. Magic of Faerûn
		case SPELL_TASHAS_HIDEOUS_LAUGHTER:				// Enchantment (Compulsion) [Mind-Affecting]
		case SPELL_COMBUST:								// Evocation [Fire], ref. Magic of Faerûn
		case SPELL_DEATH_ARMOR:							// Necromancy, ref. Magic of Faerûn
		case SPELL_GEDLEES_ELECTRIC_LOOP:				// Evocation [Electricity], ref. Magic of Faerûn & PGtF
		case SPELL_CLOUD_OF_BEWILDERMENT:				// Evocation, ref. Magic of Faerûn & PGtF
		case SPELL_BLINDSIGHT:							// Transmutation, ref. Magic of Faerûn & PGtF
		case SPELL_FALSE_LIFE:							// Necromancy
		case SPELL_FIREBURST:							// Evocation [Fire]
		case SPELL_MIRROR_IMAGE:						// Illusion (Figment)
		case SPELL_PROTECTION_FROM_ARROWS:				// Abjuration
		case SPELL_SCARE:								// Necromancy [Fear, Mind-Affecting]
			return 2;

		// Level 3
		case SPELL_CLAIRAUDIENCE_AND_CLAIRVOYANCE:		// Divination (Scrying)
		case SPELL_DISPEL_MAGIC:						// Abjuration
		case SPELL_FIREBALL:							// Evocation [Fire]
		case SPELL_FLAME_ARROW:							// Transmutation [Fire]
		case SPELL_HASTE:								// Transmutation
		case SPELL_HOLD_PERSON:							// Enchantment (Compulsion) [Mind-Affecting]
		case SPELL_INVISIBILITY_SPHERE:					// Illusion (Glamer)
		case SPELL_LIGHTNING_BOLT:						// Evocation [Electricity]
		case SPELL_PROTECTION_FROM_ENERGY:				// Abjuration
		case SPELL_SLOW:								// Transmutation
		case SPELL_STINKING_CLOUD:						// Conjuration (Creation)
		case SPELL_SUMMON_CREATURE_III:					// Conjuration (Summoning) [Air/Chaos/Earth/Evil/Fire/Good/Law/Water]
		case SPELL_VAMPIRIC_TOUCH:						// Necromancy
		case 322: //Magic Circle vs Alignment			// Abjuration                               // vérifier
		case SPELL_MAGIC_CIRCLE_AGAINST_CHAOS:			// Abjuration [Lawful]                      // vérifier...
		case SPELL_MAGIC_CIRCLE_AGAINST_EVIL:			// Abjuration [Good]
		case SPELL_MAGIC_CIRCLE_AGAINST_GOOD:			// Abjuration [Evil]
		case SPELL_MAGIC_CIRCLE_AGAINST_LAW:			// Abjuration [Chaotic]
		case SPELL_DISPLACEMENT:						// Illusion (Glamer)
		case SPELL_MESTILS_ACID_BREATH:					// Conjuration (Creation) [Acid], ref. Magic of Faerûn
		case SPELL_SCINTILLATING_SPHERE:				// Evocation [Electricity], ref. Magic of Faerûn
		case SPELL_KEEN_EDGE:							// Transmutation
		case SPELL_GREATER_MAGIC_WEAPON:				// Transmutation
		case SPELL_DEEP_SLUMBER:						// Enchantment (Compulsion) [Mind-Affecting]
		case SPELL_HEROISM:								// Enchantment (Compulsion) [Mind-Affecting]
		case SPELL_IMPROVED_MAGE_ARMOR:					// Conjuration (Creation) [Force], ref. Complete Arcane (Greater Mage Armor)
		case SPELL_RAGE:								// Enchantment (Compulsion) [Mind-Affecting]
		case SPELL_SPIDERSKIN:							// Transmutation, ref. Underdark
		case SPELL_WEAPON_OF_IMPACT:					// Transmutation, ref. Magic of Faerûn
			return 3;

		// Level 4
		case SPELL_ANIMATE_DEAD:						// Necromancy [Evil]
		case SPELL_BESTOW_CURSE:						// Transmutation
		case SPELL_CHARM_MONSTER:						// Enchantment (Charm) [Mind-Affecting]
		case SPELL_CONFUSION:							// Enchantment (Compulsion) [Mind-Affecting]
		case SPELL_CONTAGION:							// Necromancy [Evil]
		case SPELL_ELEMENTAL_SHIELD:					// Evocation [Cold, Fire], D&D name : Fire Shield
		case SPELL_ENERVATION:							// Necromancy
		case SPELL_FEAR:								// Necromancy [Fear, Mind-Affecting]
		case SPELL_GREATER_INVISIBILITY:				// Illusion (Glamer)
		case SPELL_LESSER_SPELL_BREACH:					// Abjuration, not D&D
		case SPELL_LESSER_GLOBE_OF_INVULNERABILITY:		// Abjuration
		case SPELL_PHANTASMAL_KILLER:					// Illusion (Phantasm) [Fear, Mind-Affecting]
		case SPELL_POLYMORPH_SELF:						// Transmutation                           // vérifier
		case SPELL_REMOVE_CURSE:						// Abjuration
		case 159: //SPELL_SHADOW_CONJURATION:			// Illusion (Shadow)
		case SPELL_STONESKIN:							// Abjuration
		case SPELL_SUMMON_CREATURE_IV:					// Conjuration (Summoning) [Air/Chaos/Earth/Evil/Fire/Good/Law/Water]
		case SPELL_WALL_OF_FIRE:						// Evocation [Fire]
		case SPELL_SHADOW_CONJURATION_SUMMON_SHADOW:	// Illusion (Shadow)
		case SPELL_SHADOW_CONJURATION_DARKNESS:			// Illusion (Shadow)
		case SPELL_SHADOW_CONJURATION_INIVSIBILITY:		// Illusion (Shadow)
		case SPELL_SHADOW_CONJURATION_MAGE_ARMOR:		// Illusion (Shadow)
		case SPELL_SHADOW_CONJURATION_MAGIC_MISSILE:	// Illusion (Shadow)
		case SPELL_ICE_STORM:							// Evocation [Cold]
		case SPELL_EVARDS_BLACK_TENTACLES:				// Conjuration (Creation)
		case 387:// Polymorph in Sword Spider			// Transmutation   
		case 388:// Polymorph in Troll					// Transmutation   
		case 389:// Polymorph in Humber Hulk			// Transmutation   
		case 390:// Polymorph in Gargoyle				// Transmutation   
		case 391:// Polymorph in Mindflayer				// Transmutation   
		case SPELL_ISAACS_LESSER_MISSILE_STORM:			// Evocation, not D&D
		case SPELL_ASSAY_RESISTANCE:					// Divination, ref. Complete Arcane
		case SPELL_CRUSHING_DESPAIR:					// Enchantment (Compulsion) [Mind-Affecting]
		case SPELL_LEAST_SPELL_MANTLE:					// Abjuration, not D&D
			return 4;

		// Level 5
		case SPELL_CLOUDKILL:							// Conjuration (Creation)
		case SPELL_CONE_OF_COLD:						// Evocation [Cold]
		case SPELL_DISMISSAL:							// Abjuration
		case SPELL_DOMINATE_PERSON:						// Enchantment (Compulsion) [Mind-Affecting]
		case SPELL_FEEBLEMIND:							// Enchantment (Compulsion) [Mind-Affecting]
		case SPELL_HOLD_MONSTER:						// Enchantment (Compulsion) [Mind-Affecting]
		case SPELL_LESSER_MIND_BLANK:					// Abjuration, not D&D
		case SPELL_LESSER_PLANAR_BINDING:				// Conjuration (Calling) [Air/Chaos/Earth/Evil/Fire/Good/Law/Water]
		case SPELL_LESSER_SPELL_MANTLE:					// Abjuration, not D&D
		case SPELL_MIND_FOG:							// Enchantment (Compulsion) [Mind-Affecting],
		case SPELL_SUMMON_CREATURE_V:					// Conjuration (Summoning) [Air/Chaos/Earth/Evil/Fire/Good/Law/Water]
		case SPELL_FIREBRAND:							// Evocation [Fire], ref. Magic of Faerûn
		case SPELL_BIGBYS_INTERPOSING_HAND:				// Evocation [Force]
		case SPELL_GREATER_FIREBURST:					// Evocation [Fire], ref. Complete Arcane
		case SPELL_SHROUD_OF_FLAME:						// Evocation [Fire], ref. PGtF
		case SPELL_VITRIOLIC_SPHERE:					// Conjuration (Creation) [Acid], ref. Complete Arcane
			return 5;

		// Level 6
		case SPELL_ACID_FOG:							// Conjuration (Creation) [Acid]
		case SPELL_CHAIN_LIGHTNING:						// Evocation [Electricity]
		case SPELL_CIRCLE_OF_DEATH:						// Necromancy [Death]
		case SPELL_CREATE_UNDEAD:						// Necromancy [Evil]
		case SPELL_GLOBE_OF_INVULNERABILITY:			// Abjuration
		case SPELL_GREATER_DISPELLING:					// Abjuration
		case SPELL_GREATER_SPELL_BREACH:				// Abjuration, not D&D
		case SPELL_GREATER_STONESKIN:					// Abjuration, not D&D
		case SPELL_ETHEREAL_VISAGE:						// Illusion, not D&D
		case SPELL_PLANAR_BINDING:						// Conjuration (Calling) [Air/Chaos/Earth/Evil/Fire/Good/Law/Water]
		case SPELL_SUMMON_CREATURE_VI:					// Conjuration (Summoning) [Air/Chaos/Earth/Evil/Fire/Good/Law/Water]
		case SPELL_TENSERS_TRANSFORMATION:				// Transmutation
		case SPELL_TRUE_SEEING:							// Divination
		case SPELL_LEGEND_LORE:							// Divination
		case SPELL_ISAACS_GREATER_MISSILE_STORM:		// Evocation, not D&D
		case SPELL_BIGBYS_FORCEFUL_HAND:				// Evocation [Force]
		case SPELL_FLESH_TO_STONE:						// Transmutation
		case SPELL_STONE_TO_FLESH:						// Transmutation
		case SPELL_UNDEATH_TO_DEATH:					// Necromancy, ref. Magic of Faerûn
		case SPELL_DISINTEGRATE:						// Transmutation
		case SPELL_GREATER_HEROISM:						// Enchantment (Compulsion) [Mind-Affecting]
		case SPELL_STONE_BODY:							// Transmutation, ref. PGtF
			return 6;

		// Level 7
		case SPELL_CONTROL_UNDEAD:						// Necromancy
		case SPELL_DELAYED_BLAST_FIREBALL:				// Evocation [Fire]
		case SPELL_FINGER_OF_DEATH:						// Necromancy [Death]
		case 71://SPELL_GREATER_SHADOW_CONJURATION:		// Illusion (Shadow)
		case SPELL_MORDENKAINENS_SWORD:					// Evocation [Force]
		case SPELL_PRISMATIC_SPRAY:						// Evocation
		case SPELL_SHADOW_SHIELD:						// Illusion
		case SPELL_SPELL_MANTLE:						// Abjuration (Mystra), ref. Magic of Faerûn
		case SPELL_SUMMON_CREATURE_VII:					// Conjuration (Summoning) [Air/Chaos/Earth/Evil/Fire/Good/Law/Water]
		case SPELL_GREATER_SHADOW_CONJURATION_SUMMON_SHADOW:	// Illusion (Shadow)
		case SPELL_GREATER_SHADOW_CONJURATION_ACID_ARROW:		// Illusion (Shadow)
		case SPELL_GREATER_SHADOW_CONJURATION_MIRROR_IMAGE:		// Illusion (Shadow)
		case SPELL_GREATER_SHADOW_CONJURATION_WEB:				// Illusion (Shadow)
		case SPELL_GREATER_SHADOW_CONJURATION_MINOR_GLOBE:		// Illusion (Shadow)
		case SPELL_BANISHMENT:							// Abjuration
		case SPELL_BIGBYS_GRASPING_HAND:				// Evocation [Force]
		case 724:// Ethereal Jaunt						// Transmutation
		case SPELL_ENERGY_IMMUNITY:						// Abjuration, ref. Complete Arcane
		case SPELL_MASS_HOLD_PERSON:					// Enchantment (Compulsion) [Mind-Affecting]
		case SPELL_ENERGY_IMMUNITY_ACID:				// Abjuration, ref. Complete Arcane
		case SPELL_ENERGY_IMMUNITY_COLD:				// Abjuration, ref. Complete Arcane
		case SPELL_ENERGY_IMMUNITY_ELECTRICAL:			// Abjuration, ref. Complete Arcane
		case SPELL_ENERGY_IMMUNITY_FIRE:				// Abjuration, ref. Complete Arcane
		case SPELL_ENERGY_IMMUNITY_SONIC:				// Abjuration, ref. Complete Arcane
			return 7;

		// Level 8
		case SPELL_CREATE_GREATER_UNDEAD:				// Necromancy [Evil]
		case SPELL_GREATER_PLANAR_BINDING:				// Conjuration (Calling) [Air/Chaos/Earth/Evil/Fire/Good/Law/Water]
		case SPELL_INCENDIARY_CLOUD:					// Conjuration (Creation) [Fire]
		case SPELL_MASS_BLINDNESS_AND_DEAFNESS:			// Illusion, not D&D
		case SPELL_MASS_CHARM:							// Enchantment (Charm) [Mind-Affecting]
		case SPELL_MIND_BLANK:							// Abjuration
		case SPELL_POWER_WORD_STUN:						// Enchantment (Compulsion) [Mind-Affecting]
		case SPELL_PREMONITION:							// Divination, not D&D
		case SPELL_PROTECTION_FROM_SPELLS:				// Abjuration
		case SPELL_SUMMON_CREATURE_VIII:				// Conjuration (Summoning) [Air/Chaos/Earth/Evil/Fire/Good/Law/Water]
		case SPELL_HORRID_WILTING:						// Necromancy
		case SPELL_SUNBURST:							// Evocation [Light]
		case SPELL_BIGBYS_CLENCHED_FIST:				// Evocation [Force]
		case SPELL_BLACKSTAFF:							// Transmutation, ref. Magic of Faerûn
		case SPELL_IRON_BODY:							// Transmutation
		case SPELL_POLAR_RAY:							// Evocation [Cold]
			return 8;

		// Level 9
		case SPELL_DOMINATE_MONSTER:					// Enchantment (Compulsion) [Mind-Affecting]
		case SPELL_ENERGY_DRAIN:						// Necromancy
		case SPELL_GATE:								// Conjuration (Creation or Calling)
		case SPELL_GREATER_SPELL_MANTLE:				// Abjuration, not D&D
		case SPELL_METEOR_SWARM:						// Evocation [Fire]
		case SPELL_MORDENKAINENS_DISJUNCTION:			// Abjuration
		case SPELL_POWER_WORD_KILL:						// Enchantment (Compulsion) [Death, Mind-Affecting]
		case 158: //SPELL_SHADES						// Illusion (Shadow)
		case SPELL_SHAPECHANGE:							// Transmutation
		case SPELL_SUMMON_CREATURE_IX:					// Conjuration (Summoning) [Air/Chaos/Earth/Evil/Fire/Good/Law/Water]
		case SPELL_WAIL_OF_THE_BANSHEE:					// Necromancy [Death, Sonic]
		case SPELL_WEIRD:								// Illusion (Phantasm) [Fear, Mind-Affecting]
		case SPELL_SHADES_SUMMON_SHADOW:				// Illusion (Shadow)
		case SPELL_SHADES_CONE_OF_COLD:					// Illusion (Shadow)
		case SPELL_SHADES_FIREBALL:						// Illusion (Shadow)
		case SPELL_SHADES_STONESKIN:					// Illusion (Shadow)
		case SPELL_SHADES_WALL_OF_FIRE:					// Illusion (Shadow)
		case 392:// Shapechange in Frost Giant			// Transmutation
		case 393:// Shapechange in Fire Giant			// Transmutation
		case 394:// Shapechange in Horned Devil			// Transmutation
		case 395:// Shapechange in Nightwalker			// Transmutation
		case 396:// Shapechange in Iron Golem			// Transmutation
		case SPELL_ETHEREALNESS:						// Transmutation
		case SPELL_BIGBYS_CRUSHING_HAND:				// Evocation [Force]
		case SPELL_MASS_HOLD_MONSTER:					// Enchantment (Compulsion) [Mind-Affecting]
		case SPELL_SHADES_TARGET_CASTER:				// Illusion (Shadow)
		case SPELL_SHADES_TARGET_CREATURE:				// Illusion (Shadow)
		case SPELL_SHADES_TARGET_GROUND:				// Illusion (Shadow)
		case SPELL_METEOR_SWARM_TARGET_SELF:			// Evocation [Fire]
		case SPELL_METEOR_SWARM_TARGET_LOCATION:		// Evocation [Fire]
		case SPELL_METEOR_SWARM_TARGET_CREATURE:		// Evocation [Fire]
			return 9;
	}

	return -1;
}

// Get the level of a spell for the specified class
// - iSpellId SPELL_* constant
// - iClass CLASS_TYPE_* constant
// * Returns the level of the spell or -1 if the class can't cast the spell
int JXSpbkGetBaseSpellLevel(int iSpellId, int iClass)
{
	switch (iClass)
	{
		case CLASS_TYPE_ASSASSIN:
			return JXGetSpellLevelForAssassin(iSpellId);
			break;
		case CLASS_TYPE_BARD:
			return JXGetSpellLevelForBard(iSpellId);
			break;
		case CLASS_TYPE_BLACKGUARD:
			return JXGetSpellLevelForBlackguard(iSpellId);
			break;
		case CLASS_TYPE_CLERIC:
		case CLASS_TYPE_FAVORED_SOUL:
			return JXGetSpellLevelForCleric(iSpellId);
			break;
		case CLASS_TYPE_DRUID:
		case CLASS_TYPE_SPIRIT_SHAMAN:
			return JXGetSpellLevelForDruid(iSpellId);
			break;
		case CLASS_TYPE_PALADIN:
			return JXGetSpellLevelForPaladin(iSpellId);
			break;
		case CLASS_TYPE_RANGER:
			return JXGetSpellLevelForRanger(iSpellId);
			break;
		case CLASS_TYPE_SORCERER:
		case CLASS_TYPE_WIZARD:
			return JXGetSpellLevelForWizard(iSpellId);
			break;
		case CLASS_TYPE_WARLOCK:
			return JXGetSpellLevelForWarlock(iSpellId);
			break;
	}

	return -1;
}