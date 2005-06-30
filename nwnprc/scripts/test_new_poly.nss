#include "inc_prc_poly"

void main()
{
	if (GetIsPC(OBJECT_SELF))
	{
		PRC_Polymorph_ResRef(OBJECT_SELF, "nw_demon", TRUE);
	}
}