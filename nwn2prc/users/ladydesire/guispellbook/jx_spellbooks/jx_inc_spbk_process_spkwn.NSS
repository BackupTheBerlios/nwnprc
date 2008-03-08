//::///////////////////////////////////////////////
//:: JX Spellbook - Known Spells include
//:: jx_inc_spbk_process_spkwn
//:://////////////////////////////////////////////
//:://////////////////////////////////////////////
//:: Created By: jallaix
//:: Created On: Nov 14, 2007
//:://////////////////////////////////////////////
//
// This include file provides functions to manage the spells
// known by a player in its spellbook.
//
//:://////////////////////////////////////////////

#include "jx_inc_spbk_const"
#include "jx_inc_spbk_data_spkwn"
#include "jx_inc_spbk_process_spday"
#include "jx_inc_script_call"
















//**************************************//
//                                      //
//              Interface               //
//                                      //
//**************************************//


// Get the spell list for the specified class
// - iClass CLASS_TYPE_* constant
// - iSpellLevel Spell level to get the spells from the spells from (-1 for all levels)
// * Returns the spell list found
struct jx_spells_known JXGetSpellList(int iClass, int iSpellLevel = -1);

// Restore a list of spells known previously saved for the specified PC
// - oPC Player character for which the spells must be saved
// - iClass CLASS_TYPE_* constant for which the spells must be saved
// * Returns the list of spells known previously saved
struct jx_spells_known JXRestoreSpellsKnown(object oPC, int iClass);

// Save a list of spells known for the specified PC
// - oPC Player character for which the spells must be saved
// - iClass CLASS_TYPE_* constant for which the spells must be saved
// - spellsKnown List of spells known that have to be saved
void JXSaveSpellsKnown(object oPC, int iClass, struct jx_spells_known spellsKnown);

// Determine if the spells for the current spellbook must be memorized
// and show or hide the memorized spells GUI screen if necessary
// - oPC Player character
void JXCheckSpellbookToMemorize(object oPC);

// Determine if the current spell level is available for the current class
// and invalidate it if necessary
// - oPC Player character
void JXCheckSpellLevelAvailability(object oPC);

// Transform a list of known spells into a list of spells known for the UI
// - oPC Player character to get the metamagic feats from
// - iClass Spellcasting class of the player character
// - spellsKnown List of spells known by the PC
// - iSpellLevel Spell level for which the metamagic spells must be defined
// * Return the list of known spells for the UI
struct jx_spells_known_ui JXSpellsKnownUIFromSpellsKnown(object oPC, int iClass, struct jx_spells_known spellsKnown, int iSpellLevel);

// Update the GUI screen for known spells to reflect the current data
// - oPC Player character that knowns spells
void JXUpdateGUISpellKnown(object oPC);
















//**************************************//
//                                      //
//            Implementation            //
//                                      //
//**************************************//


const int JX_SPBK_KNOWNMETA_MAXSPELLS = 20;


// Get the spell list for the specified class
// - iClass CLASS_TYPE_* constant
// - iSpellLevel Spell level to get the spells from the spells from (-1 for all levels)
// * Returns the spell list found
struct jx_spells_known JXGetSpellList(int iClass, int iSpellLevel = -1)
{
	struct script_param_list paramList;
	paramList = JXScriptAddParameterInt(paramList, iClass);
	paramList = JXScriptAddParameterInt(paramList, iSpellLevel);

	JXScriptCallFork(JX_SPBK_FORKSCRIPT, JX_FORK_SPBK_SPELLLIST, paramList);

	return JXStringToSpellsKnown(JXScriptGetResponseString());
}

// Restore a list of spells known previously saved for the specified PC
// - oPC Player character for which the spells must be saved
// - iClass CLASS_TYPE_* constant for which the spells must be saved
// * Returns the list of spells known previously saved
struct jx_spells_known JXRestoreSpellsKnown(object oPC, int iClass)
{
	string sSpellsKnown = GetLocalString(oPC, JX_SPELLS_KNOWN_PREFIX + IntToString(iClass));
	return JXStringToSpellsKnown(sSpellsKnown);
}

// Save a list of spells known for the specified PC
// - oPC Player character for which the spells must be saved
// - iClass CLASS_TYPE_* constant for which the spells must be saved
// - spellsKnown List of spells known that have to be saved
void JXSaveSpellsKnown(object oPC, int iClass, struct jx_spells_known spellsKnown)
{
	string sSpellsKnown = JXSpellsKnownToString(spellsKnown);
	SetLocalString(oPC, JX_SPELLS_KNOWN_PREFIX + IntToString(iClass), sSpellsKnown);
}

// Determine if the spells for the current spellbook must be memorized
// - oPC Player character
void JXCheckSpellbookToMemorize(object oPC)
{
	// Get the current class in the spells known GUI screen
	int iCurrentClass = GetLocalInt(oPC, JX_UI_SPELLS_KNOWN_CURRENTCLASS);

	// The class must memorize the spells
	if (JXClassGetMemorizesSpells(iCurrentClass))
	{
		DisplayGuiScreen(oPC, JX_SCREEN_SPELLS_MEMORIZED, FALSE, "jx_spells_memo.xml");
		// Fire the memorized spells' open event as this GUI screen could be already open
		ExecuteScript("gui_jx_spbk_spmem_open", oPC);
	}
	// The class doesn't memorize the spells
	else
		CloseGUIScreen(oPC, JX_SCREEN_SPELLS_MEMORIZED);
}

// Determine if the current spell level is available for the current class
// and invalidate it if necessary
// - oPC Player character
void JXCheckSpellLevelAvailability(object oPC)
{
	// Get the current class and spell level in the spells known GUI screen
	int iCurrentClass = GetLocalInt(oPC, JX_UI_SPELLS_KNOWN_CURRENTCLASS);
	int iCurrentSpellLevel = GetLocalInt(oPC, JX_UI_SPELLS_KNOWN_CURRENTLEVEL);

	// Invalidate the current spell level if the new spellcasting class doesn't allow it
	struct jx_spells_known spellsKnown = JXRestoreSpellsKnown(oPC, iCurrentClass);
	int iLoopLevel;
	for (iLoopLevel = 0; iLoopLevel <= 10; iLoopLevel++)
	{
		int iNbSpells = JXSpellsKnownGetNbSpellsForLevel(spellsKnown, iLoopLevel);
		if ((iNbSpells <= 0) && (iLoopLevel == iCurrentSpellLevel))
		{
			SetLocalInt(oPC, JX_UI_SPELLS_KNOWN_CURRENTLEVEL, -1);
			break;
		}
	}
}

// Private function - Find spells known UI for warlocks
struct jx_spells_known_ui JXPrivateSpellsKnownUIWarlockFromSpellsKnown(object oPC, struct jx_spells_known spellsKnown, int iSpellLevel)
{
	struct jx_spells_known_ui spellsKnownUI = JXSpellsKnownUICreateStruct();
	struct jx_spell_known_ui spellKnownUI;

	// Search the spells available for the specified spell level
	int iSpellsCount = JXSpellsKnownGetNbSpellsForLevel(spellsKnown, iSpellLevel);
	int iLoopSpell;
	for (iLoopSpell = 1; iLoopSpell <= iSpellsCount; iLoopSpell++)
	{
		// Get the current spell
		int iSpellId = JXSpellsKnownGetSpell(spellsKnown, iSpellLevel, iLoopSpell);
		// Save the normal spell displayed on the screen
		spellKnownUI.iSpellId = iSpellId;
		spellKnownUI.iMetaMagicFeat = 0;
		spellsKnownUI = JXSpellsKnownUIAddSpell(spellsKnownUI, 0, spellKnownUI);
	}

