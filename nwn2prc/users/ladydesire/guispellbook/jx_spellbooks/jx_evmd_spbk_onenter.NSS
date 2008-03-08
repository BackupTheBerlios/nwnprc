#include "jx_inc_spbk_process_spsel"


void main()
{
	object oPC = GetEnteringObject();

	// Define the starting values for the GUI screens
	SetLocalInt(oPC, JX_UI_SPELLS_KNOWN_CURRENTCLASS, -1);
	SetLocalInt(oPC, JX_UI_SPELLS_KNOWN_CURRENTLEVEL, -1);
	SetLocalInt(oPC, JX_UI_SPELLS_QUICK_CURRENTCLASS, -1);
	SetLocalInt(oPC, JX_UI_SPELLS_QUICK_CURRENTMETAMAGIC, 0);

	// Load the GUI screens in memory as the player is entering the module.
	// These screens are very heavy, so the player may have to wait for several seconds
	DisplayGuiScreen(oPC, JX_SCREEN_SPELLS_KNOWN, FALSE,JX_XML_SPELLS_KNOWN);
	DisplayGuiScreen(oPC, JX_SCREEN_SPELLS_MEMORIZED, FALSE, JX_XML_SPELLS_MEMORIZED);
	DisplayGuiScreen(oPC, JX_SCREEN_SPELLS_QUICK, FALSE, JX_XML_SPELLS_QUICK);
	CloseGUIScreen(oPC, JX_SCREEN_SPELLS_KNOWN);
	CloseGUIScreen(oPC, JX_SCREEN_SPELLS_MEMORIZED);
	CloseGUIScreen(oPC, JX_SCREEN_SPELLS_QUICK);

	// Update the spellbooks for the PC if necessary
	JXCheckSpellbooksToUpdate(oPC);
}