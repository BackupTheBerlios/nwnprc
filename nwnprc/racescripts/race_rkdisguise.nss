#include "prc_feat_const"
#include "prc_spell_const"

void main()
{
int nRealMe = GetAppearanceType(OBJECT_SELF);
string sRealApp= "realApp";
SetLocalInt(OBJECT_SELF, sRealApp, nRealMe + 1);
SetCreatureAppearanceType(OBJECT_SELF, APPEARANCE_TYPE_HUMAN_NPC_FEMALE_12);
}