	// Find the list of metamagic feats available for the PC
	int iMetaMagicAvailable = 0;
	if (JXSpellsKnownContainsSpell(spellsKnown, SPELL_I_DRAINING_BLAST))
		iMetaMagicAvailable += METAMAGIC_INVOC_DRAINING_BLAST;
	if (JXSpellsKnownContainsSpell(spellsKnown, SPELL_I_ELDRITCH_SPEAR))
		iMetaMagicAvailable += METAMAGIC_INVOC_ELDRITCH_SPEAR;
	if (JXSpellsKnownContainsSpell(spellsKnown, SPELL_I_FRIGHTFUL_BLAST))
		iMetaMagicAvailable += METAMAGIC_INVOC_FRIGHTFUL_BLAST;
	if (JXSpellsKnownContainsSpell(spellsKnown, SPELL_I_HIDEOUS_BLOW))
		iMetaMagicAvailable += METAMAGIC_INVOC_HIDEOUS_BLOW;
	if (JXSpellsKnownContainsSpell(spellsKnown, SPELL_I_BESHADOWED_BLAST))
		iMetaMagicAvailable += METAMAGIC_INVOC_BESHADOWED_BLAST;
	if (JXSpellsKnownContainsSpell(spellsKnown, SPELL_I_BRIMSTONE_BLAST))
		iMetaMagicAvailable += METAMAGIC_INVOC_BRIMSTONE_BLAST;
	if (JXSpellsKnownContainsSpell(spellsKnown, SPELL_I_ELDRITCH_CHAIN))
		iMetaMagicAvailable += METAMAGIC_INVOC_ELDRITCH_CHAIN;
	if (JXSpellsKnownContainsSpell(spellsKnown, SPELL_I_HELLRIME_BLAST))
		iMetaMagicAvailable += METAMAGIC_INVOC_HELLRIME_BLAST;
	if (JXSpellsKnownContainsSpell(spellsKnown, SPELL_I_BEWITCHING_BLAST))
		iMetaMagicAvailable += METAMAGIC_INVOC_BEWITCHING_BLAST;
	if (JXSpellsKnownContainsSpell(spellsKnown, SPELL_I_ELDRITCH_CONE))
		iMetaMagicAvailable += METAMAGIC_INVOC_ELDRITCH_CONE;
	if (JXSpellsKnownContainsSpell(spellsKnown, SPELL_I_NOXIOUS_BLAST))
		iMetaMagicAvailable += METAMAGIC_INVOC_NOXIOUS_BLAST;
	if (JXSpellsKnownContainsSpell(spellsKnown, SPELL_I_VITRIOLIC_BLAST))
		iMetaMagicAvailable += METAMAGIC_INVOC_VITRIOLIC_BLAST;
	if (JXSpellsKnownContainsSpell(spellsKnown, SPELL_I_ELDRITCH_DOOM))
		iMetaMagicAvailable += METAMAGIC_INVOC_ELDRITCH_DOOM;
	if (JXSpellsKnownContainsSpell(spellsKnown, SPELL_I_UTTERDARK_BLAST))
		iMetaMagicAvailable += METAMAGIC_INVOC_UTTERDARK_BLAST;
	if (JXSpellsKnownContainsSpell(spellsKnown, 1130))	// Hindering blast
		iMetaMagicAvailable += METAMAGIC_INVOC_HINDERING_BLAST;
	if (JXSpellsKnownContainsSpell(spellsKnown, 1131))	// Binding blast
		iMetaMagicAvailable += METAMAGIC_INVOC_BINDING_BLAST;

	spellKnownUI.iSpellId = SPELLABILITY_I_ELDRITCH_BLAST;
	int bInvocationShape = FALSE;
	int bInvocationEssence = FALSE;

