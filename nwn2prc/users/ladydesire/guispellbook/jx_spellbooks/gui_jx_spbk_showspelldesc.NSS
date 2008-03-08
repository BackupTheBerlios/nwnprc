//::///////////////////////////////////////////////
//:: JX Spellbook - Show spell description
//:: jx_inc_spbk_showspelldesc
//:://////////////////////////////////////////////
//:://////////////////////////////////////////////
//:: Created By: jallaix
//:: Created On: Nov 16, 2007
//:://////////////////////////////////////////////
//
// This script is fired when a player right clicks a spell
// in one of the spellbook-associated screens :
// - Known spells
// - Memorized spells
// - Quick spells
//
//:://////////////////////////////////////////////

#include "jx_inc_spbk_process_sprdy"




void main(string sDataString)
{
	object oPC = OBJECT_SELF;
	int iSpellId;

	// Spell description asked from the spells known GUI screen
	if (GetStringLeft(sDataString, 14) == "JX_SPELL_KNOWN")
	{
		// Get the list of known spells displayed
		struct jx_spells_known_ui spellsKnownUI = JXStringToSpellsKnownUI(GetLocalString(oPC, JX_UI_SPELLS_KNOWN_CURRENTLIST));
		struct jx_spell_known_ui spellKnownUI;

		// Find the spell slot for normal spells
		if (GetStringLeft(sDataString, 21) == "JX_SPELL_KNOWN_NORMAL")
		{
			int iSpellSlot = StringToInt(JXStringSplit(sDataString, "_", 4));
			spellKnownUI = JXSpellsKnownUIGetSpell(spellsKnownUI, 0, iSpellSlot);
		}
		// Find the spell slot for improved spells
		else if (GetStringLeft(sDataString, 19) == "JX_SPELL_KNOWN_META")
		{
			string sSpellInfos = GetSubString(sDataString, 19, 5);
			int iSpellList = StringToInt(JXStringSplit(sSpellInfos, "_", 0));
			int iSpellSlot = StringToInt(JXStringSplit(sSpellInfos, "_", 1));
			spellKnownUI = JXSpellsKnownUIGetSpell(spellsKnownUI, iSpellList, iSpellSlot);
		}
		else
			SendMessageToPC(oPC, "gui_jx_spbk_showspelldesc : Invalid data string");

		iSpellId = spellKnownUI.iSpellId;
	}

	// Spell description asked from the spells memorized GUI screen
	if (GetStringLeft(sDataString, 13) == "JX_SPELL_MEMO")
	{
		// Get the list of memorized spells displayed
		int iCurrentClass = GetLocalInt(oPC, JX_UI_SPELLS_KNOWN_CURRENTCLASS);
		struct jx_spells_memorized spellsMemorized = JXRestoreSpellsMemorized(oPC, iCurrentClass);

		// Find the spell slot
		string sMemoSlotInfo = GetSubString(sDataString, 14, 5);
		int iSpellLevel = StringToInt(JXStringSplit(sMemoSlotInfo, "_", 0));
		int iSpellSlot = StringToInt(JXStringSplit(sMemoSlotInfo, "_", 1));

		struct jx_spell_known_ui spellKnownUI = JXSpellsMemorizedUIGetSpell(spellsMemorized, iSpellLevel, iSpellSlot);
		iSpellId = spellKnownUI.iSpellId;
	}

	// Spell description asked from the quick spells GUI screen
	if ((GetStringLeft(sDataString, 14) == "JX_SPELL_QUICK")
	 || (GetStringLeft(sDataString, 21) == "JX_SPELL_RADIAL_QUICK"))
	{
		int iSpellLevel;
		int iSpellSlot;
		if (GetStringLeft(sDataString, 21) == "JX_SPELL_RADIAL_QUICK")
		{
			// Get the position of the spell cast in the quick spells GUI screen
			iSpellLevel = StringToInt(JXStringSplit(sDataString, "_", 4));
			iSpellSlot = StringToInt(JXStringSplit(sDataString, "_", 5));
		}
		else
		{
			// Get the position of the spell cast in the quick spells GUI screen
			iSpellLevel = StringToInt(JXStringSplit(sDataString, "_", 3));
			iSpellSlot = StringToInt(JXStringSplit(sDataString, "_", 4));
		}

		// Get the current class and metamagic in the quick spells GUI screen
		int iCurrentClass = GetLocalInt(oPC, JX_UI_SPELLS_QUICK_CURRENTCLASS);
		int iCurrentMetaMagic = GetLocalInt(oPC, JX_UI_SPELLS_QUICK_CURRENTMETAMAGIC);

		// Keep the spells from the list of ready spells associated with the selected metamagic feat
		struct jx_spells_ready spellsReady = JXRestoreSpellsReady(oPC, iCurrentClass);
		struct jx_spells_ready spellsReadyMetaMagic = JXSpellsReadyGetByMetamagic(spellsReady, iCurrentMetaMagic);

		// Loop through the spell levels to find the position clicked
		int iSpellLevelPositionUI = 0;
		int iLoopSpellLevel;
		struct jx_spell_ready spellReady;
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

		iSpellId = spellReady.iSpellId;
	}

	// Display the description for the spell found
	DisplayGuiScreen(oPC, JX_SCREEN_EXAMINE_SPELL, FALSE, JX_XML_EXAMINE_SPELL);
	int iSpellName = StringToInt(Get2DAString("spells", "Name", iSpellId));
	int iSpellDescription = StringToInt(Get2DAString("spells", "SpellDesc", iSpellId));
	SetGUIObjectText(oPC, JX_SCREEN_EXAMINE_SPELL, "txtSpellName", iSpellName, "");
	SetGUIObjectText(oPC, JX_SCREEN_EXAMINE_SPELL, "txtSpellDescription", iSpellDescription, "");
}