#include "prc_feat_const"
#include "prc_spell_const"

void main()
{
string sRealFyi = "realFyi";
int nRealFy;
nRealFy = GetLocalInt(OBJECT_SELF, sRealFyi);
if ( nRealFy > 0 )
  SetCreatureAppearanceType(OBJECT_SELF, nRealFy - 1);
}