	// Search the spells available for invocation shapes
	switch (iSpellLevel)
	{
		case 1:
			// Shape : Eldritch Spear
			if (iMetaMagicAvailable & METAMAGIC_INVOC_ELDRITCH_SPEAR)
			{
				spellKnownUI.iSpellId = SPELL_I_ELDRITCH_SPEAR;
				// Essence : Draining Blast
				if (iMetaMagicAvailable & METAMAGIC_INVOC_DRAINING_BLAST)
				{
					spellKnownUI.iMetaMagicFeat = METAMAGIC_INVOC_ELDRITCH_SPEAR + METAMAGIC_INVOC_DRAINING_BLAST;
					spellsKnownUI = JXSpellsKnownUIAddSpell(spellsKnownUI, 1, spellKnownUI);
					bInvocationShape = TRUE;
				}
				// Essence : Frightful Blast
				if (iMetaMagicAvailable & METAMAGIC_INVOC_FRIGHTFUL_BLAST)
				{
					spellKnownUI.iMetaMagicFeat = METAMAGIC_INVOC_ELDRITCH_SPEAR + METAMAGIC_INVOC_FRIGHTFUL_BLAST;
					spellsKnownUI = JXSpellsKnownUIAddSpell(spellsKnownUI, 1, spellKnownUI);
					bInvocationShape = TRUE;
				}
			}
			// Shape : Hideous Blow
			if (iMetaMagicAvailable & METAMAGIC_INVOC_HIDEOUS_BLOW)
			{
				spellKnownUI.iSpellId = SPELL_I_HIDEOUS_BLOW;
				// Essence : Draining Blast
				if (iMetaMagicAvailable & METAMAGIC_INVOC_DRAINING_BLAST)
				{
					spellKnownUI.iMetaMagicFeat = METAMAGIC_INVOC_HIDEOUS_BLOW + METAMAGIC_INVOC_DRAINING_BLAST;
					spellsKnownUI = JXSpellsKnownUIAddSpell(spellsKnownUI, 1, spellKnownUI);
					bInvocationShape = TRUE;
				}
				// Essence : Frightful Blast
				if (iMetaMagicAvailable & METAMAGIC_INVOC_FRIGHTFUL_BLAST)
				{
					spellKnownUI.iMetaMagicFeat = METAMAGIC_INVOC_HIDEOUS_BLOW + METAMAGIC_INVOC_FRIGHTFUL_BLAST;
					spellsKnownUI = JXSpellsKnownUIAddSpell(spellsKnownUI, 1, spellKnownUI);
					bInvocationShape = TRUE;
				}
			}
			break;
		case 2:
			// Shape : Eldritch Chain
			if (iMetaMagicAvailable & METAMAGIC_INVOC_ELDRITCH_CHAIN)
			{
				spellKnownUI.iSpellId = SPELL_I_ELDRITCH_CHAIN;
				// Essence : Draining Blast
				if (iMetaMagicAvailable & METAMAGIC_INVOC_DRAINING_BLAST)
				{
					spellKnownUI.iMetaMagicFeat = METAMAGIC_INVOC_ELDRITCH_CHAIN + METAMAGIC_INVOC_DRAINING_BLAST;
					spellsKnownUI = JXSpellsKnownUIAddSpell(spellsKnownUI, 1, spellKnownUI);
					bInvocationShape = TRUE;
				}
				// Essence : Frightful Blast
				if (iMetaMagicAvailable & METAMAGIC_INVOC_FRIGHTFUL_BLAST)
				{
					spellKnownUI.iMetaMagicFeat = METAMAGIC_INVOC_ELDRITCH_CHAIN + METAMAGIC_INVOC_FRIGHTFUL_BLAST;
					spellsKnownUI = JXSpellsKnownUIAddSpell(spellsKnownUI, 1, spellKnownUI);
					bInvocationShape = TRUE;
				}
				// Essence : Beshadowed Blast
				if (iMetaMagicAvailable & METAMAGIC_INVOC_BESHADOWED_BLAST)
				{
					spellKnownUI.iMetaMagicFeat = METAMAGIC_INVOC_ELDRITCH_CHAIN + METAMAGIC_INVOC_BESHADOWED_BLAST;
					spellsKnownUI = JXSpellsKnownUIAddSpell(spellsKnownUI, 1, spellKnownUI);
					bInvocationShape = TRUE;
				}
				// Essence : Brimstone Blast
				if (iMetaMagicAvailable & METAMAGIC_INVOC_BRIMSTONE_BLAST)
				{
					spellKnownUI.iMetaMagicFeat = METAMAGIC_INVOC_ELDRITCH_CHAIN + METAMAGIC_INVOC_BRIMSTONE_BLAST;
					spellsKnownUI = JXSpellsKnownUIAddSpell(spellsKnownUI, 1, spellKnownUI);
					bInvocationShape = TRUE;
				}
				// Essence : Hellrime Blast
				if (iMetaMagicAvailable & METAMAGIC_INVOC_HELLRIME_BLAST)
				{
					spellKnownUI.iMetaMagicFeat = METAMAGIC_INVOC_ELDRITCH_CHAIN + METAMAGIC_INVOC_HELLRIME_BLAST;
					spellsKnownUI = JXSpellsKnownUIAddSpell(spellsKnownUI, 1, spellKnownUI);
					bInvocationShape = TRUE;
				}
			}
			break;
		case 3:
			// Shape : Eldritch Cone
			if (iMetaMagicAvailable & METAMAGIC_INVOC_ELDRITCH_CONE)
			{
				spellKnownUI.iSpellId = SPELL_I_ELDRITCH_CONE;
				// Essence : Draining Blast
				if (iMetaMagicAvailable & METAMAGIC_INVOC_DRAINING_BLAST)
				{
					spellKnownUI.iMetaMagicFeat = METAMAGIC_INVOC_ELDRITCH_CONE + METAMAGIC_INVOC_DRAINING_BLAST;
					spellsKnownUI = JXSpellsKnownUIAddSpell(spellsKnownUI, 1, spellKnownUI);
					bInvocationShape = TRUE;
				}
				// Essence : Frightful Blast
				if (iMetaMagicAvailable & METAMAGIC_INVOC_FRIGHTFUL_BLAST)
				{
					spellKnownUI.iMetaMagicFeat = METAMAGIC_INVOC_ELDRITCH_CONE + METAMAGIC_INVOC_FRIGHTFUL_BLAST;
					spellsKnownUI = JXSpellsKnownUIAddSpell(spellsKnownUI, 1, spellKnownUI);
					bInvocationShape = TRUE;
				}
				// Essence : Beshadowed Blast
				if (iMetaMagicAvailable & METAMAGIC_INVOC_BESHADOWED_BLAST)
				{
					spellKnownUI.iMetaMagicFeat = METAMAGIC_INVOC_ELDRITCH_CONE + METAMAGIC_INVOC_BESHADOWED_BLAST;
					spellsKnownUI = JXSpellsKnownUIAddSpell(spellsKnownUI, 1, spellKnownUI);
					bInvocationShape = TRUE;
				}
				// Essence : Brimstone Blast
				if (iMetaMagicAvailable & METAMAGIC_INVOC_BRIMSTONE_BLAST)
				{
					spellKnownUI.iMetaMagicFeat = METAMAGIC_INVOC_ELDRITCH_CONE + METAMAGIC_INVOC_BRIMSTONE_BLAST;
					spellsKnownUI = JXSpellsKnownUIAddSpell(spellsKnownUI, 1, spellKnownUI);
					bInvocationShape = TRUE;
				}
				// Essence : Hellrime Blast
				if (iMetaMagicAvailable & METAMAGIC_INVOC_HELLRIME_BLAST)
				{
					spellKnownUI.iMetaMagicFeat = METAMAGIC_INVOC_ELDRITCH_CONE + METAMAGIC_INVOC_HELLRIME_BLAST;
					spellsKnownUI = JXSpellsKnownUIAddSpell(spellsKnownUI, 1, spellKnownUI);
					bInvocationShape = TRUE;
				}
				// Essence : Betwitching Blast
				if (iMetaMagicAvailable & METAMAGIC_INVOC_BEWITCHING_BLAST)
				{
					spellKnownUI.iMetaMagicFeat = METAMAGIC_INVOC_ELDRITCH_CONE + METAMAGIC_INVOC_BEWITCHING_BLAST;
					spellsKnownUI = JXSpellsKnownUIAddSpell(spellsKnownUI, 1, spellKnownUI);
					bInvocationShape = TRUE;
				}
				// Essence : Noxious Blast
				if (iMetaMagicAvailable & METAMAGIC_INVOC_NOXIOUS_BLAST)
				{
					spellKnownUI.iMetaMagicFeat = METAMAGIC_INVOC_ELDRITCH_CONE + METAMAGIC_INVOC_NOXIOUS_BLAST;
					spellsKnownUI = JXSpellsKnownUIAddSpell(spellsKnownUI, 1, spellKnownUI);
					bInvocationShape = TRUE;
				}
				// Essence : Vitriolic Blast
				if (iMetaMagicAvailable & METAMAGIC_INVOC_VITRIOLIC_BLAST)
				{
					spellKnownUI.iMetaMagicFeat = METAMAGIC_INVOC_ELDRITCH_CONE + METAMAGIC_INVOC_VITRIOLIC_BLAST;
					spellsKnownUI = JXSpellsKnownUIAddSpell(spellsKnownUI, 1, spellKnownUI);
					bInvocationShape = TRUE;
				}
				// Essence : Hindering Blast
				if (iMetaMagicAvailable & METAMAGIC_INVOC_HINDERING_BLAST)
				{
					spellKnownUI.iMetaMagicFeat = METAMAGIC_INVOC_ELDRITCH_CONE + METAMAGIC_INVOC_HINDERING_BLAST;
					spellsKnownUI = JXSpellsKnownUIAddSpell(spellsKnownUI, 1, spellKnownUI);
					bInvocationShape = TRUE;
				}
			}
			break;
		case 4:
			// Shape : Eldritch Doom
			if (iMetaMagicAvailable & METAMAGIC_INVOC_ELDRITCH_DOOM)
			{
				spellKnownUI.iSpellId = SPELL_I_ELDRITCH_DOOM;
				// Essence : Draining Blast
				if (iMetaMagicAvailable & METAMAGIC_INVOC_DRAINING_BLAST)
				{
					spellKnownUI.iMetaMagicFeat = METAMAGIC_INVOC_ELDRITCH_DOOM + METAMAGIC_INVOC_DRAINING_BLAST;
					spellsKnownUI = JXSpellsKnownUIAddSpell(spellsKnownUI, 1, spellKnownUI);
					bInvocationShape = TRUE;
				}
				// Essence : Frightful Blast
				if (iMetaMagicAvailable & METAMAGIC_INVOC_FRIGHTFUL_BLAST)
				{
					spellKnownUI.iMetaMagicFeat = METAMAGIC_INVOC_ELDRITCH_DOOM + METAMAGIC_INVOC_FRIGHTFUL_BLAST;
					spellsKnownUI = JXSpellsKnownUIAddSpell(spellsKnownUI, 1, spellKnownUI);
					bInvocationShape = TRUE;
				}
				// Essence : Beshadowed Blast
				if (iMetaMagicAvailable & METAMAGIC_INVOC_BESHADOWED_BLAST)
				{
					spellKnownUI.iMetaMagicFeat = METAMAGIC_INVOC_ELDRITCH_DOOM + METAMAGIC_INVOC_BESHADOWED_BLAST;
					spellsKnownUI = JXSpellsKnownUIAddSpell(spellsKnownUI, 1, spellKnownUI);
					bInvocationShape = TRUE;
				}
				// Essence : Brimstone Blast
				if (iMetaMagicAvailable & METAMAGIC_INVOC_BRIMSTONE_BLAST)
				{
					spellKnownUI.iMetaMagicFeat = METAMAGIC_INVOC_ELDRITCH_DOOM + METAMAGIC_INVOC_BRIMSTONE_BLAST;
					spellsKnownUI = JXSpellsKnownUIAddSpell(spellsKnownUI, 1, spellKnownUI);
					bInvocationShape = TRUE;
				}
				// Essence : Hellrime Blast
				if (iMetaMagicAvailable & METAMAGIC_INVOC_HELLRIME_BLAST)
				{
					spellKnownUI.iMetaMagicFeat = METAMAGIC_INVOC_ELDRITCH_DOOM + METAMAGIC_INVOC_HELLRIME_BLAST;
					spellsKnownUI = JXSpellsKnownUIAddSpell(spellsKnownUI, 1, spellKnownUI);
					bInvocationShape = TRUE;
				}
				// Essence : Betwitching Blast
				if (iMetaMagicAvailable & METAMAGIC_INVOC_BEWITCHING_BLAST)
				{
					spellKnownUI.iMetaMagicFeat = METAMAGIC_INVOC_ELDRITCH_DOOM + METAMAGIC_INVOC_BEWITCHING_BLAST;
					spellsKnownUI = JXSpellsKnownUIAddSpell(spellsKnownUI, 1, spellKnownUI);
					bInvocationShape = TRUE;
				}
				// Essence : Noxious Blast
				if (iMetaMagicAvailable & METAMAGIC_INVOC_NOXIOUS_BLAST)
				{
					spellKnownUI.iMetaMagicFeat = METAMAGIC_INVOC_ELDRITCH_DOOM + METAMAGIC_INVOC_NOXIOUS_BLAST;
					spellsKnownUI = JXSpellsKnownUIAddSpell(spellsKnownUI, 1, spellKnownUI);
					bInvocationShape = TRUE;
				}
				// Essence : Vitriolic Blast
				if (iMetaMagicAvailable & METAMAGIC_INVOC_VITRIOLIC_BLAST)
				{
					spellKnownUI.iMetaMagicFeat = METAMAGIC_INVOC_ELDRITCH_DOOM + METAMAGIC_INVOC_VITRIOLIC_BLAST;
					spellsKnownUI = JXSpellsKnownUIAddSpell(spellsKnownUI, 1, spellKnownUI);
					bInvocationShape = TRUE;
				}
				// Essence : Hindering Blast
				if (iMetaMagicAvailable & METAMAGIC_INVOC_HINDERING_BLAST)
				{
					spellKnownUI.iMetaMagicFeat = METAMAGIC_INVOC_ELDRITCH_DOOM + METAMAGIC_INVOC_HINDERING_BLAST;
					spellsKnownUI = JXSpellsKnownUIAddSpell(spellsKnownUI, 1, spellKnownUI);
					bInvocationShape = TRUE;
				}
				// Essence : Utterdark Blast
				if (iMetaMagicAvailable & METAMAGIC_INVOC_UTTERDARK_BLAST)
				{
					spellKnownUI.iMetaMagicFeat = METAMAGIC_INVOC_ELDRITCH_DOOM + METAMAGIC_INVOC_UTTERDARK_BLAST;
					spellsKnownUI = JXSpellsKnownUIAddSpell(spellsKnownUI, 1, spellKnownUI);
					bInvocationShape = TRUE;
				}
				// Essence : Binding Blast
				if (iMetaMagicAvailable & METAMAGIC_INVOC_BINDING_BLAST)
				{
					spellKnownUI.iMetaMagicFeat = METAMAGIC_INVOC_ELDRITCH_DOOM + METAMAGIC_INVOC_BINDING_BLAST;
					spellsKnownUI = JXSpellsKnownUIAddSpell(spellsKnownUI, 1, spellKnownUI);
					bInvocationShape = TRUE;
				}
			}
			break;
	}
	// Define the metamagic feat for the spell list
	// (Eldritch Spear is used to write down that an Invocation Shape is present)
	if (bInvocationShape == TRUE)
		spellsKnownUI = JXSpellsKnownUISetMetaMagicFeat(spellsKnownUI, 1, METAMAGIC_INVOC_ELDRITCH_SPEAR);


