//::///////////////////////////////////////////////
//:: JX Spellbook - Spells ready GUI screen event: cast spell
//:: gui_jx_spbk_spqck_castspell
//:://////////////////////////////////////////////
//:://////////////////////////////////////////////
//:: Created By: jallaix
//:: Created On: Nov 20, 2007
//:://////////////////////////////////////////////
//
// This script is fired when a player clicks on a spell
// in the quick spells GUI screen, then choose a target to
// cast this spell.
// It decreases the number of spell uses/day, update the
// screen, and cast the spell.
//
//:://////////////////////////////////////////////

#include "jx_inc_spbk_process_sprdy"
#include "jx_inc_magic"




void main(string sDataString, int iObjectId, float fPosX, float fPosY, float fPosZ)
{
	object oPC = OBJECT_SELF;

	// Prepare the structures for the spell to cast
	struct jx_spell_ready spellReady;
	struct jx_spell_ready spellMaster;
	spellMaster.iSpellId = -1;

	// Get the current class in the quick spells GUI screen
	int iCurrentClass = GetLocalInt(oPC, JX_UI_SPELLS_QUICK_CURRENTCLASS);
	// Get the list of spells ready to be cast for the current class
	struct jx_spells_ready spellsReady = JXRestoreSpellsReady(oPC, iCurrentClass);

	// Target object of the spell
	object oTarget = IntToObject(iObjectId);

	// Target location of the spell
	vector vTarget = Vector(fPosX, fPosY, fPosZ);
	location lTarget = Location(GetArea(oPC), vTarget, GetFacing(oPC));

	// Get informations from the button clicked
	if (GetStringLeft(sDataString, 14) == "JX_SPELL_QUICK")
	{
		// Get the position of the spell cast in the quick spells GUI screen
		int iSpellLevel = StringToInt(JXStringSplit(sDataString, "_", 3));
		int iSpellSlot = StringToInt(JXStringSplit(sDataString, "_", 4));

		// Get the current metamagic in the quick spells GUI screen
		int iCurrentMetaMagic = GetLocalInt(oPC, JX_UI_SPELLS_QUICK_CURRENTMETAMAGIC);

		// Keep the spells from the list of ready spell associated with the selected metamagic feat
		struct jx_spells_ready spellsReadyMetaMagic = JXSpellsReadyGetByMetamagic(spellsReady, iCurrentMetaMagic);

		// Loop through the spell levels to find the position clicked
		int iSpellLevelPositionUI = 0;
		int iLoopSpellLevel;
		for (iLoopSpellLevel = 0; iLoopSpellLevel <= spellsReadyMetaMagic.iMaxSpellLevel; iLoopSpellLevel++)
		{	
			// Get the number of spells ready to be cast for the current spell level
			int iNbSpellSlots = JXSpellsReadyGetNbSpellsForLevel(spellsReadyMetaMagic, iLoopSpellLevel);

			// Search spells for the next spell level as no spells are ready for the current spell level
			if (iNbSpellSlots == 0)
				continue;

			// The spell level position is found
			if (iSpellLevelPositionUI == iSpellLevel)
			{
				// Find the spell that was clicked
				spellReady = JXSpellsReadyGetSpell(spellsReadyMetaMagic, iLoopSpellLevel, iSpellSlot);
				break;
			}

			iSpellLevelPositionUI++;
		}
	}
	else if (GetStringLeft(sDataString, 17) == "JX_SPELL_SUBSPELL")
	{
		// Get the index of the sub-spell chosen by the player
		int iSubSpellIndex = StringToInt(JXStringSplit(sDataString, "_", 3));

		// Get the list of sub-spells currently displayed
		struct jx_subspells_ui subSpellsUI = JXStringToSubSpellsUI(GetLocalString(oPC, JX_UI_SPELLS_SBSPL_CURRENTLIST));
		// Find the informations for the sub-spell
		spellReady = JXSubSpellsUIGetSubSpell(subSpellsUI, iSubSpellIndex);
		// Find the informations for the master spell
		spellMaster = JXSubSpellsUIGetMasterSpell(subSpellsUI);

		// Hide the sub-spell context menu
		SetGUIObjectHidden(oPC, JX_SCREEN_SPELLS_QUICK, "panSpellRadial", TRUE);
	}
	else
	{
		SendMessageToPC(oPC, "BUG : unknown behaviour in gui_jx_spbk_castspell.nss");
		return;
	}

	/*// Normal spell cast
	if (spellMaster.iSpellId == -1)
	{
		// Get the spell level and slot in the list of ready spells
		int iSpellLevel = JXSpellsReadyFindSpellLevel(spellsReady, spellReady);
		// Find the number of spell uses global to the found spell level
		int iNbUses = JXSpellsReadyGetNbGlobalSpells(spellsReady, iSpellLevel);
		// Decrease the number of uses/day specific to the spell cast
		if (iNbUses == -1)
		{
			int iSpellSlot = JXSpellsReadyFindSpellSlot(spellsReady, spellReady, iSpellLevel);
			spellReady.iNbUses = spellReady.iNbUses - 1;
			spellsReady = JXSpellsReadySetSpell(spellsReady, iSpellLevel, iSpellSlot, spellReady);
		}
		// Decrease the number of uses/day specific to the global spell level
		else
			spellsReady = JXSpellsReadySetNbGlobalSpells(spellsReady, iSpellLevel, iNbUses - 1);
	}
	// Sub-spell cast
	else
	{
		// Get the spell level and slot in the list of ready spells
		int iSpellLevel = JXSpellsReadyFindSpellLevel(spellsReady, spellMaster);
		// Find the number of spell uses global to the found spell level
		int iNbUses = JXSpellsReadyGetNbGlobalSpells(spellsReady, iSpellLevel);
		// Decrease the number of uses/day specific to the spell cast
		if (iNbUses == -1)
		{
			int iSpellSlot = JXSpellsReadyFindSpellSlot(spellsReady, spellMaster, iSpellLevel);
			spellMaster.iNbUses = spellMaster.iNbUses - 1;
			spellsReady = JXSpellsReadySetSpell(spellsReady, iSpellLevel, iSpellSlot, spellMaster);
		}
		// Decrease the number of uses/day specific to the global spell level
		else
			spellsReady = JXSpellsReadySetNbGlobalSpells(spellsReady, iSpellLevel, iNbUses - 1);
	}
	// Save the list of ready spells
	JXSaveSpellsReady(oPC, iCurrentClass, spellsReady);*/

	// Get the caster level and the save DC for the spell
	int iCasterLevel = JXGetCreatureCasterLevelForSpell(spellReady.iSpellId, oPC, iCurrentClass);
	int iSpellSaveDC = JXGetCreatureSpellSaveDC(spellReady.iSpellId, oPC, iCurrentClass);

	// Cast the spell
	if (GetIsObjectValid(IntToObject(iObjectId)))
	{
		JXActionCastSpellAtObject(oTarget, spellReady.iSpellId, spellReady.iMetaMagicFeat, iCasterLevel, iSpellSaveDC, iCurrentClass);
	}
	else
	{
		JXActionCastSpellAtLocation(lTarget, spellReady.iSpellId, spellReady.iMetaMagicFeat, iCasterLevel, iSpellSaveDC, iCurrentClass);
	}

	// Update the quick spells GUI screen
	JXUpdateGUISpellQuick(oPC);
}