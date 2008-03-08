//::///////////////////////////////////////////////
//:: JX Spellbook - Spell selection GUI screen event: show spell description
//:: gui_jx_spbk_splvl_showspelldesc
//:://////////////////////////////////////////////
//:://////////////////////////////////////////////
//:: Created By: jallaix
//:: Created On: Nov 14, 2007
//:://////////////////////////////////////////////
//
// This script is fired when a player select a spell,
// so as to show its description.
//
//:://////////////////////////////////////////////

#include "jx_inc_spbk_process_spsel"




void main(string sDataString)
{
	object oPC = OBJECT_SELF;

	// Get the slot of the spell
	int iSpellSlot = StringToInt(GetSubString(sDataString, 15, 2));

	// Get the selected class and spell level
	int iCurrentClass = GetLocalInt(oPC, JX_UI_SPELLS_LEVEL_CURRENTCLASS);
	int iCurrentSpellLevel = GetLocalInt(oPC, JX_UI_SPELLS_LEVEL_CURRENTLEVEL);
	// Get the current spell selection
	struct jx_nb_spells_select nbSpellsSelect = JXStringToNbSpellsSelect(GetLocalString(oPC, JX_UI_SPELLS_LEVEL_CURRENTNBSPELLS));
	struct jx_spells_known selectedSpells = JXStringToSpellsKnown(GetLocalString(oPC, JX_UI_SPELLS_LEVEL_SELECTEDSPELLS));
	struct jx_spells_known deselectedSpells = JXStringToSpellsKnown(GetLocalString(oPC, JX_UI_SPELLS_LEVEL_DESELECTEDSPELLS));

	// Get the list of spells that the PC has selected
	struct jx_spells_known spellsKnownLearned = JXRestoreSpellsKnown(oPC, iCurrentClass);
	struct jx_spells_known spellsKnownAdded = JXSpellsKnownAddSpellList(spellsKnownLearned, selectedSpells);
	spellsKnownAdded = JXSpellsKnownRemoveSpellList(spellsKnownAdded, deselectedSpells, iCurrentSpellLevel);

	int iSpellId;

	if (GetStringLeft(sDataString, 14) == "JX_SPELL_AVAIL")
	{
		// Get the complete list of spells available for the class, except those the PC has selected
		struct jx_spells_known spellsKnownAvailable = JXGetSpellList(iCurrentClass, iCurrentSpellLevel);
		spellsKnownAvailable = JXSpellsKnownRemoveSpellList(spellsKnownAvailable, spellsKnownAdded, iCurrentSpellLevel);
	
		// Get the spell chosen from the list of available spells
		iSpellId = JXSpellsKnownGetSpell(spellsKnownAvailable, iCurrentSpellLevel, iSpellSlot);
	}

	if (GetStringLeft(sDataString, 14) == "JX_SPELL_ADDED")
	{
		// Get the spell chosen from the list of added spells
		iSpellId = JXSpellsKnownGetSpell(spellsKnownAdded, iCurrentSpellLevel, iSpellSlot);
	}

	SetLocalInt(oPC, JX_UI_SPELLS_LEVEL_CURRENTSPELL, iSpellId);

	// Update the level up GUI screen
	DelayCommand(0.0, JXUpdateGUISpellLevelUp(oPC));
}