	// Search the spells available for invocation shapes
	int iSpellList = (bInvocationShape == TRUE) ? 2 : 1;
	switch (iSpellLevel)
	{
		// Essences of Level 2 and Shapes of Level 1
		case 2:
			// Essence : Beshadowed Blast
			if (iMetaMagicAvailable & METAMAGIC_INVOC_BESHADOWED_BLAST)
			{
				// Shape : Eldritch Spear
				if (iMetaMagicAvailable & METAMAGIC_INVOC_ELDRITCH_SPEAR)
				{
					spellKnownUI.iSpellId = SPELL_I_ELDRITCH_SPEAR;
					spellKnownUI.iMetaMagicFeat = METAMAGIC_INVOC_BESHADOWED_BLAST + METAMAGIC_INVOC_ELDRITCH_SPEAR;
					spellsKnownUI = JXSpellsKnownUIAddSpell(spellsKnownUI, iSpellList, spellKnownUI);
					bInvocationEssence = TRUE;
				}
				// Shape : Hideous Blow
				if (iMetaMagicAvailable & METAMAGIC_INVOC_HIDEOUS_BLOW)
				{
					spellKnownUI.iSpellId = SPELL_I_HIDEOUS_BLOW;
					spellKnownUI.iMetaMagicFeat = METAMAGIC_INVOC_BESHADOWED_BLAST + METAMAGIC_INVOC_HIDEOUS_BLOW;
					spellsKnownUI = JXSpellsKnownUIAddSpell(spellsKnownUI, iSpellList, spellKnownUI);
					bInvocationEssence = TRUE;
				}
			}
			// Essence : Brimstone Blast
			if (iMetaMagicAvailable & METAMAGIC_INVOC_BRIMSTONE_BLAST)
			{
				// Shape : Eldritch Spear
				if (iMetaMagicAvailable & METAMAGIC_INVOC_ELDRITCH_SPEAR)
				{
					spellKnownUI.iSpellId = SPELL_I_ELDRITCH_SPEAR;
					spellKnownUI.iMetaMagicFeat = METAMAGIC_INVOC_BRIMSTONE_BLAST + METAMAGIC_INVOC_ELDRITCH_SPEAR;
					spellsKnownUI = JXSpellsKnownUIAddSpell(spellsKnownUI, iSpellList, spellKnownUI);
					bInvocationEssence = TRUE;
				}
				// Shape : Hideous Blow
				if (iMetaMagicAvailable & METAMAGIC_INVOC_HIDEOUS_BLOW)
				{
					spellKnownUI.iSpellId = SPELL_I_HIDEOUS_BLOW;
					spellKnownUI.iMetaMagicFeat = METAMAGIC_INVOC_BRIMSTONE_BLAST + METAMAGIC_INVOC_HIDEOUS_BLOW;
					spellsKnownUI = JXSpellsKnownUIAddSpell(spellsKnownUI, iSpellList, spellKnownUI);
					bInvocationEssence = TRUE;
				}
			}
			// Essence : Hellrime Blast
			if (iMetaMagicAvailable & METAMAGIC_INVOC_HELLRIME_BLAST)
			{
				// Shape : Eldritch Spear
				if (iMetaMagicAvailable & METAMAGIC_INVOC_ELDRITCH_SPEAR)
				{
					spellKnownUI.iSpellId = SPELL_I_ELDRITCH_SPEAR;
					spellKnownUI.iMetaMagicFeat = METAMAGIC_INVOC_HELLRIME_BLAST + METAMAGIC_INVOC_ELDRITCH_SPEAR;
					spellsKnownUI = JXSpellsKnownUIAddSpell(spellsKnownUI, iSpellList, spellKnownUI);
					bInvocationEssence = TRUE;
				}
				// Shape : Hideous Blow
				if (iMetaMagicAvailable & METAMAGIC_INVOC_HIDEOUS_BLOW)
				{
					spellKnownUI.iSpellId = SPELL_I_HIDEOUS_BLOW;
					spellKnownUI.iMetaMagicFeat = METAMAGIC_INVOC_HELLRIME_BLAST + METAMAGIC_INVOC_HIDEOUS_BLOW;
					spellsKnownUI = JXSpellsKnownUIAddSpell(spellsKnownUI, iSpellList, spellKnownUI);
					bInvocationEssence = TRUE;
				}
			}
			break;
		// Essences of Level 3 and Shapes of Level 1 & 2
		case 3:
			// Essence : Bewitching Blast
			if (iMetaMagicAvailable & METAMAGIC_INVOC_BEWITCHING_BLAST)
			{
				// Shape : Eldritch Spear
				if (iMetaMagicAvailable & METAMAGIC_INVOC_ELDRITCH_SPEAR)
				{
					spellKnownUI.iSpellId = SPELL_I_ELDRITCH_SPEAR;
					spellKnownUI.iMetaMagicFeat = METAMAGIC_INVOC_BEWITCHING_BLAST + METAMAGIC_INVOC_ELDRITCH_SPEAR;
					spellsKnownUI = JXSpellsKnownUIAddSpell(spellsKnownUI, iSpellList, spellKnownUI);
					bInvocationEssence = TRUE;
				}
				// Shape : Hideous Blow
				if (iMetaMagicAvailable & METAMAGIC_INVOC_HIDEOUS_BLOW)
				{
					spellKnownUI.iSpellId = SPELL_I_HIDEOUS_BLOW;
					spellKnownUI.iMetaMagicFeat = METAMAGIC_INVOC_BEWITCHING_BLAST + METAMAGIC_INVOC_HIDEOUS_BLOW;
					spellsKnownUI = JXSpellsKnownUIAddSpell(spellsKnownUI, iSpellList, spellKnownUI);
					bInvocationEssence = TRUE;
				}
				// Shape : Eldritch Chain
				if (iMetaMagicAvailable & METAMAGIC_INVOC_ELDRITCH_CHAIN)
				{
					spellKnownUI.iSpellId = SPELL_I_ELDRITCH_CHAIN;
					spellKnownUI.iMetaMagicFeat = METAMAGIC_INVOC_BEWITCHING_BLAST + METAMAGIC_INVOC_ELDRITCH_CHAIN;
					spellsKnownUI = JXSpellsKnownUIAddSpell(spellsKnownUI, iSpellList, spellKnownUI);
					bInvocationEssence = TRUE;
				}
			}
			// Essence : Noxious blast
			if (iMetaMagicAvailable & METAMAGIC_INVOC_NOXIOUS_BLAST)
			{
				// Shape : Eldritch Spear
				if (iMetaMagicAvailable & METAMAGIC_INVOC_ELDRITCH_SPEAR)
				{
					spellKnownUI.iSpellId = SPELL_I_ELDRITCH_SPEAR;
					spellKnownUI.iMetaMagicFeat = METAMAGIC_INVOC_NOXIOUS_BLAST + METAMAGIC_INVOC_ELDRITCH_SPEAR;
					spellsKnownUI = JXSpellsKnownUIAddSpell(spellsKnownUI, iSpellList, spellKnownUI);
					bInvocationEssence = TRUE;
				}
				// Shape : Hideous Blow
				if (iMetaMagicAvailable & METAMAGIC_INVOC_HIDEOUS_BLOW)
				{
					spellKnownUI.iSpellId = SPELL_I_HIDEOUS_BLOW;
					spellKnownUI.iMetaMagicFeat = METAMAGIC_INVOC_NOXIOUS_BLAST + METAMAGIC_INVOC_HIDEOUS_BLOW;
					spellsKnownUI = JXSpellsKnownUIAddSpell(spellsKnownUI, iSpellList, spellKnownUI);
					bInvocationEssence = TRUE;
				}
				// Shape : Eldritch Chain
				if (iMetaMagicAvailable & METAMAGIC_INVOC_ELDRITCH_CHAIN)
				{
					spellKnownUI.iSpellId = SPELL_I_ELDRITCH_CHAIN;
					spellKnownUI.iMetaMagicFeat = METAMAGIC_INVOC_NOXIOUS_BLAST + METAMAGIC_INVOC_ELDRITCH_CHAIN;
					spellsKnownUI = JXSpellsKnownUIAddSpell(spellsKnownUI, iSpellList, spellKnownUI);
					bInvocationEssence = TRUE;
				}
			}
			// Essence : Vitriolic Blast
			if (iMetaMagicAvailable & METAMAGIC_INVOC_VITRIOLIC_BLAST)
			{
				// Shape : Eldritch Spear
				if (iMetaMagicAvailable & METAMAGIC_INVOC_ELDRITCH_SPEAR)
				{
					spellKnownUI.iSpellId = SPELL_I_ELDRITCH_SPEAR;
					spellKnownUI.iMetaMagicFeat = METAMAGIC_INVOC_VITRIOLIC_BLAST + METAMAGIC_INVOC_ELDRITCH_SPEAR;
					spellsKnownUI = JXSpellsKnownUIAddSpell(spellsKnownUI, iSpellList, spellKnownUI);
					bInvocationEssence = TRUE;
				}
				// Shape : Hideous Blow
				if (iMetaMagicAvailable & METAMAGIC_INVOC_HIDEOUS_BLOW)
				{
					spellKnownUI.iSpellId = SPELL_I_HIDEOUS_BLOW;
					spellKnownUI.iMetaMagicFeat = METAMAGIC_INVOC_VITRIOLIC_BLAST + METAMAGIC_INVOC_HIDEOUS_BLOW;
					spellsKnownUI = JXSpellsKnownUIAddSpell(spellsKnownUI, iSpellList, spellKnownUI);
					bInvocationEssence = TRUE;
				}
				// Shape : Eldritch Chain
				if (iMetaMagicAvailable & METAMAGIC_INVOC_ELDRITCH_CHAIN)
				{
					spellKnownUI.iSpellId = SPELL_I_ELDRITCH_CHAIN;
					spellKnownUI.iMetaMagicFeat = METAMAGIC_INVOC_VITRIOLIC_BLAST + METAMAGIC_INVOC_ELDRITCH_CHAIN;
					spellsKnownUI = JXSpellsKnownUIAddSpell(spellsKnownUI, iSpellList, spellKnownUI);
					bInvocationEssence = TRUE;
				}
			}
			// Essence : Hindering Blast
			if (iMetaMagicAvailable & METAMAGIC_INVOC_HINDERING_BLAST)
			{
				// Shape : Eldritch Spear
				if (iMetaMagicAvailable & METAMAGIC_INVOC_ELDRITCH_SPEAR)
				{
					spellKnownUI.iSpellId = SPELL_I_ELDRITCH_SPEAR;
					spellKnownUI.iMetaMagicFeat = METAMAGIC_INVOC_HINDERING_BLAST + METAMAGIC_INVOC_ELDRITCH_SPEAR;
					spellsKnownUI = JXSpellsKnownUIAddSpell(spellsKnownUI, iSpellList, spellKnownUI);
					bInvocationEssence = TRUE;
				}
				// Shape : Hideous Blow
				if (iMetaMagicAvailable & METAMAGIC_INVOC_HIDEOUS_BLOW)
				{
					spellKnownUI.iSpellId = SPELL_I_HIDEOUS_BLOW;
					spellKnownUI.iMetaMagicFeat = METAMAGIC_INVOC_HINDERING_BLAST + METAMAGIC_INVOC_HIDEOUS_BLOW;
					spellsKnownUI = JXSpellsKnownUIAddSpell(spellsKnownUI, iSpellList, spellKnownUI);
					bInvocationEssence = TRUE;
				}
				// Shape : Eldritch Chain
				if (iMetaMagicAvailable & METAMAGIC_INVOC_ELDRITCH_CHAIN)
				{
					spellKnownUI.iSpellId = SPELL_I_ELDRITCH_CHAIN;
					spellKnownUI.iMetaMagicFeat = METAMAGIC_INVOC_HINDERING_BLAST + METAMAGIC_INVOC_ELDRITCH_CHAIN;
					spellsKnownUI = JXSpellsKnownUIAddSpell(spellsKnownUI, iSpellList, spellKnownUI);
					bInvocationEssence = TRUE;
				}
			}
			break;
		// Essences of Level 4 and Shapes of Level 1, 2 & 3
		case 4:
			// Essence : Utterdark Blast
			if (iMetaMagicAvailable & METAMAGIC_INVOC_UTTERDARK_BLAST)
			{
				// Shape : Eldritch Spear
				if (iMetaMagicAvailable & METAMAGIC_INVOC_ELDRITCH_SPEAR)
				{
					spellKnownUI.iSpellId = SPELL_I_ELDRITCH_SPEAR;
					spellKnownUI.iMetaMagicFeat = METAMAGIC_INVOC_UTTERDARK_BLAST + METAMAGIC_INVOC_ELDRITCH_SPEAR;
					spellsKnownUI = JXSpellsKnownUIAddSpell(spellsKnownUI, iSpellList, spellKnownUI);
					bInvocationEssence = TRUE;
				}
				// Shape : Hideous Blow
				if (iMetaMagicAvailable & METAMAGIC_INVOC_HIDEOUS_BLOW)
				{
					spellKnownUI.iSpellId = SPELL_I_HIDEOUS_BLOW;
					spellKnownUI.iMetaMagicFeat = METAMAGIC_INVOC_UTTERDARK_BLAST + METAMAGIC_INVOC_HIDEOUS_BLOW;
					spellsKnownUI = JXSpellsKnownUIAddSpell(spellsKnownUI, iSpellList, spellKnownUI);
					bInvocationEssence = TRUE;
				}
				// Shape : Eldritch Chain
				if (iMetaMagicAvailable & METAMAGIC_INVOC_ELDRITCH_CHAIN)
				{
					spellKnownUI.iSpellId = SPELL_I_ELDRITCH_CHAIN;
					spellKnownUI.iMetaMagicFeat = METAMAGIC_INVOC_UTTERDARK_BLAST + METAMAGIC_INVOC_ELDRITCH_CHAIN;
					spellsKnownUI = JXSpellsKnownUIAddSpell(spellsKnownUI, iSpellList, spellKnownUI);
					bInvocationEssence = TRUE;
				}
				// Shape : Eldritch Cone
				if (iMetaMagicAvailable & METAMAGIC_INVOC_ELDRITCH_CONE)
				{
					spellKnownUI.iSpellId = SPELL_I_ELDRITCH_CONE;
					spellKnownUI.iMetaMagicFeat = METAMAGIC_INVOC_UTTERDARK_BLAST + METAMAGIC_INVOC_ELDRITCH_CONE;
					spellsKnownUI = JXSpellsKnownUIAddSpell(spellsKnownUI, iSpellList, spellKnownUI);
					bInvocationEssence = TRUE;
				}
			}
			// Essence : Binding Blast
			if (iMetaMagicAvailable & METAMAGIC_INVOC_BINDING_BLAST)
			{
				// Shape : Eldritch Spear
				if (iMetaMagicAvailable & METAMAGIC_INVOC_ELDRITCH_SPEAR)
				{
					spellKnownUI.iSpellId = SPELL_I_ELDRITCH_SPEAR;
					spellKnownUI.iMetaMagicFeat = METAMAGIC_INVOC_BINDING_BLAST + METAMAGIC_INVOC_ELDRITCH_SPEAR;
					spellsKnownUI = JXSpellsKnownUIAddSpell(spellsKnownUI, iSpellList, spellKnownUI);
					bInvocationEssence = TRUE;
				}
				// Shape : Hideous Blow
				if (iMetaMagicAvailable & METAMAGIC_INVOC_HIDEOUS_BLOW)
				{
					spellKnownUI.iSpellId = SPELL_I_HIDEOUS_BLOW;
					spellKnownUI.iMetaMagicFeat = METAMAGIC_INVOC_BINDING_BLAST + METAMAGIC_INVOC_HIDEOUS_BLOW;
					spellsKnownUI = JXSpellsKnownUIAddSpell(spellsKnownUI, iSpellList, spellKnownUI);
					bInvocationEssence = TRUE;
				}
				// Shape : Eldritch Chain
				if (iMetaMagicAvailable & METAMAGIC_INVOC_ELDRITCH_CHAIN)
				{
					spellKnownUI.iSpellId = SPELL_I_ELDRITCH_CHAIN;
					spellKnownUI.iMetaMagicFeat = METAMAGIC_INVOC_BINDING_BLAST + METAMAGIC_INVOC_ELDRITCH_CHAIN;
					spellsKnownUI = JXSpellsKnownUIAddSpell(spellsKnownUI, iSpellList, spellKnownUI);
					bInvocationEssence = TRUE;
				}
				// Shape : Eldritch Cone
				if (iMetaMagicAvailable & METAMAGIC_INVOC_ELDRITCH_CONE)
				{
					spellKnownUI.iSpellId = SPELL_I_ELDRITCH_CONE;
					spellKnownUI.iMetaMagicFeat = METAMAGIC_INVOC_BINDING_BLAST + METAMAGIC_INVOC_ELDRITCH_CONE;
					spellsKnownUI = JXSpellsKnownUIAddSpell(spellsKnownUI, iSpellList, spellKnownUI);
					bInvocationEssence = TRUE;
				}
			}
			break;
	}
	// Define the metamagic feat for the spell list
	// (Beshadowed Blast is used to write down that an Invocation Essence is present)
	if (bInvocationEssence == TRUE)
		spellsKnownUI = JXSpellsKnownUISetMetaMagicFeat(spellsKnownUI, iSpellList, METAMAGIC_INVOC_BESHADOWED_BLAST);

