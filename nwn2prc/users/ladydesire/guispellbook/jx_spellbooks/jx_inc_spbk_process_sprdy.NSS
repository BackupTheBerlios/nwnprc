//::///////////////////////////////////////////////
//:: JX Spellbook - Quick Spells include
//:: jx_inc_spbk_process_sprdy
//:://////////////////////////////////////////////
//:://////////////////////////////////////////////
//:: Created By: jallaix
//:: Created On: Nov 16, 2007
//:://////////////////////////////////////////////
//
// This include file provides functions to manage the spells
// rready to be cast in a player's spellbook.
//
//:://////////////////////////////////////////////

#include "jx_inc_spbk_process_spkwn"
#include "jx_inc_spbk_process_spmem"
#include "jx_inc_spbk_misc"
















//**************************************//
//                                      //
//              Interface               //
//                                      //
//**************************************//


// Restore a list of ready spells for the specified class of a PC
// - oPC Player character that has ready spells
// - iClass Spellcasting class of the player character
// * Returns a list of ready spells previously saved
struct jx_spells_ready JXRestoreSpellsReady(object oPC, int iClass);

// Save a list of ready spells for the specified class of a PC
// - oPC Player character that has memorized spells
// - iClass Spellcasting class of the player character
// - sSpellsReady The list of ready spells to save
void JXSaveSpellsReady(object oPC, int iClass, struct jx_spells_ready spellsReady);

// Transform a list of memorized spells in a list of spells ready to be cast
// - spellsMemorized List of memorized spells
// - iSpellLevel Spell level for which the list has to be get
// * Returns a list of spells ready to be cast
struct jx_spells_ready JXSpellsReadyFromSpellsMemorizedUI(struct jx_spells_memorized spellsMemorized, int iSpellLevel);

// Replenish the spells ready to be cast by a PC.
// N.B. : This is an asynchronous function, so if you call it in a script, the spell
//        slots will be replenished after the script terminates
// - oPC Player character with spellcasting class(es)
// - bRest Indicate if the spells slots are replenished while the PC is resting or not
void JXReplenishSpellSlots(object oPC, int bRest = TRUE);

// Update the GUI screen for quick spells to reflect the current data
// - oPC Player character that has spells ready to be cast
void JXUpdateGUISpellQuick(object oPC);

// Update the GUI screen for quick spells (radial context menu) to reflect the current data
// - oPC Player character that chose a master spell in its list of spells ready to be cast
void JXUpdateGUISpellQuickRadial(object oPC);


















//**************************************//
//                                      //
//            Implementation            //
//                                      //
//**************************************//


// Restore a list of ready spells for the specified class of a PC
// - oPC Player character that has ready spells
// - iClass Spellcasting class of the player character
// * Returns a list of ready spells previously saved
struct jx_spells_ready JXRestoreSpellsReady(object oPC, int iClass)
{
	// Get the ready spells for the specified class
	string sSpellsReady = GetLocalString(oPC, JX_SPELLS_READY_PREFIX + IntToString(iClass));
	return JXStringToSpellsReady(sSpellsReady);
}

// Save a list of ready spells for the specified class of a PC
// - oPC Player character that has memorized spells
// - iClass Spellcasting class of the player character
// - sSpellsReady The list of ready spells to save
void JXSaveSpellsReady(object oPC, int iClass, struct jx_spells_ready spellsReady)
{
	string sSpellsReady = JXSpellsReadyToString(spellsReady);
	SetLocalString(oPC, JX_SPELLS_READY_PREFIX + IntToString(iClass), sSpellsReady);
}

// Transform a list of memorized spells in a list of spells ready to be cast
// - spellsMemorized List of memorized spells
// - iSpellLevel Spell level for which the list has to be get
// * Returns a list of spells ready to be cast
struct jx_spells_ready JXSpellsReadyFromSpellsMemorizedUI(struct jx_spells_memorized spellsMemorized, int iSpellLevel)
{
	struct jx_spells_ready spellsReady = JXSpellsReadyCreateStruct();
	struct jx_spell_known_ui spellKnown;

	int iNbSpells = JXSpellsMemorizedUIGetNbSlots(spellsMemorized, iSpellLevel);
	int iLoopSpellSlot;
	for (iLoopSpellSlot = 1; iLoopSpellSlot <= iNbSpells; iLoopSpellSlot++)
	{
		spellKnown = JXSpellsMemorizedUIGetSpell(spellsMemorized, iSpellLevel, iLoopSpellSlot);
		if (spellKnown.iSpellId != -1)
		{
			int bSpellMaster = (Get2DAString("spells", "SubRadSpell1", spellKnown.iSpellId) == "") ? FALSE : TRUE;
			spellsReady = JXSpellsReadyAddSpell(spellsReady, iSpellLevel, spellKnown, bSpellMaster);
		}
	}

	return spellsReady;
}

// Replenish the spells ready to be cast by a PC.
// N.B. : This is an asynchronous function, so if you call it in a script, the spell
//        slots will be replenished after the script terminates
// - oPC Player character with spellcasting class(es)
// - bRest Indicate if the spells slots are replenished while the PC is resting or not
void JXReplenishSpellSlots(object oPC, int bRest)
{
	float iRestFrequency = 0.0;
	if (bRest)
	{
		// Get the character level of the PC
		int iPCLevel = GetTotalLevels(oPC, FALSE);
		// Get the real time (in milliseconds) necessary for the PC to complete a rest
		int iRestMillis = StringToInt(Get2DAString("restduration", "DURATION", iPCLevel));
		// Compute the frequency at which each spell level is refreshed (in seconds)
		iRestFrequency = IntToFloat(iRestMillis / 10) / 1000;
	}
	SetLocalFloat(oPC, JX_REPLENISH_FREQUENCY, iRestFrequency);

	// Erase the current lists of spells ready to cast for all spellcasting classes
	struct jx_spells_ready spellsReady = JXSpellsReadyCreateStruct();
	int iLoopPosition;
	for (iLoopPosition = 1; iLoopPosition <= 4; iLoopPosition++)
	{
		int iClass = GetClassByPosition(iLoopPosition, oPC);
		if (JXGetHasSpellbook(oPC, iClass))
			JXSaveSpellsReady(oPC, iClass, spellsReady);
	}

	// Start the replenishment of spells ready to cast
	DelayCommand(iRestFrequency, ExecuteScript("jx_spbk_replenish", oPC));
}

