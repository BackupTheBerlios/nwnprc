#include "prc_feat_const"
#include "prc_spell_const"

void main()
{
int nRealPx = GetAppearanceType(OBJECT_SELF);
string sRealPix= "realPix";
SetLocalInt(OBJECT_SELF, sRealPix, nRealPx + 1);
SetCreatureAppearanceType(OBJECT_SELF, APPEARANCE_TYPE_DEER);
}

