void main()
{
string sRealPix = "realPix";
int nRealPx;
nRealPx = GetLocalInt(OBJECT_SELF, sRealPix);
if ( nRealPx > 0 )
  SetCreatureAppearanceType(OBJECT_SELF, nRealPx - 1);
}
