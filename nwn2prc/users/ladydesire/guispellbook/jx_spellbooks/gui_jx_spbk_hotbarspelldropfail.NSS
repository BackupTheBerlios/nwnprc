void main(int iDataInt)
{
	SendMessageToPC(OBJECT_SELF, "fail");
	SetGUIObjectHidden(OBJECT_SELF, "SCREEN_HOTBAR_2", "btnHotbarOverride_" + IntToString(iDataInt), TRUE);
	SetGUITexture(OBJECT_SELF, "SCREEN_HOTBAR_2", "btnHotbarOverride_" + IntToString(iDataInt), "b_hotbar_secondary.tga");
}