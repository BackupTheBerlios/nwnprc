#include "prc_feat_const"
#include "prc_spell_const"

void main()
{
int nRealFy = GetAppearanceType(OBJECT_SELF);
string sRealFyi= "realFyi";
SetLocalInt(OBJECT_SELF, sRealFyi, nRealFy + 1);
SetCreatureAppearanceType(OBJECT_SELF, APPEARANCE_TYPE_ELF_NPC_MALE_02);
}