// Prepare metamagic informations (name)
string gsMetaMagicEmpowerName = GetStringByStrRef(JXMetaMagicGetFeatName(METAMAGIC_EMPOWER));
string gsMetaMagicExtendName = GetStringByStrRef(JXMetaMagicGetFeatName(METAMAGIC_EXTEND));
string gsMetaMagicMaximizeName = GetStringByStrRef(JXMetaMagicGetFeatName(METAMAGIC_MAXIMIZE));
string gsMetaMagicQuickenName = GetStringByStrRef(JXMetaMagicGetFeatName(METAMAGIC_QUICKEN));
string gsMetaMagicSilentName = GetStringByStrRef(JXMetaMagicGetFeatName(METAMAGIC_SILENT));
string gsMetaMagicStillName = GetStringByStrRef(JXMetaMagicGetFeatName(METAMAGIC_STILL));
string gsMetaMagicPersistentName = GetStringByStrRef(JXMetaMagicGetFeatName(METAMAGIC_PERSISTENT));
// Prepare metamagic informations (icon)
string gsMetaMagicEmpowerIcon = JXMetaMagicGetIcon(METAMAGIC_EMPOWER);
string gsMetaMagicExtendIcon = JXMetaMagicGetIcon(METAMAGIC_EXTEND);
string gsMetaMagicMaximizeIcon = JXMetaMagicGetIcon(METAMAGIC_MAXIMIZE);
string gsMetaMagicQuickenIcon = JXMetaMagicGetIcon(METAMAGIC_QUICKEN);
string gsMetaMagicSilentIcon = JXMetaMagicGetIcon(METAMAGIC_SILENT);
string gsMetaMagicStillIcon = JXMetaMagicGetIcon(METAMAGIC_STILL);
string gsMetaMagicPersistentIcon = JXMetaMagicGetIcon(METAMAGIC_PERSISTENT);

