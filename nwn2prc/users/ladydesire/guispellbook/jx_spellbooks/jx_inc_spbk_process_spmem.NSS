//::///////////////////////////////////////////////
//:: JX Spellbook - Memorizes Spells include
//:: jx_inc_spbk_process_spmem
//:://////////////////////////////////////////////
//:://////////////////////////////////////////////
//:: Created By: jallaix
//:: Created On: Nov 16, 2007
//:://////////////////////////////////////////////
//
// This include file provides functions to manage the spells a
// player memorizes in his spellbook.
//
//:://////////////////////////////////////////////

#include "jx_inc_spbk_const"
#include "jx_inc_spbk_process_spday"
















//**************************************//
//                                      //
//              Interface               //
//                                      //
//**************************************//


// Generate a default list of memorized spells
// - sNbSpellsPerDay Number of spells per day
// * Returns a list of memorized spells
struct jx_spells_memorized JXGenerateSpellsMemorized(struct jx_spells_per_day spellsDay);

// Restore a list of memorized spells for the specified class of a PC
// - oPC Player character that has memorized spells
// - iClass Spellcasting class of the player character
// * Returns a list of memorized spells previouly saved
struct jx_spells_memorized JXRestoreSpellsMemorized(object oPC, int iClass);

// Save a list of memorized spells for the specified class of a PC
// - oPC Player character that has memorized spells
// - iClass Spellcasting class of the player character
// - sSpellsMemorized The list of memorized spells
void JXSaveSpellsMemorized(object oPC, int iClass, struct jx_spells_memorized spellsMemorized);

// Add a spell to the list of memorized spells
// - oPC Player character that has memorized spells
// - iClass Spellcasting class of the player character
// - iSpellId SPELL_* constant to add to the list
// - iSpellLevel Spell level where the spell is memorized
// - iSpellSlot Slot in the spell level where the spell is memorized (the first empty slot if -1)
void JXAddSpellMemorized(object oPC, int iClass, struct jx_spell_known_ui spellKnown, int iSpellLevel, int iSpellSlot = -1);

// Remove a spell from the list of memorized spells
// - oPC Player character that has memorized spells
// - iClass Spellcasting class of the player character
// - iSpellLevel Spell level where the spell is memorized
// - iSpellSlot Slot in the spell level where the spell is memorized
void JXRemoveSpellMemorized(object oPC, int iClass, int iSpellLevel, int iSpellSlot);

// Get a spell from the list of memorized spells
// - oPC Player character that has memorized spells
// - iClass Spellcasting class of the player character
// - iSpellLevel Spell level where the spell is memorized
// - iSpellSlot Slot in the spell level where the spell is memorized
// * Returns a SPELL_* constant
struct jx_spell_known_ui JXGetSpellMemorized(object oPC, int iClass, int iSpellLevel, int iSpellSlot);

// Update the GUI screen for memorized spells to reflect the current data
// - oPC Player character that has memorized spells
void JXUpdateGUISpellMemorized(object oPC);

















//**************************************//
//                                      //
//            Implementation            //
//                                      //
//**************************************//


// Generate a default list of memorized spells
// - sNbSpellsPerDay Number of spells per day
// * Returns a list of memorized spells
struct jx_spells_memorized JXGenerateSpellsMemorized(struct jx_spells_per_day spellsDay)
{
	struct jx_spells_memorized spellsMemorized = JXSpellsMemorizedUICreateStruct();

	// Loop upon the number of spells per day
	int iSpellLevelCount = spellsDay.iMaxSpellLevel;
	int iLoopLevel;
	for (iLoopLevel = 0; iLoopLevel <= iSpellLevelCount; iLoopLevel++)
	{
		// Find the number of spells for the current spell level
		int iNbSlot = JXSpellsDayGetNbSpells(spellsDay, iLoopLevel);
		// Define the slots for the memorized spells
		spellsMemorized = JXSpellsMemorizedUIResize(spellsMemorized, iLoopLevel, iNbSlot);
	}

	return spellsMemorized;
}

// Restore a list of memorized spells for the specified class of a PC
// - oPC Player character that has memorized spells
// - iClass Spellcasting class of the player character
// * Returns a list of memorized spells previouly saved
struct jx_spells_memorized JXRestoreSpellsMemorized(object oPC, int iClass)
{
	// Get the memorized spells for the specified class
	string sSpellsMemorized = GetLocalString(oPC, JX_SPELLS_MEMORIZED_PREFIX + IntToString(iClass));

