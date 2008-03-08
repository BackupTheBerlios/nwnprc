#include "jx_inc_spbk_process_sprdy"








void JXPrivateDecreaseNbUsesPerDay(object oCaster, int iSpellId, int iMetaMagicFeat, int iClass)
{
	// No class specifed => No number of spells/day to decrease
	if (iClass == CLASS_TYPE_INVALID)
		return;

	// Get the list of spells ready to be cast for the specified class
	struct jx_spells_ready spellsReady = JXRestoreSpellsReady(oCaster, iClass);

	// Find the master spell if the current spell is a sub-spell
	string sMaster = Get2DAString("spells", "Master", iSpellId);
	if (sMaster != "")
		iSpellId = StringToInt(sMaster);

	// Get the spell level and slot in the list of ready spells
	int iSpellLevel = JXSpellsReadyFindSpellLevel(spellsReady, iSpellId, iMetaMagicFeat);
	// Find the number of spell uses global to the found spell level
	int iNbUses = JXSpellsReadyGetNbGlobalSpells(spellsReady, iSpellLevel);

	// Decrease the number of uses/day specific to the spell cast
	struct jx_spell_ready spellReady;
	if (iNbUses == -1)
	{
		int iSpellSlot = JXSpellsReadyFindSpellSlot(spellsReady, iSpellId, iMetaMagicFeat, iSpellLevel);
		spellReady = JXSpellsReadyGetSpell(spellsReady, iSpellLevel, iSpellSlot);
		spellReady.iNbUses = spellReady.iNbUses - 1;
		spellsReady = JXSpellsReadySetSpell(spellsReady, iSpellLevel, iSpellSlot, spellReady);
	}
	// Decrease the number of uses/day specific to the global spell level
	else
		spellsReady = JXSpellsReadySetNbGlobalSpells(spellsReady, iSpellLevel, iNbUses - 1);
	// Save the list of ready spells
	JXSaveSpellsReady(oCaster, iClass, spellsReady);

	// Update the quick spells GUI screen
	JXUpdateGUISpellQuick(oCaster);
}

// This event is fired when the conjuration animation of a spellcasting action starts
// - oCaster Caster of the spell
// - iSpellId SPELL_* constant
// - oTarget Target object of the spell (may be OBJECT_INVALID)
// - lTarget Target location of the spell (location of oTarget if oTarget is valid)
// - iCasterLevel Caster level for the spell
// - iMetaMagicFeat MetaMagic feat for the spell
// - iSpellSaveDC Save DC for the spell
// - iClass Class used to cast the spell
// * Returns TRUE to let the spellcasting action continue, or FALSE to stop it
int JXSpbkEventActionCastSpellConjuring(object oCaster, int iSpellId, object oTarget, location lTarget, int iCasterLevel, int iMetaMagicFeat, int iSpellSaveDC, int iClass)
{
	if (JXClassGetHasInfiniteSpells(iClass))
		return TRUE;

	// Decrease the number of spell uses per day
	JXPrivateDecreaseNbUsesPerDay(oCaster, iSpellId, iMetaMagicFeat, iClass);

	return TRUE;
}

// This event is fired when the spell is cast
// - oCaster Caster of the spell
// - iSpellId SPELL_* constant
// - oTarget Target object of the spell (may be OBJECT_INVALID)
// - lTarget Target location of the spell (location of oTarget if oTarget is valid)
// - iCasterLevel Caster level for the spell
// - iMetaMagicFeat MetaMagic feat for the spell
// - iSpellSaveDC Save DC for the spell
// - iClass Class used to cast the spell
// * Returns TRUE to let the spell effects apply, or FALSE to prevent them
int JXSpbkEventActionCastSpellCast(object oCaster, int iSpellId, object oTarget, location lTarget, int iCasterLevel, int iMetaMagicFeat, int iSpellSaveDC, int iClass)
{
	// Decrease the number of spell uses per day for quicken spells
	if (iMetaMagicFeat & METAMAGIC_QUICKEN)
		JXPrivateDecreaseNbUsesPerDay(oCaster, iSpellId, iMetaMagicFeat, iClass);

	return TRUE;
}