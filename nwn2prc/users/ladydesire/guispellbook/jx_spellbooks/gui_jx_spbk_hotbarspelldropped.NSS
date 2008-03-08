#include "jx_inc_spbk_const"


void main(int iDataInt)
{
	object oPC = OBJECT_SELF;

	// Get the information about the UI object dropped
	string sOrigin = GetLocalString(oPC, JX_UI_MOUSESTARTDRAG);
	if (sOrigin == "") return;

	// Invalidate the drag & drop process
	DeleteLocalString(oPC, JX_UI_MOUSESTARTDRAG);

	// The object dropped is a spell known
	if (GetStringLeft(sOrigin, 14) == "JX_SPELL_KNOWN")
	{
		SetGUIObjectHidden(oPC, "SCREEN_HOTBAR_2", "btnHotbarOverride_" + IntToString(iDataInt), FALSE);
		SetGUITexture(oPC, "SCREEN_HOTBAR_2", "btnHotbarOverride_" + IntToString(iDataInt), "is_findtraps.tga");
	}

	// The object dropped is a spell memorized
	if (GetStringLeft(sOrigin, 13) == "JX_SPELL_MEMO")
	{
		SetGUIObjectHidden(oPC, "SCREEN_HOTBAR_2", "btnHotbarOverride_" + IntToString(iDataInt), FALSE);
		SetGUITexture(oPC, "SCREEN_HOTBAR_2", "btnHotbarOverride_" + IntToString(iDataInt), "is_findtraps.tga");
	}

	// The object dropped is a spell memorized
	if (GetStringLeft(sOrigin, 14) == "JX_SPELL_QUICK")
	{
		SetGUIObjectHidden(oPC, "SCREEN_HOTBAR_2", "btnHotbarOverride_" + IntToString(iDataInt), FALSE);
		SetGUITexture(oPC, "SCREEN_HOTBAR_2", "btnHotbarOverride_" + IntToString(iDataInt), "is_findtraps.tga");
	}
}