	// If no memorized spells are found, generate an empty list
	if (sSpellsMemorized == "")
	{
		struct jx_spells_per_day spellsDay = JXGetSpellsPerDay(oPC, iClass);
		struct jx_spells_memorized spellsMemorized = JXGenerateSpellsMemorized(spellsDay);
		sSpellsMemorized = JXSpellsMemorizedUIToString(spellsMemorized);
		SetLocalString(oPC, JX_SPELLS_MEMORIZED_PREFIX + IntToString(iClass), sSpellsMemorized);
	}

	return JXStringToSpellsMemorizedUI(sSpellsMemorized);
}

// Save a list of memorized spells for the specified class of a PC
// - oPC Player character that has memorized spells
// - iClass Spellcasting class of the player character
// - sSpellsMemorized The list of memorized spells
void JXSaveSpellsMemorized(object oPC, int iClass, struct jx_spells_memorized spellsMemorized)
{
	string sSpellsMemorized = JXSpellsMemorizedUIToString(spellsMemorized);
	SetLocalString(oPC, JX_SPELLS_MEMORIZED_PREFIX + IntToString(iClass), sSpellsMemorized);
}

// Add a spell to the list of memorized spells
// - oPC Player character that has memorized spells
// - iClass Spellcasting class of the player character
// - iSpellId SPELL_* constant to add to the list
// - iSpellLevel Spell level where the spell is memorized
// - iSpellSlot Slot in the spell level where the spell is memorized (the first empty slot if -1)
void JXAddSpellMemorized(object oPC, int iClass, struct jx_spell_known_ui spellKnown, int iSpellLevel, int iSpellSlot = -1)
{
	// Get the current list of spells memorized by the PC
	struct jx_spells_memorized spellsMemorized = JXRestoreSpellsMemorized(oPC, iClass);

	// Add the new spell to the list
	spellsMemorized = JXSpellsMemorizedUIAddSpell(spellsMemorized, iSpellLevel, spellKnown, iSpellSlot);

	// Save the resulting list on the PC
	JXSaveSpellsMemorized(oPC, iClass, spellsMemorized);
}

// Remove a spell from the list of memorized spells
// - oPC Player character that has memorized spells
// - iClass Spellcasting class of the player character
// - iSpellLevel Spell level where the spell is memorized
// - iSpellSlot Slot in the spell level where the spell is memorized
void JXRemoveSpellMemorized(object oPC, int iClass, int iSpellLevel, int iSpellSlot)
{
	// Get the current list of memorized spells by the PC
	struct jx_spells_memorized spellsMemorized = JXRestoreSpellsMemorized(oPC, iClass);

	// Remove the spell from the list
	spellsMemorized = JXSpellsMemorizedUIRemoveSpell(spellsMemorized, iSpellLevel, iSpellSlot);

	// Save the resulting list on the PC
	JXSaveSpellsMemorized(oPC, iClass, spellsMemorized);
}

// Get a spell from the list of memorized spells
// - oPC Player character that has memorized spells
// - iClass Spellcasting class of the player character
// - iSpellLevel Spell level where the spell is memorized
// - iSpellSlot Slot in the spell level where the spell is memorized
// * Returns a SPELL_* constant
struct jx_spell_known_ui JXGetSpellMemorized(object oPC, int iClass, int iSpellLevel, int iSpellSlot)
{
	// Get the current list of memorized spells by the PC
	struct jx_spells_memorized spellsMemorized = JXRestoreSpellsMemorized(oPC, iClass);

	// Return the spell memorized in the specified slot
	return JXSpellsMemorizedUIGetSpell(spellsMemorized, iSpellLevel, iSpellSlot);
}