// Private function - Used to display the spell slots for a specific spell level
void JXPrivateUpdateGUISpellQuickLevel(object oPC, struct jx_spells_ready spellsReady, int iClass, int iSpellLevelPositionUI, int iSpellLevel)
{
	// Get the number of spells ready to be cast for the current spell level
	int iNbSpellSlots = JXSpellsReadyGetNbSpellsForLevel(spellsReady, iSpellLevel);

	// Show the collapsable for the current spell level as some spells are ready
	string sSpellLevelPositionUI = IntToString(iSpellLevelPositionUI);
	SetGUIObjectHidden(oPC, JX_SCREEN_SPELLS_QUICK, "clpSpellLevel" + sSpellLevelPositionUI, FALSE);
	SetGUIObjectText(oPC, JX_SCREEN_SPELLS_QUICK, "btnSpellLevel" + sSpellLevelPositionUI, -1, IntToString(iSpellLevel));
	
	// Display the spells ready to be cast
	int iLoopSpellSlot;
	for (iLoopSpellSlot = 1; iLoopSpellSlot <= iNbSpellSlots; iLoopSpellSlot++)
	{
		string sSpellIcon;
		string sSpellName;
		string sSpellMetaMagicIcon = "b_empty.tga";
	
		// Find the spell to display
		struct jx_spell_ready spellReady = JXSpellsReadyGetSpell(spellsReady, iSpellLevel, iLoopSpellSlot);
		string sLoopSpellSlot = IntToString(iLoopSpellSlot);
		string sSLSP = "SL" + sSpellLevelPositionUI + "SP" + sLoopSpellSlot;
	
		// Determine specific informations associated with metamagic
		string sMetaMagicName;
		if (spellReady.iMetaMagicFeat != 0)
		{
			if (iClass != CLASS_TYPE_WARLOCK)
			{
				// Classic metamagic
				if (spellReady.iMetaMagicFeat & METAMAGIC_EMPOWER)
				{
					sMetaMagicName = (sMetaMagicName == "" ? "" : ", ") + gsMetaMagicEmpowerName;
					sSpellMetaMagicIcon = gsMetaMagicEmpowerIcon;
				}
				if (spellReady.iMetaMagicFeat & METAMAGIC_EXTEND)
				{
					sMetaMagicName = (sMetaMagicName == "" ? "" : ", ") + gsMetaMagicExtendName;
					sSpellMetaMagicIcon = gsMetaMagicExtendIcon;
				}
				if (spellReady.iMetaMagicFeat & METAMAGIC_MAXIMIZE)
				{
					sMetaMagicName = (sMetaMagicName == "" ? "" : ", ") + gsMetaMagicMaximizeName;
					sSpellMetaMagicIcon = gsMetaMagicMaximizeIcon;
				}
				if (spellReady.iMetaMagicFeat & METAMAGIC_QUICKEN)
				{
					sMetaMagicName = (sMetaMagicName == "" ? "" : ", ") + gsMetaMagicQuickenName;
					sSpellMetaMagicIcon = gsMetaMagicQuickenIcon;
				}
				if (spellReady.iMetaMagicFeat & METAMAGIC_SILENT)
				{
					sMetaMagicName = (sMetaMagicName == "" ? "" : ", ") + gsMetaMagicSilentName;
					sSpellMetaMagicIcon = gsMetaMagicSilentIcon;
				}
				if (spellReady.iMetaMagicFeat & METAMAGIC_STILL)
				{
					sMetaMagicName = (sMetaMagicName == "" ? "" : ", ") + gsMetaMagicStillName;
					sSpellMetaMagicIcon = gsMetaMagicStillIcon;
				}
				if (spellReady.iMetaMagicFeat & METAMAGIC_PERSISTENT)
				{
					sMetaMagicName = (sMetaMagicName == "" ? "" : ", ") + gsMetaMagicPersistentName;
					sSpellMetaMagicIcon = gsMetaMagicPersistentIcon;
				}
			}
			else
			{
				// Warlock essences
				if (spellReady.iMetaMagicFeat & METAMAGIC_INVOC_DRAINING_BLAST)
				{
					sMetaMagicName = (sMetaMagicName == "" ? "" : ", ") + GetStringByStrRef(JXMetaMagicGetFeatName(METAMAGIC_INVOC_DRAINING_BLAST));
					sSpellMetaMagicIcon = JXMetaMagicGetIcon(METAMAGIC_INVOC_DRAINING_BLAST);
				}
				if (spellReady.iMetaMagicFeat & METAMAGIC_INVOC_FRIGHTFUL_BLAST)
				{
					sMetaMagicName = (sMetaMagicName == "" ? "" : ", ") + GetStringByStrRef(JXMetaMagicGetFeatName(METAMAGIC_INVOC_FRIGHTFUL_BLAST));
					sSpellMetaMagicIcon = JXMetaMagicGetIcon(METAMAGIC_INVOC_FRIGHTFUL_BLAST);
				}
				if (spellReady.iMetaMagicFeat & METAMAGIC_INVOC_BESHADOWED_BLAST)
				{
					sMetaMagicName = (sMetaMagicName == "" ? "" : ", ") + GetStringByStrRef(JXMetaMagicGetFeatName(METAMAGIC_INVOC_BESHADOWED_BLAST));
					sSpellMetaMagicIcon = JXMetaMagicGetIcon(METAMAGIC_INVOC_BESHADOWED_BLAST);
				}
				if (spellReady.iMetaMagicFeat & METAMAGIC_INVOC_BRIMSTONE_BLAST)
				{
					sMetaMagicName = (sMetaMagicName == "" ? "" : ", ") + GetStringByStrRef(JXMetaMagicGetFeatName(METAMAGIC_INVOC_BRIMSTONE_BLAST));
					sSpellMetaMagicIcon = JXMetaMagicGetIcon(METAMAGIC_INVOC_BRIMSTONE_BLAST);
				}
				if (spellReady.iMetaMagicFeat & METAMAGIC_INVOC_HELLRIME_BLAST)
				{
					sMetaMagicName = (sMetaMagicName == "" ? "" : ", ") + GetStringByStrRef(JXMetaMagicGetFeatName(METAMAGIC_INVOC_HELLRIME_BLAST));
					sSpellMetaMagicIcon = JXMetaMagicGetIcon(METAMAGIC_INVOC_HELLRIME_BLAST);
				}
				if (spellReady.iMetaMagicFeat & METAMAGIC_INVOC_BEWITCHING_BLAST)
				{
					sMetaMagicName = (sMetaMagicName == "" ? "" : ", ") + GetStringByStrRef(JXMetaMagicGetFeatName(METAMAGIC_INVOC_BEWITCHING_BLAST));
					sSpellMetaMagicIcon = JXMetaMagicGetIcon(METAMAGIC_INVOC_BEWITCHING_BLAST);
				}
				if (spellReady.iMetaMagicFeat & METAMAGIC_INVOC_NOXIOUS_BLAST)
				{
					sMetaMagicName = (sMetaMagicName == "" ? "" : ", ") + GetStringByStrRef(JXMetaMagicGetFeatName(METAMAGIC_INVOC_NOXIOUS_BLAST));
					sSpellMetaMagicIcon = JXMetaMagicGetIcon(METAMAGIC_INVOC_NOXIOUS_BLAST);
				}
				if (spellReady.iMetaMagicFeat & METAMAGIC_INVOC_VITRIOLIC_BLAST)
				{
					sMetaMagicName = (sMetaMagicName == "" ? "" : ", ") + GetStringByStrRef(JXMetaMagicGetFeatName(METAMAGIC_INVOC_VITRIOLIC_BLAST));
					sSpellMetaMagicIcon = JXMetaMagicGetIcon(METAMAGIC_INVOC_VITRIOLIC_BLAST);
				}
				if (spellReady.iMetaMagicFeat & METAMAGIC_INVOC_UTTERDARK_BLAST)
				{
					sMetaMagicName = (sMetaMagicName == "" ? "" : ", ") + GetStringByStrRef(JXMetaMagicGetFeatName(METAMAGIC_INVOC_UTTERDARK_BLAST));
					sSpellMetaMagicIcon = JXMetaMagicGetIcon(METAMAGIC_INVOC_UTTERDARK_BLAST);
				}
				if (spellReady.iMetaMagicFeat & METAMAGIC_INVOC_HINDERING_BLAST)
				{
					sMetaMagicName = (sMetaMagicName == "" ? "" : ", ") + GetStringByStrRef(JXMetaMagicGetFeatName(METAMAGIC_INVOC_HINDERING_BLAST));
					sSpellMetaMagicIcon = JXMetaMagicGetIcon(METAMAGIC_INVOC_HINDERING_BLAST);
				}
				if (spellReady.iMetaMagicFeat & METAMAGIC_INVOC_BINDING_BLAST)
				{
					sMetaMagicName = (sMetaMagicName == "" ? "" : ", ") + GetStringByStrRef(JXMetaMagicGetFeatName(METAMAGIC_INVOC_BINDING_BLAST));
					sSpellMetaMagicIcon = JXMetaMagicGetIcon(METAMAGIC_INVOC_BINDING_BLAST);
				}
			}
		}
		// Get the spell's icon
		if (sSpellIcon == "")
			sSpellIcon = Get2DAString("spells", "IconResRef", spellReady.iSpellId) + ".tga";
		// Get the spell's name
		if (sSpellName == "")
			sSpellName = JXGetSpellName(spellReady.iSpellId);
		if (sMetaMagicName != "")
			sSpellName += " (" + sMetaMagicName + ")";
	
		// The spell is not a master spell => Prepare an "action" button
		if (spellReady.bMaster == FALSE)
		{
			// Hide the "master spell" button
			SetGUIObjectHidden(oPC, JX_SCREEN_SPELLS_QUICK, "btnRadial" + sSLSP, TRUE);
	
			// Get the spell properties
			int iTargetType = JXPrivateHexStringToInt(Get2DAString("spells", "TargetType", spellReady.iSpellId));
			int iSpellTarget = StringToInt(Get2DAString("spells", "TargetingUI", spellReady.iSpellId));
			if ((iSpellTarget == 3) || (iSpellTarget == 4) || (iSpellTarget == 5) || (iSpellTarget == 12) || (iSpellTarget == 16))
				iSpellTarget = 0;	// As cone and bolt target UI crash the game, assume a simple one
			int iHostile = StringToInt(Get2DAString("spells", "HostileSetting", spellReady.iSpellId));
	
			// Show the "classic spell" button for the spell target and hide the others
			int iLoopTarget;
			for (iLoopTarget = 0; iLoopTarget < 20; iLoopTarget++)
				SetGUIObjectHidden(oPC, JX_SCREEN_SPELLS_QUICK, "btn" + sSLSP + "TG" + IntToString(iLoopTarget),
								   (iLoopTarget == iSpellTarget) ? FALSE : TRUE);
			// Add the spell on the GUI buttons
			SetGUITexture(oPC, JX_SCREEN_SPELLS_QUICK, "btn" + sSLSP + "TG" + IntToString(iSpellTarget), sSpellIcon);
			// Define the number of spells used for the day
			SetGUIObjectText(oPC, JX_SCREEN_SPELLS_QUICK, "btn" + sSLSP + "TG" + IntToString(iSpellTarget),
							 -1, "       " + (spellReady.iNbUses == -2 ? "" : IntToString(spellReady.iNbUses)) + " ");
			// Set the metamagic icon
			SetGUITexture(oPC, JX_SCREEN_SPELLS_QUICK, "icoMetamagic" + sSLSP, sSpellMetaMagicIcon);
			// Disable the button if there are no uses left for the current spell
			SetGUIObjectDisabled(oPC, JX_SCREEN_SPELLS_QUICK, "btn" + sSLSP + "TG" + IntToString(iSpellTarget),
								 (spellReady.iNbUses == 0) ? TRUE : FALSE);
	
			// Define the spell properties for the button
			string sTargetType = "";
			if (iTargetType & 1) sTargetType += "self,";
			if (iTargetType & 2) sTargetType += "creature,";
			if (iTargetType & 4) sTargetType += "ground,";
			if (iTargetType & 8) sTargetType += "item,";
			if (iTargetType & 16) sTargetType += "door,";
			if (iTargetType & 32) sTargetType += "placeable,";
			if (iTargetType & 64) sTargetType += "trigger,";
			sTargetType = GetStringLeft(sTargetType, GetStringLength(sTargetType) - 1);
			string sHostile = (iHostile == 1) ? "true" : "false";
	
			// Set the spell properties for the button
			int iVariableValue = 10 + iSpellLevelPositionUI * 60 + (iLoopSpellSlot - 1) * 3;
			SetLocalGUIVariable(oPC, JX_SCREEN_SPELLS_QUICK, iVariableValue, sTargetType);
			SetLocalGUIVariable(oPC, JX_SCREEN_SPELLS_QUICK, iVariableValue + 1, sHostile);
			SetLocalGUIVariable(oPC, JX_SCREEN_SPELLS_QUICK, iVariableValue + 2, sSpellName);
		}
		// The spell is a master spell => Prepare a "radial" button
		else
		{
				// Hide the "classic spell" buttons
				int iLoopTarget;
				for (iLoopTarget = 0; iLoopTarget < 20; iLoopTarget++)
					SetGUIObjectHidden(oPC, JX_SCREEN_SPELLS_QUICK, "btn" + sSLSP + "TG" + IntToString(iLoopTarget), TRUE);
				// Show the "master spell" button
				SetGUIObjectHidden(oPC, JX_SCREEN_SPELLS_QUICK, "btnRadial" + sSLSP, FALSE);

				// Add the spell on the GUI buttons
				SetGUITexture(oPC, JX_SCREEN_SPELLS_QUICK, "btnRadial" + sSLSP, sSpellIcon);
				// Define the number of spells used for the day
				SetGUIObjectText(oPC, JX_SCREEN_SPELLS_QUICK, "btnRadial" + sSLSP, -1,
								 "       " + (spellReady.iNbUses == -2 ? "" : IntToString(spellReady.iNbUses)) + " ");
				// Set the metamagic icon
				SetGUITexture(oPC, JX_SCREEN_SPELLS_QUICK, "icoMetamagic" + sSLSP, sSpellMetaMagicIcon);
				// Disable the button if there are no uses left for the current spell
				if (spellReady.iNbUses == 0)
					SetGUIObjectDisabled(oPC, JX_SCREEN_SPELLS_QUICK, "btnRadial" + sSLSP, TRUE);
				else
					SetGUIObjectDisabled(oPC, JX_SCREEN_SPELLS_QUICK, "btnRadial" + sSLSP, FALSE);
	
				// Set the spell properties for the button
				int iName = StringToInt(Get2DAString("spells", "Name", spellReady.iSpellId));
				int iVariableValue = 10 + iSpellLevelPositionUI * 60 + (iLoopSpellSlot - 1) * 3;
				SetLocalGUIVariable(oPC, JX_SCREEN_SPELLS_QUICK, iVariableValue + 2, GetStringByStrRef(iName));
		}
	}
	
	// Hide the buttons not used for the spell level
	for (iLoopSpellSlot = iNbSpellSlots + 1; iLoopSpellSlot <= JX_SPBK_READY_MAXSPELLS; iLoopSpellSlot++)
	{
		string sLoopSpellSlot = IntToString(iLoopSpellSlot);
		string sSLSP = "SL" + sSpellLevelPositionUI + "SP" + sLoopSpellSlot;
		int iLoopTarget;
		for (iLoopTarget = 0; iLoopTarget < 20; iLoopTarget++)
		{
			SetGUIObjectHidden(oPC, JX_SCREEN_SPELLS_QUICK, "btn" + sSLSP + "TG" + IntToString(iLoopTarget), TRUE);
			SetGUITexture(oPC, JX_SCREEN_SPELLS_QUICK, "icoMetamagic" + sSLSP, "b_empty.tga");
		}
		SetGUIObjectHidden(oPC, JX_SCREEN_SPELLS_QUICK, "btnRadial" + sSLSP, TRUE);
	}
}

