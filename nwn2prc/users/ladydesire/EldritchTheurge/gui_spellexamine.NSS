void main(int nSpellID)
{
	int Name = StringToInt(Get2DAString("spells","Name", nSpellID));
	int Description = StringToInt(Get2DAString("spells","SpellDesc", nSpellID));
	
	DisplayGuiScreen(OBJECT_SELF,"SCREEN_EXAMINE",FALSE,"");
	SetGUIObjectText(OBJECT_SELF,"SCREEN_EXAMINE","EXAMINE_NAME_TEXT",Name,"");
	SetGUIObjectText(OBJECT_SELF,"SCREEN_EXAMINE","EXAMINE_DESCRIPTION_TEXT",Description,"");
}