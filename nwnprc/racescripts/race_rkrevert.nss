#include "prc_feat_const"
#include "prc_spell_const"

void main()
{
string sRealApp = "realApp";
int nRealMe;
nRealMe = GetLocalInt(OBJECT_SELF, sRealApp);
if ( nRealMe > 0 )
  SetCreatureAppearanceType(OBJECT_SELF, nRealMe - 1);
}