// Update the GUI screen for memorized spells to reflect the current data
// - oPC Player character that has memorized spells
void JXUpdateGUISpellMemorized(object oPC)
{
	// Get the current class
	int iCurrentClass = GetLocalInt(oPC, JX_UI_SPELLS_KNOWN_CURRENTCLASS);

	// Get the current list of spells memorized by the PC
	struct jx_spells_memorized spellsMemorized = JXRestoreSpellsMemorized(oPC, iCurrentClass);
	// Compute the max spell level available depending on the caster's ability score
	int iSpellLevelRestriction = JXGetSpellLevelRestriction(oPC, iCurrentClass);

	// Spell informations
	struct jx_spell_known_ui spellKnownUI;
	string sSpellIcon;
	string sSpellName;

	// Loop upon each spell level
	int iSpellLevelCount = spellsMemorized.iMaxSpellLevel;
	if (iSpellLevelRestriction < iSpellLevelCount)
		iSpellLevelCount = iSpellLevelRestriction;
	int iLoopLevel;
	for (iLoopLevel = 0; iLoopLevel <= iSpellLevelCount; iLoopLevel++)
	{
		int iSlotCount = JXSpellsMemorizedUIGetNbSlots(spellsMemorized, iLoopLevel);
		// Hide the memorized spell slots if no spells per day are available for this level
		if (iSlotCount == 0)
			SetGUIObjectHidden(oPC, JX_SCREEN_SPELLS_MEMORIZED, "clpSpellsLevel" + IntToString(iLoopLevel), TRUE);
		else
		{
			// Show the content of the spell level
			SetGUIObjectHidden(oPC, JX_SCREEN_SPELLS_MEMORIZED, "clpSpellsLevel" + IntToString(iLoopLevel), FALSE);

			// Loop upon each spell slot
			int iLoopSpellSlot;
			for (iLoopSpellSlot = 1; iLoopSpellSlot <= iSlotCount; iLoopSpellSlot++)
			{
				// Show the current spell slot
				SetGUIObjectHidden(oPC, JX_SCREEN_SPELLS_MEMORIZED,
					"btnSpellsLevel" + IntToString(iLoopLevel) + "_" + IntToString(iLoopSpellSlot), FALSE);

				// Get the memorized spell
				spellKnownUI = JXSpellsMemorizedUIGetSpell(spellsMemorized, iLoopLevel, iLoopSpellSlot);

				// Found a free slot
				if ((spellKnownUI.iSpellId == -1))
				{
					// Add the spell on the GUI buttons
					SetGUITexture(oPC, JX_SCREEN_SPELLS_MEMORIZED, "btnSpellsLevel" + 
								  IntToString(iLoopLevel) + "_" + IntToString(iLoopSpellSlot), "mem_spell_slot.tga");
					SetGUIObjectHidden(oPC, JX_SCREEN_SPELLS_MEMORIZED, "icoMetamagic" + 
								  IntToString(iLoopLevel) + "_" + IntToString(iLoopSpellSlot), TRUE);
				}
				// Add the current spell to the result spell list
				else
				{
					// Determine the metamagic feat associated with the current spell
					string sMetaMagicName = "";
					if (spellKnownUI.iMetaMagicFeat > 0)
					{
						string sMetaMagicIcon = "";
						switch (spellKnownUI.iMetaMagicFeat)
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
						}
						// Show the metamagic icon on the GUI button
						SetGUIObjectHidden(oPC, JX_SCREEN_SPELLS_MEMORIZED, "icoMetamagic" + 
									  IntToString(iLoopLevel) + "_" + IntToString(iLoopSpellSlot), FALSE);
						SetGUITexture(oPC, JX_SCREEN_SPELLS_MEMORIZED, "icoMetamagic" + 
									  IntToString(iLoopLevel) + "_" + IntToString(iLoopSpellSlot), sMetaMagicIcon + ".tga");
					}
					// No metamagic associated with the current spell
					else
						SetGUIObjectHidden(oPC, JX_SCREEN_SPELLS_MEMORIZED, "icoMetamagic" + 
									  IntToString(iLoopLevel) + "_" + IntToString(iLoopSpellSlot), TRUE);
	
					// Get the spell's icon
					sSpellIcon = Get2DAString("spells", "IconResRef", spellKnownUI.iSpellId);
					// Get the spell's name
					sSpellName = GetStringByStrRef(StringToInt(Get2DAString("spells", "Name", spellKnownUI.iSpellId)));
					// Add the spell to the GUI button
					SetGUITexture(oPC, JX_SCREEN_SPELLS_MEMORIZED, "btnSpellsLevel" + 
								  IntToString(iLoopLevel) + "_" + IntToString(iLoopSpellSlot), sSpellIcon + ".tga");
					// Set the tooltip for the GUI button
					SetLocalGUIVariable(oPC, JX_SCREEN_SPELLS_MEMORIZED, 20 + iLoopLevel * 20 + iLoopSpellSlot,
										sSpellName + ((sMetaMagicName == "") ? "" : ", " + sMetaMagicName));
				}
			}
			// Hide the spell slots that aren't available
			for (iLoopSpellSlot = iSlotCount + 1; iLoopSpellSlot <= JX_SPBK_MEMORIZED_MAXSPELLS; iLoopSpellSlot++)
			{
				SetGUIObjectHidden(oPC, JX_SCREEN_SPELLS_MEMORIZED,
					"btnSpellsLevel" + IntToString(iLoopLevel) + "_" + IntToString(iLoopSpellSlot), TRUE);
			}
		}
	}
	// Hide the unused spell levels
	for (iLoopLevel = iSpellLevelCount + 1; iLoopLevel <= 9; iLoopLevel++)
		SetGUIObjectHidden(oPC, JX_SCREEN_SPELLS_MEMORIZED, "clpSpellsLevel" + IntToString(iLoopLevel), TRUE);
}