	return spellsKnownUI;
}

// Transform a list of known spells into a list of spells known for the UI
// - oPC Player character to get the metamagic feats from
// - iClass Spellcasting class of the player character
// - spellsKnown List of spells known by the PC
// - iSpellLevel Spell level for which the metamagic spells must be defined
// * Return the list of known spells for the UI
struct jx_spells_known_ui JXSpellsKnownUIFromSpellsKnown(object oPC, int iClass, struct jx_spells_known spellsKnown, int iSpellLevel)
{
	// Specific case : Warlock
	if (iClass == CLASS_TYPE_WARLOCK)
		return JXPrivateSpellsKnownUIWarlockFromSpellsKnown(oPC, spellsKnown, iSpellLevel);

	struct jx_spells_known_ui spellsKnownUI = JXSpellsKnownUICreateStruct();
	struct jx_spell_known_ui spellKnownUI;

	// Search the spells available for the specified spell level
	int iSpellsCount = JXSpellsKnownGetNbSpellsForLevel(spellsKnown, iSpellLevel);
	int iLoopSpell;
	for (iLoopSpell = 1; iLoopSpell <= iSpellsCount; iLoopSpell++)
	{
		// Get the current spell
		int iSpellId = JXSpellsKnownGetSpell(spellsKnown, iSpellLevel, iLoopSpell);
		// Save the normal spell displayed on the screen
		spellKnownUI.iSpellId = iSpellId;
		spellKnownUI.iMetaMagicFeat = 0;
		spellsKnownUI = JXSpellsKnownUIAddSpell(spellsKnownUI, 0, spellKnownUI);
	}

