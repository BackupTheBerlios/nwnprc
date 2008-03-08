//::///////////////////////////////////////////////
//:: JX Spellbook - Spells ready GUI screen event: close sub-spells menu
//:: gui_jx_spbk_spqck_closeradial
//:://////////////////////////////////////////////
//:://////////////////////////////////////////////
//:: Created By: jallaix
//:: Created On: Nov 20, 2007
//:://////////////////////////////////////////////
//
// This script is fired when a player closes the sub-spells
// context menu in the quick spells GUI screen.
// It simply hide the menu.
//
//:://////////////////////////////////////////////

#include "jx_inc_spbk_const"




void main()
{
	object oPC = OBJECT_SELF;

	SetGUIObjectHidden(oPC, JX_SCREEN_SPELLS_QUICK, "panSpellRadial", TRUE);
}