// Private function - Used to display the spell slots
void JXPrivateUpdateGUISpellQuick(object oPC, struct jx_spells_ready spellsReady, int iClass)
{
	// Loop through the spell levels to determine the spells to be displayed
	int iSpellLevelPositionUI = 0;
	int iLoopSpellLevel;
	for (iLoopSpellLevel = 0; iLoopSpellLevel <= spellsReady.iMaxSpellLevel; iLoopSpellLevel++)
	{
		// Search spells for the next spell level because no spells are ready for the current spell level
		if (JXSpellsReadyGetNbSpellsForLevel(spellsReady, iLoopSpellLevel) == 0)
			continue;

		DelayCommand(0.0, JXPrivateUpdateGUISpellQuickLevel(oPC, spellsReady, iClass, iSpellLevelPositionUI, iLoopSpellLevel));

		iSpellLevelPositionUI++;
	}
	// Hide the collapsable for the levels that don't have ready spells
	for (iLoopSpellLevel = iSpellLevelPositionUI; iLoopSpellLevel <= 9; iLoopSpellLevel++)
		SetGUIObjectHidden(oPC, JX_SCREEN_SPELLS_QUICK, "clpSpellLevel" + IntToString(iLoopSpellLevel), TRUE);
}

// Update the GUI screen for quick spells to reflect the current data
// - oPC Player character that has spells ready to be cast
void JXUpdateGUISpellQuick(object oPC)
{
	int iCurrentClass = GetLocalInt(oPC, JX_UI_SPELLS_QUICK_CURRENTCLASS);
	int iCurrentMetaMagic = GetLocalInt(oPC, JX_UI_SPELLS_QUICK_CURRENTMETAMAGIC);


	/***************************************************/
	/* Display the classes associated with a spellbook */
	/***************************************************/

	int iClassPositionUI = 1;
	int iLoopClassPosition;
	for (iLoopClassPosition = 1; iLoopClassPosition <= 4; iLoopClassPosition++)
	{
		// Get the class for the current position
		int iClass = GetClassByPosition(iLoopClassPosition, oPC);
		// Spellbook defined for the class
		if (JXGetHasSpellbook(oPC, iClass))
		{
			// Show the class button
			SetGUIObjectHidden(oPC, JX_SCREEN_SPELLS_QUICK, "btnClass" + IntToString(iClassPositionUI), FALSE);
			// Display the icon for the current class
			string sClassIcon = Get2DAString("classes", "Icon", iClass) + ".tga";
			int iClassName= StringToInt(Get2DAString("classes", "Name", iClass));
			SetGUITexture(oPC, JX_SCREEN_SPELLS_QUICK, "btnClass" + IntToString(iClassPositionUI), sClassIcon);
			SetLocalGUIVariable(oPC, JX_SCREEN_SPELLS_QUICK, 1000 + iClassPositionUI, GetStringByStrRef(iClassName));
			iClassPositionUI++;
		}
	}
	// Hide the unused class buttons
	for (iLoopClassPosition = iClassPositionUI; iLoopClassPosition <= 4; iLoopClassPosition++)
		SetGUIObjectHidden(oPC, JX_SCREEN_SPELLS_QUICK, "btnClass" + IntToString(iLoopClassPosition), TRUE);

	// Set the name of the class
	int iClassName = StringToInt(Get2DAString("classes", "Name", iCurrentClass));
	SetGUIObjectText(oPC, JX_SCREEN_SPELLS_QUICK, "btnClass", iClassName, "");

	// As no class is selected, the metamagic feats and the spell list are hidden
	if (iCurrentClass == -1)
	{
		SetGUIObjectHidden(oPC, JX_SCREEN_SPELLS_QUICK, "panMetaMagic", TRUE);
		SetGUIObjectHidden(oPC, JX_SCREEN_SPELLS_QUICK, "lstQuickSpell", TRUE);
		return;
	}
	else
	{
		SetGUIObjectHidden(oPC, JX_SCREEN_SPELLS_QUICK, "panMetaMagic", FALSE);
		SetGUIObjectHidden(oPC, JX_SCREEN_SPELLS_QUICK, "lstQuickSpell", FALSE);
	}


	/*****************************************************/
	/* Display the metamagic feats for the current class */
	/*****************************************************/

	// Search metamagic feats if the class allows them
	if (StringToInt(Get2DAString("classes", "MetaMagicAllowed", iCurrentClass)))
	{
		// Display the metamagic feats possessed by the PC
		int iButtonMetaMagic = 1;
		string sMetaMagicIcon;
		int iMetaMagicName;
		if (GetHasFeat(FEAT_EXTEND_SPELL, oPC))
		{
			sMetaMagicIcon = JXMetaMagicGetFeatIcon(METAMAGIC_EXTEND);
			iMetaMagicName = JXMetaMagicGetFeatName(METAMAGIC_EXTEND);
			SetGUIObjectDisabled(oPC, JX_SCREEN_SPELLS_QUICK, "btnMetaMagic" + IntToString(iButtonMetaMagic), FALSE);
			SetGUITexture(oPC, JX_SCREEN_SPELLS_QUICK, "btnMetaMagic" + IntToString(iButtonMetaMagic), sMetaMagicIcon);
			SetLocalGUIVariable(oPC, JX_SCREEN_SPELLS_QUICK, 1010 + iButtonMetaMagic, GetStringByStrRef(iMetaMagicName));
			iButtonMetaMagic++;
		}
		if (GetHasFeat(FEAT_EMPOWER_SPELL, oPC))
		{
			sMetaMagicIcon = JXMetaMagicGetFeatIcon(METAMAGIC_EMPOWER);
			iMetaMagicName = JXMetaMagicGetFeatName(METAMAGIC_EMPOWER);
			SetGUIObjectDisabled(oPC, JX_SCREEN_SPELLS_QUICK, "btnMetaMagic" + IntToString(iButtonMetaMagic), FALSE);
			SetGUITexture(oPC, JX_SCREEN_SPELLS_QUICK, "btnMetaMagic" + IntToString(iButtonMetaMagic), sMetaMagicIcon);
			SetLocalGUIVariable(oPC, JX_SCREEN_SPELLS_QUICK, 1010 + iButtonMetaMagic, GetStringByStrRef(iMetaMagicName));
			iButtonMetaMagic++;
		}
		if (GetHasFeat(FEAT_MAXIMIZE_SPELL, oPC))
		{
			sMetaMagicIcon = JXMetaMagicGetFeatIcon(METAMAGIC_MAXIMIZE);
			iMetaMagicName = JXMetaMagicGetFeatName(METAMAGIC_MAXIMIZE);
			SetGUIObjectDisabled(oPC, JX_SCREEN_SPELLS_QUICK, "btnMetaMagic" + IntToString(iButtonMetaMagic), FALSE);
			SetGUITexture(oPC, JX_SCREEN_SPELLS_QUICK, "btnMetaMagic" + IntToString(iButtonMetaMagic), sMetaMagicIcon);
			SetLocalGUIVariable(oPC, JX_SCREEN_SPELLS_QUICK, 1010 + iButtonMetaMagic, GetStringByStrRef(iMetaMagicName));
			iButtonMetaMagic++;
		}
		if (GetHasFeat(FEAT_QUICKEN_SPELL, oPC))
		{
			sMetaMagicIcon = JXMetaMagicGetFeatIcon(METAMAGIC_QUICKEN);
			iMetaMagicName = JXMetaMagicGetFeatName(METAMAGIC_QUICKEN);
			SetGUIObjectDisabled(oPC, JX_SCREEN_SPELLS_QUICK, "btnMetaMagic" + IntToString(iButtonMetaMagic), FALSE);
			SetGUITexture(oPC, JX_SCREEN_SPELLS_QUICK, "btnMetaMagic" + IntToString(iButtonMetaMagic), sMetaMagicIcon);
			SetLocalGUIVariable(oPC, JX_SCREEN_SPELLS_QUICK, 1010 + iButtonMetaMagic, GetStringByStrRef(iMetaMagicName));
			iButtonMetaMagic++;
		}
		if (GetHasFeat(FEAT_SILENCE_SPELL, oPC))
		{
			sMetaMagicIcon = JXMetaMagicGetFeatIcon(METAMAGIC_SILENT);
			iMetaMagicName = JXMetaMagicGetFeatName(METAMAGIC_SILENT);
			SetGUIObjectDisabled(oPC, JX_SCREEN_SPELLS_QUICK, "btnMetaMagic" + IntToString(iButtonMetaMagic), FALSE);
			SetGUITexture(oPC, JX_SCREEN_SPELLS_QUICK, "btnMetaMagic" + IntToString(iButtonMetaMagic), sMetaMagicIcon);
			SetLocalGUIVariable(oPC, JX_SCREEN_SPELLS_QUICK, 1010 + iButtonMetaMagic, GetStringByStrRef(iMetaMagicName));
			iButtonMetaMagic++;
		}
		if (GetHasFeat(FEAT_STILL_SPELL, oPC))
		{
			sMetaMagicIcon = JXMetaMagicGetFeatIcon(METAMAGIC_STILL);
			iMetaMagicName = JXMetaMagicGetFeatName(METAMAGIC_STILL);
			SetGUIObjectDisabled(oPC, JX_SCREEN_SPELLS_QUICK, "btnMetaMagic" + IntToString(iButtonMetaMagic), FALSE);
			SetGUITexture(oPC, JX_SCREEN_SPELLS_QUICK, "btnMetaMagic" + IntToString(iButtonMetaMagic), sMetaMagicIcon);
			SetLocalGUIVariable(oPC, JX_SCREEN_SPELLS_QUICK, 1010 + iButtonMetaMagic, GetStringByStrRef(iMetaMagicName));
			iButtonMetaMagic++;
		}
		if (GetHasFeat(1679, oPC))	// FEAT_PERSISTENT_SPELL
		{
			sMetaMagicIcon = JXMetaMagicGetFeatIcon(METAMAGIC_PERSISTENT);
			iMetaMagicName = JXMetaMagicGetFeatName(METAMAGIC_PERSISTENT);
			SetGUIObjectDisabled(oPC, JX_SCREEN_SPELLS_QUICK, "btnMetaMagic" + IntToString(iButtonMetaMagic), FALSE);
			SetGUITexture(oPC, JX_SCREEN_SPELLS_QUICK, "btnMetaMagic" + IntToString(iButtonMetaMagic), sMetaMagicIcon);
			SetLocalGUIVariable(oPC, JX_SCREEN_SPELLS_QUICK, 1010 + iButtonMetaMagic, GetStringByStrRef(iMetaMagicName));
			iButtonMetaMagic++;
		}
		// Disable the unused buttons
		int iLoopMetaMagic;
		for (iLoopMetaMagic = iButtonMetaMagic; iLoopMetaMagic <= 12; iLoopMetaMagic++)
			SetGUIObjectDisabled(oPC, JX_SCREEN_SPELLS_QUICK, "btnMetaMagic" + IntToString(iLoopMetaMagic), TRUE);
	}
	// Warlock is a special case : Essences and invocations are treated like metamagic feats
	else if (iCurrentClass == CLASS_TYPE_WARLOCK)
	{
		struct jx_spells_known spellsKnown = JXRestoreSpellsKnown(oPC, iCurrentClass);

		// Display the shapes known by the warlock
		int iButtonMetaMagic = 1;
		string sMetaMagicIcon;
		int iMetaMagicName;
		if (JXSpellsKnownContainsSpell(spellsKnown, SPELL_I_ELDRITCH_SPEAR))
		{
			sMetaMagicIcon = JXMetaMagicGetFeatIcon(METAMAGIC_INVOC_ELDRITCH_SPEAR);
			iMetaMagicName = JXMetaMagicGetFeatName(METAMAGIC_INVOC_ELDRITCH_SPEAR);
			SetGUIObjectDisabled(oPC, JX_SCREEN_SPELLS_QUICK, "btnMetaMagic" + IntToString(iButtonMetaMagic), FALSE);
			SetGUITexture(oPC, JX_SCREEN_SPELLS_QUICK, "btnMetaMagic" + IntToString(iButtonMetaMagic), sMetaMagicIcon);
			SetLocalGUIVariable(oPC, JX_SCREEN_SPELLS_QUICK, 1010 + iButtonMetaMagic, GetStringByStrRef(iMetaMagicName));
			iButtonMetaMagic++;
		}
		if (JXSpellsKnownContainsSpell(spellsKnown, SPELL_I_HIDEOUS_BLOW))
		{
			sMetaMagicIcon = JXMetaMagicGetFeatIcon(METAMAGIC_INVOC_HIDEOUS_BLOW);
			iMetaMagicName = JXMetaMagicGetFeatName(METAMAGIC_INVOC_HIDEOUS_BLOW);
			SetGUIObjectDisabled(oPC, JX_SCREEN_SPELLS_QUICK, "btnMetaMagic" + IntToString(iButtonMetaMagic), FALSE);
			SetGUITexture(oPC, JX_SCREEN_SPELLS_QUICK, "btnMetaMagic" + IntToString(iButtonMetaMagic), sMetaMagicIcon);
			SetLocalGUIVariable(oPC, JX_SCREEN_SPELLS_QUICK, 1010 + iButtonMetaMagic, GetStringByStrRef(iMetaMagicName));
			iButtonMetaMagic++;
		}
		if (JXSpellsKnownContainsSpell(spellsKnown, SPELL_I_ELDRITCH_CHAIN))
		{
			sMetaMagicIcon = JXMetaMagicGetFeatIcon(METAMAGIC_INVOC_ELDRITCH_CHAIN);
			iMetaMagicName = JXMetaMagicGetFeatName(METAMAGIC_INVOC_ELDRITCH_CHAIN);
			SetGUIObjectDisabled(oPC, JX_SCREEN_SPELLS_QUICK, "btnMetaMagic" + IntToString(iButtonMetaMagic), FALSE);
			SetGUITexture(oPC, JX_SCREEN_SPELLS_QUICK, "btnMetaMagic" + IntToString(iButtonMetaMagic), sMetaMagicIcon);
			SetLocalGUIVariable(oPC, JX_SCREEN_SPELLS_QUICK, 1010 + iButtonMetaMagic, GetStringByStrRef(iMetaMagicName));
			iButtonMetaMagic++;
		}
		if (JXSpellsKnownContainsSpell(spellsKnown, SPELL_I_ELDRITCH_CONE))
		{
			sMetaMagicIcon = JXMetaMagicGetFeatIcon(METAMAGIC_INVOC_ELDRITCH_CONE);
			iMetaMagicName = JXMetaMagicGetFeatName(METAMAGIC_INVOC_ELDRITCH_CONE);
			SetGUIObjectDisabled(oPC, JX_SCREEN_SPELLS_QUICK, "btnMetaMagic" + IntToString(iButtonMetaMagic), FALSE);
			SetGUITexture(oPC, JX_SCREEN_SPELLS_QUICK, "btnMetaMagic" + IntToString(iButtonMetaMagic), sMetaMagicIcon);
			SetLocalGUIVariable(oPC, JX_SCREEN_SPELLS_QUICK, 1010 + iButtonMetaMagic, GetStringByStrRef(iMetaMagicName));
			iButtonMetaMagic++;
		}
		if (JXSpellsKnownContainsSpell(spellsKnown, SPELL_I_ELDRITCH_DOOM))
		{
			sMetaMagicIcon = JXMetaMagicGetFeatIcon(METAMAGIC_INVOC_ELDRITCH_DOOM);
			iMetaMagicName = JXMetaMagicGetFeatName(METAMAGIC_INVOC_ELDRITCH_DOOM);
			SetGUIObjectDisabled(oPC, JX_SCREEN_SPELLS_QUICK, "btnMetaMagic" + IntToString(iButtonMetaMagic), FALSE);
			SetGUITexture(oPC, JX_SCREEN_SPELLS_QUICK, "btnMetaMagic" + IntToString(iButtonMetaMagic), sMetaMagicIcon);
			SetLocalGUIVariable(oPC, JX_SCREEN_SPELLS_QUICK, 1010 + iButtonMetaMagic, GetStringByStrRef(iMetaMagicName));
			iButtonMetaMagic++;
		}
		// Display the invocations known by the warlock
		if (JXSpellsKnownContainsSpell(spellsKnown, SPELL_I_DRAINING_BLAST))
		{
			sMetaMagicIcon = JXMetaMagicGetFeatIcon(METAMAGIC_INVOC_DRAINING_BLAST);
			iMetaMagicName = JXMetaMagicGetFeatName(METAMAGIC_INVOC_DRAINING_BLAST);
			SetGUIObjectDisabled(oPC, JX_SCREEN_SPELLS_QUICK, "btnMetaMagic" + IntToString(iButtonMetaMagic), FALSE);
			SetGUITexture(oPC, JX_SCREEN_SPELLS_QUICK, "btnMetaMagic" + IntToString(iButtonMetaMagic), sMetaMagicIcon);
			SetLocalGUIVariable(oPC, JX_SCREEN_SPELLS_QUICK, 1010 + iButtonMetaMagic, GetStringByStrRef(iMetaMagicName));
			iButtonMetaMagic++;
		}
		if (JXSpellsKnownContainsSpell(spellsKnown, SPELL_I_FRIGHTFUL_BLAST))
		{
			sMetaMagicIcon = JXMetaMagicGetFeatIcon(METAMAGIC_INVOC_FRIGHTFUL_BLAST);
			iMetaMagicName = JXMetaMagicGetFeatName(METAMAGIC_INVOC_FRIGHTFUL_BLAST);
			SetGUIObjectDisabled(oPC, JX_SCREEN_SPELLS_QUICK, "btnMetaMagic" + IntToString(iButtonMetaMagic), FALSE);
			SetGUITexture(oPC, JX_SCREEN_SPELLS_QUICK, "btnMetaMagic" + IntToString(iButtonMetaMagic), sMetaMagicIcon);
			SetLocalGUIVariable(oPC, JX_SCREEN_SPELLS_QUICK, 1010 + iButtonMetaMagic, GetStringByStrRef(iMetaMagicName));
			iButtonMetaMagic++;
		}
		if (JXSpellsKnownContainsSpell(spellsKnown, SPELL_I_BESHADOWED_BLAST))
		{
			sMetaMagicIcon = JXMetaMagicGetFeatIcon(METAMAGIC_INVOC_BESHADOWED_BLAST);
			iMetaMagicName = JXMetaMagicGetFeatName(METAMAGIC_INVOC_BESHADOWED_BLAST);
			SetGUIObjectDisabled(oPC, JX_SCREEN_SPELLS_QUICK, "btnMetaMagic" + IntToString(iButtonMetaMagic), FALSE);
			SetGUITexture(oPC, JX_SCREEN_SPELLS_QUICK, "btnMetaMagic" + IntToString(iButtonMetaMagic), sMetaMagicIcon);
			SetLocalGUIVariable(oPC, JX_SCREEN_SPELLS_QUICK, 1010 + iButtonMetaMagic, GetStringByStrRef(iMetaMagicName));
			iButtonMetaMagic++;
		}
		if (JXSpellsKnownContainsSpell(spellsKnown, SPELL_I_BRIMSTONE_BLAST))
		{
			sMetaMagicIcon = JXMetaMagicGetFeatIcon(METAMAGIC_INVOC_BRIMSTONE_BLAST);
			iMetaMagicName = JXMetaMagicGetFeatName(METAMAGIC_INVOC_BRIMSTONE_BLAST);
			SetGUIObjectDisabled(oPC, JX_SCREEN_SPELLS_QUICK, "btnMetaMagic" + IntToString(iButtonMetaMagic), FALSE);
			SetGUITexture(oPC, JX_SCREEN_SPELLS_QUICK, "btnMetaMagic" + IntToString(iButtonMetaMagic), sMetaMagicIcon);
			SetLocalGUIVariable(oPC, JX_SCREEN_SPELLS_QUICK, 1010 + iButtonMetaMagic, GetStringByStrRef(iMetaMagicName));
			iButtonMetaMagic++;
		}
		if (JXSpellsKnownContainsSpell(spellsKnown, SPELL_I_HELLRIME_BLAST))
		{
			sMetaMagicIcon = JXMetaMagicGetFeatIcon(METAMAGIC_INVOC_HELLRIME_BLAST);
			iMetaMagicName = JXMetaMagicGetFeatName(METAMAGIC_INVOC_HELLRIME_BLAST);
			SetGUIObjectDisabled(oPC, JX_SCREEN_SPELLS_QUICK, "btnMetaMagic" + IntToString(iButtonMetaMagic), FALSE);
			SetGUITexture(oPC, JX_SCREEN_SPELLS_QUICK, "btnMetaMagic" + IntToString(iButtonMetaMagic), sMetaMagicIcon);
			SetLocalGUIVariable(oPC, JX_SCREEN_SPELLS_QUICK, 1010 + iButtonMetaMagic, GetStringByStrRef(iMetaMagicName));
			iButtonMetaMagic++;
		}
		if (JXSpellsKnownContainsSpell(spellsKnown, SPELL_I_BEWITCHING_BLAST))
		{
			sMetaMagicIcon = JXMetaMagicGetFeatIcon(METAMAGIC_INVOC_BEWITCHING_BLAST);
			iMetaMagicName = JXMetaMagicGetFeatName(METAMAGIC_INVOC_BEWITCHING_BLAST);
			SetGUIObjectDisabled(oPC, JX_SCREEN_SPELLS_QUICK, "btnMetaMagic" + IntToString(iButtonMetaMagic), FALSE);
			SetGUITexture(oPC, JX_SCREEN_SPELLS_QUICK, "btnMetaMagic" + IntToString(iButtonMetaMagic), sMetaMagicIcon);
			SetLocalGUIVariable(oPC, JX_SCREEN_SPELLS_QUICK, 1010 + iButtonMetaMagic, GetStringByStrRef(iMetaMagicName));
			iButtonMetaMagic++;
		}
		if (JXSpellsKnownContainsSpell(spellsKnown, SPELL_I_NOXIOUS_BLAST))
		{
			sMetaMagicIcon = JXMetaMagicGetFeatIcon(METAMAGIC_INVOC_NOXIOUS_BLAST);
			iMetaMagicName = JXMetaMagicGetFeatName(METAMAGIC_INVOC_NOXIOUS_BLAST);
			SetGUIObjectDisabled(oPC, JX_SCREEN_SPELLS_QUICK, "btnMetaMagic" + IntToString(iButtonMetaMagic), FALSE);
			SetGUITexture(oPC, JX_SCREEN_SPELLS_QUICK, "btnMetaMagic" + IntToString(iButtonMetaMagic), sMetaMagicIcon);
			SetLocalGUIVariable(oPC, JX_SCREEN_SPELLS_QUICK, 1010 + iButtonMetaMagic, GetStringByStrRef(iMetaMagicName));
			iButtonMetaMagic++;
		}
		if (JXSpellsKnownContainsSpell(spellsKnown, SPELL_I_VITRIOLIC_BLAST))
		{
			sMetaMagicIcon = JXMetaMagicGetFeatIcon(METAMAGIC_INVOC_VITRIOLIC_BLAST);
			iMetaMagicName = JXMetaMagicGetFeatName(METAMAGIC_INVOC_VITRIOLIC_BLAST);
			SetGUIObjectDisabled(oPC, JX_SCREEN_SPELLS_QUICK, "btnMetaMagic" + IntToString(iButtonMetaMagic), FALSE);
			SetGUITexture(oPC, JX_SCREEN_SPELLS_QUICK, "btnMetaMagic" + IntToString(iButtonMetaMagic), sMetaMagicIcon);
			SetLocalGUIVariable(oPC, JX_SCREEN_SPELLS_QUICK, 1010 + iButtonMetaMagic, GetStringByStrRef(iMetaMagicName));
			iButtonMetaMagic++;
		}
		if (JXSpellsKnownContainsSpell(spellsKnown, SPELL_I_UTTERDARK_BLAST))
		{
			sMetaMagicIcon = JXMetaMagicGetFeatIcon(METAMAGIC_INVOC_UTTERDARK_BLAST);
			iMetaMagicName = JXMetaMagicGetFeatName(METAMAGIC_INVOC_UTTERDARK_BLAST);
			SetGUIObjectDisabled(oPC, JX_SCREEN_SPELLS_QUICK, "btnMetaMagic" + IntToString(iButtonMetaMagic), FALSE);
			SetGUITexture(oPC, JX_SCREEN_SPELLS_QUICK, "btnMetaMagic" + IntToString(iButtonMetaMagic), sMetaMagicIcon);
			SetLocalGUIVariable(oPC, JX_SCREEN_SPELLS_QUICK, 1010 + iButtonMetaMagic, GetStringByStrRef(iMetaMagicName));
			iButtonMetaMagic++;
		}
		if (JXSpellsKnownContainsSpell(spellsKnown, 1130))	// Hindering blast
		{
			sMetaMagicIcon = JXMetaMagicGetFeatIcon(METAMAGIC_INVOC_HINDERING_BLAST);
			iMetaMagicName = JXMetaMagicGetFeatName(METAMAGIC_INVOC_HINDERING_BLAST);
			SetGUIObjectDisabled(oPC, JX_SCREEN_SPELLS_QUICK, "btnMetaMagic" + IntToString(iButtonMetaMagic), FALSE);
			SetGUITexture(oPC, JX_SCREEN_SPELLS_QUICK, "btnMetaMagic" + IntToString(iButtonMetaMagic), sMetaMagicIcon);
			SetLocalGUIVariable(oPC, JX_SCREEN_SPELLS_QUICK, 1010 + iButtonMetaMagic, GetStringByStrRef(iMetaMagicName));
			iButtonMetaMagic++;
		}
		if (JXSpellsKnownContainsSpell(spellsKnown, 1131))	// Binding blast
		{
			sMetaMagicIcon = JXMetaMagicGetFeatIcon(METAMAGIC_INVOC_BINDING_BLAST);
			iMetaMagicName = JXMetaMagicGetFeatName(METAMAGIC_INVOC_BINDING_BLAST);
			SetGUIObjectDisabled(oPC, JX_SCREEN_SPELLS_QUICK, "btnMetaMagic" + IntToString(iButtonMetaMagic), FALSE);
			SetGUITexture(oPC, JX_SCREEN_SPELLS_QUICK, "btnMetaMagic" + IntToString(iButtonMetaMagic), sMetaMagicIcon);
			SetLocalGUIVariable(oPC, JX_SCREEN_SPELLS_QUICK, 1010 + iButtonMetaMagic, GetStringByStrRef(iMetaMagicName));
			iButtonMetaMagic++;
		}
	}


	/****************************************************************************/
	/* Display the spells for the selected metamagic feat and the current class */
	/****************************************************************************/

	// Get the list of spells ready to be cast for the current class
	struct jx_spells_ready spellsReady = JXRestoreSpellsReady(oPC, iCurrentClass);
	// Keep the spells from this list associated with the selected metamagic feat
	struct jx_spells_ready spellsReadyMetaMagic = JXSpellsReadyGetByMetamagic(spellsReady, iCurrentMetaMagic);

	// Display the spell slots (delayed to avoid TMI error)
	DelayCommand(0.0, JXPrivateUpdateGUISpellQuick(oPC, spellsReadyMetaMagic, iCurrentClass));
}