	// Don't search spells modified by metamagic if the class doesn't allow it
	if (!StringToInt(Get2DAString("classes", "MetaMagicAllowed", iClass)))
		return spellsKnownUI;

	// Find the list of metamagic feats available for the PC
	int iMetaMagicAvailable = 0;
	if (GetHasFeat(FEAT_EXTEND_SPELL, oPC))
		iMetaMagicAvailable += METAMAGIC_EXTEND;
	if (GetHasFeat(FEAT_EMPOWER_SPELL, oPC))
		iMetaMagicAvailable += METAMAGIC_EMPOWER;
	if (GetHasFeat(FEAT_MAXIMIZE_SPELL, oPC))
		iMetaMagicAvailable += METAMAGIC_MAXIMIZE;
	if (GetHasFeat(FEAT_QUICKEN_SPELL, oPC))
		iMetaMagicAvailable += METAMAGIC_QUICKEN;
	if (GetHasFeat(FEAT_SILENCE_SPELL, oPC))
		iMetaMagicAvailable += METAMAGIC_SILENT;
	if (GetHasFeat(FEAT_STILL_SPELL, oPC))
		iMetaMagicAvailable += METAMAGIC_STILL;
	if (GetHasFeat(1679, oPC))	// FEAT_PERSISTENT_SPELL
		iMetaMagicAvailable += METAMAGIC_PERSISTENT;

	int bExtendDone = FALSE;
	int bEmpowerDone = FALSE;
	int bMaximizeDone = FALSE;
	int bQuickenDone = FALSE;
	int bSilentDone = FALSE;
	int bStillDone = FALSE;
	int bPersistentDone = FALSE;

	// Find the metamagic feats
	int iLoopSpellList;
	for (iLoopSpellList = 1; iLoopSpellList <= 10; iLoopSpellList++)
	{
		int iMetaMagicToApply = 0;	// Metamagic feat to apply
		int iSpellLevelMod = 0;		// Augmented spell level for the metamagic feat

		// Find the metamagic feat to apply
		if ((iMetaMagicAvailable & METAMAGIC_EXTEND) && !bExtendDone)
		{
			iMetaMagicToApply = METAMAGIC_EXTEND;
			iSpellLevelMod = StringToInt(Get2DAString("metamagic", "LevelAdjustment", JX_METAMAGIC2DA_EXTEND));
			bExtendDone = TRUE;
		}
		else if ((iMetaMagicAvailable & METAMAGIC_EMPOWER) && !bEmpowerDone)
		{
			iMetaMagicToApply = METAMAGIC_EMPOWER;
			if (GetHasFeat(FEAT_IMPROVED_EMPOWER_SPELL, oPC))
				iSpellLevelMod = StringToInt(Get2DAString("metamagic", "ImprovedLevelAdjustment", JX_METAMAGIC2DA_EMPOWER));
			else
				iSpellLevelMod = StringToInt(Get2DAString("metamagic", "LevelAdjustment", JX_METAMAGIC2DA_EMPOWER));
			bEmpowerDone = TRUE;
		}
		else if ((iMetaMagicAvailable & METAMAGIC_MAXIMIZE) && !bMaximizeDone)
		{
			iMetaMagicToApply = METAMAGIC_MAXIMIZE;
			if (GetHasFeat(FEAT_IMPROVED_MAXIMIZE_SPELL, oPC))
				iSpellLevelMod = StringToInt(Get2DAString("metamagic", "ImprovedLevelAdjustment", JX_METAMAGIC2DA_MAXIMIZE));
			else
				iSpellLevelMod = StringToInt(Get2DAString("metamagic", "LevelAdjustment", JX_METAMAGIC2DA_MAXIMIZE));
			bMaximizeDone = TRUE;
		}
		else if ((iMetaMagicAvailable & METAMAGIC_QUICKEN) && !bQuickenDone)
		{
			iMetaMagicToApply = METAMAGIC_QUICKEN;
			if (GetHasFeat(FEAT_IMPROVED_QUICKEN_SPELL, oPC))
				iSpellLevelMod = StringToInt(Get2DAString("metamagic", "ImprovedLevelAdjustment", JX_METAMAGIC2DA_QUICKEN));
			else
				iSpellLevelMod = StringToInt(Get2DAString("metamagic", "LevelAdjustment", JX_METAMAGIC2DA_QUICKEN));
			bQuickenDone = TRUE;
		}
		else if ((iMetaMagicAvailable & METAMAGIC_SILENT) && !bSilentDone)
		{
			iMetaMagicToApply = METAMAGIC_SILENT;
			iSpellLevelMod = StringToInt(Get2DAString("metamagic", "LevelAdjustment", JX_METAMAGIC2DA_SILENT));
			bSilentDone = TRUE;
		}
		else if ((iMetaMagicAvailable & METAMAGIC_STILL) && !bStillDone)
		{
			iMetaMagicToApply = METAMAGIC_STILL;
			iSpellLevelMod = StringToInt(Get2DAString("metamagic", "LevelAdjustment", JX_METAMAGIC2DA_STILL));
			bStillDone = TRUE;
		}
		else if ((iMetaMagicAvailable & METAMAGIC_PERSISTENT) && !bPersistentDone)
		{
			iMetaMagicToApply = METAMAGIC_PERSISTENT;
			iSpellLevelMod = StringToInt(Get2DAString("metamagic", "LevelAdjustment", JX_METAMAGIC2DA_PERSISTENT));
			bPersistentDone = TRUE;
		}

		// Search the spells available for the metamagic feat
		if (iMetaMagicToApply > 0)
		{
			// Find the spells that can be modified by the metamagic feat
			if ((iSpellLevel - iSpellLevelMod) >= 0)
			{
				int iSpellsCount = JXSpellsKnownGetNbSpellsForLevel(spellsKnown, iSpellLevel - iSpellLevelMod);
				int iLoopSpell;
				int bSpellFound = FALSE;
				for (iLoopSpell = 1; iLoopSpell <= iSpellsCount; iLoopSpell++)
				{
					// Get the current spell
					int iSpellId = JXSpellsKnownGetSpell(spellsKnown, iSpellLevel - iSpellLevelMod, iLoopSpell);
					// Get the possible metamagic feats for the current spell
					int iSpellMetaMagic = JXPrivateHexStringToInt(Get2DAString("spells", "MetaMagic", iSpellId));
					// The current spell can be extended => Add the spell to the current spell list
					if (iSpellMetaMagic & iMetaMagicToApply)
					{
						spellKnownUI.iSpellId = iSpellId;
						spellKnownUI.iMetaMagicFeat = iMetaMagicToApply;
						spellsKnownUI = JXSpellsKnownUIAddSpell(spellsKnownUI, iLoopSpellList, spellKnownUI);
						bSpellFound = TRUE;
					}
				}

				// Define the metamagic feat for the spell list if at least 1 spell exists
				if (bSpellFound)
					spellsKnownUI = JXSpellsKnownUISetMetaMagicFeat(spellsKnownUI, iLoopSpellList, iMetaMagicToApply);
			}
		}
	}

	return spellsKnownUI;
}

