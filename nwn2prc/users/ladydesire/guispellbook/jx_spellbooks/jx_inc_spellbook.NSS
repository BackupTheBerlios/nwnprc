#include "jx_inc_spbk_process_spkwn"
#include "jx_inc_spbk_process_sprdy"




// Determine if a creature knows the specified spell
// - iSpellId SPELL_* constant to check
// - iClass CLASS_TYPE_* constant
// - oCreature Creature for whom the spell is checked
// * Returns TRUE if the creature knows the spell, else FALSE
int JXGetKnowsSpell(int iSpellId, int iClass = CLASS_TYPE_INVALID, object oCreature = OBJECT_SELF);

// Determine if a creature can cast the specified spell
// - iSpellId SPELL_* constant to check
// - iMetaMagicFeat METAMAGIC_* constant to check
// - iClass CLASS_TYPE_* constant
// - oCreature Creature for whom the spell is checked
// * Returns TRUE if the creature has the spell available, else FALSE
int JXGetIsSpellAvailable(int iSpellId, int iMetaMagicFeat = METAMAGIC_ANY, int iClass = CLASS_TYPE_INVALID, object oCreature = OBJECT_SELF);

// Add a spell into the spellbook of a creature
// - iSpellId SPELL_* constant to check
// - iClass CLASS_TYPE_* constant
// - oCreature Creature for whom the spell is added
void JXLearnSpell(int iSpellId, int iClass, object oCreature = OBJECT_SELF);










// Determine if a creature knows the specified spell
// - iSpellId SPELL_* constant to check
// - iClass CLASS_TYPE_* constant
// - oCreature Creature for whom the spell is checked
// * Returns TRUE if the creature knows the spell, else FALSE
int JXGetKnowsSpell(int iSpellId, int iClass, object oCreature)
{
	struct jx_spells_known spellsKnown;
	if (iClass == CLASS_TYPE_INVALID)
	{
		// Loop through all spellcasting classes
		int iLoopClass;
		int iLoopClassPos;
		for (iLoopClassPos = 0; iLoopClassPos <= 4; iLoopClassPos++)
		{
			iLoopClass = GetClassByPosition(iLoopClassPos, oCreature);
			if (JXGetHasSpellbook(oCreature, iLoopClass))
			{
				spellsKnown = JXRestoreSpellsKnown(oCreature, iLoopClass);
				if (JXSpellsKnownContainsSpell(spellsKnown, iSpellId))
					return TRUE;
			}
		}
		return FALSE;
	}
	else
	{
		spellsKnown = JXRestoreSpellsKnown(oCreature, iClass);
		if (JXSpellsKnownContainsSpell(spellsKnown, iSpellId))
			return TRUE;
		else
			return FALSE;
	}
}

// Determine if a creature can cast the specified spell
// - iSpellId SPELL_* constant to check
// - iMetaMagicFeat METAMAGIC_* constant to check
// - iClass CLASS_TYPE_* constant
// - oCreature Creature for whom the spell is checked
// * Returns TRUE if the creature has the spell available, else FALSE
int JXGetIsSpellAvailable(int iSpellId, int iMetaMagicFeat, int iClass, object oCreature)
{
	struct jx_spells_ready spellsReady;
	struct jx_spell_ready spellReady;

	if (iClass == CLASS_TYPE_INVALID)
	{
		// Loop through all spellcasting classes
		int iLoopClass;
		int iLoopClassPos;
		for (iLoopClassPos = 0; iLoopClassPos <= 4; iLoopClassPos++)
		{
			iLoopClass = GetClassByPosition(iLoopClassPos, oCreature);
			if (JXGetHasSpellbook(oCreature, iLoopClass))
			{
				spellsReady = JXRestoreSpellsReady(oCreature, iClass);
				if (JXSpellsReadyContainsSpell(spellsReady, iSpellId, iMetaMagicFeat))
				{
					int iSpellLevel = JXSpellsReadyFindSpellLevel(spellsReady, iSpellId, iMetaMagicFeat);
					int iSpellSlot = JXSpellsReadyFindSpellSlot(spellsReady, iSpellId, iMetaMagicFeat, iSpellLevel);
					spellReady = JXSpellsReadyGetSpell(spellsReady, iSpellLevel, iSpellSlot);
					if (spellReady.iNbUses)
						return TRUE;
				}
			}
		}
	}
	else
	{
		spellsReady = JXRestoreSpellsReady(oCreature, iClass);
		if (JXSpellsReadyContainsSpell(spellsReady, iSpellId, iMetaMagicFeat))
		{
			int iSpellLevel = JXSpellsReadyFindSpellLevel(spellsReady, iSpellId, iMetaMagicFeat);
			int iSpellSlot = JXSpellsReadyFindSpellSlot(spellsReady, iSpellId, iMetaMagicFeat, iSpellLevel);
			spellReady = JXSpellsReadyGetSpell(spellsReady, iSpellLevel, iSpellSlot);
			if (spellReady.iNbUses)
				return TRUE;
			else
				return FALSE;
		}
	}

	return FALSE;
}

// Add a spell into the spellbook of a creature
// - iSpellId SPELL_* constant to check
// - iClass CLASS_TYPE_* constant
// - oCreature Creature for whom the spell is added
void JXLearnSpell(int iSpellId, int iClass, object oCreature)
{
	// Get the spells known by the creature
	struct jx_spells_known spellsKnown = JXRestoreSpellsKnown(oCreature, iClass);
	// Make sure the spell doesn't already exist in the spellbook
	if (JXSpellsKnownContainsSpell(spellsKnown, iSpellId))
		return;

	// Add the spell in the spellbook
	int iSpellLevel = JXGetBaseSpellLevel(iSpellId, iClass);
	spellsKnown = JXSpellsKnownAddSpell(spellsKnown, iSpellLevel, iSpellId);
	JXSaveSpellsKnown(oCreature, iClass, spellsKnown);
}