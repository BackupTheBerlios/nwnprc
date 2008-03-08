//::///////////////////////////////////////////////
//:: JX Spellbook - Spells known GUI screen event: choose spell level
//:: gui_jx_spbk_spkwn_level
//:://////////////////////////////////////////////
//:://////////////////////////////////////////////
//:: Created By: jallaix
//:: Created On: Nov 14, 2007
//:://////////////////////////////////////////////
//
// This script is fired when a player chooses a spell level.
//
//:://////////////////////////////////////////////

#include "jx_inc_spbk_process_spkwn"




void main(string sSpellLevel)
{
	object oPC = OBJECT_SELF;

	// Get the current spell level and save the new one
	int iSpellLevel = StringToInt(GetSubString(sSpellLevel, 6, 2));
	SetLocalInt(oPC, JX_UI_SPELLS_KNOWN_CURRENTLEVEL, iSpellLevel);

	// Display the list of known spells
	JXUpdateGUISpellKnown(oPC);
}