// Update the GUI screen for known spells to reflect the current data
// - oPC Player character that knowns spells
void JXUpdateGUISpellKnown(object oPC)
{
	int iCurrentClass = GetLocalInt(oPC, JX_UI_SPELLS_KNOWN_CURRENTCLASS);
	int iCurrentSpellLevel = GetLocalInt(oPC, JX_UI_SPELLS_KNOWN_CURRENTLEVEL);


	/***********************************/
	/* Display the character's classes */
	/***********************************/

	int iLoopClassPosition;
	for (iLoopClassPosition = 1; iLoopClassPosition <= 4; iLoopClassPosition++)
	{
		// Get the class at the current position
		int iClass = GetClassByPosition(iLoopClassPosition, oPC);

		// No class at the current position
		if (iClass == CLASS_TYPE_INVALID)
		{
			// Disable the class button
			SetGUIObjectDisabled(oPC, JX_SCREEN_SPELLS_KNOWN, "btnSpellClass" + IntToString(iLoopClassPosition), TRUE);
		}
		// Spellcasting class
		else if (JXGetHasSpellbook(oPC, iClass))
		{
			// Enable the class button
			SetGUIObjectDisabled(oPC, JX_SCREEN_SPELLS_KNOWN, "btnSpellClass" + IntToString(iLoopClassPosition), FALSE);
			// Set the icon for the class
			string sIcon = Get2DAString("classes", "Icon", iClass) + ".tga";
			SetGUITexture(oPC, JX_SCREEN_SPELLS_KNOWN, "btnSpellClass" + IntToString(iLoopClassPosition), sIcon);
			// Set the identifier of the class
			SetLocalGUIVariable(oPC, JX_SCREEN_SPELLS_KNOWN, iLoopClassPosition, "class_" + IntToString(iClass));
			// Set the name of the class
			string sName = GetStringByStrRef(StringToInt(Get2DAString("classes", "Name", iClass)));
			SetLocalGUIVariable(oPC, JX_SCREEN_SPELLS_KNOWN, iLoopClassPosition + 4, sName);
		}
		// Standard class
		else
		{
			// Disable the class button
			SetGUIObjectDisabled(oPC, JX_SCREEN_SPELLS_KNOWN, "btnSpellClass" + IntToString(iLoopClassPosition), TRUE);
			// Set the icon for the class
			string sIcon = Get2DAString("classes", "Icon", iClass) + ".tga";
			SetGUITexture(oPC, JX_SCREEN_SPELLS_KNOWN, "btnSpellClass" + IntToString(iLoopClassPosition), sIcon);
		}
	}

	// No class set => Hide the spell levels and the spell list
	int iLoopSpellLevel;
	if (iCurrentClass == -1)
	{
		for (iLoopSpellLevel = 0; iLoopSpellLevel <= 10; iLoopSpellLevel++)
		{
			SetGUIObjectDisabled(oPC, JX_SCREEN_SPELLS_KNOWN, "btnSpellLevel" + IntToString(iLoopSpellLevel), TRUE);
			SetGUIObjectHidden(oPC, JX_SCREEN_SPELLS_KNOWN, "clpMetamagic" + IntToString(iLoopSpellLevel), TRUE);
		}
		return;
	}
	// Class set => Print the name of the class
	else
	{
		int iName = StringToInt(Get2DAString("classes", "Name", iCurrentClass));
		SetGUIObjectText(oPC, JX_SCREEN_SPELLS_KNOWN, "txtSpellClass", iName, "");
	}


	/************************************************************************/
	/* Display the character's available spell levels for the current class */
	/************************************************************************/

	// Get the spells known by the PC for the specified class
	struct jx_spells_known spellsKnown = JXRestoreSpellsKnown(oPC, iCurrentClass);

	// Define the available spell levels
	for (iLoopSpellLevel = 0; iLoopSpellLevel <= 10; iLoopSpellLevel++)
	{
		int iNbSpells = JXSpellsKnownGetNbSpellsForLevel(spellsKnown, iLoopSpellLevel);
		if (iNbSpells <= 0)
			SetGUIObjectDisabled(oPC, JX_SCREEN_SPELLS_KNOWN, "btnSpellLevel" + IntToString(iLoopSpellLevel), TRUE);
		else
			SetGUIObjectDisabled(oPC, JX_SCREEN_SPELLS_KNOWN, "btnSpellLevel" + IntToString(iLoopSpellLevel), FALSE);
	}

	// No spell level set => Hide the the spell list
	if (iCurrentSpellLevel == -1)
	{
		for (iLoopSpellLevel = 0; iLoopSpellLevel <= 10; iLoopSpellLevel++)
			SetGUIObjectHidden(oPC, JX_SCREEN_SPELLS_KNOWN, "clpMetamagic" + IntToString(iLoopSpellLevel), TRUE);
		return;
	}


	/*********************************************************/
	/* Find the spells available for the current spell level */
	/*********************************************************/

	// Find the list of spells known for the UI
	struct jx_spells_known_ui spellsKnownUI = JXSpellsKnownUIFromSpellsKnown(oPC, iCurrentClass, spellsKnown, iCurrentSpellLevel);

	// Save the list of spells displayed
	SetLocalString(oPC, JX_UI_SPELLS_KNOWN_CURRENTLIST, JXSpellsKnownUIToString(spellsKnownUI));


	/********************************************************************/
	/* Display the normal spells known (without metamagic improvements) */
	/********************************************************************/

	// Compute the max spell level available depending on the caster's ability score
	int iSpellLevelRestriction = JXGetSpellLevelRestriction(oPC, iCurrentClass);

	// Variables used to stock spell informations
	int iSpellId;
	int iSpellName;
	string sSpellIcon;

	// Display the spell list not associated with a metamagic feat
	SetGUIObjectHidden(oPC, JX_SCREEN_SPELLS_KNOWN, "clpMetamagic0", FALSE);
	int iSpellsCount = JXSpellsKnownUIGetNbSpellsForList(spellsKnownUI, 0);
	int iLoopSpell;
	for (iLoopSpell = 1; iLoopSpell <= iSpellsCount; iLoopSpell++)
	{
		// Get the current spell
		struct jx_spell_known_ui spellKnownUI = JXSpellsKnownUIGetSpell(spellsKnownUI, 0, iLoopSpell);
		// Get the spell's icon
		sSpellIcon = Get2DAString("spells", "IconResRef", spellKnownUI.iSpellId);
		// Get the spell's name strref
		iSpellName = StringToInt(Get2DAString("spells", "Name", spellKnownUI.iSpellId));

		// Add the spell on the GUI buttons
		SetGUIObjectHidden(oPC, JX_SCREEN_SPELLS_KNOWN, "panMetamagic0Spell" + IntToString(iLoopSpell), FALSE);
		SetGUITexture(oPC, JX_SCREEN_SPELLS_KNOWN, "btnMetamagic0SpellImage" + IntToString(iLoopSpell), sSpellIcon + ".tga");
		SetGUIObjectText(oPC, JX_SCREEN_SPELLS_KNOWN, "btnMetamagic0SpellText" + IntToString(iLoopSpell), iSpellName, "");
		SetLocalGUIVariable(oPC, JX_SCREEN_SPELLS_KNOWN, 20 + iLoopSpell, GetStringByStrRef(iSpellName));

		// Disable the spell if this spell level is unavailable due to a low ability score
		if (iCurrentSpellLevel > iSpellLevelRestriction)
			SetGUIObjectDisabled(oPC, JX_SCREEN_SPELLS_KNOWN, "btnMetamagic0SpellImage" + IntToString(iLoopSpell), TRUE);
		else
			SetGUIObjectDisabled(oPC, JX_SCREEN_SPELLS_KNOWN, "btnMetamagic0SpellImage" + IntToString(iLoopSpell), FALSE);
	}

	// Hide the unused GUI buttons
	int iLoopUnused;
	for (iLoopUnused = iLoopSpell; iLoopUnused <= JX_SPBK_KNOWN_MAXSPELLS; iLoopUnused++)
		SetGUIObjectHidden(oPC, JX_SCREEN_SPELLS_KNOWN, "panMetamagic0Spell" + IntToString(iLoopUnused), TRUE);


	/********************************************************/
	/* Display the spells known improved by metamagic feats */
	/********************************************************/

	int iLoopList;
	for (iLoopList = 1; iLoopList <= 10; iLoopList++)
	{
		iSpellsCount = JXSpellsKnownUIGetNbSpellsForList(spellsKnownUI, iLoopList);

		// Hide the collapsable if no spells are defined for the current list
		if (iSpellsCount == 0)
			SetGUIObjectHidden(oPC, JX_SCREEN_SPELLS_KNOWN, "clpMetamagic" + IntToString(iLoopList), TRUE);
		// Display the spells
		else
		{
			SetGUIObjectHidden(oPC, JX_SCREEN_SPELLS_KNOWN, "clpMetamagic" + IntToString(iLoopList), FALSE);

			// Set the metamagic feat associated with the collapsable
			int iMetaMagicFeat = JXSpellsKnownUIGetMetaMagicFeat(spellsKnownUI, iLoopList);
			string sMetaMagicName;
			string sMetaMagicIcon;
			switch (iMetaMagicFeat)
			{
				case METAMAGIC_EXTEND:
					sMetaMagicName = GetStringByStrRef(293);
					sMetaMagicIcon = Get2DAString("metamagic", "IconPrefixResRef", JX_METAMAGIC2DA_EXTEND);
					break;
				case METAMAGIC_EMPOWER:
					sMetaMagicName = GetStringByStrRef(209);
					sMetaMagicIcon = Get2DAString("metamagic", "IconPrefixResRef", JX_METAMAGIC2DA_EMPOWER);
					break;
				case METAMAGIC_MAXIMIZE:
					sMetaMagicName = GetStringByStrRef(413);
					sMetaMagicIcon = Get2DAString("metamagic", "IconPrefixResRef", JX_METAMAGIC2DA_MAXIMIZE);
					break;
				case METAMAGIC_QUICKEN:
					sMetaMagicName = GetStringByStrRef(216);
					sMetaMagicIcon = Get2DAString("metamagic", "IconPrefixResRef", JX_METAMAGIC2DA_QUICKEN);
					break;
				case METAMAGIC_SILENT:
					sMetaMagicName = GetStringByStrRef(218);
					sMetaMagicIcon = Get2DAString("metamagic", "IconPrefixResRef", JX_METAMAGIC2DA_SILENT);
					break;
				case METAMAGIC_STILL:
					sMetaMagicName = GetStringByStrRef(220);
					sMetaMagicIcon = Get2DAString("metamagic", "IconPrefixResRef", JX_METAMAGIC2DA_STILL);
					break;
				case METAMAGIC_PERSISTENT:
					sMetaMagicName = GetStringByStrRef(112773);
					sMetaMagicIcon = Get2DAString("metamagic", "IconPrefixResRef", JX_METAMAGIC2DA_PERSISTENT);
					break;
				case METAMAGIC_INVOC_ELDRITCH_SPEAR:	// Eldritch Shape
					sMetaMagicName = GetStringByStrRef(182806);
					break;
				case METAMAGIC_INVOC_BESHADOWED_BLAST:	// Eldritch Essence
					sMetaMagicName = GetStringByStrRef(182805);
					break;
			}
			SetGUIObjectText(oPC, JX_SCREEN_SPELLS_KNOWN, "btnMetamagic" + IntToString(iLoopList), -1, sMetaMagicName);

			for (iLoopSpell = 1; iLoopSpell <= iSpellsCount; iLoopSpell++)
			{
				// Get the current spell
				struct jx_spell_known_ui spellKnownUI = JXSpellsKnownUIGetSpell(spellsKnownUI, iLoopList, iLoopSpell);

				// Get the spell's icon
				sSpellIcon = Get2DAString("spells", "IconResRef", spellKnownUI.iSpellId);
				// Get the spell's name strref
				iSpellName = StringToInt(Get2DAString("spells", "Name", spellKnownUI.iSpellId));

				// Eldritch Shape & Eldritch Essence (for warlocks)
				if ((iMetaMagicFeat & METAMAGIC_INVOC_ELDRITCH_SPEAR)
				 || (iMetaMagicFeat & METAMAGIC_INVOC_BESHADOWED_BLAST))
				{
					// Eldritch Shape informations
					if (spellKnownUI.iMetaMagicFeat & METAMAGIC_INVOC_ELDRITCH_SPEAR)
					{
						iSpellName = 111967;
						sSpellIcon = Get2DAString("metamagic", "IconPrefixResRef", JX_METAMAGIC2DA_ELDRITCHSPEAR);
					}
					if (spellKnownUI.iMetaMagicFeat & METAMAGIC_INVOC_HIDEOUS_BLOW)
					{
						iSpellName = 111970;
						sSpellIcon = Get2DAString("metamagic", "IconPrefixResRef", JX_METAMAGIC2DA_HIDEOUSBLOW);
					}
					if (spellKnownUI.iMetaMagicFeat & METAMAGIC_INVOC_ELDRITCH_CHAIN)
					{
						iSpellName = 111978;
						sSpellIcon = Get2DAString("metamagic", "IconPrefixResRef", JX_METAMAGIC2DA_ELDRITCHCHAIN);
					}
					if (spellKnownUI.iMetaMagicFeat & METAMAGIC_INVOC_ELDRITCH_CONE)
					{
						iSpellName = 111987;
						sSpellIcon = Get2DAString("metamagic", "IconPrefixResRef", JX_METAMAGIC2DA_ELDRITCHCONE);
					}
					if (spellKnownUI.iMetaMagicFeat & METAMAGIC_INVOC_ELDRITCH_DOOM)
					{
						iSpellName = 111993;
						sSpellIcon = Get2DAString("metamagic", "IconPrefixResRef", JX_METAMAGIC2DA_ELDRITCHDOOM);
					}

					// Eldritch Essence informations
					if (spellKnownUI.iMetaMagicFeat & METAMAGIC_INVOC_DRAINING_BLAST)
					{
						sMetaMagicName = GetStringByStrRef(111966);
						sMetaMagicIcon = Get2DAString("metamagic", "IconPrefixResRef", JX_METAMAGIC2DA_DRAININGBLAST);
					}
					if (spellKnownUI.iMetaMagicFeat & METAMAGIC_INVOC_FRIGHTFUL_BLAST)
					{
						sMetaMagicName = GetStringByStrRef(111969);
						sMetaMagicIcon = Get2DAString("metamagic", "IconPrefixResRef", JX_METAMAGIC2DA_FRIGHTFULBLAST);
					}
					if (spellKnownUI.iMetaMagicFeat & METAMAGIC_INVOC_BESHADOWED_BLAST)
					{
						sMetaMagicName = GetStringByStrRef(111973);
						sMetaMagicIcon = Get2DAString("metamagic", "IconPrefixResRef", JX_METAMAGIC2DA_BESHADOWEDBLAST);
					}
					if (spellKnownUI.iMetaMagicFeat & METAMAGIC_INVOC_BRIMSTONE_BLAST)
					{
						sMetaMagicName = GetStringByStrRef(111974);
						sMetaMagicIcon = Get2DAString("metamagic", "IconPrefixResRef", JX_METAMAGIC2DA_BRIMSTONEBLAST);
					}
					if (spellKnownUI.iMetaMagicFeat & METAMAGIC_INVOC_HELLRIME_BLAST)
					{
						sMetaMagicName = GetStringByStrRef(111980);
						sMetaMagicIcon = Get2DAString("metamagic", "IconPrefixResRef", JX_METAMAGIC2DA_HELLRIMEBLAST);
					}
					if (spellKnownUI.iMetaMagicFeat & METAMAGIC_INVOC_BEWITCHING_BLAST)
					{
						sMetaMagicName = GetStringByStrRef(111984);
						sMetaMagicIcon = Get2DAString("metamagic", "IconPrefixResRef", JX_METAMAGIC2DA_BEWITCHINGBLAST);
					}
					if (spellKnownUI.iMetaMagicFeat & METAMAGIC_INVOC_NOXIOUS_BLAST)
					{
						sMetaMagicName = GetStringByStrRef(111988);
						sMetaMagicIcon = Get2DAString("metamagic", "IconPrefixResRef", JX_METAMAGIC2DA_NOXIOUSBLAST);
					}
					if (spellKnownUI.iMetaMagicFeat & METAMAGIC_INVOC_VITRIOLIC_BLAST)
					{
						sMetaMagicName = GetStringByStrRef(111990);
						sMetaMagicIcon = Get2DAString("metamagic", "IconPrefixResRef", JX_METAMAGIC2DA_VITRIOLICBLAST);
					}
					if (spellKnownUI.iMetaMagicFeat & METAMAGIC_INVOC_UTTERDARK_BLAST)
					{
						sMetaMagicName = GetStringByStrRef(111996);
						sMetaMagicIcon = Get2DAString("metamagic", "IconPrefixResRef", JX_METAMAGIC2DA_UTTERDARKBLAST);
					}
					if (spellKnownUI.iMetaMagicFeat & METAMAGIC_INVOC_HINDERING_BLAST)
					{
						sMetaMagicName = GetStringByStrRef(196041);
						sMetaMagicIcon = Get2DAString("metamagic", "IconPrefixResRef", JX_METAMAGIC2DA_HINDERINGBLAST);
					}
					if (spellKnownUI.iMetaMagicFeat & METAMAGIC_INVOC_BINDING_BLAST)
					{
						sMetaMagicName = GetStringByStrRef(196042);
						sMetaMagicIcon = Get2DAString("metamagic", "IconPrefixResRef", JX_METAMAGIC2DA_BINDINGBLAST);
					}
				}

				// Add the spell on the GUI buttons
				SetGUIObjectHidden(oPC, JX_SCREEN_SPELLS_KNOWN, "panMetamagic" + IntToString(iLoopList) + "Spell" + IntToString(iLoopSpell), FALSE);
				SetGUITexture(oPC, JX_SCREEN_SPELLS_KNOWN, "btnMetamagic" + IntToString(iLoopList) + "SpellImage" + IntToString(iLoopSpell), sSpellIcon + ".tga");
				SetGUIObjectText(oPC, JX_SCREEN_SPELLS_KNOWN, "btnMetamagic" + IntToString(iLoopList) + "SpellText" + IntToString(iLoopSpell), -1,
								 GetStringByStrRef(iSpellName) + ", " + sMetaMagicName);
				SetGUITexture(oPC, JX_SCREEN_SPELLS_KNOWN, "icoMetamagic" + IntToString(iLoopList) + "Spell" + IntToString(iLoopSpell), sMetaMagicIcon + ".tga");
				SetLocalGUIVariable(oPC, JX_SCREEN_SPELLS_KNOWN, 100 + (iLoopList - 1) * 30 + iLoopSpell, GetStringByStrRef(iSpellName) + ", " + sMetaMagicName);
			}

			// Hide the unused GUI buttons
			for (iLoopUnused = iLoopSpell; iLoopUnused <= JX_SPBK_KNOWNMETA_MAXSPELLS; iLoopUnused++)
				SetGUIObjectHidden(oPC, JX_SCREEN_SPELLS_KNOWN, "panMetamagic" + IntToString(iLoopList) + "Spell" + IntToString(iLoopUnused), TRUE);
		}
	}
}