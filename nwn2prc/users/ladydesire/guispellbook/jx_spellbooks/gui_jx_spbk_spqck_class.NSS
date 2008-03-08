//::///////////////////////////////////////////////
//:: JX Spellbook - Spells ready GUI screen event: choose class
//:: gui_jx_spbk_spqck_class
//:://////////////////////////////////////////////
//:://////////////////////////////////////////////
//:: Created By: jallaix
//:: Created On: Nov 16, 2007
//:://////////////////////////////////////////////
//
// This script is fired when a player selects a class in
// the quick spells GUI screen.
// It updates this screen depending on the class selected.
//
//:://////////////////////////////////////////////

#include "jx_inc_spbk_process_sprdy"




void main(string sDataString)
{
	object oPC = OBJECT_SELF;

	int iClassPositionUIChosen = StringToInt(JXStringSplit(sDataString, "_", 2));

	int iClassPositionUI = 1;
	int iLoopClassPosition;
	for (iLoopClassPosition = 1; iLoopClassPosition <= 4; iLoopClassPosition++)
	{
		// Get the class for the current position
		int iClass = GetClassByPosition(iLoopClassPosition, oPC);
		// Spellbook defined for the class
		if (JXGetHasSpellbook(oPC, iClass))
		{
			if (iClassPositionUI == iClassPositionUIChosen)
			{
				SetLocalInt(oPC, JX_UI_SPELLS_QUICK_CURRENTCLASS, iClass);
				break;
			}
			iClassPositionUI++;
		}
	}

	// Update the quick spells GUI screen
	JXUpdateGUISpellQuick(oPC);
}