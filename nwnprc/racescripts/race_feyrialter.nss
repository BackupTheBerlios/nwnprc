void main()
{
int nRealMe = GetAppearanceType(OBJECT_SELF);
string sRealApp= "realApp";
SetLocalInt(OBJECT_SELF, sRealApp, nRealMe + 1);
SetCreatureAppearanceType(OBJECT_SELF, APPEARANCE_TYPE_ELF_NPC_MALE_02);
}

