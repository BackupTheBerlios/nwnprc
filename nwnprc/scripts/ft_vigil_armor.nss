#include "x0_i0_petrify"
#include "prc_feat_const"
#include "inc_item_props"

void main()
{
	object oPC = OBJECT_SELF;
	if (GetHasFeat(FEAT_VIGIL_ARMOR, oPC)) {
		object oSkin = GetPCSkin(oPC);
		SetCompositeBonus(oSkin,"VigilantSkinBonus",2,ITEM_PROPERTY_AC_BONUS);
	}
}