// Update the GUI screen for quick spells (radial context menu) to reflect the current data
// - oPC Player character that chose a master spell in its list of spells ready to be cast
void JXUpdateGUISpellQuickRadial(object oPC)
{
	struct jx_subspells_ui subSpells = JXStringToSubSpellsUI(GetLocalString(oPC, JX_UI_SPELLS_SBSPL_CURRENTLIST));

	int iLoopSubSpell;
	for (iLoopSubSpell = 1; iLoopSubSpell <= 5; iLoopSubSpell++)
	{
		int iSubSpellId;
		switch (iLoopSubSpell)
		{
			case 1: iSubSpellId = subSpells.iSubSpellId1; break;
			case 2: iSubSpellId = subSpells.iSubSpellId2; break;
			case 3: iSubSpellId = subSpells.iSubSpellId3; break;
			case 4: iSubSpellId = subSpells.iSubSpellId4; break;
			case 5: iSubSpellId = subSpells.iSubSpellId5; break;
		}

		// Update the GUI sub-spell list
		if (iSubSpellId != -1)
		{
			string sSpellIcon = Get2DAString("spells", "IconResRef", iSubSpellId);
			int iSpellName = StringToInt(Get2DAString("spells", "Name", iSubSpellId));
			SetGUIObjectHidden(oPC, JX_SCREEN_SPELLS_QUICK, "btnRadialSpellText" + IntToString(iLoopSubSpell), FALSE);
			SetGUIObjectText(oPC, JX_SCREEN_SPELLS_QUICK, "btnRadialSpellText" + IntToString(iLoopSubSpell), iSpellName, "");

			// Get the spell properties
			int iTargetType = JXPrivateHexStringToInt(Get2DAString("spells", "TargetType", iSubSpellId));
			int iSpellTarget = StringToInt(Get2DAString("spells", "TargetingUI", iSubSpellId));
			if ((iSpellTarget == 3) || (iSpellTarget == 4) || (iSpellTarget == 5) || (iSpellTarget == 12) || (iSpellTarget == 16))
				iSpellTarget = 0;	// As cone and bolt target UI crash the game, assume a simple one
			int iHostile = StringToInt(Get2DAString("spells", "HostileSetting", iSubSpellId));

			// Show the "classic spell" button for the spell target and hide the others
			int iLoopTarget;
			for (iLoopTarget = 0; iLoopTarget < 20; iLoopTarget++)
			{
				int bHideButton = TRUE;
				if (iLoopTarget == iSpellTarget)
					bHideButton = FALSE;
				SetGUIObjectHidden(oPC, JX_SCREEN_SPELLS_QUICK, "btnRadialSpellIcon" + IntToString(iLoopSubSpell) +
								   "TG" + IntToString(iLoopTarget), bHideButton);
			}
			SetGUITexture(oPC, JX_SCREEN_SPELLS_QUICK, "btnRadialSpellIcon" + IntToString(iLoopSubSpell) +
							   "TG" + IntToString(iSpellTarget), sSpellIcon + ".tga");

			// Define the spell properties for the button
			string sTargetType = "";
			if (iTargetType & 1) sTargetType += "self,";
			if (iTargetType & 2) sTargetType += "creature,";
			if (iTargetType & 4) sTargetType += "ground,";
			if (iTargetType & 8) sTargetType += "item,";
			if (iTargetType & 16) sTargetType += "door,";
			if (iTargetType & 32) sTargetType += "placeable,";
			if (iTargetType & 64) sTargetType += "trigger,";
			sTargetType = GetStringLeft(sTargetType, GetStringLength(sTargetType) - 1);
			string sHostile = (iHostile == 1) ? "true" : "false";

			// Set the spell properties for the button
			int iVariableValue = 1000 + iLoopSubSpell * 2;
			SetLocalGUIVariable(oPC, JX_SCREEN_SPELLS_QUICK, iVariableValue, sTargetType);
			SetLocalGUIVariable(oPC, JX_SCREEN_SPELLS_QUICK, iVariableValue + 1, sHostile);
		}
		else
		{
			SetGUIObjectHidden(oPC, JX_SCREEN_SPELLS_QUICK, "btnRadialSpellIcon" + IntToString(iLoopSubSpell), TRUE);
			SetGUIObjectHidden(oPC, JX_SCREEN_SPELLS_QUICK, "btnRadialSpellText" + IntToString(iLoopSubSpell), TRUE);
		}
	}

	SetGUIObjectHidden(oPC, JX_SCREEN_SPELLS_QUICK, "panSpellRadial", FALSE);
}