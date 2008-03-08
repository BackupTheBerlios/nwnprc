//::///////////////////////////////////////////////
//:: JX Spellbook - Spells ready GUI screen event: open sub-spells menu
//:: gui_jx_spbk_spqck_openradial
//:://////////////////////////////////////////////
//:://////////////////////////////////////////////
//:: Created By: jallaix
//:: Created On: Nov 20, 2007
//:://////////////////////////////////////////////
//
// This script is fired when a player chooses a master
// spell in the quick spells GUI screen.
// It opens the sub-spells context menu that contains
// the sub-spells for the master spell.
//
//:://////////////////////////////////////////////

#include "jx_inc_spbk_process_sprdy"




void main(string sDataString)
{
	object oPC = OBJECT_SELF;

	int iCurrentClass = GetLocalInt(oPC, JX_UI_SPELLS_QUICK_CURRENTCLASS);

	// Get informations from the button clicked
	int iSpellLevel;
	int iSpellSlot;
	if (GetStringLeft(sDataString, 21) == "JX_SPELL_RADIAL_QUICK")
	{
		iSpellLevel = StringToInt(JXStringSplit(sDataString, "_", 4));
		iSpellSlot = StringToInt(JXStringSplit(sDataString, "_", 5));
	}
	else
		SendMessageToPC(oPC, "BUG : unknown behaviour in gui_jx_spbk_radialspell.nss");

	// Get informations about the spell to cast
	struct jx_spells_ready spellsReady = JXRestoreSpellsReady(oPC, iCurrentClass);
	struct jx_spell_ready masterSpell = JXSpellsReadyGetSpell(spellsReady, iSpellLevel, iSpellSlot);

	// Get informations about the sub-spells
	string sSubSpellId1 = Get2DAString("spells", "SubRadSpell1", masterSpell.iSpellId);
	string sSubSpellId2 = Get2DAString("spells", "SubRadSpell2", masterSpell.iSpellId);
	string sSubSpellId3 = Get2DAString("spells", "SubRadSpell3", masterSpell.iSpellId);
	string sSubSpellId4 = Get2DAString("spells", "SubRadSpell4", masterSpell.iSpellId);
	string sSubSpellId5 = Get2DAString("spells", "SubRadSpell5", masterSpell.iSpellId);
	int iSubSpellId1 = (sSubSpellId1 == "") ? -1 : StringToInt(sSubSpellId1);
	int iSubSpellId2 = (sSubSpellId2 == "") ? -1 : StringToInt(sSubSpellId2);
	int iSubSpellId3 = (sSubSpellId3 == "") ? -1 : StringToInt(sSubSpellId3);
	int iSubSpellId4 = (sSubSpellId4 == "") ? -1 : StringToInt(sSubSpellId4);
	int iSubSpellId5 = (sSubSpellId5 == "") ? -1 : StringToInt(sSubSpellId5);

	// Define and save the list of sub-spells for the UI
	struct jx_subspells_ui subSpells = JXSubSpellsUIGetSubSpells(masterSpell,
	 iSubSpellId1, iSubSpellId2, iSubSpellId3, iSubSpellId4, iSubSpellId5);
	SetLocalString(oPC, JX_UI_SPELLS_SBSPL_CURRENTLIST, JXSubSpellsUIToString(subSpells));

	// Update the sub-spells context menu
	JXUpdateGUISpellQuickRadial(oPC);
}